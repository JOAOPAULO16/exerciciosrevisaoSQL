CREATE DATABASE exercicio_3
GO
USE DATABASE exercicio_3

CREATE TABLE pacientes(
CPF				CHAR(12)		NOT NULL,
nome			VARCHAR(150)	NOT NULL,
rua				VARCHAR(200)	NOT NULL,
num				INT				NOT NULL,
bairro			VARCHAR(80)		NOT NULL,
telefone		CHAR(8)			NULL,
data_nasc		DATETIME		NOT NULL
PRIMARY KEY(CPF)
)

CREATE TABLE medico(
codigo			INT				NOT NULL,
nome			VARCHAR(150)	NOT NULL,
especialidade	VARCHAR(100)	NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE prontuario(
data			DATETIME		NOT NULL,
CPF_paciente	CHAR(12)		NOT NULL,
codigo_medico	INT				NOT NULL,
diagnostico		VARCHAR(150)	NOT NULL,
medicamento		VARCHAR(150)	NOT NULL
PRIMARY KEY(data, CPF_paciente, codigo_medico)
FOREIGN KEY(CPF_paciente)
	REFERENCES pacientes(CPF),
FOREIGN KEY(codigo_medico)
	REFERENCES medico(codigo)
)

INSERT INTO pacientes VALUES ('35454562890', 'Jos� Rubens', 'Campos Salles', 2750, 'Centro', '21450998', '18/10/1954'),
('29865439810', 'Ana Claudia', 'Sete de Setembro', 178, 'Centro', '97382764', '29/05/1960'),
('82176534800', 'Marcos Aur�lio', 'Tim�teo Penteado', 236, 'Vila Galv�o', '68172651', '24/09/1980'),
('12386758770', 'Maria Rita', 'Castello Branco', 7765, 'Vila Ros�lia', NULL, '30/03/1975'),
('92173458910', 'Joana de Souza', 'XV de Novembro', 298, 'Centro', '21276578', '24/04/1944')

INSERT INTO medico VALUES (1, 'Wilson Cesar', 'Pediatra'),
(2, 'Marcia Matos', 'Geriatra'),
(3, 'Carolina Oliveira', 'Pediatra'),
(4, 'Vinicius Araujo', 'Cl�nico Geral')

INSERT INTO prontuario VALUES ('10/09/2020', '35454562890', 2, 'Reumatismo', 'Celebra'),
('10/09/2020','92173458910', 2, 'Renite Al�rgica', 'Allegra'),
('12/09/2020','29865439810', 1,	'Inflama��o de garganta', 'Nimesulida'),
('13/09/2020','35454562890', 2, 'H1N1',	'Tamiflu'),
('15/09/2020', '12386758770', 3, 'Bra�o Quebrado','Dorflex + Gesso')

INSERT INTO prontuario VALUES ('15/09/2020', '82176534800', 4, 'Gripe', 'Resprin')

UPDATE pacientes
SET telefone = '98345621'
WHERE CPF = '12386758770'

UPDATE pacientes
SET rua = 'Volunt�rios da P�trias',
	num = 1980,
	bairro = 'Jd. Aeroporto'
WHERE CPF = '92173458910'

SELECT nome, 'Rua ' + rua + ', ' + CAST(num AS VARCHAR(5)) + ' - ' + bairro AS endere�o
FROM pacientes
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) > 50

SELECT especialidade
FROM medico
WHERE nome LIKE '%Carolina%'

SELECT medicamento
FROM prontuario
WHERE diagnostico LIKE '%Reumatismo%'

SELECT diagnostico, medicamento
FROM prontuario
WHERE CPF_paciente IN
(
	SELECT CPF
	FROM pacientes
	WHERE nome LIKE '%Jos�%'
)

SELECT nome, 
CASE WHEN LEN(especialidade) < 3
	THEN especialidade
	ELSE SUBSTRING(especialidade, 1, 3) + '.'
	END AS especialidade
FROM medico
WHERE codigo IN
(
	SELECT codigo_medico
	FROM prontuario
	WHERE CPF_paciente =
	(
		SELECT CPF
		FROM pacientes
		WHERE nome LIKE '%Jos�%'
	)
)

SELECT SUBSTRING(CPF, 1, 3) + '.' + SUBSTRING(CPF, 4, 3) + '.' + SUBSTRING(CPF, 7, 3) + '-' + SUBSTRING (CPF, 10, 2) AS CPF,
nome,'Rua ' + rua + ', ' + CAST(num AS VARCHAR(5)) + ' - ' + bairro AS endere�o,
CASE WHEN telefone IS NULL
	THEN '-'
	ELSE telefone 
	END AS telefone
FROM pacientes
WHERE CPF IN
(
	SELECT CPF_paciente
	FROM prontuario
	WHERE codigo_medico =
	(
		SELECT codigo
		FROM medico
		WHERE nome LIKE '%Vinicius%'
	)
)

SELECT DATEDIFF(DAY, data, GETDATE()) AS total_dias_consulta
FROM prontuario
WHERE CPF_paciente IN
(
	SELECT CPF
	FROM pacientes
	WHERE nome LIKE '%Maria%'
)