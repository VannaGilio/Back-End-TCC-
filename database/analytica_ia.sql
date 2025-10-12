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

------------------------------------------------------------

-- INSERIR USUARIO
DELIMITER $
DROP procedure IF EXISTS sp_inserir_usuario;
CREATE PROCEDURE sp_inserir_usuario (
    IN p_credencial varchar(11),
    IN p_senha varchar(20),
    IN p_nivel_usuario enum('aluno', 'professor', 'gestão')
)
BEGIN
	INSERT INTO tbl_usuarios(
		credencial,
        senha,
        nivel_usuario
    )VALUES(
		p_credencial,
        p_senha,
        p_nivel_usuario
    );
END$

-- INSERIR SEMESTRE 
DELIMITER $   
DROP PROCEDURE IF EXISTS sp_inserir_semestre; 
CREATE PROCEDURE sp_inserir_semestre (   
    IN p_semestre varchar(45)   
) BEGIN 
    INSERT INTO tbl_semestre(   
        semestre   
    )VALUES(
        p_semestre 
    );   
END$ 

-- INSERIR CATEGORIA 
DELIMITER $
DROP PROCEDURE IF EXISTS sp_inserir_categoria;
CREATE PROCEDURE sp_inserir_categoria (
	IN p_categoria varchar(45)
) BEGIN
	INSERT INTO tbl_categoria(		
		categoria
    )VALUES(
		p_categoria
    );
END$

-- INSERIR MATERIA
DELIMITER $
DROP PROCEDURE IF EXISTS sp_inserir_materia;
CREATE PROCEDURE sp_inserir_materia(
	IN p_materia varchar(45),
    IN p_cor_materia varchar(45)
) BEGIN
	INSERT INTO  tbl_materia(	
		materia, 
        cor_materia
	)VALUES(
		p_materia, 
        p_cor_materia
	);
END$

-- INSERIR TURMA
DELIMITER $
DROP PROCEDURE IF EXISTS sp_inserir_turma;
CREATE PROCEDURE sp_inserir_turma(
	IN p_turma varchar(45)
)BEGIN
	INSERT INTO  tbl_turma(
		turma
	)VALUES(
		p_turma
	);
END$

CALL sp_inserir_turma("1º ano B");
select * from tbl_turma;

CREATE PROCEDURE sp_inserir_professor (
    IN 
)


use db_analytica_ai;
-- INSERIR ALUNO

DELIMITER $ 
DROP PROCEDURE IF EXISTS sp_inserir_aluno;
CREATE PROCEDURE sp_inserir_aluno (   
    IN p_nome VARCHAR(80),  
    IN p_data_nascimento DATE,
    IN p_matricula VARCHAR(45),  
    IN p_telefone VARCHAR(20),  
    IN p_email VARCHAR(45),  
    IN p_id_turma INT
) 
BEGIN  
    DECLARE v_id_usuario INT;
    DECLARE v_nivel_usuario ENUM('aluno', 'professor', 'gestão');

    -- Busca o id_usuario e o nível de acesso
    SELECT id_usuario, nivel_usuario 
    INTO v_id_usuario, v_nivel_usuario
    FROM tbl_usuarios
    WHERE credencial = p_matricula;

    -- Verifica se o usuário existe
    IF v_id_usuario IS NULL THEN 
        SIGNAL SQLSTATE '45000' 	
        SET MESSAGE_TEXT = 'Esse usuário não existe';  
    END IF; 

    -- Verifica se o nível do usuário é "aluno"
    IF v_nivel_usuario <> 'aluno' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Somente usuários com nível "aluno" podem ser inseridos nesta tabela';
    END IF;

    -- Verifica se a turma existe 
    IF NOT EXISTS (
        SELECT 1 FROM tbl_turma WHERE id_turma = p_id_turma
    ) THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Essa turma não existe'; 
    END IF; 

    -- Verifica se o usuário já está cadastrado como aluno
    IF EXISTS (
        SELECT 1 FROM tbl_aluno WHERE id_usuario = v_id_usuario
    ) THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Esse usuário já está cadastrado como aluno'; 
    END IF;

    -- Insere o novo aluno  
    INSERT INTO tbl_aluno ( 
        nome, data_nascimento, matricula, telefone, email, id_usuario, id_turma
    ) 
    VALUES ( 
        p_nome, p_data_nascimento, p_matricula, p_telefone, p_email, v_id_usuario, p_id_turma
    );
END$

-- INSERIR PROFESSOR

DELIMITER $
DROP PROCEDURE sp_inserir_professor;
CREATE PROCEDURE sp_inserir_professor (
	IN p_credencial VARCHAR(11),
    IN p_nome VARCHAR(80),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    IN p_email VARCHAR(60)
)
BEGIN
    DECLARE v_id_usuario INT;

    SELECT id_usuario INTO v_id_usuario
    FROM tbl_usuarios
    WHERE credencial = p_credencial;

	IF v_id_usuario IS NULL THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esse usuário não existe';  
    END IF;

	IF EXISTS (
        SELECT 1 FROM tbl_professor WHERE id_usuario = v_id_usuario
    ) THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Esse usuário já está cadastrado como professor'; 
    END IF;

    INSERT INTO tbl_professor (
		id_usuario,
        nome,
        data_nascimento,
        telefone,
        email
    ) VALUES (
		v_id_usuario,
        p_nome,
        p_data_nascimento,
        p_telefone,
        p_email
    );
END $

------------------------------------------------------------

-- CADASTRO DE TURMA
insert into tbl_turma(turma)values("1º ANO B")

------------------------------------------------------------

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

    INSERT INTO tbl_usuarios (credencial, senha, nivel_usuario) 
    VALUES (p_credencial, p_senha, p_nivel_usuario);

SET v_id_usuario = LAST_INSERT_ID();
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
        SELECT v_id_usuario AS id_usuario_cadastrado, p_nivel_usuario AS nivel_cadastrado;
END$

-- -- CADASTRO ALUNO
-- CALL sp_cadastrar_usuario_completo('24122460', 'oioioi', 'aluno', 'João Victor Campos dos Santos', 'joaosantos20071009@gmail.com', '994509385',
-- '2007-09-11', '24122460', 1);

-- -- CADASTRO PROFESSOR
-- CALL sp_cadastrar_usuario_completo('54321...', 'senha', 'professor', 'Nome', 'email', 'tel',
-- '1980-01-01', NULL, NULL);

-- -- CADASTRO GESTÃO
-- CALL sp_cadastrar_usuario_completo('98765...', 'senha', 'gestão', 'Nome', 'email', 'tel',
-- NULL, NULL, NULL);

-- VERIFICAR USUÁRIO CRIADO
-- select * from tbl_usuarios;

-- select * from tbl_aluno;
-- select * from tbl_professor;
-- select * from tbl_gestao;

------------------------------------------------------------

-- LOGIN USUÁRIO
DELIMITER $
DROP PROCEDURE IF EXISTS sp_login_usuario;
CREATE PROCEDURE sp_login_usuario (
    IN p_credencial VARCHAR(11),
    IN p_senha VARCHAR(20) 
)
BEGIN
    DECLARE v_nivel VARCHAR(10);
    DECLARE v_id_usuario INT;
    SELECT nivel_usuario, id_usuario INTO v_nivel, v_id_usuario
    FROM tbl_usuarios
    WHERE credencial = p_credencial AND senha = p_senha;
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
    ELSE
        SELECT NULL AS autenticacao_falhou;
    END IF;
END$

-- TESTANDO LOGIN
-- CALL sp_login_usuario('24122460', 'senha');

----------------------------------------------------------------

-- VIEW USUARIO 
DROP VIEW IF EXISTS vw_listar_usuarios;
CREATE VIEW vw_listar_usuarios AS
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

SHOW PROCEDURE STATUS WHERE Db = 'db_analytica_ai';

SHOW FULL TABLES IN db_analytica_ai WHERE TABLE_TYPE = 'VIEW';

-- ALTERAÇÃO TABELA DE USUÁRIOS
ALTER TABLE tbl_usuarios
ADD COLUMN token_recuperacao VARCHAR(255) NULL AFTER senha,
ADD COLUMN expiracao_token DATETIME NULL AFTER token_recuperacao;

-- ATUALIZANDO DADOS DE USUÁRIOS DEPOIS DAS MUDANÇAS
UPDATE tbl_usuarios SET
expiracao_token = NOW() + INTERVAL 1 HOUR,
token_recuperacao = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
WHERE id_usuario = 1;

-- VIEW - BUSCA DE USUÁRIO PELA CREDENCIAL
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

-- PROCEDURE - SALVANDO TOKEN DE RECUPERAÇÃO
DELIMITER $$
CREATE PROCEDURE sp_gerar_token_recuperacao(
IN p_id_usuario INT,
IN p_token VARCHAR(255),
IN p_expiracao DATETIME
)
BEGIN
UPDATE tbl_usuarios
SET
token_recuperacao = p_token,
expiracao_token = p_expiracao
WHERE
id_usuario = p_id_usuario;

SELECT p_id_usuario AS id_usuario_afetado;
END$$
DELIMITER ;

call sp_gerar_token_recuperacao (1, "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6", NOW() + INTERVAL 1 HOUR)

-- PROCEDURE - VALIDAR TOKEN E RESETAR SENHA
DELIMITER $$
CREATE PROCEDURE sp_resetar_senha(
IN p_token VARCHAR(255),
IN p_nova_senha VARCHAR(20)
)
BEGIN
DECLARE v_id_usuario INT;

SELECT id_usuario INTO v_id_usuario
FROM tbl_usuarios
WHERE token_recuperacao = p_token
AND expiracao_token > NOW() 
LIMIT 1;

IF v_id_usuario IS NOT NULL THEN

UPDATE tbl_usuarios
SET senha = p_nova_senha
WHERE id_usuario = v_id_usuario;

UPDATE tbl_usuarios
SET token_recuperacao = NULL,
expiracao_token = NULL
WHERE id_usuario = v_id_usuario;

SELECT 'SUCESSO' AS status_reset;
ELSE

SELECT 'FALHA_TOKEN_INVALIDO_OU_EXPIRADO' AS status_reset;
END IF;
END$$
DELIMITER ;

call sp_resetar_senha ("a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6", "novaSenhaGerada");

