const message = require('../../../modulo/config.js')
const desempenhoTurmaMateriaDAO = require('../../../model/DAO/aluno/dashboard/desempenhoTurmaMateriaDAO.js')

const buscarDesempenhoTurmaMateria = async function (idGestao, idTurma, idMateria, idSemestre) {
    try {
        if(!idGestao || isNaN(idGestao)){
            return message.ERROR_REQUIRED_FIELDS
        }else{
            let result = await desempenhoTurmaMateriaDAO.selectDesempenhoTurmaMateria(idGestao, idTurma, idMateria, idSemestre)
            let dados = {}

            if(!result && !Array.isArray(result)){
                return message.ERROR_INTERNAL_SERVER_MODEL
            }

            let desempenhoMap = new Map()

            for (const item of result) {
                const uniqueKey = `${item.id_turma}-${item.id_materia}-${item.id_semestre}`;
                
                if(!desempenhoMap.has(uniqueKey)){
                    desempenhoMap.set(uniqueKey, {
                        gestao: {
                            id_gestao: item.id_gestao,
                            nome: item.nome_gestao
                        },
                        turma: {
                            id_turma: item.id_turma,
                            turma: item.turma
                        },
                        materia: {
                            id_materia: item.id_materia, 
                            materia: item.materia
                        },
                        frequencia: {
                            frequencia_turma: item.frequencia_turma_materia,
                            total_presenca: Number(item.total_presenca), 
                            total_faltas: Number(item.total_falta),
                            total_aulas: Number(item.total_aulas)
                        },
                        media_geral: 0, 
                        atividades: []
                    })
                }
                
                const turmaMateriaObj = desempenhoMap.get(uniqueKey)

                turmaMateriaObj.atividades.push({
                    id_atividade: item.id_atividade,
                    atividade: item.atividade,
                    descricao: item.descricao_atividade, 
                    categoria: item.categoria,
                    media_turma: Number(item.media_atividade_materia)
                })
            }

            const desempenhoArray = Array.from(desempenhoMap.values()).map(turmaMateria => {
                const medias = turmaMateria.atividades.map(a => a.media_turma);
                
                if (medias.length > 0) {
                    const soma = medias.reduce((acc, curr) => acc + curr, 0);
                    const mediaCalculada = parseFloat((soma / medias.length).toFixed(2));
                    
                    turmaMateria.media_geral = mediaCalculada;
                }
                
                return turmaMateria;
            });

            if(result && result.length > 0){
                dados.status = true
                dados.status_code = 200
                dados.items = desempenhoArray.length 
                dados.desempenho = desempenhoArray

                return dados
            }else{
                return message.ERROR_NOT_FOUND
            }
        }
    } catch (error) {
        console.error(error)
        return message.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    buscarDesempenhoTurmaMateria
}