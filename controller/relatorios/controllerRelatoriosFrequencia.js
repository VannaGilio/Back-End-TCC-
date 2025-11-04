const { AzureOpenAI } = require("openai")
const relatoriosDAO = require('../../model/DAO/relatorios/relatoriosDAO.js')
const message = require('../../modulo/config.js')
const dotenv = require('dotenv')

dotenv.config();

// --- 1️⃣ CONFIGURAÇÃO AZURE OPENAI ---
const endpoint = process.env.AZURE_OPENAI_API_BASE; // https://joao-mhhl54ba-eastus2.cognitiveservices.azure.com/
const deployment = process.env.AZURE_OPENAI_DEPLOYMENT_NAME; // gpt-4o-analytica
const modelName = process.env.AZURE_OPENAI_MODEL_NAME; // gpt-4o
const apiKey = process.env.AZURE_OPENAI_API_KEY;
const apiVersion = process.env.AZURE_OPENAI_API_VERSION; // 2024-12-01-preview

// Inicializa o cliente AzureOpenAI
const client = new AzureOpenAI({
        endpoint,
        apiKey,
        deployment,
        apiVersion
});

// --- 2️⃣ FUNÇÃO DE GERAÇÃO DE PROMPT (AJUSTADA PARA CONTEÚDO CURTO) ---
const buildPrompt = (dashboardData, tipoNivel) => {

        console.log(">>> getRelatorio chamado. tipoNivel:", tipoNivel);
        console.log(">>> dashboardData.desempenho?.length:", dashboardData?.desempenho?.length);
        console.log(">>> idMateria (param):", idMateria, "idSemestre (param):", idSemestre);
        console.log(">>> firstItem:", JSON.stringify(dashboardData.desempenho?.[0] || {}, null, 2));
        const jsonString = JSON.stringify(dashboardData, null, 2);

        let role, focoAnalise;

        // Define a persona e o foco de acordo com o tipoNivel
        switch (tipoNivel) {                                                                                  
                case 'aluno':
                        role = "um mentor de desempenho escolar focado em te guiar. Sua análise deve ser motivacional, construtiva e voltada para o crescimento individual. Use linguagem encorajadora.";
                        focoAnalise = `
                        Analise o desempenho individual do aluno, com ênfase na frequência e no comprometimento geral. 
                        Identifique pontos fortes e áreas específicas de melhoria (por exemplo, se a frequência em Biologia foi maior que em Matemática). 
                        Gere um relatório textual curto e prático, com dados apresentados **em tabelas Markdown** (| coluna | coluna |). 
                        Cada seção deve conter uma tabela sempre que houver dados numéricos ou comparativos.
                        
                        Siga esta estrutura:

                        **Desempenho de Frequência**  
                        - Mostre uma tabela com frequência por disciplina.  
                        - Analise como a presença impacta o desempenho geral.  
                        - Acrescente uma observação motivacional sobre o comportamento do aluno.
                        `;

                        break;

                case 'professor':
                        role = "um analista de desempenho pedagógico especialista em tendências de turma. Seu objetivo é ajudar o professor a identificar padrões e planejar intervenções eficazes. Use linguagem técnica e focada em resultados de ensino.";
                        focoAnalise = "Analise o desempenho geral da TURMA na matéria. Foque em métricas de frequência, média da turma, e o impacto de cada tipo de atividade (Prova vs. Trabalho) no resultado final. Sugira estratégias pedagógicas.";
                        break;

                case 'gestao':
                        role = "um consultor estratégico de educação para a gestão escolar. Seu objetivo é fornecer relatorios de alto nível sobre a performance da turma para apoiar a tomada de decisões administrativas e estratégicas. Use linguagem corporativa e baseada em indicadores.";
                        focoAnalise = "Analise o desempenho da TURMA como um INDICADOR-CHAVE. Foque em identificar pontos de atenção que possam exigir intervenção da gestão, como baixa frequência média ou desequilíbrio significativo entre as médias de avaliações.";
                        break;

                default:
                        role = "um analista de dados generalista";
                        focoAnalise = "Forneça uma análise básica dos dados.";
        }


        const systemPrompt = `Você é o Analytica AI, ${role}. Sua função é analisar detalhadamente o JSON de desempenho fornecido e gerar um relatório construtivo e informativo.

        ${focoAnalise}

        Regras de Formatação:
        1. Sempre que possível, use **tabelas Markdown** para apresentar dados quantitativos, no formato:
           | Coluna | Coluna | Coluna |
           |---------|---------|---------|
           | Valor   | Valor   | Valor   |
        2. Use linguagem coerente com o papel definido no tipo de relatório (aluno = motivacional, professor = técnico, gestão = corporativa).
        3. O texto deve ser bem estruturado e legível, com parágrafos curtos, sem excesso de quebras de linha.
        4. Não retorne JSON, apenas texto puro com Markdown.
        
        Exemplo de saída esperada (estrutura simplificada):
        
        **Desempenho de Frequência**  
        | Disciplina  | Aulas Previstas | Aulas Assistidas | Faltas | Frequência |
        |--------------|-----------------|------------------|--------|------------|
        | Matemática   |        20       |        18        |    2   |     90%    |
        
        **Observação:** Excelente presença e bom engajamento geral, refletindo comprometimento nas aulas.
        `;

        const userPrompt = `Analise este JSON de desempenho e gere um relatório de frequência completo, seguindo as regras:
        ${jsonString}`;

        return { systemPrompt, userPrompt };
};

// --- 3️⃣ FUNÇÃO DE CHAMADA À IA ---
const generateRelatorioFromAI = async (dashboardData, tipoNivel) => { // AGORA RECEBE tipoNivel
        console.log("Analytica AI: Gerando novo Relatório via Azure OpenAI.");

        const { systemPrompt, userPrompt } = buildPrompt(dashboardData, tipoNivel);

        try {
                const response = await client.chat.completions.create({
                        model: modelName,
                        // response_format: { type: "json_object" },
                        messages: [
                                { role: "system", content: systemPrompt },
                                { role: "user", content: userPrompt }
                        ],
                        temperature: 0.5,
                        max_tokens: 1000
                });

                const relatorioText = response.choices[0].message.content.trim();

                try {
                        return JSON.parse(relatorioText);
                } catch (e) {
                        console.error("[Controller] Falha ao parsear JSON da IA:", e);
                        console.error("[Controller] Conteúdo bruto:", relatorioText);
                        return {
                                titulo: "Falha de Formatação da IA",
                                conteudo: "A IA gerou o conteúdo, mas não seguiu o formato JSON esperado. Conteúdo bruto: " + relatorioText.substring(0, 500) + "..."
                        };
                }
        } catch (error) {
                console.error("[Controller] Erro na chamada Azure OpenAI:", error);
                throw error;
        }
};

// --- 4️⃣ FUNÇÃO PRINCIPAL DO CONTROLLER (REFATORADA) ---
const getRelatorio = async (dashboardData, tipoNivel, tipoRelatorio, idSemestre, idMateria) => {
        try {
                // Pega o primeiro item do array de desempenho
                const firstItem = dashboardData.desempenho?.[0];

                // Variável para armazenar o ID da Turma (usado por Professor e Gestão)
                let finalIdTurma = null;
                let idChave;

                // --- 1. LÓGICA DE EXTRAÇÃO DA CHAVE DE CACHE E IDs ESPECÍFICOS ---
                if (tipoNivel === 'aluno') {
                        idChave = firstItem?.aluno?.id_aluno;
                        if (!idChave) {
                                throw new Error("ID do Aluno ausente no JSON de desempenho (desempenho[0].aluno.id_aluno).");
                        }

                } else if (tipoNivel === 'professor') {
                        // Busca o ID do Professor
                        idChave = firstItem?.professor?.id_professor;
                        if (!idChave) {
                                throw new Error("ID do Professor ausente no JSON de desempenho (desempenho[0].professor.id_professor).");
                        }

                        // Busca o ID da Turma (Obrigatório para o Professor)
                        finalIdTurma = firstItem?.turma?.id_turma;
                        if (!finalIdTurma) {
                                throw new Error("ID da Turma ausente no JSON de desempenho (desempenho[0].turma.id_turma) para o Professor.");
                        }

                } else if (tipoNivel === 'gestao') {
                        // Busca o ID da Gestão
                        idChave = firstItem?.gestao?.id_gestao;
                        if (!idChave) {
                                throw new Error("ID da Gestão ausente no JSON de desempenho (desempenho[0].gestao.id_gestao).");
                        }

                        // Busca o ID da Turma (Obrigatório para a Gestão, pois a análise é por turma)
                        finalIdTurma = firstItem?.turma?.id_turma;
                        if (!finalIdTurma) {
                                throw new Error("ID da Turma ausente no JSON de desempenho (desempenho[0].turma.id_turma) para a Gestão.");
                        }

                } else {
                        throw new Error(`'tipoNivel' desconhecido ou não implementado: ${tipoNivel}`);
                }
                // --- FIM DA LÓGICA DE EXTRAÇÃO ---

                // --- 2. VERIFICAÇÃO E EXTRAÇÃO DE idMateria/idSemestre ---
                // let finalIdMateria = idMateria;
                // let finalIdSemestre = idSemestre;
                console.log(">>> Antes da conversão:", idMateria, idSemestre);
                let finalIdMateria = Number(idMateria);
                let finalIdSemestre = Number(idSemestre);
                console.log(">>> Depois da conversão:", finalIdMateria, finalIdSemestre);
        

                // Se for professor, e idMateria não foi passado na URL, busca no JSON
                if (tipoNivel === 'professor' && !finalIdMateria) {
                        const materiaIdFromData = firstItem?.materia?.materia_id;
                        if (materiaIdFromData) {
                                finalIdMateria = materiaIdFromData;
                        }
                }

                if (tipoNivel === 'gestao' && !finalIdMateria) {
                        const materiaIdFromData = firstItem?.materia?.id_materia;
                        if (materiaIdFromData) {
                                finalIdMateria = materiaIdFromData;
                        }
                }

                // idMateria é obrigatório para todos, exceto se a Gestão estiver em um painel que não exige matéria específica.
                // Assumindo que o Aluno/Professor *sempre* olha uma matéria, e a Gestão, na maioria dos casos.
                if (!finalIdMateria || !finalIdSemestre) {
                        console.error("ERRO: finalIdMateria ou finalIdSemestre ausente");
                        console.error({ finalIdMateria, finalIdSemestre });
                        throw new Error("Os IDs de Matéria e/ou Semestre são obrigatórios e devem ser passados como parâmetros.");
                }                      

                // --- 3. TENTA BUSCAR NO CACHE (INCLUINDO ID DA TURMA) ---
                // Prepara o ID da Turma para o cache (passa null/undefined para Aluno)
                const cacheIdTurma = (tipoNivel === 'professor' || tipoNivel === 'gestao') ? Number(finalIdTurma) : undefined;


                let relatorio = await relatoriosDAO.findRelatorioCache(
                        idChave,
                        tipoNivel,
                        tipoRelatorio,
                        Number(finalIdMateria),
                        Number(finalIdSemestre),
                        cacheIdTurma // Novo parâmetro para Professor/Gestão
                );

                if (relatorio) {
                        console.log("Analytica AI: Relatório encontrado no cache.");
                        return {
                                status_code: 200,
                                message: message.SUCCESS_CREATED_ITEM.message,
                                relatorio: {
                                        link: relatorio.link
                                }
                        };
                }

                // --- 4. GERAÇÃO E SALVAMENTO NO CACHE ---
                relatorio = await generateRelatorioFromAI(dashboardData, tipoNivel);

                // --- 4️⃣ GERAÇÃO E SALVAMENTO NO CACHE ---
                const { linkPDF } = await generateRelatorioFromAI(dashboardData, tipoNivel);

                // Salva no cache (Incluindo ID da Turma)
                await relatoriosDAO.insertRelatorioCache({
                        idChave,
                        tipoNivel,
                        tipoRelatorio: "frequência",
                        idMateria: Number(finalIdMateria),
                        idSemestre: Number(finalIdSemestre),
                        idTurma: cacheIdTurma, // Novo campo para Professor/Gestão
                        link: linkPDF
                });

                return {
                        status_code: 200,
                        message: message.SUCCESS_CREATED_ITEM.message,
                        relatorio: {
                                link: linkPDF
                        }
                };

        } catch (error) {
                console.error("[Controller] Erro FATAL:", error);
                return {
                        status_code: 500,
                        message: "Devido a erros internos no servidor da CONTROLLER, não foi possivel processar a requisição!!!",
                        relatorio: {
                                titulo: "Análise Indisponível",
                                conteudo: "O serviço de IA não pôde processar a análise no momento. Detalhes: " + (error.message || "Erro desconhecido.")
                        }
                };
        }
};

module.exports = {
        generateRelatorioFromAI,
        getRelatorio
}