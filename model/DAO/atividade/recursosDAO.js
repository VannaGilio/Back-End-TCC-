const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const insertRecurso = async function(recurso) {
    try {
        const result = await prisma.$executeRaw`CALL sp_inserir_recurso(
            ${recurso.titulo},
            ${recurso.descricao},
            ${recurso.data_criacao},
            ${recurso.id_materia},
            ${recurso.id_professor},
            ${recurso.id_turma},
            ${recurso.id_semestre},
            ${recurso.link_criterio}
        )`;
    if(result)
        return true
    else
        return false
    } catch (error) {
        return false
    }
};

const selectRecursosProfessor = async function(idProfessor, idTurma, idSemestre) {
    try {
        let sql = `SELECT * FROM vw_recursos_professor WHERE id_professor = ${idProfessor}`;

        if (idTurma) {
            sql += ` AND id_turma = ${idTurma}`;
        }

        if (idSemestre) {
            sql += ` AND id_semestre = ${idSemestre}`;
        }

        const result = await prisma.$queryRawUnsafe(sql);

        if (result)
            return result;
        else
            return false;
    } catch (error) {
        return false;
    }
};

const selectRecursosGestao = async function(idGestao, idTurma, idMateria, idSemestre) {
    try {
        let sql = `SELECT * FROM vw_recursos_gestao WHERE id_gestao = ${idGestao}`;

        if (idTurma) {
            sql += ` AND id_turma = ${idTurma}`;
        }

        if (idMateria) {
            sql += ` AND id_materia = ${idMateria}`;
        }

        if (idSemestre) {
            sql += ` AND id_semestre = ${idSemestre}`;
        }

        const result = await prisma.$queryRawUnsafe(sql);

        if (result)
            return result;
        else
            return false;
    } catch (error) {
        return false;
    }
};

const selectAllRecursos = async function() {
    try {
        const result = await prisma.$queryRaw`SELECT * FROM vw_buscar_recursos`;
        return result;
    } catch (error) {
        return false;
    }
};

const selectRecursosAluno = async function(idAluno, idMateria, idSemestre) {
    try {
        let sql = `SELECT * FROM vw_recursos_aluno WHERE id_aluno = ${idAluno}`;

        if (idMateria) {
            sql += ` AND id_materia = ${idMateria}`;
        }

        if (idSemestre) {
            sql += ` AND id_semestre = ${idSemestre}`;
        }

        const result = await prisma.$queryRawUnsafe(sql);

        if (result)
            return result;
        else
            return false;
    } catch (error) {
        return false;
    }
};

const selectByIdRecurso = async function(id) {
    try {
        const result = await prisma.$queryRaw`SELECT * FROM vw_buscar_recursos WHERE id_recursos = ${id}`;
        return result;
    } catch (error) {
        return false;
    }
};

const deleteByIdRecurso = async function(id) {
    try {
        const result = await prisma.$executeRaw`DELETE FROM tbl_recursos WHERE id_recursos = ${id}`;
        return result ? true : false;
    } catch (error) {
        return false;
    }
};

const updateByIdRecurso = async function(recurso) {
    try {
        const result = await prisma.$executeRaw`
            UPDATE tbl_recursos SET
                titulo = ${recurso.titulo},
                descricao = ${recurso.descricao},
                data_criacao = ${recurso.data_criacao},
                id_materia = ${recurso.id_materia},
                id_professor = ${recurso.id_professor},
                id_turma = ${recurso.id_turma},
                id_semestre = ${recurso.id_semestre},
                link_criterio = ${recurso.link_criterio}
            WHERE id_recursos = ${recurso.id_recursos}
        `;
        return result ? true : false;
    } catch (error) {
        return false;
    }
};

module.exports = {
    insertRecurso,
    selectAllRecursos,
    selectRecursosAluno,
    selectRecursosProfessor,
    selectRecursosGestao,
    selectByIdRecurso,
    deleteByIdRecurso,
    updateByIdRecurso
};
