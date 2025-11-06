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
   npm install openai
   npm install moment
   npm install dotenv
   npm install puppeteer marked
*/

const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const path = require('path');

const dotenv = require('dotenv'); // NOVO: Para carregar variáveis de ambiente (API Keys)
const message = require('./modulo/config.js'); // NOVO: Módulo de mensagens (erros/sucesso)

// Carrega variáveis de ambiente do arquivo .env
dotenv.config(); // NOVO: Chamada de configuração

const app = express()

app.use(bodyParser.json())

app.use((request, response, next)=>{
    response.header('Access-Control-Allow-Origin', '*')
    response.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
    
    app.use(cors())
    next()
})

app.use('/public', express.static(path.join(__dirname, 'public')));

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

app.put('/v1/analytica-ai/aluno/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerAluno.atualizarAlunoPorId(id, dadosBody, contentType)

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

app.put('/v1/analytica-ai/professor/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerProfessor.atualizarProfessorPorId(id, dadosBody, contentType)

    response.status(result.status_code)
    response.json(result)
})

/*********GESTÃO*********/

const controllerGestao= require('./controller/gestao/controllerGestao.js')

app.put('/v1/analytica-ai/gestao/:id', async function (request, response) {
    let contentType = request.headers['content-type']

    let id = request.params.id

    let dadosBody = request.body

    let result = await controllerGestao.atualizarGestaoPorId(id, dadosBody, contentType)

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

/*********DESEMPENHO MATERIA TURMA*********/

const controllerDesempenhoMateriaTurma = require('./controller/aluno/dashboard/controllerDesempenhoMateriaTurma.js')

app.get('/v1/analytica-ai/desempenho/gestao/turma-materia/:idGestao', async function (request, response) {
    let idGestao = parseInt(request.params.idGestao)
    let idTurma = request.query.turma ? parseInt(request.query.turma): null
    let idMateria = request.query.materia ? parseInt(request.query.materia): null
    let idSemestre = request.query.semestre ? parseInt(request.query.semestre): null

    let result = await controllerDesempenhoMateriaTurma.buscarDesempenhoTurmaMateria(idGestao, idTurma, idMateria, idSemestre)

    response.status(result.status_code)
    response.json(result)
})

/********* RANKING ALUNO *********/
const controllerRankingAluno = require('./controller/aluno/ranking/controllerRankingAluno.js');

// Rota: /v1/analytica-ai/ranking/aluno/11?materia=4&semestre=1
app.get('/v1/analytica-ai/ranking/aluno/:idAluno', async function (request, response) {
    let idAluno = parseInt(request.params.idAluno);
    let idMateria = request.query.materia ? parseInt(request.query.materia) : null;
    let idSemestre = request.query.semestre ? parseInt(request.query.semestre) : null;

    let result = await controllerRankingAluno.buscarRankingAluno(idAluno, idMateria, idSemestre);

    response.status(result.status_code);
    response.json(result);
});

/********* RANKING PROFESSOR *********/
const controllerRankingProfessor = require('./controller/aluno/ranking/controllerRankingProfessor.js');

// Rota: /v1/analytica-ai/ranking/professor/1?turma=3&semestre=2
app.get('/v1/analytica-ai/ranking/professor/:idProfessor', async function (request, response) {
    let idProfessor = parseInt(request.params.idProfessor);
    let idTurma = request.query.turma ? parseInt(request.query.turma) : null;
    let idSemestre = request.query.semestre ? parseInt(request.query.semestre) : null;

    let result = await controllerRankingProfessor.buscarRankingProfessor(idProfessor, idTurma, idSemestre);

    response.status(result.status_code);
    response.json(result);
});

/********* RANKING GESTÃO *********/
const controllerRankingGestao = require('./controller/aluno/ranking/controllerRankingGestao.js');

// Rota: /v1/analytica-ai/ranking/gestao/1?turma=3&materia=4&semestre=2
app.get('/v1/analytica-ai/ranking/gestao/:idGestao', async function (request, response) {
    let idGestao = parseInt(request.params.idGestao);
    let idTurma = request.query.turma ? parseInt(request.query.turma) : null;
    let idMateria = request.query.materia ? parseInt(request.query.materia) : null;
    let idSemestre = request.query.semestre ? parseInt(request.query.semestre) : null;

    let result = await controllerRankingGestao.buscarRankingGestao(idGestao, idTurma, idMateria, idSemestre);

    response.status(result.status_code);
    response.json(result);
});

/********* INSIGHTS *********/ // NOVO BLOCO

const insightController = require('./controller/insights/controllerInsights.js');

/**
 * Rota para gerar insights de Aluno (POST /v1/analytica-ai/insights/aluno?materia=4&semestre=2)
 * Espera o JSON de desempenho no body e os IDs de Cache na Query.
 */
app.post('/v1/analytica-ai/insights/aluno', async function (request, response){
    let body = request.body;
    let idMateria = request.query.materia;
    let idSemestre = request.query.semestre;
    
    if (!body || !body.desempenho) {
        return response.status(400).json(message.ERROR_NO_DATA);
    }
    // O Controller precisa desses IDs como string para a chave de cache
    if (!idMateria || !idSemestre) {
        return response.status(400).json(message.ERROR_MISSING_CACHE_PARAMS);
    }

    let result = await insightController.getInsight(body, 'aluno', String(idSemestre), String(idMateria));
    
    response.status(result.status_code);
    response.json(result);
});

/**
 * Rota para gerar insights de Professor (POST /v1/analytica-ai/insights/professor?materia=4&semestre=2)
 */
app.post('/v1/analytica-ai/insights/professor', async (req, res) => {
    const body = req.body;
    const idSemestre = req.query.semestre;

    if (!body || !body.desempenho) {
        return res.status(400).json(message.ERROR_NO_DATA);
    }
    if (!idSemestre) {
        return res.status(400).json(message.ERROR_MISSING_CACHE_PARAMS);
    }

    // Controller pega idTurma do body, idMateria do body também
    const result = await insightController.getInsight(body, 'professor', String(idSemestre), undefined);

    res.status(result.status_code).json(result);
});

/**
 * Rota para gerar insights de Gestão (POST /v1/analytica-ai/insights/gestao?materia=4&semestre=2)
 */
app.post('/v1/analytica-ai/insights/gestao', async (req, res) => {
    const body = req.body;
    const idSemestre = req.query.semestre;

    if (!body || !body.desempenho) {
        return res.status(400).json(message.ERROR_NO_DATA);
    }
    if (!idSemestre) {
        return res.status(400).json(message.ERROR_MISSING_CACHE_PARAMS);
    }

    // Controller pega idTurma do body, idMateria do body também
    const result = await insightController.getInsight(body, 'gestao', String(idSemestre), undefined);

    res.status(result.status_code).json(result);
});

/**
 * Rota para gerar relatório frequência de Aluno (POST /v1/analytica-ai/relatorios/aluno?materia=4&semestre=2)
 * Espera o JSON de desempenho no body e os IDs de Cache na Query.
 */

const relatorioController = require('./controller/relatorios/controllerRelatoriosFrequencia.js');

app.post('/v1/analytica-ai/relatorios/aluno', async function (request, response) {
    const body = request.body;
    const idMateria = request.query.materia;
    const idSemestre = request.query.semestre;

    console.log("=== ROTA /relatorios/aluno chamada ===");
    console.log("query:", request.query);
    console.log("body keys:", Object.keys(request.body || {}));

    console.log('Materia:', idMateria, 'Semestre:', idSemestre);

    if (!body || !body.desempenho) {
        return response.status(400).json(message.ERROR_NO_DATA);
    }

    if (!idMateria || !idSemestre) {
        return response.status(400).json(message.ERROR_MISSING_CACHE_PARAMS);
    }

    try {
        const result = await relatorioController.getRelatorio(
            body,
            'aluno',              // tipoNivel
            'frequência',         // tipoRelatorio (ou o tipo real que quiser)
            String(idSemestre),
            String(idMateria)
        );

        response.status(result.status_code).json(result);
    } catch (error) {
        console.error("Erro na rota /relatorios/aluno:", error);
        response.status(500).json({
            status_code: 500,
            message: "Erro interno ao gerar relatório."
        });
    }
});


app.listen('8080', function(){
    console.log('API funcionando...')
})