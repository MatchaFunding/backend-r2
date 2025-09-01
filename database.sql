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
	FOREIGN KEY (Financiador) REFERENCES Financiador(ID),
	FOREIGN KEY (Estado) REFERENCES EstadoDeFondo(ID),
	FOREIGN KEY (TipoDeBeneficio) REFERENCES TipoDeBeneficio(ID),
	FOREIGN KEY (TipoDePerfil) REFERENCES TipoDePerfil(ID)
);

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
	(76,'CORPORACION MUNICIPAL DE LA CULTURA Y LAS ARTES DE SAN ANTONIO','2025-01-01',17,'N/A',2,4,1,'65065493-5','65065493-5'),
	(77,'AGRUPACION ACERCA REDES MARIQUINA','2025-01-01',17,'N/A',2,4,1,'650661257','650661257'),
	(78,'ASOCIACION GREMIAL DE RENOVADORES Y RECAUCHADORES DE NEUMATICOS DE CHILE','2025-01-01',17,'N/A',2,4,1,'65066579-1','65066579-1'),
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
