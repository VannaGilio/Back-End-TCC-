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
module.exports = {
    insertAluno
}