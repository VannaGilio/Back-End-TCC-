const message = require('../../modulo/config.js')

const usuarioDAO = require('../../model/DAO/usuarioDAO/usuarioDAO.js')
const { application } = require('express')

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

                let dados = {}

                if(Object.keys(result).length > 0){
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

module.exports = {
    inserirUsuario, 
    listarUsuarios,
    buscarUsuarioPorId,
    excluirUsuarioPorId,
    atualizarUsuarioPorId,
    loginUsuario
}