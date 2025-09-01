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
FROM Beneficiario,
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
