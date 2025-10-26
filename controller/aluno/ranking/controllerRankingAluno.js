const message = require('../../../modulo/config.js');
const rankingDAO = require('../../../model/DAO/aluno/ranking/rankingDAO.js'); // Ajuste o caminho

const buscarRankingAluno = async function (idAluno, idMateria, idSemestre) {
    try {
        // Validação obrigatória dos filtros (Aluno só pode ver se filtrar por Matéria e Semestre)
        if (!idAluno || isNaN(idAluno) || !idMateria || isNaN(idMateria) || !idSemestre || isNaN(idSemestre)) {
            return message.ERROR_REQUIRED_FIELDS;
        }

        let result = await rankingDAO.selectRankingAluno(idAluno, idMateria, idSemestre);
        let dados = {};

        if (result && result.length > 0) {

            const rankingTratado = result.map(item => {
                return {
                    Ranking: Number(item.Ranking), // <--- CONVERSÃO OBRIGATÓRIA
                    Média: Number(item['Média']), // Garante que a Média é um Number (opcional, mas bom)
                    nome: item['Nome do Aluno']
                };
            });

            dados.status = true;
            dados.status_code = 200;
            dados.items = rankingTratado.length;
            // O ranking já vem pronto e censurado do banco
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
    buscarRankingAluno
};