const message = require('../../modulo/config.js')
const alunoDAO = require('../../model/DAO/aluno/alunoDAO.js')

const inserirAluno = async function (aluno, contentType) {
  try {
      if( String(contentType).toLowerCase() == 'application/json'){
          if( !aluno.credencial || aluno.credencial.length > 11 ||
              !aluno.nome || aluno.nome.length > 80 ||
              !aluno.data_nascimento ||
              !aluno.matricula || aluno.matricula.length > 11 ||
              !aluno.telefone || aluno.telefone.length > 14 ||
              !aluno.email || aluno.email.length > 45 ||
              !aluno.id_turma
            ){
              return message.ERROR_REQUIRED_FIELDS // 400
            }else{
              if(aluno.credencial !== aluno.matricula){
                return message.ERROR_CREDENTIAL_INCOMPATIBLE
              }

              let result = await alunoDAO.insertAluno(aluno)
              
              switch (result) {
                case "EMAIL_CONFLICT":
                  return message.EMAIL_CONFLICT
                case "CREDENTIAL_CONFLICT":
                  return message.CREDENTIAL_CONFLICT
                case true:
                  return message.SUCCESS_ALUNO_CREATED
                default:
                  return message.ERROR_INTERNAL_SERVER_MODEL
              }
            }
      }else{
          return message.ERROR_CONTENT_TYPE //415
      }
  } catch (error) {
      return message.ERROR_INTERNAL_SERVER_CONTROLLER // 500
  }
}

module.exports = {
    inserirAluno
}