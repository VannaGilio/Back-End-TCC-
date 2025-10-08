const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()
const message = require('../../../modulo/config.js')

const insertMateria = async function(materia){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_materia(${materia.materia}, ${materia.cor_materia})
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const selectAllMateria = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_materia;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdMateria = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_materia WHERE id_materia = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdMateria = async function (id) {
    try {
        let sql = `delete from tbl_materia where id_materia = ${id};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const updateByIdMateria = async function (materia) {
    try {
        let sql = `update tbl_materia set   materia = '${materia.materia}',
                                            cor_materia = '${materia.cor_materia}'
                                            
                                            where id_materia = ${materia.id_materia};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}


module.exports ={
    insertMateria,
    deleteByIdMateria,
    selectAllMateria,
    selectByIdMateria,
    updateByIdMateria
}