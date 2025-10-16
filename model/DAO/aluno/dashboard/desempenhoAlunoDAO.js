const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const selectDesempenhoAluno = async function (idAluno, idMateria, idSemestre) {
    try {
        let sql = `
            SELECT * FROM vw_desempenho_aluno WHERE id_aluno = ${idAluno}
        `
        if(idMateria){
            sql += ` AND id_materia = ${idMateria}`
        }
        if(idSemestre){
            sql += ` AND id_semestre = ${idSemestre}`
        }

        let result = await prisma.$queryRawUnsafe(sql)
        
        if(result)
            return result
        else
            return false        
    } catch (error) {
        return false
    }
}

module.exports = {
    selectDesempenhoAluno
}