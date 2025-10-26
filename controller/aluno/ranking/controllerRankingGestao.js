const message = require('../../../modulo/config.js');
const rankingDAO = require('../../../model/DAO/aluno/ranking/rankingDAO.js'); // Ajuste o caminho

const buscarRankingGestao = async function (idGestao, idTurma, idMateria, idSemestre) {
    try {
        // Validação MANTIDA para os filtros ESSENCIAIS (Matéria é opcional)
        if (!idGestao || isNaN(idGestao) || 
            !idTurma || isNaN(idTurma) || 
            !idSemestre || isNaN(idSemestre)) {
            
            return message.ERROR_REQUIRED_FIELDS;
        }

        // idMateria é passado como 'null' se não estiver na query
        let result = await rankingDAO.selectRankingGestao(idGestao, idTurma, idMateria, idSemestre);
        let dados = {};

        if (result && Array.isArray(result) && result.length > 0) {
            
            // 🚀 CORREÇÃO DO BIGINT: Converte a coluna 'Ranking' para Number
            const rankingTratado = result.map(item => {
                return {
                    Ranking: Number(item.Ranking), // <--- Aplica Number()
                    Média: Number(item['Média']),
                    'Nome do Aluno': item['Nome do Aluno'],
                    Matéria: item.Matéria // Mantém o nome da Matéria
                };
            });
            
            dados.status = true;
            dados.status_code = 200;
            dados.items = rankingTratado.length;
            dados.ranking = rankingTratado; 

            return dados;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.error(error);
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

module.exports = {
    buscarRankingGestao
};