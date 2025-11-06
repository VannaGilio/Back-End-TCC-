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
const buildPrompt = (dashboardData, tipoNivel, idMateria, idSemestre) => {
        
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
                        Apenas a seção de frequência deve conter uma tabela com os dados numéricos ou comparativos.

                        **Observação importante sobre frequência:**  
                        - Considere que **75% é o mínimo obrigatório** para o aluno não reprovar por faltas.  
                        - Frequências **entre 75% e 80% devem ser tratadas como sinal de alerta**, destacando que o aluno está no limite e precisa melhorar a presença.  
                        - Frequências **abaixo de 75% devem ser classificadas como críticas**, reforçando o risco de reprovação.


                        **Regras obrigatórias para interpretação da frequência (NÃO IGNORAR):**
                        - **75% é o mínimo para NÃO reprovar.**
                        - Frequência exatamente **75% deve ser classificada como RUIM**, pois o aluno está no limite da reprovação.
                        - Frequências de **76% a 79% são classificadas como RISCO**, pois ainda estão perigosamente próximas do mínimo.
                        - Frequências **abaixo de 75% são CRÍTICAS**, e devem receber alerta claro de risco de reprovação.
                        - Frequências **80% ou mais são aceitáveis**.

                        ### 1. Identificação
                        Inclua:
                        - Nome do Aluno
                        - Nome da turma
                        - Nome da disciplina

                        Ao analisar cada disciplina, deixe claro se o aluno está:
                        - ✅ Adequado (≥ 80%)
                        - ⚠️ Em risco (76%–79%)
                        - ❌ Ruim — no limite da reprovação (75%)
                        - 💥 Crítico — risco alto de reprovação (< 75%)

                        Siga esta estrutura:

                        **Desempenho de Frequência**  
                        - Mostre uma tabela com frequência por disciplina.  
                        - Destaque disciplinas com frequência abaixo de 80%, apontando se o aluno está:
                                - **No limite** (75%–79%)
                                - **Em risco** (< 75%)  
                        - Analise como a presença impacta o desempenho.
                        - Acrescente uma observação motivacional sobre como pequenas mudanças de rotina podem melhorar tanto presença quanto desempenho.
                        `;


                        break;

                case 'professor':
                        role = "um analista de desempenho pedagógico especialista em tendências de turma. Seu objetivo é ajudar o professor a identificar padrões e planejar intervenções eficazes. Use linguagem técnica e focada em resultados de ensino.";
                        focoAnalise = `
                                Você é um analista educacional especializado em gerar relatórios técnicos para professores.
                                Seu objetivo é transformar os dados enviados no body da requisição em um relatório claro,
                                objetivo, técnico e focado em acompanhamento pedagógico.
                               
                                ### 1. Identificação
                                Inclua:
                                - nome
                                - turma
                                - materia

                                Formato esperado:

                                ### 2. Regras de interpretação da frequência da turma

                                Classificação:
                                - 80% ou mais → ✅ Frequência adequada  
                                - 76% a 79% → ⚠️ Frequência em observação  
                                - 75% → ❌ Frequência no limite mínimo  
                                - Abaixo de 75% → 🔥 Frequência crítica  
                                - total_aulas = 0 → “Nenhuma aula registrada no período analisado.”

                                ### 3. Tabela obrigatória
                                | Aulas Previstas | Presenças | Faltas | Frequência (%) | Situação |
                                |-----------------|-----------|--------|----------------|----------|

                                ### 4. Análise técnica
                                Inclua:
                                - interpretação objetiva dos dados
                                - impacto na dinâmica da turma
                                - possíveis indicadores gerais (ex.: baixa adesão, início de período, falta de engajamento)
                                - observações sobre necessidade de atenção

                                Nunca individualize alunos.  
                                Nunca mencione desempenho, notas, provas ou atividades.

                                Retorne somente texto com Markdown.
                        `;
                        break;

                case 'gestao':
                        role = "um consultor estratégico de educação para a gestão escolar. Seu objetivo é fornecer relatorios de alto nível sobre a performance da turma para apoiar a tomada de decisões administrativas e estratégicas. Use linguagem corporativa e baseada em indicadores.";
                        focoAnalise = `
                                Gere um relatório institucional baseado **exclusivamente na frequência** da turma, de acordo com a matéria e o semestre.  
                                Não use termos motivacionais nem análise de desempenho individual ou notas.
                
                                1. Identificação (obrigatório)
                                - Turma analisada
                                - Disciplina
                                - Período / semestre
                                - Responsável pelo relatório (professor ou sistema)
                
                                ### 2. Indicadores globais
                                Utilize apenas dados de frequência.  
                                Classificação:
                                - ✅ ≥ 80% — Frequência estável  
                                - ⚠️ 76% a 79% — Zona de atenção  
                                - ❌ 75% — Limite mínimo legal  
                                - 🔥 < 75% — Indicador crítico, risco regulatório  
                                - total_aulas = 0 → “Sem registro de aulas no período.”
                
                                ### 3. Tabela obrigatória (Markdown)
                                | Aulas Previstas | Presenças | Faltas | Frequência (%) | Classificação |
                                |-----------------|-----------|--------|----------------|---------------|
                
                                ### 4. Análise gerencial
                                - Interpretação da tendência da presença da turma  
                                - Impacto em metas institucionais  
                                - Riscos administrativos ou regulatórios  
                                - Sugestões de intervenção (ex.: campanhas, contato com responsáveis, revisão de horários)
                
                                Proibido:
                                - Falar de notas, desempenho, comportamento ou dificuldades individuais.
                                - Fazer narrativa motivacional (somente texto corporativo).`;
                        break;

                default:
                        role = "um analista de dados generalista";
                        focoAnalise = "Forneça uma análise básica dos dados.";
        }


        const systemPrompt = `Você é o Analytica AI, ${role}. Sua função é analisar detalhadamente o JSON de desempenho fornecido e gerar um relatório construtivo e informativo.

        ${focoAnalise} 

                Regras de Formatação:

                Antes de iniciar o relatório, escreva uma breve mensagem de boas-vindas, como:
                
                "##👋 Olá, [nome]! Seja bem-vindo(a)!                  
                Este é o seu Relatório Escolar de Frequência, gerado com apoio de inteligência artificial.  
                Aqui você encontrará uma análise clara, objetiva e personalizada sobre sua participação nas aulas."
                
                1. Sempre que possível, use **tabelas Markdown** para apresentar dados quantitativos, no formato:
                | Coluna | Coluna | Coluna |
                |---------|---------|---------|
                | Valor   | Valor   | Valor   |
                2. Use linguagem coerente com o papel definido no tipo de relatório (aluno = motivacional, professor = técnico, gestão = corporativa).
                3. O texto deve ser bem estruturado e legível, com parágrafos curtos, sem excesso de quebras de linha.
                4. Não retorne JSON, apenas texto puro com Markdown.
                
                Exemplo de saída esperada (estrutura simplificada):
                
                **Desempenho de Frequência**  
                | Aulas Previstas | Aulas Assistidas | Faltas | Frequência |
                |-----------------|------------------|--------|------------|
                |        20       |        18        |    2   |     90%    |
                
                **Observação:** Excelente presença e bom engajamento geral, refletindo comprometimento nas aulas.
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
                    
                        return `relatorio-frequencia-${identificador}-M${idMateria}-S${idSemestre}`;
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
                tipoRelatorio: "frequência",
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