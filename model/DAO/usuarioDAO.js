const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertUsuario = async function(usuario){
    try {

        console.log(usuario)

        let result = await prisma.$executeRaw`
            CALL inserir_usuario(${usuario.credencial}, ${usuario.senha}, ${usuario.nivel_usuario})
        `;
        
        if(result > 0)
            return true
        else
            return false
    } catch (error) {
        console.error(error)
        return false
    }
}

module.exports = {
    insertUsuario
}