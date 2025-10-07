const message = require('../../modulo/config.js')
const alunoDAO = require('../../model/DAO/aluno/alunoDAO.js')
const controllerUsuario = require('../../controller/usuario/controllerUsuario.js')
const controllerTurma = require('../../controller/turma/controllerTurma.js')

const listarAlunos = async function () {
    try {
        let dadosAluno = {}
        let resultAluno = await alunoDAO.selectAllAlunos()

        if (resultAluno != false && typeof(resultAluno) == 'object') {
            if (resultAluno.length > 0) {
                dadosAluno.status = true
                dadosAluno.status_code = 200
                dadosAluno.items = resultAluno.length
                dadosAluno.alunos = resultAluno

                // 🔁 Aqui entra o for...of
                for (const itemAluno of resultAluno) {
                    // Busca o usuário vinculado ao aluno
                    let dadosUsuario = await controllerUsuario.buscarUsuario(itemAluno.id_usuario)
                    itemAluno.usuario = dadosUsuario.usuario
                    delete itemAluno.id_usuario

                    // Busca a turma vinculada ao aluno
                    let dadosTurma = await controllerTurma.buscarTurma(itemAluno.id_turma)
                    itemAluno.turma = dadosTurma.turma
                    delete itemAluno.id_turma
                }

                return dadosAluno
            } else {
                return message.ERROR_NOT_FOUND // 404
            }
        } else {
            return message.ERROR_INTERNAL_SERVER_MODEL // 500
        }
    } catch (error) {
        console.error(error)
        return message.ERROR_INTERNAL_SERVER_CONTROLLER // 500
    }
}

module.exports = {
    listarAlunos
}