-- MySQL dump 10.13  Distrib 8.0.34, for macos13 (arm64)
--
-- Host: localhost    Database: mfu_borrow
-- ------------------------------------------------------
-- Server version	8.1.0

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
-- Table structure for table `borrow`
--

DROP TABLE IF EXISTS `borrow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrow` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `asset_id` int NOT NULL,
  `validator_id` int DEFAULT NULL,
  `borrow_date` datetime NOT NULL,
  `return_date` datetime NOT NULL,
  `validated_date` datetime DEFAULT NULL,
  `request_note` longtext,
  `status` enum('Pending','Approved','Disapproved','Canceled','Returned') NOT NULL,
  `requested_at` datetime NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id`),
  KEY `request_student_id_idx` (`student_id`),
  KEY `request_asset_id_idx` (`asset_id`),
  KEY `request_validtor_id_idx` (`validator_id`),
  CONSTRAINT `request_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `request_student_id` FOREIGN KEY (`student_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `request_validtor_id` FOREIGN KEY (`validator_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow`
--

LOCK TABLES `borrow` WRITE;
/*!40000 ALTER TABLE `borrow` DISABLE KEYS */;
INSERT INTO `borrow` VALUES (3,1,10,4,'2024-11-02 00:00:00','2024-11-09 00:00:00',NULL,'For group assignment','Pending','2024-11-02 00:00:00'),(5,3,11,4,'2024-11-02 00:00:00','2024-11-10 00:00:00',NULL,'For group project','Pending','2024-11-02 00:00:00'),(6,1,9,4,'2024-11-01 00:00:00','2024-11-10 00:00:00',NULL,NULL,'Approved','2024-11-01 00:00:00'),(7,1,11,4,'2024-10-28 00:00:00','2024-11-02 00:00:00',NULL,NULL,'Pending','2024-10-28 00:00:00'),(11,1,10,3,'2024-10-25 00:00:00','2024-11-02 00:00:00',NULL,NULL,'Returned','2024-10-25 00:00:00'),(12,1,10,4,'2024-11-01 00:00:00','2024-11-05 00:00:00',NULL,NULL,'Disapproved','2024-11-01 00:00:00'),(13,3,8,4,'2024-10-26 00:00:00','2024-10-29 00:00:00',NULL,NULL,'Disapproved','2024-10-26 00:00:00'),(14,1,9,4,'2024-10-31 00:00:00','2024-11-04 00:00:00',NULL,NULL,'Approved','2024-10-31 00:00:00'),(15,4,12,6,'2024-11-03 00:00:00','2024-11-12 00:00:00',NULL,'For group project','Returned','2024-11-02 00:00:00'),(16,7,12,5,'2024-11-04 00:00:00','2024-11-12 00:00:00','2024-11-02 15:33:09','For group project','Returned','2024-11-02 00:00:00'),(17,8,13,5,'2024-11-05 00:00:00','2024-11-10 00:00:00','2024-11-02 15:39:16','For group project','Disapproved','2024-11-02 00:00:00'),(18,9,14,5,'2024-11-03 00:00:00','2024-11-04 00:00:00','2024-11-02 16:58:39','For leisure','Returned','2024-11-02 00:00:00'),(19,9,14,NULL,'2024-11-05 00:00:00','2024-11-09 00:00:00',NULL,'For leisure','Canceled','2024-11-02 00:00:00'),(20,9,14,5,'2024-11-05 00:00:00','2024-11-09 00:00:00','2024-11-02 16:58:39','For research','Approved','2024-11-02 16:58:39'),(21,9,14,5,'2024-10-19 00:00:00','2024-10-23 00:00:00','2024-10-20 16:58:39','For assignment','Disapproved','2024-10-19 00:00:00'),(22,9,13,NULL,'2024-11-06 00:00:00','2024-11-09 00:00:00',NULL,'For group work','Pending','2024-11-06 00:00:00'),(23,9,11,5,'2024-11-01 00:00:00','2024-11-03 00:00:00','2024-11-01 16:58:39','For assignment','Approved','2024-11-01 00:00:00'),(24,9,10,5,'2024-10-10 00:00:00','2024-10-13 00:00:00','2024-10-10 00:00:00','For assignment','Returned','2024-10-10 00:00:00'),(25,9,14,NULL,'2024-11-05 00:00:00','2024-11-09 00:00:00',NULL,'For leisure','Pending','2024-11-05 00:00:00'),(26,8,15,NULL,'2024-11-06 00:00:00','2024-11-10 00:00:00',NULL,'For leisure','Pending','2024-11-06 00:00:00');
/*!40000 ALTER TABLE `borrow` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-06 11:43:17
