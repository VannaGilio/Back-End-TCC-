const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertUsuario = async function(usuario){
    try {
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

const selectAllUsuario = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from listar_usuarios;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdUsuario = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from buscar_usuario WHERE id_usuario = ${id};
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdUsuario = async function (id) {
    try {
        let sql = `delete from tbl_usuarios where id_usuario = ${id}`

        let result = await prisma.$executeRawUnsafe(sql)
        console.log(result)

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
    insertUsuario,
    selectAllUsuario,
    selectByIdUsuario,
    deleteByIdUsuario
}