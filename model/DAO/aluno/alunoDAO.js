const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertAluno = async function(aluno){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_aluno ('${aluno.credencial}', ${aluno.id_turma}, '${aluno.nome}', '${aluno.matricula}', '${aluno.telefone}', '${aluno.email}', '${aluno.data_nascimento}');
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        if(error.code == "P2010"){
            return error.code
        }
        return false
    }
}

const selectAllAlunos = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_aluno_turma;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdAluno = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_aluno_turma WHERE id_aluno = ${id}
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

