/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: MatchaFundingMySQL
-- ------------------------------------------------------
-- Server version	12.0.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `Beneficiario`
--

DROP TABLE IF EXISTS `Beneficiario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Beneficiario` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `FechaDeCreacion` date NOT NULL,
  `RegionDeCreacion` bigint(20) NOT NULL,
  `Direccion` varchar(300) NOT NULL,
  `TipoDePersona` bigint(20) NOT NULL,
  `TipoDeEmpresa` bigint(20) NOT NULL,
  `Perfil` bigint(20) NOT NULL,
  `RUTdeEmpresa` varchar(12) NOT NULL,
  `RUTdeRepresentante` varchar(12) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `RegionDeCreacion` (`RegionDeCreacion`),
  KEY `TipoDePersona` (`TipoDePersona`),
  KEY `TipoDeEmpresa` (`TipoDeEmpresa`),
  KEY `Perfil` (`Perfil`),
  CONSTRAINT `Beneficiario_ibfk_1` FOREIGN KEY (`RegionDeCreacion`) REFERENCES `Region` (`ID`),
  CONSTRAINT `Beneficiario_ibfk_2` FOREIGN KEY (`TipoDePersona`) REFERENCES `TipoDePersona` (`ID`),
  CONSTRAINT `Beneficiario_ibfk_3` FOREIGN KEY (`TipoDeEmpresa`) REFERENCES `TipoDeEmpresa` (`ID`),
  CONSTRAINT `Beneficiario_ibfk_4` FOREIGN KEY (`Perfil`) REFERENCES `TipoDePerfil` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Beneficiario`
--

LOCK TABLES `Beneficiario` WRITE;
/*!40000 ALTER TABLE `Beneficiario` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Beneficiario` VALUES
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
/*!40000 ALTER TABLE `Beneficiario` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Colaborador`
--

DROP TABLE IF EXISTS `Colaborador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Colaborador` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Persona` bigint(20) NOT NULL,
  `Proyecto` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Persona` (`Persona`),
  KEY `Proyecto` (`Proyecto`),
  CONSTRAINT `Colaborador_ibfk_1` FOREIGN KEY (`Persona`) REFERENCES `Persona` (`ID`),
  CONSTRAINT `Colaborador_ibfk_2` FOREIGN KEY (`Proyecto`) REFERENCES `Proyecto` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Colaborador`
--

LOCK TABLES `Colaborador` WRITE;
/*!40000 ALTER TABLE `Colaborador` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Colaborador` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Consorcio`
--

DROP TABLE IF EXISTS `Consorcio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Consorcio` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PrimerBeneficiario` bigint(20) NOT NULL,
  `SegundoBeneficiario` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PrimerBeneficiario` (`PrimerBeneficiario`),
  KEY `SegundoBeneficiario` (`SegundoBeneficiario`),
  CONSTRAINT `Consorcio_ibfk_1` FOREIGN KEY (`PrimerBeneficiario`) REFERENCES `Beneficiario` (`ID`),
  CONSTRAINT `Consorcio_ibfk_2` FOREIGN KEY (`SegundoBeneficiario`) REFERENCES `Beneficiario` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Consorcio`
--

LOCK TABLES `Consorcio` WRITE;
/*!40000 ALTER TABLE `Consorcio` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Consorcio` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `EstadoDeFondo`
--

DROP TABLE IF EXISTS `EstadoDeFondo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EstadoDeFondo` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(3) NOT NULL,
  `Nombre` varchar(40) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EstadoDeFondo`
--

LOCK TABLES `EstadoDeFondo` WRITE;
/*!40000 ALTER TABLE `EstadoDeFondo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `EstadoDeFondo` VALUES
(1,'PRX','Proximo'),
(2,'ABI','Abierto'),
(3,'EVA','En evaluacion'),
(4,'ADJ','Adjudicado'),
(5,'SUS','Suspendido'),
(6,'PAY','Patrocinio Institucional'),
(7,'DES','Desierto'),
(8,'CER','Cerrrado');
/*!40000 ALTER TABLE `EstadoDeFondo` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Financiador`
--

DROP TABLE IF EXISTS `Financiador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Financiador` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `FechaDeCreacion` date NOT NULL,
  `RegionDeCreacion` bigint(20) NOT NULL,
  `Direccion` varchar(300) NOT NULL,
  `TipoDePersona` bigint(20) NOT NULL,
  `TipoDeEmpresa` bigint(20) NOT NULL,
  `Perfil` bigint(20) NOT NULL,
  `RUTdeEmpresa` varchar(12) NOT NULL,
  `RUTdeRepresentante` varchar(12) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `RegionDeCreacion` (`RegionDeCreacion`),
  KEY `TipoDePersona` (`TipoDePersona`),
  KEY `TipoDeEmpresa` (`TipoDeEmpresa`),
  KEY `Perfil` (`Perfil`),
  CONSTRAINT `Financiador_ibfk_1` FOREIGN KEY (`RegionDeCreacion`) REFERENCES `Region` (`ID`),
  CONSTRAINT `Financiador_ibfk_2` FOREIGN KEY (`TipoDePersona`) REFERENCES `TipoDePersona` (`ID`),
  CONSTRAINT `Financiador_ibfk_3` FOREIGN KEY (`TipoDeEmpresa`) REFERENCES `TipoDePersona` (`ID`),
  CONSTRAINT `Financiador_ibfk_4` FOREIGN KEY (`Perfil`) REFERENCES `TipoDePerfil` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Financiador`
--

LOCK TABLES `Financiador` WRITE;
/*!40000 ALTER TABLE `Financiador` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Financiador` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Idea`
--

DROP TABLE IF EXISTS `Idea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Idea` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Usuario` bigint(20) NOT NULL,
  `Campo` varchar(1000) NOT NULL,
  `Problema` varchar(1000) NOT NULL,
  `Publico` varchar(1000) NOT NULL,
  `Innovacion` varchar(1000) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Usuario` (`Usuario`),
  CONSTRAINT `Idea_ibfk_1` FOREIGN KEY (`Usuario`) REFERENCES `Usuario` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Idea`
--

LOCK TABLES `Idea` WRITE;
/*!40000 ALTER TABLE `Idea` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Idea` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Instrumento`
--

DROP TABLE IF EXISTS `Instrumento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Instrumento` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(200) NOT NULL,
  `Alcance` bigint(20) NOT NULL,
  `Descripcion` varchar(1000) NOT NULL,
  `FechaDeApertura` date NOT NULL,
  `FechaDeCierre` date NOT NULL,
  `DuracionEnMeses` int(11) NOT NULL,
  `Beneficios` varchar(1000) NOT NULL,
  `Requisitos` varchar(1000) NOT NULL,
  `MontoMinimo` int(11) NOT NULL,
  `MontoMaximo` int(11) NOT NULL,
  `Estado` bigint(20) NOT NULL,
  `TipoDeBeneficio` bigint(20) NOT NULL,
  `TipoDePerfil` bigint(20) NOT NULL,
  `EnlaceDelDetalle` varchar(300) NOT NULL,
  `EnlaceDeLaFoto` varchar(300) NOT NULL,
  `Financiador` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Alcance` (`Alcance`),
  KEY `Financiador` (`Financiador`),
  KEY `Estado` (`Estado`),
  KEY `TipoDeBeneficio` (`TipoDeBeneficio`),
  KEY `TipoDePerfil` (`TipoDePerfil`),
  CONSTRAINT `Instrumento_ibfk_1` FOREIGN KEY (`Alcance`) REFERENCES `Region` (`ID`),
  CONSTRAINT `Instrumento_ibfk_2` FOREIGN KEY (`Financiador`) REFERENCES `Financiador` (`ID`),
  CONSTRAINT `Instrumento_ibfk_3` FOREIGN KEY (`Estado`) REFERENCES `EstadoDeFondo` (`ID`),
  CONSTRAINT `Instrumento_ibfk_4` FOREIGN KEY (`TipoDeBeneficio`) REFERENCES `TipoDeBeneficio` (`ID`),
  CONSTRAINT `Instrumento_ibfk_5` FOREIGN KEY (`TipoDePerfil`) REFERENCES `TipoDePerfil` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Instrumento`
--

LOCK TABLES `Instrumento` WRITE;
/*!40000 ALTER TABLE `Instrumento` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Instrumento` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Miembro`
--

DROP TABLE IF EXISTS `Miembro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Miembro` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Beneficiario` bigint(20) NOT NULL,
  `Persona` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Beneficiario` (`Beneficiario`),
  KEY `Persona` (`Persona`),
  CONSTRAINT `Miembro_ibfk_1` FOREIGN KEY (`Beneficiario`) REFERENCES `Beneficiario` (`ID`),
  CONSTRAINT `Miembro_ibfk_2` FOREIGN KEY (`Persona`) REFERENCES `Persona` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Miembro`
--

LOCK TABLES `Miembro` WRITE;
/*!40000 ALTER TABLE `Miembro` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Miembro` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Persona`
--

DROP TABLE IF EXISTS `Persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Persona` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(200) NOT NULL,
  `Sexo` bigint(20) NOT NULL,
  `RUT` varchar(12) NOT NULL,
  `FechaDeNacimiento` date NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Sexo` (`Sexo`),
  CONSTRAINT `Persona_ibfk_1` FOREIGN KEY (`Sexo`) REFERENCES `Sexo` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Persona`
--

LOCK TABLES `Persona` WRITE;
/*!40000 ALTER TABLE `Persona` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Persona` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Postulacion`
--

DROP TABLE IF EXISTS `Postulacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Postulacion` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Resultado` varchar(30) NOT NULL,
  `MontoObtenido` int(11) NOT NULL,
  `FechaDePostulacion` date NOT NULL,
  `FechaDeResultado` date NOT NULL,
  `Detalle` varchar(1000) NOT NULL,
  `Beneficiario` bigint(20) NOT NULL,
  `Instrumento` bigint(20) NOT NULL,
  `Proyecto` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Beneficiario` (`Beneficiario`),
  KEY `Instrumento` (`Instrumento`),
  KEY `Proyecto` (`Proyecto`),
  CONSTRAINT `Postulacion_ibfk_1` FOREIGN KEY (`Beneficiario`) REFERENCES `Beneficiario` (`ID`),
  CONSTRAINT `Postulacion_ibfk_2` FOREIGN KEY (`Instrumento`) REFERENCES `Instrumento` (`ID`),
  CONSTRAINT `Postulacion_ibfk_3` FOREIGN KEY (`Proyecto`) REFERENCES `Proyecto` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Postulacion`
--

LOCK TABLES `Postulacion` WRITE;
/*!40000 ALTER TABLE `Postulacion` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Postulacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Proyecto`
--

DROP TABLE IF EXISTS `Proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Proyecto` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(300) NOT NULL,
  `Descripcion` varchar(500) NOT NULL,
  `DuracionEnMesesMinimo` int(11) NOT NULL,
  `DuracionEnMesesMaximo` int(11) NOT NULL,
  `Alcance` bigint(20) NOT NULL,
  `Area` varchar(100) NOT NULL,
  `Beneficiario` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Beneficiario` (`Beneficiario`),
  KEY `Alcance` (`Alcance`),
  CONSTRAINT `Proyecto_ibfk_1` FOREIGN KEY (`Beneficiario`) REFERENCES `Beneficiario` (`ID`),
  CONSTRAINT `Proyecto_ibfk_2` FOREIGN KEY (`Alcance`) REFERENCES `Region` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proyecto`
--

LOCK TABLES `Proyecto` WRITE;
/*!40000 ALTER TABLE `Proyecto` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Proyecto` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Region`
--

DROP TABLE IF EXISTS `Region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Region` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(2) NOT NULL,
  `Nombre` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Region`
--

LOCK TABLES `Region` WRITE;
/*!40000 ALTER TABLE `Region` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Region` VALUES
(1,'AP','Arica y Parinacota'),
(2,'TA','Tarapaca'),
(3,'AN','Antofagasta'),
(4,'AT','Atacama'),
(5,'CO','Coquimbo'),
(6,'VA','Valparaiso'),
(7,'RM','Santiago'),
(8,'LI','O Higgins'),
(9,'ML','Maule'),
(10,'NB','Nuble'),
(11,'BI','Biobio'),
(12,'AR','La Araucania'),
(13,'LR','Los Rios'),
(14,'LL','Los Lagos'),
(15,'AI','Aysen'),
(16,'MA','Magallanes'),
(17,'NA','Nacional');
/*!40000 ALTER TABLE `Region` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Sexo`
--

DROP TABLE IF EXISTS `Sexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sexo` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(3) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sexo`
--

LOCK TABLES `Sexo` WRITE;
/*!40000 ALTER TABLE `Sexo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Sexo` VALUES
(1,'VAR','Hombre'),
(2,'MUJ','Mujer'),
(3,'NA','Otro');
/*!40000 ALTER TABLE `Sexo` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `TipoDeBeneficio`
--

DROP TABLE IF EXISTS `TipoDeBeneficio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDeBeneficio` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(3) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDeBeneficio`
--

LOCK TABLES `TipoDeBeneficio` WRITE;
/*!40000 ALTER TABLE `TipoDeBeneficio` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `TipoDeBeneficio` VALUES
(1,'CAP','Capacitacion'),
(2,'RIE','Capital de riesgo'),
(3,'CRE','Creditos'),
(4,'GAR','Garantias'),
(5,'MUJ','Incentivo mujeres'),
(6,'OTR','Otros incentivos'),
(7,'SUB','Subsidios');
/*!40000 ALTER TABLE `TipoDeBeneficio` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `TipoDeEmpresa`
--

DROP TABLE IF EXISTS `TipoDeEmpresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDeEmpresa` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(4) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDeEmpresa`
--

LOCK TABLES `TipoDeEmpresa` WRITE;
/*!40000 ALTER TABLE `TipoDeEmpresa` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `TipoDeEmpresa` VALUES
(1,'SA','Sociedad Anonima'),
(2,'SRL','Sociedad de Responsabilidad Limitada'),
(3,'SPA','Sociedad por Acciones'),
(4,'EIRL','Empresa Individual de Responsabilidad Limitada');
/*!40000 ALTER TABLE `TipoDeEmpresa` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `TipoDePerfil`
--

DROP TABLE IF EXISTS `TipoDePerfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDePerfil` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(3) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDePerfil`
--

LOCK TABLES `TipoDePerfil` WRITE;
/*!40000 ALTER TABLE `TipoDePerfil` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `TipoDePerfil` VALUES
(1,'EMP','Empresa'),
(2,'EXT','Extranjero'),
(3,'INS','Institucion'),
(4,'MED','Intermediario'),
(5,'ORG','Organizacion'),
(6,'PER','Persona');
/*!40000 ALTER TABLE `TipoDePerfil` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `TipoDePersona`
--

DROP TABLE IF EXISTS `TipoDePersona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoDePersona` (
  `ID` bigint(20) NOT NULL,
  `Codigo` varchar(2) NOT NULL,
  `Nombre` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoDePersona`
--

LOCK TABLES `TipoDePersona` WRITE;
/*!40000 ALTER TABLE `TipoDePersona` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `TipoDePersona` VALUES
(1,'JU','Juridica'),
(2,'NA','Natural');
/*!40000 ALTER TABLE `TipoDePersona` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `NombreDeUsuario` varchar(200) NOT NULL,
  `Contrasena` varchar(200) NOT NULL,
  `Correo` varchar(200) NOT NULL,
  `Persona` bigint(20) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Persona` (`Persona`),
  CONSTRAINT `Usuario_ibfk_1` FOREIGN KEY (`Persona`) REFERENCES `Persona` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Temporary table structure for view `VerRegionesComoJSON`
--

DROP TABLE IF EXISTS `VerRegionesComoJSON`;
/*!50001 DROP VIEW IF EXISTS `VerRegionesComoJSON`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `VerRegionesComoJSON` AS SELECT
 1 AS `Name_exp_1` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `VerTodasLasPersonas`
--

DROP TABLE IF EXISTS `VerTodasLasPersonas`;
/*!50001 DROP VIEW IF EXISTS `VerTodasLasPersonas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `VerTodasLasPersonas` AS SELECT
 1 AS `ID`,
  1 AS `Nombre`,
  1 AS `RUT`,
  1 AS `Sexo` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `VerTodasLasRegiones`
--

DROP TABLE IF EXISTS `VerTodasLasRegiones`;
/*!50001 DROP VIEW IF EXISTS `VerTodasLasRegiones`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `VerTodasLasRegiones` AS SELECT
 1 AS `ID`,
  1 AS `Codigo`,
  1 AS `Nombre` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `VerTodosLosBeneficiarios`
--

DROP TABLE IF EXISTS `VerTodosLosBeneficiarios`;
/*!50001 DROP VIEW IF EXISTS `VerTodosLosBeneficiarios`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `VerTodosLosBeneficiarios` AS SELECT
 1 AS `ID`,
  1 AS `Nombre`,
  1 AS `FechaDeCreacion`,
  1 AS `RegionDeCreacion`,
  1 AS `Direccion`,
  1 AS `TipoDePersona`,
  1 AS `TipoDeEmpresa`,
  1 AS `Perfil`,
  1 AS `RUTdeEmpresa`,
  1 AS `RUTdeRepresentante` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `VerRegionesComoJSON`
--

/*!50001 DROP VIEW IF EXISTS `VerRegionesComoJSON`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `VerRegionesComoJSON` AS select json_arrayagg(json_object('ID',`Region`.`ID`,'Codigo',`Region`.`Codigo`,'Nombre',`Region`.`Nombre`)) AS `Name_exp_1` from `Region` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `VerTodasLasPersonas`
--

/*!50001 DROP VIEW IF EXISTS `VerTodasLasPersonas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `VerTodasLasPersonas` AS select `Persona`.`ID` AS `ID`,`Persona`.`Nombre` AS `Nombre`,`Persona`.`RUT` AS `RUT`,`Sexo`.`Nombre` AS `Sexo` from (`Persona` join `Sexo`) where `Sexo`.`ID` = `Persona`.`Sexo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `VerTodasLasRegiones`
--

/*!50001 DROP VIEW IF EXISTS `VerTodasLasRegiones`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `VerTodasLasRegiones` AS select `Region`.`ID` AS `ID`,`Region`.`Codigo` AS `Codigo`,`Region`.`Nombre` AS `Nombre` from `Region` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `VerTodosLosBeneficiarios`
--

/*!50001 DROP VIEW IF EXISTS `VerTodosLosBeneficiarios`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `VerTodosLosBeneficiarios` AS select `Beneficiario`.`ID` AS `ID`,`Beneficiario`.`Nombre` AS `Nombre`,`Beneficiario`.`FechaDeCreacion` AS `FechaDeCreacion`,`Region`.`Nombre` AS `RegionDeCreacion`,`Beneficiario`.`Direccion` AS `Direccion`,`TipoDePersona`.`Nombre` AS `TipoDePersona`,`TipoDeEmpresa`.`Nombre` AS `TipoDeEmpresa`,`TipoDePerfil`.`Nombre` AS `Perfil`,`Beneficiario`.`RUTdeEmpresa` AS `RUTdeEmpresa`,`Beneficiario`.`RUTdeRepresentante` AS `RUTdeRepresentante` from ((((`Beneficiario` join `Region`) join `TipoDePersona`) join `TipoDeEmpresa`) join `TipoDePerfil`) where `Region`.`ID` = `Beneficiario`.`RegionDeCreacion` and `TipoDePersona`.`ID` = `Beneficiario`.`TipoDePersona` and `TipoDeEmpresa`.`ID` = `Beneficiario`.`TipoDeEmpresa` and `TipoDePerfil`.`ID` = `Beneficiario`.`Perfil` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-08-31 21:38:33
