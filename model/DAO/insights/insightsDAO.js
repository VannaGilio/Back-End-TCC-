//model/DAO/insights/insightsDAO.js

const { PrismaClient } = require('@prisma/client');
const moment = require('moment');

const prisma = new PrismaClient();
const CACHE_VALIDITY_HOURS = 240;

/**
 * Checa se já existe um insight recente (válido) para a combinação Chave/Matéria/Semestre/Turma.
 * @param {number} idChave - ID da chave primária (aluno, professor ou gestão).
 * @param {string} tipoInsight - O nível de acesso que está gerando o insight.
 * @param {number} idMateria - ID da matéria.
 * @param {number} idSemestre - ID do semestre.
 * @param {number | undefined} idTurma - ID da turma (presente para professor/gestão, undefined/null para aluno).
 * @returns {Promise<{titulo: string, conteudo: string} | null>} Retorna o insight mais recente do cache ou null.
 */
const findInsightCache = async function (idChave, tipoInsight, idMateria, idSemestre, idTurma) {
    try {
        const validDate = moment().subtract(CACHE_VALIDITY_HOURS, 'hours').format('YYYY-MM-DD HH:mm:ss');

        // Define a coluna de ID de acordo com o tipo de insight
        let idColumn = '';
        if (tipoInsight === 'aluno') idColumn = 'id_aluno';
        else if (tipoInsight === 'professor') idColumn = 'id_professor';
        else if (tipoInsight === 'gestao') idColumn = 'id_gestao';
        else {
            console.error("[DAO] Tipo de Insight Inválido:", tipoInsight);
            return null;
        }

        // Condição de turma
        let turmaCondition = '';
        if (tipoInsight === 'professor' || tipoInsight === 'gestao') {
            if (idTurma != null) turmaCondition = `AND id_turma = ${idTurma}`;
            else turmaCondition = `AND id_turma IS NULL`;
        } else {
            turmaCondition = `AND id_turma IS NULL`;
        }

        const query = `
            SELECT titulo, conteudo, data_geracao
            FROM tbl_insights
            WHERE ${idColumn} = ${idChave}
              AND id_materia = ${idMateria}
              AND id_semestre = ${idSemestre}
              AND tipo_insight = '${tipoInsight}'
              ${turmaCondition}
              AND data_geracao >= '${validDate}'
            ORDER BY data_geracao DESC
            LIMIT 1
        `;

        const result = await prisma.$queryRawUnsafe(query);
        return result.length > 0 ? result[0] : null;

    } catch (error) {
        console.error("[DAO] Erro ao buscar cache de insights:", error);
        throw error;
    }
};

/**
 * Salva um novo insight gerado pela IA na tabela de cache (tbl_insights).
 * @param {object} insightData - Dados do insight a ser salvo.
 */
const insertInsightCache = async function (insightData) {
    try {
        let idAluno = null, idProfessor = null, idGestao = null;
        let idTurma = insightData.idTurma || null;

        if (insightData.tipoInsight === 'aluno') idAluno = insightData.idChave;
        else if (insightData.tipoInsight === 'professor') idProfessor = insightData.idChave;
        else if (insightData.tipoInsight === 'gestao') idGestao = insightData.idChave;
        else {
            console.error("[DAO] Tentativa de inserir insight com Tipo Inválido:", insightData.tipoInsight);
            return false;
        }

        const result = await prisma.$executeRawUnsafe(`
            INSERT INTO tbl_insights (
                titulo,
                conteudo,
                data_geracao,
                tipo_insight,
                id_materia,
                id_semestre,
                id_aluno,
                id_professor,
                id_gestao,
                id_turma
            ) VALUES (
                '${insightData.titulo.replace(/'/g, "\\'")}',
                '${insightData.conteudo.replace(/'/g, "\\'")}',
                NOW(),
                '${insightData.tipoInsight}',
                ${insightData.idMateria},
                ${insightData.idSemestre},
                ${idAluno},
                ${idProfessor},
                ${idGestao},
                ${idTurma}
            );
        `);

        return result === 1;

    } catch (error) {
        console.error("[DAO] Erro ao inserir cache de insights:", error);
        throw error;
    }
}

module.exports = {
    findInsightCache,
    insertInsightCache
};
