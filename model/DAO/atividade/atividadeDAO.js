const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const insertAtividade = async function(atividade) {
    try {
        const result = await prisma.$executeRaw`CALL sp_inserir_atividade(
            ${atividade.titulo},
            ${atividade.descricao},
            ${atividade.data_criacao},
            ${atividade.id_materia},
            ${atividade.id_professor},
            ${atividade.id_categoria}
        )`;
        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
};

const selectAllAtividades = async function() {
    try {
        const result = await prisma.$queryRaw`SELECT * FROM vw_buscar_atividades`;
        return result;
    } catch (error) {
        return false;
    }
};

const selectByIdAtividade = async function(id) {
    try {
        const result = await prisma.$queryRaw`SELECT * FROM vw_buscar_atividades WHERE id_atividade = ${id}`;
        return result;
    } catch (error) {
        return false;
    }
};

const deleteByIdAtividade = async function(id) {
    try {
        const result = await prisma.$executeRaw`DELETE FROM tbl_atividade WHERE id_atividade = ${id}`;
        return result ? true : false;
    } catch (error) {
        return false;
    }
};

const updateByIdAtividade = async function(atividade) {
    try {
        const result = await prisma.$executeRaw`
            UPDATE tbl_atividade SET
                titulo = ${atividade.titulo},
                descricao = ${atividade.descricao},
                data_criacao = ${atividade.data_criacao},
                id_materia = ${atividade.id_materia},
                id_professor = ${atividade.id_professor},
                id_categoria = ${atividade.id_categoria}
            WHERE id_atividade = ${atividade.id_atividade}
        `;
        return result ? true : false;
    } catch (error) {
        return false;
    }
};

module.exports = {
    insertAtividade,
    selectAllAtividades,
    selectByIdAtividade,
    deleteByIdAtividade,
    updateByIdAtividade
};
