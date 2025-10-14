const message = require('../../modulo/config.js')

const categoriaDAO = require('../../model/DAO/categoria/categoriaDAO.js')
const { application } = require('express')

const inserirCategoria = async function (categoria, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( categoria.categoria == '' || categoria.categoria == undefined || categoria.categoria == null || categoria.categoria.length > 45){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await categoriaDAO.insertCategoria(categoria)
    
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

const listarCategoria = async function (){
    try {
        let result = await categoriaDAO.selectAllCategorias()
        let dados = {}

        if(result != false || typeof (result) == 'object'){
            if(result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = result.length
                dados.categorias = result

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

const buscarCategoriaPorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await categoriaDAO.selectByIdCategoria(id)
            let dados = {}

            if(result != false || typeof (result) == 'object'){
                if(result.length > 0){
                    dados.status = true
                    dados.status_code = 200
                    dados.categorias = result
    
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

const excluirCategoriaPorId = async function (id) {
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0){
            return message.ERROR_REQUIRED_FIELDS
        }else{

            let select = await categoriaDAO.selectByIdCategoria(parseInt(id))

            if(select != false || typeof (select) == 'object'){
                if(select.length > 0){
                    let result = await categoriaDAO.deleteByIdCaterogia(parseInt(id))

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

const atualizarCategoriaPorId = async function (id, categoria, contentType) {
    try {
        if(contentType == 'application/json'){
            if( id == '' || id == null || id == undefined || id.length <= 0 ||
                categoria.categoria == '' || categoria.categoria == undefined || categoria.categoria == null || categoria.categoria.length > 45 ){
                    
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await categoriaDAO.selectByIdCategoria(parseInt(id))

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        categoria.id_categoria = parseInt(id)
                    
                        let result = await categoriaDAO.updateByIdCategoria(categoria)

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
    inserirCategoria,
    listarCategoria,
    buscarCategoriaPorId,
    atualizarCategoriaPorId,
    excluirCategoriaPorId
}