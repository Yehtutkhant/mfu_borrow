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
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `role` enum('student','lecturer','staff') NOT NULL,
  `student_id` varchar(10) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `student_id_UNIQUE` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'lonelone','6531591234@lamduan.mfu.ac.th','$2b$10$ygLMRMCUk/H98t0dDjlXNOSoH7nbhO7bDuFO/AprYH/TXBs63FPmC',NULL,'student','6531591234'),(3,'lonelone','6531591233@lamduan.mfu.ac.th','$2b$10$B6wZ0hhJKbWWYX33yHHmrO/wCs4cYWfRo3dMc5buK6hS0rmR9X7Qm',NULL,'student','6f31591234'),(4,'lonelone','6531591237@lamduan.mfu.ac.th','$2b$10$MGt4VHjhhTgCsHhQUe0XHOvyhbmwbaf95va1oBrTBON.Ay5u.SfeS',NULL,'student','6531591237'),(5,'mike123','mike@lamduan.mfu.ac.th','$2b$10$/lrABEC4.Rm8x/aJqCrh7unU10ExW4GqRzhLcXhb1SiUVOwpUhh4m',NULL,'lecturer','6531591244'),(6,'lisa123','lisa@lamduan.mfu.ac.th','$2b$10$koXoLEgDB0ez/twjKRWmvuLBPS3z2ef4QioyMtIrDQoIVHAhI.G1G',NULL,'staff','6531591248'),(7,'andy129','andy125@lamduan.mfu.ac.th','$2b$10$f69R4bn10APWIISK2Ts0e.cV25No1K9ZEoQ5UsnNGgWnQ2imMcmf2','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/profiles/download_(3).jpeg_3140325a-7a35-4e14-b0a8-dfdbe171b94f','student','6631500005'),(8,'andy','andy@lamduan.mfu.ac.th','$2b$10$nWeQteryU7EfKkIsD0zdoOD/ECUmIO1m7hXTOYKIuReEY/CALJyWa',NULL,'student','6531501256'),(9,'paul','paul@lamduan.mfu.ac.th','$2b$10$jhQ3nNNDptuwzmIjiK/EdOPu1FPn0fuBPukoKkHyUFhMzaLIeyR6y',NULL,'student','6531501257'),(10,'paulin','paulin@lamduan.mfu.ac.th','$2b$10$nt9KUVdU8mCOXC.ObdKt4.lTXXczGqFihYg3GKVlf5VN.MHivV5eW',NULL,'student','6531501259'),(11,'pal','paulin1@lamduan.mfu.ac.th','$2b$10$ScgOI2/s7T4odFfEm7tJpuzHit7Tbd7r4/maFSXR5OSjVAESYOUKO',NULL,'student','6531501200');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
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
