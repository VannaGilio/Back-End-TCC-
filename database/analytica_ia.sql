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

CREATE TABLE tbl_gestao_turma (
    id_gestao_turma INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_gestao INT NOT NULL,
    id_turma INT NOT NULL,
    CONSTRAINT fk_gestao_turma
        FOREIGN KEY (id_gestao)
        REFERENCES tbl_gestao (id_gestao)
        ON DELETE CASCADE,
    CONSTRAINT fk_turma_gestao
        FOREIGN KEY (id_turma)
        REFERENCES tbl_turma (id_turma)
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
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_login_usuario $$
CREATE PROCEDURE sp_login_usuario (
    IN p_credencial VARCHAR(11),
    IN p_senha VARCHAR(20)
)
BEGIN
    DECLARE v_nivel VARCHAR(10);
    DECLARE v_id_usuario INT;

    -- Verifica se o usuário existe
    SELECT nivel_usuario, id_usuario 
    INTO v_nivel, v_id_usuario
    FROM tbl_usuarios
    WHERE credencial = p_credencial AND senha = p_senha COLLATE utf8mb4_bin;

    IF v_id_usuario IS NOT NULL THEN
        
        -- A. PERFIL ALUNO
        IF v_nivel = 'aluno' THEN
            SELECT
                U.id_usuario,
                A.id_aluno AS id_perfil,
                U.credencial,
                U.nivel_usuario,
                A.nome,
                A.email,
                A.telefone,
                A.data_nascimento,
                A.matricula,
                A.id_turma
            FROM tbl_usuarios U
            INNER JOIN tbl_aluno A ON U.id_usuario = A.id_usuario
            WHERE U.id_usuario = v_id_usuario;
        
        -- B. PERFIL PROFESSOR
        ELSEIF v_nivel = 'professor' THEN
            SELECT
                U.id_usuario,
                P.id_professor AS id_perfil,
                U.credencial,
                U.nivel_usuario,
                P.nome,
                P.email,
                P.telefone,
                P.data_nascimento
            FROM tbl_usuarios U
            INNER JOIN tbl_professor P ON U.id_usuario = P.id_usuario
            WHERE U.id_usuario = v_id_usuario;
        
        -- C. PERFIL GESTÃO
        ELSEIF v_nivel = 'gestão' THEN
            SELECT
                U.id_usuario,
                G.id_gestao AS id_perfil,
                U.credencial,
                U.nivel_usuario,
                G.nome,
                G.email,
                G.telefone
            FROM tbl_usuarios U
            INNER JOIN tbl_gestao G ON U.id_usuario = G.id_usuario
            WHERE U.id_usuario = v_id_usuario;
        END IF;

    ELSE
        SELECT NULL AS autenticacao_falhou;
    END IF;
END $$

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

---------------------------------

-- VIEW MEDIA MATERIA - ALUNO 

DROP VIEW IF EXISTS vw_media_aluno_materia_semestre;
CREATE VIEW vw_media_aluno_materia_semestre AS
SELECT 
    aa.id_aluno,
    m.id_materia,
    n.id_semestre,
    AVG(n.nota) AS media
FROM tbl_nota n
INNER JOIN tbl_atividade_aluno aa 
    ON n.id_atividade_aluno = aa.id_atividade_aluno
INNER JOIN tbl_atividade a 
    ON aa.id_atividade = a.id_atividade
INNER JOIN tbl_materia m 
    ON a.id_materia = m.id_materia
GROUP BY aa.id_aluno, m.id_materia, n.id_semestre;

-- VIEW DESEMPENHO DO ALUNO
DROP VIEW IF EXISTS vw_desempenho_aluno;
CREATE VIEW vw_desempenho_aluno AS
SELECT 
    aa.id_aluno,
    al.nome AS nome,
    m.id_materia,
    m.materia,
    a.id_atividade,
    a.titulo AS atividade,
    a.descricao AS descricao_atividade,  -- ✅ ADICIONADO
    c.categoria,
    n.nota,
    n.id_semestre,
    vm.media AS media_materia,
    f.total_presenca,
    f.total_falta,
    f.total_aulas,
    f.porcentagem_frequencia
FROM tbl_nota n
INNER JOIN tbl_atividade_aluno aa 
    ON n.id_atividade_aluno = aa.id_atividade_aluno
INNER JOIN tbl_aluno al 
    ON aa.id_aluno = al.id_aluno  
INNER JOIN tbl_atividade a 
    ON aa.id_atividade = a.id_atividade
INNER JOIN tbl_materia m 
    ON a.id_materia = m.id_materia
INNER JOIN tbl_categoria c 
    ON a.id_categoria = c.id_categoria
LEFT JOIN vw_media_aluno_materia_semestre vm 
    ON vm.id_aluno = aa.id_aluno 
   AND vm.id_materia = m.id_materia 
   AND vm.id_semestre = n.id_semestre
LEFT JOIN vw_frequencia_por_aluno_materia f
    ON f.id_aluno = aa.id_aluno 
   AND f.id_materia = m.id_materia;


SELECT * 
FROM vw_desempenho_aluno 
WHERE id_aluno = 9 AND id_materia = 2 AND id_semestre = 2;

SELECT * FROM vw_desempenho_aluno;

INSERT INTO tbl_professor (
	nome, 
    data_nascimento,
    telefone,
    email,
    id_usuario
) VALUES (
	'Professor Genérico',
    '2000-09-09',
    '(11) 0 0000-0000',
    'generico@escola.com',
    2
);
select * from tbl_professor;

INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Prova 1', 'Primeira prova do semestre', '2025-10-01', 2, 1, 1),
('Trabalho 1', 'Trabalho em grupo', '2025-10-05', 1, 1, 2),
('Seminario', 'Seminario', '2025-10-10', 3, 2, 3),
('Atividade Extra', 'Atividade complementar', '2025-10-10', 2, 1, 2);

INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno)
VALUES
(1, 9),
(2, 9),
(3, 9);
SELECT * FROM tbl_atividade;
SELECT * FROM tbl_atividade_aluno;

INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre)
VALUES
(7.5, 4, 2), 
(8.0, 5, 2),
(9.0, 6, 2); 
SELECT * FROM tbl_nota;

-- VIEW FREQUENCIA

CREATE OR REPLACE VIEW vw_frequencia_por_aluno_materia AS
SELECT
    id_aluno,
    id_materia,
    COUNT(CASE WHEN f.presenca = 1 THEN 1 END) AS total_presenca,
    COUNT(CASE WHEN f.presenca = 0 THEN 1 END) AS total_falta,
    COUNT(*) AS total_aulas,
    CONCAT(ROUND(COUNT(CASE WHEN f.presenca = 1 THEN 1 END) / COUNT(*) * 100, 2), '%') AS porcentagem_frequencia
FROM
    tbl_frequencia f
GROUP BY
    id_aluno,
    id_materia;

-- INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia)
-- VALUES (false, '2025-10-22', 3, 1);

--------------------------------------------------------------

-- VIEW MEDIA ATIVIDADES TURMA - DOCENTE

DROP VIEW IF EXISTS vw_media_atividades_turma;
CREATE VIEW vw_media_atividades_turma AS
SELECT 
    t.id_turma,
    t.turma AS turma,
    a.id_atividade,
    a.titulo AS atividade,
    a.descricao AS descricao_atividade, -- ✅ ADICIONADO
    c.categoria,
    ROUND(AVG(n.nota), 2) AS media_atividade,
    n.id_semestre,
    m.id_materia,         -- ✅ ADICIONADO
    m.materia             -- ✅ ADICIONADO
FROM tbl_turma t
JOIN tbl_aluno al ON al.id_turma = t.id_turma
JOIN tbl_atividade_aluno aa ON aa.id_aluno = al.id_aluno
JOIN tbl_atividade a ON a.id_atividade = aa.id_atividade
JOIN tbl_categoria c ON c.id_categoria = a.id_categoria
JOIN tbl_nota n ON n.id_atividade_aluno = aa.id_atividade_aluno
JOIN tbl_materia m ON a.id_materia = m.id_materia -- ✅ ADICIONADO JOIN DA MATÉRIA
GROUP BY 
    t.id_turma, 
    t.turma, 
    a.id_atividade, 
    a.titulo, 
    a.descricao,   -- ✅ ADICIONADO AO GROUP BY
    c.categoria, 
    n.id_semestre,
    m.id_materia, 
    m.materia;     -- ✅ ADICIONADO AO GROUP BY

-- VIEW FREQUENCIA MEDIA TURMA 

DROP VIEW IF EXISTS vw_frequencia_media_turma;
CREATE VIEW vw_frequencia_media_turma AS
SELECT
    t.id_turma,
    t.turma,
    st.id_semestre,

    COUNT(DISTINCT al.id_aluno) AS total_alunos,

    COUNT(DISTINCT fq.data_frequencia) AS total_aulas,

    -- Presenças únicas por aluno/data
    SUM(fq.presenca) AS total_presenca,
    SUM(1 - fq.presenca) AS total_falta,

    -- Frequência média: total_presenca / (total_alunos * total_aulas)
    CONCAT(
        ROUND(
            SUM(fq.presenca) / (COUNT(DISTINCT al.id_aluno) * COUNT(DISTINCT fq.data_frequencia)) * 100,
        2), '%'
    ) AS frequencia_turma

FROM tbl_turma t
JOIN tbl_semestre_turma st ON st.id_turma = t.id_turma
JOIN tbl_aluno al ON al.id_turma = t.id_turma
JOIN (
    -- pega apenas uma linha por aluno por data
    SELECT id_aluno, data_frequencia, MAX(presenca) AS presenca
    FROM tbl_frequencia
    GROUP BY id_aluno, data_frequencia
) fq ON fq.id_aluno = al.id_aluno

GROUP BY t.id_turma, t.turma, st.id_semestre;

-- INSERT INTO tbl_semestre_turma (id_turma, id_semestre)
-- VALUES (2, 1);

-- INSERT INTO tbl_turma_professor (id_turma, id_professor) 
-- VALUES (1, 5);

-- VIEW DESEMPENHO TURMA (CORRIGIDA)
DROP VIEW IF EXISTS vw_desempenho_turma;
CREATE VIEW vw_desempenho_turma AS
SELECT
    TPA.id_professor, 
    P.nome AS nome_professor,

    MA.id_turma,
    MA.turma,
    MA.id_semestre,
    MA.id_materia,              -- ✅ ADICIONADO
    MA.materia,                 -- ✅ ADICIONADO
    MA.atividade,
    MA.descricao_atividade,     -- ✅ ADICIONADO
    MA.categoria,
    MA.media_atividade,

    -- Campos de frequência
    FT.frequencia_turma,
    FT.total_presenca,
    FT.total_falta,
    FT.total_aulas,

    (
        SELECT ROUND(AVG(MA_SUB.media_atividade), 2)
        FROM vw_media_atividades_turma MA_SUB
        JOIN tbl_atividade TPA_SUB ON TPA_SUB.id_atividade = MA_SUB.id_atividade
        WHERE 
            MA_SUB.id_turma = MA.id_turma
            AND MA_SUB.id_semestre = MA.id_semestre 
            AND TPA_SUB.id_professor = TPA.id_professor 
    ) AS media_geral_professor
FROM 
    vw_media_atividades_turma MA
LEFT JOIN 
    vw_frequencia_media_turma FT
    ON FT.id_turma = MA.id_turma
   AND FT.id_semestre = MA.id_semestre
JOIN 
    tbl_atividade TPA
    ON TPA.id_atividade = MA.id_atividade 
JOIN 
    tbl_professor P
    ON P.id_professor = TPA.id_professor;

----------------------------

-- VIEW MEDIA TURMA MATERIA SEMESTRE - GESTÃO

USE db_analytica_ai;

  DROP VIEW IF EXISTS vw_media_atividade_materia;
CREATE VIEW vw_media_atividade_materia AS
SELECT 
    g.id_gestao,
    g.nome AS nome,
    t.id_turma,
    t.turma,
    m.id_materia,
    m.materia,
    a.id_atividade,
    a.titulo AS atividade,
    a.descricao AS descricao_atividade, -- <<< CAMPO ADICIONADO
    c.categoria,
    -- Forçando o tipo DECIMAL(10, 2) para garantir casas decimais
    CAST(ROUND(AVG(n.nota), 2) AS DECIMAL(10, 2)) AS media_atividade_materia,
    n.id_semestre
FROM 
    tbl_nota n
INNER JOIN tbl_atividade_aluno aa ON n.id_atividade_aluno = aa.id_atividade_aluno
INNER JOIN tbl_atividade a ON aa.id_atividade = a.id_atividade
INNER JOIN tbl_materia m ON a.id_materia = m.id_materia
INNER JOIN tbl_categoria c ON c.id_categoria = a.id_categoria
INNER JOIN tbl_aluno al ON aa.id_aluno = al.id_aluno
INNER JOIN tbl_turma t ON al.id_turma = t.id_turma
INNER JOIN tbl_gestao_turma tg ON t.id_turma = tg.id_turma
INNER JOIN tbl_gestao g ON tg.id_gestao = g.id_gestao
GROUP BY 
    g.id_gestao, g.nome,
    t.id_turma, t.turma,
    m.id_materia, m.materia,
    a.id_atividade, a.titulo, a.descricao, -- <<< ADICIONADO AO GROUP BY
    c.categoria,
    n.id_semestre;


-- VIEW FREQUENCIA MEDIA TURMA MATERIA SEMESTRE

 DROP VIEW IF EXISTS vw_frequencia_turma_materia;
CREATE OR REPLACE VIEW vw_frequencia_turma_materia AS
SELECT 
    t.id_turma,
    t.turma,
    m.id_materia,
    m.materia,
    st.id_semestre,
    
    -- CONTADORES: Usamos CAST(COUNT AS SIGNED) para evitar o erro BigInt (o 'n' no Node.js)
    CAST(SUM(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) AS SIGNED) AS total_presenca, -- <<< CAMPO NOVO
    CAST(SUM(CASE WHEN f.presenca = 0 THEN 1 ELSE 0 END) AS SIGNED) AS total_falta,    -- <<< CAMPO NOVO
    CAST(COUNT(*) AS SIGNED) AS total_aulas,                                            -- <<< CAMPO NOVO
    
    CONCAT(
        ROUND(
            AVG(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) * 100, 
        2), '%'
    ) AS frequencia_turma_materia
FROM 
    tbl_frequencia f
INNER JOIN tbl_materia m 
    ON f.id_materia = m.id_materia
INNER JOIN tbl_aluno a 
    ON f.id_aluno = a.id_aluno
INNER JOIN tbl_turma t 
    ON a.id_turma = t.id_turma
INNER JOIN tbl_semestre_turma st 
    ON st.id_turma = t.id_turma
GROUP BY 
    t.id_turma, t.turma, m.id_materia, m.materia, st.id_semestre;

-- VIEW MEDIA DA MEDIA TURMA
  
 DROP VIEW IF EXISTS vw_media_turma_materia;
CREATE VIEW vw_media_turma_materia AS
SELECT 
    ma.id_gestao,
    ma.nome,
    ma.id_turma,
    ma.turma,
    ma.id_materia,
    ma.materia,
    ma.id_semestre,
    -- FORÇANDO FLOAT NO CÁLCULO
    ROUND(AVG(ma.media_atividade_materia * 1.0), 2) AS media_turma_materia
FROM 
    vw_media_atividade_materia ma
GROUP BY 
    ma.id_gestao,
    ma.nome,
    ma.id_turma,
    ma.turma,
    ma.id_materia,
    ma.materia,
    ma.id_semestre;

-- VIEW DESEMPENHO

DROP VIEW IF EXISTS vw_desempenho_turma_materia;
CREATE VIEW vw_desempenho_turma_materia AS
SELECT 
    g.id_gestao,
    g.nome AS nome_gestao,
    mt.id_turma,
    mt.turma,
    mt.id_materia,
    mt.materia,
    mt.id_semestre,
    mt.media_turma_materia,
    fm.frequencia_turma_materia,
    fm.total_presenca, 
    fm.total_falta,
    fm.total_aulas,
    ma.id_atividade,
    ma.atividade,
    ma.descricao_atividade,
    ma.categoria,
    ma.media_atividade_materia
FROM 
    tbl_gestao g
LEFT JOIN 
    vw_media_turma_materia mt 
        ON g.id_gestao = mt.id_gestao
LEFT JOIN 
    vw_frequencia_turma_materia fm 
        ON mt.id_turma = fm.id_turma
       AND mt.id_materia = fm.id_materia
       AND mt.id_semestre = fm.id_semestre
LEFT JOIN 
    vw_media_atividade_materia ma 
        ON mt.id_turma = ma.id_turma
       AND mt.id_materia = ma.id_materia
       AND mt.id_semestre = ma.id_semestre;

-- INSERT INTO tbl_gestao (
-- 	nome,
--     telefone,
--     email,
--     id_usuario
-- )VALUES(
-- 	"Jheniffer Rodrigues",
--     "(11) 9 1823-7602",
--     "gestao@gmail.com",
--     8
-- );

-- insert into tbl_gestao_turma(
--     id_gestao,
--     id_turma
-- )value
-- 	(2, 2),
--     (2, 1);

----------------------------

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

--------------------------------------------------------------------------

-- POPULANDO AS TABELAS COM DADOS

-- Desativa a checagem de chaves estrangeiras para permitir o TRUNCATE
SET FOREIGN_KEY_CHECKS = 0;

-- Limpeza de Tabelas de Dados (Ordem inversa das dependências é mais seguro, mas com o FK_CHECKS=0, não é estritamente necessário)
TRUNCATE TABLE tbl_nota;
TRUNCATE TABLE tbl_frequencia;
TRUNCATE TABLE tbl_observacao;
TRUNCATE TABLE tbl_insights;
TRUNCATE TABLE tbl_relatorio;
TRUNCATE TABLE tbl_atividade_aluno;
TRUNCATE TABLE tbl_atividade;
TRUNCATE TABLE tbl_recurso_aluno;
TRUNCATE TABLE tbl_recursos;
TRUNCATE TABLE tbl_turma_professor;
TRUNCATE TABLE tbl_semestre_turma;
TRUNCATE TABLE tbl_gestao_turma;
TRUNCATE TABLE tbl_aluno;
TRUNCATE TABLE tbl_professor;
TRUNCATE TABLE tbl_gestao;

-- Limpeza de Tabelas de Estrutura e Usuários
TRUNCATE TABLE tbl_materia;
TRUNCATE TABLE tbl_categoria;
TRUNCATE TABLE tbl_semestre;
TRUNCATE TABLE tbl_turma;
TRUNCATE TABLE tbl_usuarios;

-- Reativa a checagem de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Todas as tabelas foram limpas e auto-incrementos resetados.' AS Status;

-- -------------------------------------------------------------------------------------

CALL sp_inserir_turma('1º Período - A');     -- ID_TURMA = 1
CALL sp_inserir_turma('1º Período - B');     -- ID_TURMA = 2
CALL sp_inserir_turma('2º Período - C');     -- ID_TURMA = 3

select * from tbl_turma;

CALL sp_inserir_semestre('2024.1');            -- ID_SEMESTRE = 1
CALL sp_inserir_semestre('2024.2');            -- ID_SEMESTRE = 2

select * from tbl_semestre;

CALL sp_inserir_categoria('Prova');             -- ID_CATEGORIA = 1
CALL sp_inserir_categoria('Trabalho');          -- ID_CATEGORIA = 2
CALL sp_inserir_categoria('Teste Rápido');      -- ID_CATEGORIA = 3

select * from tbl_categoria;

CALL sp_inserir_materia('Matemática', '#EA4335');     -- ID_MATERIA = 1 (Exatas)
CALL sp_inserir_materia('Português', '#4285F4');      -- ID_MATERIA = 2 (Humanas)
CALL sp_inserir_materia('História', '#FCDD03');       -- ID_MATERIA = 3 (Humanas)
CALL sp_inserir_materia('Biologia', '#34A853');       -- ID_MATERIA = 4 (Biológicas)
CALL sp_inserir_materia('Física', '#1A73E8');        -- ID_MATERIA = 5 (Exatas)
CALL sp_inserir_materia('Artes', '#FF6D00');          -- ID_MATERIA = 6 (Humanas)

select * from tbl_materia;

-- GESTÃO (ID_GESTAO = 1)
CALL sp_cadastrar_usuario_completo('10010010', 'gestao', 'gestão', 'Ana Gestora', 'ana.g@escola.com', '100100010', NULL, NULL, NULL);

-- PROFESSORES (3)
CALL sp_cadastrar_usuario_completo('50150150', 'profMat', 'professor', 'Prof. Carlos (Mat)', 'carlos.m@escola.com', '50150150', '1975-03-10', NULL, NULL); -- ID_PROFESSOR = 1
CALL sp_cadastrar_usuario_completo('50250250', 'profPort', 'professor', 'Prof. Claudia (Port)', 'claudia.p@escola.com', '50250250', '1985-11-20', NULL, NULL); -- ID_PROFESSOR = 2
CALL sp_cadastrar_usuario_completo('50350350', 'profBio', 'professor', 'Prof. Gabriel (Bio)', 'gabriel.b@escola.com', '50350350', '1990-09-01', NULL, NULL);    -- ID_PROFESSOR = 3

-- Turma 1 (ID_TURMA = 1)
CALL sp_cadastrar_usuario_completo('93344', 'a1a1a1a1', 'aluno', 'Lucas Silva', 'lucas.s@aluno.com', '93344', '2000-01-15', '2001', 1); -- ID_ALUNO = 1 (CHAVE)
CALL sp_cadastrar_usuario_completo('94455', 'a2a2a2a2', 'aluno', 'Beatriz Souza', 'bia.s@aluno.com', '94455', '2001-05-20', '2002', 1); -- ID_ALUNO = 2
CALL sp_cadastrar_usuario_completo('95566', 'a3a3a3a3', 'aluno', 'Carlos Lima', 'carlos.l@aluno.com', '95566', '1999-12-01', '2003', 1); -- ID_ALUNO = 3
CALL sp_cadastrar_usuario_completo('96677', 'a4a4a4a4', 'aluno', 'Diana Rosa', 'diana.r@aluno.com', '96677', '2000-08-25', '2004', 1); -- ID_ALUNO = 4
CALL sp_cadastrar_usuario_completo('97788', 'a5a5a5a5', 'aluno', 'Eduardo Neves', 'eduardo.n@aluno.com', '97788', '2001-03-11', '2005', 1); -- ID_ALUNO = 5

-- Turma 2 (ID_TURMA = 2)
CALL sp_cadastrar_usuario_completo('98899', 'a6a6a6a6', 'aluno', 'Fernanda Guedes', 'fef.g@aluno.com', '98899', '2002-07-07', '2006', 2); -- ID_ALUNO = 6
CALL sp_cadastrar_usuario_completo('90011', 'a7a7a7a7', 'aluno', 'Gustavo Viana', 'guga.v@aluno.com', '90011', '2003-04-18', '2007', 2); -- ID_ALUNO = 7
CALL sp_cadastrar_usuario_completo('92233', 'a8a8a8a8', 'aluno', 'Heloisa Farias', 'helo.f@aluno.com', '92233', '2002-10-30', '2008', 3); -- ID_ALUNO = 8

-- Turma 3 (ID_TURMA = 3)
CALL sp_cadastrar_usuario_completo('944551', 'a9a9a9a9', 'aluno', 'Igor Santos', 'igor.s@aluno.com', '944551', '2001-06-12', '2009', 3); -- ID_ALUNO = 9
CALL sp_cadastrar_usuario_completo('966771', 'a10a10a1', 'aluno', 'Joana Rocha', 'joana.r@aluno.com', '966771', '2003-01-22', '2010', 3); -- ID_ALUNO = 10
CALL sp_cadastrar_usuario_completo('24122460', 'a11a11a1', 'aluno', 'João Campos', 'joaosantos20071009@gmail.com', '(11) 9 9450-9385', '2007-09-11', '24122460', 3); -- ID_ALUNO = 11

select * from tbl_usuarios;
select * from tbl_aluno;
select * from tbl_professor;
select * from tbl_gestao;

INSERT INTO tbl_turma_professor (id_professor, id_turma) VALUES 
(1, 1), (1, 2), (1, 3), -- Prof Carlos em todas as turmas
(2, 1), (2, 2),          -- Prof Claudia em Turmas 1 e 2
(3, 3);                  -- Prof Gabriel na Turma 3

select * from tbl_turma_professor;

-- Gestão e Semestres em Turmas
INSERT INTO tbl_gestao_turma (id_gestao, id_turma) VALUES (1, 1), (1, 2), (1, 3);
INSERT INTO tbl_semestre_turma (id_turma, id_semestre) VALUES (1, 1), (1, 2), (2, 1), (2, 2), (3, 1), (3, 2);

select * from tbl_gestao_turma;
select * from tbl_semestre_turma;

-- Matemática (ID_MATERIA = 1, ID_PROFESSOR = 1)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES 
('Prova Mat S1', 'Matemática Prova S1', '2024-04-15', 1, 1, 1),  -- ID_ATIVIDADE = 1
('Teste Mat S2', 'Matemática Teste S2', '2024-10-15', 1, 1, 3);  -- ID_ATIVIDADE = 2

-- Português (ID_MATERIA = 2, ID_PROFESSOR = 2)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES 
('Trabalho Port S1', 'Português Trabalho S1', '2024-05-01', 2, 2, 2), -- ID_ATIVIDADE = 3
('Prova Port S2', 'Português Prova S2', '2024-11-01', 2, 2, 1);   -- ID_ATIVIDADE = 4

-- Biologia (ID_MATERIA = 4, ID_PROFESSOR = 3)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES 
('Teste Bio S1', 'Biologia Teste S1', '2024-03-20', 4, 3, 3), -- ID_ATIVIDADE = 5
('Trabalho Bio S2', 'Biologia Trabalho S2', '2024-09-30', 4, 3, 2), -- ID_ATIVIDADE = 6
('Prova Bio S2', 'Biologia Trabalho S2', '2024-10-20', 4, 3, 1); -- ID_ATIVIDADE = 7

select * from tbl_atividade;

-- Aluno 11 (Turma 3) em todas atividades
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (1, 11), (2, 11), (3, 11), (4, 11), (5, 11), (6, 11), (7, 11); -- ID_ATIVIDADE_ALUNO 1 AO 7

select * from tbl_atividade_aluno;

-- Média Aluno 11 em Mat
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (10.0, 1, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (9.5, 2, 2);

-- Média Aluno 11 em Port
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.0, 3, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.5, 4, 2);

-- Média Aluno 11 em Bio
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (9.0, 5, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.5, 6, 2);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (8.5, 7, 2);

select * from tbl_nota;

-- Aluno 11 (João) em Matemática (4 aulas)
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia) VALUES 
(true, '2024-03-01', 11, 1), (false, '2024-03-02', 11, 1), -- 50%
(true, '2024-03-03', 11, 1), (true, '2024-03-04', 11, 1); -- (3/4 = 75%)

-- Aluno 11 (João) em Português (4 aulas)
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia) VALUES 
(true, '2024-03-01', 11, 2), (false, '2024-03-02', 11, 2), -- 50%
(true, '2024-03-03', 11, 2), (true, '2024-03-04', 11, 2); -- (3/4 = 75%)

-- Aluno 11 (João) em Português (4 aulas)
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia) VALUES 
(true, '2024-03-01', 11, 4), (true, '2024-03-02', 11, 4), -- 100%
(true, '2024-03-03', 11, 4), (true, '2024-03-04', 11, 4); -- (4/4 = 100%)

select * from tbl_frequencia;

-- --------------------------------------------------------------------
-- ** CONSULTAS DE VALIDAÇÃO (Para rodar após a inserção) **
-- --------------------------------------------------------------------

-- TESTE A: VALIDAÇÃO DA MÉDIA DO ALUNO POR SEMESTRE (Alunos diferentes com notas diferentes)
-- Aluno 11 (João) em Matemática (ID=1). Média S1: 10.0, Média S2: 9.5
SELECT 
    *
FROM vw_desempenho_aluno 
WHERE id_aluno = 11 AND id_materia = 1;

-- TESTE B: VALIDAÇÃO DA MÉDIA DA ATIVIDADE POR TURMA (Docente)
SELECT 
    *
FROM vw_desempenho_turma
WHERE id_professor = 3 AND id_turma = 3;

-- TESTE C: VALIDAÇÃO DA MÉDIA CONSOLIDADA POR MATÉRIA/TURMA (Gestão)
SELECT 
   *
FROM vw_desempenho_turma_materia
WHERE id_gestao = 1 AND id_turma = 3 AND id_materia = 4 AND id_semestre = 2;

-- POPULANDO MAIS AINDA

-- Aluno 9 (Igor Santos) em todas atividades
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (1, 9), (2, 9), (3, 9), (4, 9), (5, 9), (6, 9), (7, 9); 
-- ID_ATIVIDADE_ALUNO 8 AO 14

-- Média Aluno 9 em Bio (ID_ATIVIDADE_ALUNO 12, 13, 14)
-- S1: Teste Bio S1 (ID_ATIVIDADE = 5)
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (8.0, 12, 1); 

-- S2: Trabalho Bio S2 (ID_ATIVIDADE = 6)
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (6.0, 13, 2); 
-- S2: Prova Bio S2 (ID_ATIVIDADE = 7)
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.0, 14, 2); 

-- Média Turma 3, Biologia, Semestre 2 (Turma: Aluno 9 + Aluno 11)
-- Atividade 6 (Trabalho Bio S2): (7.5 + 6.0) / 2 = 6.75
-- Atividade 7 (Prova Bio S2): (8.5 + 7.0) / 2 = 7.75

-- Média FINAL ESPERADA: (6.75 + 7.75) / 2 = 14.50 / 2 = 7.25

-- Aluno 9 (Igor) em Biologia (4 aulas)
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia) VALUES 
(true, '2024-03-01', 9, 4), (true, '2024-03-02', 9, 4), 
(false, '2024-03-03', 9, 4), (true, '2024-03-04', 9, 4); 
-- (3/4 = 75%)

--------------------------------------------------------------------------