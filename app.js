/* 
   inicio projeto:

   npm install cors --save
   npm install express --save
   npm install body-parser --save
   npm install prisma --save
   npx prisma init --save
   npm install @prisma/client --save
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

const controllerUsuario = require('./controller/controllerUsuario.js')

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

app.listen('8080', function(){
    console.log('API funcionando...')
})