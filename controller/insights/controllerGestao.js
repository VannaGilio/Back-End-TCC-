const InsightDAO = require('../../model/DAO/insights/insightsDAO.js');
// Biblioteca para comunicação com a Azure OpenAI
const OpenAI = require('openai'); 
const message = require('../../modulo/config.js'); 

// --- CONFIGURAÇÃO DA AZURE OPENAI (CRÍTICO) ---
// O Controller carrega as variáveis de ambiente que você configurou no .env
const AZURE_OPENAI_ENDPOINT = process.env.AZURE_OPENAI_ENDPOINT;
const AZURE_OPENAI_API_KEY = process.env.AZURE_OPENAI_API_KEY;
const AZURE_OPENAI_DEPLOYMENT_NAME = process.env.AZURE_OPENAI_DEPLOYMENT_NAME; 

// Inicializa o cliente OpenAI configurado para o Azure
const openai = new OpenAI({
    apiKey: AZURE_OPENAI_API_KEY,
    // MUDANÇA CRÍTICA: Use o bloco 'azure' para configurar o endpoint e deployment.
    azure: {
        endpoint: AZURE_OPENAI_ENDPOINT, 
        deployment: AZURE_OPENAI_DEPLOYMENT_NAME,
        apiVersion: '2024-02-15-preview', // Versão da API do Azure
    },
});

// --- FUNÇÃO 1: PROMPT PARA NÍVEL DE ACESSO 'ALUNO' (Análise Individual) ---
/**
 * Formata os dados de desempenho de UM ALUNO em um Prompt.
 * @param {object} desempenho - O JSON de desempenho de um único aluno (desempenho[0]).
 * @returns {object} Um objeto contendo systemPrompt e userPrompt.
 */
const buildAlunoInsightPrompt = (desempenho) => {
    // CORREÇÃO: Usando a estrutura do seu JSON
    const nomeAluno = desempenho.aluno.nome || `Aluno ID ${desempenho.aluno.id_aluno}`;

    // Formata a lista de atividades para a IA
    const atividadesFormatadas = desempenho.atividades.map(a => 
        // CORREÇÃO: Usando 'atividade' e 'nota' do seu JSON
        ` - Atividade: ${a.atividade}, Categoria: ${a.categoria}, Nota: ${a.nota}`
    ).join('\n');

    const systemPrompt = `
        Você é o "Analytica AI", um assistente pedagógico sênior. Sua tarefa é analisar o desempenho de UM ALUNO e gerar um insight principal e sugestões, focando nos pontos que merecem atenção e reconhecendo os sucessos.

        A resposta DEVE ser um objeto JSON formatado e válido, SEMPRE seguindo o esquema abaixo. NÃO inclua nenhum texto, explicação ou formatação EXTRA (Markdown, HTML, etc) fora do JSON.

        --- ESQUEMA DE SAÍDA JSON ---
        {
          "titulo": "Resumo do Desempenho em [Matéria]",
          "conteudo": "Aqui vai a análise detalhada e as sugestões, com um tom profissional e encorajador, para o aluno. Máximo de 5 parágrafos curtos."
        }
        --- FIM DO ESQUEMA ---
    `;

    const userPrompt = `
        Analise os seguintes dados de ${nomeAluno} para a matéria de ${desempenho.materia.materia}:

        - Média Final: ${desempenho.media}
        - Frequência: ${desempenho.frequencia.porcentagem_frequencia} (${desempenho.frequencia.faltas} faltas)

        - Detalhe de Atividades (${desempenho.atividades.length} no total):
        ${atividadesFormatadas}

        **Regras de Análise:**
        1. Identifique as notas mais discrepantes (altas e baixas).
        2. Se a frequência for inferior a 75%, priorize a menção deste ponto.
    `;

    return { systemPrompt, userPrompt };
};

// --- FUNÇÃO 2: PROMPT PARA NÍVEL DE ACESSO 'PROFESSOR' / 'GESTAO' (Análise Agregada de Turma) ---
/**
 * Formata os dados de desempenho de MÚLTIPLOS ALUNOS em um Prompt (Análise de Turma).
 * @param {Array<object>} dadosTurma - O array de desempenho de todos os alunos da turma.
 * @param {string} tipoAcesso - Indica se é 'professor' ou 'gestao'.
 * @returns {object} Um objeto contendo systemPrompt e userPrompt.
 */
const buildAgregadoInsightPrompt = (dadosAgregados, tipoAcesso) => {
    // CORREÇÃO: Dados agregados (professor/gestão) vêm como um único objeto
    const desempenhoRef = dadosAgregados[0];
    
    // Identifica o responsável e o foco da análise
    let nomeResponsavel;
    let focoAnalise;

    if (tipoAcesso === 'professor') {
        nomeResponsavel = desempenhoRef.professor.nome || `Professor ID ${desempenhoRef.professor.id_professor}`;
        focoAnalise = `turma ${desempenhoRef.turma.turma}`;
    } else { // 'gestao'
        nomeResponsavel = desempenhoRef.gestao.nome || `Gestor ID ${desempenhoRef.gestao.id_gestao}`;
        focoAnalise = `a situação agregada da turma ${desempenhoRef.turma.turma}`;
    }

    const materia = desempenhoRef.materia.materia;
    const mediaGeral = desempenhoRef.media;
    const freqGeral = desempenhoRef.frequencia.porcentagem_frequencia;

    // Constrói um resumo focado em métricas da turma (usando as atividades da turma como métricas)
    const atividadesResumo = desempenhoRef.atividades.map(a => 
        ` - Atividade: ${a.atividade} (Média: ${a.nota})`
    ).join('\n');

    const systemPrompt = `
        Você é o "Analytica AI", um assistente de coordenação pedagógica. Sua tarefa é analisar o desempenho AGREGADO de ${focoAnalise} para ${nomeResponsavel}. O foco deve ser em tendências de aprendizado, outliers (alunos em risco ou com excelência) e áreas da matéria que parecem estar com dificuldades. O tom deve ser profissional e de suporte.

        A resposta DEVE ser um objeto JSON formatado e válido, SEMPRE seguindo o esquema abaixo. NÃO inclua nenhum texto, explicação ou formatação EXTRA (Markdown, HTML, etc) fora do JSON.

        --- ESQUEMA DE SAÍDA JSON ---
        {
          "titulo": "Análise Agregada da Turma em [Matéria]",
          "conteudo": "Aqui vai a análise de desempenho, identificação de tendências, e sugestões de intervenção pedagógica para a turma. Máximo de 5 parágrafos curtos."
        }
        --- FIM DO ESQUEMA ---
    `;

    const userPrompt = `
        Analise a ${focoAnalise} na matéria de ${materia}.

        - Média Geral da Turma: ${mediaGeral}
        - Frequência Média: ${freqGeral} (${desempenhoRef.frequencia.faltas} faltas no total de ${desempenhoRef.frequencia.total_aulas} aulas)

        - Desempenho por Atividade (Notas Médias da Turma):
        ${atividadesResumo}

        **Regras de Análise:**
        1. Identifique as atividades com as notas médias mais baixas (pontos de atenção do conteúdo).
        2. Mencione a taxa de frequência e seu impacto no desempenho.
        3. Forneça sugestões de intervenção que o responsável (${tipoAcesso}) possa adotar.
    `;

    return { systemPrompt, userPrompt };
};

// --- FUNÇÃO DE CHAMADA GERAL À AZURE ---
/**
 * Chama a API da Azure para gerar o insight de forma assíncrona.
 * @param {object} body - O JSON completo do endpoint de desempenho.
 * @param {string} tipoInsight - O nível de acesso ('aluno', 'professor', 'gestao').
 * @param {string|number} idSemestre - ID do Semestre (obtido do query param da URL).
 * @param {string|number} idMateria - ID da Matéria (obtido do query param da URL).
 * @returns {Promise<{titulo: string, conteudo: string}>} O insight gerado (ou fallback em caso de erro).
 */
const generateInsightFromAI = async (body, tipoInsight, idSemestre, idMateria) => {
    let prompt;
    const dadosDesempenho = body.desempenho;

    // Seleciona o Prompt correto baseado no tipo de acesso/dado
    if (tipoInsight === 'aluno' && dadosDesempenho.length > 0) {
        // Aluno: usa a função de prompt individual
        prompt = buildAlunoInsightPrompt(dadosDesempenho[0]);
    } else if (tipoInsight === 'professor' || tipoInsight === 'gestao') {
        // Professor/Gestão: usa a função de prompt agregado
        prompt = buildAgregadoInsightPrompt(dadosDesempenho, tipoInsight);
    } else {
        throw new Error("Tipo de Insight ou Estrutura de Dados Inválida para Geração de IA.");
    }
    
    try {
        const completion = await openai.chat.completions.create({
            model: AZURE_OPENAI_DEPLOYMENT_NAME, 
            messages: [
                { role: "system", content: prompt.systemPrompt },
                { role: "user", content: prompt.userPrompt }
            ],
            temperature: 0.5, 
            response_format: { type: "json_object" },
        });

        const rawJsonText = completion.choices[0].message.content;
        return JSON.parse(rawJsonText);
        
    } catch (e) {
        console.error("[Controller] Erro na chamada à Azure OpenAI:", e);
        // Retorna um insight de fallback para não quebrar o front-end
        return {
            titulo: "Análise Indisponível",
            conteudo: "O serviço de IA não pôde processar a análise no momento. Por favor, tente novamente mais tarde. Verifique suas chaves de API e nome de deployment."
        };
    }
};


/**
 * Função principal chamada pela rota para gerar/obter o insight.
 * @param {object} body - O JSON de dados (desempenho, turma, etc.) enviado pelo front-end.
 * @param {string} tipoInsight - O nível de acesso ('aluno', 'professor', 'gestao').
 * @param {string|number} idSemestre - ID do Semestre (obtido do query param da URL).
 * @param {string|number} idMateria - ID da Matéria (obtido do query param da URL).
 * @returns {object} Retorna o JSON de resposta (status, message e o insight).
 */
const getInsight = async (body, tipoInsight, idSemestre, idMateria) => {
    // Importa o DAO aqui para evitar erro de dependência circular durante o carregamento dos módulos
    const InsightDAO = require('../../model/DAO/insights/insightsDAO.js');
    
    try {
        if (!body || !body.desempenho || body.desempenho.length === 0) {
            return message.ERROR_NO_DATA; 
        }
        
        const desempenhoData = body.desempenho[0]; // Pega o primeiro objeto para extrair chaves
        
        // --- 1. DEFINIÇÃO DA CHAVE DE CACHE (DAO) ---
        let idChave;
        if (tipoInsight === 'aluno') {
            // CORREÇÃO: Usando id_aluno
            idChave = desempenhoData.aluno.id_aluno; 
        } else if (tipoInsight === 'professor') {
            // CORREÇÃO: Usando id_professor
            idChave = desempenhoData.professor.id_professor; 
        } else if (tipoInsight === 'gestao') {
            // CORREÇÃO: Usando id_gestao
            idChave = desempenhoData.gestao.id_gestao; 
        } else {
             return message.ERROR_INVALID_ACCESS_LEVEL; 
        }
        
        // O ID da Matéria e Semestre devem vir como parâmetros
        const idMateriaCache = idMateria;
        const idSemestreCache = idSemestre;

        // 2. TENTAR BUSCAR NO CACHE (DAO)
        const cachedInsight = await InsightDAO.findInsightCache(idChave, tipoInsight, idMateriaCache, idSemestreCache);

        if (cachedInsight) {
            console.log(`Analytica AI: Insight (${tipoInsight}) retornado do Cache (DB).`);
            return {
                status_code: 200,
                message: "SUCCESS_INSIGHT_CACHE", 
                insight: {
                    titulo: cachedInsight.titulo,
                    conteudo: cachedInsight.conteudo
                }
            };
        }

        // 3. CACHE MISS: GERAR COM A IA (GASTO DE CRÉDITO)
        console.log(`Analytica AI: Gerando novo Insight (${tipoInsight}) via Azure OpenAI. Consumo de crédito.`);
        
        const newInsight = await generateInsightFromAI(body, tipoInsight, idSemestreCache, idMateriaCache);

        // 4. ARMAZENAR NO CACHE (DAO) - É executado em segundo plano (fire-and-forget)
        InsightDAO.insertInsightCache({
            idChave,
            tipoInsight,
            idMateria: idMateriaCache,
            idSemestre: idSemestreCache,
            titulo: newInsight.titulo,
            conteudo: newInsight.conteudo,
        }).catch(err => {
             console.warn("Falha ao salvar o insight no cache, mas o insight foi retornado ao usuário.", err);
        });
        
        // 5. RETORNAR O NOVO INSIGHT
        return {
            status_code: 200,
            message: "SUCCESS_INSIGHT_GENERATED", 
            insight: newInsight
        };

    } catch (error) {
        console.error(`[Controller] Erro FATAL no Controller de Insights para ${tipoInsight}:`, error);
        return message.ERROR_INTERNAL_SERVER_CONTROLLER; // 500
    }
}

module.exports = {
    getInsight
};
