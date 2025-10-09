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
      }
    }))
  
    alunos.forEach(a => delete a.id_turma)
  
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

const excluirAlunoPorId = async function (id) {
  try {
      if(id == '' || id == null || id == undefined){
          return message.ERROR_REQUIRED_FIELDS
      }else{

          let select = await alunoDAO.selectByIdAluno(parseInt(id))

          if(select != false || typeof (select) == 'object'){
              if(select.length > 0){
                  let result = await alunoDAO.deleteByIdAluno(parseInt(id))

                  if(result){
                      return message.SUCCESS_DELETED_ITEM
                  }else{
                      return message.ERROR_INTERNAL_SERVER_MODEL
                  }   
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
  inserirAluno,
  listarAlunos,
  buscarAlunoPorId,
  excluirAlunoPorId
}