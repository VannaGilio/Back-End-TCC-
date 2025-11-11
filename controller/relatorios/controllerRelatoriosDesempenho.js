const { AzureOpenAI } = require("openai")
const relatoriosDAO = require('../../model/DAO/relatorios/relatoriosDAO.js')
const message = require('../../modulo/config.js')
const dotenv = require('dotenv')
const { gerarPDF } = require('../../utils/gerarPDF.js');

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

    const jsonString = JSON.stringify(dashboardData, null, 2);

    let role, focoAnalise;

    // Define a persona e o foco de acordo com o tipoNivel
    switch (tipoNivel) {
        case 'aluno':
            role = "um mentor de desempenho escolar focado em te guiar. Sua análise deve ser motivacional, construtiva e voltada para o crescimento individual. Use linguagem encorajadora.";

            focoAnalise = `
                          Você é um analista educacional especializado em gerar relatórios técnicos para professores.
                                Seu objetivo é transformar os dados enviados no body da requisição em um relatório claro,
                                objetivo, técnico e focado em acompanhamento pedagógico.

                                ### 1. Identificação
                                Inclua:
                                - Nome do aluno (se disponível)
                                - Turma (se existir)
                                - Disciplina

                                ### 2. Indicadores globais
                                Utilize apenas dados de desempenho.  
                                Classificação:
                                - ✅ ≥ 8,0 — Desempenho estável  
                                - ⚠️ 7,5 a 7,9 — Zona de atenção  
                                - ❌ 7 — Limite mínimo legal  
                                - 🔥 < 6,9 — Indicador crítico, risco regulatório

                                ### 2. Desempenho Acadêmico
                                Gere uma **tabela Markdown** com as atividades avaliadas:
                                | Atividade | Categoria | Nota | Descrição |
                                |------------|------------|------|------------|

                                Depois da tabela, faça uma breve análise:
                                - Destaque os **pontos fortes** (ex.: bom desempenho em provas ou consistência nas atividades).  
                                - Aponte **áreas de melhoria** (ex.: trabalhos com notas mais baixas ou falta de regularidade).  
                                - Comente sobre a **média geral** e o que ela indica sobre o desempenho atual.

                                ### 3. Conclusão Motivacional
                                Termine com uma mensagem positiva e encorajadora,
                                sugerindo **ações simples e realistas** para que o aluno melhore nas próximas avaliações.  
                                Use um tom humano, leve e inspirador.

                                **Importante:**  
                                - Não incluir frequência. 
                        `;


            break;

        case 'professor':
            role = "um analista de desempenho pedagógico especialista em tendências de turma. Seu objetivo é ajudar o professor a identificar padrões e planejar intervenções eficazes. Use linguagem técnica e focada em resultados de ensino.";
            focoAnalise = `
                                Gere um relatório técnico e sintético sobre o **desempenho acadêmico** dos alunos na disciplina analisada.  

                                ### 1. Identificação
                                Inclua:
                                - Nome do Professor
                                - Turma
                                - Disciplina

                                ### 2. Indicadores globais
                                Utilize apenas dados de desempenho.  
                                Classificação:
                                - ✅ ≥ 8,0 — Desempenho estável  
                                - ⚠️ 7,5 a 7,9 — Zona de atenção  
                                - ❌ 7 — Limite mínimo legal  
                                - 🔥 < 6,9 — Indicador crítico, risco regulatório

                                ### 2. Análise do Desempenho
                                Gere uma **tabela Markdown**:
                                | Atividade | Categoria | Nota Média | Descrição |
                                |------------|------------|-------------|------------|

                                Depois da tabela, faça uma interpretação objetiva:
                                - Identifique **tendências gerais** (ex.: notas altas em provas, desempenho inferior em trabalhos).  
                                - Aponte **padrões** que indiquem necessidade de reforço ou revisão de conteúdo.  
                                - Sugira **ações pedagógicas** (ex.: reforçar temas específicos, variar metodologias, reavaliar critérios de avaliação).

                                ### 3. Conclusão Técnica
                                Finalize com uma síntese curta, destacando:
                                - Conclusão geral sobre o aproveitamento da turma.
                                - Observações para planejamento futuro.
                                Use linguagem profissional e centrada em resultados.

                                **Importante:**  
                                - Não incluir frequência. 
                        `;
            break;

        case 'gestao':
            role = "um consultor estratégico de educação para a gestão escolar. Seu objetivo é fornecer relatorios de alto nível sobre a performance da turma para apoiar a tomada de decisões administrativas e estratégicas. Use linguagem corporativa e baseada em indicadores.";
            focoAnalise = `
                                Gere um **relatório institucional** baseado nos dados do JSON recebido.  
                                Foque apenas no **desempenho acadêmico** (notas, médias e atividades), sem abordar frequência ou comportamento.
                
                                1. Identificação (obrigatório)
                                - Turma analisada
                                - Disciplina
                                - Período / semestre
                                - Responsável pelo relatório (professor ou sistema)
                
                                ### 2. Indicadores globais
                                Utilize apenas dados de desempenho.  
                                Classificação:
                                - ✅ ≥ 8,0 — Desempenho estável  
                                - ⚠️ 7,5 a 7,9 — Zona de atenção  
                                - ❌ 7 — Limite mínimo legal  
                                - 🔥 < 6,9 — Indicador crítico, risco regulatório
                
                                Gere uma **tabela Markdown** com as principais atividades:
                                | Atividade | Categoria | Média da Turma | Descrição |
                                |------------|------------|----------------|------------|

                                ### 3. Análise Gerencial
                                Destaque:
                                - Tendências de notas (ex.: melhoria ou queda ao longo do período)  
                                - Pontos de atenção pedagógica (ex.: baixa média em determinado tipo de atividade)  
                                - Impacto dos resultados nas metas institucionais  
                                - Recomendações de acompanhamento ou reforço pedagógico

                                **Importante:**  
                                - Não incluir frequência, comportamento ou nomes de alunos.  
                                - Linguagem formal e objetiva, com foco em indicadores e decisões estratégicas.`;
            break;

        default:
            role = "um analista de dados generalista";
            focoAnalise = "Forneça uma análise básica dos dados.";
    }


    const systemPrompt = `Você é o Analytica AI, ${role}. Sua função é analisar detalhadamente o JSON de desempenho fornecido e gerar um relatório construtivo e informativo.

        ${focoAnalise} 

                Regras de Formatação:

                Antes de iniciar o relatório, escreva uma breve mensagem de boas-vindas, como:

                "## 👋 Olá, [nome]!
                Este é o **Relatório de Desempenho Acadêmico**, gerado com apoio de inteligência artificial.
                Aqui você encontrará uma análise clara, objetiva e personalizada sobre seu desempenho nas aulas."

                1. Sempre que possível, use **tabelas Markdown** para exibir dados de desempenho.
                2. Use linguagem coerente com o papel definido no tipo de relatório (aluno = motivacional, professor = técnico, gestão = corporativa).
                3. O texto deve ser bem estruturado e legível, com parágrafos curtos, sem excesso de quebras de linha.
                4. Não retorne JSON, apenas texto puro com Markdown.

                Exemplo de saída esperada:
                **Indicadores de Desempenho**
                | Atividade | Categoria | Média da Turma | Descrição |
                |------------|------------|----------------|------------|
                | Teste Intermediário | Teste | 9.2 | Avaliação de meio de semestre |

                **Observação:** Desempenho acima da média, refletindo boas práticas pedagógicas e engajamento institucional.

                **Importante:**  
                 Não incluir frequência, comportamento ou nomes de alunos.  
        `;

    const userPrompt = `Analise este JSON de desempenho e gere um relatório de frequência completo, seguindo as regras:
        ${jsonString}`;

    return { systemPrompt, userPrompt };
};

// --- 3️⃣ FUNÇÃO DE CHAMADA À IA ---
const generateRelatorioFromAI = async (dashboardData, tipoNivel, idMateria, idSemestre) => { // AGORA RECEBE tipoNivel
    console.log("Analytica AI: Gerando novo Relatório via Azure OpenAI.");

    const { systemPrompt, userPrompt } = buildPrompt(dashboardData, tipoNivel, idMateria, idSemestre);

    try {
        const response = await client.chat.completions.create({
            model: modelName,
            // Removendo response_format, pois agora esperamos texto puro/Markdown.
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: userPrompt }
            ],
            temperature: 0.5,
            max_tokens: 1000
        });

        const relatorioMarkdown = response.choices[0].message.content.trim();

        const gerarNomeArquivo = (tipoNivel, desempenho, idMateria, idSemestre) => {
            const item = desempenho?.[0];

            let identificador = "";
            let turma = item?.turma?.id_turma ? `T${item.turma.id_turma}` : "TURMA";

            switch (tipoNivel) {
                case "aluno":
                    identificador = `ALUNO-${item?.aluno?.id_aluno || "SEMID"}`;
                    break;

                case "professor":
                    identificador = `PROF-${item?.professor?.id_professor || "SEMID"}-${turma}`;
                    break;

                case "gestao":
                    identificador = `GESTAO-${item?.gestao?.id_gestao || "SEMID"}-${turma}`;
                    break;

                default:
                    identificador = "RELATORIO";
            }

            return `relatorio-desempenho-${identificador}-M${idMateria}-S${idSemestre}`;
        };

        const nomeArquivo = gerarNomeArquivo(
            tipoNivel,
            dashboardData.desempenho,
            idMateria,
            idSemestre
        );

        const linkPDF = await gerarPDF(relatorioMarkdown, nomeArquivo);

        return {
            linkPDF: linkPDF,
            conteudoMarkdown: relatorioMarkdown
        };
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
            idChave = firstItem?.professor?.id_professor;
            finalIdTurma = firstItem?.turma?.id_turma;
            if (!idChave) {
                throw new Error("ID do Professor ausente no JSON de desempenho (desempenho[0].professor.id_professor).");
            }
            if (!finalIdTurma) {
                throw new Error("ID da Turma ausente no JSON de desempenho (desempenho[0].turma.id_turma) para o Professor.");
            }
        } else if (tipoNivel === 'gestao') {
            idChave = firstItem?.gestao?.id_gestao;
            finalIdTurma = firstItem?.turma?.id_turma;
            if (!idChave) {
                throw new Error("ID da Gestão ausente no JSON de desempenho (desempenho[0].gestao.id_gestao).");
            }
            if (!finalIdTurma) {
                throw new Error("ID da Turma ausente no JSON de desempenho (desempenho[0].turma.id_turma) para a Gestão.");
            }
        } else {
            throw new Error(`'tipoNivel' desconhecido ou não implementado: ${tipoNivel}`);
        }
        // --- FIM DA LÓGICA DE EXTRAÇÃO ---

        // --- 2. VERIFICAÇÃO E EXTRAÇÃO DE idMateria/idSemestre ---
        console.log(">>> Antes da conversão:", idMateria, idSemestre);
        let finalIdMateria = Number(idMateria);
        let finalIdSemestre = Number(idSemestre);
        console.log(">>> Depois da conversão:", finalIdMateria, finalIdSemestre);


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

        if (!finalIdMateria || !finalIdSemestre) {
            console.error("ERRO: finalIdMateria ou finalIdSemestre ausente");
            console.error({ finalIdMateria, finalIdSemestre });
            throw new Error("Os IDs de Matéria e/ou Semestre são obrigatórios e devem ser passados como parâmetros.");
        }

        // --- 3. TENTA BUSCAR NO CACHE ---
        const cacheIdTurma = (tipoNivel === 'professor' || tipoNivel === 'gestao') ? Number(finalIdTurma) : undefined;


        let relatorioCache = await relatoriosDAO.findRelatorioCache(
            idChave,
            tipoNivel,
            tipoRelatorio,
            Number(finalIdMateria),
            Number(finalIdSemestre),
            cacheIdTurma
        );

        if (relatorioCache) {
            console.log("Analytica AI: Relatório encontrado no cache.");
            return {
                status_code: 200,
                message: message.SUCCESS_CREATED_ITEM.message,
                relatorio: {
                    link: relatorioCache.link
                }
            };
        }

        // --- 4. GERAÇÃO E SALVAMENTO NO CACHE (CORRIGIDO) ---
        // Aqui, generateRelatorioFromAI gera o Markdown, o PDF e retorna o link
        const { linkPDF, conteudoMarkdown } = await generateRelatorioFromAI(dashboardData, tipoNivel, idMateria, idSemestre);

        // Garante que o link é válido antes de salvar no cache (previne o erro .replace())
        if (!linkPDF || typeof linkPDF !== 'string') {
            throw new Error("Link do PDF não foi gerado corretamente. Não será possível salvar no cache.");
        }

        // Salva no cache
        await relatoriosDAO.insertRelatorioCache({
            idChave,
            tipoNivel,
            tipoRelatorio: "desempenho",
            idMateria: Number(finalIdMateria),
            idSemestre: Number(finalIdSemestre),
            idTurma: cacheIdTurma,
            link: linkPDF,
            // Adicionando o conteúdo Markdown bruto (opcional)
            conteudo: conteudoMarkdown
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
        }
    }
}

module.exports = {
    generateRelatorioFromAI,
    getRelatorio
}