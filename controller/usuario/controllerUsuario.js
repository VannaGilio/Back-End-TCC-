const message = require('../../modulo/config.js')

const usuarioDAO = require('../../model/DAO/usuarioDAO/usuarioDAO.js')
const { application } = require('express')

//Import das controllerss
const controllerTurma = require('../turma/controllerTurma.js')

const crypto = require('crypto');
const nodeMailer = require('../../utils/nodeMailer.js');

const inserirUsuario = async function (usuario, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( usuario.credencial == '' || usuario.credencial == undefined || usuario.credencial == null || usuario.credencial.length > 11 ||
                usuario.senha == '' || usuario.senha == undefined || usuario.senha == null || usuario.senha.length > 20 || usuario.senha.length < 8 ||
                // usuario.nivel_usuario == '' || usuario.nivel_usuario == undefined || usuario.nivel_usuario == null || 
                usuario.nivel_usuario != 'aluno' && usuario.nivel_usuario != 'professor' && usuario.nivel_usuario != 'gestão'
            ){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await usuarioDAO.insertUsuario(usuario)
    
                if(result == "P2010"){
                    return message.ERROR_CONFLICT //409
                }else if(result){
                    return message.SUCCESS_CREATED_ITEM // 201
                }else{
                    return message.ERROR_INTERNAL_SERVER_MODEL //500
                }
            }
        }else{
            return message.ERROR_CONTENT_TYPE //415
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER // 500
    }
}

const listarUsuarios = async function (){
    try {
        let result = await usuarioDAO.selectAllUsuario()
        let dados = {}

        if(result != false || typeof (result) == 'object'){
            if(result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = result.length
                dados.usuarios = result

                return dados
            }else{
                return message.ERROR_NOT_FOUND //404
            }
        }else{
            return message.ERROR_INTERNAL_SERVER_MODEL //500
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

const buscarUsuarioPorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await usuarioDAO.selectByIdUsuario(id)
            let dados = {}

            if(result != false || typeof (result) == 'object'){
                if(result.length > 0){
                    dados.status = true
                    dados.status_code = 200
                    dados.usuarios = result
    
                    return dados
                
                }else{
                    return message.ERROR_NOT_FOUND //404
                }
            }else{
                return message.ERROR_INTERNAL_SERVER_MODEL //500
            }
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

const excluirUsuarioPorId = async function (id) {
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0){
            return message.ERROR_REQUIRED_FIELDS
        }else{

            let select = await usuarioDAO.selectByIdUsuario(parseInt(id))

            if(select != false || typeof (select) == 'object'){
                if(select.length > 0){
                    let result = await usuarioDAO.deleteByIdUsuario(parseInt(id))

                    if(result){
                        return message.SUCCESS_DELETED_ITEM
                    }else{
                        return message.ERROR_INTERNAL_SERVER_MODEL
                    }   
                }else{
                    return message.ERROR_NOT_FOUND
                }
            }else{
                return message.ERROR_INTERNAL_SERVER_MODEL
            }
        } 
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarUsuarioPorId = async function (id, usuario, contentType) {
    try {
        if(contentType == 'application/json'){
            if( id == '' || id == null || id == undefined || id.length <= 0 ||
                usuario.credencial == '' || usuario.credencial == undefined || usuario.credencial == null || usuario.credencial.length > 11 ||
                usuario.senha == '' || usuario.senha == undefined || usuario.senha == null || usuario.senha.length > 20 && usuario.senha.length < 8 ||
                usuario.nivel_usuario != 'aluno' && usuario.nivel_usuario != 'professor' && usuario.nivel_usuario != 'gestão'){
                    
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await usuarioDAO.selectByIdUsuario(parseInt(id))

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        usuario.id_usuario = parseInt(id)
                    
                        let result = await usuarioDAO.updateByIdUsuario(usuario)

                        if(result){
                            return message.SUCCESS_UPDATED_ITEM
                        }else{
                            return message.ERROR_INTERNAL_SERVER_MODEL
                        }
                    }else{
                        return message.ERROR_NOT_FOUND
                    }
                }else{
                    return message.ERROR_INTERNAL_SERVER_MODEL
                }
            } 
        }else{
            return message.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const loginUsuario = async function (usuario, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( usuario.credencial == '' || usuario.credencial == undefined || usuario.credencial == null || usuario.credencial.length > 11 ||
                usuario.senha == '' || usuario.senha == undefined || usuario.senha == null || usuario.senha.length > 20 && usuario.senha.length < 8
            ){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await usuarioDAO.loginUsuario(usuario)

                const dadosTurma = await controllerTurma.buscarTurmaPorId(result.id_turma)

                if(Object.keys(result).length > 0){
                    const turma = {
                        id_turma: dadosTurma.turmas[0].id_turma,
                        turma: dadosTurma.turmas[0].turma
                    }

                    result.turma = turma
                    delete result.id_turma

                    let dados = {}


                    dados.status = true
                    dados.status_code = 200
                    dados.items = result.length
                    dados.usuario = result
                    
                    return dados
                }else{
                    return message.ERROR_NOT_FOUND
                }
            }
        }else{
            return message.ERROR_CONTENT_TYPE //415
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER // 400
    }
}

const solicitarRecuperacaoSenha = async function (dadosCredencial, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE; 
        }
        const credencial = dadosCredencial.credencial

        if (!credencial || credencial === '' || credencial.length > 15) {
            return { status: false, status_code: 400, message: 'A credencial é obrigatória e deve ter um formato válido.' };
        }

        const user = await usuarioDAO.selectUserByCredencial(credencial);

        if (user.length <= 0) {
            let dados = {};
            dados.status = false;
            dados.status_code = 404;
            dados.message = 'Credencial inválida. Verifique-a e tente novamente.';
            return dados;
        }

        const idUsuario = user[0].id_usuario;

        const token = crypto.randomBytes(32).toString('hex');

        const expirationDate = new Date();
        expirationDate.setHours(expirationDate.getHours() + 1);
        const mysqlDateTime = expirationDate.toISOString().slice(0, 19).replace('T', ' ');

        const tokenSaved = await usuarioDAO.generatePasswordToken(idUsuario, token, mysqlDateTime);

        if (!tokenSaved) {
            return { status: false, status_code: 500, message: 'Erro ao tentar gerar o e-mail, tente novamente mais tarde.' };
        }


        const emailSent = await nodeMailer.sendPasswordResetEmail(user[0].email, token);

        let dados = {};
        if (emailSent) {
            dados.status = true;
            dados.status_code = 200;
            dados.message = 'Link de redefinição enviado para o seu e-mail.';
            return dados;
        } else {
            await usuarioDAO.generatePasswordToken(idUsuario, null, null);
            return { status: false, status_code: 500, message: 'Erro ao enviar o e-mail de redefinição.' };
        }

    } catch (error) {
        console.error('Erro na controller solicitarRecuperacaoSenha:', error);
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const redefinirSenha = async function (dadosRedefinicao, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE;
        }

        const token = dadosRedefinicao.token
        const novaSenha = dadosRedefinicao.nova_senha

        if (!token || token === '' || !novaSenha || novaSenha === '') {
            return { status: false, status_code: 400, message: 'Token e nova senha são obrigatórios.' };
        }

        if (novaSenha.length < 4 || novaSenha.length > 20) {
            return { status: false, status_code: 400, message: 'A senha deve ter entre 4 e 20 caracteres.' };
        }

        const resetStatus = await usuarioDAO.resetPassword(token, novaSenha);

        if (resetStatus === true) {
            let dados = {};

            dados.status = true;
            dados.status_code = 200;
            dados.message = 'Senha redefinida com sucesso! Você já pode fazer login.';
            return dados; 
            
        } else if (resetStatus === 'FALHA_TOKEN_INVALIDO_OU_EXPIRADO') {
            return { 
                status: false, 
                status_code: 401, 
                message: 'Token inválido ou expirado. Por favor, solicite uma nova recuperação.' 
            };
            
        } else {
            return { status: false, status_code: 500, message: `Falha na redefinição de senha: ${resetStatus}` };
        }

    } catch (error) {
        console.error('Erro na controller redefinirSenha:', error);
        return message.ERROR_INTERNAL_SERVER_CONTROLLER; 
    }
};

module.exports = {
    inserirUsuario, 
    listarUsuarios,
    buscarUsuarioPorId,
    excluirUsuarioPorId,
    atualizarUsuarioPorId,
    loginUsuario,

    solicitarRecuperacaoSenha,
    redefinirSenha
}