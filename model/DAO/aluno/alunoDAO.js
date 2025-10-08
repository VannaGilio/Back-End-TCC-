const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertAluno = async function(aluno) {
    try {
        await prisma.$executeRawUnsafe(
            `CALL sp_inserir_aluno(?, ?, ?, ?, ?, ?, ?)`,
            aluno.credencial,
            aluno.id_turma,
            aluno.nome,
            aluno.matricula,
            aluno.telefone,
            aluno.email,
            aluno.data_nascimento
        );
        return "SUCCESS";
    } catch (error) {
        console.error(error);

        if(error.code === "P2002") {
            // violação de UNIQUE
            if(error.meta?.target?.includes("email")) return "EMAIL_CONFLICT";
            if(error.meta?.target?.includes("credencial")) return "CREDENTIAL_CONFLICT";
            return "CONFLICT";
        }

        if(error.code === "P2010" || error.message.includes("Esse usuário não existe")) {
            return "USER_NOT_FOUND";
        }

        if(error.message.includes("Essa turma não existe")) {
            return "TURMA_NOT_FOUND";
        }

        return "UNKNOWN_ERROR";
    }
}

module.exports = {
    insertAluno
}

