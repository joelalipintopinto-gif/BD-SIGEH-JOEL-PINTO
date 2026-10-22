
-- SIGEH: criação do zero e 20 registos fictícios por tabela.

-- ATENÇÃO: elimina e recria a base de dados sigeh.

DROP DATABASE IF EXISTS sigeh;

CREATE DATABASE sigeh CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sigeh;

CREATE TABLE hospitais(id_hospital INT PRIMARY KEY,nome VARCHAR(100) NOT NULL,provincia VARCHAR(60) NOT NULL,cidade VARCHAR(60) NOT NULL,endereco VARCHAR(150) NOT NULL,telefone VARCHAR(30),email VARCHAR(100) UNIQUE,nivel ENUM('Central','Provincial','Distrital','Geral') NOT NULL,estado ENUM('ACTIVO','INACTIVO') NOT NULL) ENGINE=InnoDB;

CREATE TABLE servicos(id_servico INT PRIMARY KEY,id_hospital INT NOT NULL,nome VARCHAR(80) NOT NULL,descricao VARCHAR(200),estado ENUM('ACTIVO','INACTIVO') NOT NULL,FOREIGN KEY(id_hospital) REFERENCES hospitais(id_hospital)) ENGINE=InnoDB;

CREATE TABLE camas(id_cama INT PRIMARY KEY,id_hospital INT NOT NULL,id_servico INT NOT NULL,codigo VARCHAR(20) NOT NULL,tipo ENUM('GERAL','PEDIATRICA','INTENSIVA','MATERNIDADE') NOT NULL,estado ENUM('LIVRE','OCUPADA','RESERVADA','INDISPONIVEL') NOT NULL,UNIQUE(id_hospital,codigo),FOREIGN KEY(id_hospital) REFERENCES hospitais(id_hospital),FOREIGN KEY(id_servico) REFERENCES servicos(id_servico)) ENGINE=InnoDB;

CREATE TABLE medicamentos(id_medicamento INT PRIMARY KEY,nome VARCHAR(100) NOT NULL,forma VARCHAR(60) NOT NULL,concentracao VARCHAR(40) NOT NULL,unidade_medida VARCHAR(30) NOT NULL) ENGINE=InnoDB;

CREATE TABLE stock_medicamentos(id_stock INT PRIMARY KEY,id_hospital INT NOT NULL,id_medicamento INT NOT NULL,quantidade INT NOT NULL,quantidade_reservada INT NOT NULL,validade_lote DATE NOT NULL,actualizado_em DATETIME NOT NULL,UNIQUE(id_hospital,id_medicamento),CHECK(quantidade>=0),CHECK(quantidade_reservada>=0 AND quantidade_reservada<=quantidade),FOREIGN KEY(id_hospital) REFERENCES hospitais(id_hospital),FOREIGN KEY(id_medicamento) REFERENCES medicamentos(id_medicamento)) ENGINE=InnoDB;

CREATE TABLE bolsas_sangue(id_bolsa INT PRIMARY KEY,id_hospital INT NOT NULL,grupo_sanguineo ENUM('A','B','AB','O') NOT NULL,factor_rh ENUM('POSITIVO','NEGATIVO') NOT NULL,estado ENUM('DISPONIVEL','RESERVADA','UTILIZADA','EXPIRADA') NOT NULL,data_colheita DATE NOT NULL,data_validade DATE NOT NULL,CHECK(data_validade>=data_colheita),FOREIGN KEY(id_hospital) REFERENCES hospitais(id_hospital)) ENGINE=InnoDB;

CREATE TABLE emergencias(id_emergencia INT PRIMARY KEY,codigo VARCHAR(20) UNIQUE NOT NULL,data_hora DATETIME NOT NULL,prioridade ENUM('BAIXA','MEDIA','ALTA','CRITICA') NOT NULL,descricao VARCHAR(250) NOT NULL,estado ENUM('REGISTADA','EM_AVALIACAO','ENCAMINHADA','CONCLUIDA','CANCELADA') NOT NULL,origem VARCHAR(100) NOT NULL) ENGINE=InnoDB;

CREATE TABLE necessidades(id_necessidade INT PRIMARY KEY,id_emergencia INT NOT NULL,tipo_recurso ENUM('CAMA','MEDICAMENTO','SANGUE','SERVICO','EQUIPAMENTO') NOT NULL,descricao VARCHAR(200) NOT NULL,quantidade INT NOT NULL,prioridade ENUM('BAIXA','MEDIA','ALTA','CRITICA') NOT NULL,estado ENUM('PENDENTE','PARCIAL','SATISFEITA','CANCELADA') NOT NULL,CHECK(quantidade>0),FOREIGN KEY(id_emergencia) REFERENCES emergencias(id_emergencia)) ENGINE=InnoDB;

CREATE TABLE pedidos_recepcao(id_pedido INT PRIMARY KEY,id_emergencia INT NOT NULL,id_hospital INT NOT NULL,data_pedido DATETIME NOT NULL,estado ENUM('PENDENTE','ACEITE','RECUSADO','CANCELADO') NOT NULL,observacao VARCHAR(250),FOREIGN KEY(id_emergencia) REFERENCES emergencias(id_emergencia),FOREIGN KEY(id_hospital) REFERENCES hospitais(id_hospital)) ENGINE=InnoDB;

CREATE TABLE internamentos(id_internamento INT PRIMARY KEY,id_emergencia INT NOT NULL,id_hospital INT NOT NULL,id_cama INT NOT NULL,codigo_paciente VARCHAR(30) NOT NULL,data_entrada DATETIME NOT NULL,data_alta DATETIME NULL,estado ENUM('ATIVO','ALTA','TRANSFERIDO') NOT NULL,CHECK(data_alta IS NULL OR data_alta>=data_entrada),FOREIGN KEY(id_emergencia) REFERENCES emergencias(id_emergencia),FOREIGN KEY(id_hospital) REFERENCES hospitais(id_hospital),FOREIGN KEY(id_cama) REFERENCES camas(id_cama)) ENGINE=InnoDB;

CREATE TABLE encaminhamentos(id_encaminhamento INT PRIMARY KEY,id_emergencia INT NOT NULL,id_hospital_origem INT NULL,id_hospital_destino INT NOT NULL,data_hora DATETIME NOT NULL,meio_transporte ENUM('AMBULANCIA','MEIOS_PROPRIOS','OUTRO') NOT NULL,estado ENUM('PROPOSTO','CONFIRMADO','EM_TRANSITO','CONCLUIDO','CANCELADO') NOT NULL,observacao VARCHAR(250),FOREIGN KEY(id_emergencia) REFERENCES emergencias(id_emergencia),FOREIGN KEY(id_hospital_origem) REFERENCES hospitais(id_hospital),FOREIGN KEY(id_hospital_destino) REFERENCES hospitais(id_hospital)) ENGINE=InnoDB;

INSERT INTO hospitais (id_hospital,nome,provincia,cidade,endereco,telefone,email,nivel,estado) VALUES
(1,'Hospital Simulado 01','Maputo Cidade','Maputo','Av. de Demonstração 101','+258 84 000 0001','hospital01@sigeh.test','Central','ACTIVO'),
(2,'Hospital Simulado 02','Maputo Província','Matola','Av. de Demonstração 102','+258 84 000 0002','hospital02@sigeh.test','Provincial','ACTIVO'),
(3,'Hospital Simulado 03','Gaza','Xai-Xai','Av. de Demonstração 103','+258 84 000 0003','hospital03@sigeh.test','Distrital','ACTIVO'),
(4,'Hospital Simulado 04','Inhambane','Inhambane','Av. de Demonstração 104','+258 84 000 0004','hospital04@sigeh.test','Geral','ACTIVO'),
(5,'Hospital Simulado 05','Sofala','Beira','Av. de Demonstração 105','+258 84 000 0005','hospital05@sigeh.test','Central','ACTIVO'),
(6,'Hospital Simulado 06','Manica','Chimoio','Av. de Demonstração 106','+258 84 000 0006','hospital06@sigeh.test','Provincial','ACTIVO'),
(7,'Hospital Simulado 07','Tete','Tete','Av. de Demonstração 107','+258 84 000 0007','hospital07@sigeh.test','Distrital','ACTIVO'),
(8,'Hospital Simulado 08','Zambézia','Quelimane','Av. de Demonstração 108','+258 84 000 0008','hospital08@sigeh.test','Geral','ACTIVO'),
(9,'Hospital Simulado 09','Nampula','Nampula','Av. de Demonstração 109','+258 84 000 0009','hospital09@sigeh.test','Central','ACTIVO'),
(10,'Hospital Simulado 10','Cabo Delgado','Pemba','Av. de Demonstração 110','+258 84 000 0010','hospital10@sigeh.test','Provincial','ACTIVO'),
(11,'Hospital Simulado 11','Niassa','Lichinga','Av. de Demonstração 111','+258 84 000 0011','hospital11@sigeh.test','Distrital','ACTIVO'),
(12,'Hospital Simulado 12','Maputo Cidade','Maputo','Av. de Demonstração 112','+258 84 000 0012','hospital12@sigeh.test','Geral','ACTIVO'),
(13,'Hospital Simulado 13','Sofala','Dondo','Av. de Demonstração 113','+258 84 000 0013','hospital13@sigeh.test','Central','ACTIVO'),
(14,'Hospital Simulado 14','Nampula','Nacala','Av. de Demonstração 114','+258 84 000 0014','hospital14@sigeh.test','Provincial','ACTIVO'),
(15,'Hospital Simulado 15','Tete','Moatize','Av. de Demonstração 115','+258 84 000 0015','hospital15@sigeh.test','Distrital','ACTIVO'),
(16,'Hospital Simulado 16','Gaza','Chókwè','Av. de Demonstração 116','+258 84 000 0016','hospital16@sigeh.test','Geral','ACTIVO'),
(17,'Hospital Simulado 17','Manica','Gondola','Av. de Demonstração 117','+258 84 000 0017','hospital17@sigeh.test','Central','ACTIVO'),
(18,'Hospital Simulado 18','Zambézia','Mocuba','Av. de Demonstração 118','+258 84 000 0018','hospital18@sigeh.test','Provincial','ACTIVO'),
(19,'Hospital Simulado 19','Inhambane','Maxixe','Av. de Demonstração 119','+258 84 000 0019','hospital19@sigeh.test','Distrital','ACTIVO'),
(20,'Hospital Simulado 20','Maputo Província','Boane','Av. de Demonstração 120','+258 84 000 0020','hospital20@sigeh.test','Geral','ACTIVO');


INSERT INTO servicos (id_servico,id_hospital,nome,descricao,estado) VALUES
(1,1,'Urgência','Serviço simulado urgência','ACTIVO'),
(2,2,'Medicina Interna','Serviço simulado medicina interna','ACTIVO'),
(3,3,'Pediatria','Serviço simulado pediatria','ACTIVO'),
(4,4,'Cirurgia','Serviço simulado cirurgia','ACTIVO'),
(5,5,'Maternidade','Serviço simulado maternidade','ACTIVO'),
(6,6,'Ortopedia','Serviço simulado ortopedia','ACTIVO'),
(7,7,'Cuidados Intensivos','Serviço simulado cuidados intensivos','ACTIVO'),
(8,8,'Laboratório','Serviço simulado laboratório','ACTIVO'),
(9,9,'Imagiologia','Serviço simulado imagiologia','ACTIVO'),
(10,10,'Banco de Sangue','Serviço simulado banco de sangue','ACTIVO'),
(11,11,'Urgência','Serviço simulado urgência','ACTIVO'),
(12,12,'Medicina Interna','Serviço simulado medicina interna','ACTIVO'),
(13,13,'Pediatria','Serviço simulado pediatria','ACTIVO'),
(14,14,'Cirurgia','Serviço simulado cirurgia','ACTIVO'),
(15,15,'Maternidade','Serviço simulado maternidade','ACTIVO'),
(16,16,'Ortopedia','Serviço simulado ortopedia','ACTIVO'),
(17,17,'Cuidados Intensivos','Serviço simulado cuidados intensivos','ACTIVO'),
(18,18,'Laboratório','Serviço simulado laboratório','ACTIVO'),
(19,19,'Imagiologia','Serviço simulado imagiologia','ACTIVO'),
(20,20,'Banco de Sangue','Serviço simulado banco de sangue','ACTIVO');


INSERT INTO camas (id_cama,id_hospital,id_servico,codigo,tipo,estado) VALUES
(1,1,1,'C-001','GERAL','OCUPADA'),
(2,2,2,'C-002','PEDIATRICA','OCUPADA'),
(3,3,3,'C-003','INTENSIVA','OCUPADA'),
(4,4,4,'C-004','MATERNIDADE','OCUPADA'),
(5,5,5,'C-005','GERAL','OCUPADA'),
(6,6,6,'C-006','PEDIATRICA','OCUPADA'),
(7,7,7,'C-007','INTENSIVA','OCUPADA'),
(8,8,8,'C-008','MATERNIDADE','OCUPADA'),
(9,9,9,'C-009','GERAL','OCUPADA'),
(10,10,10,'C-010','PEDIATRICA','OCUPADA'),
(11,11,11,'C-011','INTENSIVA','LIVRE'),
(12,12,12,'C-012','MATERNIDADE','LIVRE'),
(13,13,13,'C-013','GERAL','LIVRE'),
(14,14,14,'C-014','PEDIATRICA','LIVRE'),
(15,15,15,'C-015','INTENSIVA','LIVRE'),
(16,16,16,'C-016','MATERNIDADE','LIVRE'),
(17,17,17,'C-017','GERAL','LIVRE'),
(18,18,18,'C-018','PEDIATRICA','LIVRE'),
(19,19,19,'C-019','INTENSIVA','LIVRE'),
(20,20,20,'C-020','MATERNIDADE','LIVRE');


INSERT INTO medicamentos (id_medicamento,nome,forma,concentracao,unidade_medida) VALUES
(1,'Paracetamol','Comprimido','500 mg','comprimido'),
(2,'Amoxicilina','Cápsula','500 mg','cápsula'),
(3,'Soro fisiológico','Solução injectável','0,9%','frasco'),
(4,'Adrenalina','Solução injectável','1 mg/ml','ampola'),
(5,'Ibuprofeno','Comprimido','400 mg','comprimido'),
(6,'Ceftriaxona','Pó injectável','1 g','frasco'),
(7,'Metronidazol','Comprimido','500 mg','comprimido'),
(8,'Salbutamol','Aerossol','100 mcg/dose','inalador'),
(9,'Omeprazol','Cápsula','20 mg','cápsula'),
(10,'Diazepam','Comprimido','5 mg','comprimido'),
(11,'Dexametasona','Solução injectável','4 mg/ml','ampola'),
(12,'Lidocaína','Solução injectável','2%','frasco'),
(13,'Furosemida','Comprimido','40 mg','comprimido'),
(14,'Aspirina','Comprimido','100 mg','comprimido'),
(15,'Insulina regular','Solução injectável','100 UI/ml','frasco'),
(16,'Ondansetrona','Comprimido','4 mg','comprimido'),
(17,'Cloreto de potássio','Solução','10%','ampola'),
(18,'Loratadina','Comprimido','10 mg','comprimido'),
(19,'Diclofenac','Solução injectável','75 mg/3 ml','ampola'),
(20,'Ringer lactato','Solução injectável','500 ml','frasco');


INSERT INTO stock_medicamentos (id_stock,id_hospital,id_medicamento,quantidade,quantidade_reservada,validade_lote,actualizado_em) VALUES
(1,1,1,83,0,'2028-02-28','2026-10-01 08:00:00'),
(2,2,2,86,0,'2027-03-28','2026-10-02 08:00:00'),
(3,3,3,89,5,'2028-04-28','2026-10-03 08:00:00'),
(4,4,4,92,0,'2027-05-28','2026-10-04 08:00:00'),
(5,5,5,95,0,'2028-06-28','2026-10-05 08:00:00'),
(6,6,6,98,5,'2027-07-28','2026-10-06 08:00:00'),
(7,7,7,101,0,'2028-08-28','2026-10-07 08:00:00'),
(8,8,8,104,0,'2027-09-28','2026-10-08 08:00:00'),
(9,9,9,107,5,'2028-10-28','2026-10-09 08:00:00'),
(10,10,10,110,0,'2027-11-28','2026-10-10 08:00:00'),
(11,11,11,113,0,'2028-12-28','2026-10-11 08:00:00'),
(12,12,12,116,5,'2027-01-28','2026-10-12 08:00:00'),
(13,13,13,119,0,'2028-02-28','2026-10-13 08:00:00'),
(14,14,14,122,0,'2027-03-28','2026-10-14 08:00:00'),
(15,15,15,125,5,'2028-04-28','2026-10-15 08:00:00'),
(16,16,16,128,0,'2027-05-28','2026-10-16 08:00:00'),
(17,17,17,131,0,'2028-06-28','2026-10-17 08:00:00'),
(18,18,18,134,5,'2027-07-28','2026-10-18 08:00:00'),
(19,19,19,137,0,'2028-08-28','2026-10-19 08:00:00'),
(20,20,20,140,0,'2027-09-28','2026-10-20 08:00:00');


INSERT INTO bolsas_sangue (id_bolsa,id_hospital,grupo_sanguineo,factor_rh,estado,data_colheita,data_validade) VALUES
(1,1,'A','POSITIVO','DISPONIVEL','2026-09-02','2026-10-07'),
(2,2,'B','NEGATIVO','DISPONIVEL','2026-09-03','2026-10-08'),
(3,3,'AB','POSITIVO','DISPONIVEL','2026-09-04','2026-10-09'),
(4,4,'O','NEGATIVO','DISPONIVEL','2026-09-05','2026-10-10'),
(5,5,'A','POSITIVO','RESERVADA','2026-09-06','2026-10-11'),
(6,6,'B','NEGATIVO','DISPONIVEL','2026-09-07','2026-10-12'),
(7,7,'AB','POSITIVO','DISPONIVEL','2026-09-08','2026-10-13'),
(8,8,'O','NEGATIVO','DISPONIVEL','2026-09-09','2026-10-14'),
(9,9,'A','POSITIVO','DISPONIVEL','2026-09-10','2026-10-15'),
(10,10,'B','NEGATIVO','RESERVADA','2026-09-11','2026-10-16'),
(11,11,'AB','POSITIVO','DISPONIVEL','2026-09-12','2026-10-17'),
(12,12,'O','NEGATIVO','DISPONIVEL','2026-09-13','2026-10-18'),
(13,13,'A','POSITIVO','DISPONIVEL','2026-09-14','2026-10-19'),
(14,14,'B','NEGATIVO','DISPONIVEL','2026-09-15','2026-10-20'),
(15,15,'AB','POSITIVO','RESERVADA','2026-09-16','2026-10-21'),
(16,16,'O','NEGATIVO','DISPONIVEL','2026-09-17','2026-10-22'),
(17,17,'A','POSITIVO','DISPONIVEL','2026-09-18','2026-10-23'),
(18,18,'B','NEGATIVO','DISPONIVEL','2026-09-19','2026-10-24'),
(19,19,'AB','POSITIVO','DISPONIVEL','2026-09-20','2026-10-25'),
(20,20,'O','NEGATIVO','RESERVADA','2026-09-21','2026-10-26');


INSERT INTO emergencias (id_emergencia,codigo,data_hora,prioridade,descricao,estado,origem) VALUES
(1,'EMG-2026-0001','2026-10-01 11:00:00','BAIXA','Caso de emergência simulado 1; descrição demonstrativa.','EM_AVALIACAO','Centro de Saúde Simulado'),
(2,'EMG-2026-0002','2026-10-01 14:00:00','MEDIA','Caso de emergência simulado 2; descrição demonstrativa.','EM_AVALIACAO','Localidade Simulada'),
(3,'EMG-2026-0003','2026-10-01 17:00:00','ALTA','Caso de emergência simulado 3; descrição demonstrativa.','EM_AVALIACAO','Unidade Simulada'),
(4,'EMG-2026-0004','2026-10-01 20:00:00','CRITICA','Caso de emergência simulado 4; descrição demonstrativa.','EM_AVALIACAO','Comunidade Simulada'),
(5,'EMG-2026-0005','2026-10-01 23:00:00','BAIXA','Caso de emergência simulado 5; descrição demonstrativa.','EM_AVALIACAO','Centro de Saúde Simulado'),
(6,'EMG-2026-0006','2026-10-02 02:00:00','MEDIA','Caso de emergência simulado 6; descrição demonstrativa.','EM_AVALIACAO','Localidade Simulada'),
(7,'EMG-2026-0007','2026-10-02 05:00:00','ALTA','Caso de emergência simulado 7; descrição demonstrativa.','EM_AVALIACAO','Unidade Simulada'),
(8,'EMG-2026-0008','2026-10-02 08:00:00','CRITICA','Caso de emergência simulado 8; descrição demonstrativa.','EM_AVALIACAO','Comunidade Simulada'),
(9,'EMG-2026-0009','2026-10-02 11:00:00','BAIXA','Caso de emergência simulado 9; descrição demonstrativa.','ENCAMINHADA','Centro de Saúde Simulado'),
(10,'EMG-2026-0010','2026-10-02 14:00:00','MEDIA','Caso de emergência simulado 10; descrição demonstrativa.','ENCAMINHADA','Localidade Simulada'),
(11,'EMG-2026-0011','2026-10-02 17:00:00','ALTA','Caso de emergência simulado 11; descrição demonstrativa.','ENCAMINHADA','Unidade Simulada'),
(12,'EMG-2026-0012','2026-10-02 20:00:00','CRITICA','Caso de emergência simulado 12; descrição demonstrativa.','ENCAMINHADA','Comunidade Simulada'),
(13,'EMG-2026-0013','2026-10-02 23:00:00','BAIXA','Caso de emergência simulado 13; descrição demonstrativa.','ENCAMINHADA','Centro de Saúde Simulado'),
(14,'EMG-2026-0014','2026-10-03 02:00:00','MEDIA','Caso de emergência simulado 14; descrição demonstrativa.','ENCAMINHADA','Localidade Simulada'),
(15,'EMG-2026-0015','2026-10-03 05:00:00','ALTA','Caso de emergência simulado 15; descrição demonstrativa.','ENCAMINHADA','Unidade Simulada'),
(16,'EMG-2026-0016','2026-10-03 08:00:00','CRITICA','Caso de emergência simulado 16; descrição demonstrativa.','CONCLUIDA','Comunidade Simulada'),
(17,'EMG-2026-0017','2026-10-03 11:00:00','BAIXA','Caso de emergência simulado 17; descrição demonstrativa.','CONCLUIDA','Centro de Saúde Simulado'),
(18,'EMG-2026-0018','2026-10-03 14:00:00','MEDIA','Caso de emergência simulado 18; descrição demonstrativa.','CONCLUIDA','Localidade Simulada'),
(19,'EMG-2026-0019','2026-10-03 17:00:00','ALTA','Caso de emergência simulado 19; descrição demonstrativa.','CONCLUIDA','Unidade Simulada'),
(20,'EMG-2026-0020','2026-10-03 20:00:00','CRITICA','Caso de emergência simulado 20; descrição demonstrativa.','CONCLUIDA','Comunidade Simulada');


INSERT INTO necessidades (id_necessidade,id_emergencia,tipo_recurso,descricao,quantidade,prioridade,estado) VALUES
(1,1,'CAMA','Necessidade simulada 1',2,'BAIXA','PENDENTE'),
(2,2,'MEDICAMENTO','Necessidade simulada 2',3,'MEDIA','PENDENTE'),
(3,3,'SANGUE','Necessidade simulada 3',1,'ALTA','PENDENTE'),
(4,4,'SERVICO','Necessidade simulada 4',2,'CRITICA','PENDENTE'),
(5,5,'EQUIPAMENTO','Necessidade simulada 5',3,'BAIXA','PENDENTE'),
(6,6,'CAMA','Necessidade simulada 6',1,'MEDIA','PENDENTE'),
(7,7,'MEDICAMENTO','Necessidade simulada 7',2,'ALTA','PARCIAL'),
(8,8,'SANGUE','Necessidade simulada 8',3,'CRITICA','PARCIAL'),
(9,9,'SERVICO','Necessidade simulada 9',1,'BAIXA','PARCIAL'),
(10,10,'EQUIPAMENTO','Necessidade simulada 10',2,'MEDIA','PARCIAL'),
(11,11,'CAMA','Necessidade simulada 11',3,'ALTA','PARCIAL'),
(12,12,'MEDICAMENTO','Necessidade simulada 12',1,'CRITICA','PARCIAL'),
(13,13,'SANGUE','Necessidade simulada 13',2,'BAIXA','SATISFEITA'),
(14,14,'SERVICO','Necessidade simulada 14',3,'MEDIA','SATISFEITA'),
(15,15,'EQUIPAMENTO','Necessidade simulada 15',1,'ALTA','SATISFEITA'),
(16,16,'CAMA','Necessidade simulada 16',2,'CRITICA','SATISFEITA'),
(17,17,'MEDICAMENTO','Necessidade simulada 17',3,'BAIXA','SATISFEITA'),
(18,18,'SANGUE','Necessidade simulada 18',1,'MEDIA','SATISFEITA'),
(19,19,'SERVICO','Necessidade simulada 19',2,'ALTA','SATISFEITA'),
(20,20,'EQUIPAMENTO','Necessidade simulada 20',3,'CRITICA','SATISFEITA');


INSERT INTO pedidos_recepcao (id_pedido,id_emergencia,id_hospital,data_pedido,estado,observacao) VALUES
(1,1,4,'2026-10-01 12:00:00','RECUSADO','Pedido demonstrativo 1; confirmar disponibilidade.'),
(2,2,5,'2026-10-01 15:00:00','PENDENTE','Pedido demonstrativo 2; confirmar disponibilidade.'),
(3,3,6,'2026-10-01 18:00:00','ACEITE','Pedido demonstrativo 3; confirmar disponibilidade.'),
(4,4,7,'2026-10-01 21:00:00','RECUSADO','Pedido demonstrativo 4; confirmar disponibilidade.'),
(5,5,8,'2026-10-02 00:00:00','PENDENTE','Pedido demonstrativo 5; confirmar disponibilidade.'),
(6,6,9,'2026-10-02 03:00:00','ACEITE','Pedido demonstrativo 6; confirmar disponibilidade.'),
(7,7,10,'2026-10-02 06:00:00','RECUSADO','Pedido demonstrativo 7; confirmar disponibilidade.'),
(8,8,11,'2026-10-02 09:00:00','PENDENTE','Pedido demonstrativo 8; confirmar disponibilidade.'),
(9,9,12,'2026-10-02 12:00:00','ACEITE','Pedido demonstrativo 9; confirmar disponibilidade.'),
(10,10,13,'2026-10-02 15:00:00','RECUSADO','Pedido demonstrativo 10; confirmar disponibilidade.'),
(11,11,14,'2026-10-02 18:00:00','PENDENTE','Pedido demonstrativo 11; confirmar disponibilidade.'),
(12,12,15,'2026-10-02 21:00:00','ACEITE','Pedido demonstrativo 12; confirmar disponibilidade.'),
(13,13,16,'2026-10-03 00:00:00','RECUSADO','Pedido demonstrativo 13; confirmar disponibilidade.'),
(14,14,17,'2026-10-03 03:00:00','PENDENTE','Pedido demonstrativo 14; confirmar disponibilidade.'),
(15,15,18,'2026-10-03 06:00:00','ACEITE','Pedido demonstrativo 15; confirmar disponibilidade.'),
(16,16,19,'2026-10-03 09:00:00','RECUSADO','Pedido demonstrativo 16; confirmar disponibilidade.'),
(17,17,20,'2026-10-03 12:00:00','PENDENTE','Pedido demonstrativo 17; confirmar disponibilidade.'),
(18,18,1,'2026-10-03 15:00:00','ACEITE','Pedido demonstrativo 18; confirmar disponibilidade.'),
(19,19,2,'2026-10-03 18:00:00','RECUSADO','Pedido demonstrativo 19; confirmar disponibilidade.'),
(20,20,3,'2026-10-03 21:00:00','PENDENTE','Pedido demonstrativo 20; confirmar disponibilidade.');


INSERT INTO internamentos (id_internamento,id_emergencia,id_hospital,id_cama,codigo_paciente,data_entrada,data_alta,estado) VALUES
(1,1,1,1,'PAC-SIM-0001','2026-10-02 12:00:00',NULL,'ATIVO'),
(2,2,2,2,'PAC-SIM-0002','2026-10-02 14:00:00',NULL,'ATIVO'),
(3,3,3,3,'PAC-SIM-0003','2026-10-02 16:00:00',NULL,'ATIVO'),
(4,4,4,4,'PAC-SIM-0004','2026-10-02 18:00:00',NULL,'ATIVO'),
(5,5,5,5,'PAC-SIM-0005','2026-10-02 20:00:00',NULL,'ATIVO'),
(6,6,6,6,'PAC-SIM-0006','2026-10-02 22:00:00',NULL,'ATIVO'),
(7,7,7,7,'PAC-SIM-0007','2026-10-03 00:00:00',NULL,'ATIVO'),
(8,8,8,8,'PAC-SIM-0008','2026-10-03 02:00:00',NULL,'ATIVO'),
(9,9,9,9,'PAC-SIM-0009','2026-10-03 04:00:00',NULL,'ATIVO'),
(10,10,10,10,'PAC-SIM-0010','2026-10-03 06:00:00',NULL,'ATIVO'),
(11,11,11,11,'PAC-SIM-0011','2026-10-03 08:00:00','2026-10-07 08:00:00','ALTA'),
(12,12,12,12,'PAC-SIM-0012','2026-10-03 10:00:00','2026-10-04 10:00:00','ALTA'),
(13,13,13,13,'PAC-SIM-0013','2026-10-03 12:00:00','2026-10-05 12:00:00','ALTA'),
(14,14,14,14,'PAC-SIM-0014','2026-10-03 14:00:00','2026-10-06 14:00:00','ALTA'),
(15,15,15,15,'PAC-SIM-0015','2026-10-03 16:00:00','2026-10-07 16:00:00','ALTA'),
(16,16,16,16,'PAC-SIM-0016','2026-10-03 18:00:00','2026-10-04 18:00:00','ALTA'),
(17,17,17,17,'PAC-SIM-0017','2026-10-03 20:00:00','2026-10-05 20:00:00','ALTA'),
(18,18,18,18,'PAC-SIM-0018','2026-10-03 22:00:00','2026-10-06 22:00:00','ALTA'),
(19,19,19,19,'PAC-SIM-0019','2026-10-04 00:00:00','2026-10-08 00:00:00','ALTA'),
(20,20,20,20,'PAC-SIM-0020','2026-10-04 02:00:00','2026-10-05 02:00:00','ALTA');


INSERT INTO encaminhamentos (id_encaminhamento,id_emergencia,id_hospital_origem,id_hospital_destino,data_hora,meio_transporte,estado,observacao) VALUES
(1,1,6,4,'2026-10-03 10:00:00','AMBULANCIA','PROPOSTO','Encaminhamento simulado 1'),
(2,2,7,5,'2026-10-03 12:00:00','MEIOS_PROPRIOS','CONFIRMADO','Encaminhamento simulado 2'),
(3,3,8,6,'2026-10-03 14:00:00','OUTRO','EM_TRANSITO','Encaminhamento simulado 3'),
(4,4,NULL,7,'2026-10-03 16:00:00','AMBULANCIA','CONCLUIDO','Encaminhamento simulado 4'),
(5,5,10,8,'2026-10-03 18:00:00','MEIOS_PROPRIOS','PROPOSTO','Encaminhamento simulado 5'),
(6,6,11,9,'2026-10-03 20:00:00','OUTRO','CONFIRMADO','Encaminhamento simulado 6'),
(7,7,12,10,'2026-10-03 22:00:00','AMBULANCIA','EM_TRANSITO','Encaminhamento simulado 7'),
(8,8,NULL,11,'2026-10-04 00:00:00','MEIOS_PROPRIOS','CONCLUIDO','Encaminhamento simulado 8'),
(9,9,14,12,'2026-10-04 02:00:00','OUTRO','PROPOSTO','Encaminhamento simulado 9'),
(10,10,15,13,'2026-10-04 04:00:00','AMBULANCIA','CONFIRMADO','Encaminhamento simulado 10'),
(11,11,16,14,'2026-10-04 06:00:00','MEIOS_PROPRIOS','EM_TRANSITO','Encaminhamento simulado 11'),
(12,12,NULL,15,'2026-10-04 08:00:00','OUTRO','CONCLUIDO','Encaminhamento simulado 12'),
(13,13,18,16,'2026-10-04 10:00:00','AMBULANCIA','PROPOSTO','Encaminhamento simulado 13'),
(14,14,19,17,'2026-10-04 12:00:00','MEIOS_PROPRIOS','CONFIRMADO','Encaminhamento simulado 14'),
(15,15,20,18,'2026-10-04 14:00:00','OUTRO','EM_TRANSITO','Encaminhamento simulado 15'),
(16,16,NULL,19,'2026-10-04 16:00:00','AMBULANCIA','CONCLUIDO','Encaminhamento simulado 16'),
(17,17,2,20,'2026-10-04 18:00:00','MEIOS_PROPRIOS','PROPOSTO','Encaminhamento simulado 17'),
(18,18,3,1,'2026-10-04 20:00:00','OUTRO','CONFIRMADO','Encaminhamento simulado 18'),
(19,19,4,2,'2026-10-04 22:00:00','AMBULANCIA','EM_TRANSITO','Encaminhamento simulado 19'),
(20,20,NULL,3,'2026-10-05 00:00:00','MEIOS_PROPRIOS','CONCLUIDO','Encaminhamento simulado 20');


-- Fim: 20 registos em cada uma das 11 tabelas.
