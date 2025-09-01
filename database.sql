DROP DATABASE IF EXISTS MatchaFundingMySQL;
CREATE DATABASE IF NOT EXISTS MatchaFundingMySQL;
USE MatchaFundingMySQL;

/* 
Funcion que valida un RUT dado a traves de una expresion regular.
CALL ValidarRUT(ID);
*/
DELIMITER $$
CREATE PROCEDURE ValidarRUT (IN r varchar(12))
BEGIN
	SELECT r REGEXP '[0-9]{1,2}[\.]{0,1}[0-9]{3}[\.]{0,1}[0-9]{3}[\-]{1}[0-9|K|k]{1}';
END$$
DELIMITER ;

/*
Regiones de Chile como su propia tabla para poder hacer la validacion correcta
Es un campo sumamanete comun en este contexto.
*/
CREATE TABLE Region (
	ID bigint NOT NULL,
	Codigo varchar(2) NOT NULL,
	Nombre varchar(20) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO Region (ID, Codigo, Nombre)
VALUES
	(1,"AP","Arica y Parinacota"),
	(2,"TA","Tarapaca"),
	(3,"AN","Antofagasta"),
	(4,"AT","Atacama"),
	(5,"CO","Coquimbo"),
	(6,"VA","Valparaiso"),
	(7,"RM","Santiago"),
	(8,"LI","O Higgins"),
	(9,"ML","Maule"),
	(10,"NB","Nuble"),
	(11,"BI","Biobio"),
	(12,"AR","La Araucania"),
	(13,"LR","Los Rios"),
	(14,"LL","Los Lagos"),
	(15,"AI","Aysen"),
	(16,"MA","Magallanes"),
	(17,"NA","Nacional");

/* 
Funcion que busca recibe un string y busca si existe una region que
calce por nombre o codigo.
CALL ValidarRegion(ID);
*/
DELIMITER $$
CREATE PROCEDURE ValidarRegion (IN s varchar(20))
BEGIN
	SELECT Region.ID FROM Region WHERE s=Region.Nombre OR s=Region.Codigo;
END$$
DELIMITER ;

/* 
Funcion que permite ver todas las regiones en el sistema.
SELECT * FROM VerTodasLasRegiones;
*/
CREATE VIEW VerTodasLasRegiones AS
SELECT * FROM Region;

/* 
Funcion que permite ver todas las regiones en el sistema en formato JSON.
SELECT * FROM VerRegionesComoJSON;
*/
CREATE VIEW VerRegionesComoJSON AS
SELECT JSON_ARRAYAGG(
	JSON_OBJECT(
		'ID', ID,
		'Codigo', Codigo,
		'Nombre', Nombre
	)
)
FROM Region;

				/*
Tipo de persona que representa a una empresa en terminos juridicos. 
En este contexto los beneficiarios y financiadores
pueden ser empresas formales.
https://www.sii.cl/mipyme/emprendedor/documentos/fac_Datos_Comenzar_2.htm
*/
CREATE TABLE TipoDePersona (
	ID bigint NOT NULL,
	Codigo varchar(2) NOT NULL,
	Nombre varchar(10) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO TipoDePersona (ID, Codigo, Nombre)
VALUES
	(1,"JU","Juridica"),
	(2,"NA","Natural");

/*
Tipo de empresa que representa una agrupacion en el contexto legal.
https://ipp.cl/general/tipos-de-empresas-en-chile/
*/
CREATE TABLE TipoDeEmpresa (
	ID bigint NOT NULL,
	Codigo varchar(4) NOT NULL,
	Nombre varchar(50) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO TipoDeEmpresa (ID, Codigo, Nombre)
VALUES
	(1,"SA","Sociedad Anonima"),
	(2,"SRL","Sociedad de Responsabilidad Limitada"),
	(3,"SPA","Sociedad por Acciones"),
	(4,"EIRL","Empresa Individual de Responsabilidad Limitada");

/*
Tipo de perfil que asume la empresa, para este contexto
representa su escala.
*/
CREATE TABLE TipoDePerfil (
	ID bigint NOT NULL,
	Codigo varchar(3) NOT NULL,
	Nombre varchar(30) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO TipoDePerfil (ID, Codigo, Nombre)
VALUES
	(1,"EMP","Empresa"),
	(2,"EXT","Extranjero"),
	(3,"INS","Institucion"),
	(4,"MED","Intermediario"),
	(5,"ORG","Organizacion"),
	(6,"PER","Persona");

/*
Clase que representa la empresa, emprendimiento, grupo de investigacion, etc.
que desea postular al fondo. La informacion debe regirse por la descripcion
legal de la empresa.
https://www.registrodeempresasysociedades.cl/MarcaDominio.aspx
https://www.rutificador.co/empresas/buscar
https://www.boletaofactura.com/
https://registros19862.gob.cl/
https://dequienes.cl/
*/
CREATE TABLE Beneficiario (
	ID bigint NOT NULL AUTO_INCREMENT,
	Nombre varchar(100) NOT NULL,
	FechaDeCreacion date NOT NULL,
	RegionDeCreacion bigint NOT NULL,
	Direccion varchar(300) NOT NULL,
	TipoDePersona bigint NOT NULL,
	TipoDeEmpresa bigint NOT NULL,
	Perfil bigint NOT NULL,
	RUTdeEmpresa varchar(12) NOT NULL,
	RUTdeRepresentante varchar(12) NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (RegionDeCreacion) REFERENCES Region(ID),
	FOREIGN KEY (TipoDePersona) REFERENCES TipoDePersona(ID),
	FOREIGN KEY (TipoDeEmpresa) REFERENCES TipoDeEmpresa(ID),
	FOREIGN KEY (Perfil) REFERENCES TipoDePerfil(ID)
);

/* 
Funcion que permite crear un nuevo beneficiario a partir de argumentos dados.
CALL CrearBeneficiario(
	Nombre
	FechaDeCreacion
	RegionDeCreacion
	Direccion
	TipoDePersona
	TipoDeEmpresa
	Perfil
	RUTdeEmpresa
	RUTdeRepresentante
);
*/
DELIMITER $$
CREATE PROCEDURE CrearBeneficiario (
	IN n varchar(100),
	IN fc date,
	IN rc bigint,
	IN dr varchar(300),
	IN tp bigint,
	IN te bigint,
	IN pe bigint,
	IN re varchar(12),
	IN rp varchar(12)
)
BEGIN
	DECLARE region bigint;
	DECLARE tipo_persona bigint;
	DECLARE tipo_empresa bigint;
	DECLARE tipo_perfil bigint;
	DECLARE rut_empresa bigint;
	DECLARE rut_persona bigint;

	SELECT ID FROM Region WHERE rc=Nombre INTO region;
	SELECT ID FROM TipoDePersona WHERE tp=Nombre INTO tipo_persona;
	SELECT ID FROM TipoDeEmpresa WHERE tp=Nombre INTO tipo_empresa;
	SELECT ID FROM TipoDePerfil WHERE tp=Nombre INTO tipo_perfil;
	SELECT re REGEXP '[0-9]{1,2}[\.]{0,1}[0-9]{3}[\.]{0,1}[0-9]{3}[\-]{0,1}[0-9|K|k]{1}' INTO rut_empresa;
	SELECT rp REGEXP '[0-9]{1,2}[\.]{0,1}[0-9]{3}[\.]{0,1}[0-9]{3}[\-]{0,1}[0-9|K|k]{1}' INTO rut_persona;

	IF rut_empresa=1 AND rut_persona=1 AND NOT region=0 AND
	NOT tipo_persona=0 AND NOT tipo_empresa=0 AND NOT tipo_perfil=0
	THEN
		INSERT INTO Beneficiario (
		Nombre,
		FechaDeCreacion,
		RegionDeCreacion,
		Direccion,
		TipoDePersona,
		TipoDeEmpresa,
		Perfil,
		RUTdeEmpresa,
		RUTdeRepresentante
		) 
		VALUES (n, fc, region, dr, tipo_persona, tipo_empresa, tipo_perfil, re, rp);
	END IF;
END$$
DELIMITER ;

/* 
Funcion que permite ver todos los beneficiarios en el sistema.
SELECT * FROM VerTodosLosBeneficiarios;
*/
CREATE VIEW VerTodosLosBeneficiarios AS
SELECT
	Beneficiario.ID,
	Beneficiario.Nombre,
	Beneficiario.FechaDeCreacion,
	Region.Nombre AS RegionDeCreacion,
	Beneficiario.Direccion,
	TipoDePersona.Nombre AS TipoDePersona,
	TipoDeEmpresa.Nombre AS TipoDeEmpresa,
	TipoDePerfil.Nombre AS Perfil,
	Beneficiario.RUTdeEmpresa,
	Beneficiario.RUTdeRepresentante
FROM Beneficiario, Region, TipoDePersona, TipoDeEmpresa, TipoDePerfil
WHERE
	Region.ID=Beneficiario.RegionDeCreacion AND
	TipoDePersona.ID=Beneficiario.TipoDePersona AND
	TipoDeEmpresa.ID=Beneficiario.TipoDeEmpresa AND
	TipoDePerfil.ID=Beneficiario.Perfil;

/*
Clase que representa los proyectos de una misma empresa.
https://www.boletaofactura.com/
*/
CREATE TABLE Proyecto (
	ID bigint NOT NULL AUTO_INCREMENT,
	Titulo varchar(300) NOT NULL,
	Descripcion varchar(500) NOT NULL,
	DuracionEnMesesMinimo int NOT NULL,
	DuracionEnMesesMaximo int NOT NULL,
	Alcance bigint NOT NULL,
	Area varchar(100) NOT NULL,
	Beneficiario bigint NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Beneficiario) REFERENCES Beneficiario(ID),
	FOREIGN KEY (Alcance) REFERENCES Region(ID)
);

/*
Genero u orientacion con la cual una persona se identifica.
Preferi hacerlo una tabla para realizar las validaciones de
fondos con enfoque de genero.
*/
CREATE TABLE Sexo (
	ID bigint NOT NULL,
	Codigo varchar(3) NOT NULL,
	Nombre varchar(30) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO Sexo (ID, Codigo, Nombre)
VALUES
	(1,"VAR","Hombre"),
	(2,"MUJ","Mujer"),
	(3,"NA","Otro");

/*
Clase que representa a una persona natural, la cual puede ser miembro de una 
empresa o proyecto. Abajo de este estan las asociaciones entre persona y 
agrupacion.
https://www.nombrerutyfirma.com/nombre
https://www.nombrerutyfirma.com/rut
https://www.volanteomaleta.com/
*/
CREATE TABLE Persona (
	ID bigint NOT NULL AUTO_INCREMENT,
	Nombre varchar(200) NOT NULL,
	Sexo bigint NOT NULL,
	RUT varchar(12) NOT NULL,
	FechaDeNacimiento date NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Sexo) REFERENCES Sexo(ID)
);

/* 
Funcion que permite ver todas las personas en el sistema.
SELECT * FROM VerTodasLasPersonas;
*/
CREATE VIEW VerTodasLasPersonas AS
SELECT Persona.ID, Persona.Nombre, Persona.RUT, Sexo.Nombre AS Sexo
FROM Persona, Sexo
WHERE Sexo.ID=Persona.Sexo;

/* 
Funcion que permite crear una nueva persona a partir de argumentos dados.
CALL CrearPersona(Nombre, Sexo, RUT);
*/
DELIMITER $$
CREATE PROCEDURE CrearPersona (IN n varchar(200), IN s bigint, IN r varchar(12))
BEGIN
	INSERT INTO Persona (Nombre, Sexo, RUT) VALUES (n, s, r);
END$$
DELIMITER ;

/* 
Funcion que permite borrar a una persona a partir de su ID.
CALL BorrarPersona(ID);
*/
DELIMITER $$
CREATE PROCEDURE BorrarPersona (IN i bigint)
BEGIN
	DELETE FROM Persona WHERE Persona.ID=i;
END$$
DELIMITER ;

/*
Clase que representa a una persona que es parte de una empresa, 
agrupacion o grupo de investigacion.
https://dequienes.cl/
*/
CREATE TABLE Miembro (
	ID bigint NOT NULL AUTO_INCREMENT,
	Beneficiario bigint NOT NULL,
	Persona bigint NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Beneficiario) REFERENCES Beneficiario(ID),
	FOREIGN KEY (Persona) REFERENCES Persona(ID)
);

/*
Clase que representa a una persona que es parte de un proyecto que busca fondos.
https://dequienes.cl/
*/
CREATE TABLE Colaborador (
	ID bigint NOT NULL AUTO_INCREMENT,
	Persona bigint NOT NULL,
	Proyecto bigint NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Persona) REFERENCES Persona(ID),
	FOREIGN KEY (Proyecto) REFERENCES Proyecto(ID)
);

/*
Clase que representa a un usuario de MatchaFunding.
*/
CREATE TABLE Usuario (
	ID bigint NOT NULL AUTO_INCREMENT,
	NombreDeUsuario varchar(200) NOT NULL,
	Contrasena varchar(200) NOT NULL,
	Correo varchar(200) NOT NULL,
	Persona bigint NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Persona) REFERENCES Persona(ID)
);

/*
Agrupacion de multiples empresas y agrupaciones que pretenden postular
en conjunto a un instrumento / fondo comun. A veces puede ser un
requisito para postular a ciertos beneficios.
*/
CREATE TABLE Consorcio (
	ID bigint NOT NULL AUTO_INCREMENT,
	PrimerBeneficiario bigint NOT NULL,
	SegundoBeneficiario bigint NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (PrimerBeneficiario) REFERENCES Beneficiario(ID),
	FOREIGN KEY (SegundoBeneficiario) REFERENCES Beneficiario(ID)
);

/*
Clase que representa las entes financieras que ofrecen los fondos.
En muchos sentidos operan de la misma forma que las entes benficiarias,
lo unico que cambia en rigor son sus relaciones con las otras clases.
https://www.registrodeempresasysociedades.cl/MarcaDominio.aspx
https://www.rutificador.co/empresas/buscar
https://registros19862.gob.cl/
https://dequienes.cl/
*/
CREATE TABLE Financiador (
	ID bigint NOT NULL AUTO_INCREMENT,
	Nombre varchar(100) NOT NULL,
	FechaDeCreacion date NOT NULL,
	RegionDeCreacion bigint NOT NULL,
	Direccion varchar(300) NOT NULL,
	TipoDePersona bigint NOT NULL,
	TipoDeEmpresa bigint NOT NULL,
	Perfil bigint NOT NULL,
	RUTdeEmpresa varchar(12) NOT NULL,
	RUTdeRepresentante varchar(12) NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (RegionDeCreacion) REFERENCES Region(ID),
	FOREIGN KEY (TipoDePersona) REFERENCES TipoDePersona(ID),
	FOREIGN KEY (TipoDeEmpresa) REFERENCES TipoDePersona(ID),
	FOREIGN KEY (Perfil) REFERENCES TipoDePerfil(ID)
);

/* 
Funcion que permite ver todos los beneficiarios en el sistema.
SELECT * FROM VerTodosLosFinanciadores;
*/
CREATE VIEW VerTodosLosFinanciadores AS
SELECT
	Financiador.ID,
	Financiador.Nombre,
	Financiador.FechaDeCreacion,
	Region.Nombre AS RegionDeCreacion,
	Financiador.Direccion,
	TipoDePersona.Nombre AS TipoDePersona,
	TipoDeEmpresa.Nombre AS TipoDeEmpresa,
	TipoDePerfil.Nombre AS Perfil,
	Financiador.RUTdeEmpresa,
	Financiador.RUTdeRepresentante
FROM Financiador, Region, TipoDePersona, TipoDeEmpresa, TipoDePerfil
WHERE
	Region.ID=Financiador.RegionDeCreacion AND
	TipoDePersona.ID=Financiador.TipoDePersona AND
	TipoDeEmpresa.ID=Financiador.TipoDeEmpresa AND
	TipoDePerfil.ID=Financiador.Perfil;

/*
Estado en el que se encuentra un fondo o instrumento.
*/
CREATE TABLE EstadoDeFondo (
	ID bigint NOT NULL,
	Codigo varchar(3) NOT NULL,
	Nombre varchar(40) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO EstadoDeFondo (ID, Codigo, Nombre)
VALUES
	(1,"PRX","Proximo"),
	(2,"ABI","Abierto"),
	(3,"EVA","En evaluacion"),
	(4,"ADJ","Adjudicado"),
	(5,"SUS","Suspendido"),
	(6,"PAY","Patrocinio Institucional"),
	(7,"DES","Desierto"),
	(8,"CER","Cerrrado");

/*
Tipo de beneficio que otorga cierto fondo o instrumento.
*/
CREATE TABLE TipoDeBeneficio (
	ID bigint NOT NULL,
	Codigo varchar(3) NOT NULL,
	Nombre varchar(30) NOT NULL,
	PRIMARY KEY (ID)
);
INSERT INTO TipoDeBeneficio (ID, Codigo, Nombre)
VALUES
	(1,"CAP","Capacitacion"),
	(2,"RIE","Capital de riesgo"),
	(3,"CRE","Creditos"),
	(4,"GAR","Garantias"),
	(5,"MUJ","Incentivo mujeres"),
	(6,"OTR","Otros incentivos"),
	(7,"SUB","Subsidios");

/*
Clase que representa los fondos concursables a los que los proyectos pueden postular.
Esta clase contiene todos los parametros y requisitos que dictan la posterior evaluacion.
Representa tanto los fondos actuales como los historicos, en donde la fecha de cierre
indica a cual de los dos corresponde.
Recursos de fondos historicos:
http://wapp.corfo.cl/transparencia/home/Subsidios.aspx
https://github.com/ANID-GITHUB?tab=repositories
https://datainnovacion.cl/api
*/
CREATE TABLE Instrumento (
	ID bigint NOT NULL AUTO_INCREMENT,
	Titulo varchar(200) NOT NULL,
	Alcance bigint NOT NULL,
	Descripcion varchar(1000) NOT NULL,
	FechaDeApertura date NOT NULL,
	FechaDeCierre date NOT NULL,
	DuracionEnMeses int NOT NULL,
	Beneficios varchar(1000) NOT NULL,
	Requisitos varchar(1000) NOT NULL,
	MontoMinimo int NOT NULL,
	MontoMaximo int NOT NULL,
	Estado bigint NOT NULL,
	TipoDeBeneficio bigint NOT NULL,
	TipoDePerfil bigint NOT NULL,
	EnlaceDelDetalle varchar(300) NOT NULL,
	EnlaceDeLaFoto varchar(300) NOT NULL,
	Financiador bigint NOT NULL,    
	PRIMARY KEY (ID),
	FOREIGN KEY (Alcance) REFERENCES Region(ID),
	FOREIGN KEY (Estado) REFERENCES EstadoDeFondo(ID),
	FOREIGN KEY (TipoDeBeneficio) REFERENCES TipoDeBeneficio(ID),
	FOREIGN KEY (TipoDePerfil) REFERENCES TipoDePerfil(ID),
	FOREIGN KEY (Financiador) REFERENCES Financiador(ID)
);

/* 
Funcion que permite crear un nuevo beneficiario a partir de argumentos dados.
CALL CrearInstrumento(
	Titulo
	Alcance
	Descripcion
	FechaDeApertura
	FechaDeCierre
	DuracionEnMeses
	Beneficios
	Requisitos
	MontoMinimo
	MontoMaximo
	Estado
	TipoDeBeneficio
	TipoDePerfil
	EnlaceDelDetalle
	Financiador
);
*/

DELIMITER $$
CREATE PROCEDURE CrearInstrumento (
	IN ti varchar(200),
	IN al date,
	IN ds varchar(1000),
	IN fa date,
	IN fc date,
	IN du int,
	IN be varchar(1000),
	IN rq varchar(1000),
	IN mi int,
	IN ma int,
	IN es varchar(100),
	IN tb varchar(100),
	IN tp varchar(100),
	IN ed varchar(100),
	IN ef varchar(100),
	IN fi varchar(100)
)
BEGIN
	DECLARE alcance bigint;
	DECLARE estado bigint;
	DECLARE tipo_beneficio bigint;
	DECLARE tipo_perfil bigint;
	DECLARE financiador bigint;

	SELECT ID FROM Alcance WHERE al=Nombre INTO alcance;
	SELECT ID FROM EstadoDeFondo WHERE es=Nombre INTO estado;
	SELECT ID FROM TipoDeBeneficio WHERE tb=Nombre INTO tipo_beneficio;
	SELECT ID FROM TipoDePerfil WHERE tp=Nombre INTO tipo_perfil;
	SELECT ID FROM Financiador WHERE fi=Nombre INTO financiador;

	IF NOT alcance=0 AND NOT estado=0 AND NOT tipo_beneficio=0
        AND NOT tipo_perfil=0 AND NOT financiador=0
	THEN
		INSERT INTO Instrumento (
			Titulo,
			Alcance,
			Descripcion,
			FechaDeApertura,
			FechaDeCierre,
			DuracionEnMeses,
			Beneficios,
			Requisitos,
			MontoMinimo,
			MontoMaximo,
			Estado,
			TipoDeBeneficio,
			TipoDePerfil,
			EnlaceDelDetalle,
			Financiador
		) 
		VALUES (
			ti,
			alcance,
			ds,
			fa,
			fc,
			du,
			be,
			rq,
			mi,
			ma,
			estado,
			tipo_beneficio,
			tipo_perfil,
			ed,
			ef,
			financiador
		);
	END IF;
END$$
DELIMITER ;

/*
Clase que representa las postulaciones de un proyecto a un fondo
https://registros19862.gob.cl/
*/
CREATE TABLE Postulacion (
	ID bigint NOT NULL AUTO_INCREMENT,
	Resultado varchar(30) NOT NULL,
	MontoObtenido int NOT NULL,
	FechaDePostulacion date NOT NULL,
	FechaDeResultado date NOT NULL,
	Detalle varchar(1000) NOT NULL,
	Beneficiario bigint NOT NULL,
	Instrumento bigint NOT NULL,
	Proyecto bigint NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Beneficiario) REFERENCES Beneficiario(ID),
	FOREIGN KEY (Instrumento) REFERENCES Instrumento(ID),
	FOREIGN KEY (Proyecto) REFERENCES Proyecto(ID)
);

/*
Clase que representa la idea para un proyecto
*/
CREATE TABLE Idea (
	ID bigint NOT NULL AUTO_INCREMENT,
	Usuario bigint NOT NULL,
	Campo varchar(1000) NOT NULL,
	Problema varchar(1000) NOT NULL,
	Publico varchar(1000) NOT NULL,
	Innovacion varchar(1000) NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (Usuario) REFERENCES Usuario(ID)
);

INSERT INTO Financiador (ID,Nombre,FechaDeCreacion,RegionDeCreacion,Direccion,TipoDePersona,TipoDeEmpresa,Perfil,RUTdeEmpresa,RUTdeRepresentante)
VALUES
	(1,'ANID','2005-06-23',7,'N/A',1,1,3,'60.915.000-9','14.131.587-0'),
	(2,'CORFO','2005-06-23',7,'N/A',1,1,3,'60.706.000-2','78.i39.379-3'),
	(3,'FondosGob','2005-06-23',7,'N/A',1,1,3,'60.801.000-9','60.801.000-9');

INSERT INTO Beneficiario (ID,Nombre,FechaDeCreacion,RegionDeCreacion,Direccion,TipoDePersona,TipoDeEmpresa,Perfil,RUTdeEmpresa,RUTdeRepresentante)
VALUES
	(1,'ASOCIACION CHILE DISENO ASOCIACION GREMIAL','2025-01-01',17,'N/A',2,4,1,'507412300','507412300'),
	(2,'AGRICOLA JULIO GIDDINGS E I R L','2025-01-01',17,'N/A',2,4,1,'520014225','520014225'),
	(3,'BEATRIZ EDITH ARAYA ARANCIBIA ASESORIAS EN TECNOLOGIAS DE INFORMACION SPA','2025-01-01',17,'N/A',2,4,1,'52001578-7','52001578-7'),
	(4,'SAENS POLIMEROS Y REVESTIMIENTOS LIMITADA','2025-01-01',17,'N/A',2,4,1,'520035087','520035087'),
	(5,'LACTEOS CHAUQUEN SPA','2025-01-01',17,'N/A',2,4,1,'52004143-5','52004143-5'),
	(6,'CALEB OTONIEL ARAYA CASTILLO SPA','2025-01-01',17,'N/A',2,4,1,'52004346-2','52004346-2'),
	(7,'IQUIQUE TELEVISION PRODUCCIONES TELEVISIVAS Y EVENTOS LIMITADA','2025-01-01',17,'N/A',2,4,1,'520046666','520046666'),
	(8,'ALEJANDRO MARIO CAEROLS SILVA EIRL','2025-01-01',17,'N/A',2,4,1,'520050310','520050310'),
	(9,'OSCAR ALCIDES TORRES CORTES E.I.R.L.','2025-01-01',17,'N/A',2,4,1,'520054642','520054642'),
	(10,'SOCIEDAD AGRICOLA Y VIVERO SAN RAFAEL LIMITADA','2025-01-01',17,'N/A',2,4,1,'53306574-0','53306574-0'),
	(11,'FUNDACION DESAFIO','2025-01-01',17,'N/A',2,4,1,'533090079','533090079'),
	(12,'FUNDACION BASURA','2025-01-01',17,'N/A',2,4,1,'53323226-4','53323226-4'),
	(13,'FRIMA S A','2025-01-01',17,'N/A',2,4,1,'590291404','590291404'),
	(14,'ACCIONA CONSTRUCCION S.A. AGENCIA CHILE','2025-01-01',17,'N/A',2,4,1,'59069860-1','59069860-1'),
	(15,'ENYSE AGENCIA CHILE S A','2025-01-01',17,'N/A',2,4,1,'591087800','591087800'),
	(16,'ANGLO AMERICAN TECHNICAL & SUSTAINABILITY SERVICES LTD - AGENCIA EN CHILE','2025-01-01',17,'N/A',2,4,1,'592803909','592803909'),
	(17,'LABORELEC LATIN AMERICA','2025-01-01',17,'N/A',2,4,1,'5928196-0','5928196-0'),
	(18,'INSTITUTO ANTARTICO CHILENO','2025-01-01',17,'N/A',2,4,1,'606050003','606050003'),
	(19,'INSTITUTO NACIONAL DE ESTADISTICAS','2025-01-01',17,'N/A',2,4,1,'607030006','607030006'),
	(20,'CASA DE MONEDA DE CHILE S.A.','2025-01-01',17,'N/A',2,4,1,'608060006','608060006'),
	(21,'SERVICIO NACIONAL DEL PATRIMONIO CULTURAL','2025-01-01',17,'N/A',2,4,1,'609050004','609050004'),
	(22,'UNIVERSIDAD DE CHILE','2025-01-01',17,'N/A',2,4,1,'609100001','609100001'),
	(23,'UNIVERSIDAD DE SANTIAGO DE CHILE','2025-01-01',17,'N/A',2,4,1,'609110007','609110007'),
	(24,'UNIVERSIDAD DEL BIO BIO','2025-01-01',17,'N/A',2,4,1,'609110066','609110066'),
	(25,'UNIVERSIDAD DE VALPARAISO','2025-01-01',17,'N/A',2,4,1,'609210001','609210001'),
	(26,'ACADEMIA POLITECNICA MILITAR','2025-01-01',17,'N/A',2,4,1,'61.101.021-4','61.101.021-4'),
	(27,'INSTITUTO DE FOMENTO PESQUERO','2025-01-01',17,'N/A',2,4,1,'613100008','613100008'),
	(28,'INSTITUTO FORESTAL','2025-01-01',17,'N/A',2,4,1,'613110003','613110003'),
	(29,'INSTITUTO DE INVESTIGACIONES AGROPECUARIAS','2025-01-01',17,'N/A',2,4,1,'613120009','613120009'),
	(30,'AGUAS ANDINAS S A','2025-01-01',17,'N/A',2,4,1,'618080005','618080005'),
	(31,'CENTRO DEL AGUA PARA ZONAS ARIDAS Y SEMIARIDAS DE AMERICA LATINA','2025-01-01',17,'N/A',2,4,1,'619686004','619686004'),
	(32,'UNIVERSIDAD DE O\'HIGGINS','2025-01-01',17,'N/A',2,4,1,'61980530-5','61980530-5'),
	(33,'FUNDACION PATRIMONIO NUESTRO','2025-01-01',17,'N/A',2,4,1,'650028449','650028449'),
	(34,'ASOCIACION GREMIAL DE PRODUCTORES DE OVINOS DE LA NOVENA REGION - OVINOS ARAUCAN','2025-01-01',17,'N/A',2,4,1,'650030354','650030354'),
	(35,'FUNDACION SNP PATAGONIA SUR','2025-01-01',17,'N/A',2,4,1,'650034244','650034244'),
	(36,'FUNDACION SENDERO DE CHILE','2025-01-01',17,'N/A',2,4,1,'650164067','650164067'),
	(37,'PEQUENOS Y MEDIANOS INDUSTRIALES MADEREROS DEL BIO BIO A.G.','2025-01-01',17,'N/A',2,4,1,'650175484','650175484'),
	(38,'ASOCIACION GREMIAL DE CANALES REGIONALES DE TELEVISION DE SENAL ABIERTA DE CHILE','2025-01-01',17,'N/A',2,4,1,'65018149-2','65018149-2'),
	(39,'FEDERACION DE EMPRESAS DE TURISMO DE CHILE - FEDERACION GREMIAL','2025-01-01',17,'N/A',2,4,1,'650195086','650195086'),
	(40,'FUNDACION URBANISMO SOCIAL','2025-01-01',17,'N/A',2,4,1,'650222784','650222784'),
	(41,'ASOC CHILENA DE ORGANIZACIONES DE FERIAS LIBRES ASOF A G','2025-01-01',17,'N/A',2,4,1,'65024560-1','65024560-1'),
	(42,'FUNDACION BANIGUALDAD','2025-01-01',17,'N/A',2,4,1,'650251504','650251504'),
	(43,'FUNDACION PROCULTURA','2025-01-01',17,'N/A',2,4,1,'650262166','650262166'),
	(44,'ASOCIACION GREMIAL DE EMPRESAS DE LA CIRUELA DESHIDRATADA','2025-01-01',17,'N/A',2,4,1,'650269551','650269551'),
	(45,'ASOCIACION GREMIAL CHILENA DE DESARROLLADORES DE VIDEOJUEGOS','2025-01-01',17,'N/A',2,4,1,'65027653-1','65027653-1'),
	(46,'VISION VALDIVIA,CAPITAL NAUTICA DEL PACIFICO SUR-ASOCIACION GREMIAL','2025-01-01',17,'N/A',2,4,1,'65029077-1','65029077-1'),
	(47,'AGENCIA CHILENA DE EFICIENCIA ENERGETICA','2025-01-01',17,'N/A',2,4,1,'65030848-4','65030848-4'),
	(48,'FUNDACION SERVICIO JESUITA A MIGRANTES','2025-01-01',17,'N/A',2,4,1,'650308921','650308921'),
	(49,'FUND JUVENTUD EMPRENDEDORA','2025-01-01',17,'N/A',2,4,1,'650324900','650324900'),
	(50,'FUNDACION FRAUNHOFER CHILE RESEARCH','2025-01-01',17,'N/A',2,4,1,'65033192-3','65033192-3'),
	(51,'ORGANIZACION NO GUBERNAMENTAL DE DESARROLLO CORPORACION DE DESARROLLO PHOENIX BR','2025-01-01',17,'N/A',2,4,1,'65034573-8','65034573-8'),
	(52,'SOCIEDAD GEOGRAFICA DE DOCUMENTACION ANDINA','2025-01-01',17,'N/A',2,4,1,'650348397','650348397'),
	(53,'CORPORACION CULTIVA','2025-01-01',17,'N/A',2,4,1,'65034868-0','65034868-0'),
	(54,'AGENCIA REGIONAL DE DESARROLLO PRODUCTIVO DE LA ARAUCANIA','2025-01-01',17,'N/A',2,4,1,'65034891-5','65034891-5'),
	(55,'ASOCIACION GREMIAL DE PROPIETARIOS, TENEDORES Y USUARIOS DE TIERRAS PRIVADAS Y D','2025-01-01',17,'N/A',2,4,1,'650349784','650349784'),
	(56,'ASOCIACION DE ARQUITECTOS Y PROFESIONALES POR EL PATRIMONIO DE VALPARAISO PLAN','2025-01-01',17,'N/A',2,4,1,'65041039-4','65041039-4'),
	(57,'FUNDACION GRANDES VALORES','2025-01-01',17,'N/A',2,4,1,'65041318-0','65041318-0'),
	(58,'ORGANIZACION NO GUBERNAMENTAL DE DESARROLLO SANTA MARIA','2025-01-01',17,'N/A',2,4,1,'65041820-4','65041820-4'),
	(59,'FUNDACION GANAMOS TODOS','2025-01-01',17,'N/A',2,4,1,'650421396','650421396'),
	(60,'CORPORACION REGIONAL DE DESARROLLO DE LA REGION DE TARAPACA','2025-01-01',17,'N/A',2,4,1,'650429044','650429044'),
	(61,'ASOCIACION GREMIAL DE EMPRENDEDORES EN CHILE A.G','2025-01-01',17,'N/A',2,4,1,'65046213-0','65046213-0'),
	(62,'ORGANIZACIÓN NO GUBERNAMENTAL DE DESARROLLO LA RUTA SOLAR EN LIQUIDACIÓN','2025-01-01',17,'N/A',2,4,1,'650505573','650505573'),
	(63,'FUNDACION IMPULSORA DE UN NUEVO SECTOR EN LA ECONOMIA SISTEMA B','2025-01-01',17,'N/A',2,4,1,'65052193-5','65052193-5'),
	(64,'ORGANIZACION NO GUBERNAMENTAL DE DESARROLLO CANALES U ONG CANALES','2025-01-01',17,'N/A',2,4,1,'65052395-4','65052395-4'),
	(65,'ASOCIACION NACIONAL DE EMPRESAS ESCOS, ANESCO CHILE A.G.','2025-01-01',17,'N/A',2,4,1,'65053196-5','65053196-5'),
	(66,'CENTRO DE INVESTIGACION DE POLIMEROS AVANZADOS, CIPA','2025-01-01',17,'N/A',2,4,1,'65053487-5','65053487-5'),
	(67,'CONSEJO DE INST. PROFESIONALES Y CENTROS DE FORMACION TECNICA A.G','2025-01-01',17,'N/A',2,4,1,'650544846','650544846'),
	(68,'PROPIETARIOS E INDUSTRIALES FORESTALES','2025-01-01',17,'N/A',2,4,1,'65054509-5','65054509-5'),
	(69,'FUNDACION INRIA CHILE','2025-01-01',17,'N/A',2,4,1,'650580443','650580443'),
	(70,'INSTITUTO DE NEUROCIENCIA BIOMEDICA','2025-01-01',17,'N/A',2,4,1,'65059721-4','65059721-4'),
	(71,'ASOCIACION DE MUNICIPALIDADES PARQUE CORDILLERA','2025-01-01',17,'N/A',2,4,1,'650604849','650604849'),
	(72,'FUNDACION DE BENEFICENCIA RECYCLAPOLIS','2025-01-01',17,'N/A',2,4,1,'65060486-5','65060486-5'),
	(73,'FUND CIENTIFICA Y CULTURAL BIOCIENCIA','2025-01-01',17,'N/A',2,4,1,'650612108','650612108'),
	(74,'CORPORACION PARA EL DESARROLLO DE MALLECO','2025-01-01',17,'N/A',2,4,1,'65062346-0','65062346-0'),
	(75,'CORPORACION CULTURAL ACONCAGUA SUMMIT','2025-01-01',17,'N/A',2,4,1,'65064666-5','65064666-5'),
	(79,'ASOCIACION INDIGENA AYMARA SUMA JUIRA DE CARIQUIMA','2025-01-01',17,'N/A',2,4,1,'650694422','650694422'),
	(80,'FUNDACION DEPORTE LIBRE','2025-01-01',17,'N/A',2,4,1,'650707044','650707044'),
	(81,'FUNDACION PARA EL TRABAJO UNIVERSIDAD ARTURO PRAT','2025-01-01',17,'N/A',2,4,1,'650718593','650718593'),
	(82,'CENTRO REGIONAL DE ESTUDIOS EN ALIMENTOS SALUDABLES','2025-01-01',17,'N/A',2,4,1,'650725166','650725166'),
	(83,'FUNDACION PARA EL DESARROLLO SUSTENTABLE DE FRUTILLAR','2025-01-01',17,'N/A',2,4,1,'65074257-5','65074257-5'),
	(84,'FUNDACION CSIRO-CHILE RESEARCH','2025-01-01',17,'N/A',2,4,1,'650756444','650756444'),
	(85,'CORPORACION YO TAMBIEN','2025-01-01',17,'N/A',2,4,1,'650766989','650766989'),
	(86,'O N G DE DESARROLLO CORPORACION DE DESARROLLO LONKO KILAPANG','2025-01-01',17,'N/A',2,4,1,'650776003','650776003'),
	(87,'CORPORACION MUNICIPAL DE TURISMO VICUNA','2025-01-01',17,'N/A',2,4,1,'65080284-5','65080284-5'),
	(88,'FUNDACION LEITAT CHILE','2025-01-01',17,'N/A',2,4,1,'65081283-2','65081283-2'),
	(89,'LO BARNECHEA EMPRENDE','2025-01-01',17,'N/A',2,4,1,'650816412','650816412'),
	(90,'FUNDACION CERROS ISLA','2025-01-01',17,'N/A',2,4,1,'65084846-2','65084846-2'),
	(91,'FUNDACION PATIO VIVO','2025-01-01',17,'N/A',2,4,1,'65086999-0','65086999-0'),
	(92,'CORPORACION CONSTRUYENDO MIS SUENOS','2025-01-01',17,'N/A',2,4,1,'65087946-5','65087946-5'),
	(93,'FUNDACION PARQUE CIENTIFICO TECNOLOGICO DE LA REGION DE ANTOFAGASTA','2025-01-01',17,'N/A',2,4,1,'650881222','650881222'),
	(94,'COOPERATIVA PESQUERA Y COMERCIALIZADORA CALETA SAN PEDRO','2025-01-01',17,'N/A',2,4,1,'650886666','650886666'),
	(95,'COOPERATIVA M-31 DE TONGOY','2025-01-01',17,'N/A',2,4,1,'650899466','650899466'),
	(96,'COOPERATIVA DE TRABAJO PARA EL DESARROLLO LOCAL Y LA ECONOMÍA SOLIDARIA','2025-01-01',17,'N/A',2,4,1,'65091056-7','65091056-7'),
	(97,'CORP. REG.. AYSEN DE INV. Y DES. COOPER. CENTRO DE INV.EN ECOSIST.DE LA PATAGONI','2025-01-01',17,'N/A',2,4,1,'650911466','650911466'),
	(98,'FUNDACION CENTRO DE ESTUDIOS DE MONTANA','2025-01-01',17,'N/A',2,4,1,'650922875','650922875'),
	(99,'FUNDACION LABORATORIO CAMBIO SOCIAL','2025-01-01',17,'N/A',2,4,1,'65092353-7','65092353-7'),
	(100,'FUNDACION TANTI','2025-01-01',17,'N/A',2,4,1,'65094167-5','65094167-5'),
	(101,'ASOCIACION CHILENA DE BIOMASA A.G','2025-01-01',17,'N/A',2,4,1,'65094557-3','65094557-3'),
	(102,'TAYON SPA','2025-01-01',17,'N/A',2,4,1,'77.822.744-4','77.822.744-4'),
	(103,'Instituto Milenio en Amoníaco Verde como Vector Energético (MIGA)','2023-01-01',7,'N/A',2,4,1,'65.225.271-0','65.225.271-0');

CALL CrearInstrumento ('Concurso InES Ciencia Abierta 2025 – Renovación Competitiva','','El concurso InES Ciencia Abierta 2025 – Renovación Competitiva busca fortalecer las capacidades en ciencia abierta disponibles en las instituciones de educación superior, potenciando el acceso y gestión de datos e información científica. El objetivo es asegurar la sostenibilidad, escalabilidad y apropiación de las capacidades instaladas, fortaleciendo la visibilidad de la producción científica local y avanzando hacia una infraestructura de acceso abierto más robusta y sostenible.  Se enfoca en el fortalecimiento de infraestructuras digitales abiertas y el entrenamiento de la comunidad universitaria.  El concurso está dirigido a Universidades reconocidas por el Estado, que se hayan adjudicado proyectos en la convocatoria InES Ciencia Abierta 2021, realizada por ANID.','2025-08-29','2025-10-09',36,'Capacitación, Otros incentivos','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x, Universidades reconocidas por el Estado, que se hayan adjudicado proyectos en la convocatoria InES Ciencia Abierta 2021, realizada por ANID, Universidades con cuatro o más años de acreditación institucional, en conformidad a lo establecido en la Ley N°20.129, y haber entregado el Informe Técnico Final del proyecto InES Ciencia Abierta',0,30000000,'ABI','CAP','ORG','https://anid.cl/concursos/concurso-ines-ciencia-abierta-2025-renovacion-competitiva/','https://anid.cl/wp-content/uploads/2025/01/INES-Ciencia-Abierta-2025-renovacion_web-op.jpg',1);
CALL CrearInstrumento ('Concurso INES Género 2025 – Renovación Competitiva','','La Agencia Nacional de Investigación y Desarrollo, ANID, a través de su Subdirección de Redes, Estrategias y Conocimiento CALL CrearInstrumento (REC), ha impulsado el fortalecimiento de las capacidades en instituciones de educación superior para reducir las brechas de género. Esta iniciativa se alinea con la Política de Igualdad de Género en Ciencia, Tecnología, Conocimiento e Innovación CALL CrearInstrumento (CTCI) del Ministerio de Ciencia, Tecnología, Conocimiento e Innovación, mediante la asignación de fondos públicos. La convocatoria busca fortalecer de manera sostenible las capacidades ya instaladas, promoviendo estructuras y mecanismos que aseguren la transversalización de la perspectiva de género en los procesos de investigación, desarrollo, innovación y emprendimiento de base científica-tecnológica. El objetivo es consolidar las acciones implementadas para disminuir las brechas de género en los ámbitos de I+D+i+e de base científica-tecnológica, en las instituciones de educación superior.','2025-08-29','2025-10-09',36,'Capacitación, Otros incentivos','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x, Contar con cuatro o más años de acreditación institucional, en conformidad a lo establecido en la Ley N°20.129',0,30000000,'ABI','CAP','ORG','https://anid.cl/concursos/concurso-ines-genero-2025-renovacion-competitiva/','https://anid.cl/wp-content/uploads/2025/01/INES-genero-2025-renovacion_web-op.jpg',1);
CALL CrearInstrumento ('Primer llamado Beneficios Complementarios 2026','','Este llamado busca apoyar proyectos de Capital Humano, enfocándose en el desarrollo de capacidades y el fortalecimiento del capital humano en diversas áreas. El objetivo principal es fomentar la innovación y el desarrollo de soluciones que impulsen el crecimiento económico y social. Se priorizarán proyectos que generen impacto positivo en la comunidad y que estén alineados con las políticas públicas del Gobierno.','2025-08-28','2025-10-02',0,'Capacitación, Incentivo mujeres','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x',0,0,'ABI','CAP','PER','https://anid.cl/concursos/primer-llamado-beneficios-complementarios-2026/','https://anid.cl/wp-content/uploads/2025/08/beneficios-complementarios-2026-op.jpg',1);
CALL CrearInstrumento ('Indexación de Revistas Científicas en Colección SciELO Chile 2025','','Convocatoria para indexar revistas científicas chilenas con calidad científica, en todas las áreas del conocimiento, para formar parte de la colección SciELO Chile. Esta actualización incorpora el enfoque de ciencia abierta, entendido como un conjunto de prácticas fundamentadas en la transparencia, la colaboración y la apertura en los procesos de investigación, en sintonía con la Política de Acceso Abierto ANID. La inclusión de estos principios permitirá que los criterios de evaluación de SciELO Chile se alineen con los estándares internacionales vigentes en comunicación científica, promoviendo así una ciencia más accesible, reproducible y con mayor impacto, mediante el intercambio abierto de datos y resultados.','2025-08-18','2025-12-31',0,'Capacitación, Otros incentivos','Revistas científicas chilenas editadas en formato electrónico pertenecientes a todas las áreas del conocimiento. Estas deben publicar predominantemente artículos resultantes de investigaciones científicas y otras contribuciones significativas para el área específica de la revista. Es imprescindible que las revistas mantengan su sitio web actualizado y en funcionamiento durante el periodo de evaluación.',0,0,'ABI','OTR','ORG','https://anid.cl/concursos/convocatoria-para-indexacion-de-revistas-cientificas-en-coleccion-scielo-chile-2025/','https://anid.cl/wp-content/uploads/2025/08/scielo-2025-op.jpg',1);
CALL CrearInstrumento ('Proyectos de investigación conjunta ANID-BMFTR 2025','','Esta convocatoria busca instalar instancias de cooperación, investigación e innovación entre Chile y Alemania, con foco en la investigación científica y robustecer la cooperación entre ambas instituciones, potenciando el trabajo en áreas afines. Se busca desarrollar soluciones científicas, tecnológicas y de innovación, a problemáticas, brechas o necesidades en las áreas definidas en colaboración directa con investigadores/as, académicos/as o representantes del sector privado de Alemania. El financiamiento otorgado por ANID, para los equipos de investigación chilenos, será de un máximo de $300.000.000 por el total del período de ejecución.','2025-08-04','2025-10-15',36,'Capacitación, Otros incentivos','Tener RUT chileno, Institución Nacional Postulante, Investigador o Investigadora Responsable y grupo de investigación de Chile, quienes deben tener experiencia en las áreas temáticas indicadas.',0,300000000,'ABI','OTR','ORG','https://anid.cl/concursos/proyectos-de-investigacion-conjunta-anid-bmbf-2025/','https://anid.cl/wp-content/uploads/2025/08/alemania_web_BMFTR-op.jpg',1);
CALL CrearInstrumento ('Concurso IDeA I+D 2026','','El concurso IDeA I+D 2026 apoya el cofinanciamiento de proyectos de I+D aplicada con un fuerte componente científico, para que desarrollen tecnologías que puedan convertirse en nuevos productos, procesos o servicios, con una razonable probabilidad de generación de impactos productivos, económicos y sociales.','2025-07-31','2025-09-30',24,'Subsidio para regiones y zonas extremas','personas jurídicas nacionales sin fines de lucro, incluidas universidades e instituciones de educación superior reconocidas por el Estado',0,227000000,'ABI','SUB','INS','https://anid.cl/concursos/concurso-idea-id-2026/','https://anid.cl/wp-content/uploads/2025/01/IDEA-ID-2026_web-op.jpg',1);
CALL CrearInstrumento ('Redes, Estrategia y Conocimiento','','Este concurso es una iniciativa conjunta entre la Agencia Nacional de Investigación y Desarrollo CALL CrearInstrumento (ANID) de Chile y la Fundação de Amparo à Pesquisa do Estado de São Paulo CALL CrearInstrumento (FAPESP) de Brasil, con el objetivo de fortalecer la cooperación científica y la innovación a través de proyectos de investigación conjunta. Se busca fomentar el intercambio de conocimientos y capacidades entre equipos de investigadores de ambos países, apoyando el desarrollo de soluciones científicas, tecnológicas y de innovación en áreas priorizadas por Chile y Brasil. La convocatoria se enmarca en la Oportunidad de Agencia Líder FAPESP-ANID, buscando robustecer la cooperación entre ambas agencias de investigación.','2025-07-22','2025-09-01',36,'Capacitación, Capital de riesgo, Otros incentivos','Tener RUT chileno, Institución Extranjera del estado de Sao Paulo, Investigador Responsable de Chile debe trabajar en la propuesta en conjunto con la contraparte extranjera para el proyecto de investigación conjunta',0,161325000,'ABI','CAP','PER','https://fapesp.br/17580/chamada-de-propostas-conjuntas-2025-do-programa-proasa-fapesp-e-a-agencia-nacional-de-investigacion-y-desarrollo-anid','https://anid.cl/wp-content/uploads/2025/07/FAPESP-2025_web-op.jpg',1);
CALL CrearInstrumento ('Doctorado Becas Chile ANID-DAAD 2025','','Esta beca tiene como objetivo formar capital humano avanzado, para que las y los graduados, a su regreso a Chile, apliquen los conocimientos adquiridos y contribuyan al desarrollo científico, académico, económico, social y cultural del país.','2025-07-17','2025-09-01',0,'Capacitación, Capital de riesgo','Personas chilenas. Poseer el grado académico de licenciado o licenciada en carreras de, al menos, ocho semestres, o título profesional en carreras de, al menos, diez semestres de duración o su equivalente en el caso de los estudios de pregrado realizados en el extranjero. Poseer excelencia académica acreditando, al menos, uno de los siguientes requisitos: haber obtenido un promedio final de notas de pregrado igual o superior a 5.0 sobre un máximo de 7.0 o su equivalente, para la obtención de la licenciatura y/o título profesional; o bien, encontrarse dentro del 30% superior de su promoción de titulación o egreso de pregrado. Encontrarse aceptado o aceptada, al momento de la postulación ante el DAAD, para iniciar estudios de doctorado en una universidad o centro de investigación de excelencia en Alemania, lo que deberá certificar de acuerdo con lo señalado en el numeral 4.3 de las bases del concurso.',0,0,'ABI','CAP','PER','https://anid.cl/concursos/doctorado-becas-chile-anid-daad-2025/','https://anid.cl/wp-content/uploads/2025/01/ANID-DAAD-BECAS-CHILE-2025-op.jpg',1);
CALL CrearInstrumento ('Startup Ciencia 2026','','Esta convocatoria, liderada por la Agencia Nacional de Investigación y Desarrollo CALL CrearInstrumento (ANID) a través de la Subdirección de Investigación Aplicada, busca incrementar los emprendimientos de base científico-tecnológica CALL CrearInstrumento (EBCT) en Chile y en etapa temprana.  El objetivo es promover el crecimiento y fortalecimiento de estas empresas a través del cofinanciamiento y apoyo técnico en el desarrollo tecnológico e innovación, validación técnica y de negocios, facilitando su entrada a mercados nacionales e internacionales. Se enfoca en empresas con proyectos que promuevan avances medibles en la instalación y fortalecimiento de la capacidad de emprendimiento científico y tecnológico, avance en la madurez de tecnologías, estrategias de protección de la tecnología, transferencia tecnológica y de negocios, estrategias de desarrollo y validación del consumidor, nuevas alianzas y acuerdos formales de colaboración, y estrategias de financiamiento.  El público objetivo son micro y pequeñas empresas, con menos','2025-07-10','2025-09-10',12,'Capacitación, Capital de riesgo, Otros incentivos','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x,  Empresas lideradas por mujeres: se verificará si quien dirige el proyecto es mujer, si el equipo está compuesto mayoritariamente por mujeres o si la participación societaria o accionaria de las mujeres es mayor al 50% de la propiedad de la persona jurídica. Empresas pertenecientes a regiones distintas a la metropolitana: las postulaciones cuyo beneficiario tenga domicilio registrado en el SII distinto a la Región Metropolitana y que, además, coincida con el lugar donde realiza la actividad principal del negocio o giro.',0,1345500000,'ABI','CAP','EMP','https://anid.cl/concursos/startup-ciencia-2026/','https://anid.cl/wp-content/uploads/2025/01/startup-ciencia-2026-web-op.jpg',1);
CALL CrearInstrumento ('DESARROLLA INVERSIÓN PRODUCTIVA – REGIÓN DE TARAPACÁ – CONVOCATORIA 2025','TA','Buscamos contribuir al desarrollo de la Región de Tarapacá mediante el crecimiento económico de sus empresas – pequeñas y medianas. Apoyando la materialización de proyectos de inversión productiva cofinanciando la adquisición de activo fijo, habilitación de infraestructura productiva y capital de trabajo.','2025-08-28','2025-09-16',0,'Corfo cofinanciará hasta el 60% del costo total de cada proyecto, con tope de $15.000.000, de acuerdo al tramo de inversión total del proyecto. Se podrá cofinanciar con el subsidio la adquisición de activo fijo, habilitación de infraestructura productiva y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,15000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/dip-tarapaca-2025/','',2);
CALL CrearInstrumento ('DESARROLLA INVERSIÓN PRODUCTIVA – REGIÓN DE TARAPACÁ – CONVOCATORIA 2025 COMERCIO Y LOGÍSTICA','TA','Buscamos contribuir al desarrollo de la Región de Tarapacá mediante el crecimiento económico de sus empresas – pequeñas y medianas. Apoyando la materialización de proyectos de inversión productiva cofinanciando la adquisición de activo fijo, habilitación de infraestructura productiva y capital de trabajo.','2025-08-28','2025-09-16',0,'Corfo cofinanciará hasta el 60% del costo total de cada proyecto, con tope de $15.000.000, de acuerdo al tramo de inversión total del proyecto. Se podrá cofinanciar con el subsidio la adquisición de activo fijo, habilitación de infraestructura productiva y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,15000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/dip-tarapaca-comercio-logistica-2025/','',2);
CALL CrearInstrumento ('Anillos Industriales fomento demanda encadenamiento productivo Valparaiso 2025','','La presente convocatoria busca la promoción de iniciativas orientadas a fomentar la producción y demanda de hidrógeno cuenta con un potencial importante para impulsar el desarrollo de esta industria en el país, además de contribuir al cumplimiento de los compromisos de Chile en el marco del Acuerdo de París para alcanzar la carbono-neutralidad al 2050. En virtud de lo señalado, se focalizará esta convocatoria en la temática consistente en \"Anillos Industriales fomento demanda encadenamiento productivo Valparaiso 2025\", con el objetivo de fomentar el desarrollo productivo, el desarrollo de capacidades, la transferencia de tecnología, innovación, y otros procesos habilitantes para hidrógeno verde y sus derivados en el país.','2025-08-27','2025-10-29',0,'Se cofinanciará hasta el 60% del costo total de cada proyecto, con un tope de hasta USD$6.000.000 CALL CrearInstrumento (seis millones de dólares de Estados Unidos de América), el que se entregará en una o más cuotas, según determine Corfo, a título de anticipo.','',0,6000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/anillos-industriales-fomento-demanda-encadenamiento-productivo-valparaiso-2025/','',2);
CALL CrearInstrumento ('DESARROLLA INVERSIÓN PRODUCTIVA – REGIÓN METROPOLITANA – 2° CONVOCATORIA 2025','RM','Apoyo a proyectos de inversión productiva con potencial de generación de externalidades positivas mediante un cofinanciamiento para la adquisición de activo fijo, infraestructura y capital de trabajo. El cofinanciamiento cubre hasta el 60% del costo total del proyecto, con un tope de $20.000.000.','2025-08-27','2025-09-10',1,'El cofinanciamiento cubre hasta el 60% del costo total del proyecto, con un tope de $20.000.000. Para cofinanciar capital de trabajo, se podrá destinar hasta un 20% del monto total de cofinanciamiento entregado por CDPR al proyecto.','Tener RUT chileno',0,20000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/dip-metropolitana-segunda-convocatoria-2025/','',2);
CALL CrearInstrumento ('RED MERCADOS – 1° CONVOCATORIA NACIONAL 2025 ETAPA DESARROLLO','','El Programa Red Mercados busca apoyar a grupos de empresas a incorporar las capacidades y conocimientos necesarios para acceder, directa o indirectamente a mercados internacionales.','2025-01-01','2025-12-31',0,'Financiamiento: Financiamiento de hasta un 90% del costo total de la Etapa, con un tope de hasta $40.000.000 CALL CrearInstrumento (cuarenta millones) por proyecto. El cofinanciamiento de los beneficiarios será de, al menos, el 10% del costo total de la Etapa de Desarrollo del proyecto.','',0,40000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-mercados-primera-convocatoria-nacional-desarrollo-2025/','',2);
CALL CrearInstrumento ('IMPULSA TRANSICION TECNOLOGICA – IMPULSATEC 2025','','Corfo invita a postular al llamado a concurso del instrumento de financiamiento denominado “IMPULSA TRANSICION TECNOLOGICA – IMPULSATEC”, el que tiene por objetivo contribuir a que empresas manufactureras nacionales diversifiquen su productividad y competitividad, insertándose como proveedores en cadenas de valor de sectores especializados.','2025-08-26','2025-10-14',0,'Corfo cofinanciará hasta el 60,00% del costo total del proyecto, con un tope de hasta $1.250.000.000.- CALL CrearInstrumento (mil doscientos cincuenta millones de pesos). El aporte mínimo de las entidades participantes CALL CrearInstrumento (incluye aportes “nuevos o pecuniarios” y “preexistentes o no pecuniarios”) deberá ser de, al menos, un 40,00% del costo total del proyecto y el aporte “nuevo o pecuniario” mínimo deberá corresponder, al menos, a un 20,00% del referido costo total.','Tener RUT chileno',0,1250000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/impulsa-transicion-tecnologica-impulsatec-2025/','',2);
CALL CrearInstrumento ('PAR – REGIÓN DE TARAPACÁ – CONVOCATORIA 2025 COMERCIO Y LOGÍSTICA','TA','Buscamos mejorar el potencial productivo y fortalecer la gestión de las empresas y/o emprendedores de la región de Tarapacá, apoyando el desarrollo de sus competencias y capacidades y cofinanciando proyectos de inversión, que les permitan acceder a nuevas oportunidades de negocios y/o mantener los existentes.','2025-08-25','2025-09-11',0,'Corfo cofinanciará hasta el 80% del costo total de cada proyecto, con tope de $4.000.000. Se podrá cofinanciar con el subsidio la adquisición de activos, gastos operacionales como capacitaciones, insumos, planes de negocios, consultorías, asistencias técnicas y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,4000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/par-tarapaca-comercio-logistica-2025/','',2);
CALL CrearInstrumento ('PAR – REGIÓN DE TARAPACÁ – CONVOCATORIA 2025 PESCA Y AGRICULTURA','TA','Buscamos mejorar el potencial productivo y fortalecer la gestión de las empresas y/o emprendedores de la región de Tarapacá, apoyando el desarrollo de sus competencias y capacidades y cofinanciando proyectos de inversión, que les permitan acceder a nuevas oportunidades de negocios y/o mantener los existentes.','2025-08-25','2025-09-11',0,'Corfo cofinanciará hasta el 80% del costo total de cada proyecto, con tope de $4.000.000. Se podrá cofinanciar con el subsidio la adquisición de activos, gastos operacionales como capacitaciones, insumos, planes de negocios, consultorías, asistencias técnicas y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,4000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/par-tarapaca-pesca-agricultura-2025/','',2);
CALL CrearInstrumento ('PAR – REGIÓN DE TARAPACÁ – CONVOCATORIA 2025 PROVEEDORES DE LA MINERÍA','TA','Buscamos mejorar el potencial productivo y fortalecer la gestión de las empresas y/o emprendedores de la región de Tarapacá, apoyando el desarrollo de sus competencias y capacidades y cofinanciando proyectos de inversión, que les permitan acceder a nuevas oportunidades de negocios y/o mantener los existentes.','2025-08-25','2025-09-11',0,'Corfo cofinanciará hasta el 80% del costo total de cada proyecto, con tope de $4.000.000. Se podrá cofinanciar con el subsidio la adquisición de activos, gastos operacionales como capacitaciones, insumos, planes de negocios, consultorias, asistencias técnicas y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,4000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/par-tarapaca-proveedores-mineria-2025/','',2);
CALL CrearInstrumento ('PAR – REGIÓN DE TARAPACÁ – CONVOCATORIA 2025 TURISMO','TA','Buscamos mejorar el potencial productivo y fortalecer la gestión de las empresas y/o emprendedores de la región de Tarapacá, apoyando el desarrollo de sus competencias y capacidades y cofinanciando proyectos de inversión, que les permitan acceder a nuevas oportunidades de negocios y/o mantener los existentes.','2025-08-25','2025-09-10',0,'Corfo cofinanciará hasta el 80% del costo total de cada proyecto, con tope de $4.000.000. Se podrá cofinanciar con el subsidio la adquisición de activos, gastos operacionales como capacitaciones, insumos, planes de negocios, consultorías, asistencias técnicas y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,4000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/par-tarapaca-turismo-2025/','',2);
CALL CrearInstrumento ('RED DE ASISTENCIA DIGITAL FORTALECE PYME – REGIÓN DE LA ARAUCANÍA – 1° CONVOCATORIA 2025','AR','La Red de Asistencia Digital Fortalece Pyme busca contribuir a que las Pymes aumenten sus ingresos y/o mejoren sus niveles de productividad. Esta convocatoria busca proyectos que contemplen la incorporación de tecnologías digitales en los beneficiarios atendidos de sectores económicos vinculados a Turismo, Agropecuario, Silvícola, Pesca y Acuicultura, Construcción, Manufactura, Tecnologías de Información y Comunicaciones, Energía e Industrias Creativas.','2025-08-19','2025-09-22',3,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto. El monto restante debe ser aportado por los participantes y al menos, el 5% del costo total del proyecto debe ser pecuniario.','Tener RUT chileno',0,600000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asistencia-digital-fortalece-pyme-araucania-1ra-2025/','',2);
CALL CrearInstrumento ('RED DE ASISTENCIA DIGITAL FORTALECE PYME – REGIÓN DE LOS RÍOS – 1° CONVOCATORIA 2025','LR','La Red de Asistencia Digital Fortalece Pyme busca contribuir a que las Pymes de todos los sectores económicos de la región, aumenten sus ingresos y/o mejoren sus niveles de productividad a través de la adopción y utilización de tecnologías digitales en sus procesos de negocio CALL CrearInstrumento (productivos, de gestión y/o comerciales), mediante el apoyo a la operación de proyectos ‘Red de Asistencia Digital Fortalece Pyme, FPyme’ que entregarán servicios en dichos ámbitos.','2025-08-19','2025-09-22',3,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto. El monto restante debe ser aportado por los participantes y al menos, el 5% del costo total del proyecto debe ser pecuniario.','Tener RUT chileno',0,600000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asistencia-digital-fortalece-pyme-los-rios-1ra-2025/','',2);
CALL CrearInstrumento ('RED DE ASISTENCIA DIGITAL FORTALECE PYME – REGIÓN DE ÑUBLE – 1° CONVOCATORIA 2025','NB','La Red de Asistencia Digital Fortalece Pyme busca contribuir a que las Pymes aumenten sus ingresos y/o mejoren sus niveles de productividad. Esta convocatoria busca proyectos que contemplen la incorporación de tecnologías digitales en los beneficiarios atendidos de sectores económicos vinculados a agropecuario – silvícola, construcción, industria manufacturera, turismo y comercio.','2025-08-19','2025-09-22',3,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto. El monto restante debe ser aportado por los participantes y al menos, el 5% del costo total del proyecto debe ser pecuniario.','Tener RUT chileno',0,600000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asistencia-digital-fortalece-pyme-nuble-1ra-2025/','',2);
CALL CrearInstrumento ('RED DE ASISTENCIA DIGITAL FORTALECE PYME – REGIÓN DE O’HIGGINS – 1° CONVOCATORIA 2025','LI','La Red de Asistencia Digital Fortalece Pyme busca contribuir a que las Pymes aumenten sus ingresos y/o mejoren sus niveles de productividad. Esta convocatoria busca proyectos que contemplen la incorporación de tecnologías digitales en los beneficiarios atendidos, Pymes, de todos los sectores económicos de la región, priorizando durante el primer año de ejecución la búsqueda y atención de empresas de los sectores vinculados a la minería, agricultura, manufactura y turismo.','2025-08-19','2025-09-22',3,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto. El monto restante debe ser aportado por los participantes y al menos, el 5% del costo total del proyecto debe ser pecuniario.','Tener RUT chileno',0,600000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asistencia-digital-fortalece-pyme-ohiggins-1ra-2025/','',2);
CALL CrearInstrumento ('RED DE ASISTENCIA DIGITAL FORTALECE PYME – REGIÓN DE VALPARAÍSO – 1° CONVOCATORIA 2025','VA','La Red de Asistencia Digital Fortalece Pyme busca contribuir a que las Pymes aumenten sus ingresos y/o mejoren sus niveles de productividad. Esta convocatoria busca proyectos que contemplen la incorporación de tecnologías digitales en los beneficiarios atendidos de sectores económicos vinculados a a la agricultura y manufactura CALL CrearInstrumento (este último, vinculado a la agroindustria alimentaria).','2025-08-19','2025-09-22',3,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto. El monto restante debe ser aportado por los participantes y al menos, el 5% del costo total del proyecto debe ser pecuniario.','Tener RUT chileno',0,600000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asistencia-digital-fortalece-pyme-valparaiso-1ra-2025/','',2);
CALL CrearInstrumento ('RED DE ASISTENCIA DIGITAL FORTALECE PYME – REGIÓN DEL MAULE – 1° CONVOCATORIA 2025','MA','La Red de Asistencia Digital Fortalece Pyme busca contribuir a que las Pymes aumenten sus ingresos y/o mejoren sus niveles de productividad. Esta convocatoria busca proyectos que contemplen la incorporación de tecnologías digitales en los beneficiarios atendidos de sectores económicos vinculados a agropecuario – silvícola, manufactura, construcción y turismo.','2025-08-19','2025-09-22',3,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto. El monto restante debe ser aportado por los participantes y al menos, el 5% del costo total del proyecto debe ser pecuniario.','Tener RUT chileno',0,600000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asistencia-digital-fortalece-pyme-maule-1ra-2025/','',2);
CALL CrearInstrumento ('PRIMER CONCURSO PDT REGIÓN DE COQUIMBO','CO','El objetivo es contribuir al cierre de brechas de productividad del sector empresarial, de preferencia Pymes, de la región de Coquimbo, a través de la difusión de tecnologías y mejores prácticas innovadoras, con el propósito de fomentar su adopción y potenciar la competitividad de un grupo de empresas de una industria o sector que enfrentan una problemática común.','2025-08-14','2025-09-15',0,'InnovaChile cofinanciará hasta el 70,0% del costo total del proyecto, con un tope de hasta $90.000.000.- CALL CrearInstrumento (noventa millones de pesos). El aporte restante del 30% como mínimo del costo total del proyecto, puede ser pecuniario y valorado.','',0,90000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/primer-concurso-pdt-coquimbo-2025/','',2);
CALL CrearInstrumento ('SEGUNDO CONCURSO PDT VIENTO NORTE','CO','El objetivo es contribuir al cierre de brechas de productividad del sector empresarial, de preferencia Pymes, a través de la difusión de tecnologías y mejores prácticas innovadoras, con el propósito de fomentar su adopción y potenciar la competitividad de un grupo de empresas de una industria o sector que enfrentan una problemática común, fomentando el triple impacto CALL CrearInstrumento (económico, social, medioambiental).','2025-08-14','2025-09-15',1,'InnovaChile cofinanciará hasta el 70,00% del costo total del proyecto, con un tope de hasta $90.000.000. CALL CrearInstrumento (noventa millones de pesos). El aporte restante del 30% como mínimo del costo total del proyecto, puede ser pecuniario y valorado.','Ser persona natural o jurídica',0,90000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/segundo-concurso-pdt-viento-norte-coquimbo-2025/','',2);
CALL CrearInstrumento ('RED DE FOMENTO SOSTENIBLE – CONVOCATORIA 2025, CONSTRUCCIÓN SUSTENTABLE','BI','Queremos que las Pymes puedan aumentar sus ingresos y/o mejoren su productividad, a través del acceso a servicios de extensionismo tecnológico que les permitan adoptar y utilizar tecnologías, mediante el cofinanciamiento de la operación de proyectos \"Red de Fomento Sostenible\" que entregarán servicios en dicho ámbito a Pymes del sector de la construcción.','2025-08-14','2025-09-22',0,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto.','Tener RUT chileno',0,900000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red-fomento-sostenible-construccion-sustentable-2025/','',2);
CALL CrearInstrumento ('RED DE FOMENTO SOSTENIBLE – CONVOCATORIA 2025, PESCA Y ACUICULTURA','AI','Queremos que las Pymes puedan aumentar sus ingresos y/o mejoren su productividad, a través del acceso a servicios de extensionismo tecnológico que les permitan adoptar y utilizar tecnologías, mediante el cofinanciamiento de la operación de proyectos \"Red de Fomento Sostenible\" que entregarán servicios en dicho ámbito a Pymes del sector de la pesca y acuicultura.','2025-08-14','2025-09-22',0,'El cofinanciamiento cubre hasta el 80% del costo total del proyecto.','Tener RUT chileno',0,900000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red-fomento-sostenible-pesca-acuicultura-2025/','',2);
CALL CrearInstrumento ('RED MERCADOS – REGIÓN DE LA ARAUCANÍA – 2° CONVOCATORIA 2025 ETAPA DIAGNÓSTICO','AR','Red Mercados apoya a grupos de empresas a incorporar capacidades y conocimientos para acceder, directa o indirectamente a mercados internacionales.','2025-08-13','2025-09-03',2,'Corfo/Comité de Desarrollo Productivo Regional financiará hasta $4.000.000.- CALL CrearInstrumento (cuatro millones de pesos) de la Etapa de Diagnóstico, por proyecto. El plazo máximo de ejecución será de hasta 2 CALL CrearInstrumento (dos) meses. El plazo podrá ser prorrogado, previa solicitud presentada antes del vencimiento. El plazo total del proyecto CALL CrearInstrumento (incluidas sus prórrogas) no podrá superar los 3 CALL CrearInstrumento (tres) meses.','Tener RUT chileno',0,4000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-mercados-araucania-segunda-convocatoria-diagnostico-2025/','',2);
CALL CrearInstrumento ('DESARROLLA INVERSIÓN PRODUCTIVA –REGIÓN DE COQUIMBO – 2° CONVOCATORIA 2025','CO','El llamado a concurso se focalizará temáticamente, por lo que sólo podrán postular proyectos de inversión productiva con potencial de generación de externalidades positivas, contribución al crecimiento sostenible y la reactivación económica de la Región de Coquimbo, mediante la adquisición de activo fijo, habilitación de infraestructura productiva y/o equipamiento tecnológico en etapas relevantes del proceso productivo.','2025-08-11','2025-09-01',1,'Corfo cofinanciará hasta el 60% del costo total de cada proyecto, con tope de $50.000.000, de acuerdo con el tramo de inversión total del proyecto indicado en la resolución de focalización de esta convocatoria CALL CrearInstrumento (revisar bases). El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,5000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/dip-coquimbo-segunda-convocatoria-2025/','',2);
CALL CrearInstrumento ('DESARROLLA INVERSIÓN PRODUCTIVA –REGIÓN DE COQUIMBO – 3° CONV. 2025, TERRITORIOS VIENTO NORTE','CO','El llamado a concurso se focalizará temáticamente, por lo que sólo podrán postular proyectos de inversión productiva con potencial de generación de externalidades positivas, contribución al crecimiento sostenible y la reactivación económica de las comunas de Vicuña, Andacollo, La Higuera, Río Hurtado, mediante la adquisición de activo fijo, habilitación de infraestructura productiva y/o equipamiento tecnológico en etapas relevantes del proceso productivo.','2025-08-11','2025-09-01',1,'Corfo cofinanciará hasta el 70% del costo total de cada proyecto, con tope de $50.000.000. Se podrá cofinanciar con el subsidio la adquisición de activo fijo, habilitación de infraestructura productiva y capital de trabajo. El porcentaje de capital de trabajo no podrá exceder del 20% del costo total del proyecto individual.','Tener RUT chileno',0,50000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/dip-coquimbo-tercera-convocatoria-territorios-viento-norte-2025/','',2);
CALL CrearInstrumento ('RED ASOCIATIVA – 1° CONV. ZONAL 2025 DESARROLLO SILVOAGROPECUARIO SUSTENTABLE, ETAPA DIAGNÓSTICO','AP','Red Asociativa busca contribuir al aumento de la competitividad de un grupo de al menos 3 empresas, para mejorar su oferta de valor y acceder a nuevos mercados, a través del cofinanciamiento de proyectos asociativos que incorporen mejoras en gestión, productividad, sustentabilidad e innovación.','2025-01-01','2025-12-31',8,'Corfo cofinanciará hasta un 70% del costo total de la Etapa de Diagnóstico, con un tope de $8.000.000, por proyecto. La Etapa de diagnóstico se podrá extender por hasta 6 meses, prorrogable hasta 8 meses.','Tener RUT chileno',0,8000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asociativa-desarrollo-silvoagropecuario-sustentable-diagnostico-2025/','',2);
CALL CrearInstrumento ('RED ASOCIATIVA AGRO+ – 1° CONV. ZONAL 2025 DESARROLLO SILVOAGROPECUARIO SUSTENTABLE','AP','Red Asociativa AGRO+”, fomenta el cooperativismo, a través de: Beneficio: Corfo/Comité de Desarrollo Productivo Regional cofinanciará hasta un 80% del costo total de la Etapa de Diagnóstico, con un tope de $10.000.000.- CALL CrearInstrumento (diez millones de pesos), por proyecto. Finalizada la Etapa de Diagnóstico, el proyecto podrá postular a la Etapa de Desarrollo, cuyo financiamiento será de hasta un 80% del costo total de la Etapa, con un tope para cada periodo de $45.000.000.- CALL CrearInstrumento (cuarenta y cinco millones de pesos) por proyecto.','2025-01-01','2025-12-31',0,'Capacitación, Inversión en infraestructura','Tener RUT chileno, Estar insrito en un programa x',0,45000000,'EVA','CAP','ORG','https://corfo.cl/sites/cpp/convocatoria/red-asociativa-agro-desarrollo-silvoagropecuario-sustentable-diagnostico-2025/','',2);
CALL CrearInstrumento ('RED PROVEEDORES – 1° CONV. ZONAL 2025 DESARROLLO SILVOAGROPECUARIO SUSTENTABLE, ETAPA DESARROLLO','LL','\"Red Proveedores\" permite fortalecer la relación Proveedor—Demandante, promueve el trabajo colaborativo para mejorar la oferta de valor de las empresas y así mejorar la competitividad de la Cadena productiva. El objetivo es desarrollar e implementar un plan de actividades que reduzca brechas de las empresas proveedoras y de la cadena productiva, basadas en el trabajo colaborativo. Corfo cofinanciará hasta un 50% del costo total de la Etapa de Desarrollo, con un tope de $50.000.000, por proyecto. La Etapa de desarrollo se podrá extender por hasta tres años, aprobándose anualmente el proyecto y asignándose su presupuesto.','2025-01-01','2025-12-31',0,'CAP, RIE','Tener RUT chileno, Estar insrito en un programa x',0,50000000,'EVA','CAP, RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-proveedores-desarrollo-silvoagropecuario-sustentable-desarrollo-2025/','',2);
CALL CrearInstrumento ('RED TECNOLÓGICA GTT – 1° CONV. ZONAL 2025 DESARROLLO SILVOAGROPECUARIO SUSTENTABLE','AR','Red Tecnológica GTT+ busca que grupos de entre 10 y 15 empresas puedan, a través del intercambio entre pares y asistencias técnicas, cerrar brechas tecnológicas y de gestión, incorporando herramientas y mejores prácticas productivas, fomentando la construcción de alianzas entre los empresarios, mejorar su productividad y posición competitiva.','2025-01-01','2025-12-31',0,'Corfo otorgará, para la ejecución de la Etapa de Desarrollo un cofinanciamiento de hasta un 80% del costo total de la Etapa con un tope para cada año de ejecución de $2.000.000.- CALL CrearInstrumento (dos millones de pesos), por cada beneficiario que integra el proyecto. La Etapa de desarrollo se podrá extender por hasta tres años, aprobándose anualmente el proyecto y asignándose su presupuesto.','Tener RUT chileno',0,2000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-tecnologica-gtt-desarrollo-silvoagropecuario-sustentable-desarrollo-2025/','',2);
CALL CrearInstrumento ('RED TECNOLÓGICA GTT – 1° CONV. ZONAL 2025 DESARROLLO SILVOAGROPECUARIO SUSTENTABLE','RM','Red Tecnológica GTT+ busca que grupos de entre 10 y 15 empresas puedan, a través del intercambio entre pares y asistencias técnicas, cerrar brechas tecnológicas y de gestión, incorporando herramientas y mejores prácticas productivas, fomentando la construcción de alianzas entre empresas para ampliar el capital relacional, mejorar su productividad y posición competitiva.','2025-01-01','2025-12-31',0,'Corfo financiará hasta $3.500.000 para la Etapa de Diagnóstico, por proyecto.','Tener RUT chileno',0,3500000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-tecnologica-gtt-desarrollo-silvoagropecuario-sustentable-diagnostico-2025/','',2);
CALL CrearInstrumento ('INVIERTE Plataformas de Crowdfunding','','Se busca apoyar la organización, fortalecimiento y operación de las plataformas de financiamiento colectivo de equity a través de la diversificación de la inversión y el aumento de alternativas de acceso a capitales para emprendimientos con potencial de crecimiento y desarrollar negocios innovadores. Además de entregar acceso y alternatiavs para invertir en emprendimientos con potencial de ser dinámicos.','2025-07-30','2025-09-08',0,'Hasta el 70,0% del costo total del proyecto considerando un monto máximo de hasta $50.000.000.','Tener RUT chileno',0,50000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/invierte-plataformas-crowdfunding-2025/','',2);
CALL CrearInstrumento ('INVIERTE Redes de Ángeles','','Se busca apoyar en la organización, fortalecimiento y operación de las Redes, a través de la preparación y fidelización de inversionistas y emprendedores, logrando mayor transferencia de capacidades entre ellos, fomentar la inversión privada y mejorar sus condiciones de éxito y crecimiento.','2025-07-30','2025-09-08',0,'Hasta el 70,00% del costo total del proyecto considerando un monto máximo de hasta $50.000.000.','',0,5000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/invierte-redes-angeles-2025/','',2);
CALL CrearInstrumento ('CREACIÓN DE CENTRO TECNOLÓGICO DE BIOTECNOLOGÍA PARA LA SOSTENIBILIDAD','LR','La convocatoria tiene como objetivo crear y/o fortalecer infraestructura tecnológica y capital humano avanzado mediante la implementación de un Centro Tecnológico de Biotecnología para la Sostenibilidad, en la región de Los Ríos, que permita que empresas y emprendedores desarrollen soluciones sostenibles de alto valor y potencial de mercado con base en biotecnología.','2025-07-28','2025-09-30',3,'Cofinanciamiento: Etapa 1: cofinanciamiento hasta 4.000.000.000.- CALL CrearInstrumento (cuatro mil millones de pesos) con un tope de hasta el 80,00% del costo total de la primera etapa. Los participantes deberán aportar el financiamiento restante, de los cuales al menos 5,00% del costo total de la Etapa deberá ser mediante aportes nuevos o pecuniarios. Etapa 2: cofinanciamiento hasta 3.900.000.000.- CALL CrearInstrumento (tres mil novecientos millones de pesos) con un tope de hasta el 65,00% del costo total de la segunda etapa. Los participantes deberán aportar el financiamiento restante, de los cuales al menos 10,00% del costo total de la Etapa deberá ser mediante aportes nuevos o pecuniarios. Etapa 3: cofinanciamiento hasta 1.800.000.000.- CALL CrearInstrumento (il ochocientos millones de pesos) con un tope de hasta el 35,00% del costo total de la tercera etapa. Los participantes deberán aportar el financiamiento restante, de los cuales al menos 15,00% del costo total de la Etapa deberá ser mediante aportes nuevos o pecuniarios.','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,400000000,'ABI','CRE','EMP','https://corfo.cl/sites/cpp/convocatoria/creacion-centro-tecnologico-biotecnologia-sostenibilidad-los-rios-2025/','',2);
CALL CrearInstrumento ('CREACIÓN DE UN CENTRO TECNOLÓGICO PARA LA ECONOMÍA CIRCULAR','LL','La convocatoria tiene como objetivo principal la creación y puesta en marcha de un \"Centro Tecnológico para la Economía Circular, en la Región de Los Lagos\" que permita crear, habilitar y/o fortalecer infraestructura y equipamiento tecnológico para el desarrollo de soluciones basadas en modelos de economía circular, abordando las brechas y oportunidades que enfrenta la región de Los Lagos, relacionadas con la prevención en generación de residuos, así como también, de estrategias de reparación, remanufactura, reutilización, reciclaje y disposición final de residuos generados por las actividades productivas, con el fin de transitar hacia un modelo de desarrollo económico circular.','2025-07-22','2025-09-30',3,'Cofinanciamiento hasta $9.700.000.000 CALL CrearInstrumento (nueve mil setecientos millones de pesos) en tres etapas.','Tener RUT chileno',0,9700000,'ABI','CRE','ORG','https://corfo.cl/sites/cpp/convocatoria/creacion-centro-tecnologico-economia-circular-los-lagos-2025/','',2);
CALL CrearInstrumento ('Programa de Difusión Tecnológica CDPR Atacama 2025','AT','El objetivo es contribuir al cierre de brechas de productividad del sector empresarial vinculados a la agroindustria, minería, turismo, eficiencia hídrica y energética, de preferencia Pymes, de la región de Atacama, a través de la difusión de tecnologías y mejores prácticas innovadoras, con el propósito de fomentar su adopción y potenciar la competitividad de un grupo de empresas de una industria o sector que enfrentan una problemática común.','2025-01-01','2025-12-31',0,'InnovaChile cofinanciará hasta el 70,00% del costo total del proyecto, con un tope de hasta $90.000.000.- CALL CrearInstrumento (noventa millones de pesos). El aporte restante del 30% como mínimo del costo total del proyecto, puede ser pecuniario y valorado.','Tener RUT chileno',0,90000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/programa-difusion-tecnologica-cdpr-atacama-2025/','',2);
CALL CrearInstrumento ('RED PROVEEDORES – REGIÓN METROPOLITANA – 1° CONVOCATORIA 2025 ETAPA DESARROLLO','RM','Si tienes interés en fortalecer tu cadena productiva, promoviendo el trabajo colaborativo con proveedores actuales o nuevos, fortaleciendo la relación estratégica Proveedores – Demandante, para mejorar la oferta de valor y el acceso a nuevos mercados, te invitamos a postular a Red Proveedores.  El Comité de Desarrollo Productivo Regional cofinanciará hasta un 50% del costo total de la Etapa de Desarrollo, con un tope para cada periodo de $60.000.000.- CALL CrearInstrumento (sesenta millones de pesos), por proyecto, cuando éste sea sustentable.  En caso contrario, Corfo cofinanciará hasta un 40% del costo total de la Etapa de Desarrollo, con un tope para cada periodo de $50.000.000.- CALL CrearInstrumento (cincuenta millones de pesos), por proyecto.','2025-01-01','2025-12-31',0,'Financiamiento: El Comité de Desarrollo Productivo Regional cofinanciará hasta un 50% del costo total de la Etapa de Desarrollo, con un tope para cada periodo de $60.000.000.- CALL CrearInstrumento (sesenta millones de pesos), por proyecto, cuando éste sea sustentable.  En caso contrario, Corfo cofinanciará hasta un 40% del costo total de la Etapa de Desarrollo, con un tope para cada periodo de $50.000.000.- CALL CrearInstrumento (cincuenta millones de pesos), por proyecto.  Un proyecto “RED Proveedores” es sustentable cuando, además de cumplir con los objetivos del programa y línea de apoyo, busca generar impacto en tres ámbitos: Social: busca implementar prácticas que defiendan los valores sociales, la equidad y el cumplimiento irrestricto de leyes vigentes, además del compromiso con el desarrollo de la comunidad que le rodea. Ambiental: Se preocupa de la preservación del medioambiente y del uso eficiente y racional de los recursos naturales. Económico: busca hacer sustentable su iniciativa desde el punto de vista comercial pe','',0,120000000,'EVA','SUB','ORG','https://corfo.cl/sites/cpp/convocatoria/red-proveedores-metropolitana-1ra-convocatoria-desarrollo-2025/','',2);
CALL CrearInstrumento ('Entidades Patrocinadoras para Semilla Inicia y Semilla Expande','','El presente instrumento tiene por objetivo regular la incorporación de determinadas entidades a la “Nómina de Entidades Patrocinadoras para Semilla Inicia” y a la “Nómina de Entidades Patrocinadoras para Semilla Expande”, respectivamente, así como sus obligaciones y el proceso de evaluación periódica de las mismas durante la ejecución de los proyectos.','2025-01-01','2025-12-31',0,'','',0,0,'EVA','OTR','ORG','https://corfo.cl/sites/cpp/convocatoria/entidades_patrocinadoras_para_semilla_inicia_y_semilla_expande/',' ',2);
CALL CrearInstrumento ('Innova Alta Tecnología – Eureka','','Apoyamos innovaciones intensivas en I+D, que enfrenten alta incertidumbre tecnológica y que apunten a escalamientos de alto potencial de comercialización nacional o global, fortaleciendo las capacidades de I+D+i en las empresas.','2025-01-01','2025-12-31',0,'InnovaChile cofinanciará los proyectos que resulten adjudicados con un tope de hasta $1.000.000.000.- CALL CrearInstrumento (mil millones de pesos). El porcentaje de cofinanciamiento dependerá de los ingresos anuales por ventas del beneficiario: Empresa Micro y pequeña CALL CrearInstrumento (ventas por hasta 25.000 UF anual): hasta 70%. Empresa Mediana CALL CrearInstrumento (ventas por sobre 25.000 UF y hasta 100.000 UF anual) hasta 55%. Empresa Grande CALL CrearInstrumento (ventas por sobre 100.000 UF anual) hasta 40%. Aumento de hasta un 10 % más de cofinanciamiento para ‘Empresas lideradas por mujeres’. Beneficio para PYMES que cuenten con el ‘Sello 40 horas’','',0,1000000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/innova_alta_tecnologia_eureka/','',2);
CALL CrearInstrumento ('Programa de Prospección Tecnológica vinculación internacional','','Apoya actividades asociativas de prospección tecnológica, de conocimiento y de mejores prácticas no disponibles a nivel nacional, y su adecuación y transferencia al contexto nacional, que contribuyan a la creación de valor y fortalecimiento de las capacidades de innovación en las empresas.','2025-01-01','2025-12-31',0,'Se cofinanciará hasta el 60,0% del costo total del proyecto, con un tope de hasta $25.000.000.- CALL CrearInstrumento (veinticinco millones de pesos). Aumento del porcentaje de cofinanciamiento para proyectos con 30% o más de beneficiarios atendidos que correspondan a \"empresas lideradas por mujeres\". Beneficio para PYMES que cuenten con el \"Sello 40 horas\".','',0,25000000,'EVA','OTR','EMP','https://corfo.cl/sites/cpp/convocatoria/programa_de_prospeccion_tecnologica_vinculacion_internacional/','',2);
CALL CrearInstrumento ('PAR – REGIÓN DE O’HIGGINS – GESTIÓN EFICIENTE DE RECURSOS HÍDRICOS 2024','LI','Queremos potenciar a un grupo entre 5 y 15 empresas y/o emprendedores de una localidad o sector económico determinado, para que mejoren su competencia productiva y gestión, desarrollando planes de asistencia técnica, capacitación y cofinanciando la inversión productiva.','2024-02-05','2025-12-01',10,'Hasta $2.000.000 CALL CrearInstrumento (dos millones de pesos) para actividades de asistencia técnica, capacitación y consultoría. Hasta 80% del costo total del proyecto para Proyecto de Inversión, con tope de hasta $5.000.000 CALL CrearInstrumento (cinco millones de pesos).','Un contribuyente o un emprendedor podrá beneficiarse de este instrumento sólo en una oportunidad.',0,5000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/par_ohiggins_gestion_eficiente_recursos_hidricos/','',2);
CALL CrearInstrumento ('FOCAL – REGIÓN DE O’HIGGINS – INDIVIDUAL AVANCE 2023','LI','Subsidio que busca contribuir a la diversificación productiva de la Región de O’Higgins, a través de generar condiciones para potenciar el desarrollo de proveedores de servicios a la minería, mediante el fortalecimiento del Capital humano, el fomento de nuevos emprendimientos e incentivo a la innovación tecnológica minera.','2023-10-25','2025-12-30',2,'Cofinanciamiento para la implementación de un documento normativo, con tope de hasta $3.500.000 CALL CrearInstrumento (tres millones quinientos mil pesos). El cofinanciamiento cubre hasta el 70% del costo total del proyecto. El porcentaje restante debe ser cubierto por el beneficiario con aportes pecuniarios.','Tener RUT chileno',0,3500000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/focal_ohiggins_individual_avance-2/','',2);
CALL CrearInstrumento ('FOCAL – REGIÓN DE O’HIGGINS – INDIVIDUAL REEMBOLSO 2023','LI','Subsidio que busca contribuir a la diversificación productiva de la Región de O’Higgins, a través de generar condiciones para potenciar el desarrollo de proveedores de servicios a la minería, mediante el fortalecimiento del Capital humano, el fomento de nuevos emprendimientos e incentivo a la innovación tecnológica minera.','2023-10-25','2025-12-30',0,'Cofinanciamiento para la implementación de un documento normativo, con tope de hasta $3.500.000 CALL CrearInstrumento (tres millones quinientos mil pesos). El cofinanciamiento cubre hasta el 70% del costo total del proyecto. El porcentaje restante debe ser cubierto por el beneficiario con aportes pecuniarios.','Tener RUT chileno',0,3500000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/focal_ohiggins_individual_reembolso-2/','',2);
CALL CrearInstrumento ('RED ASOCIATIVA – REGIÓN DE O’HIGGINS – ETAPA DE DIAGNÓSTICO Y DESARROLLO 2023','LI','Si tienes interés en participar junto a otras Empresas para mejorar tu oferta de valor y acceder a nuevos mercados, a través del Programa RED Asociativa te apoyamos con asesoría experta para abordar oportunidades de mercado y de mejoramiento tecnológico, desarrollando estrategias de negocios colaborativos, de acuerdo a las características productivas del grupo de empresas.','2023-06-30','2025-12-30',2,'Se financiará hasta el 70% del costo total de la Etapa de Diagnóstico y Desarrollo. Hasta el 70% del costo total de la Etapa de Diagnóstico, con un tope de $8.000.000 CALL CrearInstrumento (ocho millones de pesos) por proyecto.','Tener RUT chileno',0,8000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red_asociativa_ohiggins_diagdesa-2/','',2);
CALL CrearInstrumento ('RED ASOCIATIVA – REGIÓN DE O’HIGGINS – ETAPA DE DIAGNÓSTICO Y DESARROLLO 2023','LI','Si tienes interés en participar junto a otras Empresas para mejorar tu oferta de valor y acceder a nuevos mercados, a través del Programa RED Asociativa te apoyamos con asesoría experta para abordar oportunidades de mercado y de mejoramiento tecnológico, desarrollando estrategias de negocios colaborativos, de acuerdo a las características productivas del grupo de empresas.','2023-06-30','2025-12-30',2,'Se financiará hasta el 70% del costo total de la Etapa de Diagnóstico y Desarrollo. Hasta el 70% del costo total de la Etapa de Diagnóstico, con un tope de $8.000.000 CALL CrearInstrumento (ocho millones de pesos) por proyecto.','Tener RUT chileno',0,8000000,'ABI','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red_asociativa_ohiggins_diagdesa/','',2);
CALL CrearInstrumento ('RED MERCADOS – REGIÓN DE O’HIGGINS – ETAPA DE DIAGNÓSTICO Y DESARROLLO 2023','LI','Buscamos apoyar a grupos de empresas a incorporar las capacidades y conocimientos necesarios para acceder, directa o indirectamente a mercados internacionales.','2023-06-30','2025-12-30',2,'Para la Etapa de Diagnostico cofinanciara hasta $4.000.000.- CALL CrearInstrumento (cuatro millones de pesos), por proyecto. Para la Etapa de Desarrollo, Corfo cofinanciará hasta un 90% del costo total de ésta, con un tope de $40.000.000 CALL CrearInstrumento (cuarenta millones de pesos), por proyecto.','',0,4000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red_mercados_ohiggins_diagndesar/','',2);
CALL CrearInstrumento ('RED PROVEEDORES – REGIÓN DE O’HIGGINS – ETAPA DE DIAGNÓSTICO Y DESARROLLO 2023','LI','Buscamos fortalecer la relación Proveedor – Demandante, promueve el trabajo colaborativo para mejorar la oferta de valor de las empresas y así aumentar la competitividad de la cadena productiva.','2023-06-30','2025-12-30',24,'Etapa Diagnostico: Corfo cofinanciará hasta un 50% del costo total de la Etapa de Diagnóstico, con un tope de $10.000.000, por proyecto. Etapa Desarrollo: Corfo cofinanciará hasta un 40% del costo total de la Etapa de Desarrollo, con tope $50.000.000 CALL CrearInstrumento (cincuenta millones) para cada año de ejecución, por proyecto.','Tener RUT chileno',0,50000000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red_proveedores_ohiggins_diagndesarrollo/','',2);
CALL CrearInstrumento ('RED TECNOLÓGICA GTT – REGIÓN DE O’HIGGINS – ETAPA DE DIAGNÓSTICO Y DESARROLLO 2023','LI','Buscamos empresas con interés en participar junto a otras, para aumentar tu competitividad a través del Programa RED GTT para abordar brechas en ámbitos tecnológicos y de gestión, desarrollando actividades de construcción de capital social de Pymes silvoagropecuarias, a través de la organización y el trabajo en grupo de los productores, de acuerdo con las características productivas del grupo de empresas. Convocatoria abierta para la Región de O’Higgins.','2023-06-30','2025-12-30',2,'Se financiará hasta $3.500.000.- CALL CrearInstrumento (tres millones quinientos mil pesos) de la Etapa de Diagnóstico, por proyecto. El cofinanciamiento cubre hasta un 80% del costo total de la Etapa de Desarrollo.','Tener RUT chileno',0,3500000,'ABI','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/red_tecnologica_gtt_oh_diag_desar/','',2);
CALL CrearInstrumento ('Garantía PRO-INVERSIÓN','','ES UN MECANISMO DE APOYO para acceder a Financiamiento para micro, pequeña, mediana y grandes empresas CALL CrearInstrumento (venta anual hasta UF600.000). Corfo facilita el acceso a crédito, mediante el otorgamiento de coberturas a instituciones financieras, que en su proceso de evaluación y otorgamiento de créditos requieren garantías del deudor para cursar los financiamientos, fomentando de esta forma la realización de proyectos de inversión y/o adquisición de activos fijos.','2025-01-01','2025-12-31',0,'Corfo otorga coberturas a las instituciones financieras CALL CrearInstrumento (Bancos, Cooperativas y Servicios Financieros) con el fin de facilitar el acceso a crédito, mediante el otorgamiento de coberturas a instituciones financieras, que en su proceso de evaluación y otorgamiento de créditos requieren garantías del deudor para cursar los financiamientos, fomentando de esta forma la realización de proyectos de inversión y/o adquisición de activos fijos. Corfo otorga coberturas a las instituciones financieras CALL CrearInstrumento (Bancos, Cooperativas y Servicios Financieros) con el fin de facilitar el acceso a crédito, mediante el otorgamiento de coberturas a instituciones financieras, que en su proceso de evaluación y otorgamiento de créditos requieren garantías del deudor para cursar los financiamientos, fomentando de esta forma la realización de proyectos de inversión y/o adquisición de activos fijos. Corfo otorga coberturas a las instituciones financieras CALL CrearInstrumento (Bancos, Cooperativas y Servicios Financieros) con el fin de facil','Tener RUT chileno',0,100000,'EVA','GAR','EMP','https://corfo.cl/sites/cpp/convocatoria/garantia_pro_inversion/','',2);
CALL CrearInstrumento ('Becas Capital Humano','','El fondo Becas Capital Humano de CORFO busca apoyar a emprendedores y empresas innovadoras que desarrollen proyectos de alto impacto en Chile.  El objetivo es fomentar la creación de nuevas empresas y el desarrollo de proyectos que generen empleo de calidad y contribuyan al desarrollo económico del país.  Se busca apoyar proyectos en diversas áreas, como tecnología, innovación social, energías renovables y turismo sostenible.  CORFO ofrece financiamiento para cubrir costos de capacitación, asesoría técnica, inversión en infraestructura y otros incentivos para apoyar el desarrollo de proyectos innovadores.','2025-01-01','2025-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura, Otros incentivos','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x',0,0,'EVA','RIE','EMP','https://www.corfo.cl/sites/becascapitalhumano/home',' ',2);
CALL CrearInstrumento ('convocatoria de prueba','','Esta convocatoria de prueba tiene como objetivo evaluar el proceso de extracción de información de fondos concursables. Se busca obtener datos clave como el titular, el financiamiento, el alcance geográfico, la descripción, los beneficios, los requisitos, los montos mínimos y máximos, y el estado del fondo.  Además, se requiere identificar el tipo de beneficio, el tipo de perfil, el enlace al detalle y el enlace a la foto.  La información extraída se utilizará para mejorar la eficiencia del sistema de procesamiento de convocatorias.','2025-01-01','2025-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,0,'EVA','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/convocatoria-de-prueba/','',2);
CALL CrearInstrumento ('Crea y Valida-Eureka','','Es un apoyo que cofinancia proyectos colaborativos de I+D+i para empresas chilenas que trabajen en el desarrollo de nuevos o mejorados productos CALL CrearInstrumento (bienes o servicios) y/o procesos, que requieran I+D, desde la fase de prototipo y hasta la fase de validación técnica a escala productiva y/o validación comercial con empresas de países miembros de la Red Eureka, estimulando el intercambio tecnológico y la cooperación internacional en I+D+i entre empresas chilenas y las entidades de los países participantes de la Red Eureka.','2025-01-01','2025-12-31',0,'InnovaChile cofinanciará los proyectos con un tope de hasta $220.000.000.- CALL CrearInstrumento (doscientos veinte millones de pesos). Se financiará un porcentaje del costo total del proyecto, dependiendo del tamaño del beneficiario: Empresa Micro y pequeña CALL CrearInstrumento (ventas por hasta 25.000 UF anual): hasta 80% Empresa Mediana CALL CrearInstrumento (ventas por sobre 25.000 UF y hasta 100.000 UF anual) hasta 60% Empresa Grande CALL CrearInstrumento (ventas por sobre 100.000 UF anual) hasta 40% Aumento de hasta un 10 % más de cofinanciamiento para \"Empresas lideradas por mujeres\". Beneficio para PYMES que cuenten con el \"Sello 40 horas\".','',0,220000000,'EVA','OTR','EMP','https://corfo.cl/sites/cpp/convocatoria/crea_valida_eureka/','',2);
CALL CrearInstrumento ('Crédito Corfo MiPyme','','Es un programa de financiamiento que busca ampliar y/o mejorar la oferta de financiamiento para las Micro, Pequeñas y Medianas Empresas CALL CrearInstrumento (MIPYMES). Lo anterior, a través de Intermediarios Financieros No Bancarios CALL CrearInstrumento (IFNB), que otorguen operaciones de Crédito, Leasing y/o Factoring para capital de trabajo y/o inversión.','2025-01-01','2025-12-31',0,'Corfo otorga un refinanciamiento mediante préstamos a las instituciones financieras no bancarias CALL CrearInstrumento (Cooperativas y Servicios Financieros) mediante operaciones de crédito y leasing de hasta 10 años plazo, y operaciones de factoring. Este programa NO brinda financiamiento directo a la empresa, sino que proporciona recursos para que las instituciones financieras no bancarias otorguen operaciones de créditos, factoring u leasing a empresas beneficiarias que cumplan con los criterios de elegibilidad.','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,1000000,'EVA','CRE','EMP','https://corfo.cl/sites/cpp/convocatoria/credito_mipyme/','',2);
CALL CrearInstrumento ('Crédito Verde','','Programa de financiamiento, a través de instituciones financieras participantes, para potenciar el desarrollo y ejecución de proyectos que mitiguen los efectos del cambio climático y/o mejoren la sustentabilidad ambiental de las empresas, reimpulsando la inversión en iniciativas de: Generación y almacenamiento de energía renovables no convencionales CALL CrearInstrumento (ERNC), incluyendo proyectos para autoabastecimiento. Eficiencia energética CALL CrearInstrumento (EE) relacionados con la optimización del uso energético y la reducción de sus costos asociados al uso de la energía; Medidas de mejora medio ambiental en los procesos productivos, incluidos los proyectos de economía circular que incorporan, entre otros, el ecodiseño, la reutilización, reciclaje y valorización. Desarrollo de la Industria de Hidrógeno Verde. Proyectos de partes y piezas y bienes finales de Crédito Verde, relacionado a la inversión en plantas de fabricación y ensamblaje de componentes y bienes finales.','2025-01-01','2025-12-31',0,'CAP, RIE','Tener RUT chileno',0,30000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/credito_verde/','',2);
CALL CrearInstrumento ('Fondo de Desarrollo Crecimiento','','Este fondo busca apoyar a administradoras de capital de riesgo que desarrollen proyectos de alto impacto en el sector de la innovación. Se enfoca en el crecimiento de empresas con potencial de expansión, promoviendo la creación de empleo y el desarrollo de nuevas tecnologías. El objetivo es fortalecer el ecosistema de innovación en Chile, impulsando el emprendimiento y la competitividad de las empresas.','2025-01-01','2025-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura, Capital de riesgo','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x',0,0,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/fondo_de_desarrollo_crecimiento_perfil_administradoras/',' ',2);
CALL CrearInstrumento ('Fondo de Desarrollo Crecimiento - Perfil Empresa','','Este fondo busca apoyar a empresas en etapa de crecimiento, promoviendo la innovación y el desarrollo de nuevos productos y servicios. Se enfoca en el fortalecimiento de la competitividad de las empresas chilenas, impulsando la creación de empleo y el desarrollo económico.','2025-01-01','2025-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura.','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x.',0,0,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/fondo_de_desarrollo_crecimiento_perfil_empresa/',' ',2);
CALL CrearInstrumento ('Fondo Etapas Tempranas Administradoras','','Este fondo está destinado a apoyar a administradoras de fondos de etapa temprana, buscando fortalecer sus capacidades y acelerar el desarrollo de sus proyectos. El objetivo es fomentar la innovación y el emprendimiento en Chile, promoviendo la creación de nuevas empresas y la generación de empleo.','2023-03-08','2023-05-09',3,'Capacitación, Asesoría técnica, Inversión en infraestructura, Financiamiento de capital semilla.','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x, Cumplir con los requisitos de la convocatoria.',0,0,'CER','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/fondo_etapas_tempranas_perfil_administradoras/','',2);
CALL CrearInstrumento ('Fondo Etapas Tempranas Tecnológicas','','El Fondo Etapas Tempranas Tecnológicas busca apoyar a emprendedores y startups en etapa inicial, que desarrollen proyectos innovadores en diversas áreas tecnológicas.  El objetivo es fomentar la creación de nuevas empresas y el desarrollo de soluciones tecnológicas que generen impacto económico y social.  Se priorizarán proyectos con alto potencial de crecimiento y escalabilidad.  El fondo ofrece financiamiento para la validación de ideas, el desarrollo de prototipos y la creación de empresas.','2025-01-01','2025-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x',0,0,'EVA','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/fondo_etapas_tempranas_tecnologicas_perfil_administradoras/','',2);
CALL CrearInstrumento ('Garantía COBEX','','ES UN MECANISMO DE APOYO para acceder a Financiamiento para la micro, pequeña, mediana y grandes empresas relacionadas directa o indirectamente con el comercio exterior CALL CrearInstrumento (venta anual hasta UF600.000). Corfo facilita el acceso a crédito, mediante el otorgamiento de coberturas a instituciones financieras, que en su proceso de evaluación y otorgamiento de créditos requieren garantías del deudor para cursar los financiamientos para inversión y capital de trabajo, incluidas las operaciones destinadas a mitigar el riesgo de tipo de cambio, fomentando de esta forma el comercio exterior.','2025-01-01','2025-12-31',0,'Corfo otorga coberturas a las instituciones financieras CALL CrearInstrumento (Banco, Cooperativa y Servicios Financieros) con el fin de facilitar el acceso a crédito, mediante el otorgamiento de coberturas a instituciones financieras, que en su proceso de evaluación y otorgamiento de créditos requieren garantías del deudor para cursar los financiamientos para inversión y capital de trabajo, incluidas las operaciones destinadas a mitigar el riesgo de tipo de cambio, fomentando de esta forma el comercio exterior. Las operaciones de financiamiento posibles de acoger a la garantía son; Créditos en cuotas, Carta de crédito de Importación, Forward de moneda, Préstamos anticipado exportador CALL CrearInstrumento (PAE), Carta de crédito Stand By, Línea de crédito de boleta de garantías Bancarias y Proyectos de Inversión en tierras indígenas. Los financiamientos pueden ser en pesos, UF, dólares y euros. El plazo de las operaciones debe ser superior a 30 días.','Tener RUT chileno',0,35000,'EVA','GAR','EMP','https://corfo.cl/sites/cpp/convocatoria/cobex/','',2);
CALL CrearInstrumento ('ESCALA PRO-INVERSIÓN','','ES UN MECANISMO DE APOYO para acceder a Financiamiento para Empresas con planes de crecimiento, aceleración y/o con soluciones innovadoras que hayan sido previamente beneficiarias de un instrumento de las Gerencias de Emprendimiento, Redes y Territorio, Capacidades Tecnológicas o Innova de Corfo; y cuenten con una carta de recomendación entregada por la respectiva gerencia o comité. El beneficio consiste en los siguiente: Cobertura especial del 80% del financiamiento, con un tope máximo de UF 100.000 por empresa beneficiaria, sin importar su nivel de venta o tipo de operación de crédito, siempre que exista margen de cobertura disponible. El plazo de las operaciones podrá ser inferior a 36 meses y se permite destinar el 100% a capital de trabajo. Si el plazo es superior a 36 meses, se aplica la norma general que permite incorporar Capital de trabajo asociado a la inversión, con un tope máximo del 30% del monto del financiamiento.','2025-01-01','2025-12-31',0,'Cobertura especial del 80% del financiamiento, con un tope máximo de UF 100.000 por empresa beneficiaria, sin importar su nivel de venta o tipo de operación de crédito, siempre que exista margen de cobertura disponible. El plazo de las operaciones podrá ser inferior a 36 meses y se permite destinar el 100% a capital de trabajo. Si el plazo es superior a 36 meses, se aplica la norma general que permite incorporar Capital de trabajo asociado a la inversión, con un tope máximo del 30% del monto del financiamiento.','',0,0,'EVA','GAR','EMP','https://corfo.cl/sites/cpp/convocatoria/escala_pro_inversion/','',2);
CALL CrearInstrumento ('Garantía FOGAIN','','ES UN MECANISMO DE APOYO para acceder a CREDITOS para micro, pequeñas y medianas empresas. Corfo facilita el acceso a crédito mediante el otorgamiento de coberturas a instituciones financieras, que en su proceso de evaluación y otorgamiento de créditos requieren garantías del deudor para cursar los financiamientos. Este programa NO brinda financiamiento directo a la empresa, sino que proporciona un porcentaje de garantía que las entidades financieras solicitarán al momento de pedir un crédito. Las operaciones de financiamiento posibles de acoger a la garantía son créditos, leasing, leaseback, factoring, boleta de garantía, o línea de sobre giro; los financiamientos pueden ser en pesos, UF, dólares y euros.','2025-01-01','2025-12-31',0,'Corfo otorga coberturas a las instituciones financieras CALL CrearInstrumento (Banco, Cooperativa y Servicios Financieros) con el fin de facilitar el acceso a créditos de las empresas. El beneficio tiene los siguientes montos máximos de garantía por tamaño de empresas: Microempresas: hasta UF 5.000, Pequeñas empresas: hasta UF 7.000, Medianas empresas: hasta UF 9.000.','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,0,'EVA','CRE','EMP','https://corfo.cl/sites/cpp/convocatoria/fogain/','',2);
CALL CrearInstrumento ('Garantía FOGAIN MUJER','','ES UN MECANISMO DE APOYO para acceder a FINANCIAMIENTO para micro y pequeña empresa lideradas por mujeres, de todo Chile, con necesidades de capital de trabajo, inversión y/o refinanciamiento. Para ello, Corfo otorga una garantía parcial a los créditos otorgados por Instituciones Financieras Bancarias y No Bancarias, compensando parcialmente sus pérdidas en caso de que estas empresas beneficiarias no cumplan con el pago de sus créditos.','2025-01-01','2025-12-31',0,'Corfo otorga coberturas a las instituciones financieras CALL CrearInstrumento (Banco, Cooperativa y Servicios Financieros) con el fin de facilitar el acceso a créditos de las empresas. Este programa NO brinda financiamiento directo a la empresa, sino que proporciona un porcentaje de garantía que las entidades financieras solicitarán al momento de pedir el financiamiento. Otorga una cobertura especial de hasta 90% del financiamiento, a empresas lideradas por mujeres. Los financiamientos posibles de acoger a la garantía son; créditos, leasing, leaseback, factoring, boleta de garantía, o línea de sobre giro; los financiamientos pueden ser en pesos, UF, dólares y euros.','Tener RUT chileno',0,0,'EVA','GAR','PER','https://corfo.cl/sites/cpp/convocatoria/fogain_mujer/','',2);
CALL CrearInstrumento ('Growth & Scale: Financiamiento Mercados Alternativos','','Dirigida a startups o scaleups interesadas en ingresar a ScaleX, el nuevo mercado alternativo de la Bolsa de Santiago. Los fondos podrán ser utilizados para cubrir parte de los gastos conducentes a la inscripción de ScaleX, tales como la realización de due diligence integral de la startup o para sufragar los derechos de cotización y comisiones definidas por la bolsa.','2025-01-01','2025-12-31',0,'El subsidio pretende costear parte de los gastos conducentes a la inscripción en ScaleX, tales como la realización del due diligence integral de la startup, o para sufragar los derechos de cotización y comisiones definidas por la Bolsa. El aporte otorgado corresponderá hasta un 50% del gasto incurrido en el enlistamiento en ScaleX, con un tope de hasta $75.000.000 de pesos.','',0,75000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/growth_scale_financiamiento_mercados_alternativos/','',2);
CALL CrearInstrumento ('Innova Región Atacama 2025','AT','Apoyamos el desarrollo de nuevos o mejorados productos CALL CrearInstrumento (bienes o servicios) y/o procesos desde la fase de prototipo, hasta la fase de validación técnica a escala productiva y/o validación comercial, que aporten a la economía regional y fortalezcan las capacidades de innovación en la empresa en los ámbitos minería, agroindustria, eficiencia hídrica y energética.','2025-01-01','2025-12-31',0,'Se cofinanciará los proyectos con un tope de hasta $60.000.000.- CALL CrearInstrumento (sesenta millones de pesos). Se financiará un porcentaje del costo total del proyecto, dependiendo de los ingresos por ventas del beneficiario: Empresa Micro y pequeña CALL CrearInstrumento (ventas por hasta 25.000 UF anual): hasta 80% Empresa Mediana CALL CrearInstrumento (ventas por sobre 25.000 UF y hasta 100.000 UF anual) hasta 60% Empresa Grande CALL CrearInstrumento (ventas por sobre 100.000 UF anual) hasta 40% Aumento de hasta un 10 % más de cofinanciamiento para \"Empresas lideradas por mujeres\".','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,60000000,'EVA','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/innova-region-atacama-2025/','',2);
CALL CrearInstrumento ('Incentivo Tributario para la Innovación de las Regiones','','Este incentivo busca apoyar a las empresas de las regiones de Arica y Parinacota, Tarapacá, Antofagasta, Atacama, Coquimbo, Valparaíso, Santiago, O’Higgins, Maule, Ñuble, Biobío, La Araucanía, Los Ríos, Los Lagos, Aysén, Magallanes y Nacional, que desarrollen proyectos de innovación.  El objetivo es fomentar la creación de empresas innovadoras, la generación de empleo de alta calidad y el desarrollo de nuevas tecnologías.  Se busca impulsar la competitividad de las empresas chilenas y su capacidad de generar valor agregado.  El incentivo se enfoca en proyectos que contribuyan al desarrollo económico y social de las regiones.','2024-01-01','2024-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura, Incentivo tributario.','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x, Cumplir con los requisitos de innovación establecidos.',0,0,'CER','RIE','EMP','https://corfo.cl/sites/cpp/incentivo_tributario/','',2);
CALL CrearInstrumento ('PAR GESTIÓN EFICIENTE DE RECURSOS HÍDRICOS – REGIÓN DE O’HIGGINS 2022','LI','Subsidio que busca mejorar el potencial productivo y fortalecer la gestión de las empresas y/o emprendedores de un territorio, apoyando proyectos vinculados a la sustentabilidad medioambiental, que incorporen la gestión eficiente de recursos hídricos, fomentando el desarrollo de sus competencias y capacidades y cofinanciando proyectos de inversión, que les permitan acceder a nuevas oportunidades de negocio y/o mantener las existentes.','2022-01-01','2022-12-31',12,'Hasta $2.000.000 CALL CrearInstrumento (dos millones de pesos) para actividades de asistencia técnica, capacitación y consultoría. Hasta 80% del costo total del proyecto para Proyecto de Inversión, con tope de hasta $5.000.000 CALL CrearInstrumento (cinco millones de pesos).','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,5000000,'CER','SUB','EMP','https://corfo.cl/sites/cpp/convocatoria/par_gestion_eficiente_de_recursos_hidricos_ohiggins/','',2);
CALL CrearInstrumento ('PAR MULTISECTORIAL IDENTIDAD REGIONAL Y PATRIMONIAL – REGIÓN DE O’HIGGINS – AÑO 2023','LI','Queremos potenciar a un grupo entre 5 y 15 empresas y/o emprendedores de una localidad o sector económico determinado, para que mejoren su competencia productiva y gestión, desarrollando planes de asistencia técnica, capacitación y cofinanciando la inversión productiva.','2023-01-01','2023-12-31',12,'Hasta $2.000.000 CALL CrearInstrumento (dos millones de pesos) para actividades de asistencia técnica, capacitación y consultoría. Hasta 80% del costo total del proyecto para Proyecto de Inversión, con tope de hasta $5.000.000 CALL CrearInstrumento (cinco millones de pesos).','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,5000000,'CER','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/par_multisectorial_identidad_regional_y_patrimonial_oh/','',2);
CALL CrearInstrumento ('PAR MULTISECTORIAL INCLUSION – REGION DE O’HIGGINS – AÑO 2023','LI','Queremos potenciar a un grupo entre 5 y 15 empresas y/o emprendedores de una localidad o sector económico determinado, para que mejoren su competencia productiva y gestión, desarrollando planes de asistencia técnica, capacitación y cofinanciando la inversión productiva.','2023-01-01','2023-12-31',0,'Hasta $2.000.000 CALL CrearInstrumento (dos millones de pesos) para actividades de asistencia técnica, capacitación y consultoría. Hasta 80% del costo total del proyecto para Proyecto de Inversión, con tope de hasta $5.000.000 CALL CrearInstrumento (cinco millones de pesos).','Tener RUT chileno',0,5000000,'CER','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/par_multisectorial_inclusion_oh/','',2);
CALL CrearInstrumento ('Fondos de Garantía a Instituciones de Garantía Reciproca','','CORFO abre convocatoria para Fondos de Garantía a Instituciones de Garantía Reciproca. El objetivo es apoyar a instituciones de garantía que otorguen créditos a empresas y personas naturales o jurídicas, promoviendo el desarrollo económico y la generación de empleo en Chile. Se busca fomentar la innovación y el emprendimiento, así como el fortalecimiento de las capacidades de las instituciones de garantía.','2025-01-01','2025-12-31',0,'Capacitación, Asesoría técnica, Inversión en infraestructura, Financiamiento de proyectos innovadores.','Tener RUT chileno, Ser persona natural o jurídica, Estar inscrito en un programa x, Cumplir con los requisitos establecidos en el reglamento.',0,0,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/fondos_de_garantia_a_instituciones_de_garantia_reciproca/',' ',2);
CALL CrearInstrumento ('RED ASOCIATIVA – REGIÓN METROPOLITANA – 1° CONVOCATORIA 2025 ETAPA DESARROLLO','RM','El Programa Red Asociativa permite participar junto a otras Empresas para mejorar tu oferta de valor y acceder a nuevos mercados, a través del Programa RED Asociativa te apoyamos con asesoría experta para abordar oportunidades de mercado y de mejoramiento tecnológico, desarrollando estrategias de negocios colaborativos, de acuerdo con las características productivas del grupo de empresas.','2025-01-01','2025-12-31',0,'Corfo cofinanciará hasta un 70% del costo total de la Etapa de Desarrollo, con un tope de $40.000.000, por proyecto.','Tener RUT chileno',0,40000000,'EVA','RIE','EMP','https://corfo.cl/sites/cpp/convocatoria/red-asociativa-metropolitana-1ra-convocatoria-desarrollo-2025/','',2);
CALL CrearInstrumento ('Red Tecnológica GTT+','RM','Si tienes interés en participar junto a otras empresas del sector silvoagropecuario en un proyecto GTT, los invitamos a postular al programa GTT+. Esta línea de apoyo busca que grupos de entre 10 y 15 empresas puedan, a través del intercambio entre pares y asistencias técnicas, cerrar brechas tecnológicas y de gestión, incorporando herramientas y mejores prácticas productivas, fomentando la construcción de alianzas entre los empresarios para ampliar el capital relacional, mejorar su productividad y posición competitiva.','2025-01-01','2025-12-31',0,'Cofinanciamiento: Hasta $3.500.000.- CALL CrearInstrumento (tres millones quinientos mil pesos), para la Etapa de Diagnóstico.- En la Etapa de Diagnóstico se otorgará un financiamiento de hasta $3.500.000.- CALL CrearInstrumento (tres millones quinientos mil pesos), por proyecto. Corfo cofinanciará hasta un 80% del costo total de la Etapa de Desarrollo, con un tope para cada periodo de $2.000.000.- CALL CrearInstrumento (dos millones de pesos), por cada beneficiario que integra el proyecto.','',0,3500000,'EVA','CAP','EMP','https://corfo.cl/sites/cpp/convocatoria/gtt/','',2);
CALL CrearInstrumento ('Solicitud previa de aprobación de proyectos de I+D – artículo 41 G LIR','','Procedimiento para solicitar a Corfo, en el marco del régimen ProPyme de la letra D del artículo 14 de la LIR, la certificación previa de acuerdos que se celebren para el financiamiento mediante la participación en Pymes, con la finalidad de apoyar puesta en marcha, desarrollo o crecimiento de emprendimientos o de proyectos de innovación tecnológica. En mérito de dicha certificación, no se entenderán entidades relacionadas con la Pyme, aquellas que participen en ella con ese fin y, por lo tanto, no se consideran para el cálculo de los ingresos brutos de la Pyme.','2025-01-01','2025-12-31',0,'','',0,0,'EVA','OTR','EMP','https://corfo.cl/sites/cpp/convocatoria/solicitud_aprobacion_proyectos_excepcion_rentas_pasivas/','',2);
CALL CrearInstrumento ('Solicitud previa de certificación de acuerdos – artículo 14 LIR','','Procedimiento para solicitar a Corfo, en el marco del régimen ProPyme de la letra D del artículo 14 de la LIR, la certificación previa de acuerdos que se celebren para el financiamiento mediante la participación en Pymes, con la finalidad de apoyar puesta en marcha, desarrollo o crecimiento de emprendimientos o de proyectos de innovación tecnológica. En mérito de dicha certificación, no se entenderán entidades relacionadas con la Pyme, aquellas que participen en ella con ese fin y, por lo tanto, no se consideran para el cálculo de los ingresos brutos de la Pyme.','2025-01-01','2025-12-31',0,'','',0,0,'EVA','OTR','PER','https://corfo.cl/sites/cpp/convocatoria/certificacion_acuerdo_financiamiento_participacion_pyme/','',2);
CALL CrearInstrumento ('PAMMA Asistencia Técnica 2025','TA','Este instrumento entregará asistencia técnica a las y los productores de la pequeña minería de las regiones de Antofagasta, Atacama y Coquimbo. Este servicio será entregado por la Universidad de Atacama, incluyendo dos líneas de trabajo especificas: Regularización ante Sernageomin y Asesoría técnica productiva.','2025-08-13','2025-09-01',1,'Capacitación, Asesoría técnica','Tener RUT chileno, Ser persona natural o jurídica',0,0,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/minmineria/pamma-at-2025/','',3);
CALL CrearInstrumento ('Proyectos Culturales y Deportivos','AT','Este Fondo, a través de las Bases Generales, regula el proceso de concursabilidad y de asignación de recursos para subvencionar las actividades mencionadas en la Glosa 07 de la Ley N°21.722 del Sector Público año 2025, para que postulen instituciones privadas sin fines de lucro a proyectos cultureles y deportivos con actividades de vinculación con la comunidad Atacameña.','2025-08-19','2025-09-01',0,'Capacitación','Tener RUT chileno',0,4000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/goreatacama/proyectos-culturales-deportivos-atacama/','',3);
CALL CrearInstrumento ('CONCURSO EVALUADORESCALL CrearInstrumento (AS) EXTERNOSCALL CrearInstrumento (AS) ESTUDIOS DE INVESTIGACION E INNOVACION EN SEGURIDAD Y SALUD EN EL TRABAJO','','La Superintendencia de Seguridad Social invita a profesionales y académicosCALL CrearInstrumento (as) con experiencia en materias vinculadas a la Seguridad y Salud en el Trabajo a participar en el proceso de selección de evaluadoresCALL CrearInstrumento (as) externosCALL CrearInstrumento (as) para la revisión de los Proyectos de Estudios de Investigación e Innovación. El objetivo de este concurso es fortalecer el análisis y validación de iniciativas que aporten evidencia, conocimiento y propuestas innovadoras que contribuyan al perfeccionamiento del Seguro Social contra Riesgos de Accidentes del Trabajo y Enfermedades Profesionales, conforme a lo establecido en la Ley N°16.744.','2025-08-14','2025-09-08',1,'Capacitación','Tener RUT chileno',0,100000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/suseso/cuesoevaluadoresenseguridadysalud/','',3);
CALL CrearInstrumento ('Muestra Nacional de Dramaturgia','','La presente convocatoria tiene por objetivo fomentar la creación de obras dramáticas y potenciar la visibilización de la dramaturgia nacional, a través de la selección de cinco CALL CrearInstrumento (5) obras dramáticas, tres CALL CrearInstrumento (3) en la Categoría Autor Emergente y dos CALL CrearInstrumento (2) en la Categoría Autor de Trayectoria, las cuales serán montadas y estrenadas en la versión XXII de la Muestra Nacional de Dramaturgia 2025.','2025-08-08','2025-09-08',1,'Capacitación','Tener RUT chileno',3000000,5000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/mincap/convocatoria-dramaturgia/','',3);
CALL CrearInstrumento ('Fondo de las Artes Escénicas: Convocatoria XI Encuentros Coreograficos Nacionales','','La presente convocatoria tiene por objetivo promover, visibilizar y reconocer la creación coreográfica nacional, a través de la selección de cinco CALL CrearInstrumento (5) proyectos de obras coreograficas ineditas presentadas por coreografos y/o coreografas, los cuales serán premiados con un monto unico de $4.000.000.- cada uno. Los proyectos de creacion presentados pueden contemplar de 1 a 3 coreografos y/o coreografas como numero maximo de integrantes. El programa tiene los siguientes objetivos especificos: Contribuir a la creacion y desarrollo de nuevas obras coreograficas nacionales. Fomentar la experimentacion de nuevos lenguajes y procedimientos coreograficos. Visibilizar y poner en valor la creacion coreografica.','2025-08-08','2025-09-08',0,'CAP','Tener RUT chileno',0,4000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/mincap/encuentroscoreograficos/','',3);
CALL CrearInstrumento ('Desafíos Públicos','','Los Desafíos Públicos, son concursos de innovación abierta que tienen por objetivo encontrar soluciones innovadoras a problemas públicos complejos, que requieran investigación y desarrollo y/o desarrollo tecnológico, a fin de generar un impacto positivo en el desarrollo económico, ambiental y social a nivel país. El instrumento busca conectar a quienes demandan o necesitan esta innovación -como organismos públicos o empresas públicas- con posibles oferentes desde las Startups, los centros de investigación, universidades y grupos de emprendedores CALL CrearInstrumento (entre otros). Los Desafíos Públicos, son una herramienta liderada por el Ministerio de Ciencia, Tecnología, Conocimiento e Innovación, en conjunto con la Agencia Nacional de Investigación y Desarrollo CALL CrearInstrumento (ANID) y el Laboratorio de Gobierno CALL CrearInstrumento (LabGob), que busca resolver problemas país a través de la innovación, ofreciendo una recompensa a quien pueda entregar la solución más efectiva al desafío propuesto, a través de la investigación científica y e','2025-08-13','2025-09-10',0,'CAP','Tener RUT chileno',0,60000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/subctci/minciencia-desafiospublicos/','',3);
CALL CrearInstrumento ('ESTUDIOS DE INVESTIGACION E INNOVACION EN SEGURIDAD Y SALUD EN EL TRABAJO','','Los proyectos financiados con recursos del Seguro Social de la Ley N°16.744 tienen como objetivo generar conocimiento científico y soluciones innovadoras que contribuyan, en primer lugar, a la seguridad y salud en el trabajo, incluyendo su promoción y la prevención de los accidentes del trabajo y las enfermedades profesionales; en segundo lugar, a mejorar la calidad, eficiencia y oportunidad de las prestaciones médicas y económicas, incluyendo la rehabilitación y el reintegro laboral que contempla la Ley N°16.744; así como los efectos sociales y económicos relacionados con la incapacidad permanente. Los proyectos adjudicados son financiados con los recursos de la Ley N°16.744 destinados a actividades de prevención de riesgos laborales.','2025-08-14','2025-09-15',0,'CAPACITACION, INVERSION EN INFRAESTRUCTURA','TENER RUT CHILENO, SER PERSONA NATURAL O JURIDICA',0,96971000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/suseso/investigacioneinnovacion/','',3);
CALL CrearInstrumento ('LABORATORIO CIENCIA PÚBLICA','','La convocatoria tiene por objeto entregar financiamiento, expandir capacidades y generar procesos de aprendizaje a través de metodologías y herramientas para el diseño y desarrollo de proyectos comunitarios inéditos de comunicación de conocimientos locales o indígenas, en colaboración con instituciones y/o especialistas vinculados a la ciencia, tecnología, conocimiento o innovación CALL CrearInstrumento (CTCI) que trabajan en el territorio en que las comunidades están insertas. Dichos proyectos no pueden estar dirigidos a escolares, insertarse en actividades propias de las comunidades educativas o estar alineados al currículo. Se entenderá por Laboratorio Ciencia Pública a la metodología utilizada en este concurso para generar un espacio de aprendizaje, fortalecimiento de capacidades e interacción de integrantes de organizaciones sociales que lideran proyectos para la comunicación de conocimientos locales o indígenas. El laboratorio consta de dos etapas: la etapa 1 consistente en un programa de mentoría per','2025-08-18','2025-09-15',3,'CAP','Tener RUT chileno',0,8000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/subctci/laboratoriocienciaspublicas/','',3);
CALL CrearInstrumento ('CONCURSO NACIONAL DE CIENCIA PÚBLICA 2026','','La convocatoria tiene el objetivo de promover la continuidad de eventos públicos, de acceso abierto y gratuito, que fomenten la apropiación de la ciencia y los conocimientos en el territorio nacional, a través de su financiamiento total o parcial. Se entiende por continuidad de eventos la entrega de financiamiento a festivales, ferias, fiestas u otras actividades masivas que fomenten la apropiación de conocimientos científicos, humanísticos, artísticos y tecnológicos y/o el desarrollo de habilidades en áreas como programación, robótica, inteligencia artificial y otras tecnologías emergentes, que cuenten con la realización de al menos una versión ejecutada antes de la publicación de esta convocatoria. A través de este concurso no se financiarán eventos nuevos o versiones en una nueva localidad o territorio.','2025-08-18','2025-09-15',0,'CAP','Tener RUT chileno',0,9000000,'ABI','CAP','EMP','https://www.fondos.gob.cl/ficha/minciencia/cienciapublica-eventos-publicos/','',3);
CALL CrearInstrumento ('titereymarioneta','','El Ministerio de las Culturas, las Artes y el Patrimonio, a través de la Secretaría Ejecutiva de Artes Escénicas, invita a participar en la convocatoria Encuentro de prácticas creativas disciplinares del títere y la marioneta, fortalecer las capacidades creativas y contribuir a la profesionalización de la disciplina del títere y la marioneta, mediante la entrega de herramientas teóricas y prácticas en las áreas de dramaturgia, diseño escénico y dirección. El encuentro se llevará a cabo el mes de noviembre de 2025 y consistirá en el desarrollo de talleres presenciales impartidos por profesionales de destacada trayectoria en la disciplina del títere y la marioneta.','2025-08-11','2025-09-16',1,'Capacitación','Tener RUT chileno',0,0,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/mincap/titereymarioneta/','',3);
CALL CrearInstrumento ('Fondo de Protección Ambiental: Puesta en valor de los Ecosistemas Altoandinos – Humedales y Criósfera','AT','A través de este concurso, el Ministerio del Medio Ambiente, por medio del Fondo de Protección Ambiental, busca promover la puesta en valor y gestión sustentable de los ecosistemas altoandinos de la comuna de Alto del Carmen, Región de Atacama, con especial énfasis en los humedales y la criósfera. Para ello, se apoyarán proyectos ejecutados por universidades, centros de investigación, fundaciones, corporaciones y ONG, orientados a generar conocimiento científico sobre estos ecosistemas, acercarlos a la comunidad mediante infraestructura educativa itinerante y fortalecer su protección a través de actividades de educación ambiental.','2025-08-05','2025-09-17',7,'Capacitación, Inversión en infraestructura','Tener RUT chileno, Ser persona jurídica',0,7000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/mma/fpa-alto-del-carmen-hidrico/','',3);
CALL CrearInstrumento ('Fondo de Protección Ambiental: Puesta en valor de los Ecosistemas Altoandinos – Biodiversidad','AT','A través de este concurso, el Ministerio del Medio Ambiente, por medio del Fondo de Protección Ambiental, busca promover el conocimiento y la conservación de la biodiversidad de los ecosistemas altoandinos en la comuna de Alto del Carmen, Región de Atacama. La convocatoria está dirigida a universidades, centros de investigación, fundaciones, corporaciones y ONG, y contempla el financiamiento de proyectos que permitan diagnosticar los principales componentes de la biodiversidad local, identificar sitios prioritarios para su protección y fortalecer la valoración de estos ecosistemas mediante actividades de educación ambiental dirigidas a la comunidad.','2025-08-05','2025-09-17',6,'Capacitación, Asesoría técnica','Tener RUT chileno, Ser persona jurídica',0,6000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/mma/fpa-alto-del-carmen-biodiversidad/','',3);
CALL CrearInstrumento ('FONDO PARA LA EQUIDAD DE GÉNERO CALL CrearInstrumento (FEG)','','Es un fondo creado por la Ley N°20.820 y tienen por objeto convocar a personas naturales y jurídicas sin fines de lucro interesadas en adjudicarse financiamiento para la ejecución de proyectos en las distintas regiones del país, destinados a apoyar el fortalecimiento de organizaciones de mujeres, cuyas participantes que se beneficien con el proyecto sean exclusivamente mujeres, ya sea mejorando sus capacidades internas, ampliando su impacto en la comunidad o promoviendo su participación en políticas públicas con enfoque de género.','2025-08-26','2025-09-23',0,'CAP','Tener RUT chileno',0,3000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/sernameg/equidad-de-genero/','',3);
CALL CrearInstrumento ('ACMCH2026','','La Secretaría de Fomento de la Música Nacional a través de la Línea de Apoyo a la Circulación de la Música Chilena 2025 – 2026 invita a los distintos agentes del sector a postular proyectos cuyo objetivo sea contribuir al posicionamiento de músicas/os, mediadoras/es, investigadoras/es y profesionales en los circuitos nacionales o extranjeros, mediante la difusión de su trabajo y el fomento de generación de redes de intercambio en territorio chileno y en el exterior. Este primer llamado es para postulaciones con inicio de ejecución durante diciembre de 2025.','2025-08-20','2025-09-23',1,'Capacitación, Asesoría técnica, Inversión en infraestructura','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,15000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/mincap/acmch2026/','',3);
CALL CrearInstrumento ('Fondo de Protección Ambiental - Tocopilla','TA','A través de este Concurso, el MMA por medio del Fondo de Protección Ambiental, busca contribuir al proceso de Transición Socioecológica Justa de la comuna de Tocopilla Región del Antofagasta, por medio de la ejecución de proyectos ciudadanos, focalizados en las temáticas de Innovación en energías renovables y eficiencia energética y Adaptación al Cambio Climático, incorporando la educación ambiental como un proceso permanente.','2025-07-01','2025-09-24',6,'CAP, RIE','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,1000000,'ABI','RIE','ORG','https://www.fondos.gob.cl/ficha/mma/fpatocopilla-2025/','',3);
CALL CrearInstrumento ('PROYECTOS CIUDADANOS CON ENFOQUE DE TRANSICIÓN SOCIOECOLÓGICA JUSTA','TA','A través de este Concurso, el MMA por medio del Fondo de Protección Ambiental, busca contribuir al proceso de Transición Socioecológica Justa de la comuna de Mejillones Región del Antofagasta, por medio de la ejecución de proyectos ciudadanos, focalizados en las temáticas de Innovación en energías renovables y eficiencia energética y Adaptación al Cambio Climático, incorporando la educación ambiental como un proceso permanente.','2025-07-01','2025-09-24',6,'CAP','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',0,10000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/mma/fpamejillones-2025/','',3);
CALL CrearInstrumento ('Premio a las Artes Escénicas Nacionales Presidente de la República 2025','','El Ministerio de las Culturas, las Artes y el Patrimonio, a través del Consejo Nacional de Artes Escénicas, invita a participar en la convocatoria 2025 de los Premios a las Artes Escénicas Nacionales Presidente de la República. Desde 2022, el Premio a las Artes Escénicas Nacionales Presidente de la República distingue anualmente la excelencia, creatividad y labor de artistas, elencos y/o compañías que ha aportado al desarrollo del sector desde diversos ámbitos y disciplinas. Cada año, el proceso de selección se inicia con un llamado abierto a la ciudadanía y al sector cultural a presentar sus candidaturas. Posteriormente, el Consejo Nacional de Artes Escénicas evalúa los antecedentes recibidos para luego definir a las y los galardonados en ocho categorías: teatro, danza, ópera, circo, narración oral, autores de obras escénicas, diseño escénico y artista emergente.','2025-08-26','2025-09-25',0,'Capacitación, Asesoría técnica, Inversión en infraestructura','Tener RUT chileno, Ser persona natural o jurídica',0,0,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/mincap/aepr2025/','',3);
CALL CrearInstrumento ('Fondo de las Artes Escénicas: Programa de Residencias Internacionales en Artes Escénicas 2025','','El Ministerio de las Culturas, las Artes y el Patrimonio, a través de su Secretaría Ejecutiva de Artes Escénicas, abre la convocatoria para postular al Programa de Residencias Internacionales en Artes Escénicas, convocatoria 2025. Esta convocatoria tiene por objetivo promover y apoyar los procesos de creación escénica en residencia que se realicen en el extranjero. Los proyectos de residencia deben facilitar y coordinar la colaboración entre espacios de residencia a nivel nacional e internacional, aprovechando su infraestructura y redes de trabajo para fomentar la cooperación artística y la difusión internacional de las artes escénicas, con el propósito de aumentar la visibilidad de las obras nacionales y sus procesos creativos.','2025-08-20','2025-09-26',1,'CAP','Tener RUT chileno',0,15000000,'ABI','RIE','ORG','https://www.fondos.gob.cl/ficha/mincap/priae2025/','',3);
CALL CrearInstrumento ('SERPAT CALL CrearInstrumento (CONCURSO NACIONAL)','','Para beneficiar el patrimonio cultural en todas sus formas, la Ley 21.045 dispone recursos para el financiamiento \"total o parcial de proyectos, programas, actividades y medidas de identificación, registro, investigación, difusión, valoración, protección, rescate, preservación, conservación, adquisición y salvaguardia del patrimonio, en sus diversas modalidades y manifestaciones, y de educación en todos los ámbitos del patrimonio cultural, material e inmaterial, incluidas las manifestaciones de las culturas y patrimonio de los pueblos indígenas\"','2025-07-17','2025-09-30',2,'Capacitación, Asesoría técnica, Inversión en infraestructura','Tener RUT chileno, Ser persona natural o jurídica',10000000,85000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/serpat/patrimonio2025/','',3);
CALL CrearInstrumento ('Coproducciones artes escenicas','','El Ministerio de las Culturas, las Artes y el Patrimonio, a través de la Secretaría Ejecutiva de Artes Escénicas, invita a postular a la convocatoria \"Coproducciones de obras de artes escénicas\". Esta convocatoria tiene por objetivo entregar financiamiento parcial a proyectos que desarrollen la coproducción de una puesta en escena inédita de gran formato en el ámbito de las artes escénicas CALL CrearInstrumento (como ópera, ballet, teatro musical, teatro callejero, entre otros), mediante la realización de un proyecto con contemple su creación, producción y circulación, con un mínimo de 6 funciones en total.','2025-08-26','2025-10-01',0,'Capacitación','Tener RUT chileno',0,10000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/mincap/coproducciones-artesescenicas/','',3);
CALL CrearInstrumento ('FPA 2026 - PROYECTOS SUSTENTABLES CIUDADANOS CALL CrearInstrumento (PSC)','','Uno de los focos del MMA, es promover el trabajo institucional en conjunto con la ciudadanía, apoyando proyectos de carácter comunitario y asociativo, que contribuyan a mejorar la calidad ambiental de su territorio a través de la realización de actividades y experiencias demostrativas replicables que utilicen los recursos disponibles CALL CrearInstrumento (sociales, culturales, ambientales, económicos, etc.) de manera sustentable, contribuyendo con ello a generar mayor conciencia y valoración de su entorno, a través de la educación ambiental y la participación ciudadana, para resolver una necesidad ambiental.','2025-08-26','2025-10-07',3,'Capacitación, Asesoría técnica, Inversión en infraestructura','Tener RUT chileno, Ser persona jurídica',0,6000000,'ABI','CAP','EMP','https://www.fondos.gob.cl/ficha/mma/fpa2026-psc/','',3);
CALL CrearInstrumento ('FPA 2026 - PROYECTOS SUSTENTABLES EN ESTABLECIMIENTES EDUCACIONALES CALL CrearInstrumento (PSEE)','','El presente concurso aspira a ser un aporte en la creación de hábitos y conductas sustentables al interior de los establecimientos educacionales, apoyando y fomentando proyectos que desarrollen e incorporen prácticas ambientales en la gestión de recursos y en el quehacer educativo, logrando que el establecimiento sea reconocido como un espacio de aprendizaje integral para la comunidad educativa, y un referente ambiental para el fortalecimiento de la gestión local.','2025-08-26','2025-10-07',0,'CAP','Tener RUT chileno',0,6000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/mma/fpa2026-psee/','',3);
CALL CrearInstrumento ('FPA 2026 - PROYECTOS SUSTENTABLES PARA PUEBLOS INDÍGENAS CALL CrearInstrumento (PSPI)','','Uno de los focos del MMA es promover el trabajo institucional en conjunto con los pueblos indígenas, velando por su adecuado desarrollo social, poniendo énfasis particular en el resguardo de su cultura y cosmovisión. Lo anterior, apoyando proyectos de carácter comunitario y asociativo, que contribuyan a mejorar la calidad ambiental del territorio, a través de la realización de actividades y experiencias demostrativas y replicables que utilicen los recursos disponibles CALL CrearInstrumento (sociales, culturales, ambientales, económicos, etc.) de manera sustentable, aportando con ello a generar mayor conciencia y valoración de su entorno, a través de la educación ambiental y la participación ciudadana, para resolver una necesidad ambiental.','2025-08-26','2025-10-07',0,'CAP','Tener RUT chileno',0,6000000,'ABI','CAP','ORG','https://www.fondos.gob.cl/ficha/mma/fpa2026-pspi/','',3);
CALL CrearInstrumento ('MI TAXI ELÉCTRICO ATACAMA','AT','Este fondo cofinancia la inversión para el reemplazo de un vehículo con motor de combustión interna, que sea taxi en todas sus modalidades, según DS-212 de MTT a un vehículo eléctrico. El vehículo a reemplazar debe estar inscrito en el registro nacional de transporte de pasajeros en la región y el propietario debe contar con un lugar o estacionamiento bajo su control y que pueda ser instalado un cargador para el vehículo eléctrico. Este Fondo se encontrará abierto hasta completar los cupos CALL CrearInstrumento (158).','2024-04-30','2025-10-30',12,'Capacitación','Tener RUT chileno, Estar inscrito en un programa x',0,16000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/minenergia/mte-atacama/','',3);
CALL CrearInstrumento ('MI TAXI ELÉCTRICO O\'HIGGINS','LI','Este fondo cofinancia la inversión para el reemplazo de un vehículo con motor de combustión interna, que sea taxi en todas sus modalidades, según DS-212 de MTT a un vehículo eléctrico. El vehículo a reemplazar debe estar inscrito en el registro nacional de transporte de pasajeros en la región y el propietario debe contar con un lugar o estacionamiento bajo su control y que pueda ser instalado un cargador para el vehículo eléctrico. Este Fondo se encontrará abierto hasta completar los cupos CALL CrearInstrumento (152).','2024-03-13','2025-10-30',12,'Capacitación','Tener RUT chileno, Estar inscrito en un programa x',0,16000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/minenergia/mte-ohiggins/','',3);
CALL CrearInstrumento ('MI TAXI ELÉCTRICO BÍOBÍO','BI','Este fondo cofinancia la inversión para el reemplazo de un vehículo con motor de combustión interna, que sea taxi en todas sus modalidades, según DS-212 de MTT a un vehículo eléctrico. El vehículo a reemplazar debe estar inscrito en el registro nacional de transporte de pasajeros en la región y el propietario debe contar con un lugar o estacionamiento bajo su control y que pueda ser instalado un cargador para el vehículo eléctrico. Este Fondo se encontrará abierto hasta completar los cupos CALL CrearInstrumento (299).','2024-04-30','2025-10-30',12,'Capacitación','Tener RUT chileno, Estar inscrito en un programa x',0,16000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/minenergia/mte-biobio/','',3);
CALL CrearInstrumento ('MI TAXI ELÉCTRICO ANTOFAGASTA','TA','Este fondo cofinancia la inversión para el reemplazo de un vehículo con motor de combustión interna, que sea taxi en todas sus modalidades, según DS-212 de MTT a un vehículo eléctrico. El vehículo a reemplazar debe estar inscrito en el registro nacional de transporte de pasajeros en la región y el propietario debe contar con un lugar o estacionamiento bajo su control y que pueda ser instalado un cargador para el vehículo eléctrico. Este Fondo se encontrará abierto hasta completar los cupos CALL CrearInstrumento (59).','2024-03-26','2025-10-30',12,'Capacitación','Tener RUT chileno, Estar inscrito en un programa x',0,16000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/minenergia/mte-antofagasta/','',3);
CALL CrearInstrumento ('FNDR Deportistas O’Higgins 2025','LI','Apoyar procesos de preparación y/o entrenamientos para competencias de deportistas destacados, convencionales y paralímpicos. Dichos deportistas deben tener domicilio CALL CrearInstrumento (residencia) y afiliación deportiva en la Región de O’Higgins. Sin perjuicio de lo anterior, y con respecto al punto de la exigencia de afiliación deportiva, se considerarán casos excepcionales, pero debidamente calificados, por ejemplo, para aquellas disciplinas que no posean clubes federados en la región, seleccionados/as nacionales que, a pesar de tener domicilio en la región, por motivos fundamentados, han debido afiliarse a clubes fuera de esta, CALL CrearInstrumento (entre otros similares). Cabe señalar, que la pertinencia de dichos casos será evaluada por la Unidad FNDR 8%.','2025-05-06','2025-12-31',7,'Capacitación','Tener RUT chileno, Ser persona natural o jurídica, Estar insrito en un programa x',6000000,8000000,'ABI','CAP','PER','https://www.fondos.gob.cl/ficha/goreohiggins/fndr_deportistas_ohiggins-2025/','',3);
