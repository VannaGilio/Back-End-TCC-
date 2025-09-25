DELIMITER $
CREATE PROCEDURE inserir_usuario (
	OUT p_id_usuario int,
    IN p_credencial varchar(45),
    IN p_senha varchar(20),
    IN p_nivel_acesso enum('aluno', 'professor', 'gestão')
)
BEGIN
	INSERT INTO tbl_usuarios(
		credencial,
        senha,
        nivel_acesso
    )VALUES(
		p_credencial,
        p_senha,
        p_nivel_acesso
    );
    SET p_id_usuario = last_insert_id();
END$