const message = require('../../../modulo/config.js')
const desempenhoTurmaDAO = require('../../../model/DAO/aluno/dashboard/desempenhoTurmaDAO.js')

const buscarDesempenhoTurma = async function (idProfessor, idTurma, idSemestre) {
    try {
        if(!idProfessor || isNaN(idProfessor)){
            return message.ERROR_REQUIRED_FIELDS
        }else{
            let result = await desempenhoTurmaDAO.selectDesempenhoTurma(idProfessor, idTurma, idSemestre)
            let dados = {}

            if(!result && !Array.isArray(result)){
                return message.ERROR_INTERNAL_SERVER_MODEL
            }

            let desempenhoMap = new Map()

            for (const item of result) {
                if(!desempenhoMap.has(item.id_turma)){
                    desempenhoMap.set(item.id_turma, {
                        professor: {
                            id_professor: item.id_professor,
                            nome: item.nome_professor
                        },
                        turma: {
                            id_turma: item.id_turma,
                            turma: item.turma
                        },
                        frequencia: {
                            frequencia_turma: item.frequencia_turma
                        },
                        media_turma: Number(item.media_geral_professor),
                        atividades: []
                    })
                }
                const materiaArray = desempenhoMap.get(item.id_turma)
                materiaArray.atividades.push({
                    atividade: item.atividade,
                    categoria: item.categoria,
                    media_atividade: Number(item.media_atividade)
                })
            }

            const desempenhoArray = Array.from(desempenhoMap.values())

            if(result && result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = result.length
                dados.desempenho = desempenhoArray

                return dados

        
            }else{
                return message.ERROR_NOT_FOUND
            }
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    buscarDesempenhoTurma
}