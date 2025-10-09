const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertAluno = async function(aluno){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_aluno(
            ${aluno.credencial}, 
            ${aluno.id_turma},
            ${aluno.nome}, 
            ${aluno.matricula}, 
            ${aluno.email}, 
            ${aluno.telefone}, 
            ${aluno.data_nascimento}
           );
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        console.error(error)
        return false
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

module.exports = {
    insertAluno,
    selectAllAlunos,
    selectByIdAluno
}