const { PrismaClient } = require('@prisma/client');
const moment = require('moment');

const prisma = new PrismaClient();
const CACHE_VALIDITY_HOURS = 240;

/**
 * Checa se já existe um Relatório recente (válido) para a combinação Chave/Matéria/Semestre/Turma.
 * @param {number} idChave - ID da chave primária (aluno, professor ou gestão).
 * @param {string} tipoNivel - O nível de acesso que está gerando o Relatório.
 * @param {string} tipoRelatorio - Tipo de relatório que será gerado.
 * @param {number} idMateria - ID da matéria.
 * @param {number} idSemestre - ID do semestre.
 * @param {number | undefined} idTurma - ID da turma (presente para professor/gestão, undefined/null para aluno).
 * @returns {Promise<{titulo: string, conteudo: string} | null>} Retorna o Relatório mais recente do cache ou null.
 */
const findRelatorioCache = async function (idChave, tipoNivel, tipoRelatorio, idMateria, idSemestre, idTurma) {
    try {
        const validDate = moment().subtract(CACHE_VALIDITY_HOURS, 'hours').format('YYYY-MM-DD HH:mm:ss');

        // Define a coluna de ID de acordo com o nivel de acesso.
        let idColumn = '';
        if (tipoNivel === 'aluno') idColumn = 'id_aluno';
        else if (tipoNivel === 'professor') idColumn = 'id_professor';
        else if (tipoNivel === 'gestao') idColumn = 'id_gestao';
        else {
            console.error("[DAO] Tipo de Relatório Inválido:", tipoNivel);
            return null;
        }

        // Condição de turma
        let turmaCondition = '';
        if (tipoNivel === 'professor' || tipoNivel === 'gestao') {
            if (idTurma != null) turmaCondition = `AND id_turma = ${idTurma}`;
            else turmaCondition = `AND id_turma IS NULL`;
        } else {
            turmaCondition = `AND id_turma IS NULL`;
        }

        const query = `
            SELECT data_geracao, link, tipo_relatorio
            FROM tbl_relatorio
            WHERE ${idColumn} = ${idChave}
              AND id_materia = ${idMateria}
              AND id_semestre = ${idSemestre}
              AND tipo_nivel = '${tipoNivel}'
              ${turmaCondition}
              AND tipo_relatorio =  '${tipoRelatorio}'
              AND data_geracao >= '${validDate}'
            ORDER BY data_geracao DESC
            LIMIT 1
        `;

        const result = await prisma.$queryRawUnsafe(query);
        return result.length > 0 ? result[0] : null;

    } catch (error) {
        console.error("[DAO] Erro ao buscar cache de relatórios:", error);
        throw error;
    }
};

/**
 * Salva um novo insight gerado pela IA na tabela de cache (tbl_insights).
 * @param {object} relatorioData - Dados do insight a ser salvo.
 */
const insertRelatorioCache = async function (relatorioData) {
    try {
        let idAluno = null, idProfessor = null, idGestao = null;
        let idTurma = relatorioData.idTurma || null;

        if (relatorioData.tipoNivel === 'aluno') idAluno = relatorioData.idChave;
        else if (relatorioData.tipoNivel === 'professor') idProfessor = relatorioData.idChave;
        else if (relatorioData.tipoNivel === 'gestao') idGestao = relatorioData.idChave;
        else {
            console.error("[DAO] Tentativa de inserir relatótio com Tipo Inválido:", relatorioData.tipoNivel);
            return false;
        }

        const result = await prisma.$executeRawUnsafe(`
            INSERT INTO tbl_relatorio (
                link,
                data_geracao,
                tipo_relatorio,
                tipo_nivel,
                id_aluno,
                id_professor,
                id_gestao,
                id_materia,
                id_turma,
                id_semestre,
            ) VALUES (
                '${relatorioData.link.replace(/'/g, "\\'")}'
                NOW(),
                '${relatorioData.tipoRelatorio}',
                '${relatorioData.tipoNivel}',
                ${idAluno},
                ${idProfessor},
                ${idGestao},
                ${relatorioData.idMateria},
                ${idTurma},
                ${relatorioData.idSemestre},
            );
        `);

        return result === 1;

    } catch (error) {
        console.error("[DAO] Erro ao inserir cache de relatório:", error);
        throw error;
    }
}

module.exports = {
   findRelatorioCache,
   insertRelatorioCache
};
