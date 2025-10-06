const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()
const message = require('../../../modulo/config.js')

const insertTurma = async function(turma){
    try {
        let result = await prisma.$executeRaw`
            CALL inserir_turma(${turma.turma})
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const selectAllTurmas = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from buscar_turma;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdTurma = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from buscar_turma WHERE id_turma = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdTurma = async function (id) {
    try {
        let sql = `delete from tbl_turma where id_turma = ${id};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const updateByIdTurma = async function (turma) {
    try {
        let sql = `update tbl_turma set  turma = '${turma.turma}'
                                            
                                            where id_turma = ${turma.id_turma};`

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
    insertTurma,
    selectAllTurmas,
    selectByIdTurma,
    deleteByIdTurma,
    updateByIdTurma
}