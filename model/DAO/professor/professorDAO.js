const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertProfessor = async function(aluno){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_professor(
            ${aluno.credencial}, 
            ${aluno.nome}, 
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
    insertProfessor
}