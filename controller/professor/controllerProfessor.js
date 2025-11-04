const message = require('../../modulo/config.js')
const professorDAO = require('../../model/DAO/professor/professorDAO.js')

const inserirProfessor = async function (professor, contentType) {
    try {
        if( String(contentType).toLowerCase() == 'application/json'){
            if( !professor.credencial || professor.credencial.length > 11 ||
                !professor.nome || professor.nome.length > 80 ||
                !professor.data_nascimento ||
                !professor.telefone || professor.telefone.length > 14 ||
                !professor.email || professor.email.length > 45 
                ){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await professorDAO.insertProfessor(professor)

                switch (result) {
                    case value:
                        
                        break;
                
                    default:
                        break;
                }
                if(result)
                    return message.SUCCESS_PROFESSOR_CREATED
                else
                    return message.ERROR_INTERNAL_SERVER_MODEL
            }
        }else{
            return message.ERROR_CONTENT_TYPE
        }
    } catch (error) {
      return message.ERROR_INTERNAL_SERVER_CONTROLLER // 500
    }
}

const buscarProfessorPorId = async function (id){
    try {
        if(id == '' || id == null || id == undefined || id.length <= 0 || isNaN(id)){
            return message.ERROR_REQUIRED_FIELDS //400
        }else{
            let result = await professorDAO.selectByIdProfessor(id)
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

const atualizarProfessorPorId = async function (id, professor, contentType) {
    try {
        if(contentType == 'application/json'){
            if( !id || 
                !professor.nome || professor.nome.length > 80 ||
                !professor.telefone || professor.telefone.length > 14 ||
                !professor.email || professor.email.length > 45 
              ){
                return message.ERROR_REQUIRED_FIELDS
            }else{
                let select = await professorDAO.selectByIdProfessor(parseInt(id))

                console.log(professor)

                if (select != false || typeof (select) == 'object') {
                    if (select.length > 0) {
                        professor.id_professor = parseInt(id)
                    
                        let result = await professorDAO.updateByIdProfessor(professor)

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
    inserirProfessor,
    atualizarProfessorPorId,
    buscarProfessorPorId
}