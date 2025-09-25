// Exportando status code
const message = require('../modulo/config.js')

// Exportando DAO 
const usuarioDAO = require('../model/DAO/usuarioDAO.js')

const inserirUsuario = async function (usuario, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( usuario.credencial == '' || usuario.credencial == undefined || usuario.credencial == null || usuario.credencial.length > 11 ||
                usuario.senha == '' || usuario.senha == undefined || usuario.senha == null || usuario.senha.length > 20 && usuario.senha.length < 8 ||
                // usuario.nivel_usuario == '' || usuario.nivel_usuario == undefined || usuario.nivel_usuario == null || 
                usuario.nivel_usuario != 'aluno' && usuario.nivel_usuario != 'professor' && usuario.nivel_usuario != 'gestão'
            ){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await usuarioDAO.insertUsuario(usuario)
    
                if(result){
                    return message.SUCCESS_CREATED_ITEM // 201
                }else{
                    return message.ERROR_INTERNAL_SERVER_MODEL //201
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
    inserirUsuario
}