USE db_analytica_ai;

-- VIEW USUARIO 
DROP VIEW IF EXISTS vw_buscar_usuarios;
CREATE VIEW vw_buscar_usuarios AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

-- VIEW SEMESTRE
DROP VIEW IF EXISTS vw_buscar_semestre;
CREATE VIEW vw_buscar_semestre AS
SELECT
    id_semestre,
    semestre
FROM tbl_semestre;

-- VIEW CATEGORIA
DROP VIEW IF EXISTS vw_buscar_categoria;
CREATE VIEW vw_buscar_categoria AS 
SELECT
    id_categoria,
    categoria
FROM tbl_categoria;

-- VIEW MATERIA 
DROP VIEW IF EXISTS vw_buscar_materia;
CREATE VIEW  vw_buscar_materia AS
SELECT
    id_materia,
    materia,
    cor_materia
FROM tbl_materia;

-- VIEW TURMA
DROP VIEW IF EXISTS vw_buscar_turma;
CREATE VIEW vw_buscar_turma AS
SELECT
    id_turma,
    turma
FROM tbl_turma;

-- VIEW ALUNO
DROP VIEW IF EXISTS vw_buscar_aluno; 
CREATE VIEW vw_buscar_aluno AS 
SELECT 
    a.id_aluno, 
    u.id_usuario, u.credencial, t.id_turma, 
    t.turma AS turma, 
    a.nome AS nome, 
    a.matricula, 
    a.telefone, 
    a.email, 
    a.data_nascimento 
FROM tbl_aluno a JOIN tbl_usuarios u ON a.id_usuario = u.id_usuario 
JOIN tbl_turma t ON a.id_turma = t.id_turma; 

-- EXIBIR VIEWS
SHOW FULL TABLES IN db_analytica_ai WHERE TABLE_TYPE = 'VIEW';

-- VIEW DE BUSCA DE DADOS DO USUÁRIO PELA CREDENCIAL
CREATE OR REPLACE VIEW vw_buscar_usuario_by_credencial AS
SELECT
    u.id_usuario,
    u.credencial,
    u.senha,
    u.nivel_usuario,
    u.token_recuperacao,
    u.expiracao_token,
    COALESCE(a.email, p.email, g.email) AS email
FROM
    tbl_usuarios u
LEFT JOIN
    tbl_aluno a ON u.id_usuario = a.id_usuario
LEFT JOIN
    tbl_professor p ON u.id_usuario = p.id_usuario
LEFT JOIN
    tbl_gestao g ON u.id_usuario = g.id_usuario
WHERE
    COALESCE(a.email, p.email, g.email) IS NOT NULL;

select * from vw_buscar_usuario_by_credencial where credencial = "24122460";

insert into tbl_usuarios(credencial, senha, nivel_usuario, token_recuperacao, expiracao_token)values(
	"credencial",
    "senha",
    "aluno",
    "token_teste",
    "2025-10-09T16:13:47"
);