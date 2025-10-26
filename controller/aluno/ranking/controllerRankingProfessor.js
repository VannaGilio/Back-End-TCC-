const message = require('../../../modulo/config.js');
const rankingDAO = require('../../../model/DAO/aluno/ranking/rankingDAO.js'); // Ajuste o caminho

const buscarRankingProfessor = async function (idProfessor, idTurma, idSemestre) {
    try {
        // Validação obrigatória dos filtros
        if (!idProfessor || isNaN(idProfessor) || 
            !idTurma || isNaN(idTurma) ||
            !idSemestre || isNaN(idSemestre)) {
            
            return message.ERROR_REQUIRED_FIELDS;
        }

        let result = await rankingDAO.selectRankingProfessor(idProfessor, idTurma, idSemestre);
        let dados = {};

        if (result && Array.isArray(result) && result.length > 0) {
            
            // 🚀 CORREÇÃO DO BIGINT: Converte a coluna 'Ranking' para Number
            const rankingTratado = result.map(item => {
                return {
                    Ranking: Number(item.Ranking), // <--- Aplica Number() para evitar TypeError
                    Média: Number(item['Média']), // Boa prática para garantir que a Média é um Number
                    'Nome do Aluno': item['Nome do Aluno']
                };
            });
            
            dados.status = true;
            dados.status_code = 200;
            dados.items = rankingTratado.length;
            dados.ranking = rankingTratado; // Retorna o array já tratado

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
    buscarRankingProfessor
};