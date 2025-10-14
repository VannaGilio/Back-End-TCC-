USE db_analytica_ai;

CREATE VIEW listarUsuarios AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

CREATE VIEW buscarAluno AS
SELECT
    id_aluno,
    nome,
    data_nascimento,
    matricula,
    telefone,
    email
FROM tbl_aluno;

CREATE VIEW buscarUsuarios AS
SELECT
    id_usuario,
	credencial,
    senha,
    nivel_usuario
FROM tbl_usuarios;

CREATE VIEW buscarProfessor AS
SELECT
    id_professor,
    nome,
    data_nascimento,
    telefone,
    email
FROM tbl_professor;

CREATE VIEW buscarTurma AS
SELECT
    id_turma,
    turma
FROM tbl_turma;

CREATE VIEW buscarMateria AS
SELECT
    id_materia,
    materia,
    cor_materia
FROM tbl_materia;

CREATE VIEW buscarSemestre AS
SELECT
    id_semestre,
    semestre
FROM tbl_semestre;


CREATE VIEW buscarCategoria AS 
SELECT
    id_categoria,
    categoria
FROM tbl_categoria;



---------------------------------------------------------------


CREATE VIEW buscarGestao AS
SELECT
    tbl_gestao.id_gestao,
    tbl_gestao.nome,
    tbl_gestao.telefone,
    tbl_gestao.email,
    tbl_usuario.id_usuario,
    tbl_usuario.credencial,
    tbl_usuario.senha,
    tbl_usuario.nivel_usuario
FROM tbl_gestao;
JOIN tbl_usuario ON tbl_gestao.id_usuario = tbl_usuario.id_usuario


CREATE VIEW buscarSemestreTurma AS
SELECT
    tbl_semestre_turma.id_semestre_turma,
    tbl_turma.id_turma,
    tbl_turma.turma,
	tbl_semestre.id_semestre,
    tbl_semestre.semestre,
FROM tbl_semestre_turma
JOIN tbl_turma ON tbl_semestre_turma.id_turma = tbl_turma.id_turma
JOIN tbl_semestre ON tbl_semestre_turma.id_semestre = tbl_semestre.id_semestre;

CREATE VIEW buscarTurmaProfesor AS
SELECT
    tbl_turma_professor.id_turma_professor,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario,
    tbl_turma.id_turma,
    tbl_turma.turma
FROM tbl_turma_professor
JOIN tbl_professor ON tbl_turma_professor.id_professor = tbl_professor.id_professor
JOIN tbl_turma ON tbl_turma_professor.id_turma = tbl_turma.id_turma;



CREATE VIEW buscarRecursos AS
SELECT
    tbl_recursos.id_recursos,
    tbl_recursos.titulo,
    tbl_recursos.descricao,
    tbl_recursos.data_criacao,
    tbl_materia.id_materia,
    tbl_materia.materia,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario
FROM tbl_recursos
JOIN tbl_materia ON tbl_recursos.id_materia = tbl_materia.id_materia
JOIN tbl_professor ON tbl_recursos.id_professor = tbl_professor.id_professor;


CREATE VIEW buscarRecursoAluno AS
SELECT
    tbl_recurso_aluno.id_recursos_aluno,
    tbl_recursos.id_recursos,
    tbl_recursos.titulo,
    tbl_recursos.descricao,
    tbl_recursos.data_criacao,
    tbl_recursos.id_materia,
    tbl_recursos.id_professor,
    tbl_aluno.id_aluno,
    tbl_aluno.nome,
    tbl_aluno.data_nascimento,
    tbl_aluno.matricula,
    tbl_aluno.telefone,
    tbl_aluno.email,
    tbl_aluno.id_usuario,
    tbl_aluno.id_turma
FROM tbl_recurso_aluno
JOIN tbl_recursos ON tbl_recurso_aluno.id_recursos = tbl_recursos.id_recursos
JOIN tbl_aluno ON tbl_recurso_aluno.id_aluno = tbl_aluno.id_aluno;


CREATE VIEW buscarAtividade AS
    tbl_atividades.id_atividade,
    tbl_atividades.titulo,
    tbl_atividades.descricao,
    data_criacao,
	tbl_atividades.id_materia,
    tbl_professor.id_professor,
    tbl_professor.nome,
    tbl_professor.data_nascimento,
    tbl_professor.telefone,
    tbl_professor.email,
    tbl_professor.id_usuario,
    tbl_categoria.id_categoria,
    tbl_categoria.categoria,
FROM tbl_atividade;


CREATE VIEW buscarAtividadeAluno AS
    id_atividade_aluno,
    id_atividade,
    id_aluno
FROM tbl_atividade_aluno;


CREATE VIEW buscarFrequencia AS
    id_frequencia,
    presenca,
    data_frequencia,
    id_aluno,
    id_materia
FROM tbl_frequencia;

CREATE VIEW buscarNota AS
    id_nota,
    nota,
    id_atividade_aluno,
    id_semestre
FROM tbl_nota;



CREATE VIEW buscarObservacao AS
    id_observacao,
    descricao,
    id_atividade,
    id_aluno
FROM tbl_observacao;


CREATE VIEW buscarInsigths AS
    id_insights,
    insights,
    id_materia,
    id_aluno,
    id_professor
FROM tbl_insights;

CREATE VIEW buscarRelatorio AS
    id_relatorio,
    relatorio,
    titulo,
    data_criacao,
    id_aluno,
    id_professor,
    id_materia 
FROM tbl_relatorio;













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