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

--Select
DELIMITER $
DROP procedure IF EXISTS listar_usuarios;
CREATE PROCEDURE listar_usuarios()
BEGIN
	SELECT * FROM tbl_usuarios;
END$