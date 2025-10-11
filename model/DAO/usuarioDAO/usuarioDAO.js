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

// Busca o usuário pela credencial
const selectUserByCredencial = async function (credencial) {
    try {
        const result = await prisma.$queryRaw`
            SELECT * FROM vw_buscar_usuario_by_credencial WHERE credencial = ${credencial}
        `;

        if(result)
            return result
        else
            return false
    } catch (error) {
        console.error("Erro no DAO (selectUserByEmail):", error);
        return false;
    }
};

// Salva o token e a expiração via Stored Procedure
const generatePasswordToken = async (idUsuario, token, expirationDate) => {
    try {
        // Usa a Stored Procedure para persistir o token
        const result = await prisma.$queryRaw`
            CALL sp_gerar_token_recuperacao(${idUsuario}, ${token}, ${expirationDate})
        `;
        return result.length > 0;
    } catch (error) {
        console.error("Erro no DAO (generatePasswordToken):", error);
        return false;
    }
};

// Redefine a senha via Stored Procedure
const resetPassword = async (token, newPassword) => {
    try {
        // Usa a Stored Procedure para validar o token, resetar a senha e limpar o token.
        const result = await prisma.$queryRaw`
            CALL sp_resetar_senha(${token}, ${newPassword})
        `;
        
        if (result.length > 0 && result[0].f0 === 'SUCESSO') {
            return true;
        }else if (result.length > 0 && result[0].f0 === 'FALHA_TOKEN_INVALIDO_OU_EXPIRADO') {
            return result[0].f0
        }else {
            return false
        }
    } catch (error) {
        console.error("Erro no DAO (resetPassword):", error);
        return false;
    }
};



module.exports = {
    insertUsuario,
    selectAllUsuario,
    selectByIdUsuario,
    deleteByIdUsuario,
    updateByIdUsuario,
    loginUsuario,

    selectUserByCredencial,
    generatePasswordToken,
    resetPassword
}