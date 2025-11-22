USE db_analytica_ai;

-- Desativar checagem de FKs e limpar todas as tabelas de dados
SET FOREIGN_KEY_CHECKS = 0;

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
TRUNCATE TABLE tbl_materia;
TRUNCATE TABLE tbl_categoria;
TRUNCATE TABLE tbl_semestre;
TRUNCATE TABLE tbl_turma;
TRUNCATE TABLE tbl_usuarios;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- BASE: TURMAS, SEMESTRES, CATEGORIAS, MATÉRIAS
-- =====================================================

CALL sp_inserir_turma('1º Período - A');     -- id_turma = 1
CALL sp_inserir_turma('1º Período - B');     -- id_turma = 2
CALL sp_inserir_turma('2º Período - C');     -- id_turma = 3

CALL sp_inserir_semestre('2024.1');          -- id_semestre = 1
CALL sp_inserir_semestre('2024.2');          -- id_semestre = 2

CALL sp_inserir_categoria('Prova');          -- id_categoria = 1
CALL sp_inserir_categoria('Trabalho');       -- id_categoria = 2
CALL sp_inserir_categoria('Teste Rápido');   -- id_categoria = 3

-- Matérias compatíveis com o bloco de recursos
CALL sp_inserir_materia('Matemática', '#EA4335');         -- id_materia = 1
CALL sp_inserir_materia('Português', '#4285F4');          -- id_materia = 2
CALL sp_inserir_materia('História', '#FCDD03');           -- id_materia = 3
CALL sp_inserir_materia('Geografia', '#34A853');          -- id_materia = 4
CALL sp_inserir_materia('Ciências / Biologia', '#1A73E8');-- id_materia = 5
CALL sp_inserir_materia('Inglês', '#FF6D00');             -- id_materia = 6

-- =====================================================
-- GESTÃO + PROFESSORES
-- =====================================================

-- Gestão (id_gestao = 1)
CALL sp_cadastrar_usuario_completo(
    '10010010',          -- credencial
    'gestao',            -- senha
    'gestão',            -- nível
    'Ana Gestora',       -- nome
    'ana.g@escola.com',  -- email
    '100100010',         -- telefone
    NULL,                -- data_nascimento
    NULL,                -- matricula
    NULL                 -- id_turma
);

-- Professores (3)
CALL sp_cadastrar_usuario_completo(
    '50150150',          -- credencial
    'profMat',           -- senha
    'professor',         -- nível
    'Prof. Carlos (Mat)',
    'carlos.m@escola.com',
    '50150150',
    '1975-03-10',        -- data_nascimento
    NULL,                -- matricula
    NULL                 -- id_turma
); -- id_professor = 1

CALL sp_cadastrar_usuario_completo(
    '50250250',
    'profPort',
    'professor',
    'Prof. Claudia (Port)',
    'claudia.p@escola.com',
    '50250250',
    '1985-11-20',
    NULL,
    NULL
); -- id_professor = 2

CALL sp_cadastrar_usuario_completo(
    '50350350',
    'profCiencias',
    'professor',
    'Prof. Gabriel (Ciências)',
    'gabriel.b@escola.com',
    '50350350',
    '1990-09-01',
    NULL,
    NULL
); -- id_professor = 3

-- =====================================================
-- ALUNOS (11 ALUNOS INICIAIS)
-- =====================================================

-- Turma 1 (id_turma = 1)
CALL sp_cadastrar_usuario_completo('93344',  'a1a1a1a1', 'aluno', 'Lucas Silva',    'lucas.s@aluno.com',  '93344',  '2000-01-15', '2001', 1); -- id_aluno = 1
CALL sp_cadastrar_usuario_completo('94455',  'a2a2a2a2', 'aluno', 'Beatriz Souza',  'bia.s@aluno.com',    '94455',  '2001-05-20', '2002', 1); -- id_aluno = 2
CALL sp_cadastrar_usuario_completo('95566',  'a3a3a3a3', 'aluno', 'Carlos Lima',    'carlos.l@aluno.com', '95566',  '1999-12-01', '2003', 1); -- id_aluno = 3
CALL sp_cadastrar_usuario_completo('96677',  'a4a4a4a4', 'aluno', 'Diana Rosa',     'diana.r@aluno.com',  '96677',  '2000-08-25', '2004', 1); -- id_aluno = 4
CALL sp_cadastrar_usuario_completo('97788',  'a5a5a5a5', 'aluno', 'Eduardo Neves', 'eduardo.n@aluno.com','97788',  '2001-03-11', '2005', 1); -- id_aluno = 5

-- Turma 2 (id_turma = 2)
CALL sp_cadastrar_usuario_completo('98899',  'a6a6a6a6', 'aluno', 'Fernanda Guedes','fef.g@aluno.com',   '98899',  '2002-07-07', '2006', 2); -- id_aluno = 6
CALL sp_cadastrar_usuario_completo('90011',  'a7a7a7a7', 'aluno', 'Gustavo Viana', 'guga.v@aluno.com',  '90011',  '2003-04-18', '2007', 2); -- id_aluno = 7
CALL sp_cadastrar_usuario_completo('92233',  'a8a8a8a8', 'aluno', 'Heloisa Farias','helo.f@aluno.com',  '92233',  '2002-10-30', '2008', 3); -- id_aluno = 8

-- Turma 3 (id_turma = 3)
CALL sp_cadastrar_usuario_completo('944551', 'a9a9a9a9',  'aluno', 'Igor Santos',  'igor.s@aluno.com',  '944551', '2001-06-12', '2009', 3); -- id_aluno = 9
CALL sp_cadastrar_usuario_completo('966771', 'a10a10a1',  'aluno', 'Joana Rocha', 'joana.r@aluno.com', '966771', '2003-01-22', '2010', 3); -- id_aluno = 10
CALL sp_cadastrar_usuario_completo('24122460','a11a11a1', 'aluno', 'João Campos', 'joaosantos20071009@gmail.com','(11) 9 9450-9385','2007-09-11','24122460', 3); -- id_aluno = 11

-- =====================================================
-- RELACIONAMENTOS TURMA/PROF, GESTÃO/TURMA, SEMESTRE/TURMA
-- =====================================================

INSERT INTO tbl_turma_professor (id_professor, id_turma) VALUES 
(1, 1), (1, 2), (1, 3), -- Prof Carlos em todas as turmas
(2, 1), (2, 2),         -- Prof Claudia em Turmas 1 e 2
(3, 3);                 -- Prof Gabriel na Turma 3

INSERT INTO tbl_gestao_turma (id_gestao, id_turma) VALUES 
(1, 1), (1, 2), (1, 3);

INSERT INTO tbl_semestre_turma (id_turma, id_semestre) VALUES 
(1, 1), (1, 2),
(2, 1), (2, 2),
(3, 1), (3, 2);

-- =====================================================
-- ATIVIDADES (MESMO PADRÃO DO analytica_ia.sql)
-- =====================================================

-- Matemática (id_materia = 1, id_professor = 1)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES 
('Prova Mat S1',  'Matemática Prova S1',  '2024-04-15', 1, 1, 1), -- id_atividade = 1
('Teste Mat S2',  'Matemática Teste S2',  '2024-10-15', 1, 1, 3); -- id_atividade = 2

-- Português (id_materia = 2, id_professor = 2)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES 
('Trabalho Port S1', 'Português Trabalho S1', '2024-05-01', 2, 2, 2), -- id_atividade = 3
('Prova Port S2',    'Português Prova S2',    '2024-11-01', 2, 2, 1);  -- id_atividade = 4

-- Ciências / Biologia (id_materia = 5, id_professor = 3)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES 
('Teste Bio S1',      'Biologia Teste S1',      '2024-03-20', 5, 3, 3), -- id_atividade = 5
('Trabalho Bio S2',   'Biologia Trabalho S2',   '2024-09-30', 5, 3, 2), -- id_atividade = 6
('Prova Bio S2',      'Biologia Prova S2',      '2024-10-20', 5, 3, 1); -- id_atividade = 7

-- =====================================================
-- LIGAÇÃO ATIVIDADE x ALUNO + NOTAS (ALUNO 11 E 9 EM TODAS)
-- =====================================================

-- Aluno 11 (João Campos) em todas as atividades
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES 
(1, 11), (2, 11), (3, 11), (4, 11), (5, 11), (6, 11), (7, 11);

-- Notas do Aluno 11
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (10.0, 1, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (9.5, 2, 2);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.0, 3, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.5, 4, 2);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (9.0, 5, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.5, 6, 2);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (8.5, 7, 2);

-- Aluno 9 (Igor Santos) em todas as atividades
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno) VALUES 
(1, 9), (2, 9), (3, 9), (4, 9), (5, 9), (6, 9), (7, 9);
-- Estes registros gerarão id_atividade_aluno de 8 a 14

-- Notas do Aluno 9 em Biologia (atividades 5, 6, 7 -> ids 12, 13, 14)
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (8.0, 12, 1);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (6.0, 13, 2);
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre) VALUES (7.0, 14, 2);

-- =====================================================
-- FREQUÊNCIA COMPLETA (1º E 2º SEMESTRE, ALUNOS 1..11)
-- (reaproveitado do bloco de frequência já existente)
-- =====================================================

INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
-- Giovanna Gilio (turma 1) - aqui usando id_aluno = 1
(1, '2024-03-01', 1, 1, 1), (1, '2024-03-02', 1, 2, 1), (0, '2024-03-03', 1, 3, 1), (1, '2024-03-04', 1, 5, 1), 
(0, '2024-03-05', 1, 1, 1), (1, '2024-03-06', 1, 6, 1),

-- Beatriz Souza (id_aluno = 2)
(1, '2024-03-01', 2, 1, 1), (1, '2024-03-02', 2, 2, 1), (1, '2024-03-03', 2, 3, 1), (0, '2024-03-04', 2, 5, 1),
(1, '2024-03-05', 2, 1, 1), (1, '2024-03-06', 2, 6, 1),

-- Carlos Lima (id_aluno = 3)
(0, '2024-03-01', 3, 1, 1), (1, '2024-03-02', 3, 2, 1), (1, '2024-03-03', 3, 3, 1), (1, '2024-03-04', 3, 5, 1),
(0, '2024-03-05', 3, 1, 1), (1, '2024-03-06', 3, 6, 1),

-- Diana Rosa (id_aluno = 4)
(1, '2024-03-01', 4, 1, 1), (1, '2024-03-02', 4, 2, 1), (1, '2024-03-03', 4, 3, 1), (1, '2024-03-04', 4, 5, 1),
(1, '2024-03-05', 4, 1, 1), (1, '2024-03-06', 4, 6, 1),

-- Fernanda Guedes (id_aluno = 6)
(0, '2024-03-01', 6, 1, 1), (0, '2024-03-02', 6, 2, 1), (1, '2024-03-03', 6, 3, 1), (1, '2024-03-04', 6, 5, 1),
(1, '2024-03-05', 6, 1, 1), (0, '2024-03-06', 6, 6, 1),

-- Gustavo Viana (id_aluno = 7)
(1, '2024-03-01', 7, 1, 1), (0, '2024-03-02', 7, 2, 1), (1, '2024-03-03', 7, 3, 1), (0, '2024-03-04', 7, 5, 1),
(1, '2024-03-05', 7, 1, 1), (1, '2024-03-06', 7, 6, 1),

-- Heloisa Farias (id_aluno = 8)
(1, '2024-03-01', 8, 1, 1), (1, '2024-03-02', 8, 2, 1), (0, '2024-03-03', 8, 3, 1), (0, '2024-03-04', 8, 5, 1),
(1, '2024-03-05', 8, 1, 1), (1, '2024-03-06', 8, 6, 1),

-- Igor Santos (id_aluno = 9)
(0, '2024-03-01', 9, 1, 1), (1, '2024-03-02', 9, 2, 1), (0, '2024-03-03', 9, 3, 1), (1, '2024-03-04', 9, 5, 1),
(1, '2024-03-05', 9, 1, 1), (0, '2024-03-06', 9, 6, 1),

-- Joana Rocha (id_aluno = 10)
(1, '2024-03-01', 10, 1, 1), (1, '2024-03-02', 10, 2, 1), (1, '2024-03-03', 10, 3, 1), (1, '2024-03-04', 10, 5, 1),
(1, '2024-03-05', 10, 1, 1), (0, '2024-03-06', 10, 6, 1),

-- João Victor / João Campos (id_aluno = 11)
(1, '2024-03-01', 11, 1, 1), (0, '2024-03-02', 11, 2, 1), (1, '2024-03-03', 11, 3, 1), (1, '2024-03-04', 11, 5, 1),
(1, '2024-03-05', 11, 1, 1), (1, '2024-03-06', 11, 6, 1);

-- Frequências do 2º semestre (id_semestre = 2)
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
(1, '2024-08-01', 1, 1, 2), (0, '2024-08-02', 1, 2, 2), (1, '2024-08-03', 1, 3, 2), (1, '2024-08-04', 1, 5, 2),
(1, '2024-08-05', 1, 1, 2), (1, '2024-08-06', 1, 6, 2),

(1, '2024-08-01', 2, 1, 2), (1, '2024-08-02', 2, 2, 2), (1, '2024-08-03', 2, 3, 2), (1, '2024-08-04', 2, 5, 2),
(1, '2024-08-05', 2, 1, 2), (0, '2024-08-06', 2, 6, 2),

(1, '2024-08-01', 3, 1, 2), (0, '2024-08-02', 3, 2, 2), (1, '2024-08-03', 3, 3, 2), (1, '2024-08-04', 3, 5, 2),
(0, '2024-08-05', 3, 1, 2), (1, '2024-08-06', 3, 6, 2),

(1, '2024-08-01', 6, 1, 2), (1, '2024-08-02', 6, 2, 2), (1, '2024-08-03', 6, 3, 2), (0, '2024-08-04', 6, 5, 2),
(1, '2024-08-05', 6, 1, 2), (1, '2024-08-06', 6, 6, 2),

(0, '2024-08-01', 7, 1, 2), (1, '2024-08-02', 7, 2, 2), (1, '2024-08-03', 7, 3, 2), (1, '2024-08-04', 7, 5, 2),
(1, '2024-08-05', 7, 1, 2), (0, '2024-08-06', 7, 6, 2),

(1, '2024-08-01', 8, 1, 2), (0, '2024-08-02', 8, 2, 2), (1, '2024-08-03', 8, 3, 2), (0, '2024-08-04', 8, 5, 2),
(1, '2024-08-05', 8, 1, 2), (1, '2024-08-06', 8, 6, 2),

(1, '2024-08-01', 9, 1, 2), (1, '2024-08-02', 9, 2, 2), (1, '2024-08-03', 9, 3, 2), (1, '2024-08-04', 9, 5, 2),
(1, '2024-08-05', 9, 1, 2), (0, '2024-08-06', 9, 6, 2),

(1, '2024-08-01', 10, 1, 2), (0, '2024-08-02', 10, 2, 2), (1, '2024-08-03', 10, 3, 2), (1, '2024-08-04', 10, 5, 2),
(1, '2024-08-05', 10, 1, 2), (1, '2024-08-06', 10, 6, 2),

(0, '2024-08-01', 11, 1, 2), (1, '2024-08-02', 11, 2, 2), (1, '2024-08-03', 11, 3, 2), (1, '2024-08-04', 11, 5, 2),
(0, '2024-08-05', 11, 1, 2), (1, '2024-08-06', 11, 6, 2);

-- Pequeno extra: uma linha a mais para brincar com percentuais
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES (1, '2024-08-03', 11, 1, 2);

-- =====================================================
-- RECURSOS COM LINKS REAIS (ADAPTADO DE new.sql)
-- =====================================================

INSERT INTO tbl_recursos (
    titulo,
    descricao,
    link_criterio,
    data_criacao,
    id_materia,
    id_professor,
    id_turma,
    id_semestre
) VALUES
-- Matemática (id_materia = 1)
('Vídeo - Revisão de Equações do 1º Grau',
 'Aula de revisão de equações do 1º grau com exemplos passo a passo.',
 'https://www.youtube.com/watch?v=Z0zKBCV3U2A',
 '2025-03-01',
 1,  -- Matemática
 1,  -- Professor
 3,  -- Turma
 1   -- Semestre
),
('Lista de Exercícios - Equações do 2º Grau',
 'Lista com exercícios de equações do 2º grau para treinar para a prova.',
 'https://www.youtube.com/watch?v=9T8A89jgeTI',
 '2025-03-02',
 1,
 1,
 3,
 1
),
('Vídeo - Funções Afim e Quadrática',
 'Vídeo explicando a diferença entre função afim e quadrática.',
 'https://www.youtube.com/watch?v=ZKkG5YcD3SM',
 '2025-03-03',
 1,
 1,
 3,
 2
),

-- Português (id_materia = 2)
('Vídeo - Interpretação de Texto Narrativo',
 'Aula sobre técnicas de interpretação de textos narrativos.',
 'https://www.youtube.com/watch?v=PZ4pctQM4zA',
 '2025-03-04',
 2,
 2,
 3,
 1
),
('Critérios de Avaliação - Redação Dissertativa',
 'Critérios de correção para redações dissertativas argumentativas.',
 'https://www.youtube.com/watch?v=3M3JZ5d4Z0s',
 '2025-03-05',
 2,
 2,
 3,
 2
),
('Vídeo - Coesão e Coerência na Redação',
 'Explicação sobre coesão e coerência com exemplos práticos.',
 'https://www.youtube.com/watch?v=s8hWQGz_3No',
 '2025-03-06',
 2,
 2,
 3,
 2
),

-- História (id_materia = 3)
('Documentário - Revolução Francesa',
 'Documentário introdutório sobre a Revolução Francesa.',
 'https://www.youtube.com/watch?v=E0KpG2K6Xn4',
 '2025-03-07',
 3,
 3,
 3,
 1
),
('Vídeo - Brasil Colônia',
 'Aula sobre o período colonial no Brasil.',
 'https://www.youtube.com/watch?v=evqXqgRZ0Vw',
 '2025-03-08',
 3,
 3,
 3,
 1
),

-- Geografia (id_materia = 4)
('Vídeo - Climas do Mundo',
 'Explicação sobre os principais tipos de clima do planeta.',
 'https://www.youtube.com/watch?v=Ys2uDn0vZ_E',
 '2025-03-09',
 4,
 3,
 3,
 1
),
('Vídeo - Urbanização e Problemas Urbanos',
 'Aula sobre urbanização, metrópoles e problemas urbanos.',
 'https://www.youtube.com/watch?v=VgK0tZ1B2cs',
 '2025-03-10',
 4,
 3,
 3,
 2
),

-- Ciências / Biologia (id_materia = 5)
('Vídeo - Sistema Digestório',
 'Vídeo aula sobre o funcionamento do sistema digestório humano.',
 'https://www.youtube.com/watch?v=8gI5qX2FXSs',
 '2025-03-11',
 5,
 2,
 3,
 1
),
('Vídeo - Cadeia Alimentar',
 'Explicação sobre cadeias e teias alimentares com exemplos simples.',
 'https://www.youtube.com/watch?v=K3u2aFSkD4M',
 '2025-03-12',
 5,
 2,
 3,
 2
),

-- Inglês (id_materia = 6)
('Vídeo - Simple Present Explicado',
 'Aula em português explicando o uso do Simple Present no inglês.',
 'https://www.youtube.com/watch?v=F1qOQvYg3qM',
 '2025-03-13',
 6,
 1,
 3,
 1
),
('Playlist - Listening para Iniciantes',
 'Playlist com exercícios de listening para iniciantes.',
 'https://www.youtube.com/watch?v=jL8uDJJBjMA&list=PL-listening-iniciantes',
 '2025-03-14',
 6,
 1,
 3,
 2
);

-- =====================================================
-- EXPANSÃO: NOVOS PROFESSORES PARA MATÉRIAS RESTANTES
-- =====================================================

CALL sp_cadastrar_usuario_completo(
    '50450450', 'profHist', 'professor',
    'Prof. Helena (História)', 'helena.h@escola.com', '50450450',
    '1982-02-10', NULL, NULL
); -- id_professor = 4

CALL sp_cadastrar_usuario_completo(
    '50550550', 'profGeo', 'professor',
    'Prof. Paulo (Geografia)', 'paulo.g@escola.com', '50550550',
    '1984-07-22', NULL, NULL
); -- id_professor = 5

CALL sp_cadastrar_usuario_completo(
    '50650650', 'profIng', 'professor',
    'Prof. Ingrid (Inglês)', 'ingrid.i@escola.com', '50650650',
    '1991-09-30', NULL, NULL
); -- id_professor = 6

-- Associar novos professores principalmente à Turma 3 (2º Período - C)
INSERT INTO tbl_turma_professor (id_professor, id_turma) VALUES
    (4, 3), -- História - Turma C
    (5, 3), -- Geografia - Turma C
    (6, 3); -- Inglês - Turma C

-- =====================================================
-- NOVAS ATIVIDADES GLOBAIS POR MATÉRIA (S1 E S2)
-- =====================================================

-- Matemática (id_materia = 1, id_professor = 1)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Mat - Avaliação Global S1', 'Avaliação global de Matemática - 2024.1', '2024-04-30', 1, 1, 1),
('Mat - Avaliação Global S2', 'Avaliação global de Matemática - 2024.2', '2024-10-30', 1, 1, 1);

-- Português (id_materia = 2, id_professor = 2)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Port - Avaliação Global S1', 'Avaliação global de Português - 2024.1', '2024-04-30', 2, 2, 1),
('Port - Avaliação Global S2', 'Avaliação global de Português - 2024.2', '2024-10-30', 2, 2, 1);

-- História (id_materia = 3, id_professor = 4)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Hist - Avaliação Global S1', 'Avaliação global de História - 2024.1', '2024-04-30', 3, 4, 1),
('Hist - Avaliação Global S2', 'Avaliação global de História - 2024.2', '2024-10-30', 3, 4, 1);

-- Geografia (id_materia = 4, id_professor = 5)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Geo - Avaliação Global S1', 'Avaliação global de Geografia - 2024.1', '2024-04-30', 4, 5, 1),
('Geo - Avaliação Global S2', 'Avaliação global de Geografia - 2024.2', '2024-10-30', 4, 5, 1);

-- Ciências / Biologia (id_materia = 5, id_professor = 3)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('CienBio - Avaliação Global S1', 'Avaliação global de Ciências/Biologia - 2024.1', '2024-04-30', 5, 3, 1),
('CienBio - Avaliação Global S2', 'Avaliação global de Ciências/Biologia - 2024.2', '2024-10-30', 5, 3, 1);

-- Inglês (id_materia = 6, id_professor = 6)
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Ing - Avaliação Global S1', 'Avaliação global de Inglês - 2024.1', '2024-04-30', 6, 6, 1),
('Ing - Avaliação Global S2', 'Avaliação global de Inglês - 2024.2', '2024-10-30', 6, 6, 1);

-- =====================================================
-- DISTRIBUIR NOVAS ATIVIDADES PARA TODOS OS ALUNOS 1-11
-- =====================================================

-- Cada aluno 1..11 recebe todas as avaliações globais de todas as matérias (S1 e S2)
INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno)
SELECT
    a.id_atividade,
    al.id_aluno
FROM tbl_atividade a
JOIN tbl_aluno al ON al.id_aluno BETWEEN 1 AND 11
WHERE a.titulo IN (
    'Mat - Avaliação Global S1',
    'Mat - Avaliação Global S2',
    'Port - Avaliação Global S1',
    'Port - Avaliação Global S2',
    'Hist - Avaliação Global S1',
    'Hist - Avaliação Global S2',
    'Geo - Avaliação Global S1',
    'Geo - Avaliação Global S2',
    'CienBio - Avaliação Global S1',
    'CienBio - Avaliação Global S2',
    'Ing - Avaliação Global S1',
    'Ing - Avaliação Global S2'
);

-- =====================================================
-- NOTAS PARA TODAS AS NOVAS ATIVIDADES (RANKING BEM POPULADO)
-- =====================================================

-- Uma nota por combinação (aluno, atividade global), com variação por aluno
INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre)
SELECT
    CASE
        WHEN al.id_aluno IN (1, 2, 10, 11) THEN 9.0
        WHEN al.id_aluno IN (3, 4, 5, 9) THEN 8.0
        WHEN al.id_aluno IN (6, 7) THEN 7.0
        ELSE 6.5
    END AS nota,
    aa.id_atividade_aluno,
    CASE
        WHEN a.titulo LIKE '%S1' THEN 1
        ELSE 2
    END AS id_semestre
FROM tbl_atividade_aluno aa
JOIN tbl_atividade a ON a.id_atividade = aa.id_atividade
JOIN tbl_aluno al ON al.id_aluno = aa.id_aluno
WHERE al.id_aluno BETWEEN 1 AND 11
  AND a.titulo LIKE '%Avaliação Global S%';

-- =====================================================
-- FREQUÊNCIAS ADICIONAIS (FOCO ESPECIAL NA TURMA 3)
-- =====================================================

-- Frequências extras para todos os alunos 1..11 em Matemática, Português e Ciências/Biologia
-- Datas adicionais em 2024.1 e 2024.2 para enriquecer as views de frequência
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
-- 2024.1 (semestre 1) - Matemática (1), Português (2), Cien/Bio (5)
(1, '2024-03-10', 1, 1, 1), (1, '2024-03-10', 1, 2, 1), (1, '2024-03-10', 1, 5, 1),
(1, '2024-03-10', 2, 1, 1), (0, '2024-03-10', 2, 2, 1), (1, '2024-03-10', 2, 5, 1),
(0, '2024-03-10', 3, 1, 1), (1, '2024-03-10', 3, 2, 1), (1, '2024-03-10', 3, 5, 1),
(1, '2024-03-10', 4, 1, 1), (1, '2024-03-10', 4, 2, 1), (1, '2024-03-10', 4, 5, 1),
(1, '2024-03-10', 5, 1, 1), (0, '2024-03-10', 5, 2, 1), (1, '2024-03-10', 5, 5, 1),
(0, '2024-03-10', 6, 1, 1), (1, '2024-03-10', 6, 2, 1), (1, '2024-03-10', 6, 5, 1),
(1, '2024-03-10', 7, 1, 1), (1, '2024-03-10', 7, 2, 1), (0, '2024-03-10', 7, 5, 1),
(1, '2024-03-10', 8, 1, 1), (1, '2024-03-10', 8, 2, 1), (1, '2024-03-10', 8, 5, 1),
(1, '2024-03-10', 9, 1, 1), (0, '2024-03-10', 9, 2, 1), (1, '2024-03-10', 9, 5, 1),
(1, '2024-03-10', 10, 1, 1), (1, '2024-03-10', 10, 2, 1), (1, '2024-03-10', 10, 5, 1),
(1, '2024-03-10', 11, 1, 1), (1, '2024-03-10', 11, 2, 1), (1, '2024-03-10', 11, 5, 1),

-- 2024.2 (semestre 2) - mesmas matérias
(1, '2024-08-10', 1, 1, 2), (0, '2024-08-10', 1, 2, 2), (1, '2024-08-10', 1, 5, 2),
(1, '2024-08-10', 2, 1, 2), (1, '2024-08-10', 2, 2, 2), (1, '2024-08-10', 2, 5, 2),
(0, '2024-08-10', 3, 1, 2), (1, '2024-08-10', 3, 2, 2), (1, '2024-08-10', 3, 5, 2),
(1, '2024-08-10', 4, 1, 2), (1, '2024-08-10', 4, 2, 2), (0, '2024-08-10', 4, 5, 2),
(1, '2024-08-10', 5, 1, 2), (1, '2024-08-10', 5, 2, 2), (1, '2024-08-10', 5, 5, 2),
(0, '2024-08-10', 6, 1, 2), (1, '2024-08-10', 6, 2, 2), (1, '2024-08-10', 6, 5, 2),
(1, '2024-08-10', 7, 1, 2), (0, '2024-08-10', 7, 2, 2), (1, '2024-08-10', 7, 5, 2),
(1, '2024-08-10', 8, 1, 2), (1, '2024-08-10', 8, 2, 2), (1, '2024-08-10', 8, 5, 2),
(1, '2024-08-10', 9, 1, 2), (1, '2024-08-10', 9, 2, 2), (0, '2024-08-10', 9, 5, 2),
(1, '2024-08-10', 10, 1, 2), (1, '2024-08-10', 10, 2, 2), (1, '2024-08-10', 10, 5, 2),
(1, '2024-08-10', 11, 1, 2), (1, '2024-08-10', 11, 2, 2), (1, '2024-08-10', 11, 5, 2);

-- Frequências extras específicas para Turma 3 (alunos 8, 9, 10, 11)
-- Inclui também História (3), Geografia (4) e Inglês (6) para o aluno 11 em todas as matérias
INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre)
VALUES
-- 2024.1 (semestre 1) - foco Turma C
(1, '2024-03-11', 8, 3, 1), (1, '2024-03-11', 8, 4, 1), (0, '2024-03-11', 8, 6, 1),
(1, '2024-03-11', 9, 3, 1), (0, '2024-03-11', 9, 4, 1), (1, '2024-03-11', 9, 6, 1),
(1, '2024-03-11', 10, 3, 1), (1, '2024-03-11', 10, 4, 1), (1, '2024-03-11', 10, 6, 1),
(1, '2024-03-11', 11, 1, 1), (1, '2024-03-11', 11, 2, 1), (1, '2024-03-11', 11, 3, 1),
(1, '2024-03-11', 11, 4, 1), (1, '2024-03-11', 11, 5, 1), (1, '2024-03-11', 11, 6, 1),

-- 2024.2 (semestre 2) - foco Turma C
(1, '2024-08-11', 8, 3, 2), (0, '2024-08-11', 8, 4, 2), (1, '2024-08-11', 8, 6, 2),
(1, '2024-08-11', 9, 3, 2), (1, '2024-08-11', 9, 4, 2), (0, '2024-08-11', 9, 6, 2),
(1, '2024-08-11', 10, 3, 2), (1, '2024-08-11', 10, 4, 2), (1, '2024-08-11', 10, 6, 2),
(1, '2024-08-11', 11, 1, 2), (1, '2024-08-11', 11, 2, 2), (1, '2024-08-11', 11, 3, 2),
(1, '2024-08-11', 11, 4, 2), (1, '2024-08-11', 11, 5, 2), (1, '2024-08-11', 11, 6, 2);
