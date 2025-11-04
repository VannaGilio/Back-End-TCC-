// controller/insightsController.js
import { AzureOpenAI } from "openai";
import insightsDAO from '../../model/DAO/insights/insightsDAO.js';
import message from '../../modulo/config.js';
import dotenv from 'dotenv';

dotenv.config();

// --- 1️⃣ CONFIGURAÇÃO AZURE OPENAI ---
const endpoint = process.env.AZURE_OPENAI_API_BASE;             // https://joao-mhhl54ba-eastus2.cognitiveservices.azure.com/
const deployment = process.env.AZURE_OPENAI_DEPLOYMENT_NAME;    // gpt-4o-analytica
const modelName = process.env.AZURE_OPENAI_MODEL_NAME;          // gpt-4o
const apiKey = process.env.AZURE_OPENAI_API_KEY;
const apiVersion = process.env.AZURE_OPENAI_API_VERSION;        // 2024-12-01-preview

// Inicializa o cliente AzureOpenAI
const client = new AzureOpenAI({
    endpoint,
    apiKey,
    deployment,
    apiVersion
});

// --- 2️⃣ FUNÇÃO DE GERAÇÃO DE PROMPT (AJUSTADA PARA CONTEÚDO CURTO) ---
const buildPrompt = (dashboardData, tipoInsight) => {
    const jsonString = JSON.stringify(dashboardData, null, 2);

    let role, focoAnalise;

    // Define a persona e o foco de acordo com o tipoInsight
    switch (tipoInsight) {
        case 'aluno':
            role = "um mentor de desempenho escolar focado em te guiar. Sua análise deve ser motivacional, construtiva e voltada para o crescimento individual. Use linguagem encorajadora.";
            focoAnalise = "Analise o desempenho individual (notas e frequência) em detalhe. Identifique pontos fortes e áreas específicas de melhoria (por exemplo, se a nota da prova foi melhor que a do trabalho).";
            break;

        case 'professor':
            role = "um analista de desempenho pedagógico especialista em tendências de turma. Seu objetivo é ajudar o professor a identificar padrões e planejar intervenções eficazes. Use linguagem técnica e focada em resultados de ensino.";
            focoAnalise = "Analise o desempenho geral da TURMA na matéria. Foque em métricas de frequência, média da turma, e o impacto de cada tipo de atividade (Prova vs. Trabalho) no resultado final. Sugira estratégias pedagógicas.";
            break;

        case 'gestao':
            role = "um consultor estratégico de educação para a gestão escolar. Seu objetivo é fornecer insights de alto nível sobre a performance da turma para apoiar a tomada de decisões administrativas e estratégicas. Use linguagem corporativa e baseada em indicadores.";
            focoAnalise = "Analise o desempenho da TURMA como um INDICADOR-CHAVE. Foque em identificar pontos de atenção que possam exigir intervenção da gestão, como baixa frequência média ou desequilíbrio significativo entre as médias de avaliações.";
            break;

        default:
            role = "um analista de dados generalista";
            focoAnalise = "Forneça uma análise básica dos dados.";
    }


    const systemPrompt = `Você é o Analytica AI, ${role}. Sua função é analisar detalhadamente o JSON de desempenho fornecido e gerar um insight construtivo e informativo.

${focoAnalise}

Regras de Formatação:
1. O resultado DEVE ser um objeto JSON válido, contendo SOMENTE as chaves 'titulo' e 'conteudo'.
2. O 'titulo' deve ser curto e chamativo (máximo 8 palavras).
3. O 'conteudo' DEVE ser um texto com no máximo 4 linhas. Mantenha-o extremamente conciso, direto ao ponto e sem quebras de linha que gerem parágrafos vazios.

Exemplo de Saída Esperada:
{
    "titulo": "Aproveitamento Sólido em Geometria",
    "conteudo": "Excelente domínio do conteúdo de álgebra e geometria, refletido em notas consistentemente altas nas provas. Manter o foco nas revisões semanais será crucial para finalizar o semestre com sucesso."
}`;

    const userPrompt = `Analise este JSON de desempenho e gere um insight de acordo com as regras:
${jsonString}`;

    return { systemPrompt, userPrompt };
};

// --- 3️⃣ FUNÇÃO DE CHAMADA À IA ---
const generateInsightFromAI = async (dashboardData, tipoInsight) => { // AGORA RECEBE tipoInsight
    console.log("Analytica AI: Gerando novo Insight via Azure OpenAI.");

    const { systemPrompt, userPrompt } = buildPrompt(dashboardData, tipoInsight);

    try {
        const response = await client.chat.completions.create({
            model: modelName,
            response_format: { type: "json_object" },
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: userPrompt }
            ],
            temperature: 0.5,
            max_tokens: 1000
        });

        const insightText = response.choices[0].message.content.trim();

        try {
            return JSON.parse(insightText);
        } catch (e) {
            console.error("[Controller] Falha ao parsear JSON da IA:", e);
            console.error("[Controller] Conteúdo bruto:", insightText);
            return {
                titulo: "Falha de Formatação da IA",
                conteudo: "A IA gerou o conteúdo, mas não seguiu o formato JSON esperado. Conteúdo bruto: " + insightText.substring(0, 500) + "..."
            };
        }
    } catch (error) {
        console.error("[Controller] Erro na chamada Azure OpenAI:", error);
        throw error;
    }
};

// --- 4️⃣ FUNÇÃO PRINCIPAL DO CONTROLLER (REFATORADA) ---
export const getInsight = async (dashboardData, tipoInsight, idSemestre, idMateria) => {
   try {
        // Pega o primeiro item do array de desempenho
        const firstItem = dashboardData.desempenho?.[0];

        // Variável para armazenar o ID da Turma (usado por Professor e Gestão)
        let finalIdTurma = null;
        let idChave;

        // --- 1. LÓGICA DE EXTRAÇÃO DA CHAVE DE CACHE E IDs ESPECÍFICOS ---
        if (tipoInsight === 'aluno') {
            idChave = firstItem?.aluno?.id_aluno;
            if (!idChave) {
                throw new Error("ID do Aluno ausente no JSON de desempenho (desempenho[0].aluno.id_aluno).");
            }
        
        } else if (tipoInsight === 'professor') {
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
        
        } else if (tipoInsight === 'gestao') {
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
            throw new Error(`'tipoInsight' desconhecido ou não implementado: ${tipoInsight}`);
        }
        // --- FIM DA LÓGICA DE EXTRAÇÃO ---

        // --- 2. VERIFICAÇÃO E EXTRAÇÃO DE idMateria/idSemestre ---
        let finalIdMateria = idMateria;
        let finalIdSemestre = idSemestre;

        // Se for professor, e idMateria não foi passado na URL, busca no JSON
        if (tipoInsight === 'professor' && !finalIdMateria) {
            const materiaIdFromData = firstItem?.materia?.materia_id;
            if (materiaIdFromData) {
                finalIdMateria = materiaIdFromData;
            }
        }

        if (tipoInsight === 'gestao' && !finalIdMateria) {
            const materiaIdFromData = firstItem?.materia?.id_materia;
            if (materiaIdFromData) {
                finalIdMateria = materiaIdFromData;
            }
        }
        
        // idMateria é obrigatório para todos, exceto se a Gestão estiver em um painel que não exige matéria específica.
        // Assumindo que o Aluno/Professor *sempre* olha uma matéria, e a Gestão, na maioria dos casos.
        if (!finalIdMateria || !finalIdSemestre) {
            throw new Error("Os IDs de Matéria e/ou Semestre são obrigatórios e devem ser passados como parâmetros.");
        }

        // --- 3. TENTA BUSCAR NO CACHE (INCLUINDO ID DA TURMA) ---
        // Prepara o ID da Turma para o cache (passa null/undefined para Aluno)
        const cacheIdTurma = (tipoInsight === 'professor' || tipoInsight === 'gestao') ? Number(finalIdTurma) : undefined;


        let insight = await insightsDAO.findInsightCache(
            idChave,
            tipoInsight,
            Number(finalIdMateria),
            Number(finalIdSemestre),
            cacheIdTurma // Novo parâmetro para Professor/Gestão
        );

        if (insight) {
            console.log("Analytica AI: Insight encontrado no cache.")

            const data = insight.data_geracao
            const dataFormatada = data.toLocaleDateString("pt-BR", {
                day: "2-digit",
                month: "2-digit",
                year: "numeric",
            });
            return {
                status_code: 200,
                message: message.SUCCESS_CREATED_ITEM.message,
                insight: {
                    titulo: insight.titulo,
                    conteudo: insight.conteudo,
                    data: dataFormatada,
                }
            };
        }

        // --- 4. GERAÇÃO E SALVAMENTO NO CACHE ---
        insight = await generateInsightFromAI(dashboardData, tipoInsight);

        // Salva no cache (Incluindo ID da Turma)
        await insightsDAO.insertInsightCache({
            idChave,
            tipoInsight,
            idMateria: Number(finalIdMateria),
            idSemestre: Number(finalIdSemestre),
            idTurma: cacheIdTurma, // Novo campo para Professor/Gestão
            titulo: insight.titulo,
            conteudo: insight.conteudo
        });

        return {
            status_code: 200,
            message: message.SUCCESS_CREATED_ITEM.message,
            insight
        };

    } catch (error) {
        console.error("[Controller] Erro FATAL:", error);
        return {
            status_code: 500,
            message: "Devido a erros internos no servidor da CONTROLLER, não foi possivel processar a requisição!!!",
            insight: {
                titulo: "Análise Indisponível",
                conteudo: "O serviço de IA não pôde processar a análise no momento. Detalhes: " + (error.message || "Erro desconhecido.")
            }
        };
    }
};