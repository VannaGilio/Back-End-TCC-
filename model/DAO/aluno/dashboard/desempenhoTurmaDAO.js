const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient()

const selectDesempenhoTurma = async function (idProfessor, idTurma, idSemestre) {
    try {
        let sql = `
            SELECT * FROM vw_desempenho_turma WHERE id_professor = ${idProfessor}
        `
        if(idTurma){
            sql += ` AND id_turma = ${idTurma}`
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
        console.log(error)
        return false
    }
}

module.exports = {
    selectDesempenhoTurma
}