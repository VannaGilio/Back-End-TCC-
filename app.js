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

const usuarioDAO = require('./model/DAO/usuarioDAO.js')


app.post('/v1/analytica-ai/cadastro-usuario', async function (request, response){
    let contentType = request.headers['content-type']
    let body =  request.body

    let result = await usuarioDAO.insertUsuario(body, contentType)
    
    response.status(result.status_code)
    response.json(result)
})

app.listen('8080', function(){
    console.log('API funcionando...')
})