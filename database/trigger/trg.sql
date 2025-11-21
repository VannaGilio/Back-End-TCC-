SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE tbl_relatorio;
TRUNCATE TABLE tbl_insights;
TRUNCATE TABLE tbl_observacao;
TRUNCATE TABLE tbl_nota;
TRUNCATE TABLE tbl_frequencia;
TRUNCATE TABLE tbl_atividade_aluno;
TRUNCATE TABLE tbl_recurso_aluno;
TRUNCATE TABLE tbl_atividade;
TRUNCATE TABLE tbl_recursos;
TRUNCATE TABLE tbl_turma_professor;
TRUNCATE TABLE tbl_semestre_turma;
TRUNCATE TABLE tbl_gestao_turma;
TRUNCATE TABLE tbl_aluno;
TRUNCATE TABLE tbl_professor;
TRUNCATE TABLE tbl_gestao;
TRUNCATE TABLE tbl_materia;
TRUNCATE TABLE tbl_turma;
TRUNCATE TABLE tbl_categoria;
TRUNCATE TABLE tbl_semestre;
TRUNCATE TABLE tbl_usuarios;

SET FOREIGN_KEY_CHECKS = 1;

CALL sp_inserir_semestre('2023.1');
CALL sp_inserir_semestre('2023.2'); 
CALL sp_inserir_semestre('2024.1'); 
CALL sp_inserir_semestre('2024.2');
CALL sp_inserir_semestre('2025.1'); 
CALL sp_inserir_semestre('2025.2');

CALL sp_inserir_categoria('Prova');    
CALL sp_inserir_categoria('Trabalho em Grupo'); 
CALL sp_inserir_categoria('Seminário');         
CALL sp_inserir_categoria('Atividade');   
CALL sp_inserir_categoria('Teste');
CALL sp_inserir_categoria('Redação');

CALL sp_inserir_turma('1º ano A');  
CALL sp_inserir_turma('1º ano B'); 
CALL sp_inserir_turma('2º ano A');     
CALL sp_inserir_turma('2º ano B'); 
CALL sp_inserir_turma('3º ano A'); 
CALL sp_inserir_turma('3º ano B');  
CALL sp_inserir_turma('9º ano A');  
CALL sp_inserir_turma('9º ano B');

CALL sp_inserir_materia('Matemática', '#00539C'); 
CALL sp_inserir_materia('Português', '#EEA47F'); 
CALL sp_inserir_materia('Biologia', '#4285F4');
CALL sp_inserir_materia('Inglês', '#FFC107');
CALL sp_inserir_materia('História', '#EA4335');            
CALL sp_inserir_materia('Química', '#34A853'); 
CALL sp_inserir_materia('Física', '#9C27B0');
CALL sp_inserir_materia('Geografia', '#FF6D00');  

CALL sp_cadastrar_usuario_completo('G1001', 'gestao123', 'gestão', 'Diretora Maria Costa', 'diretoria@analytica.com', '(11) 91111-1111', NULL, NULL, NULL);
CALL sp_cadastrar_usuario_completo('G1002', 'gestao123', 'gestão', 'Mariana Silva', 'diretoria2@analytica.com', '(11) 91111-2222', NULL, NULL, NULL);
CALL sp_cadastrar_usuario_completo('G1003', 'gestao123', 'gestão', 'Luciano Miguel', 'diretoria3@analytica.com', '(11) 91111-3333', NULL, NULL, NULL);

CALL sp_cadastrar_usuario_completo('P2001', 'prof123', 'professor', 'Prof. Alan Codd',      'alan.codd@analytica.com', '(11) 92222-1111', '1980-05-10', NULL, NULL); 
CALL sp_cadastrar_usuario_completo('P2002', 'prof123', 'professor', 'Prof. Ada Lovelace',   'ada.lovelace@analytica.com', '(11) 92222-2222', '1985-12-01', NULL, NULL); 
CALL sp_cadastrar_usuario_completo('P2003', 'prof123', 'professor', 'Prof. Machado de Assis','machado.assis@analytica.com','(11) 92222-3333', '1975-03-20', NULL, NULL); 
CALL sp_cadastrar_usuario_completo('P2004', 'prof123', 'professor', 'Prof. Peter Drucker',  'peter.drucker@analytica.com','(11) 92222-4444', '1982-11-15', NULL, NULL);
CALL sp_cadastrar_usuario_completo('P2005', 'prof123', 'professor', 'Prof. Marie Curie',    'marie.curie@analytica.com', '(11) 92222-5555', '1990-07-07', NULL, NULL); 
CALL sp_cadastrar_usuario_completo('P2006', 'prof123', 'professor', 'Prof. Oto Patrício',   'oto.patricio@analytica.com', '(11) 92222-6666', '1990-07-30', NULL, NULL); 
CALL sp_cadastrar_usuario_completo('P2007', 'prof123', 'professor', 'Prof. Luciana Coelho', 'luciana.coelho@analytica.com','(11) 92222-7777', '1990-03-30', NULL, NULL);


---
CALL sp_cadastrar_usuario_completo('24122460', 'a11a11a1', 'aluno', 'João Campos', 'joaosantos20071009@gmail.com', '(11) 9 9450-9385', '2007-09-11', '24122460', 3); -- ID_ALUNO = 11
CALL sp_cadastrar_usuario_completo('A1001', 'aluno123', 'aluno', 'Lucas Silva', 'lucas.s@aluno.com', '(11) 91001-0001', '2008-01-10', 'A1001', 1);
CALL sp_cadastrar_usuario_completo('A1002', 'aluno123', 'aluno', 'Beatriz Souza', 'beatriz.s@aluno.com', '(11) 91001-0002', '2008-03-15', 'A1002', 1);
CALL sp_cadastrar_usuario_completo('A1003', 'aluno123', 'aluno', 'Carlos Lima', 'carlos.l@aluno.com', '(11) 91001-0003', '2007-11-20', 'A1003', 1);
CALL sp_cadastrar_usuario_completo('A1004', 'aluno123', 'aluno', 'Diana Rosa', 'diana.r@aluno.com', '(11) 91001-0004', '2008-05-05', 'A1004', 1);
CALL sp_cadastrar_usuario_completo('A1005', 'aluno123', 'aluno', 'Eduardo Neves', 'eduardo.n@aluno.com', '(11) 91001-0005', '2007-09-30', 'A1005', 1);
CALL sp_cadastrar_usuario_completo('A1006', 'aluno123', 'aluno', 'Fabiana Cruz', 'fabiana.c@aluno.com', '(11) 91001-0006', '2008-02-14', 'A1006', 1);
CALL sp_cadastrar_usuario_completo('A1007', 'aluno123', 'aluno', 'Gabriel Mendes', 'gabriel.m@aluno.com', '(11) 91001-0007', '2008-07-19', 'A1007', 1);
CALL sp_cadastrar_usuario_completo('A1008', 'aluno123', 'aluno', 'Heloisa Martins', 'heloisa.m@aluno.com', '(11) 91001-0008', '2007-12-25', 'A1008', 1);
CALL sp_cadastrar_usuario_completo('A1009', 'aluno123', 'aluno', 'Igor Ferreira', 'igor.f@aluno.com', '(11) 91001-0009', '2008-04-12', 'A1009', 1);
CALL sp_cadastrar_usuario_completo('A1010', 'aluno123', 'aluno', 'Julia Paiva', 'julia.p@aluno.com', '(11) 91001-0010', '2008-08-08', 'A1010', 1);
CALL sp_cadastrar_usuario_completo('A1011', 'aluno123', 'aluno', 'Kevin Santos', 'kevin.s@aluno.com', '(11) 91001-0011', '2007-10-17', 'A1011', 1);
CALL sp_cadastrar_usuario_completo('A1012', 'aluno123', 'aluno', 'Larissa Gomes', 'larissa.g@aluno.com', '(11) 91001-0012', '2008-06-22', 'A1012', 1);
CALL sp_cadastrar_usuario_completo('A1013', 'aluno123', 'aluno', 'Marcos Dias', 'marcos.d@aluno.com', '(11) 91001-0013', '2008-03-29', 'A1013', 1);
CALL sp_cadastrar_usuario_completo('A1014', 'aluno123', 'aluno', 'Natalia Barros', 'natalia.b@aluno.com', '(11) 91001-0014', '2007-11-02', 'A1014', 1);
CALL sp_cadastrar_usuario_completo('A1015', 'aluno123', 'aluno', 'Otavio Ribeiro', 'otavio.r@aluno.com', '(11) 91001-0015', '2008-01-27', 'A1015', 1);

CALL sp_cadastrar_usuario_completo('A2001', 'aluno123', 'aluno', 'Patricia Alves', 'patricia.a@aluno.com', '(11) 92001-0001', '2007-02-18', 'A2001', 2);
CALL sp_cadastrar_usuario_completo('A2002', 'aluno123', 'aluno', 'Ricardo Jorge', 'ricardo.j@aluno.com', '(11) 92001-0002', '2007-07-23', 'A2002', 2);
CALL sp_cadastrar_usuario_completo('A2003', 'aluno123', 'aluno', 'Sabrina Lins', 'sabrina.l@aluno.com', '(11) 92001-0003', '2006-10-09', 'A2003', 2);
CALL sp_cadastrar_usuario_completo('A2004', 'aluno123', 'aluno', 'Tiago Moreira', 'tiago.m@aluno.com', '(11) 92001-0004', '2007-04-01', 'A2004', 2);
CALL sp_cadastrar_usuario_completo('A2005', 'aluno123', 'aluno', 'Ursula Bastos', 'ursula.b@aluno.com', '(11) 92001-0005', '2006-08-14', 'A2005', 2);
CALL sp_cadastrar_usuario_completo('A2006', 'aluno123', 'aluno', 'Victor Hugo', 'victor.h@aluno.com', '(11) 92001-0006', '2007-01-07', 'A2006', 2);
CALL sp_cadastrar_usuario_completo('A2007', 'aluno123', 'aluno', 'Wagner Teles', 'wagner.t@aluno.com', '(11) 92001-0007', '2007-06-11', 'A2007', 2);
CALL sp_cadastrar_usuario_completo('A2008', 'aluno123', 'aluno', 'Ximena Freitas', 'ximena.f@aluno.com', '(11) 92001-0008', '2006-09-25', 'A2008', 2);
CALL sp_cadastrar_usuario_completo('A2009', 'aluno123', 'aluno', 'Yago Pires', 'yago.p@aluno.com', '(11) 92001-0009', '2007-03-30', 'A2009', 2);

CALL sp_cadastrar_usuario_completo('A2010', 'aluno123', 'aluno', 'Zilda Matos', 'zilda.m@aluno.com', '(11) 92001-0010', '2006-12-04', 'RM025', 2);
CALL sp_cadastrar_usuario_completo('A2011', 'aluno123', 'aluno', 'Antonio Bessa', 'antonio.b@aluno.com', '(11) 92001-0011', '2007-05-16', 'RM026', 2);
CALL sp_cadastrar_usuario_completo('A2012', 'aluno123', 'aluno', 'Bruna Queiroz', 'bruna.q@aluno.com', '(11) 92001-0012', '2006-07-28', 'RM027', 2);
CALL sp_cadastrar_usuario_completo('A2013', 'aluno123', 'aluno', 'Caio Viana', 'caio.v@aluno.com', '(11) 92001-0013', '2007-02-03', 'RM028', 2);
CALL sp_cadastrar_usuario_completo('A2014', 'aluno123', 'aluno', 'Daniela Faria', 'daniela.f@aluno.com', '(11) 92001-0014', '2006-11-12', 'RM029', 2);
CALL sp_cadastrar_usuario_completo('A2015', 'aluno123', 'aluno', 'Elias Justino', 'elias.j@aluno.com', '(11) 92001-0015', '2007-08-27', 'RM030', 2);

CALL sp_cadastrar_usuario_completo('A3001', 'aluno123', 'aluno', 'Fernanda Guedes', 'fernanda.g@aluno.com', '(11) 93001-0001', '2006-07-07', 'RM031', 3);
CALL sp_cadastrar_usuario_completo('A3002', 'aluno123', 'aluno', 'Gustavo Viana', 'gustavo.v@aluno.com', '(11) 93001-0002', '2007-04-18', 'RM032', 3);
CALL sp_cadastrar_usuario_completo('A3003', 'aluno123', 'aluno', 'Heloisa Farias', 'heloisa.f@aluno.com', '(11) 93001-0003', '2006-10-30', 'RM033', 3);
CALL sp_cadastrar_usuario_completo('A3004', 'aluno123', 'aluno', 'Igor Santos', 'igor.s@aluno.com', '(11) 93001-0004', '2005-06-12', 'RM034', 3);
CALL sp_cadastrar_usuario_completo('A3005', 'aluno123', 'aluno', 'Joana Rocha', 'joana.r@aluno.com', '(11) 93001-0005', '2007-01-22', 'RM035', 3);
CALL sp_cadastrar_usuario_completo('A3006', 'aluno123', 'aluno', 'João Campos', 'joao.c@aluno.com', '(11) 93001-0006', '2006-09-11', 'RM036', 3);
CALL sp_cadastrar_usuario_completo('A3007', 'aluno123', 'aluno', 'Livia Andrade', 'livia.a@aluno.com', '(11) 93001-0007', '2006-05-24', 'RM037', 3);
CALL sp_cadastrar_usuario_completo('A3008', 'aluno123', 'aluno', 'Murilo Nunes', 'murilo.n@aluno.com', '(11) 93001-0008', '2005-08-03', 'RM038', 3);
CALL sp_cadastrar_usuario_completo('A3009', 'aluno123', 'aluno', 'Nicole Peixoto', 'nicole.p@aluno.com', '(11) 93001-0009', '2007-03-08', 'RM039', 3);
CALL sp_cadastrar_usuario_completo('A3010', 'aluno123', 'aluno', 'Oscar Schmidt', 'oscar.s@aluno.com', '(11) 93001-0010', '2006-12-16', 'RM040', 3);
CALL sp_cadastrar_usuario_completo('A3011', 'aluno123', 'aluno', 'Pedro Barroso', 'pedro.b@aluno.com', '(11) 93001-0011', '2005-02-28', 'RM041', 3);
CALL sp_cadastrar_usuario_completo('A3012', 'aluno123', 'aluno', 'Raquel Sampaio', 'raquel.s@aluno.com', '(11) 93001-0012', '2006-07-14', 'RM042', 3);
CALL sp_cadastrar_usuario_completo('A3013', 'aluno123', 'aluno', 'Silas Malafaia', 'silas.m@aluno.com', '(11) 93001-0013', '2005-10-21', 'RM043', 3);
CALL sp_cadastrar_usuario_completo('A3014', 'aluno123', 'aluno', 'Tania Veiga', 'tania.v@aluno.com', '(11) 93001-0014', '2007-05-02', 'RM044', 3);
CALL sp_cadastrar_usuario_completo('A3015', 'aluno123', 'aluno', 'Ulisses Castro', 'ulisses.c@aluno.com', '(11) 93001-0015', '2006-08-19', 'RM045', 3);


---


CALL sp_cadastrar_usuario_completo('C1001', 'aluno789', 'aluno', 'André Souza', 'andre.s@aluno.com', '(11) 94101-0001', '2008-01-10', 'ADS201', 4); -- (ID_ALUNO = 91)
CALL sp_cadastrar_usuario_completo('C1002', 'aluno789', 'aluno', 'Bruna Lima', 'bruna.l@aluno.com', '(11) 94101-0002', '2008-03-15', 'ADS202', 4); -- 92
CALL sp_cadastrar_usuario_completo('C1003', 'aluno789', 'aluno', 'Caio Ferreira', 'caio.f@aluno.com', '(11) 94101-0003', '2007-11-20', 'ADS203', 4); -- 93
CALL sp_cadastrar_usuario_completo('C1004', 'aluno789', 'aluno', 'Daniela Moura', 'daniela.m@aluno.com', '(11) 94101-0004', '2008-05-05', 'ADS204', 4); -- 94
CALL sp_cadastrar_usuario_completo('C1005', 'aluno789', 'aluno', 'Enzo Ribeiro', 'enzo.r@aluno.com', '(11) 94101-0005', '2007-09-30', 'ADS205', 4); -- 95 (dificuldade)
CALL sp_cadastrar_usuario_completo('C1006', 'aluno789', 'aluno', 'Fátima Rocha', 'fatima.r@aluno.com', '(11) 94101-0006', '2008-02-14', 'ADS206', 4); -- 96
CALL sp_cadastrar_usuario_completo('C1007', 'aluno789', 'aluno', 'Gabriel Castro', 'gabriel.c@aluno.com', '(11) 94101-0007', '2007-07-19', 'ADS207', 4); -- 97
CALL sp_cadastrar_usuario_completo('C1008', 'aluno789', 'aluno', 'Helena Dias', 'helena.d@aluno.com', '(11) 94101-0008', '2007-12-25', 'ADS208', 4); -- 98
CALL sp_cadastrar_usuario_completo('C1009', 'aluno789', 'aluno', 'Igor Nunes', 'igor.n@aluno.com', '(11) 94101-0009', '2008-04-12', 'ADS209', 4); -- 99
CALL sp_cadastrar_usuario_completo('C1010', 'aluno789', 'aluno', 'Joana Pinto', 'joana.p@aluno.com', '(11) 94101-0010', '2008-08-08', 'ADS210', 4); -- 100
CALL sp_cadastrar_usuario_completo('C1011', 'aluno789', 'aluno', 'Kauan Mendes', 'kauan.m@aluno.com', '(11) 94101-0011', '2007-10-17', 'ADS211', 4); -- 101
CALL sp_cadastrar_usuario_completo('C1012', 'aluno789', 'aluno', 'Larissa Pinto', 'larissa.p@aluno.com', '(11) 94101-0012', '2008-06-22', 'ADS212', 4); -- 102
CALL sp_cadastrar_usuario_completo('C1013', 'aluno789', 'aluno', 'Matheus Rocha', 'matheus.r@aluno.com', '(11) 94101-0013', '2008-03-29', 'ADS213', 4); -- 103 (dificuldade)
CALL sp_cadastrar_usuario_completo('C1014', 'aluno789', 'aluno', 'Natália Alves', 'natalia.a@aluno.com', '(11) 94101-0014', '2007-11-02', 'ADS214', 4); -- 104
CALL sp_cadastrar_usuario_completo('C1015', 'aluno789', 'aluno', 'Otávio Santos', 'otavio.s@aluno.com', '(11) 94101-0015', '2008-01-27', 'ADS215', 4); -- 105

CALL sp_cadastrar_usuario_completo('C2001', 'aluno789', 'aluno', 'Paula Gomes', 'paula.g@aluno.com', '(11) 94201-0001', '2007-02-18', 'LOG201', 5); -- 106
CALL sp_cadastrar_usuario_completo('C2002', 'aluno789', 'aluno', 'Rafael Soares', 'rafael.s@aluno.com', '(11) 94201-0002', '2007-07-23', 'LOG202', 5); -- 107
CALL sp_cadastrar_usuario_completo('C2003', 'aluno789', 'aluno', 'Soraia Lima', 'soraia.l@aluno.com', '(11) 94201-0003', '2006-10-09', 'LOG203', 5); -- 108
CALL sp_cadastrar_usuario_completo('C2004', 'aluno789', 'aluno', 'Tiago Cardoso', 'tiago.c@aluno.com', '(11) 94201-0004', '2007-04-01', 'LOG204', 5); -- 109
CALL sp_cadastrar_usuario_completo('C2005', 'aluno789', 'aluno', 'Úrsula Barros', 'ursula.b@aluno.com', '(11) 94201-0005', '2006-08-14', 'LOG205', 5); -- 110 (dificuldade)
CALL sp_cadastrar_usuario_completo('C2006', 'aluno789', 'aluno', 'Vitor Braga', 'vitor.b@aluno.com', '(11) 94201-0006', '2007-01-07', 'LOG206', 5); -- 111
CALL sp_cadastrar_usuario_completo('C2007', 'aluno789', 'aluno', 'Wesley Farias', 'wesley.f@aluno.com', '(11) 94201-0007', '2007-06-11', 'LOG207', 5); -- 112
CALL sp_cadastrar_usuario_completo('C2008', 'aluno789', 'aluno', 'Xênia Ramos', 'xenia.r@aluno.com', '(11) 94201-0008', '2006-09-25', 'LOG208', 5); -- 113
CALL sp_cadastrar_usuario_completo('C2009', 'aluno789', 'aluno', 'Yuri Alves', 'yuri.a@aluno.com', '(11) 94201-0009', '2007-03-30', 'LOG209', 5); -- 114
CALL sp_cadastrar_usuario_completo('C2010', 'aluno789', 'aluno', 'Zilda Pereira', 'zilda.p@aluno.com', '(11) 94201-0010', '2006-12-04', 'LOG210', 5); -- 115
CALL sp_cadastrar_usuario_completo('C2011', 'aluno789', 'aluno', 'Anderson Silva', 'anderson.s@aluno.com', '(11) 94201-0011', '2007-05-16', 'LOG211', 5); -- 116
CALL sp_cadastrar_usuario_completo('C2012', 'aluno789', 'aluno', 'Beatriz Maia', 'beatriz.m@aluno.com', '(11) 94201-0012', '2006-07-28', 'LOG212', 5); -- 117
CALL sp_cadastrar_usuario_completo('C2013', 'aluno789', 'aluno', 'Cauã Torres', 'caua.t@aluno.com', '(11) 94201-0013', '2007-02-03', 'LOG213', 5); -- 118
CALL sp_cadastrar_usuario_completo('C2014', 'aluno789', 'aluno', 'Débora Freitas', 'debora.f@aluno.com', '(11) 94201-0014', '2006-11-12', 'LOG214', 5); -- 119 (dificuldade)
CALL sp_cadastrar_usuario_completo('C2015', 'aluno789', 'aluno', 'Emanuel Costa', 'emanuel.c@aluno.com', '(11) 94201-0015', '2007-08-27', 'LOG215', 5); -- 120

CALL sp_cadastrar_usuario_completo('C3001', 'aluno789', 'aluno', 'Fabiana Gomes', 'fabiana.g@aluno.com', '(11) 94301-0001', '2005-07-07', 'GCOM201', 6); -- 121
CALL sp_cadastrar_usuario_completo('C3002', 'aluno789', 'aluno', 'Guilherme Rocha', 'guilherme.r@aluno.com', '(11) 94301-0002', '2006-04-18', 'GCOM202', 6); -- 122
CALL sp_cadastrar_usuario_completo('C3003', 'aluno789', 'aluno', 'Heloísa Brito', 'heloisa.b@aluno.com', '(11) 94301-0003', '2005-10-30', 'GCOM203', 6); -- 123
CALL sp_cadastrar_usuario_completo('C3004', 'aluno789', 'aluno', 'Igor Menezes', 'igor.m@aluno.com', '(11) 94301-0004', '2004-06-12', 'GCOM204', 6); -- 124
CALL sp_cadastrar_usuario_completo('C3005', 'aluno789', 'aluno', 'Joana Lopes', 'joana.l@aluno.com', '(11) 94301-0005', '2006-01-22', 'GCOM205', 6); -- 125 (dificuldade)
CALL sp_cadastrar_usuario_completo('C3006', 'aluno789', 'aluno', 'João Victor', 'joao.v@aluno.com', '(11) 94301-0006', '2005-09-11', 'GCOM206', 6); -- 126
CALL sp_cadastrar_usuario_completo('C3007', 'aluno789', 'aluno', 'Larissa F.', 'larissa.f@aluno.com', '(11) 94301-0007', '2005-05-24', 'GCOM207', 6); -- 127
CALL sp_cadastrar_usuario_completo('C3008', 'aluno789', 'aluno', 'Marcos Tavares', 'marcos.t@aluno.com', '(11) 94301-0008', '2004-08-03', 'GCOM208', 6); -- 128
CALL sp_cadastrar_usuario_completo('C3009', 'aluno789', 'aluno', 'Natália P.', 'natalia.p@aluno.com', '(11) 94301-0009', '2006-03-08', 'GCOM209', 6); -- 129
CALL sp_cadastrar_usuario_completo('C3010', 'aluno789', 'aluno', 'Otávio Luz', 'otavio.l@aluno.com', '(11) 94301-0010', '2005-12-16', 'GCOM210', 6); -- 130
CALL sp_cadastrar_usuario_completo('C3011', 'aluno789', 'aluno', 'Pedro Sousa', 'pedro.s@aluno.com', '(11) 94301-0011', '2004-02-28', 'GCOM211', 6); -- 131
CALL sp_cadastrar_usuario_completo('C3012', 'aluno789', 'aluno', 'Quésia Ramos', 'quesia.r@aluno.com', '(11) 94301-0012', '2005-07-14', 'GCOM212', 6); -- 132
CALL sp_cadastrar_usuario_completo('C3013', 'aluno789', 'aluno', 'Rita Lemos', 'rita.l@aluno.com', '(11) 94301-0013', '2004-10-21', 'GCOM213', 6); -- 133
CALL sp_cadastrar_usuario_completo('C3014', 'aluno789', 'aluno', 'Samuel Porto', 'samuel.p@aluno.com', '(11) 94301-0014', '2006-05-02', 'GCOM214', 6); -- 134
CALL sp_cadastrar_usuario_completo('C3015', 'aluno789', 'aluno', 'Thiago Barros', 'thiago.b@aluno.com', '(11) 94301-0015', '2005-08-19', 'GCOM215', 6); -- 135


---


CALL sp_cadastrar_usuario_completo('C3016', 'aluno789', 'aluno', 'Ana Clara Dias', 'ana.d@aluno.com', '(11) 94301-0016', '2005-01-10', 'GCOM216', 7); -- 136
CALL sp_cadastrar_usuario_completo('C3017', 'aluno789', 'aluno', 'Bruno Costa', 'bruno.c@aluno.com', '(11) 94301-0017', '2006-02-15', 'GCOM217', 7); -- 137
CALL sp_cadastrar_usuario_completo('C3018', 'aluno789', 'aluno', 'Carolina Viana', 'carolina.v@aluno.com', '(11) 94301-0018', '2004-11-05', 'GCOM218', 7); -- 138
CALL sp_cadastrar_usuario_completo('C3019', 'aluno789', 'aluno', 'Daniel Moreira', 'daniel.m@aluno.com', '(11) 94301-0019', '2005-03-20', 'GCOM219', 7); -- 139
CALL sp_cadastrar_usuario_completo('C3020', 'aluno789', 'aluno', 'Eduarda Faria', 'eduarda.f@aluno.com', '(11) 94301-0020', '2006-08-01', 'GCOM220', 7); -- 140
CALL sp_cadastrar_usuario_completo('C3021', 'aluno789', 'aluno', 'Felipe Nogueira', 'felipe.n@aluno.com', '(11) 94301-0021', '2004-04-14', 'GCOM221', 7); -- 141
CALL sp_cadastrar_usuario_completo('C3022', 'aluno789', 'aluno', 'Gabriela Pinto', 'gabriela.p@aluno.com', '(11) 94301-0022', '2005-09-29', 'GCOM222', 7); -- 142
CALL sp_cadastrar_usuario_completo('C3023', 'aluno789', 'aluno', 'Heitor Campos', 'heitor.c@aluno.com', '(11) 94301-0023', '2005-12-03', 'GCOM223', 7); -- 143
CALL sp_cadastrar_usuario_completo('C3024', 'aluno789', 'aluno', 'Isabela Andrade', 'isabela.a@aluno.com', '(11) 94301-0024', '2006-06-17', 'GCOM224', 7); -- 144
CALL sp_cadastrar_usuario_completo('C3025', 'aluno789', 'aluno', 'Júlio César Matos', 'julio.m@aluno.com', '(11) 94301-0025', '2004-07-25', 'GCOM225', 7); -- 145
CALL sp_cadastrar_usuario_completo('C3026', 'aluno789', 'aluno', 'Karina Borges', 'karina.b@aluno.com', '(11) 94301-0026', '2005-10-08', 'GCOM226', 7); -- 146
CALL sp_cadastrar_usuario_completo('C3027', 'aluno789', 'aluno', 'Lucas Ribeiro', 'lucas.r@aluno.com', '(11) 94301-0027', '2006-01-30', 'GCOM227', 7); -- 147
CALL sp_cadastrar_usuario_completo('C3028', 'aluno789', 'aluno', 'Manuela Siqueira', 'manuela.s@aluno.com', '(11) 94301-0028', '2004-03-12', 'GCOM228', 7); -- 148
CALL sp_cadastrar_usuario_completo('C3029', 'aluno789', 'aluno', 'Nicolas Freire', 'nicolas.f@aluno.com', '(11) 94301-0029', '2005-05-19', 'GCOM229', 7); -- 149
CALL sp_cadastrar_usuario_completo('C3030', 'aluno789', 'aluno', 'Olívia Dantas', 'olivia.d@aluno.com', '(11) 94301-0030', '2004-09-09', 'GCOM230', 7); -- 150
CALL sp_cadastrar_usuario_completo('C3031', 'aluno789', 'aluno', 'Paulo Henrique Melo', 'paulo.m@aluno.com', '(11) 94301-0031', '2006-04-22', 'GCOM231', 7); -- 151

CALL sp_cadastrar_usuario_completo('C3032', 'aluno789', 'aluno', 'Rafaela Justo', 'rafaela.j@aluno.com', '(11) 94301-0032', '2005-08-11', 'GCOM232', 8); -- 152
CALL sp_cadastrar_usuario_completo('C3033', 'aluno789', 'aluno', 'Sérgio Valente', 'sergio.v@aluno.com', '(11) 94301-0033', '2004-12-25', 'GCOM233', 8); -- 153
CALL sp_cadastrar_usuario_completo('C3034', 'aluno789', 'aluno', 'Tainá Barreto', 'taina.b@aluno.com', '(11) 94301-0034', '2005-02-18', 'GCOM234', 8); -- 154
CALL sp_cadastrar_usuario_completo('C3035', 'aluno789', 'aluno', 'Vítor Hugo Sales', 'vitor.s@aluno.com', '(11) 94301-0035', '2006-07-03', 'GCOM235', 8); -- 155
CALL sp_cadastrar_usuario_completo('C3036', 'aluno789', 'aluno', 'Yasmin Correia', 'yasmin.c@aluno.com', '(11) 94301-0036', '2004-06-07', 'GCOM236', 8); -- 156
CALL sp_cadastrar_usuario_completo('C3037', 'aluno789', 'aluno', 'Caio Neves', 'caio.n@aluno.com', '(11) 94301-0037', '2005-11-13', 'GCOM237', 8); -- 157
CALL sp_cadastrar_usuario_completo('C3038', 'aluno789', 'aluno', 'Beatriz Macedo', 'beatriz.m@aluno.com', '(11) 94301-0038', '2006-03-27', 'GCOM238', 8); -- 158
CALL sp_cadastrar_usuario_completo('C3039', 'aluno789', 'aluno', 'Davi Pires', 'davi.p@aluno.com', '(11) 94301-0039', '2004-08-30', 'GCOM239', 8); -- 159
CALL sp_cadastrar_usuario_completo('C3040', 'aluno789', 'aluno', 'Estela Guerra', 'estela.g@aluno.com', '(11) 94301-0040', '2005-04-04', 'GCOM240', 8); -- 160
CALL sp_cadastrar_usuario_completo('C3041', 'aluno789', 'aluno', 'Flávio Cunha', 'flavio.c@aluno.com', '(11) 94301-0041', '2004-10-18', 'GCOM241', 8); -- 161
CALL sp_cadastrar_usuario_completo('C3042', 'aluno789', 'aluno', 'Giovanna Martins', 'giovanna.m@aluno.com', '(11) 94301-0042', '2006-09-02', 'GCOM242', 8); -- 162
CALL sp_cadastrar_usuario_completo('C3043', 'aluno789', 'aluno', 'Hugo Silveira', 'hugo.s@aluno.com', '(11) 94301-0043', '2005-01-26', 'GCOM243', 8); -- 163
CALL sp_cadastrar_usuario_completo('C3044', 'aluno789', 'aluno', 'Isadora Lins', 'isadora.l@aluno.com', '(11) 94301-0044', '2004-05-31', 'GCOM244', 8); -- 164
CALL sp_cadastrar_usuario_completo('C3045', 'aluno789', 'aluno', 'Luan Peixoto', 'luan.p@aluno.com', '(11) 94301-0045', '2005-06-25', 'GCOM245', 8); -- 165


---


INSERT INTO tbl_semestre_turma (id_turma, id_semestre) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6),
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 6);

INSERT INTO tbl_turma_professor (id_professor, id_turma) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6),
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6);

INSERT INTO tbl_gestao_turma (id_gestao, id_turma) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6);

-- MATEMÁTICA
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Teste 1: Funções', 'Avaliação rápida sobre funções de 1º e 2º grau', '2023-03-15', 1, 1, 5),
('Lista 1: Geometria', 'Exercícios de geometria plana e espacial', '2023-05-02', 1, 1, 4),
('P2: Trigonometria', 'Prova semestral sobre ciclo trigonométrico', '2023-06-10', 1, 1, 1),
('Trabalho: Estatística', 'Análise e apresentação de dados estatísticos', '2024-03-20', 1, 1, 2),
('P1: Matrizes', 'Prova sobre operações com matrizes e determinantes', '2024-04-18', 1, 1, 1);

-- PORTUGUÊS
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Redação: Dissertação', 'Produção textual sobre tema atual', '2023-03-22', 2, 2, 2),
('Teste: Classes Gramaticais', 'Teste rápido sobre substantivos, verbos e adjetivos', '2023-05-10', 2, 2, 5),
('Seminário: Modernismo', 'Apresentação sobre a Semana de Arte Moderna', '2023-10-05', 2, 2, 3),
('P1: Literatura', 'Prova sobre escolas literárias (Romantismo)', '2024-04-12', 2, 2, 1),
('Debate: Livro "Dom Casmurro"', 'Debate em sala sobre a obra de Machado de Assis', '2024-05-15', 2, 2, 6);

-- BIOLOGIA
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('P1: Citologia', 'Prova sobre estrutura celular e membranas', '2023-04-05', 3, 5, 1),
('Relatório: Microscopia', 'Relatório de aula prática em laboratório', '2023-05-08', 3, 5, 2),
('Teste: Genética Básica', 'Avaliação sobre Leis de Mendel', '2023-09-15', 3, 5, 5),
('Projeto: Ecossistemas', 'Projeto em grupo sobre biomas brasileiros', '2024-04-01', 3, 5, 6),
('P2: Corpo Humano', 'Prova sobre sistemas digestório e respiratório', '2024-06-05', 3, 5, 1);

-- INGLÊS
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Teste: Verb Tenses', 'Teste rápido sobre Past Simple e Present Perfect', '2023-03-28', 4, 4, 5),
('Trabalho: Reading', 'Interpretação de texto (Short Story)', '2023-05-12', 4, 4, 2),
('Atividade: Listening', 'Exercício de compreensão auditiva', '2023-10-10', 4, 4, 4),
('P1: Writing', 'Produção de texto (ensaio argumentativo)', '2024-04-20', 4, 4, 1),
('Seminário: Cultura Pop', 'Apresentação oral sobre filme ou música', '2024-05-22', 4, 4, 3);

-- HISTÓRIA
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('P1: Grécia Antiga', 'Prova sobre pólis gregas e filosofia', '2023-04-14', 5, 3, 1),
('Teste: Feudalismo', 'Avaliação curta sobre Idade Média', '2023-09-05', 5, 3, 5),
('P2: Guerra Fria', 'Prova sobre o período bipolar', '2023-11-20', 5, 3, 1),
('Debate: Revolução Francesa', 'Debate sobre as causas e consequências', '2024-03-18', 5, 3, 6),
('Trabalho: Brasil Império', 'Pesquisa sobre o Segundo Reinado', '2024-05-30', 5, 3, 2);

-- QUÍMICA
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('P1: Atomística', 'Prova sobre modelos atômicos e tabela periódica', '2023-04-17', 6, 5, 1),
('Teste: Ligações Químicas', 'Teste rápido sobre ligações iônicas e covalentes', '2023-05-25', 6, 5, 5),
('Relatório: Laboratório', 'Relatório sobre reações de precipitação', '2023-10-16', 6, 5, 2),
('Lista: Estequiometria', 'Lista de exercícios de cálculo estequiométrico', '2024-04-08', 6, 5, 4),
('P1: Orgânica', 'Prova sobre hidrocarbonetos e funções oxigenadas', '2024-09-20', 6, 5, 1);

-- FÍSICA
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('P1: Cinemática', 'Prova sobre MRU e MRUV', '2023-04-20', 7, 6, 1),
('Lista: Leis de Newton', 'Exercícios sobre dinâmica (Força e Aceleração)', '2023-05-18', 7, 6, 4),
('Teste: Energia', 'Avaliação curta sobre energia cinética e potencial', '2023-10-02', 7, 6, 5),
('P2: Termodinâmica', 'Prova sobre calor e temperatura', '2024-04-25', 7, 6, 1),
('Projeto: Eletricidade', 'Construção de um circuito elétrico simples', '2024-05-28', 7, 6, 6);

-- GEOGRAFIA
INSERT INTO tbl_atividade (titulo, descricao, data_criacao, id_materia, id_professor, id_categoria)
VALUES
('Teste: Cartografia', 'Teste rápido sobre mapas e escalas', '2023-03-30', 8, 7, 5),
('Trabalho: Relevo', 'Pesquisa sobre formas de relevo brasileiro', '2023-05-22', 8, 7, 2),
('P2: Globalização', 'Prova sobre blocos econômicos e fluxos', '2023-11-15', 8, 7, 1),
('Seminário: Urbanização', 'Apresentação sobre problemas urbanos', '2024-05-05', 8, 7, 3),
('Lista: Fontes de Energia', 'Exercícios sobre matriz energética mundial', '2024-10-01', 8, 7, 4);


---


INSERT INTO tbl_atividade_aluno (id_atividade, id_aluno)
VALUES
-- Turma 1 (Alunos 1-21) - Atividades 2024.1 (9, 10, 11, 13) - 84 registros
(9, 1), (10, 1), (11, 1), (13, 1),
(9, 2), (10, 2), (11, 2), (13, 2),
(9, 3), (10, 3), (11, 3), (13, 3),
(9, 4), (10, 4), (11, 4), (13, 4),
(9, 5), (10, 5), (11, 5), (13, 5),
(9, 6), (10, 6), (11, 6), (13, 6),
(9, 7), (10, 7), (11, 7), (13, 7),
(9, 8), (10, 8), (11, 8), (13, 8),
(9, 9), (10, 9), (11, 9), (13, 9),
(9, 10), (10, 10), (11, 10), (13, 10),
(9, 11), (10, 11), (11, 11), (13, 11),
(9, 12), (10, 12), (11, 12), (13, 12),
(9, 13), (10, 13), (11, 13), (13, 13),
(9, 14), (10, 14), (11, 14), (13, 14),
(9, 15), (10, 15), (11, 15), (13, 15),
(9, 16), (10, 16), (11, 16), (13, 16),
(9, 17), (10, 17), (11, 17), (13, 17),
(9, 18), (10, 18), (11, 18), (13, 18),
(9, 19), (10, 19), (11, 19), (13, 19),
(9, 20), (10, 20), (11, 20), (13, 20),
(9, 21), (10, 21), (11, 21), (13, 21),

-- Turma 2 (Alunos 22-42) - Atividades 2024.2 (14, 15, 16, 17) - 84 registros
(14, 22), (15, 22), (16, 22), (17, 22),
(14, 23), (15, 23), (16, 23), (17, 23),
(14, 24), (15, 24), (16, 24), (17, 24),
(14, 25), (15, 25), (16, 25), (17, 25),
(14, 26), (15, 26), (16, 26), (17, 26),
(14, 27), (15, 27), (16, 27), (17, 27),
(14, 28), (15, 28), (16, 28), (17, 28),
(14, 29), (15, 29), (16, 29), (17, 29),
(14, 30), (15, 30), (16, 30), (17, 30),
(14, 31), (15, 31), (16, 31), (17, 31),
(14, 32), (15, 32), (16, 32), (17, 32),
(14, 33), (15, 33), (16, 33), (17, 33),
(14, 34), (15, 34), (16, 34), (17, 34),
(14, 35), (15, 35), (16, 35), (17, 35),
(14, 36), (15, 36), (16, 36), (17, 36),
(14, 37), (15, 37), (16, 37), (17, 37),
(14, 38), (15, 38), (16, 38), (17, 38),
(14, 39), (15, 39), (16, 39), (17, 39),
(14, 40), (15, 40), (16, 40), (17, 40),
(14, 41), (15, 41), (16, 41), (17, 41),
(14, 42), (15, 42), (16, 42), (17, 42),

-- Turma 3 (Alunos 43-63) - Foco Matemática (18, 19, 20) - 63 registros
(18, 43), (19, 43), (20, 43),
(18, 44), (19, 44), (20, 44),
(18, 45), (19, 45), (20, 45),
(18, 46), (19, 46), (20, 46),
(18, 47), (19, 47), (20, 47),
(18, 48), (19, 48), (20, 48),
(18, 49), (19, 49), (20, 49),
(18, 50), (19, 50), (20, 50),
(18, 51), (19, 51), (20, 51),
(18, 52), (19, 52), (20, 52),
(18, 53), (19, 53), (20, 53),
(18, 54), (19, 54), (20, 54),
(18, 55), (19, 55), (20, 55),
(18, 56), (19, 56), (20, 56),
(18, 57), (19, 57), (20, 57),
(18, 58), (19, 58), (20, 58),
(18, 59), (19, 59), (20, 59),
(18, 60), (19, 60), (20, 60),
(18, 61), (19, 61), (20, 61),
(18, 62), (19, 62), (20, 62),
(18, 63), (19, 63), (20, 63),

-- Turma 4 (Alunos 64-84) - Foco Português (23, 24, 25, 26) - 84 registros
(23, 64), (24, 64), (25, 64), (26, 64),
(23, 65), (24, 65), (25, 65), (26, 65),
(23, 66), (24, 66), (25, 66), (26, 66),
(23, 67), (24, 67), (25, 67), (26, 67),
(23, 68), (24, 68), (25, 68), (26, 68),
(23, 69), (24, 69), (25, 69), (26, 69),
(23, 70), (24, 70), (25, 70), (26, 70),
(23, 71), (24, 71), (25, 71), (26, 71),
(23, 72), (24, 72), (25, 72), (26, 72),
(23, 73), (24, 73), (25, 73), (26, 73),
(23, 74), (24, 74), (25, 74), (26, 74),
(23, 75), (24, 75), (25, 75), (26, 75),
(23, 76), (24, 76), (25, 76), (26, 76),
(23, 77), (24, 77), (25, 77), (26, 77),
(23, 78), (24, 78), (25, 78), (26, 78),
(23, 79), (24, 79), (25, 79), (26, 79),
(23, 80), (24, 80), (25, 80), (26, 80),
(23, 81), (24, 81), (25, 81), (26, 81),
(23, 82), (24, 82), (25, 82), (26, 82),
(23, 83), (24, 83), (25, 83), (26, 83),
(23, 84), (24, 84), (25, 84), (26, 84),

-- Turma 5 (Alunos 85-105) - Foco Biologia/Química (28, 29, 43, 44) - 84 registros
(28, 85), (29, 85), (43, 85), (44, 85),
(28, 86), (29, 86), (43, 86), (44, 86),
(28, 87), (29, 87), (43, 87), (44, 87),
(28, 88), (29, 88), (43, 88), (44, 88),
(28, 89), (29, 89), (43, 89), (44, 89),
(28, 90), (29, 90), (43, 90), (44, 90),
(28, 91), (29, 91), (43, 91), (44, 91),
(28, 92), (29, 92), (43, 92), (44, 92),
(28, 93), (29, 93), (43, 93), (44, 93),
(28, 94), (29, 94), (43, 94), (44, 94),
(28, 95), (29, 95), (43, 95), (44, 95),
(28, 96), (29, 96), (43, 96), (44, 96),
(28, 97), (29, 97), (43, 97), (44, 97),
(28, 98), (29, 98), (43, 98), (44, 98),
(28, 99), (29, 99), (43, 99), (44, 99),
(28, 100), (29, 100), (43, 100), (44, 100),
(28, 101), (29, 101), (43, 101), (44, 101),
(28, 102), (29, 102), (43, 102), (44, 102),
(28, 103), (29, 103), (43, 103), (44, 103),
(28, 104), (29, 104), (43, 104), (44, 104),
(28, 105), (29, 105), (43, 105), (44, 105);

-- -- Turma 6 (Alunos 106-125) - Foco Inglês/História (33, 34, 38, 39) - 80 registros
-- (33, 106), (34, 106), (38, 106), (39, 106),
-- (33, 107), (34, 107), (38, 107), (39, 107),
-- (33, 108), (34, 108), (38, 108), (39, 108),
-- (33, 109), (34, 109), (38, 109), (39, 109),
-- (33, 110), (34, 110), (38, 110), (39, 110),
-- (33, 111), (34, 111), (38, 111), (39, 111),
-- (33, 112), (34, 112), (38, 112), (39, 112),
-- (33, 113), (34, 113), (38, 113), (39, 113),
-- (33, 114), (34, 114), (38, 114), (39, 114),
-- (33, 115), (34, 115), (38, 115), (39, 115),
-- (33, 116), (34, 116), (38, 116), (39, 116),
-- (33, 117), (34, 117), (38, 117), (39, 117),
-- (33, 118), (34, 118), (38, 118), (39, 118),
-- (33, 119), (34, 119), (38, 119), (39, 119),
-- (33, 120), (34, 120), (38, 120), (39, 120),
-- (33, 121), (34, 121), (38, 121), (39, 121),
-- (33, 122), (34, 122), (38, 122), (39, 122),
-- (33, 123), (34, 123), (38, 123), (39, 123),
-- (33, 124), (34, 124), (38, 124), (39, 124),
-- (33, 125), (34, 125), (38, 125), (39, 125),

-- -- Turma 7 (Alunos 126-145) - Foco Física (48, 49, 50) - 60 registros
-- (48, 126), (49, 126), (50, 126),
-- (48, 127), (49, 127), (50, 127),
-- (48, 128), (49, 128), (50, 128),
-- (48, 129), (49, 129), (50, 129),
-- (48, 130), (49, 130), (50, 130),
-- (48, 131), (49, 131), (50, 131),
-- (48, 132), (49, 132), (50, 132),
-- (48, 133), (49, 133), (50, 133),
-- (48, 134), (49, 134), (50, 134),
-- (48, 135), (49, 135), (50, 135),
-- (48, 136), (49, 136), (50, 136),
-- (48, 137), (49, 137), (50, 137),
-- (48, 138), (49, 138), (50, 138),
-- (48, 139), (49, 139), (50, 139),
-- (48, 140), (49, 140), (50, 140),
-- (48, 141), (49, 141), (50, 141),
-- (48, 142), (49, 142), (50, 142),
-- (48, 143), (49, 143), (50, 143),
-- (48, 144), (49, 144), (50, 144),
-- (48, 145), (49, 145), (50, 145),

-- -- Turma 8 (Alunos 146-165) - Foco Geografia (53, 54, 55) - 60 registros
-- (53, 146), (54, 146), (55, 146),
-- (53, 147), (54, 147), (55, 147),
-- (53, 148), (54, 148), (55, 148),
-- (53, 149), (54, 149), (55, 149),
-- (53, 150), (54, 150), (55, 150),
-- (53, 151), (54, 151), (55, 151),
-- (53, 152), (54, 152), (55, 152),
-- (53, 153), (54, 153), (55, 153),
-- (53, 154), (54, 154), (55, 154),
-- (53, 155), (54, 155), (55, 155),
-- (53, 156), (54, 156), (55, 156),
-- (53, 157), (54, 157), (55, 157),
-- (53, 158), (54, 158), (55, 158),
-- (53, 159), (54, 159), (55, 159),
-- (53, 160), (54, 160), (55, 160),
-- (53, 161), (54, 161), (55, 161),
-- (53, 162), (54, 162), (55, 162),
-- (53, 163), (54, 163), (55, 163),
-- (53, 164), (54, 164), (55, 164),
-- (53, 165), (54, 165), (55, 165);

INSERT INTO tbl_nota (nota, id_atividade_aluno, id_semestre)
VALUES
-- Turma 1 (AA 1-84) - Semestre 3 (2024.1)
(9.0, 1, 3), (8.5, 2, 3), (9.5, 3, 3), (10.0, 4, 3),
(8.5, 5, 3), (9.0, 6, 3), (8.0, 7, 3), (9.0, 8, 3),
(9.5, 9, 3), (8.0, 10, 3), (8.5, 11, 3), (8.5, 12, 3),
(10.0, 13, 3), (9.5, 14, 3), (9.0, 15, 3), (9.5, 16, 3),
(4.0, 17, 3), (5.5, 18, 3), (3.0, 19, 3), (4.5, 20, 3),
(7.0, 21, 3), (8.0, 22, 3), (7.5, 23, 3), (8.0, 24, 3),
(6.5, 25, 3), (7.0, 26, 3), (8.0, 27, 3), (7.0, 28, 3),
(8.0, 29, 3), (7.5, 30, 3), (6.0, 31, 3), (7.5, 32, 3),
(7.5, 33, 3), (8.5, 34, 3), (7.0, 35, 3), (8.0, 36, 3),
(6.0, 37, 3), (7.0, 38, 3), (7.5, 39, 3), (7.0, 40, 3),
(8.5, 41, 3), (8.0, 42, 3), (6.5, 43, 3), (7.5, 44, 3),
(7.0, 45, 3), (7.5, 46, 3), (8.0, 47, 3), (6.0, 48, 3),
(5.0, 49, 3), (4.5, 50, 3), (5.5, 51, 3), (3.5, 52, 3),
(8.0, 53, 3), (9.0, 54, 3), (7.5, 55, 3), (8.5, 56, 3),
(9.0, 57, 3), (7.0, 58, 3), (8.0, 59, 3), (7.5, 60, 3),
(8.0, 61, 3), (7.5, 62, 3), (9.0, 63, 3), (8.5, 64, 3),
(7.0, 65, 3), (6.5, 66, 3), (8.0, 67, 3), (7.0, 68, 3),
(9.5, 69, 3), (8.0, 70, 3), (8.5, 71, 3), (9.0, 72, 3),
(10.0, 73, 3), (9.0, 74, 3), (7.5, 75, 3), (8.0, 76, 3),
(6.0, 77, 3), (5.5, 78, 3), (6.0, 79, 3), (7.5, 80, 3),
(8.0, 81, 3), (7.0, 82, 3), (7.5, 83, 3), (8.0, 84, 3),

-- Turma 2 (AA 85-168) - Semestre 4 (2024.2)
(9.0, 85, 4), (8.5, 86, 4), (8.0, 87, 4), (7.0, 88, 4),
(7.5, 89, 4), (8.0, 90, 4), (6.5, 91, 4), (7.0, 92, 4),
(8.5, 93, 4), (9.0, 94, 4), (7.0, 95, 4), (8.0, 96, 4),
(5.0, 97, 4), (6.0, 98, 4), (7.5, 99, 4), (6.5, 100, 4),
(8.0, 101, 4), (8.5, 102, 4), (7.0, 103, 4), (7.5, 104, 4),
(7.0, 105, 4), (7.5, 106, 4), (8.0, 107, 4), (6.0, 108, 4),
(9.0, 109, 4), (8.5, 110, 4), (9.0, 111, 4), (7.5, 112, 4),
(8.0, 113, 4), (9.0, 114, 4), (7.5, 115, 4), (8.5, 116, 4),
(7.0, 117, 4), (6.5, 118, 4), (8.0, 119, 4), (7.5, 120, 4),
(8.0, 121, 4), (7.5, 122, 4), (9.0, 123, 4), (8.5, 124, 4),
(7.0, 125, 4), (6.5, 126, 4), (8.0, 127, 4), (7.0, 128, 4),
(9.5, 129, 4), (8.0, 130, 4), (8.5, 131, 4), (9.0, 132, 4),
(10.0, 133, 4), (9.0, 134, 4), (7.5, 135, 4), (8.0, 136, 4),
(6.0, 137, 4), (5.5, 138, 4), (6.0, 139, 4), (7.5, 140, 4),
(8.0, 141, 4), (7.0, 142, 4), (7.5, 143, 4), (8.0, 144, 4),
(9.0, 145, 4), (8.5, 146, 4), (8.0, 147, 4), (7.0, 148, 4),
(7.5, 149, 4), (8.0, 150, 4), (6.5, 151, 4), (7.0, 152, 4),
(8.5, 153, 4), (9.0, 154, 4), (7.0, 155, 4), (8.0, 156, 4),
(5.0, 157, 4), (6.0, 158, 4), (7.5, 159, 4), (6.5, 160, 4),
(8.0, 161, 4), (8.5, 162, 4), (7.0, 163, 4), (7.5, 164, 4),
(7.0, 165, 4), (7.5, 166, 4), (8.0, 167, 4), (6.0, 168, 4),

-- Turma 3 (AA 169-231) - Semestre 1 (2023.1)
(9.0, 169, 1), (8.5, 170, 1), (9.5, 171, 1),
(7.5, 172, 1), (8.0, 173, 1), (7.0, 174, 1),
(6.0, 175, 1), (7.0, 176, 1), (6.5, 177, 1),
(8.5, 178, 1), (9.0, 179, 1), (8.0, 180, 1),
(10.0, 181, 1), (9.5, 182, 1), (9.0, 183, 1),
(4.5, 184, 1), (5.0, 185, 1), (6.0, 186, 1),
(7.0, 187, 1), (7.5, 188, 1), (8.0, 189, 1),
(8.0, 190, 1), (8.5, 191, 1), (7.5, 192, 1),
(6.5, 193, 1), (7.0, 194, 1), (8.0, 195, 1),
(9.0, 196, 1), (8.0, 197, 1), (8.5, 198, 1),
(7.0, 199, 1), (7.5, 200, 1), (6.0, 201, 1),
(8.0, 202, 1), (9.0, 203, 1), (8.5, 204, 1),
(5.0, 205, 1), (6.0, 206, 1), (5.5, 207, 1),
(7.5, 208, 1), (8.0, 209, 1), (7.0, 210, 1),
(6.0, 211, 1), (7.0, 212, 1), (6.5, 213, 1),
(9.0, 214, 1), (8.5, 215, 1), (9.5, 216, 1),
(7.5, 217, 1), (8.0, 218, 1), (7.0, 219, 1),
(6.0, 220, 1), (7.0, 221, 1), (6.5, 222, 1),
(8.5, 223, 1), (9.0, 224, 1), (8.0, 225, 1),
(10.0, 226, 1), (9.5, 227, 1), (9.0, 228, 1),
(4.5, 229, 1), (5.0, 230, 1), (6.0, 231, 1),

-- Turma 4 (AA 232-315) - Semestre 2 (2023.2)
(8.0, 232, 2), (7.5, 233, 2), (9.0, 234, 2), (8.5, 235, 2),
(9.0, 236, 2), (8.0, 237, 2), (8.5, 238, 2), (9.0, 239, 2),
(7.0, 240, 2), (6.5, 241, 2), (7.5, 242, 2), (8.0, 243, 2),
(9.5, 244, 2), (10.0, 245, 2), (9.0, 246, 2), (9.5, 247, 2),
(5.0, 248, 2), (4.0, 249, 2), (5.5, 250, 2), (6.0, 251, 2),
(8.0, 252, 2), (7.0, 253, 2), (7.5, 254, 2), (8.0, 255, 2),
(8.5, 256, 2), (9.0, 257, 2), (8.0, 258, 2), (8.5, 259, 2),
(7.0, 260, 2), (7.5, 261, 2), (6.5, 262, 2), (7.0, 263, 2),
(6.0, 264, 2), (7.0, 265, 2), (6.5, 266, 2), (7.5, 267, 2),
(9.0, 268, 2), (8.5, 269, 2), (9.5, 270, 2), (9.0, 271, 2),
(7.5, 272, 2), (8.0, 273, 2), (7.0, 274, 2), (8.5, 275, 2),
(8.0, 276, 2), (8.5, 277, 2), (9.0, 278, 2), (8.0, 279, 2),
(6.0, 280, 2), (5.0, 281, 2), (6.5, 282, 2), (7.0, 283, 2),
(10.0, 284, 2), (9.0, 285, 2), (9.5, 286, 2), (10.0, 287, 2),
(7.5, 288, 2), (8.0, 289, 2), (7.0, 290, 2), (9.0, 291, 2),
(8.0, 292, 2), (7.5, 293, 2), (9.0, 294, 2), (8.5, 295, 2),
(9.0, 296, 2), (8.0, 297, 2), (8.5, 298, 2), (9.0, 299, 2),
(7.0, 300, 2), (6.5, 301, 2), (7.5, 302, 2), (8.0, 303, 2),
(9.5, 304, 2), (10.0, 305, 2), (9.0, 306, 2), (9.5, 307, 2),
(5.0, 308, 2), (4.0, 309, 2), (5.5, 310, 2), (6.0, 311, 2),
(8.0, 312, 2), (7.0, 313, 2), (7.5, 314, 2), (8.0, 315, 2),

-- Turma 5 (AA 316-399) - Semestre 5
(6.5, 316, 5), (7.0, 317, 5), (8.0, 318, 5), (7.5, 319, 5),
(8.0, 320, 5), (8.5, 321, 5), (9.0, 322, 5), (8.0, 323, 5),
(9.0, 324, 5), (9.5, 325, 5), (8.5, 326, 5), (9.0, 327, 5),
(7.0, 328, 5), (6.0, 329, 5), (7.5, 330, 5), (7.0, 331, 5),
(8.0, 332, 5), (7.5, 333, 5), (8.0, 334, 5), (8.5, 335, 5),
(9.5, 336, 5), (9.0, 337, 5), (10.0, 338, 5), (9.0, 339, 5),
(3.0, 340, 5), (4.5, 341, 5), (5.0, 342, 5), (4.0, 343, 5),
(7.0, 344, 5), (8.0, 345, 5), (7.5, 346, 5), (8.0, 347, 5),
(8.5, 348, 5), (8.0, 349, 5), (9.0, 350, 5), (8.5, 351, 5),
(6.0, 352, 5), (7.0, 353, 5), (6.5, 354, 5), (7.0, 355, 5),
(7.5, 356, 5), (7.0, 357, 5), (8.0, 358, 5), (7.5, 359, 5),
(9.0, 360, 5), (8.5, 361, 5), (9.0, 362, 5), (8.0, 363, 5),
(8.0, 364, 5), (7.0, 365, 5), (7.5, 366, 5), (8.0, 367, 5),
(6.5, 368, 5), (6.0, 369, 5), (7.0, 370, 5), (6.5, 371, 5),
(9.0, 372, 5), (8.5, 373, 5), (9.0, 374, 5), (9.5, 375, 5),
(6.5, 376, 5), (7.0, 377, 5), (8.0, 378, 5), (7.5, 379, 5),
(8.0, 380, 5), (8.5, 381, 5), (9.0, 382, 5), (8.0, 383, 5),
(9.0, 384, 5), (9.5, 385, 5), (8.5, 386, 5), (9.0, 387, 5),
(7.0, 388, 5), (6.0, 389, 5), (7.5, 390, 5), (7.0, 391, 5),
(8.0, 392, 5), (7.5, 393, 5), (8.0, 394, 5), (8.5, 395, 5),
(9.5, 396, 5), (9.0, 397, 5), (10.0, 398, 5), (9.0, 399, 5);


INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre) VALUES
(1, '2025-04-01', 1, 1, 6),
(1, '2025-04-01', 1, 2, 6),
(1, '2025-04-01', 1, 3, 6),
(1, '2025-04-01', 1, 4, 6),
(0, '2025-04-01', 1, 5, 6),
(1, '2025-04-01', 1, 6, 6),
(1, '2025-04-01', 1, 7, 6),
(1, '2025-04-01', 1, 8, 6),

(1, '2025-04-02', 1, 1, 6),
(1, '2025-04-02', 1, 2, 6),
(1, '2025-04-02', 1, 3, 6),
(0, '2025-04-02', 1, 4, 6),
(1, '2025-04-02', 1, 5, 6),
(1, '2025-04-02', 1, 6, 6),
(1, '2025-04-02', 1, 7, 6),
(1, '2025-04-02', 1, 8, 6),

(1, '2025-04-03', 1, 1, 6),
(1, '2025-04-03', 1, 2, 6),
(1, '2025-04-03', 1, 3, 6),
(1, '2025-04-03', 1, 4, 6),
(1, '2025-04-03', 1, 5, 6),
(0, '2025-04-03', 1, 6, 6),
(1, '2025-04-03', 1, 7, 6),
(1, '2025-04-03', 1, 8, 6),

(1, '2025-04-04', 1, 1, 6),
(1, '2025-04-04', 1, 2, 6),
(1, '2025-04-04', 1, 3, 6),
(1, '2025-04-04', 1, 4, 6),
(1, '2025-04-04', 1, 5, 6),
(1, '2025-04-04', 1, 6, 6),
(0, '2025-04-04', 1, 7, 6),
(1, '2025-04-04', 1, 8, 6),

(1, '2025-04-05', 1, 1, 6),
(1, '2025-04-05', 1, 2, 6),
(1, '2025-04-05', 1, 3, 6),
(0, '2025-04-05', 1, 4, 6),
(1, '2025-04-05', 1, 5, 6),
(1, '2025-04-05', 1, 6, 6),
(1, '2025-04-05', 1, 7, 6),
(1, '2025-04-05', 1, 8, 6),

(1, '2025-04-06', 1, 1, 6),
(1, '2025-04-06', 1, 2, 6),
(1, '2025-04-06', 1, 3, 6),
(1, '2025-04-06', 1, 4, 6),
(0, '2025-04-06', 1, 5, 6),
(1, '2025-04-06', 1, 6, 6),
(1, '2025-04-06', 1, 7, 6),
(1, '2025-04-06', 1, 8, 6),

(1, '2025-04-07', 1, 1, 6),
(1, '2025-04-07', 1, 2, 6),
(1, '2025-04-07', 1, 3, 6),
(1, '2025-04-07', 1, 4, 6),
(1, '2025-04-07', 1, 5, 6),
(1, '2025-04-07', 1, 6, 6),
(1, '2025-04-07', 1, 7, 6),
(0, '2025-04-07', 1, 8, 6);

INSERT INTO tbl_frequencia (presenca, data_frequencia, id_aluno, id_materia, id_semestre) VALUES
(1, '2025-04-01', 1, 1, 5),
(1, '2025-04-01', 1, 2, 5),
(1, '2025-04-01', 1, 3, 5),
(1, '2025-04-01', 1, 4, 5),
(0, '2025-04-01', 1, 5, 5),
(0, '2025-04-01', 1, 6, 5),
(1, '2025-04-01', 1, 7, 5),
(0, '2025-04-01', 1, 8, 5),

(1, '2025-04-02', 1, 1, 5),
(1, '2025-04-02', 1, 2, 5),
(1, '2025-04-02', 1, 3, 5),
(0, '2025-04-02', 1, 4, 5),
(1, '2025-04-02', 1, 5, 5),
(0, '2025-04-02', 1, 6, 5),
(1, '2025-04-02', 1, 7, 5),
(1, '2025-04-02', 1, 8, 5),

(1, '2025-04-03', 1, 1, 5),
(0, '2025-04-03', 1, 2, 5),
(1, '2025-04-03', 1, 3, 5),
(1, '2025-04-03', 1, 4, 5),
(1, '2025-04-03', 1, 5, 5),
(0, '2025-04-03', 1, 6, 5),
(0, '2025-04-03', 1, 7, 5),
(1, '2025-04-03', 1, 8, 5),

(1, '2025-04-04', 1, 1, 5),
(0, '2025-04-04', 1, 2, 5),
(1, '2025-04-04', 1, 3, 5),
(0, '2025-04-04', 1, 4, 5),
(1, '2025-04-04', 1, 5, 5),
(1, '2025-04-04', 1, 6, 5),
(0, '2025-04-04', 1, 7, 5),
(1, '2025-04-04', 1, 8, 5),

(1, '2025-04-05', 1, 1, 5),
(1, '2025-04-05', 1, 2, 5),
(1, '2025-04-05', 1, 3, 5),
(0, '2025-04-05', 1, 4, 5),
(1, '2025-04-05', 1, 5, 5),
(1, '2025-04-05', 1, 6, 5),
(1, '2025-04-05', 1, 7, 5),
(1, '2025-04-05', 1, 8, 5),

(1, '2025-04-06', 1, 1, 5),
(0, '2025-04-06', 1, 2, 5),
(1, '2025-04-06', 1, 3, 5),
(1, '2025-04-06', 1, 4, 5),
(0, '2025-04-06', 1, 5, 5),
(1, '2025-04-06', 1, 6, 5),
(0, '2025-04-06', 1, 7, 5),
(1, '2025-04-06', 1, 8, 5),

(1, '2025-04-07', 1, 1, 5),
(1, '2025-04-07', 1, 2, 5),
(0, '2025-04-07', 1, 3, 5),
(1, '2025-04-07', 1, 4, 5),
(0, '2025-04-07', 1, 5, 5),
(0, '2025-04-07', 1, 6, 5),
(1, '2025-04-07', 1, 7, 5),
(0, '2025-04-07', 1, 8, 5),

(1, '2025-05-01', 1, 1, 5),
(1, '2025-05-01', 1, 2, 5),
(1, '2025-05-01', 1, 3, 5),
(1, '2025-05-01', 1, 4, 5),
(0, '2025-05-01', 1, 5, 5),
(0, '2025-05-01', 1, 6, 5),
(1, '2025-05-01', 1, 7, 5),
(0, '2025-05-01', 1, 8, 5),

(1, '2025-05-02', 1, 1, 5),
(1, '2025-05-02', 1, 2, 5),
(1, '2025-05-02', 1, 3, 5),
(0, '2025-05-02', 1, 4, 5),
(1, '2025-05-02', 1, 5, 5),
(0, '2025-05-02', 1, 6, 5),
(1, '2025-05-02', 1, 7, 5),
(1, '2025-05-02', 1, 8, 5),

(1, '2025-05-03', 1, 1, 5),
(0, '2025-05-03', 1, 2, 5),
(1, '2025-05-03', 1, 3, 5),
(1, '2025-05-03', 1, 4, 5),
(1, '2025-05-03', 1, 5, 5),
(0, '2025-05-03', 1, 6, 5),
(0, '2025-05-03', 1, 7, 5),
(1, '2025-05-03', 1, 8, 5),

(1, '2025-05-05', 1, 1, 5),
(0, '2025-05-05', 1, 2, 5),
(1, '2025-05-05', 1, 3, 5),
(0, '2025-05-05', 1, 4, 5),
(1, '2025-05-05', 1, 5, 5),
(1, '2025-05-05', 1, 6, 5),
(0, '2025-05-05', 1, 7, 5),
(1, '2025-05-05', 1, 8, 5),

(1, '2025-05-04', 1, 1, 5),
(1, '2025-05-04', 1, 2, 5),
(1, '2025-05-04', 1, 3, 5),
(0, '2025-05-04', 1, 4, 5),
(1, '2025-05-04', 1, 5, 5),
(1, '2025-05-04', 1, 6, 5),
(1, '2025-05-04', 1, 7, 5),
(1, '2025-05-04', 1, 8, 5),

(1, '2025-05-06', 1, 1, 5),
(0, '2025-05-06', 1, 2, 5),
(1, '2025-05-06', 1, 3, 5),
(1, '2025-05-06', 1, 4, 5),
(0, '2025-05-06', 1, 5, 5),
(1, '2025-05-06', 1, 6, 5),
(0, '2025-05-06', 1, 7, 5),
(1, '2025-05-06', 1, 8, 5),

(1, '2025-05-07', 1, 1, 5),
(1, '2025-05-07', 1, 2, 5),
(0, '2025-05-07', 1, 3, 5),
(1, '2025-05-07', 1, 4, 5),
(0, '2025-05-07', 1, 5, 5),
(0, '2025-05-07', 1, 6, 5),
(1, '2025-05-07', 1, 7, 5),
(0, '2025-05-07', 1, 8, 5);


