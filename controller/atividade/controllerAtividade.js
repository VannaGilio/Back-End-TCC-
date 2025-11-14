const atividadeDAO = require('../../model/DAO/atividade/atividadeDAO.js');
const message = require('../../modulo/config.js'); // ajuste conforme seu projeto

const inserirAtividade = async function(atividade, contentType) {
    try {
        if (String(contentType).toLowerCase() === 'application/json') {
            if (!atividade.titulo || !atividade.data_criacao || !atividade.id_materia || !atividade.id_professor || !atividade.id_categoria) {
                return message.ERROR_REQUIRED_FIELDS
            }
            let result = await atividadeDAO.insertAtividade(atividade);
            if (result) return message.SUCCESS_CREATED_ITEM;
            else return message.ERROR_INTERNAL_SERVER_MODEL;
        } else {
            return message.ERROR_CONTENT_TYPE;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const listarAtividades = async function() {
    try {
        let result = await atividadeDAO.selectAllAtividades();
        if (result && typeof result === 'object' && result.length > 0) {
            return {
                status: true,
                status_code: 200,
                atividades: result
            };
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const buscarAtividadePorId = async function(id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_REQUIRED_FIELDS;
        let result = await atividadeDAO.selectByIdAtividade(id);
        if (result && result.length > 0) {
            return {
                status: true,
                status_code: 200,
                atividade: result[0]
            };
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const atualizarAtividadePorId = async function(id, atividade, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') return message.ERROR_CONTENT_TYPE;
        if (!id || isNaN(id)) return message.ERROR_REQUIRED_FIELDS;
        if (!atividade.titulo || !atividade.data_criacao || !atividade.id_materia || !atividade.id_professor || !atividade.id_categoria) {
            return message.ERROR_REQUIRED_FIELDS;
        }
        atividade.id_atividade = parseInt(id);
        let select = await atividadeDAO.selectByIdAtividade(id);
        if (select && select.length > 0) {
            let result = await atividadeDAO.updateByIdAtividade(atividade);
            if (result) return message.SUCCESS_UPDATED_ITEM;
            else return message.ERROR_INTERNAL_SERVER_MODEL;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const excluirAtividadePorId = async function(id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_REQUIRED_FIELDS;
        let select = await atividadeDAO.selectByIdAtividade(id);
        if (select && select.length > 0) {
            let result = await atividadeDAO.deleteByIdAtividade(id);
            if (result) return message.SUCCESS_DELETED_ITEM;
            else return message.ERROR_INTERNAL_SERVER_MODEL;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

module.exports = {
    inserirAtividade,
    listarAtividades,
    buscarAtividadePorId,
    atualizarAtividadePorId,
    excluirAtividadePorId
};
