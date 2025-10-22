const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const selectDesempenhoTurmaMateria = async function (idGestao, idTurma, idMateria, idSemestre) {
    try {
        let sql = `
            SELECT * FROM vw_desempenho_turma_materia WHERE id_gestao = ${idGestao}
        `
        if(idTurma){
            sql += ` AND id_turma = ${idTurma}`
        }
        if(idSemestre){
            sql += ` AND id_semestre = ${idSemestre}`
        }
        if(idMateria){
            sql += ` AND id_materia = ${idMateria}`
        }

        let result = await prisma.$queryRawUnsafe(sql)
        
        if(result)
            return result
        else
            return false        
    } catch (error) {
        console.log(error)
        return false
    }
}

module.exports = {
    selectDesempenhoTurmaMateria
}