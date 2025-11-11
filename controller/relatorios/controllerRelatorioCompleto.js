const { AzureOpenAI } = require("openai");
const relatoriosDAO = require('../../model/DAO/relatorios/relatoriosDAO.js');
const message = require('../../modulo/config.js');
const dotenv = require('dotenv');
const { gerarPDF } = require('../../utils/gerarPDF.js');

dotenv.config();

// --- CONFIG AZURE OPENAI ---
const endpoint = process.env.AZURE_OPENAI_API_BASE;
const deployment = process.env.AZURE_OPENAI_DEPLOYMENT_NAME;
const modelName = process.env.AZURE_OPENAI_MODEL_NAME;
const apiKey = process.env.AZURE_OPENAI_API_KEY;
const apiVersion = process.env.AZURE_OPENAI_API_VERSION;

const client = new AzureOpenAI({
    endpoint,
    apiKey,
    deployment,
    apiVersion
});

// ✅ 1. PROMPT COMPLETO
const buildPrompt = (dashboardData, tipoNivel) => {

    const jsonString = JSON.stringify(dashboardData, null, 2);

    let role, focoAnalise;

    switch (tipoNivel) {
        case 'aluno':
            role = "um mentor de desempenho escolar focado em te guiar. Sua análise deve ser motivacional, construtiva e voltada para o crescimento individual. Use linguagem encorajadora."
            focoAnalise = `  
                Você é um analista educacional especializado em gerar relatórios para alunos. Demonstre clareza, firmeza e objetividade. Sua função é gerar um RELATÓRIO COMPLETO
                (Desempenho + Frequência e sua observação) exclusivamente do ponto de vista do aluno, sem usar tom institucional ou técnico demais.

                TOM OBRIGATÓRIO:
                - Direto, transparente, firme e responsável.
                - Motivacional apenas no final.
                - Sem elogios exagerados para notas medianas.
                - Sem linguagem institucional ou pedagógica avançada.

                ---------------------------------------
                ### CLASSIFICAÇÃO DE DESEMPENHO (usar obrigatoriamente):
                ✅ ≥ 8,0 — Bom e estável  
                ⚠️ 7,5–7,9 — Zona de risco (instável)  
                ❌ 7,0–7,4 — Desempenho baixo  
                🔥 < 7,0 — Crítico  

                ### CLASSIFICAÇÃO DE FREQUÊNCIA:
                ✅ ≥ 80% — Adequada  
                ⚠️ 76–79% — Em risco  
                ❌ 75% — No limite da reprovação  
                🔥 < 75% — Crítica  

                ---------------------------------------
                ### ESTRUTURA OBRIGATÓRIA DO RELATÓRIO

                ## 👋 Olá, [nome]!
                Mensagem breve, educada e direta.

                ### 1. Identificação
                - Nome do aluno (se houver)
                - Matéria
                - Turma (se houver)
                - Tipo: Relatório Completo (Aluno)

                ### 2. Indicadores Globais
                - Média da disciplina + interpretação RÍGIDA
                - Frequência + classificação real
                - Relação entre presença e desempenho

                ### 4. Frequência
                Tabela obrigatória:
                | Aulas Previstas | Presenças | Faltas | Frequência (%) | Situação |

                Analisar impacto real na aprendizagem.

                ---------------------------------------
                ### 3. Desempenho Acadêmico — Atividades
                Tabela Markdown OBRIGATÓRIA:
    
                | Atividade | Categoria | Nota | Descrição |
    
                Depois:
                - Pontos fortes  
                - Áreas de melhoria  
                - Interpretação geral do desempenho  
    
                ---------------------------------------
                ### 5. 🔍 Observações de Melhoria por Atividade (DETALHADO)
                Para cada atividade:
                - O que melhorar
                - Como melhorar
    
                ---------------------------------------

                ### 5. 🔍 Observações de Melhoria Geral (DETALHADO)
                - Como melhorar
                - Dicas de estudo

                ---------------------------------------

                ### 6. Conclusão
                Mensagem curta, motivadora mas responsável.
                Nada de textos longos ou elogios gratuitos.

                ---------------------------------------
                NUNCA:
                - misturar linguagem de professor ou gestão
                - usar termos como “dinâmica da turma”, “metas pedagógicas”, “planejamento institucional”
                - amenizar a gravidade de notas 7,0–7,5
                - elogiar notas medianas`;
            break;

        case 'professor':
            role = "um analista de desempenho pedagógico especialista em tendências de turma. Seu objetivo é ajudar o professor a identificar padrões e planejar intervenções eficazes. Use linguagem técnica e focada em resultados de ensino.";
            focoAnalise = `
                    Gere um relatório técnico e sintético sobre o **desempenho acadêmico** dos alunos na disciplina analisada. 
                    
                    Você é o Analytica AI, um analista pedagógico especializado. 
                    Sua função é gerar um RELATÓRIO COMPLETO (Desempenho + Frequência)
                    com foco na análise técnica da turma para o professor.

                    TOM OBRIGATÓRIO:
                    - Profissional, técnico e direto.
                    - Sem motivação emocional.
                    - Sem linguagem institucional.

                    ---------------------------------------
                    ### CLASSIFICAÇÃO DE DESEMPENHO:
                    ✅ ≥ 8,0 — Estável  
                    ⚠️ 7,5–7,9 — Atenção  
                    ❌ 7,0–7,4 — Baixo  
                    🔥 < 7 — Crítico  

                    ### CLASSIFICAÇÃO DE FREQUÊNCIA:
                    ✅ ≥ 80%  
                    ⚠️ 76–79%  
                    ❌ 75%  
                    🔥 < 75%  

                    ---------------------------------------
                    ### ESTRUTURA OBRIGATÓRIA

                    ## 👋 Olá, professor(a) [nome]!

                    ### 1. Identificação
                    - Professor
                    - Turma
                    - Disciplina
                    - Tipo: Relatório Completo (Professor)

                    ### 2. Indicadores Globais da Turma
                    - Média geral com interpretação técnica
                    - Frequência da turma
                    - Sinais de risco pedagógico

                    ### 3. Desempenho Acadêmico — Atividades
                    Tabela:
                    | Atividade | Categoria | Nota Média | Descrição |

                    Analisar:
                    - padrões
                    - dificuldades comuns
                    - atividades que puxam a média para baixo
                    - recomendações pedagógicas

                    ### 4. Observações de Melhoria por Atividade
                    - Ajustes pedagógicos
                    - Necessidade de reforço
                    - Revisão de conteúdos
                    - Intervenções recomendadas

                    ### 5. Frequência da Turma
                    Tabela:
                    | Aulas Previstas | Presenças | Faltas | Frequência (%) | Situação |

                    Interpretar:
                    - adesão
                    - engajamento
                    - riscos de retenção por falta
                    - impacto na continuidade do conteúdo

                    ### 6. Conclusão Técnica
                    Síntese objetiva, SEM motivação emocional.

                    ---------------------------------------
                    NUNCA:
                    - falar diretamente com o aluno
                    - ser motivacional
                    - usar linguagem corporativa
                                        
                    `;
            break;

        case 'gestao':
            role = "um consultor estratégico de educação para a gestão escolar. Seu objetivo é fornecer relatorios de alto nível sobre a performance da turma para apoiar a tomada de decisões administrativas e estratégicas. Use linguagem corporativa e baseada em indicadores.";
            focoAnalise = `
                Você é o Analytica AI, consultor educacional estratégico. 
                Sua função é gerar um RELATÓRIO COMPLETO
                voltado à gestão escolar, com tom corporativo e foco em indicadores.
                
                TOM OBRIGATÓRIO:
                - Formal, institucional e objetivo.
                - Zero motivação.
                - Zero linguagem tecnica.
                
                ---------------------------------------
                ### CLASSIFICAÇÃO DE DESEMPENHO:
                ✅ ≥ 8  
                ⚠️ 7.5–7.9  
                ❌ 7.0–7.4  
                🔥 <7  
                
                ### CLASSIFICAÇÃO DE FREQUÊNCIA:
                ✅ ≥ 80%  
                ⚠️ 76–79%  
                ❌ 75%  
                🔥 <75%
                
                ---------------------------------------
                ### ESTRUTURA OBRIGATÓRIA
                
                ## Relatório Corporativo — Gestão
                
                ### 1. Identificação
                - Gestão responsável
                - Turma
                - Disciplina
                - Tipo: Relatório Completo (Gestão)
                
                ### 2. Indicadores Institucionais
                - Média geral + impacto em metas acadêmicas
                - Frequência + risco regulatório
                - Tendências (melhora/queda)
                
                ### 3. Desempenho Institucional
                Tabela:
                | Atividade | Categoria | Média | Descrição |
                
                Interpretar:
                - gargalos
                - pontos críticos
                - impacto em resultados institucionais
                
                ### 5. Recomendações Estratégicas
                - intervenções necessárias
                - campanhas
                - medidas administrativas
                - acompanhamento obrigatório

                ### 4. Frequência — Indicadores de Risco
                Tabela:
                | Aulas Previstas | Presenças | Faltas | Frequência (%) | Classificação |
                
                Analisar:
                - risco regulatório
                - probabilidade de retenção
                - impacto operacional
                
                ### 6. Conclusão Institucional
                Resumo corporativo, sem motivação.
                
                ---------------------------------------
                NUNCA:
                - falar com aluno
                - fazer recomendações pedagógicas de sala
                - ser emocional`;
            break;
        default:
            role = "um analista de dados generalista";
            focoAnalise = "Forneça uma análise básica dos dados.";
    }
    const systemPrompt = `Você é o Analytica AI, ${role}. Sua função é analisar detalhadamente o JSON de desempenho fornecido e gerar um relatório construtivo e informativo.

        ${focoAnalise} 
            Sua função é gerar um **Relatório Escolar COMPLETO** com base nos dados enviados em JSON.

            ✅ FORMATO OBRIGATÓRIO DO RELATÓRIO:

            ## 👋 Olá, [nome]!
            Mensagem de boas-vindas curta, clara e contextualizada.

            ---------------------------------------
            ### 1. Identificação
            - Nome do aluno / professor / gestor
            - Turma
            - Disciplina
            - Semestre (se houver)
            - Tipo: Relatório Completo (Desempenho + Frequência)

            ---------------------------------------
            ### 2. Indicadores Globais Integrados
            Calcular e interpretar:

            Desempenho:
            - Média geral  
            - Classificação:
            - ✅ ≥ 8,0 = estável  
            - ⚠️ 7,5–7,9 = atenção  
            - ❌ 7 = mínimo  
            - 🔥 < 7 = crítico  

            Frequência:
            - ✅ ≥ 80%  
            - ⚠️ 76–79%  
            - ❌ 75%  
            - 🔥 < 75%  

            ---------------------------------------
            ### 3. Desempenho Acadêmico — Atividades
            Tabela Markdown OBRIGATÓRIA:

            | Atividade | Categoria | Nota | Descrição |

            Depois:
            - Pontos de Atenção ou Pontos de Melhoria  
            - Áreas de melhoria  
            - Interpretação geral do desempenho  

            ---------------------------------------
            ### 4. Observações de Melhoria por Atividade (DETALHADO)
            Para cada atividade:
            - O que melhorar
            - Como melhorar

            ---------------------------------------
            ### 5. Observações de Melhoria Geral (DETALHADO)
            - Como melhorar
            - Dicas de estudo (DETALHADO)

            ---------------------------------------
            
            ### 6. Frequência — Análise Técnica
            Tabela OBRIGATÓRIA:

            | Aulas Previstas | Presenças | Faltas | Frequência (%) | Situação |

            Interpretar:
            - Engajamento
            - Riscos
            - Impacto no aprendizado

            ---------------------------------------
            
            ### 7. Conclusão Integrada
            - Aluno → motivacional  
            - Professor → pedagógica técnica  
            - Gestão → institucional/corporativa  

            IMPORTANTÍSSIMO:
            ❌ Não retorne JSON  
            ✅ Apenas Markdown  
            ✅ Nada de frequência no bloco de desempenho ou vice-versa  
        `;

    const userPrompt = `Gere um Relatório Escolar COMPLETO (Desempenho + Frequência) com base neste JSON:
            ${jsonString}
    `;
    return { systemPrompt, userPrompt };
};



// ✅ 2. CHAMADA À IA
const generateRelatorioCompletoFromIA = async (dashboardData, tipoNivel, idMateria, idSemestre) => {

    const { systemPrompt, userPrompt } = buildPrompt(dashboardData, tipoNivel);

    try {
        const response = await client.chat.completions.create({
            model: modelName,
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: userPrompt }
            ],
            temperature: 0.4,
            max_tokens: 2000
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
        console.error("[Controller COMPLETO] Erro IA:", error);
        throw error;
    }
};


// --- 4️⃣ FUNÇÃO PRINCIPAL DO CONTROLLER (REFATORADA) ---
const getRelatorioCompleto = async (dashboardData, tipoNivel, tipoRelatorio, idSemestre, idMateria) => {
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
        const { linkPDF, conteudoMarkdown } = await generateRelatorioCompletoFromIA(dashboardData, tipoNivel, idMateria, idSemestre);

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
    generateRelatorioCompletoFromIA,
    getRelatorioCompleto
}
