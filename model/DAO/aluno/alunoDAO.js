const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()
const message = require('../../../modulo/config.js')

const insertAluno = async function(aluno){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_aluno(
            ${aluno.nome}, 
            ${aluno.data_nascimento},
            ${aluno.matricula}, 
            ${aluno.telefone}, 
            ${aluno.email},
            ${aluno.id_turma}
           );
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        throw error
    }
}

const selectAllAlunos = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_aluno;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdAluno = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_aluno WHERE id_aluno = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdAluno = async function (id) {
    try {
        let sql = `delete from tbl_aluno where id_aluno = ${id};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

module.exports = {
    insertAluno,
    selectAllAlunos,
    selectByIdAluno,
    deleteByIdAluno
}