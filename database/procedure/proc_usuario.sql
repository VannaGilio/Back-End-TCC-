-- Inserir
DELIMITER $
DROP procedure IF EXISTS inserir_usuario;
CREATE PROCEDURE inserir_usuario (
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

--Delete

USE db_analytica_ai;

DELIMITER $
DROP procedure IF EXISTS delete_usuario;
CREATE PROCEDURE delete_usuario (
	IN p_id INT
)
BEGIN
	DELETE FROM tbl_usuarios WHERE id_usuario = p_id;
END$

-- SELECT
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

-----------------------------------------------------------------------------------------------------

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_login_usuario $$

CREATE PROCEDURE sp_login_usuario (
    IN p_credencial VARCHAR(11),
    IN p_senha VARCHAR(20)
)
BEGIN
    -- Variável para armazenar o nível e o ID do usuário autenticado
    DECLARE v_nivel VARCHAR(10);
    DECLARE v_id_usuario INT;

    -- 1. Verifica se usuário existe
    SELECT nivel_usuario, id_usuario
    INTO v_nivel, v_id_usuario
    FROM tbl_usuarios
    WHERE credencial = p_credencial AND senha = p_senha;

    -- 2. Se encontrou usuário
    IF v_id_usuario IS NOT NULL THEN

        -- Perfil aluno
        IF v_nivel = 'aluno' THEN
            SELECT * 
            FROM vw_login_aluno 
            WHERE id_usuario = v_id_usuario;

        -- Perfil professor
        ELSEIF v_nivel = 'professor' THEN
            SELECT * 
            FROM vw_login_professor 
            WHERE id_usuario = v_id_usuario;

        -- Perfil gestão
        ELSEIF v_nivel = 'gestão' THEN
            SELECT * 
            FROM vw_login_gestao 
            WHERE id_usuario = v_id_usuario;
        END IF;
    END IF;
END $$


------------------------

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
END IF;
END$