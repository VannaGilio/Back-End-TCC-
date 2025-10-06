const message = require('../../modulo/config.js')

const materiaDAO = require('../../model/DAO/materia/materiaDAO.js')
const { application } = require('express')

const inserirMateria = async function (materia, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( materia.materia == '' || materia.materia == undefined || materia.materia == null || materia.materia.length > 45 ||
                materia.cor_materia == '' || materia.cor_materia == undefined || materia.cor_materia == null || materia.cor_materia.length > 45
            ){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await materiaDAO.insertMateria(materia)
    
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

const listarMateria = async function (){
    try {
        let result = await materiaDAO.selectAllMateria()
        let dados = {}

        if(result != false || typeof (result) == 'object'){
            if(result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = result.length
                dados.materias = result

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

const buscarMateriaPorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await materiaDAO.selectByIdMateria(id)
            let dados = {}

            if(result != false || typeof (result) == 'object'){
                if(result.length > 0){
                    dados.status = true
                    dados.status_code = 200
                    dados.materias = result
    
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

const excluirMateriaPorId = async function (id) {
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0){
            return message.ERROR_REQUIRED_FIELDS
        }else{

            let select = await materiaDAO.selectByIdMateria(parseInt(id))

            if(select != false || typeof (select) == 'object'){
                if(select.length > 0){
                    let result = await materiaDAO.deleteByIdMateria(parseInt(id))

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

const atualizarMateriaPorId = async function (id, materia, contentType) {
    try {
        if(contentType == 'application/json'){
            if( id == '' || id == null || id == undefined || id.length <= 0 ||
                materia.materia == '' || materia.materia == undefined || materia.materia == null || materia.materia.length > 45 ||
                materia.cor_materia == '' || materia.cor_materia == undefined || materia.cor_materia == null || materia.cor_materia.length > 45
            ){        
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await materiaDAO.selectByIdMateria(parseInt(id))

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        materia.id_materia = parseInt(id)
                    
                        let result = await materiaDAO.updateByIdMateria(materia)

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
    inserirMateria,
    listarMateria,
    buscarMateriaPorId,
    excluirMateriaPorId,
    atualizarMateriaPorId
}