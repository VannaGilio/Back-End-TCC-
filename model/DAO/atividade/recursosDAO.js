const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const insertRecurso = async function(recurso) {
    try {
        const result = await prisma.$executeRaw`CALL sp_inserir_recurso(
            ${recurso.titulo},
            ${recurso.descricao},
            ${recurso.data_criacao},
            ${recurso.id_materia},
            ${recurso.id_professor}
        )`;
    if(result)
        return true
    else
        return false
    } catch (error) {
        return false
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
                id_professor = ${recurso.id_professor}
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
    selectByIdRecurso,
    deleteByIdRecurso,
    updateByIdRecurso
};
