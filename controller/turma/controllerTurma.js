const message = require('../../modulo/config.js')

const turmaDAO = require('../../model/DAO/turma/turmaDAO.js')
const { application } = require('express')

const inserirTurma = async function (turma, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( turma.turma == '' || turma.turma == undefined || turma.turma == null || turma.turma.length > 45){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await turmaDAO.insertTurma(turma)
    
                if(result){
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

const listarTurma = async function (){
    try {
        let result = await turmaDAO.selectAllTurmas()
        let dados = {}

        if(result != false || typeof (result) == 'object'){
            if(result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = result.length
                dados.turmas = result

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

const buscarTurmaPorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await turmaDAO.selectByIdTurma(id)
            let dados = {}

            if(result != false || typeof (result) == 'object'){
                if(result.length > 0){
                    dados.status = true
                    dados.status_code = 200
                    dados.turmas = result
    
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

const excluirTurmaPorId = async function (id) {
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0){
            return message.ERROR_REQUIRED_FIELDS
        }else{

            let select = await turmaDAO.selectByIdTurma(parseInt(id))

            if(select != false || typeof (select) == 'object'){
                if(select.length > 0){
                    let result = await turmaDAO.deleteByIdTurma(parseInt(id))

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

const atualizarTurmaPorId = async function (id, turma, contentType) {
    try {
        if(contentType == 'application/json'){
            if( id == '' || id == null || id == undefined || id.length <= 0 ||
                turma.turma == '' || turma.turma == undefined || turma.turma == null || turma.turma.length > 45 ){
                    
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await turmaDAO.selectByIdTurma(parseInt(id))

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        turma.id_turma = parseInt(id)
                    
                        let result = await turmaDAO.updateByIdTurma(turma)

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

module.exports ={
    inserirTurma,
    listarTurma,
    buscarTurmaPorId,
    atualizarTurmaPorId,
    excluirTurmaPorId
}