CREATE DATABASE  IF NOT EXISTS `cs336project`; 
USE `cs336project`;


DROP TABLE IF EXISTS `qanda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qanda` (
`QID` int NOT NULL,
`CustomerId` int DEFAULT NULL,
`EmployeeId` int DEFAULT NULL,
  `question` varchar(200) NOT NULL,
  `answer` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`QID`),
  CONSTRAINT `fk_customer` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`CustomerId`),
  CONSTRAINT `fk_employee` FOREIGN KEY (`EmployeeId`) REFERENCES `employee` (`EmployeeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


LOCK TABLES `qanda` WRITE;

INSERT INTO `qanda` VALUES (1,1,1,'when do trains start to run','trains start to run at 6:00 AM'),(2,1,1,'how long is the longest ride','the longest ride is 12 hours'),(3,1,NULL,'how long is the train stop?',NULL);

UNLOCK TABLES;
