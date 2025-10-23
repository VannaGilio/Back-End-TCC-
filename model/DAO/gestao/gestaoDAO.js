const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const selectByIdGestao = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from vw_buscar_gestao WHERE id_gestao = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const updateByIdGestao = async function(gestao){
    try {
        let sql = `update tbl_gestao set nome = '${gestao.nome}',
                                         email = '${gestao.email}',
                                         telefone = '${gestao.telefone}'
                                                                            
                                    where id_gestao = ${gestao.id_gestao};`

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
    selectByIdGestao,
    updateByIdGestao
}