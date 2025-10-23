const message = require('../../modulo/config.js')
const gestaoDAO = require('../../model/DAO/gestao/gestaoDAO.js')

const buscarGestaoPorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await gestaoDAO.selectByIdGestao(id)
            let dados = {}

            if(result != false || typeof (result) == 'object'){
                if(result.length > 0){
                    dados.status = true
                    dados.status_code = 200
                    dados.semestres = result
    
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

const atualizarGestaoPorId = async function (id, gestao, contentType) {
    try {
        if(contentType == 'application/json'){
            if( !id || 
                !gestao.nome || gestao.nome.length > 80 ||
                !gestao.telefone || gestao.telefone.length > 14 ||
                !gestao.email || gestao.email.length > 45 
              ){
                    
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await gestaoDAO.selectByIdGestao(parseInt(id))

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        gestao.id_gestao = parseInt(id)
                    
                        let result = await gestaoDAO.updateByIdGestao(gestao)

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

module.exports = {
    buscarGestaoPorId,
    atualizarGestaoPorId
}