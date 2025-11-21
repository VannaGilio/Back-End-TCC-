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

-- Criação das tabelas de curso e turma
CREATE TABLE tbl_turma (
    id_turma INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    turma VARCHAR(45) NOT NULL
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
    link_criterio VARCHAR(255),
    data_criacao DATE NOT NULL,
    id_materia INT NOT NULL,
    id_professor INT NOT NULL,
    id_turma INT NOT NULL,
    id_semestre INT NOT NULL,
    CONSTRAINT fk_recursos_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_recursos_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor)
        ON DELETE CASCADE,
    CONSTRAINT fk_recursos_turma
        FOREIGN KEY (id_turma)
        REFERENCES tbl_turma (id_turma)
        ON DELETE CASCADE,
    CONSTRAINT fk_recursos_semestre
        FOREIGN KEY (id_semestre)
        REFERENCES tbl_semestre (id_semestre)
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
    id_semestre INT,
    CONSTRAINT fk_frequencia_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno)
        ON DELETE CASCADE,
    CONSTRAINT fk_frequencia_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia)
        ON DELETE CASCADE,
    CONSTRAINT fk_frequencia_semestre
    FOREIGN KEY (id_semestre)
    REFERENCES tbl_semestre (id_semestre)
    ON DELETE SET NULL
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
    link TEXT NOT NULL,
    data_geracao DATETIME NOT NULL,
    tipo_relatorio VARCHAR(40) NOT NULL,
    tipo_nivel VARCHAR(50) NOT NULL,
    id_aluno INT,
    id_professor INT,
    id_gestao INT,
    id_materia INT NOT NULL,
    id_turma INT,
    id_semestre INT NOT NULL,
    CONSTRAINT fk_relatorio_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES tbl_aluno (id_aluno),
    CONSTRAINT fk_relatorio_professor
        FOREIGN KEY (id_professor)
        REFERENCES tbl_professor (id_professor),
    CONSTRAINT fk_relatorio_materia
        FOREIGN KEY (id_materia)
        REFERENCES tbl_materia (id_materia),
    CONSTRAINT fk_relatorio_gestao
        FOREIGN KEY (id_gestao)
        REFERENCES tbl_gestao (id_gestao),
    CONSTRAINT fk_relatorio_turma
        FOREIGN KEY (id_turma)
        REFERENCES tbl_turma (id_turma),
    CONSTRAINT fk_relatorio_semestre
        FOREIGN KEY (id_semestre)
        REFERENCES tbl_semestre (id_semestre)
);

-----------------------------------------------------------------------------------------

USE db_analytica_ai;

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

-- VIEW FREQUENCIA MEDIA TURMA MATERIA SEMESTRE

DROP VIEW IF EXISTS vw_frequencia_turma_materia;
CREATE VIEW vw_frequencia_turma_materia AS
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