
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

-- INSERIR ALUNO

DELIMITER $ 
DROP PROCEDURE IF EXISTS sp_inserir_aluno;
CREATE PROCEDURE sp_inserir_aluno (  
    IN p_credencial INT,  
    IN p_id_turma INT,  
    IN p_nome VARCHAR(80),  
    IN p_matricula VARCHAR(45),  
    IN p_telefone VARCHAR(20),  
    IN p_email VARCHAR(45),  
    IN p_data_nascimento DATE  
) BEGIN  
IF NOT EXISTS ( 
    SELECT 1 FROM tbl_usuarios 
    WHERE id_usuario = p_id_usuario)  
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esse usuário não existe';  
END IF; 
-- Verifica se a turma existe 
IF NOT EXISTS (
    SELECT 1 FROM tbl_turma WHERE id_turma = p_id_turma) 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Essa turma não existe'; 
END IF; 
-- Insere o novo aluno  
INSERT INTO tbl_aluno ( 
    id_usuario, id_turma, nome, matricula, telefone, email, data_nascimento 
) 
VALUES ( 
    p_id_usuario, p_id_turma, p_nome, p_matricula, p_telefone, p_email, p_data_nascimento 
);
END$ 

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

-- CADASTRO ALUNO
CALL sp_cadastrar_usuario_completo('24122460', 'senha', 'aluno', 'João Victor Campos dos Santos', 'joaosantos20071009@gmail.com', '994509385',
'2007-09-11', '24122460', 1);

-- CADASTRO PROFESSOR
CALL sp_cadastrar_usuario_completo('54321...', 'senha', 'professor', 'Nome', 'email', 'tel',
'1980-01-01', NULL, NULL);

-- CADASTRO GESTÃO
CALL sp_cadastrar_usuario_completo('98765...', 'senha', 'gestão', 'Nome', 'email', 'tel',
NULL, NULL, NULL);

-- VERIFICAR USUÁRIO CRIADO
select * from tbl_usuarios;

-- TESTANDO LOGIN
CALL sp_login_usuario('24122460', 'senha');

SHOW PROCEDURE STATUS WHERE Db = 'db_analytica_ai';