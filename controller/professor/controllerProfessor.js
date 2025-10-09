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

module.exports = {
    inserirProfessor
}