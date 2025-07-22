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
-- Table structure for table `asset`
--

DROP TABLE IF EXISTS `asset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset` (
  `id` int NOT NULL AUTO_INCREMENT,
  `asset_id` int NOT NULL,
  `asset_name` varchar(45) NOT NULL,
  `category` enum('Laptop','Book','Projector','Lab Tool','Audio-Visual','Entertainment') NOT NULL,
  `description` longtext,
  `location` varchar(45) NOT NULL,
  `status` enum('Available','Onholded','Borrowed','Disabled') NOT NULL,
  `asset_image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_id_UNIQUE` (`asset_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset`
--

LOCK TABLES `asset` WRITE;
/*!40000 ALTER TABLE `asset` DISABLE KEYS */;
INSERT INTO `asset` VALUES (8,293361,'TypeScript 2','Book','Basic Programming Book for all student','D1','Disabled','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/Ch06_6531501234.png_169b9011-f6cc-4ceb-aa35-8e86a05da582'),(9,32305,'Python Programming 2','Book','Basic Programming Book for everyone','Library','Available','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/pythonbookimage.jpeg_97b853eb-201c-4ef5-a859-df9e189cfc69'),(10,63179,'Modern C Programming','Book','OOP Programming Book ','MFU Library','Available','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/images.jpeg_6fdbb139-929e-4d85-b20b-55d2bdf07bec'),(11,514924,'Mac Book Pro','Laptop','Mac Book Pro M3/ RAM-16GB/ ROM-512GB','MFU Library','Available','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/download_(1).jpeg_38cec714-f0b7-4153-af1d-c0efae76223b'),(12,949403,'Sony earphones','Audio-Visual','Earphones for all purposes','MFU Library','Available','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/download_(2).jpeg_61d032ec-be46-43f9-90fa-a9954368d2d5'),(13,382173,'Lenovo Yoga Slim','Laptop','Intel Corei-7(9th Gen)/ RAM -16GB','MFU Library','Available','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/shopping.webp_6336dc3b-9121-4700-b60d-4ffcae7403da'),(14,446276,'Encanto','Entertainment','Disney animation Movie','MFU Library','Onholded','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/download_(3).jpeg_7cf6c765-8831-4623-9016-c44b9401cb7c'),(15,552095,'Encanto 2','Entertainment','Disney animation Movie','MFU Library','Onholded','https://res.cloudinary.com/dndkxuzes/image/upload/q_auto/f_auto/v1/MFU%20BORROW/assets/download_(3).jpeg_42e7c346-3f50-4ba6-8918-8edc8bc5da16');
/*!40000 ALTER TABLE `asset` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-06 11:43:18
