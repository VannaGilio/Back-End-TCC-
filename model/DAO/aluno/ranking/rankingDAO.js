const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// model/DAO/aluno/ranking/rankingAlunoDAO.js (Exemplo)

const selectRankingAluno = async function (idAluno, idMateria, idSemestre) {
    try {
        // 1. Obter o ID da Turma do Aluno
        const turmaResult = await prisma.$queryRawUnsafe(`
            SELECT id_turma FROM vw_buscar_aluno WHERE id_aluno = ${idAluno}
        `);
        const idTurma = turmaResult && turmaResult.length > 0 ? turmaResult[0].id_turma : null;

        if (!idTurma) return false;

        // 2. Executar a consulta final (com filtros e CENSURA)
        let sql = `
            SELECT
                CAST(posicao_ranking AS SIGNED INTEGER) AS Ranking,
                media_consolidada AS Média,
                fn_censurar_nome_aluno(nome_aluno, id_aluno, ${idAluno}) AS \`Nome do Aluno\`
            FROM
                vw_ranking_base
            WHERE
                id_turma = ${idTurma}
                AND id_materia = ${idMateria}
                AND id_semestre = ${idSemestre}
            ORDER BY
                posicao_ranking;
        `;
        let result = await prisma.$queryRawUnsafe(sql);
        
        return result; // Não precisamos do [0] se for query direta
    } catch (error) {
        console.error("Erro no selectRankingAluno:", error);
        return false;
    }
};

// model/DAO/aluno/ranking/rankingTurmaDAO.js

// Assumindo que a instância do Prisma está disponível como 'prisma'
// const prisma = require('../../prisma'); 

const selectRankingProfessor = async function (idProfessor, idTurma, idSemestre) {
    try {
        let sql = `
            SELECT
                CAST(posicao_ranking AS SIGNED INTEGER) AS Ranking, 
                media_consolidada AS Média,
                nome_aluno AS \`Nome do Aluno\`
            FROM
                vw_ranking_professor
            WHERE
                -- Filtros obrigatórios para segurança e contexto
                id_professor = ${idProfessor}
                AND id_turma = ${idTurma}
                AND id_semestre = ${idSemestre}
        `;
        
        sql += ` ORDER BY Ranking;`;
        
        let result = await prisma.$queryRawUnsafe(sql); 
        
        return result; 
    } catch (error) {
        console.error("Erro no selectRankingProfessor:", error);
        return false;
    }
};

// DAO para a GESTÃO
const selectRankingGestao = async function (idGestao, idTurma, idMateria, idSemestre) {
    try {
        let sql = `
            SELECT
                -- Aplicando o CAST para evitar o erro BigInt no Node.js
                CAST(posicao_ranking AS SIGNED INTEGER) AS Ranking, 
                media_consolidada AS Média,
                nome_aluno AS \`Nome do Aluno\`,
                materia AS Matéria -- Mantemos a matéria no retorno para contexto
            FROM
                vw_ranking_gestao
            WHERE
                -- Filtros de segurança e contexto OBRIGATÓRIOS
                id_gestao = ${idGestao}
                AND id_turma = ${idTurma}
                AND id_semestre = ${idSemestre}
        `;
        
        // 🚀 AJUSTE: Filtro de Matéria se torna condicional e opcional
        if (idMateria !== null) {
            sql += ` AND id_materia = ${idMateria}`;
        }
        
        sql += ` ORDER BY Ranking;`;
        
        let result = await prisma.$queryRawUnsafe(sql); 
        
        return result; 
    } catch (error) {
        console.error("Erro no selectRankingGestao:", error);
        return false;
    }
};

module.exports = {
    selectRankingAluno,
    selectRankingProfessor,
    selectRankingGestao
};