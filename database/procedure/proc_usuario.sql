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
