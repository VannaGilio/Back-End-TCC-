DELIMITER $
DROP TRIGGER IF EXISTS trg_delete_aluno;
CREATE TRIGGER trg_delete_aluno
AFTER DELETE ON tbl_aluno
FOR EACH ROW
BEGIN
    DELETE FROM tbl_usuarios WHERE id_usuario = OLD.id_usuario;
END$
DELIMITER ;
