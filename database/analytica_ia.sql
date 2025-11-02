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
    id_semestre INT NOT NULL
    CONSTRAINT fk_frequencia_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno)
        ON DELETE CASCADE,
    CONSTRAINT fk_frequencia_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
        ON DELETE CASCADE
    CONSTRAINT fk_frequencia_semestre
    FOREIGN KEY (id_semestre)
    REFERENCES tbl_semestre (id_semestre)
    ON DELETE SET NULL;
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
data_geracao DATETIME NOT NULL,
tipo_insight VARCHAR(50) NOT NULL, 
titulo VARCHAR(255) NOT NULL,
conteudo TEXT NOT NULL,
id_materia INT NOT NULL,
id_semestre INT NOT NULL,
id_aluno INT NULL,
id_professor INT NULL,
id_gestao INT NULL,
id_turma INT NULL, 
-- Chaves Estrangeiras
CONSTRAINT fk_insights_materia
    FOREIGN KEY (id_materia)
    REFERENCES tbl_materia (id_materia),
CONSTRAINT fk_insights_semestre
    FOREIGN KEY (id_semestre)
    REFERENCES tbl_semestre (id_semestre),
CONSTRAINT fk_insights_aluno
    FOREIGN KEY (id_aluno)
    REFERENCES tbl_aluno (id_aluno),
CONSTRAINT fk_insights_professor
    FOREIGN KEY (id_professor)
    REFERENCES tbl_professor (id_professor),
CONSTRAINT fk_insights_gestao
    FOREIGN KEY (id_gestao)
    REFERENCES tbl_gestao (id_gestao),
CONSTRAINT fk_insights_turma
    FOREIGN KEY (id_turma)
    REFERENCES tbl_turma (id_turma)
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
DROP PROCEDURE IF EXISTS sp_inserir_professor;
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
DROP PROCEDURE IF EXISTS sp_gerar_token_recuperacao;
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

-- PROCEDURE - VALIDAR TOKEN E RESETAR SENHA
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_resetar_senha;
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

-- ----------------------------------------------------------

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

-- --------------------------------------------------------------

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

-- -------------------------------

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

-- VIEW FREQUENCIA

DROP VIEW IF EXISTS vw_frequencia_por_aluno_materia;
CREATE VIEW vw_frequencia_por_aluno_materia AS
SELECT
    f.id_aluno,
    f.id_materia,
    f.id_semestre,
    COUNT(CASE WHEN f.presenca = 1 THEN 1 END) AS total_presenca,
    COUNT(CASE WHEN f.presenca = 0 THEN 1 END) AS total_falta,
    COUNT(*) AS total_aulas,
    CONCAT(ROUND(
        IF(COUNT(*) = 0, 0,
           COUNT(CASE WHEN f.presenca = 1 THEN 1 END) / COUNT(*) * 100
        ), 2), '%') AS porcentagem_frequencia
FROM
    tbl_frequencia f
GROUP BY
    f.id_aluno,
    f.id_materia,
    f.id_semestre;

-- VIEW DESEMPENHO DO ALUNO
DROP VIEW IF EXISTS vw_desempenho_aluno;
CREATE VIEW vw_desempenho_aluno AS
SELECT 
    al.id_aluno,
    al.nome AS nome_aluno,
    m.id_materia,
    m.materia,
    a.id_atividade,
    a.titulo AS atividade,
    a.descricao AS descricao_atividade,
    c.categoria,
    n.nota,
    n.id_semestre,
    (
        SELECT AVG(n2.nota)
        FROM tbl_nota n2
        INNER JOIN tbl_atividade_aluno aa2 
            ON n2.id_atividade_aluno = aa2.id_atividade_aluno
        INNER JOIN tbl_atividade a2 
            ON aa2.id_atividade = a2.id_atividade
        WHERE aa2.id_aluno = al.id_aluno
          AND a2.id_materia = m.id_materia
          AND n2.id_semestre = n.id_semestre
    ) AS media_materia,
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
LEFT JOIN vw_frequencia_por_aluno_materia f
    ON f.id_aluno = al.id_aluno
   AND f.id_materia = m.id_materia
   AND f.id_semestre = n.id_semestre;

-- ------------------------------------------------------------

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
CREATE OR REPLACE VIEW vw_frequencia_media_turma AS
SELECT
    t.id_turma,
    t.turma,
    f.id_semestre,
    COUNT(DISTINCT a.id_aluno) AS total_alunos,
    CAST(COUNT(*) AS SIGNED) AS total_registros_freq,
    CAST(SUM(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) AS SIGNED) AS total_presenca,
    CAST(SUM(CASE WHEN f.presenca = 0 THEN 1 ELSE 0 END) AS SIGNED) AS total_falta,
    CONCAT(
        ROUND(
            IF(COUNT(*) = 0, 0,
               SUM(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100
            ), 2), '%'
    ) AS frequencia_turma
FROM tbl_turma t
JOIN tbl_aluno a ON a.id_turma = t.id_turma
JOIN tbl_frequencia f ON f.id_aluno = a.id_aluno
GROUP BY t.id_turma, t.turma, f.id_semestre;

-- VIEW DESEMPENHO TURMA (CORRIGIDA)
DROP VIEW IF EXISTS vw_desempenho_turma;
CREATE VIEW vw_desempenho_turma AS
SELECT
    TPA.id_professor, 
    P.nome AS nome_professor,
    MA.id_turma,
    MA.turma,
    MA.id_semestre,
    MA.id_materia,              
    MA.materia,                 
    MA.atividade,
    MA.descricao_atividade,     
    MA.categoria,
    MA.media_atividade,
    FT.frequencia_turma_materia,
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
    vw_frequencia_turma_materia FT
    ON FT.id_turma = MA.id_turma
   AND FT.id_semestre = MA.id_semestre
   AND FT.id_materia = MA.id_materia
JOIN 
    tbl_atividade TPA ON TPA.id_atividade = MA.id_atividade 
JOIN 
    tbl_professor P ON P.id_professor = TPA.id_professor;

-- --------------------------

-- VIEW MEDIA TURMA MATERIA SEMESTRE - GESTÃO

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
    f.id_semestre,
    
    CAST(SUM(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) AS SIGNED) AS total_presenca,
    CAST(SUM(CASE WHEN f.presenca = 0 THEN 1 ELSE 0 END) AS SIGNED) AS total_falta,
    CAST(COUNT(*) AS SIGNED) AS total_aulas,
    
    CONCAT(
        ROUND(
            IF(COUNT(*) = 0, 0,
               AVG(CASE WHEN f.presenca = 1 THEN 1 ELSE 0 END) * 100
            ), 2), '%'
    ) AS frequencia_turma_materia
FROM 
    tbl_frequencia f
INNER JOIN tbl_materia m ON f.id_materia = m.id_materia
INNER JOIN tbl_aluno a ON f.id_aluno = a.id_aluno
INNER JOIN tbl_turma t ON a.id_turma = t.id_turma
GROUP BY 
    t.id_turma, t.turma, m.id_materia, m.materia, f.id_semestre;

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

-- --------------------------

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

-- ALTERAÇÃO TABELA DE USUÁRIOS
ALTER TABLE tbl_usuarios
ADD COLUMN token_recuperacao VARCHAR(255) NULL AFTER senha,
ADD COLUMN expiracao_token DATETIME NULL AFTER token_recuperacao;

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

-- ------------------------------------------------------------------------

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

-- ------------------------------------------------------------------------

-- ANALÍSES / MUDANÇAS / INSERÇÃO ACERCA DA FREQUÊNCIA

SET FOREIGN_KEY_CHECKS = 0;
-- Limpando antes de popular (opcional, só se estiver testando)
truncate table tbl_frequencia;

-- Frequências para o 1º semestre (2024.1)
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
-- Giovanna Gilio (turma 1)
(1, '2024-03-01', 1, 1, 1), (1, '2024-03-02', 1, 2, 1), (0, '2024-03-03', 1, 3, 1), (1, '2024-03-04', 1, 4, 1), 
(0, '2024-03-05', 1, 5, 1), (1, '2024-03-06', 1, 6, 1),

-- Beatriz Souza
(1, '2024-03-01', 2, 1, 1), (1, '2024-03-02', 2, 2, 1), (1, '2024-03-03', 2, 3, 1), (0, '2024-03-04', 2, 4, 1),
(1, '2024-03-05', 2, 5, 1), (1, '2024-03-06', 2, 6, 1),

-- Carlos Lima
(0, '2024-03-01', 3, 1, 1), (1, '2024-03-02', 3, 2, 1), (1, '2024-03-03', 3, 3, 1), (1, '2024-03-04', 3, 4, 1),
(0, '2024-03-05', 3, 5, 1), (1, '2024-03-06', 3, 6, 1),

-- Diana Rosa
(1, '2024-03-01', 4, 1, 1), (1, '2024-03-02', 4, 2, 1), (1, '2024-03-03', 4, 3, 1), (1, '2024-03-04', 4, 4, 1),
(1, '2024-03-05', 4, 5, 1), (1, '2024-03-06', 4, 6, 1),

-- Fernanda Guedes (turma 2)
(0, '2024-03-01', 6, 1, 1), (0, '2024-03-02', 6, 2, 1), (1, '2024-03-03', 6, 3, 1), (1, '2024-03-04', 6, 4, 1),
(1, '2024-03-05', 6, 5, 1), (0, '2024-03-06', 6, 6, 1),

-- Gustavo Viana
(1, '2024-03-01', 7, 1, 1), (0, '2024-03-02', 7, 2, 1), (1, '2024-03-03', 7, 3, 1), (0, '2024-03-04', 7, 4, 1),
(1, '2024-03-05', 7, 5, 1), (1, '2024-03-06', 7, 6, 1),

-- Heloisa Farias (turma 3)
(1, '2024-03-01', 8, 1, 1), (1, '2024-03-02', 8, 2, 1), (0, '2024-03-03', 8, 3, 1), (0, '2024-03-04', 8, 4, 1),
(1, '2024-03-05', 8, 5, 1), (1, '2024-03-06', 8, 6, 1),

-- Igor Santos
(0, '2024-03-01', 9, 1, 1), (1, '2024-03-02', 9, 2, 1), (0, '2024-03-03', 9, 3, 1), (1, '2024-03-04', 9, 4, 1),
(1, '2024-03-05', 9, 5, 1), (0, '2024-03-06', 9, 6, 1),

-- Joana Rocha
(1, '2024-03-01', 10, 1, 1), (1, '2024-03-02', 10, 2, 1), (1, '2024-03-03', 10, 3, 1), (1, '2024-03-04', 10, 4, 1),
(1, '2024-03-05', 10, 5, 1), (0, '2024-03-06', 10, 6, 1),

-- João Victor Campos dos Santos
(1, '2024-03-01', 11, 1, 1), (0, '2024-03-02', 11, 2, 1), (1, '2024-03-03', 11, 3, 1), (1, '2024-03-04', 11, 4, 1),
(1, '2024-03-05', 11, 5, 1), (1, '2024-03-06', 11, 6, 1);

-- ============================
-- 📅 Frequências do 2º semestre (id_semestre = 2)
-- ============================
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
-- Alunos da turma 1 (variações de presença)
(1, '2024-08-01', 1, 1, 2), (0, '2024-08-02', 1, 2, 2), (1, '2024-08-03', 1, 3, 2), (1, '2024-08-04', 1, 4, 2),
(1, '2024-08-05', 1, 5, 2), (1, '2024-08-06', 1, 6, 2),

(1, '2024-08-01', 2, 1, 2), (1, '2024-08-02', 2, 2, 2), (1, '2024-08-03', 2, 3, 2), (1, '2024-08-04', 2, 4, 2),
(1, '2024-08-05', 2, 5, 2), (0, '2024-08-06', 2, 6, 2),

(1, '2024-08-01', 3, 1, 2), (0, '2024-08-02', 3, 2, 2), (1, '2024-08-03', 3, 3, 2), (1, '2024-08-04', 3, 4, 2),
(0, '2024-08-05', 3, 5, 2), (1, '2024-08-06', 3, 6, 2),

-- Turma 2 (Fernanda e Gustavo)
(1, '2024-08-01', 6, 1, 2), (1, '2024-08-02', 6, 2, 2), (1, '2024-08-03', 6, 3, 2), (0, '2024-08-04', 6, 4, 2),
(1, '2024-08-05', 6, 5, 2), (1, '2024-08-06', 6, 6, 2),

(0, '2024-08-01', 7, 1, 2), (1, '2024-08-02', 7, 2, 2), (1, '2024-08-03', 7, 3, 2), (1, '2024-08-04', 7, 4, 2),
(1, '2024-08-05', 7, 5, 2), (0, '2024-08-06', 7, 6, 2),

-- Turma 3 (Heloisa, Igor, Joana, João Victor)
(1, '2024-08-01', 8, 1, 2), (0, '2024-08-02', 8, 2, 2), (1, '2024-08-03', 8, 3, 2), (0, '2024-08-04', 8, 4, 2),
(1, '2024-08-05', 8, 5, 2), (1, '2024-08-06', 8, 6, 2),

(1, '2024-08-01', 9, 1, 2), (1, '2024-08-02', 9, 2, 2), (1, '2024-08-03', 9, 3, 2), (1, '2024-08-04', 9, 4, 2),
(1, '2024-08-05', 9, 5, 2), (0, '2024-08-06', 9, 6, 2),

(1, '2024-08-01', 10, 1, 2), (0, '2024-08-02', 10, 2, 2), (1, '2024-08-03', 10, 3, 2), (1, '2024-08-04', 10, 4, 2),
(1, '2024-08-05', 10, 5, 2), (1, '2024-08-06', 10, 6, 2),

(0, '2024-08-01', 11, 1, 2), (1, '2024-08-02', 11, 2, 2), (1, '2024-08-03', 11, 3, 2), (1, '2024-08-04', 11, 4, 2),
(0, '2024-08-05', 11, 5, 2), (1, '2024-08-06', 11, 6, 2);

SET FOREIGN_KEY_CHECKS = 1;

-- Frequência agregada por aluno, matéria e semestre
SELECT * FROM vw_frequencia_por_aluno_materia;

-- Frequência agregada por turma, matéria e semestre
SELECT * FROM vw_frequencia_turma_materia;

-- Desempenho do aluno (média + frequência)
SELECT * FROM vw_desempenho_aluno;

-- Desempenho geral (gestão)
SELECT * FROM vw_desempenho_turma;

-- INSERT PARA FICAR BRINCANDO COM OS VALORES DA PRESENÇA
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
-- Alunos da turma 1 (variações de presença)
(1, '2024-08-03', 11, 1, 2)

-- ---------------------------------------------------------------------

-- =================================================================
-- 1. VIEWS DE BASE (Para todos os níveis de acesso)
-- =================================================================

-- 1.1. vw_ranking_base
-- Consolida a média final do aluno por matéria e semestre, e calcula o ranking
DROP VIEW IF EXISTS vw_ranking_base;

CREATE VIEW vw_ranking_base AS
SELECT
    A.id_aluno,
    A.nome AS nome_aluno,
    A.id_turma,
    T.turma,
    M.id_materia,
    M.materia,
    VS.id_semestre,
    VS.semestre,
    -- Calcula a média geral das atividades do aluno na matéria/semestre
    CAST(ROUND(AVG(N.nota), 2) AS DECIMAL(10, 2)) AS media_consolidada,
    -- Calcula a posição no ranking (a posição 1 é a maior nota)
    DENSE_RANK() OVER (
        PARTITION BY VS.id_semestre, M.id_materia, A.id_turma 
        ORDER BY AVG(N.nota) DESC
    ) AS posicao_ranking
FROM
    tbl_aluno A
JOIN 
    tbl_turma T ON A.id_turma = T.id_turma
JOIN 
    tbl_atividade_aluno AA ON A.id_aluno = AA.id_aluno
JOIN 
    tbl_atividade AT ON AA.id_atividade = AT.id_atividade
JOIN 
    tbl_materia M ON AT.id_materia = M.id_materia
JOIN 
    tbl_nota N ON AA.id_atividade_aluno = N.id_atividade_aluno
JOIN 
    tbl_semestre VS ON N.id_semestre = VS.id_semestre
GROUP BY
    A.id_aluno, A.nome, A.id_turma, T.turma, M.id_materia, VS.id_semestre
ORDER BY
    VS.id_semestre, M.id_materia, A.id_turma, media_consolidada DESC;


-- 1.2. vw_ranking_professor
-- Adiciona o ID do professor para filtros de segurança
DROP VIEW IF EXISTS vw_ranking_professor;

CREATE VIEW vw_ranking_professor AS
SELECT
    A.id_professor,
    RB.id_aluno,
    RB.nome_aluno,
    RB.id_turma,
    RB.turma,
    RB.id_materia,
    RB.materia,
    RB.id_semestre,
    RB.media_consolidada,
    RB.posicao_ranking
FROM
    vw_ranking_base RB
JOIN
    -- Encontra o ID do professor que criou a atividade naquela matéria
    (SELECT DISTINCT id_materia, id_professor FROM tbl_atividade) A 
    ON RB.id_materia = A.id_materia
JOIN
    -- Garante que o professor leciona na turma em questão (filtro de acesso)
    tbl_turma_professor TP 
    ON RB.id_turma = TP.id_turma AND A.id_professor = TP.id_professor;


-- 1.3. vw_ranking_gestao
-- Adiciona o ID da gestão para filtros de segurança
DROP VIEW IF EXISTS vw_ranking_gestao;

CREATE VIEW vw_ranking_gestao AS
SELECT
    GT.id_gestao,
    RB.*
FROM
    vw_ranking_base RB
JOIN
    tbl_gestao_turma GT ON RB.id_turma = GT.id_turma;


-- =================================================================
-- 2. FUNÇÃO DE CENSURA (Exclusiva para a visão do Aluno)
-- =================================================================

DELIMITER $$

DROP FUNCTION IF EXISTS fn_censurar_nome_aluno;

CREATE FUNCTION fn_censurar_nome_aluno (
    nome_completo VARCHAR(255),
    id_aluno_ranking INT,
    id_aluno_logado INT
)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE nome_censurado VARCHAR(255);

    -- Se for o aluno logado, retorna o nome completo.
    IF id_aluno_ranking = id_aluno_logado THEN
        RETURN nome_completo;
    ELSE
        -- Censura: Primeiro Nome + Inicial do Último Nome.
        -- Ex: 'Lucas Silva' -> 'Lucas S.'
        SET nome_censurado = CONCAT(
            SUBSTRING_INDEX(nome_completo, ' ', 1),
            ' ',
            LEFT(SUBSTRING_INDEX(nome_completo, ' ', -1), 1),
            '.'
        );
        RETURN nome_censurado;
    END IF;
END $$

DELIMITER ;

select * from tbl_aluno;

CALL sp_get_ranking_aluno(11, 4, 1);

CALL sp_get_ranking_professor(3, 3, 4, 1);

CALL sp_get_ranking_gestao(1, 3, 4, 2);

-- =================================================================
-- INSERÇÃO DE DADOS ADICIONAIS PARA TESTE DE RANKING
-- =================================================================

-- ***************************************************************
-- ALUNOS DA TURMA 1 (Lucas, Beatriz, Carlos, Diana) - Semestre 1
-- ***************************************************************

-- 1. Lucas Silva (ID=1) - Notas Turma 1
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (1, 1), (3, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES 
(8.0, LAST_INSERT_ID() - 1, 1), -- Prova Mat S1 (ID=1): 8.0
(9.5, LAST_INSERT_ID(), 1);
-- Trabalho Port S1 (ID=3): 9.5
-- Média S1: Mat: 8.0 / Port: 9.5

-- 2. Beatriz Souza (ID=2) - Notas Turma 1
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (1, 2), (3, 2);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES 
(9.0, LAST_INSERT_ID() - 1, 1), -- Prova Mat S1 (ID=1): 9.0
(7.0, LAST_INSERT_ID(), 1);
-- Trabalho Port S1 (ID=3): 7.0
-- Média S1: Mat: 9.0 / Port: 7.0

-- 3. Carlos Lima (ID=3) - Notas Turma 1
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (1, 3), (3, 3);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES 
(8.0, LAST_INSERT_ID() - 1, 1), -- Prova Mat S1 (ID=1): 8.0
(8.5, LAST_INSERT_ID(), 1);
-- Trabalho Port S1 (ID=3): 8.5
-- Média S1: Mat: 8.0 / Port: 8.5

-- 4. Diana Rosa (ID=4) - Notas Turma 1
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (1, 4), (3, 4);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES 
(9.0, LAST_INSERT_ID() - 1, 1), -- Prova Mat S1 (ID=1): 9.0
(7.5, LAST_INSERT_ID(), 1);
-- Trabalho Port S1 (ID=3): 7.5
-- Média S1: Mat: 9.0 / Port: 7.5

-- ***************************************************************
-- ALUNOS DA TURMA 3 (Igor, Joana, João) - Semestre 1 (Biologia)
-- ***************************************************************
-- João (ID=11) já tem nota 9.0 no Teste Bio S1 (ID=5)

-- 5. Igor Santos (ID=9) já tem nota 8.0 no Teste Bio S1 (ID=5)

-- 6. Joana Rocha (ID=10) - Notas Turma 3
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES (5, 10);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES 
(9.5, LAST_INSERT_ID(), 1);
-- Teste Bio S1 (ID=5): 9.5
-- Média S1: Bio: 9.5

-- ***************************************************************
-- RESUMO DO RANKING ESPERADO (Turma 3, Biologia, S1)
-- ***************************************************************
-- 1º Joana Rocha: 9.5
-- 2º João Campos: 9.0
-- 3º Igor Santos: 8.0

-- -----------------------------------------------------------------------

