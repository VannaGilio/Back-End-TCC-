const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertUsuario = async function(usuario){
    try {
        let result = await prisma.$executeRaw
        `
            EXEC inserir_usuario ${usuario.credencial}, ${usuario.senha}, ${usuario.nivel_usuario}
        `
        if(result > 0)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

module.exports = {
    insertUsuario
}