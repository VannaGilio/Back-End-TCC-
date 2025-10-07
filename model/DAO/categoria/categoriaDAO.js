const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const insertCategoria = async function(categoria){
    try {
        let result = await prisma.$executeRaw`
            CALL inserir_categoria(${categoria.categoria})
        `

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const selectAllCategorias = async function(){
    try {
        let result = await prisma.$queryRaw`
            select * from buscar_categoria;
        `
        return result
    } catch (error) {
        return false
    }
}

const selectByIdCategoria = async function(id){
    try {
        let result = await prisma.$queryRaw`
            select * from buscar_categoria WHERE id_categoria = ${id}
        `
        return result
    } catch (error) {
        return false
    }
}

const deleteByIdCaterogia = async function (id) {
    try {
        let sql = `delete from tbl_categoria where id_categoria = ${id};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

const updateByIdCategoria = async function (categoria) {
    try {
        let sql = `update tbl_categoria set  categoria = '${categoria.categoria}'
                                            
                                            where id_categoria = ${categoria.id_categoria};`

        let result = await prisma.$executeRawUnsafe(sql)

        if(result)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

module.exports = {
    insertCategoria,
    selectAllCategorias,
    selectByIdCategoria,
    deleteByIdCaterogia,
    updateByIdCategoria
}