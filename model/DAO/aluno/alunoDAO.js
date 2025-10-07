const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertAluno = async function(aluno){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_aluno(${aluno.aluno})
        `

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

module.exports = {
    insertAluno
}