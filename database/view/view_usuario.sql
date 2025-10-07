USE db_analytica_ai;

CREATE VIEW listar_usuarios AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

CREATE VIEW buscar_aluno AS
SELECT
    id_aluno,
    nome,
    data_nascimento,
    matricula,
    telefone,
    email
FROM tbl_aluno;

CREATE VIEW buscar_usuario AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

CREATE VIEW buscar_professor AS
SELECT
    id_professor,
    nome,
    data_nascimento,
    telefone,
    email   
FROM tbl_professor;

CREATE VIEW buscar_turma AS
SELECT
    id_turma,
    turma
FROM tbl_turma;

CREATE VIEW buscar_materia AS
SELECT
    id_materia,
    materia,
    cor_materia
FROM tbl_materia;

CREATE VIEW buscar_semestre AS
SELECT
    id_semestre,
    semestre
FROM tbl_semestre;


CREATE VIEW buscar_categoria AS 
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
FROM tbl_gestao
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
SELECT
    tbl_atividade.id_atividade,
    tbl_atividade.titulo,
    tbl_atividade.descricao,
    tbl_atividade.data_criacao,
	tbl_materia.id_materia,
    tbl_materia.materia,
    tbl_materia.cor_materia,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario,
    tbl_categoria.id_categoria,
    tbl_categoria.categoria
FROM tbl_atividade
JOIN tbl_materia ON tbl_atividade.id_materia = tbl_materia.id_materia
JOIN tbl_professor ON tbl_atividade.id_professor= tbl_professor.id_professor
JOIN tbl_categoria ON tbl_atividade.id_categoria= tbl_categoria.id_categoria;



CREATE VIEW buscarAtividadeAluno AS
SELECT
    tbl_atividade_aluno.id_atividade_aluno,
    tbl_atividade.id_atividade,
    tbl_atividade.titulo,
    tbl_atividade.descricao,
    tbl_atividade.data_criacao,
	tbl_atividade.id_materia,
    tbl_atividade.id_professor,
    tbl_atividade.id_categoria,
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma
FROM tbl_atividade_aluno
JOIN tbl_atividade ON tbl_atividade_aluno.id_atividade = tbl_atividade.id_atividade
JOIN tbl_aluno ON tbl_atividade_aluno.id_aluno = tbl_aluno.id_;



CREATE VIEW buscarFrequencia AS
    tbl_frequencia.id_frequencia,
    tbl_frequencia.presenca,
    tbl_frequencia.data_frequencia,
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma
    tbl_materia.id_materia,
    tbl_materia.materia,
    tbl_materia.cor_materia
FROM tbl_frequencia
JOIN tbl_aluno ON tbl_frequencia.id_aluno = tbl_aluno.id_aluno
JOIN tbl_materia ON tbl_frequencia.id_materia = tbl_materia.id_materia;


CREATE VIEW buscarNota AS
    tbl_nota.id_nota,
    tbl_nota.nota,
    tbl_atividade_aluno.id_atividade_aluno,
    tbl_atividade_aluno.id_atividade,
    tbl_atividade_aluno.id_aluno,
    tbl_semestre.id_semestre,
    tbl_semestre.semestre
FROM tbl_nota
JOIN tbl_atividade_aluno ON tbl_nota.id_atividade_aluno = tbl_atividade_aluno.id_atividade_aluno
JOIN tbl_semestre ON tbl_nota.id_semestre = tbl_semestre.id_semestre;


CREATE VIEW buscarObservacao AS
SELECT
    tbl_observacao.id_observacao,
    tbl_observacao.descricao,
    tbl_atividade.id_atividade,
    tbl_atividade.titulo,
    tbl_atividade.descricao,
    tbl_atividade.data_criacao,
	tbl_atividade.id_materia,
    tbl_atividade.id_professor,
    tbl_atividade.id_categoria
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma
FROM tbl_observacao
JOIN tbl_aluno ON tbl_observacao.id_aluno = tbl_aluno.id_aluno
JOIN tbl_atividade ON tbl_observacao.id_atividade = tbl_atividade.id_atividade;



CREATE VIEW buscarInsigths AS
SELECT
    tbl_insights.id_insights,
    tbl_insights.insights,
    tbl_materia.id_materia,
    tbl_materia.materia,
    tbl_materia.cor_materia,
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario
FROM tbl_insights
JOIN tbl_materia ON tbl_insights.id_materia = tbl_materia.id_materia
JOIN tbl_aluno ON tbl_insights.id_aluno = tbl_aluno.id_aluno
JOIN tbl_professor ON tbl_insights.id_professor = tbl_professor.id_professor;

CREATE VIEW buscarRelatorio AS
SELECT
    tbl_relatorio.id_relatorio,
    tbl_relatorio.relatorio,
    tbl_relatorio.titulo,
    tbl_relatorio.data_criacao,
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario,
    tbl_materia.id_materia,
    tbl_materia.materia,
    tbl_materia.cor_materia
FROM tbl_relatorio
JOIN tbl_aluno ON tbl_relatorio.id_aluno = tbl_aluno.id_aluno
JOIN tbl_professor ON tbl_relatorio.id_professor = tbl_professor.id_professor
JOIN tbl_materia ON tbl_relatorio.id_materia = tbl_materia.id_materia;


-- view usuario gestão
CREATE OR REPLACE VIEW vw_login_gestao AS
SELECT
    U.id_usuario AS id_usuario,
    U.credencial AS credencial,
    U.senha AS senha,
    U.nivel_usuario AS nivel_usuario,
    G.id_gestao AS id_gestao,
    G.nome AS nome,
    G.email AS email,
    G.telefone AS telefone
FROM
    tbl_usuarios U
INNER JOIN tbl_gestao G ON U.id_usuario = G.id_usuario
WHERE U.nivel_usuario = 'gestão';

-- view usuario professor
-- View para login de PROFESSOR
CREATE OR REPLACE VIEW vw_login_professor AS
SELECT
    U.id_usuario AS id_usuario,
    U.credencial AS credencial,
    U.senha AS senha,
    U.nivel_usuario AS nivel_usuario,
    P.id_professor AS id_professor,
    P.nome AS nome,
    P.email AS email,
    P.telefone AS telefone,
    P.data_nascimento AS data_nascimento
FROM
    tbl_usuarios U
INNER JOIN tbl_professor P ON U.id_usuario = P.id_usuario
WHERE U.nivel_usuario = 'professor';

-- view usuario aluno
CREATE OR REPLACE VIEW vw_login_aluno AS
SELECT
    U.id_usuario AS id_usuario,
    U.credencial AS credencial,
    U.senha AS senha,
    U.nivel_usuario AS nivel_usuario,
    A.id_aluno AS id_aluno,
    A.nome AS nome,
    A.email AS email,
    A.telefone AS telefone,
    A.data_nascimento AS data_nascimento,
    A.matricula AS matricula,
    A.id_turma AS id_turma
FROM
    tbl_usuarios U
INNER JOIN tbl_aluno A ON U.id_usuario = A.id_usuario
WHERE U.nivel_usuario = 'aluno';