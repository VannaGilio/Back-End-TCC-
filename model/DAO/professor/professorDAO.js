const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertProfessor = async function(professor){
    try {
        let result = await prisma.$executeRaw`
            CALL sp_inserir_professor(
            ${professor.credencial}, 
            ${professor.nome}, 
            ${professor.email}, 
            ${professor.telefone}, 
            ${professor.data_nascimento}
           );
        `
        if(result)
            return true
        else
            return false
    } catch (error) {
        console.error(error)
        return false
    }
}

const selectByIdProfessor = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_professor WHERE id_professor = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const updateByIdProfessor = async function(professor){
    try {
        let sql = `update tbl_professor set nome = '${professor.nome}',
                                            email = '${professor.email}',
                                            telefone = '${professor.telefone}'
                                            
        where id_professor = ${professor.id_professor};`
        console.log(professor)

        let result = await prisma.$executeRawUnsafe(sql)
        if(result)
            return true
        else
            return false
    } catch (error) {
        console.error(error)
        return false
    }
}

module.exports = {
    insertProfessor,
    selectByIdProfessor,
    updateByIdProfessor
}