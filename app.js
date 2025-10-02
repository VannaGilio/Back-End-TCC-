/* 
   inicio projeto:

   npm install cors --save
   npm install express --save
   npm install body-parser --save
   npm install prisma --save
   npx prisma init
   npm install @prisma/client
   npx prisma migrate dev 

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

app.listen('8080', function(){
    console.log('API funcionando...')
})