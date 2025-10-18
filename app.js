/* 
   inicio projeto:

   npm install cors --save
   npm install express --save
   npm install body-parser --save
   npm install prisma --save
   npx prisma init
   npm install @prisma/client
   npx prisma migrate dev 
   npm install nodemailer

   sinc schema.prisma:

   npx prisma db pull
   npx prisma generate
*/

const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')

const app = express()

app.use(bodyParser.json())

app.use((request, response, next)=>{
    response.header('Access-Control-Allow-Origin', '*')
    response.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
    
    app.use(cors())
    next()
})

/*********USUARIO*********/

const controllerUsuario = require('./controller/usuario/controllerUsuario.js')

app.post('/v1/analytica-ai/usuarios', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerUsuario.inserirUsuario(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/usuarios', async function (request, response){
    let result = await controllerUsuario.listarUsuarios()

    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/usuarios/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerUsuario.buscarUsuarioPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.delete('/v1/analytica-ai/usuarios/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerUsuario.excluirUsuarioPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.put('/v1/analytica-ai/usuarios/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerUsuario.atualizarUsuarioPorId(id, dadosBody, contentType)

    response.status(result.status_code)
    response.json(result)
})

app.post('/v1/analytica-ai/usuarios/login', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerUsuario.loginUsuario(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.post('/v1/analytica-ai/usuarios/recuperar-senha', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    const result = await controllerUsuario.solicitarRecuperacaoSenha(body, contentType);

    response.status(result.status_code)
    response.json(result)
});

app.post('/v1/analytica-ai/usuarios/resetar-senha', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    const result = await controllerUsuario.redefinirSenha(body, contentType);

    response.status(result.status_code)
    response.json(result)
});

app.get('/v1/analytica-ai/usuarios/verificar-token/:token', async function (request, response){
    let token = request.params.token

    let result = await controllerUsuario.verificarExistenciaToken(token)

    response.status(result.status_code)
    response.json(result)
})

/*********SEMESTRE*********/

const controllerSemestre = require('./controller/semestre/controllerSemestre.js')

app.post('/v1/analytica-ai/semestre', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerSemestre.inserirSemestre(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/semestre', async function (request, response){
    let result = await controllerSemestre.listarSemestre()

    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/semestre/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerSemestre.buscarSemestrePorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.delete('/v1/analytica-ai/semestre/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerSemestre.excluirSemestrePorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.put('/v1/analytica-ai/semestre/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerSemestre.atualizarSemestrePorId(id, dadosBody, contentType)

    response.status(result.status_code)
    response.json(result)
})

/*********CATEGORIA*********/

const controllerCategoria= require('./controller/categoria/controllerCategoria.js')

app.post('/v1/analytica-ai/categoria', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerCategoria.inserirCategoria(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/categoria', async function (request, response){
    let result = await controllerCategoria.listarCategoria()

    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/categoria/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerCategoria.buscarCategoriaPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.delete('/v1/analytica-ai/categoria/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerCategoria.excluirCategoriaPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.put('/v1/analytica-ai/categoria/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerCategoria.atualizarCategoriaPorId(id, dadosBody, contentType)

    response.status(result.status_code)
    response.json(result)
})

/*********TURMA*********/

const controllerTurma= require('./controller/turma/controllerTurma.js')

app.post('/v1/analytica-ai/turma', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerTurma.inserirTurma(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/turma', async function (request, response){
    let result = await controllerTurma.listarTurma()

    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/turma/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerTurma.buscarTurmaPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.delete('/v1/analytica-ai/turma/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerTurma.excluirTurmaPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.put('/v1/analytica-ai/turma/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerTurma.atualizarTurmaPorId(id, dadosBody, contentType)

    response.status(result.status_code)
    response.json(result)
})

/*********MATERIA*********/

const controllerMateria= require('./controller/materia/controllerMateria.js')

app.post('/v1/analytica-ai/materia', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerMateria.inserirMateria(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/materia', async function (request, response){
    let result = await controllerMateria.listarMateria()

    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/materia/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerMateria.buscarMateriaPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.delete('/v1/analytica-ai/materia/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerMateria.excluirMateriaPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.put('/v1/analytica-ai/materia/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerMateria.atualizarMateriaPorId(id, dadosBody, contentType)

    response.status(result.status_code)
    response.json(result)
})

/*********ALUNO*********/

const controllerAluno= require('./controller/aluno/controllerAluno.js')

app.post('/v1/analytica-ai/aluno', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerAluno.inserirAluno(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/alunos', async function (request, response){
    let result = await controllerAluno.listarAlunos()

    response.status(result.status_code)
    response.json(result)
})

app.get('/v1/analytica-ai/aluno/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerAluno.buscarAlunoPorId(id)

    response.status(result.status_code)
    response.json(result)
})

app.delete('/v1/analytica-ai/aluno/:id', async function (request, response){
    let id = request.params.id

    let result = await controllerAluno.excluirAlunoPorId(id)

    response.status(result.status_code)
    response.json(result)
})


/*********PROFESSOR*********/

const controllerProfessor= require('./controller/professor/controllerProfessor.js')

app.post('/v1/analytica-ai/professor', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await controllerProfessor.inserirProfessor(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

/*********DESEMPENHO ALUNO*********/

const controllerDesempenhoAluno = require('./controller/aluno/dashboard/controllerDesempenhoAluno.js')

app.get('/v1/analytica-ai/desempenho/aluno/:idAluno', async function (request, response) {
    let idAluno = parseInt(request.params.idAluno)
    let idMateria = request.query.materia ? parseInt(request.query.materia): null
    let idSemestre = request.query.semestre ? parseInt(request.query.semestre): null

    let result = await controllerDesempenhoAluno.buscarDesempenhoAluno(idAluno, idMateria, idSemestre)

    response.status(result.status_code)
    response.json(result)
})

/*********DESEMPENHO TURMA*********/

const controllerDesempenhoTurma = require('./controller/aluno/dashboard/controllerDesempenhoTurma.js')

app.get('/v1/analytica-ai/desempenho/turma/:idProfessor', async function (request, response) {
    let idProfessor = parseInt(request.params.idProfessor)
    let idTurma = request.query.turma ? parseInt(request.query.turma): null
    let idSemestre = request.query.semestre ? parseInt(request.query.semestre): null

    let result = await controllerDesempenhoTurma.buscarDesempenhoTurma(idProfessor, idTurma, idSemestre)

    response.status(result.status_code)
    response.json(result)
})

app.listen('8080', function(){
    console.log('API funcionando...')
})