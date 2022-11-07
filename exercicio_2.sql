CREATE DATABASE exercicio_2
GO
USE DATABASE exercicio_2

CREATE TABLE carro(
placa		CHAR(7)			NOT NULL,
marca		VARCHAR(20)		NOT NULL,
modelo		VARCHAR(50)		NOT NULL,
cor			VARCHAR(30)		NOT NULL,
ano			INT				NOT NULL
PRIMARY KEY(placa)
)

CREATE TABLE pe�as(
codigo		INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL,
valor		DECIMAL(7,2)	NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE cliente(
nome		VARCHAR(150)	NOT NULL,
logradouro	VARCHAR(200)	NOT NULL,
num			INT				NOT NULL,
bairro		VARCHAR(50)		NOT NULL,
telefone	CHAR(8)			NOT NULL,
carro		CHAR(7)			NOT NULL
PRIMARY KEY(carro)
FOREIGN KEY(carro) 
	REFERENCES carro(placa)
)

CREATE TABLE servi�o(
carro		CHAR(7)			NOT NULL,
pe�a		INT				NOT NULL,
qtdade		INT				NOT NULL,
valor		DECIMAL(7,2)	NOT NULL,
data		DATETIME		NOT NULL
PRIMARY KEY(carro, pe�a, data)
FOREIGN KEY(carro)
	REFERENCES carro(placa),
FOREIGN KEY(pe�a)
	REFERENCES pe�as(codigo)
)

INSERT INTO cliente VALUES ('Jo�o Alves', 'R. Pereira Barreto', 1258, 'Jd. Oliveiras', '21549658', 'DXO9876'),
('Ana Maria', 'R. 7 de Setembro', 259, 'Centro', '96588541', 'LKM7380'),
('Clara Oliveira', 'Av. Na��es Unidas', 10254, 'Pinheiros', '24589658', 'EGT4631'),
('Jos� Sim�es', 'R. XV de Novembro', 36, '�gua Branca', '78952459', 'BCD7521'),
('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', '69582548', 'AFT9087')

INSERT INTO carro VALUES ('AFT9087', 'VW', 'Gol', 'Preto', 2007),
('DXO9876', 'Ford', 'Ka', 'Azul', 2000),
('EGT4631', 'Renault', 'Clio', 'Verde', 2004),
('LKM7380', 'Fiat', 'Palio', 'Prata', 1997),
('BCD7521', 'Ford', 'Fiesta', 'Preto', 1999)

INSERT INTO pe�as VALUES (1, 'Vela', 70.00),
(2, 'Correia Dentada', 125.00),
(3, 'Trambulador', 90.00),
(4, 'Filtro de Ar', 30.00)

INSERT INTO servi�o VALUES ('DXO9876', 1, 4, 280.00, '2020-08-01'),
('DXO9876', 4, 1, 30.00, '2020-08-01'),
('EGT4631', 3, 1, 90.00, '2020-08-02'),
('DXO9876', 2, 1, 125.00, '2020-08-07')

SELECT placa 
FROM carro
WHERE ano < 2001

SELECT marca + ' ' + modelo + ' ' + cor AS carro
FROM carro
WHERE ano > 2005

SELECT codigo, nome
FROM pe�as
WHERE valor < 80.00

SELECT telefone
FROM cliente
WHERE carro IN 
(
	SELECT placa
	FROM carro
	WHERE modelo LIKE 'Ka'
)

SELECT logradouro + ', ' + CAST(num AS VARCHAR(10)) + ', ' + bairro AS endere�o
FROM cliente
WHERE carro IN
(
	SELECT carro
	FROM servi�o
	WHERE data = '2020-08-02'
)