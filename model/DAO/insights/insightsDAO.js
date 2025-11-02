// Importa o cliente Prisma e a biblioteca 'moment' para trabalhar com datas/horas
// Se você não tiver 'moment', instale com: npm install moment
const { prisma } = require('../database/prisma_client'); 
const moment = require('moment'); 

// Define o período de validade do cache em horas. 
// Insights mais antigos que 24 horas serão regerados pela IA.
const CACHE_VALIDITY_HOURS = 24; 

/**
 * Checa se já existe um insight recente (válido) para a combinação Chave/Matéria/Semestre.
 * O insight deve ter sido gerado no período de CACHE_VALIDITY_HOURS (24h).
 * * @param {number} idChave - ID da chave primária (aluno, professor ou gestão, dependendo do tipoInsight).
 * @param {string} tipoInsight - O nível de acesso que está gerando o insight ('aluno', 'professor', 'gestao').
 * @param {number} idMateria - ID da matéria.
 * @param {number} idSemestre - ID do semestre.
 * @returns {Promise<{titulo: string, conteudo: string} | null>} Retorna o insight mais recente do cache ou null.
 */
const findInsightCache = async function (idChave, tipoInsight, idMateria, idSemestre) {
    try {
        // Calcula a data e hora mínimas aceitáveis para o insight
        const validDate = moment().subtract(CACHE_VALIDITY_HOURS, 'hours').format('YYYY-MM-DD HH:mm:ss');
        
        // Determina qual coluna de ID usar na busca (id_aluno, id_professor ou id_gestao)
        let idColumn = '';
        if (tipoInsight === 'aluno') {
            idColumn = 'id_aluno';
        } else if (tipoInsight === 'professor') {
            idColumn = 'id_professor';
        } else if (tipoInsight === 'gestao') {
            idColumn = 'id_gestao';
        } else {
            console.error("[DAO] Tipo de Insight Inválido:", tipoInsight);
            return null; // Retorna null se o tipo for desconhecido/inválido
        }

        // Busca o insight mais recente (ORDER BY DESC) que ainda está dentro do período de validade
        // Usa a coluna dinâmica idColumn na query
        const result = await prisma.$queryRawUnsafe(`
            SELECT titulo, conteudo, data_geracao
            FROM tbl_insights
            WHERE ${idColumn} = $1
              AND id_materia = $2
              AND id_semestre = $3
              AND tipo_insight = $4
              AND data_geracao >= $5
            ORDER BY data_geracao DESC
            LIMIT 1
        `, idChave, idMateria, idSemestre, tipoInsight, validDate);

        // Retorna o primeiro insight encontrado (o mais recente)
        return result.length > 0 ? result[0] : null;

    } catch (error) {
        console.error("[DAO] Erro ao buscar cache de insights:", error);
        throw error; 
    }
}

/**
 * Salva um novo insight gerado pela IA na tabela de cache (tbl_insights).
 * * @param {object} insightData - Dados do insight a ser salvo.
 * @param {number} insightData.idChave - ID da chave primária (aluno, professor ou gestão).
 * @param {string} insightData.tipoInsight - O nível de acesso que gerou o insight ('aluno', 'professor', 'gestao').
 * @param {number} insightData.idMateria - ID da matéria.
 * @param {number} insightData.idSemestre - ID do semestre.
 * @param {string} insightData.titulo - Título do insight.
 * @param {string} insightData.conteudo - Conteúdo gerado pela IA.
 * @returns {Promise<boolean>} Retorna true se a inserção foi bem-sucedida.
 */
const insertInsightCache = async function (insightData) {
    try {
        let idAluno = null;
        let idProfessor = null;
        let idGestao = null;

        // Atribui o ID à coluna correta
        if (insightData.tipoInsight === 'aluno') {
            idAluno = insightData.idChave;
        } else if (insightData.tipoInsight === 'professor') {
            idProfessor = insightData.idChave;
        } else if (insightData.tipoInsight === 'gestao') {
            idGestao = insightData.idChave;
        } else {
            console.error("[DAO] Tentativa de inserir insight com Tipo Inválido:", insightData.tipoInsight);
            return false;
        }

        // Insere os dados usando NOW() para a data de geração
        const result = await prisma.$executeRaw`
            INSERT INTO tbl_insights (
                titulo, 
                conteudo, 
                data_geracao, 
                tipo_insight, 
                id_materia, 
                id_semestre, 
                id_aluno, 
                id_professor,
                id_gestao
            ) VALUES (
                ${insightData.titulo},
                ${insightData.conteudo},
                NOW(),
                ${insightData.tipoInsight},
                ${insightData.idMateria},
                ${insightData.idSemestre},
                ${idAluno}, 
                ${idProfessor}, 
                ${idGestao}
            );
        `;

        return result === 1; // Verifica se uma linha foi afetada
    } catch (error) {
        console.error("[DAO] Erro ao inserir cache de insights:", error);
        throw error;
    }
}

module.exports = {
    findInsightCache,
    insertInsightCache
};
