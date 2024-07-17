CREATE DATABASE  IF NOT EXISTS `cs336project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cs336project`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: cs336project
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `CustomerId` int NOT NULL,
  `LastName` varchar(100) DEFAULT NULL,
  `FirstName` varchar(100) DEFAULT NULL,
  `Username` varchar(100) DEFAULT NULL,
  `Password` varchar(100) DEFAULT NULL,
  `EmailAddress` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CustomerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Smith','John','johnsmith','secret_password','john.smith@rutgers.edu'),(2,'jordan','jordan','jordan','jordan','jordan@jordan.jordan'),(3,'aaron','aaron','aaron','aaron','aaron@aaron.aaron'),(4,'ariel','ariel','ariel','ariel','ariel@ariel.ariel'),(5,'susan','susan','susan','susan','susan@susan.susan'),(6,'caleb','caleb','caleb','caleb','caleb@caleb.caleb');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `EmployeeId` int NOT NULL,
  `SSN` varchar(20) DEFAULT NULL,
  `LastName` varchar(100) DEFAULT NULL,
  `FirstName` varchar(100) DEFAULT NULL,
  `Username` varchar(100) DEFAULT NULL,
  `Password` varchar(100) DEFAULT NULL,
  `EmployeeType` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EmployeeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (0,'000-00-0000','Instructor','Wonderful','admin','admin','Admin'),(1,'111-11-1111','Customer','Customer','employee','employee','customerRep');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faretype`
--

DROP TABLE IF EXISTS `faretype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faretype` (
  `FareTypeId` int NOT NULL,
  `FareTypeName` varchar(100) DEFAULT NULL,
  `FareTypeMultiplier` float DEFAULT NULL,
  PRIMARY KEY (`FareTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faretype`
--

LOCK TABLES `faretype` WRITE;
/*!40000 ALTER TABLE `faretype` DISABLE KEYS */;
INSERT INTO `faretype` VALUES (1,'StandardFare',1),(2,'ChildFare',0.75),(3,'SeniorFare',0.65),(4,'DisabledFare',0.5);
/*!40000 ALTER TABLE `faretype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `line`
--

DROP TABLE IF EXISTS `line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `line` (
  `LineId` int NOT NULL,
  `LineName` varchar(100) DEFAULT NULL,
  `OriginStationId` int DEFAULT NULL,
  `DestinationStationId` int DEFAULT NULL,
  `LineCost` double DEFAULT NULL,
  PRIMARY KEY (`LineId`),
  KEY `fk_station` (`OriginStationId`),
  KEY `fk_dstation` (`DestinationStationId`),
  CONSTRAINT `fk_dstation` FOREIGN KEY (`DestinationStationId`) REFERENCES `station` (`StationId`),
  CONSTRAINT `fk_station` FOREIGN KEY (`OriginStationId`) REFERENCES `station` (`StationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `line`
--

LOCK TABLES `line` WRITE;
/*!40000 ALTER TABLE `line` DISABLE KEYS */;
INSERT INTO `line` VALUES (1,'Northeast Corridor',1,16,50),(2,'Atlantic City Line',401,408,60),(3,'Montclair-Boonton Line',801,829,70),(4,'Morristown Line',501,524,80),(5,'Gladstone Branch',701,724,75),(6,'North Jersey Coast Line',201,229,65),(7,'Raritan Valley Line',301,319,60),(8,'Port Jervis Line',601,614,90);
/*!40000 ALTER TABLE `line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `line_direction`
--

DROP TABLE IF EXISTS `line_direction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `line_direction` (
  `LineId` int NOT NULL,
  `DirectionId` int NOT NULL,
  `DirectionName` varchar(100) NOT NULL,
  `OriginStationId` int NOT NULL,
  `DestinationStationId` int NOT NULL,
  PRIMARY KEY (`LineId`,`DirectionId`),
  KEY `idx_origin_station` (`OriginStationId`),
  KEY `idx_destination_station` (`DestinationStationId`),
  CONSTRAINT `fk_line_direction_destination_station` FOREIGN KEY (`DestinationStationId`) REFERENCES `station` (`StationId`),
  CONSTRAINT `fk_line_direction_origin_station` FOREIGN KEY (`OriginStationId`) REFERENCES `station` (`StationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `line_direction`
--

LOCK TABLES `line_direction` WRITE;
/*!40000 ALTER TABLE `line_direction` DISABLE KEYS */;
INSERT INTO `line_direction` VALUES (1,1,'To Penn Station NY',1,16),(1,2,'To Trenton NJ',16,1),(2,1,'To Atlantic City',401,408),(2,2,'To Philadelphia',408,401),(3,1,'To Summit',801,829),(3,2,'To Hoboken',829,801),(4,1,'To Hackettstown',501,525),(4,2,'To Hoboken',525,501),(5,1,'To Gladstone',701,724),(5,2,'To Hoboken',724,701),(6,1,'To NY Penn Station',201,229),(6,2,'To Bay Head',229,201),(7,1,'To Newark Penn Station',301,319),(7,2,'To High Bridge',319,301),(8,1,'To Port Jervis',601,614),(8,2,'To Hoboken',614,601);
/*!40000 ALTER TABLE `line_direction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `reservationId` int NOT NULL AUTO_INCREMENT,
  `CustomerId` int DEFAULT NULL,
  `DepartureDateTime` datetime DEFAULT NULL,
  `OriginStationId` int DEFAULT NULL,
  `DestinationStationId` int DEFAULT NULL,
  `LineId` int DEFAULT NULL,
  `TrainId` int DEFAULT NULL,
  `FareTypeId` int DEFAULT NULL,
  `RoundTrip` tinyint(1) DEFAULT NULL,
  `CalculatedFare` double DEFAULT NULL,
  PRIMARY KEY (`reservationId`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,2,'2024-07-02 18:00:00',1,6,1,8193,1,0,8.333333333333334),(2,2,'2024-07-02 15:00:00',1,7,1,8587,1,1,7.142857142857143),(3,3,'2024-07-01 17:30:00',1,7,1,8527,1,0,7.142857142857143),(4,2,'2024-07-03 20:10:00',2,8,1,704,1,0,7.142857142857143),(5,2,'2024-07-11 18:30:00',1,4,1,5383,4,0,12.5),(6,3,'2024-07-01 20:00:00',1,12,1,704,1,0,4.166666666666667),(7,2,'2024-07-31 22:49:00',9,12,1,8019,1,0,12.5),(8,2,'2024-07-31 20:49:00',9,12,1,704,4,0,12.5),(9,6,'2024-07-01 20:40:00',2,9,1,6889,1,1,25),(10,2,'2024-07-02 23:01:00',1,7,1,3893,1,0,18.75);
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `StationId` int NOT NULL,
  `StationName` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  PRIMARY KEY (`StationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'New York Penn','New York','NY'),(2,'Secaucus Junction','Secaucus','NJ'),(3,'Newark Penn','Newark','NJ'),(4,'Newark Liberty Int.','Newark','NJ'),(5,'North Elizabeth','Elizabeth','NJ'),(6,'Elizabeth','Elizabeth','NJ'),(7,'Linden','Linden','NJ'),(8,'Rahway','Rahway','NJ'),(9,'Metropark','Iselin','NJ'),(10,'Metuchen','Metuchen','NJ'),(11,'Edison','Edison','NJ'),(12,'New Brunswick','New Brunswick','NJ'),(13,'Jersey Avenue','New Brunswick','NJ'),(14,'Princeton Junction','Princeton','NJ'),(15,'Hamilton','Hamilton Township','NJ'),(16,'Trenton','Trenton','NJ'),(201,'Bay Head','Bay Head','NJ'),(202,'Point Pleasant Beach','Point Pleasant Beach','NJ'),(203,'Manasquan','Manasquan','NJ'),(204,'Spring Lake','Spring Lake','NJ'),(205,'Belmar','Belmar','NJ'),(206,'Bradley Beach','Bradley Beach','NJ'),(207,'Avon','Avon','NJ'),(208,'Asbury Park','Asbury Park','NJ'),(209,'Allenhurst','Allenhurst','NJ'),(210,'Elberon','Elberon','NJ'),(211,'Long Branch','Long Branch','NJ'),(212,'Monmouth Park','Monmouth Park','NJ'),(213,'Little Silver','Little Silver','NJ'),(214,'Red Bank','Red Bank','NJ'),(215,'Middletown','Middletown','NJ'),(216,'Hazlet','Hazlet','NJ'),(217,'Aberdeen-Matawan','Aberdeen-Matawan','NJ'),(218,'South Amboy','South Amboy','NJ'),(219,'Perth Amboy','Perth Amboy','NJ'),(220,'Woodbridge','Woodbridge','NJ'),(221,'Avenel','Avenel','NJ'),(222,'Rahway','Rahway','NJ'),(223,'Linden','Linden','NJ'),(224,'Elizabeth','Elizabeth','NJ'),(225,'North Elizabeth','North Elizabeth','NJ'),(226,'Newark Airport','Newark Airport','NJ'),(227,'Newark Penn Station','Newark Penn Station','NJ'),(228,'Secaucus Junction','Secaucus Junction','NJ'),(229,'New York Penn Station','New York Penn Station','NY'),(301,'High Bridge','High Bridge','NJ'),(302,'Annandale','Annandale','NJ'),(303,'Lebanon','Lebanon','NJ'),(304,'White House','White House','NJ'),(305,'North Branch','North Branch','NJ'),(306,'Raritan','Raritan','NJ'),(307,'Somerville','Somerville','NJ'),(308,'Bridgewater','Bridgewater','NJ'),(309,'Bound Brook','Bound Brook','NJ'),(310,'Dunellen','Dunellen','NJ'),(311,'Plainfield','Plainfield','NJ'),(312,'Netherwood','Netherwood','NJ'),(313,'Fanwood','Fanwood','NJ'),(314,'Westfield','Westfield','NJ'),(315,'Garwood','Garwood','NJ'),(316,'Cranford','Cranford','NJ'),(317,'Roselle Park','Roselle Park','NJ'),(318,'Union','Union','NJ'),(319,'Newark Penn Station','Newark Penn Station','NJ'),(401,'Philadelphia 30th Street Station','Philadelphia','PA'),(402,'Cherry Hill','Cherry Hill','NJ'),(403,'Lindenwold','Lindenwold','NJ'),(404,'Atco','Atco','NJ'),(405,'Hammonton','Hammonton','NJ'),(406,'Egg Harbor City','Egg Harbor City','NJ'),(407,'Absecon','Absecon','NJ'),(408,'Atlantic City','Atlantic City','NJ'),(501,'Hoboken','Hoboken','NJ'),(502,'Secaucus Junction','Secaucus Junction','NJ'),(503,'Newark Broad Street','Newark Broad Street','NJ'),(504,'East Orange','East Orange','NJ'),(505,'Brick Church','Brick Church','NJ'),(506,'Orange','Orange','NJ'),(507,'South Orange','South Orange','NJ'),(508,'Mountain Station','Mountain Station','NJ'),(509,'Maplewood','Maplewood','NJ'),(510,'Millburn','Millburn','NJ'),(511,'Short Hills','Short Hills','NJ'),(512,'Summit','Summit','NJ'),(513,'Chatham','Chatham','NJ'),(514,'Madison','Madison','NJ'),(515,'Convent Station','Convent Station','NJ'),(516,'Morristown','Morristown','NJ'),(517,'Morris Plains','Morris Plains','NJ'),(518,'Mount Tabor','Mount Tabor','NJ'),(519,'Denville','Denville','NJ'),(520,'Dover','Dover','NJ'),(521,'Mount Arlington','Mount Arlington','NJ'),(522,'Lake Hopatcong','Lake Hopatcong','NJ'),(523,'Netcong','Netcong','NJ'),(524,'Mount Olive','Mount Olive','NJ'),(525,'Hackettstown','Hackettstown','NJ'),(601,'Hoboken','Hoboken','NJ'),(602,'Secaucus Junction','Secaucus Junction','NJ'),(603,'Ramsey-Route 17','Ramsey-Route 17','NJ'),(604,'Ramsey','Ramsey','NJ'),(605,'Mahwah','Mahwah','NJ'),(606,'Suffern','Suffern','NJ'),(607,'Sloatsburg','Sloatsburg','NJ'),(608,'Tuxedo','Tuxedo','NJ'),(609,'Harriman','Harriman','NJ'),(610,'Salisbury Mills','Salisbury Mills','NJ'),(611,'Campbell Hall','Campbell Hall','NJ'),(612,'Middletown','Middletown','NJ'),(613,'Otisville','Otisville','NJ'),(614,'Port Jervis','Port Jervis','NJ'),(701,'Hoboken','Hoboken','NJ'),(702,'Secaucus Junction','Secaucus Junction','NJ'),(703,'Newark Broad Street','Newark Broad Street','NJ'),(704,'East Orange','East Orange','NJ'),(705,'Brick Church','Brick Church','NJ'),(706,'Orange','Orange','NJ'),(707,'South Orange','South Orange','NJ'),(708,'Mountain Station','Mountain Station','NJ'),(709,'Maplewood','Maplewood','NJ'),(710,'Millburn','Millburn','NJ'),(711,'Short Hills','Short Hills','NJ'),(712,'Summit','Summit','NJ'),(713,'New Providence','New Providence','NJ'),(714,'Berkeley Heights','Berkeley Heights','NJ'),(715,'Murray Hill','Murray Hill','NJ'),(716,'Gillette','Gillette','NJ'),(717,'Stirling','Stirling','NJ'),(718,'Millington','Millington','NJ'),(719,'Lyons','Lyons','NJ'),(720,'Basking Ridge','Basking Ridge','NJ'),(721,'Bernardsville','Bernardsville','NJ'),(722,'Far Hills','Far Hills','NJ'),(723,'Peapack','Peapack','NJ'),(724,'Gladstone','Gladstone','NJ'),(801,'Hoboken','Hoboken','NJ'),(802,'Secaucus Junction','Secaucus Junction','NJ'),(803,'Newark Broad Street','Newark Broad Street','NJ'),(804,'Watsessing Avenue','Watsessing Avenue','NJ'),(805,'Bloomfield','Bloomfield','NJ'),(806,'Glen Ridge','Glen Ridge','NJ'),(807,'Bay Street','Bay Street','NJ'),(808,'Walnut Street','Walnut Street','NJ'),(809,'Watchung Avenue','Watchung Avenue','NJ'),(810,'Upper Montclair','Upper Montclair','NJ'),(811,'Mountain Avenue','Mountain Avenue','NJ'),(812,'Montclair Heights','Montclair Heights','NJ'),(813,'Montclair State University','Montclair State University','NJ'),(814,'Little Falls','Little Falls','NJ'),(815,'Wayne-Route 23 Transit Center','Wayne','NJ'),(816,'Mountain View','Mountain View','NJ'),(817,'Lincoln Park','Lincoln Park','NJ'),(818,'Towaco','Towaco','NJ'),(819,'Boonton','Boonton','NJ'),(820,'Mountain Lakes','Mountain Lakes','NJ'),(821,'Denville','Denville','NJ'),(822,'Dover','Dover','NJ'),(823,'Mount Tabor','Mount Tabor','NJ'),(824,'Morris Plains','Morris Plains','NJ'),(825,'Morristown','Morristown','NJ'),(826,'Convent Station','Convent Station','NJ'),(827,'Madison','Madison','NJ'),(828,'Chatham','Chatham','NJ'),(829,'Summit','Summit','NJ');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stop`
--

DROP TABLE IF EXISTS `stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stop` (
  `StopId` int NOT NULL,
  `LineId` int DEFAULT NULL,
  `StationId` int DEFAULT NULL,
  `StopOrder` int DEFAULT NULL,
  `MinutesFromLastStop` double DEFAULT NULL,
  `DirectionId` int DEFAULT NULL,
  PRIMARY KEY (`StopId`),
  KEY `LineId` (`LineId`),
  KEY `StationId` (`StationId`),
  CONSTRAINT `stop_ibfk_1` FOREIGN KEY (`LineId`) REFERENCES `line` (`LineId`),
  CONSTRAINT `stop_ibfk_2` FOREIGN KEY (`StationId`) REFERENCES `station` (`StationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stop`
--

LOCK TABLES `stop` WRITE;
/*!40000 ALTER TABLE `stop` DISABLE KEYS */;
INSERT INTO `stop` VALUES (1,1,1,1,0,1),(2,1,2,2,10,1),(3,1,3,3,10,1),(4,1,4,4,6,1),(5,1,5,5,4,1),(6,1,6,6,3,1),(7,1,7,7,6,1),(8,1,8,8,4,1),(9,1,9,9,6,1),(10,1,10,10,5,1),(11,1,11,11,5,1),(12,1,12,12,5,1),(13,1,13,13,6,1),(14,1,14,14,13,1),(15,1,15,15,9,1),(16,1,16,16,11,1),(17,1,16,1,0,2),(18,1,15,2,11,2),(19,1,14,3,9,2),(20,1,13,4,13,2),(21,1,12,5,6,2),(22,1,11,6,5,2),(23,1,10,7,5,2),(24,1,9,8,5,2),(25,1,8,9,6,2),(26,1,7,10,4,2),(27,1,6,11,6,2),(28,1,5,12,3,2),(29,1,4,13,4,2),(30,1,3,14,6,2),(31,1,2,15,10,2),(32,1,1,16,10,2),(33,6,201,1,0,1),(34,6,202,2,5,1),(35,6,203,3,5,1),(36,6,204,4,5,1),(37,6,205,5,5,1),(38,6,206,6,5,1),(39,6,207,7,5,1),(40,6,208,8,5,1),(41,6,209,9,5,1),(42,6,210,10,5,1),(43,6,211,11,5,1),(44,6,212,12,5,1),(45,6,213,13,5,1),(46,6,214,14,5,1),(47,6,215,15,5,1),(48,6,216,16,5,1),(49,6,217,17,5,1),(50,6,218,18,5,1),(51,6,219,19,5,1),(52,6,220,20,5,1),(53,6,221,21,5,1),(54,6,222,22,5,1),(55,6,223,23,5,1),(56,6,224,24,5,1),(57,6,225,25,5,1),(58,6,226,26,5,1),(59,6,227,27,5,1),(60,6,228,28,10,1),(61,6,229,29,15,1),(62,6,229,29,15,2),(63,6,228,28,10,2),(64,6,227,27,5,2),(65,6,226,26,5,2),(66,6,225,25,5,2),(67,6,224,24,5,2),(68,6,223,23,5,2),(69,6,222,22,5,2),(70,6,221,21,5,2),(71,6,220,20,5,2),(72,6,219,19,5,2),(73,6,218,18,5,2),(74,6,217,17,5,2),(75,6,216,16,5,2),(76,6,215,15,5,2),(77,6,214,14,5,2),(78,6,213,13,5,2),(79,6,212,12,5,2),(80,6,211,11,5,2),(81,6,210,10,5,2),(82,6,209,9,5,2),(83,6,208,8,5,2),(84,6,207,7,5,2),(85,6,206,6,5,2),(86,6,205,5,5,2),(87,6,204,4,5,2),(88,6,203,3,5,2),(89,6,202,2,5,2),(90,6,201,1,0,2),(91,7,301,1,0,1),(92,7,302,2,10,1),(93,7,303,3,10,1),(94,7,304,4,10,1),(95,7,305,5,10,1),(96,7,306,6,10,1),(97,7,307,7,5,1),(98,7,308,8,10,1),(99,7,309,9,10,1),(100,7,310,10,10,1),(101,7,311,11,10,1),(102,7,312,12,5,1),(103,7,313,13,5,1),(104,7,314,14,5,1),(105,7,315,15,5,1),(106,7,316,16,5,1),(107,7,317,17,5,1),(108,7,318,18,10,1),(109,7,319,19,20,1),(110,7,319,19,20,2),(111,7,318,18,10,2),(112,7,317,17,5,2),(113,7,316,16,5,2),(114,7,315,15,5,2),(115,7,314,14,5,2),(116,7,313,13,5,2),(117,7,312,12,5,2),(118,7,311,11,10,2),(119,7,310,10,10,2),(120,7,309,9,10,2),(121,7,308,8,10,2),(122,7,307,7,5,2),(123,7,306,6,10,2),(124,7,305,5,10,2),(125,7,304,4,10,2),(126,7,303,3,10,2),(127,7,302,2,10,2),(128,7,301,1,0,2),(129,2,401,1,0,1),(130,2,402,2,15,1),(131,2,403,3,10,1),(132,2,404,4,10,1),(133,2,405,5,15,1),(134,2,406,6,15,1),(135,2,407,7,10,1),(136,2,408,8,10,1),(137,2,408,1,0,2),(138,2,407,2,10,2),(139,2,406,3,10,2),(140,2,405,4,15,2),(141,2,404,5,15,2),(142,2,403,6,10,2),(143,2,402,7,10,2),(144,2,401,8,15,2),(145,4,501,1,0,1),(146,4,502,2,10,1),(147,4,503,3,10,1),(148,4,504,4,5,1),(149,4,505,5,5,1),(150,4,506,6,5,1),(151,4,507,7,5,1),(152,4,508,8,5,1),(153,4,509,9,5,1),(154,4,510,10,5,1),(155,4,511,11,5,1),(156,4,512,12,5,1),(157,4,513,13,5,1),(158,4,514,14,5,1),(159,4,515,15,5,1),(160,4,516,16,5,1),(161,4,517,17,5,1),(162,4,518,18,5,1),(163,4,519,19,5,1),(164,4,520,20,5,1),(165,4,521,21,5,1),(166,4,522,22,5,1),(167,4,523,23,5,1),(168,4,524,24,5,1),(169,4,525,24,5,1),(170,4,525,24,5,1),(171,4,524,24,5,2),(172,4,523,23,5,2),(173,4,522,22,5,2),(174,4,521,21,5,2),(175,4,520,20,5,2),(176,4,519,19,5,2),(177,4,518,18,5,2),(178,4,517,17,5,2),(179,4,516,16,5,2),(180,4,515,15,5,2),(181,4,514,14,5,2),(182,4,513,13,5,2),(183,4,512,12,5,2),(184,4,511,11,5,2),(185,4,510,10,5,2),(186,4,509,9,5,2),(187,4,508,8,5,2),(188,4,507,7,5,2),(189,4,506,6,5,2),(190,4,505,5,5,2),(191,4,504,4,5,2),(192,4,503,3,10,2),(193,4,502,2,10,2),(194,4,501,1,0,2),(195,8,601,1,0,1),(196,8,602,2,10,1),(197,8,603,3,15,1),(198,8,604,4,5,1),(199,8,605,5,5,1),(200,8,606,6,10,1),(201,8,607,7,5,1),(202,8,608,8,5,1),(203,8,609,9,10,1),(204,8,610,10,10,1),(205,8,611,11,10,1),(206,8,612,12,10,1),(207,8,613,13,10,1),(208,8,614,14,10,1),(209,8,614,1,0,2),(210,8,613,2,10,2),(211,8,612,3,10,2),(212,8,611,4,10,2),(213,8,610,5,10,2),(214,8,609,6,10,2),(215,8,608,7,5,2),(216,8,607,8,5,2),(217,8,606,9,5,2),(218,8,605,10,5,2),(219,8,604,11,5,2),(220,8,603,12,5,2),(221,8,602,13,15,2),(222,8,601,14,10,2),(223,5,701,1,0,1),(224,5,702,2,10,1),(225,5,703,3,10,1),(226,5,704,4,5,1),(227,5,705,5,5,1),(228,5,706,6,5,1),(229,5,707,7,5,1),(230,5,708,8,5,1),(231,5,709,9,5,1),(232,5,710,10,5,1),(233,5,711,11,5,1),(234,5,712,12,5,1),(235,5,713,13,5,1),(236,5,714,14,5,1),(237,5,715,15,5,1),(238,5,716,16,5,1),(239,5,717,17,5,1),(240,5,718,18,5,1),(241,5,719,19,5,1),(242,5,720,20,5,1),(243,5,721,21,5,1),(244,5,722,22,5,1),(245,5,723,23,5,1),(246,5,724,24,5,1),(247,5,724,1,0,2),(248,5,723,2,5,2),(249,5,722,3,5,2),(250,5,721,4,5,2),(251,5,720,5,5,2),(252,5,719,6,5,2),(253,5,718,7,5,2),(254,5,717,8,5,2),(255,5,716,9,5,2),(256,5,715,10,5,2),(257,5,714,11,5,2),(258,5,713,12,5,2),(259,5,712,13,5,2),(260,5,711,14,5,2),(261,5,710,15,5,2),(262,5,709,16,5,2),(263,5,708,17,5,2),(264,5,707,18,5,2),(265,5,706,19,5,2),(266,5,705,20,5,2),(267,5,704,21,5,2),(268,5,703,22,5,2),(269,5,702,23,10,2),(270,5,701,24,10,2),(271,3,801,1,0,1),(272,3,802,2,10,1),(273,3,803,3,10,1),(274,3,804,4,5,1),(275,3,805,5,5,1),(276,3,806,6,5,1),(277,3,807,7,5,1),(278,3,808,8,5,1),(279,3,809,9,5,1),(280,3,810,10,5,1),(281,3,811,11,5,1),(282,3,812,12,5,1),(283,3,813,13,5,1),(284,3,814,14,5,1),(285,3,815,15,5,1),(286,3,816,16,5,1),(287,3,817,17,5,1),(288,3,818,18,5,1),(289,3,819,19,5,1),(290,3,820,20,5,1),(291,3,821,21,5,1),(292,3,822,22,5,1),(293,3,823,23,5,1),(294,3,824,24,5,1),(295,3,825,25,5,1),(296,3,826,26,5,1),(297,3,827,27,5,1),(298,3,828,28,5,1),(299,3,829,29,5,1),(300,3,829,29,5,2),(301,3,828,28,5,2),(302,3,827,27,5,2),(303,3,826,26,5,2),(304,3,825,25,5,2),(305,3,824,24,5,2),(306,3,823,23,5,2),(307,3,822,22,5,2),(308,3,821,21,5,2),(309,3,820,20,5,2),(310,3,819,19,5,2),(311,3,818,18,5,2),(312,3,817,17,5,2),(313,3,816,16,5,2),(314,3,815,15,5,2),(315,3,814,14,5,2),(316,3,813,13,5,2),(317,3,812,12,5,2),(318,3,811,11,5,2),(319,3,810,10,5,2),(320,3,809,9,5,2),(321,3,808,8,5,2),(322,3,807,7,5,2),(323,3,806,6,5,2),(324,3,805,5,5,2),(325,3,804,4,5,2),(326,3,803,3,10,2),(327,3,802,2,10,2),(328,3,801,1,0,2);
/*!40000 ALTER TABLE `stop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `TrainId` int NOT NULL,
  `TrainNumber` int DEFAULT NULL,
  `DepartureTime` time DEFAULT NULL,
  `LineId` int DEFAULT NULL,
  `DirectionId` int DEFAULT NULL,
  PRIMARY KEY (`TrainId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES (1,3801,'00:01:00',1,1),(2,3805,'01:01:00',1,1),(3,3809,'02:01:00',1,1),(4,3813,'03:01:00',1,1),(5,3817,'04:01:00',1,1),(6,3821,'05:01:00',1,1),(7,3825,'06:01:00',1,1),(8,3829,'07:01:00',1,1),(9,3833,'08:01:00',1,1),(10,3837,'09:01:00',1,1),(11,3841,'10:01:00',1,1),(12,3845,'11:01:00',1,1),(13,3849,'12:01:00',1,1),(14,3853,'13:01:00',1,1),(15,3857,'14:01:00',1,1),(16,3861,'15:01:00',1,1),(17,3865,'16:01:00',1,1),(18,3869,'17:01:00',1,1),(19,3873,'18:01:00',1,1),(20,3877,'19:01:00',1,1),(21,3881,'20:01:00',1,1),(22,3885,'21:01:00',1,1),(23,3889,'22:01:00',1,1),(24,3893,'23:01:00',1,1),(25,3902,'00:01:00',1,2),(26,3906,'01:01:00',1,2),(27,3910,'02:01:00',1,2),(28,3914,'03:01:00',1,2),(29,3918,'04:01:00',1,2),(30,3922,'05:01:00',1,2),(31,3926,'06:01:00',1,2),(32,3930,'07:01:00',1,2),(33,3934,'08:01:00',1,2),(34,3938,'09:01:00',1,2),(35,3942,'10:01:00',1,2),(36,3946,'11:01:00',1,2),(37,3950,'12:01:00',1,2),(38,3954,'13:01:00',1,2),(39,3958,'14:01:00',1,2),(40,3962,'15:01:00',1,2),(41,3966,'16:01:00',1,2),(42,3970,'17:01:00',1,2),(43,3974,'18:01:00',1,2),(44,3978,'19:01:00',1,2),(45,3982,'20:01:00',1,2),(46,3986,'21:01:00',1,2),(47,3990,'22:01:00',1,2),(48,3994,'23:01:00',1,2);
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-16 22:55:04
