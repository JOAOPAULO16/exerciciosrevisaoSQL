CREATE DATABASE exercicio5
GO
USE exercicio5

CREATE TABLE fornecedores(
codigo				INT				NOT NULL,
nome				VARCHAR(150)	NOT NULL,
atividade			VARCHAR(200)	NOT NULL,
telefone			CHAR(8)			NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE clientes(
codigo				INT				NOT NULL,
nome				VARCHAR(150)	NOT NULL,
logradouro			VARCHAR(200)	NOT NULL,
numero				INT				NOT NULL,
telefone			CHAR(8)			NOT NULL,
data_nasc			DATETIME		NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE prod (
codigo				INT				NOT NULL,
nome				VARCHAR(150)	NOT NULL,
valor_unitario		DECIMAL(7,2)	NOT NULL,
qtdade_estoque		INT				NOT NULL,
descricao			VARCHAR(255)	NOT NULL,
codigo_fornecedor	INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(codigo_fornecedor)
	REFERENCES fornecedores(codigo)
)

CREATE TABLE pedido(
codigo				INT				NOT NULL,
codigo_cliente		INT				NOT NULL,
codigo_produto		INT				NOT NULL,
quantidade			INT				NOT NULL,
previsao_entrega	DATETIME		NOT NULL
PRIMARY KEY(codigo, codigo_cliente, codigo_produto)
FOREIGN KEY (codigo_produto)
	REFERENCES prod (codigo),
FOREIGN KEY(codigo_cliente)
	REFERENCES clientes(codigo)
)

INSERT INTO fornecedores VALUES (1001, 'Estrela', 'Brinquedo', '41525898'),
(1002, 'Lacta', 'Chocolate', '42698596'),
(1003, 'Asus', 'Informática', '52014596'),
(1004, 'Tramontina', 'Utensílios Domésticos', '50563985'),
(1005, 'Grow', 'Brinquedos', '47896325'),
(1006,	'Mattel', 'Bonecos', '59865898')

INSERT INTO clientes VALUES (33601, 'Maria Clara', 'R. 1° de Abril', 870, '96325874', 2000-08-15),
(33602,	'Alberto Souza', 'R. XV de Novembro', 987, '95873625',	1985-02-02),
(33603,	'Sonia Silva', 'R. Voluntários da Pátria', 1151, '75418596', 1957-08-23),
(33604,	'José Sobrinho', 'Av. Paulista', 250, '85236547', 1986-12-09),
(33605,	'Carlos Camargo', 'Av. Tiquatira', 9652, '75896325', 1971-03-25)

INSERT INTO prod VALUES (1,	'Banco Imobiliário', 65.00,	15,	'Versão Super Luxo', 1001),
(2,	'Puzzle 5000 peças', 50.00,	5,	'Mapas Mundo', 1005),
(3,	'Faqueiro',	'350.00', 0, '120 peças', 1004),
(4,	'Jogo para churrasco', 75.00, 3, '7 peças',	1004),
(5,	'Tablet', 750.00, 29, 'Tablet', 1003),
(6,	'Detetive',	 49.00,	0,	'Nova Versão do Jogo', 1001),
(7,	'Chocolate com Paçoquinha',	6.00, 0, 'Barra', 1002),
(8,	'Galak', 5.00, 65, 'Barra', 1002)

INSERT INTO pedido VALUES (99001, 33601, 1, 1,	2012-06-07),
(99001, 33601, 2, 1, 2012-06-07),
(99001,	33601, 8, 3, 2012-06-07),
(99002, 33602, 2, 1, 2012-06-09),
(99002, 33602, 4, 3, 2012-06-09),
(99003,	33605, 5, 1, 2012-06-15)

SELECT pd.quantidade, SUM(pr.valor_unitario) AS valor_total, CAST(SUM(pr.valor_unitario) * 0.75 AS DECIMAL(7,2)) AS valor_total_com_desconto
FROM pedido pd, prod pr, clientes c
WHERE  pd.codigo_produto = pr.codigo
	AND c.codigo = pd.codigo_cliente
	AND pd.codigo_produto IN
(
	SELECT pr.codigo
	FROM prod pr, pedido pd, clientes C
	WHERE pd.codigo_produto = pr.codigo
		AND c.codigo = pd.codigo_cliente
		AND c.nome LIKE '%Maria%'
)
GROUP BY pd.codigo_cliente, pd.quantidade

SELECT nome
FROM prod
WHERE qtdade_estoque = 0

UPDATE prod
SET valor_unitario = valor_unitario * 0.9
WHERE descricao LIKE '%Barra%'

UPDATE prod
SET qtdade_estoque = 10
WHERE nome LIKE '%Faqueiro%'

SELECT nome 
FROM clientes
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) >= 40

SELECT nome, telefone
FROM fornecedores
WHERE atividade LIKE '%Brinquedo%'
	OR atividade LIKE '%Chocolate%'

SELECT nome, CAST(valor_unitario * 0.75 AS DECIMAL(7,2)) AS valor_com_desconto
FROM prod
WHERE valor_unitario <= 50.00

SELECT nome, CAST(valor_unitario * 1.1 AS DECIMAL(7,2)) AS valor_com_desconto
FROM prod
WHERE valor_unitario >= 100.00

SELECT pr.nome, CAST(pr.valor_unitario * 0.85 AS DECIMAL(7,2)) AS valor_com_desconto
FROM prod pr, pedido pd
WHERE pr.codigo = pd.codigo_produto
	AND pd.codigo = 99001

SELECT DISTINCT pd.codigo, c.nome, DATEDIFF(YEAR, c.data_nasc, GETDATE()) AS idade
FROM pedido pd, clientes c
WHERE c.codigo = pd.codigo_cliente