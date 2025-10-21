const message = require('../../../modulo/config.js')
const desempenhoAlunoDAO = require('../../../model/DAO/aluno/dashboard/desempenhoAlunoDAO.js')

const buscarDesempenhoAluno = async function (idAluno, idMateria, idSemestre) {
    try {
        if(!idAluno || isNaN(idAluno)){
            return message.ERROR_REQUIRED_FIELDS
        }else{
            let result = await desempenhoAlunoDAO.selectDesempenhoAluno(idAluno, idMateria, idSemestre)
            let dados = {}

            if(!result && !Array.isArray(result)){
                return message.ERROR_INTERNAL_SERVER_MODEL
            }

            let desempenhoMap = new Map()

            for (const item of result) {
                if(!desempenhoMap.has(item.id_materia)){
                    desempenhoMap.set(item.id_materia, {
                        aluno: {
                            id_aluno: item.id_aluno,
                            nome: item.nome
                        },
                        frequencia: {
                            frequencia: item.porcentagem_frequencia
                        },
                        materia: {
                            materia_id: item.id_materia,
                            materia: item.materia,
                        },
                        atividades: [],
                        media: item.media_materia
                    })
                }
                const materiaArray = desempenhoMap.get(item.id_materia)
                materiaArray.atividades.push({
                    atividade: item.atividade,
                    categoria: item.categoria,
                    nota: Number(item.nota)
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
    buscarDesempenhoAluno
}