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
INSERT INTO `employee` VALUES (0,'000-00-0000','Instructor','Wonderful','admin','admin','Admin');
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
INSERT INTO `line` VALUES (1,'Northeast Corridor',1,16,50);
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
INSERT INTO `line_direction` VALUES (1,1,'To Penn Station NY',1,16),(1,2,'To Trenton NJ',16,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,2,'2024-07-02 18:00:00',1,6,1,8193,1,0,8.333333333333334),(2,2,'2024-07-02 15:00:00',1,7,1,8587,1,1,7.142857142857143),(3,3,'2024-07-01 17:30:00',1,7,1,8527,1,0,7.142857142857143),(4,2,'2024-07-03 20:10:00',2,8,1,704,1,0,7.142857142857143),(5,2,'2024-07-11 18:30:00',1,4,1,5383,4,0,12.5),(6,3,'2024-07-01 20:00:00',1,12,1,704,1,0,4.166666666666667),(7,2,'2024-07-31 22:49:00',9,12,1,8019,1,0,12.5),(8,2,'2024-07-31 20:49:00',9,12,1,704,4,0,12.5),(9,6,'2024-07-01 20:40:00',2,9,1,6889,1,1,25);
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
INSERT INTO `station` VALUES (1,'New York Penn','New York','NY'),(2,'Secaucus Junction','Secaucus','NJ'),(3,'Newark Penn','Newark','NJ'),(4,'Newark Liberty Int.','Newark','NJ'),(5,'North Elizabeth','Elizabeth','NJ'),(6,'Elizabeth','Elizabeth','NJ'),(7,'Linden','Linden','NJ'),(8,'Rahway','Rahway','NJ'),(9,'Metropark','Iselin','NJ'),(10,'Metuchen','Metuchen','NJ'),(11,'Edison','Edison','NJ'),(12,'New Brunswick','New Brunswick','NJ'),(13,'Jersey Avenue','New Brunswick','NJ'),(14,'Princeton Junction','Princeton','NJ'),(15,'Hamilton','Hamilton Township','NJ'),(16,'Trenton','Trenton','NJ');
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
INSERT INTO `stop` VALUES (1,1,1,1,0,1),(2,1,2,2,10,1),(3,1,3,3,10,1),(4,1,4,4,6,1),(5,1,5,5,4,1),(6,1,6,6,3,1),(7,1,7,7,6,1),(8,1,8,8,4,1),(9,1,9,9,6,1),(10,1,10,10,5,1),(11,1,11,11,5,1),(12,1,12,12,5,1),(13,1,13,13,6,1),(14,1,14,14,13,1),(15,1,15,15,9,1),(16,1,16,16,11,1),(17,1,16,1,0,2),(18,1,15,2,11,2),(19,1,14,3,9,2),(20,1,13,4,13,2),(21,1,12,5,6,2),(22,1,11,6,5,2),(23,1,10,7,5,2),(24,1,9,8,5,2),(25,1,8,9,6,2),(26,1,7,10,4,2),(27,1,6,11,6,2),(28,1,5,12,3,2),(29,1,4,13,4,2),(30,1,3,14,6,2),(31,1,2,15,10,2),(32,1,1,16,10,2);
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

-- Dump completed on 2024-07-15 19:04:49
