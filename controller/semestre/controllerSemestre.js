const message = require('../../modulo/config.js')

const semestreDAO = require('../../model/DAO/semestre/semestreDAO.js')
const { application } = require('express')

const inserirSemestre = async function (semestre, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( semestre.semestre == '' || semestre.semestre == undefined || semestre.semestre == null || semestre.semestre.length > 45){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await semestreDAO.insertSemestre(semestre)
    
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

const listarSemestre = async function (){
    try {
        let result = await semestreDAO.selectAllSemestres()
        let dados = {}

        if(result != false || typeof (result) == 'object'){
            if(result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = result.length
                dados.semestres = result

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

const buscarSemestrePorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await semestreDAO.selectByIdSemestre(id)
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

const excluirSemestrePorId = async function (id) {
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0){
            return message.ERROR_REQUIRED_FIELDS
        }else{

            let select = await semestreDAO.selectByIdSemestre(parseInt(id))

            if(select != false || typeof (select) == 'object'){
                if(select.length > 0){
                    let result = await semestreDAO.deleteByIdSemestre(parseInt(id))

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

const atualizarSemestrePorId = async function (id, semestre, contentType) {
    try {
        if(contentType == 'application/json'){
            if( id == '' || id == null || id == undefined || id.length <= 0 ||
                semestre.semestre == '' || semestre.semestre == undefined || semestre.semestre == null || semestre.semestre.length > 45 ){
                    
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await semestreDAO.selectByIdSemestre(parseInt(id))

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        semestre.id_semestre = parseInt(id)
                    
                        let result = await semestreDAO.updateByIdSemestre(semestre)

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
    inserirSemestre,
    listarSemestre,
    buscarSemestrePorId,
    excluirSemestrePorId,
    atualizarSemestrePorId
}