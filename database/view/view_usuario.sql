USE db_analytica_ai;

CREATE VIEW listarUsuarios AS
SELECT
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;