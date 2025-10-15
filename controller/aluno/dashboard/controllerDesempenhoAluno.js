const message = require('../../../modulo/config.js')
const desempenhoAlunoDAO = require('../../../model/DAO/aluno/dashboard/desempenhoAlunoDAO.js')

const buscarDesempenhoAluno = async function (idAluno, idMateria, idSemestre) {
    try {
        if(!idAluno || isNaN(idAluno)){
            return message.ERROR_REQUIRED_FIELDS
        }else{
            let result = await desempenhoAlunoDAO.selectDesempenhoAluno(idAluno, idMateria, idSemestre)
            let dados = {}

            if(result && Array.isArray(result)){
                if(result && result.length > 0){
                     dados.status = true
                    dados.status_code = 200
                    dados.items = result.length
                    dados.desempenho = result

                    return dados
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

module.exports = {
    buscarDesempenhoAluno
}