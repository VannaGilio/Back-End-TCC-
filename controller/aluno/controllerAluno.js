const message = require('../../modulo/config.js')
const alunoDAO = require('../../model/DAO/aluno/alunoDAO.js')

const inserirAluno = async function (aluno, contentType) {
    try {
        if( String(contentType) == 'application/json'){
            if( aluno.credencial == '' || aluno.credencial == undefined || aluno.credencial == null || aluno.credencial.length > 12 ||
                aluno.nome == '' || aluno.nome == undefined || aluno.nome == null || aluno.nome.length > 80 ||
                aluno.data_nascimento == '' || aluno.data_nascimento == undefined || aluno.data_nascimento == null ||
                aluno.matricula == '' || aluno.matricula == undefined || aluno.matricula == null || aluno.matricula.length > 12 ||
                // aluno.matriculla != aluno.credencial ||
                aluno.telefone == '' || aluno.telefone == undefined || aluno.telefone == null || aluno.telefone.length > 14 ||
                aluno.email == '' || aluno.email == undefined || aluno.email == null || aluno.email.length > 45 ||
                aluno.id_turma == '' || aluno.id_turma == undefined || aluno.id_turma == null || aluno.id_turma.length < 0
            ){
                return message.ERROR_REQUIRED_FIELDS // 400
            }else{
                let result = await alunoDAO.insertAluno(aluno)
    
                if(result == "P2010"){
                    return message.ERROR_CONFLICT //409
                }else if(result){
                    return message.SUCCESS_CREATED_ITEM // 201
                }else{
                    return message.ERROR_INTERNAL_SERVER_MODEL //500
                }
            }
        }else{
            return message.ERROR_CONTENT_TYPE //415
        }
    } catch (error) {
        console.error(error)
        return message.ERROR_INTERNAL_SERVER_CONTROLLER // 500
    }
}

const listarAlunos = async function(){
    try {
      let result = await alunoDAO.selectAllAlunos()
  
      if (!result || !Array.isArray(result) || result.length === 0) {
        return message.ERROR_NOT_FOUND
      }
  
      let alunos = result.map(item => ({
        ...item,
        turma: {
          id_turma: item.id_turma,
          nome_turma: item.turma
        },
        usuario: {
            id_usuario: item.id_usuario,
            credencial: item.credencial
        }
      }))
  
      alunos.forEach(a => {
        delete a.id_turma
        delete a.id_usuario
        delete a.credencial 
      })
  
      let dados = {
        status: true,
        status_code: 200,
        items: alunos.length,
        alunos
      }
  
      return dados
  
    } catch (error) {
      return message.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const buscarAlunoPorId = async function(id){
    try {
      let result = await alunoDAO.selectByIdAluno(id)
  
      if (!result || result.length === 0) {
        return message.ERROR_NOT_FOUND
      }
  
      let aluno = {
        ...result[0],  
        turma: {
          id_turma: result[0].id_turma,
          turma: result[0].turma
        }
      }
  
      delete aluno.id_turma
  
      let dados = {
        status: true,
        status_code: 200,
        aluno
      }
      
      return dados
  
    } catch (error) {
      return message.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    inserirAluno,
    listarAlunos,
    buscarAlunoPorId
}