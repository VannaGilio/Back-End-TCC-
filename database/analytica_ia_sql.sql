CREATE DATABASE db_analytica_ai;

USE db_analytica_ai;

-- Criação das tabelas base
CREATE TABLE tbl_usuarios (
    id_usuario INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    credencial VARCHAR(11) NOT NULL UNIQUE,
    senha VARCHAR(20) NOT NULL,
    nivel_usuario ENUM('aluno', 'professor', 'gestão') NOT NULL
);

CREATE TABLE tbl_semestre (
    id_semestre INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    semestre VARCHAR(45) NOT NULL
);

CREATE TABLE tbl_categoria (
    id_categoria INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    categoria VARCHAR(45) NOT NULL
);

-- Criação das tabelas de perfil
CREATE TABLE tbl_gestao (
    id_gestao INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(45) NOT NULL,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_gestao_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES tbl_usuarios (id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE tbl_professor (
    id_professor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(20),
    email VARCHAR(60) NOT NULL,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_professor_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES tbl_usuarios (id_usuario)
        ON DELETE CASCADE
);

-- Criação das tabelas de curso e turma
CREATE TABLE tbl_turma (
    id_turma INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    turma VARCHAR(45) NOT NULL
);

CREATE TABLE tbl_materia (
    id_materia INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    materia VARCHAR(45) NOT NULL,
    cor_materia VARCHAR(45)
);

-- Criação da tabela de aluno
CREATE TABLE tbl_aluno (
    id_aluno INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    data_nascimento DATE,
    matricula VARCHAR(45) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(45) NOT NULL,
    id_usuario INT NOT NULL,
    id_turma INT NOT NULL,
    CONSTRAINT fk_aluno_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES tbl_usuarios (id_usuario)
        ON DELETE CASCADE,
    CONSTRAINT fk_aluno_turma
        FOREIGN KEY (id_turma)
        REFERENCES tbl_turma (id_turma)
        ON DELETE CASCADE
);

-- Criação das tabelas de relacionamento
CREATE TABLE tbl_semestre_turma (
    id_semestre_turma INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_turma INT NOT NULL,
	id_semestre INT NOT NULL,
    CONSTRAINT fk_semestre_turma_semestre
        FOREIGN KEY (id_semestre)
        REFERENCES tbl_semestre (id_semestre)
        ON DELETE CASCADE,
    CONSTRAINT fk_semestre_turma_turma
        FOREIGN KEY (id_turma)
        REFERENCES tbl_turma (id_turma)
        ON DELETE CASCADE
);

CREATE TABLE tbl_turma_professor (
    id_turma_professor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_professor INT NOT NULL,
	id_turma INT NOT NULL,
    CONSTRAINT fk_turma_professor_turma
        FOREIGN KEY (id_turma)
        REFERENCES tbl_turma (id_turma)
        ON DELETE CASCADE,
    CONSTRAINT fk_turma_professor_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor)
        ON DELETE CASCADE
);

-- Criação das tabelas de registro e atividades
CREATE TABLE tbl_recursos (
    id_recursos INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(45),
    descricao VARCHAR(255),
    data_criacao DATE NOT NULL,
    id_materia INT NOT NULL,
    id_professor INT NOT NULL,
    CONSTRAINT fk_recursos_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_recursos_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor)
        ON DELETE CASCADE
);

CREATE TABLE tbl_recurso_aluno (
    id_recursos_aluno INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_recursos INT NOT NULL,
    id_aluno INT NOT NULL,
    CONSTRAINT fk_recurso_aluno_recurso
        FOREIGN KEY (id_recursos)
        REFERENCES tbl_recursos (id_recursos)
        ON DELETE CASCADE,
    CONSTRAINT fk_recurso_aluno_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno)
        ON DELETE CASCADE
);

CREATE TABLE tbl_atividade (
    id_atividade INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(45) NOT NULL,
    descricao VARCHAR(255),
    data_criacao DATE NOT NULL,
	id_materia INT NOT NULL,
    id_professor INT NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_atividade_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_atividade_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor)
        ON DELETE CASCADE,
    CONSTRAINT fk_atividade_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES tbl_categoria (id_categoria)
        ON DELETE CASCADE
);

CREATE TABLE tbl_atividade_aluno (
    id_atividade_aluno INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_atividade INT NOT NULL,
    id_aluno INT NOT NULL,
    CONSTRAINT fk_atividade_aluno_atividade
        FOREIGN KEY (id_atividade)
        REFERENCES tbl_atividade (id_atividade)
        ON DELETE CASCADE,
    CONSTRAINT fk_atividade_aluno_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno)
        ON DELETE CASCADE
);

CREATE TABLE tbl_frequencia (
    id_frequencia INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    presenca BOOLEAN NOT NULL,
    data_frequencia DATE,
    id_aluno INT NOT NULL,
    id_materia INT NOT NULL,
    CONSTRAINT fk_frequencia_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno)
        ON DELETE CASCADE,
    CONSTRAINT fk_frequencia_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
        ON DELETE CASCADE
);

CREATE TABLE tbl_nota (
    id_nota INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nota DECIMAL(5,2),
    id_atividade_aluno INT NOT NULL,
    id_semestre INT NOT NULL,
    CONSTRAINT fk_nota_atividade_aluno
        FOREIGN KEY (id_atividade_aluno)
        REFERENCES tbl_atividade_aluno (id_atividade_aluno)
        ON DELETE CASCADE,
    CONSTRAINT fk_nota_semestre
        FOREIGN KEY (id_semestre)
        REFERENCES tbl_semestre (id_semestre)
        ON DELETE CASCADE
);

CREATE TABLE tbl_observacao (
    id_observacao INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(500),
    id_atividade INT,
    id_aluno INT NOT NULL,
    CONSTRAINT fk_observacao_atividade
        FOREIGN KEY (id_atividade)
        REFERENCES tbl_atividade (id_atividade)
        ON DELETE CASCADE,
    CONSTRAINT fk_observacao_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno)
        ON DELETE CASCADE
);

CREATE TABLE tbl_insights (
    id_insights INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    insights VARCHAR(255),
    id_materia INT NOT NULL,
    id_aluno INT NOT NULL,
    id_professor INT NOT NULL,
    CONSTRAINT fk_insights_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia),
    CONSTRAINT fk_insights_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno),
    CONSTRAINT fk_insights_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor)
);

CREATE TABLE tbl_relatorio (
    id_relatorio INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    relatorio VARCHAR(500),
    titulo VARCHAR(45),
    data_criacao DATE,
    id_aluno INT NOT NULL,
    id_professor INT NOT NULL,
    id_materia INT NOT NULL,
    CONSTRAINT fk_relatorio_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno),
    CONSTRAINT fk_relatorio_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor),
    CONSTRAINT fk_relatorio_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
);

-- ----------------------------------------------------------

-- CADASTRO DE TURMA
insert into tbl_turma(turma)values("1º ANO B")

-- ----------------------------------------------------------

-- CADASTRO DE USUÁRIO
DELIMITER $
DROP PROCEDURE IF EXISTS sp_cadastrar_usuario_completo;
CREATE PROCEDURE sp_cadastrar_usuario_completo (
-- DADOS DE ACESSO (tbl_usuarios)
IN p_credencial VARCHAR(11),
IN p_senha VARCHAR(20),
IN p_nivel_usuario ENUM('aluno', 'professor', 'gestão'),
-- DADOS GERAIS
IN p_nome VARCHAR(80),
IN p_email VARCHAR(60),
IN p_telefone VARCHAR(20),
-- DADOS ESPECÍFICOS DE ALUNO/PROFESSOR (Passar NULL se for Gestão)
IN p_data_nascimento DATE,
-- DADOS ESPECÍFICOS DE ALUNO (Passar NULL se for Professor/Gestão)
IN p_matricula VARCHAR(45),
IN p_id_turma INT
)
BEGIN
DECLARE v_id_usuario INT;
-- 1. Insere o registro de credencial/acesso
INSERT INTO tbl_usuarios (credencial, senha, nivel_usuario) VALUES
(p_credencial, p_senha, p_nivel_usuario);
-- 2. Captura o ID gerado (LAST_INSERT_ID())

SET v_id_usuario = LAST_INSERT_ID();
-- 3. Lógica Condicional para a inserção do perfil
IF p_nivel_usuario = 'aluno' THEN
INSERT INTO tbl_aluno (
nome, data_nascimento, matricula, telefone, email, id_usuario, id_turma
) VALUES (
p_nome, p_data_nascimento, p_matricula, p_telefone, p_email, v_id_usuario,
p_id_turma
);
ELSEIF p_nivel_usuario = 'professor' THEN
INSERT INTO tbl_professor (
nome, data_nascimento, telefone, email, id_usuario
) VALUES (
p_nome, p_data_nascimento, p_telefone, p_email, v_id_usuario
);
ELSEIF p_nivel_usuario = 'gestão' THEN
INSERT INTO tbl_gestao (
nome, telefone, email, id_usuario
) VALUES (
p_nome, p_telefone, p_email, v_id_usuario
);
END IF;
-- 4. Retorna o ID gerado
SELECT v_id_usuario AS id_usuario_cadastrado, p_nivel_usuario AS nivel_cadastrado;
END$

-- CADASTRO ALUNO
CALL sp_cadastrar_usuario_completo('24122460', 'oioioi', 'aluno', 'João Victor Campos dos Santos', 'joaosantos20071009@gmail.com', '994509385',
'2007-09-11', '24122460', 1);

-- CADASTRO PROFESSOR
CALL sp_cadastrar_usuario_completo('54321...', 'senha', 'professor', 'Nome', 'email', 'tel',
'1980-01-01', NULL, NULL);

-- CADASTRO GESTÃO
CALL sp_cadastrar_usuario_completo('98765...', 'senha', 'gestão', 'Nome', 'email', 'tel',
NULL, NULL, NULL);

-- VERIFICAR USUÁRIO CRIADO
select * from tbl_usuarios;

-- ----------------------------------------------------------

-- LOGIN USUÁRIO
DELIMITER $
DROP PROCEDURE IF EXISTS sp_login_usuario;
CREATE PROCEDURE sp_login_usuario (
IN p_credencial VARCHAR(11),
IN p_senha VARCHAR(20) -- Lembre-se: use HASHES de senha no ambiente real!
)
BEGIN
-- Variável para armazenar o nível e o ID do usuário autenticado
DECLARE v_nivel VARCHAR(10);
DECLARE v_id_usuario INT;
-- 1. Tenta encontrar e autenticar o usuário
-- Se as credenciais baterem, armazena o nível e o ID nas variáveis locais.
SELECT nivel_usuario, id_usuario INTO v_nivel, v_id_usuario
FROM tbl_usuarios
WHERE credencial = p_credencial AND senha = p_senha;
-- 2. Se o usuário foi encontrado (v_id_usuario NÃO é NULL), executa o SELECT específico
IF v_id_usuario IS NOT NULL THEN
-- A. PERFIL ALUNO
IF v_nivel = 'aluno' THEN
SELECT
U.id_usuario,
U.credencial,
U.senha,
U.nivel_usuario,
A.id_aluno,
A.nome,
A.email,
A.telefone,

A.data_nascimento,
A.matricula,
A.id_turma
FROM
tbl_usuarios U
INNER JOIN tbl_aluno A ON U.id_usuario = A.id_usuario
WHERE U.id_usuario = v_id_usuario;
-- B. PERFIL PROFESSOR
ELSEIF v_nivel = 'professor' THEN
SELECT
U.id_usuario,
U.credencial,
U.senha,
U.nivel_usuario,
P.id_professor,
P.nome,
P.email,
P.telefone,
P.data_nascimento
FROM
tbl_usuarios U
INNER JOIN tbl_professor P ON U.id_usuario = P.id_usuario
WHERE U.id_usuario = v_id_usuario;
-- C. PERFIL GESTÃO
ELSEIF v_nivel = 'gestão' THEN
SELECT
U.id_usuario,
U.credencial,
U.senha,
U.nivel_usuario,
G.id_gestao,
G.nome,
G.email,
G.telefone
FROM
tbl_usuarios U
INNER JOIN tbl_gestao G ON U.id_usuario = G.id_usuario
WHERE U.id_usuario = v_id_usuario;
END IF;
-- 3. Se as credenciais não bateram
ELSE

-- Retorna um resultado vazio (ou uma linha de erro que seu backend pode capturar)
SELECT NULL AS autenticacao_falhou;
END IF;
END$

-- TESTANDO LOGIN
CALL sp_login_usuario(
'24122460', -- p_credencial
'oioioi' -- p_senha
);

