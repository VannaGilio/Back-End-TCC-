const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()
const message = require('../../../modulo/config.js')

const insertUsuario = async function(usuario){
        try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_usuario(${usuario.credencial}, ${usuario.senha}, ${usuario.nivel_usuario})
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

const selectAllUsuario = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_usuarios;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdUsuario = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_usuarios WHERE id_usuario = ${id}
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

        if(result)
            return true
        else
            return false
    } catch (error) {
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
        `
        if (!result || result.length === 0) {
            return false;
        }

        const rows = result[0];

        const nivel_usuario = String(rows.f3).toLowerCase()

        let usuarioFormatado = {};

        if (nivel_usuario === 'aluno') {
            usuarioFormatado = {
                id_usuario: rows.f0,
                credencial: rows.f1,
                senha: rows.f2,
                nivel_usuario: nivel_usuario,
                id_aluno: rows.f4,
                nome: rows.f5, 
                email: rows.f6,
                telefone: rows.f7,
                data_nascimento: rows.f8,
                matricula: rows.f9,
                id_turma: rows.f10,
            }
        } else if (nivel_usuario === 'professor') {
            usuarioFormatado = {
                id_usuario: rows.f0,
                credencial: rows.f1, 
                senha: rows.f2,
                nivel_usuario: nivel_usuario,
                id_professor: rows.f4,
                nome: rows.f5, 
                email: rows.f6,
                telefone: rows.f7,
                data_nascimento: rows.f8
            }
        } else if (nivel_usuario === 'gestão') {
            usuarioFormatado = {
                id_usuario: rows.f0,
                credencial: rows.f1,
                senha: rows.f2, 
                nivel_usuario: nivel_usuario,
                id_gestao: rows.f4,
                nome: rows.f5,
                email: rows.f6,
                telefone: rows.f7
            }
        }
        
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