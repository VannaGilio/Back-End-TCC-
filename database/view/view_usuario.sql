USE db_analytica_ai;

CREATE VIEW listarUsuarios AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

CREATE VIEW buscarAluno AS
SELECT
    id_aluno,
    nome,
    data_nascimento,
    matricula,
    telefone,
    email
FROM tbl_aluno;

CREATE VIEW buscarUsuarios AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

CREATE VIEW buscarProfessor AS
SELECT
    id_professor,
    nome,
    data_nascimento,
    telefone,
    email
FROM tbl_professor;

CREATE VIEW buscarTurma AS
SELECT
    id_turma,
    turma
FROM tbl_turma;

CREATE VIEW buscarMateria AS
SELECT
    id_materia,
    materia,
    cor_materia
FROM tbl_materia;

CREATE VIEW buscarSemestre AS
SELECT
    id_semestre,
    semestre
FROM tbl_semestre;


CREATE VIEW buscarCategoria AS 
SELECT
    id_categoria,
    categoria
FROM tbl_categoria;



---------------------------------------------------------------


CREATE VIEW buscarGestao AS
SELECT
    tbl_gestao.id_gestao,
    tbl_gestao.nome,
    tbl_gestao.telefone,
    tbl_gestao.email,
    tbl_usuario.id_usuario,
    tbl_usuario.credencial,
    tbl_usuario.senha,
    tbl_usuario.nivel_usuario
FROM tbl_gestao;
JOIN tbl_usuario ON tbl_gestao.id_usuario = tbl_usuario.id_usuario


CREATE VIEW buscarSemestreTurma AS
SELECT
    tbl_semestre_turma.id_semestre_turma,
    tbl_turma.id_turma,
    tbl_turma.turma,
	tbl_semestre.id_semestre,
    tbl_semestre.semestre,
FROM tbl_semestre_turma
JOIN tbl_turma ON tbl_semestre_turma.id_turma = tbl_turma.id_turma
JOIN tbl_semestre ON tbl_semestre_turma.id_semestre = tbl_semestre.id_semestre;

CREATE VIEW buscarTurmaProfesor AS
SELECT
    tbl_turma_professor.id_turma_professor,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario,
    tbl_turma.id_turma,
    tbl_turma.turma
FROM tbl_turma_professor
JOIN tbl_professor ON tbl_turma_professor.id_professor = tbl_professor.id_professor
JOIN tbl_turma ON tbl_turma_professor.id_turma = tbl_turma.id_turma;



CREATE VIEW buscarRecursos AS
SELECT
    tbl_recursos.id_recursos,
    tbl_recursos.titulo,
    tbl_recursos.descricao,
    tbl_recursos.data_criacao,
    tbl_materia.id_materia,
    tbl_materia.materia,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario
FROM tbl_recursos
JOIN tbl_materia ON tbl_recursos.id_materia = tbl_materia.id_materia
JOIN tbl_professor ON tbl_recursos.id_professor = tbl_professor.id_professor;


CREATE VIEW buscarRecursoAluno AS
SELECT
    tbl_recurso_aluno.id_recursos_aluno,
    tbl_recursos.id_recursos,
    tbl_recursos.titulo,
    tbl_recursos.descricao,
    tbl_recursos.data_criacao,
    tbl_recursos.id_materia,
    tbl_recursos.id_professor,
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma
FROM tbl_recurso_aluno
JOIN tbl_recursos ON tbl_recurso_aluno.id_recursos = tbl_recursos.id_recursos
JOIN tbl_aluno ON tbl_recurso_aluno.id_aluno = tbl_aluno.id_aluno;


CREATE VIEW buscarAtividade AS
    tbl_atividades.id_atividade,
    tbl_atividades.titulo,
    tbl_atividades.descricao,
    data_criacao,
	tbl_atividades.id_materia,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario,
    tbl_categoria.id_categoria,
    tbl_categoria.categoria,
FROM tbl_atividade;


CREATE VIEW buscarAtividadeAluno AS
    id_atividade_aluno,
    id_atividade,
    id_aluno
FROM tbl_atividade_aluno;


CREATE VIEW buscarFrequencia AS
    id_frequencia,
    presenca,
    data_frequencia,
    id_aluno,
    id_materia
FROM tbl_frequencia;

CREATE VIEW buscarNota AS
    id_nota,
    nota,
    id_atividade_aluno,
    id_semestre
FROM tbl_nota;



CREATE VIEW buscarObservacao AS
    id_observacao,
    descricao,
    id_atividade,
    id_aluno
FROM tbl_observacao;


CREATE VIEW buscarInsigths AS
    id_insights,
    insights,
    id_materia,
    id_aluno,
    id_professor
FROM tbl_insights;

CREATE VIEW buscarRelatorio AS
    id_relatorio,
    relatorio,
    titulo,
    data_criacao,
    id_aluno,
    id_professor,
    id_materia 
FROM tbl_relatorio;