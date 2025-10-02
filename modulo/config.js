const ERROR_REQUIRED_FIELDS = {status: false, status_code: 400, message: "Não foi possivel realizar a requisisção, pois existem campos obrigatorios que não foram preenchidos ou não atendem a quantidade de caracteristicas"}
const ERROR_INTERNAL_SERVER = {status: false, status_code: 500, message: "Devido a erros internos no servidor, não foi possivel processar a requisição!!!"}
const ERROR_INTERNAL_SERVER_MODEL = {status: false, status_code: 500, message: "Devido a erros internos no servidor da MODEL, não foi possivel processar a requisição!!!"}
const ERROR_INTERNAL_SERVER_CONTROLLER = {status: false, status_code: 500, message: "Devido a erros internos no servidor da CONTROLLER, não foi possivel processar a requisição!!!"}
const ERROR_CONTENT_TYPE = {status: false, status_code: 415, message: "Não foi possivel processar a requisição, pois, o tipo de dado encaminhado não é processado pelo servidor. Favor encaminhar dados apenas no formato JSON"}
const ERROR_NOT_FOUND = {status: false, status_code: 404, message: "Não foram encontrados itens de retorno"}
const ERROR_CONFLICT = {status: false, status_code: 409, message: "Usuário já existe"}

const SUCCESS_CREATED_ITEM = {status: true, status_code: 201, message: "Item criado com sucesso!!!"}
const SUCCESS_DELETED_ITEM = {status: true, status_code: 200, message: "Item excluído com sucesso!!!"}
const SUCCESS_UPDATED_ITEM = {status: true, status_code: 200, message: "Item atualizado com sucesso!!"}

module.exports = {
    ERROR_REQUIRED_FIELDS,
    ERROR_INTERNAL_SERVER,
    SUCCESS_CREATED_ITEM,
    ERROR_INTERNAL_SERVER_CONTROLLER,
    ERROR_INTERNAL_SERVER_MODEL,
    ERROR_CONTENT_TYPE,
    ERROR_NOT_FOUND,
    SUCCESS_DELETED_ITEM,
    SUCCESS_UPDATED_ITEM,
    ERROR_CONFLICT
}