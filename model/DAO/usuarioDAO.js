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
            select * from buscar_usuario WHERE id_usuario = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdUsuario = async function (id) {
    try {
        let sql = `delete from tbl_usuarios where id_usuario = ${id};`

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

const updateByIdUsuario = async function (usuario) {
    try {
        let sql = `update tbl_usuarios set  credencial = '${usuario.credencial}',
                                            senha = '${usuario.senha}',
                                            nivel_usuario = '${usuario.nivel_usuario}'
                                            
                                            where id_usuario = ${usuario.id_usuario};`

        let result = await prisma.$executeRawUnsafe(sql)
        console.log(result)
        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const loginUsuario = async function(usuario){
    try {
        let result = await prisma.$queryRaw`
            CALL sp_login_usuario(${usuario.credencial}, ${usuario.senha})
        `;
        
        const rows = result[0];

        const usuarioFormatado = {
            id_usuario: rows.f0,
            credencial: rows.f1,
            senha: rows.f2,
            nivel_usuario: rows.f3,
            id_gestao: rows.f4,
            nome: rows.f5,
            email: rows.f6,
            telefone: rows.f7
          };

        if(result)
            return usuarioFormatado
        else
            return false
    } catch (error) {
        return false
    }
}


module.exports = {
    insertUsuario,
    selectAllUsuario,
    selectByIdUsuario,
    deleteByIdUsuario,
    updateByIdUsuario,
    loginUsuario
}