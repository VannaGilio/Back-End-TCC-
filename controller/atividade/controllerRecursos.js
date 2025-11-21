const recursosDAO = require('../../model/DAO/atividade/recursosDAO.js');
const message = require('../../modulo/config.js');

const inserirRecurso = async function(recurso, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE;
        }
        if (!recurso.titulo || !recurso.data_criacao || !recurso.id_materia || !recurso.id_professor || !recurso.id_turma || !recurso.id_semestre || !recurso.link_criterio) {
            return message.ERROR_REQUIRED_FIELDS;
        }
        let result = await recursosDAO.insertRecurso(recurso);
        if (result) return message.SUCCESS_CREATED_ITEM;
        else return message.ERROR_INTERNAL_SERVER_MODEL;
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const listarRecursos = async function() {
    try {
        let result = await recursosDAO.selectAllRecursos();
        if (result && typeof result === 'object' && result.length > 0) {
            return {
                status: true,
                status_code: 200,
                recursos: result
            };
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const buscarRecursoPorId = async function(id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_REQUIRED_FIELDS;
        let result = await recursosDAO.selectByIdRecurso(id);
        if (result && result.length > 0) {
            return {
                status: true,
                status_code: 200,
                recurso: result[0]
            };
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const buscarRecursosAluno = async function(idAluno, idMateria, idSemestre) {
    try {
        if (!idAluno || isNaN(idAluno)) {
            return message.ERROR_REQUIRED_FIELDS;
        }

        let result = await recursosDAO.selectRecursosAluno(idAluno, idMateria, idSemestre);

        if (result && typeof result === 'object' && result.length > 0) {
            return {
                status: true,
                status_code: 200,
                items: result.length,
                recursos: result
            };
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const atualizarRecursoPorId = async function(id, recurso, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') return message.ERROR_CONTENT_TYPE;
        if (!id || isNaN(id)) return message.ERROR_REQUIRED_FIELDS;
        if (!recurso.titulo || !recurso.data_criacao || !recurso.id_materia || !recurso.id_professor || !recurso.id_turma || !recurso.id_semestre || !recurso.link_criterio) {
            return message.ERROR_REQUIRED_FIELDS;
        }
        recurso.id_recursos = parseInt(id);
        let select = await recursosDAO.selectByIdRecurso(id);
        if (select && select.length > 0) {
            let result = await recursosDAO.updateByIdRecurso(recurso);
            if (result) return message.SUCCESS_UPDATED_ITEM;
            else return message.ERROR_INTERNAL_SERVER_MODEL;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER;
    }
};

const excluirRecursoPorId = async function(id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_REQUIRED_FIELDS;
        let select = await recursosDAO.selectByIdRecurso(id);
        if (select && select.length > 0) {
            let result = await recursosDAO.deleteByIdRecurso(id);
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
    inserirRecurso,
    listarRecursos,
    buscarRecursoPorId,
    buscarRecursosAluno,
    atualizarRecursoPorId,
    excluirRecursoPorId
};
