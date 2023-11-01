CREATE DATABASE locadora2
GO
USE locadora2
GO
CREATE TABLE estrela
(
	id_estrela				INT		NOT NULL,
	nome					VARCHAR(50)	NOT NULL
	PRIMARY KEY(id_estrela)
)
GO
CREATE TABLE filme
(
	id_filme				INT		NOT NULL,
	titulo					VARCHAR(40)	NOT NULL,
	ano					INT		NULL CHECK(ano <= 2021)
	PRIMARY KEY(id_filme)
)
GO
CREATE TABLE filme_estrela
(
	id_filme				INT		NOT NULL,
	id_estrela				INT		NOT NULL
	PRIMARY KEY(id_filme, id_estrela)
	FOREIGN KEY(id_filme) REFERENCES filme(id_filme),
	FOREIGN KEY(id_estrela) REFERENCES estrela(id_estrela)
)
GO
CREATE TABLE cliente
(
	num_cad_cliente				INT		NOT NULL,
	nome					VARCHAR(70)	NOT NULL,
	logradouro_end				VARCHAR(150)	NOT NULL,
	num_end					INT		NOT NULL CHECK(num_end >= 0),
	cep_end					CHAR(8)		NULL CHECK(LEN(cep_end) = 8)
	PRIMARY KEY(num_cad_cliente)
)
GO
CREATE TABLE dvd
(
	num_dvd					INT		NOT NULL,
	data_fabr				DATE		NOT NULL CHECK(data_fabr < GETDATE()),
	id_filme				INT		NOT NULL
	PRIMARY KEY(num_dvd)
	FOREIGN KEY(id_filme) REFERENCES filme(id_filme)
)
GO
CREATE TABLE locacao
(
	num_dvd					INT		NOT NULL,
	num_cad_cliente				INT		NOT NULL,
	data_locacao				DATE		NOT NULL DEFAULT GETDATE(),
	data_devolucao				DATE		NOT NULL,
	valor					DECIMAL(7, 2)	NOT NULL CHECK(valor >= 0)
	PRIMARY KEY(num_dvd, num_cad_cliente, data_locacao)
	FOREIGN KEY(num_dvd) REFERENCES dvd(num_dvd),
	FOREIGN KEY(num_cad_cliente) REFERENCES cliente(num_cad_cliente),
	CONSTRAINT chk_dtl_dtd CHECK(data_locacao < data_devolucao)
)
GO
ALTER TABLE estrela 
ADD nome_real VARCHAR(50) NULL
GO
ALTER TABLE filme 
ALTER COLUMN titulo VARCHAR(80)
GO
INSERT INTO filme (id_filme, titulo, ano)
VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014), --Um ótimo filme inclusive
(1004, 'A Culpa É das Estreças', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014), --Não to acreditando que esse filme existe
(1006, 'Sing', 2016)
GO
INSERT INTO estrela (id_estrela, nome, nome_real)
VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')
GO
INSERT INTO filme_estrela (id_filme, id_estrela)
VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)
GO
INSERT INTO dvd (num_dvd, data_fabr, id_filme)
VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)
GO
INSERT INTO cliente (num_cad_cliente, nome, logradouro_end, num_end, cep_end)
VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
GO
INSERT INTO locacao (num_dvd, num_cad_cliente, data_locacao, data_devolucao, valor)
VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

--update
--cli 1 cep
UPDATE cliente 
SET cep_end = '08411150'
WHERE num_cad_cliente = 5503
--cli 2 cep
UPDATE cliente 
SET cep_end = '02918190'
WHERE num_cad_cliente = 5504

--loc 1 valor
UPDATE locacao 
SET valor = 3.25
WHERE data_locacao = '2021-02-18' AND num_cad_cliente = 5502
--loc 2 valor
UPDATE locacao 
SET valor = 3.10
WHERE data_locacao = '2021-02-24' AND num_cad_cliente = 5501

--dvd 1 data
UPDATE dvd 
SET data_fabr = '2019-07-14'
WHERE num_dvd = 10005

--star 1 nome real
UPDATE estrela 
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

--delete Sing
DELETE filme
WHERE titulo = 'Sing'


SELECT titulo
FROM filme 
WHERE ano = 2014

SELECT id_filme, ano 
FROM filme
WHERE titulo = 'Birdman'

SELECT id_filme, ano
FROM filme
WHERE titulo LIKE '%plash'

SELECT id_estrela, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'

SELECT id_filme, CONVERT(VARCHAR(10), data_fabr, 103) AS fab
FROM dvd
WHERE data_fabr > '2020-01-01' 

SELECT num_dvd, data_locacao, data_devolucao, valor, valor + 2 AS valor_multa
FROM locacao 
WHERE num_cad_cliente = 5505

SELECT logradouro_end, num_end, cep_end 
FROM cliente 
WHERE nome LIKE 'Matilde Luz'

SELECT nome_real 
FROM estrela
WHERE nome LIKE 'Michael Keaton'

SELECT 
	num_cad_cliente, 
	nome, 
	logradouro_end + ' - Num ' + CAST(num_end AS VARCHAR(10)) + 
	' - CEP ' + STUFF(cep_end, LEN(cep_end) - 2, 0, '-') AS end_comp 
FROM cliente 
WHERE num_cad_cliente >= 5503
----------------------------ExercLocadora2-----------------------------

--1/
SELECT 
f.id_filme, 
f.ano, 
CASE 
	WHEN LEN(f.titulo) > 10
		THEN SUBSTRING(f.titulo, 1, 10) + '...'
	ELSE 
		f.titulo 
	END AS titulo
FROM filme AS f 
INNER JOIN dvd AS d ON f.id_filme = d.id_filme 
WHERE d.data_fabr > '2020-01-01'

--2/
SELECT 
d.num_dvd, 
d.data_fabr, 
DATEDIFF(MONTH, d.data_fabr, GETDATE()) AS qntd_mes_fabr
FROM dvd AS d
INNER JOIN filme AS f ON d.id_filme = f.id_filme
WHERE f.titulo LIKE 'Interestelar'

--3/
SELECT 
l.num_dvd, 
l.data_locacao,
l.data_devolucao,
DATEDIFF(DAY, l.data_locacao, l.data_devolucao) AS dias_alugado,
l.valor 
FROM locacao AS l 
INNER JOIN cliente AS c ON l.num_cad_cliente = c.num_cad_cliente 
WHERE c.nome LIKE '%Rosa%'

--4/
SELECT 
c.nome,
c.logradouro_end + ' ' + CAST(c.num_end AS VARCHAR) AS endereco_completo, 
SUBSTRING(c.cep_end, 1, 5) + '-' + SUBSTRING(c.cep_end, 6, 8) AS cep
FROM cliente AS c
INNER JOIN locacao AS l ON l.num_cad_cliente = c.num_cad_cliente 
WHERE l.num_dvd = '10002'
