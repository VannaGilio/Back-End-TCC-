const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()
const message = require('../../../modulo/config.js')

const insertSemestre = async function(semestre){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_semestre(${semestre.semestre})
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const selectAllSemestres = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_semestre;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdSemestre = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_semestre WHERE id_semestre = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdSemestre = async function (id) {
    try {
        let sql = `delete from tbl_semestre where id_semestre = ${id};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const updateByIdSemestre = async function (semestre) {
    try {
        let sql = `update tbl_semestre set  semestre = '${semestre.semestre}'
                                            
                                            where id_semestre = ${semestre.id_semestre};`

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
    insertSemestre,
    selectAllSemestres,
    selectByIdSemestre,
    deleteByIdSemestre,
    updateByIdSemestre
}