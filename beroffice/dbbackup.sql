-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: itbackup
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `backup_path`
--

DROP TABLE IF EXISTS `backup_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backup_path` (
  `UID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `server_UID` bigint(20) NOT NULL,
  `backupname` varchar(64) NOT NULL,
  `backup_drive` varchar(32) NOT NULL,
  `storage_period` enum('2','3','4','5','6','7','8','9','10','11','12') DEFAULT '2',
  `cycle` enum('daily','weekly','monthly') DEFAULT 'daily',
  `cycle_val` int(2) NOT NULL,
  `status` enum('enable','disable') DEFAULT 'disable',
  `backup_target` varchar(256) NOT NULL,
  PRIMARY KEY (`UID`),
  KEY `server_UID` (`server_UID`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_path`
--

LOCK TABLES `backup_path` WRITE;
/*!40000 ALTER TABLE `backup_path` DISABLE KEYS */;
INSERT INTO `backup_path` VALUES (1,1,'TEST1','/','2','daily',25,'disable','/home/itadmin/test/');
/*!40000 ALTER TABLE `backup_path` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_server_list`
--

DROP TABLE IF EXISTS `backup_server_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backup_server_list` (
  `UID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `server_name` varchar(32) NOT NULL,
  `server_ip` varchar(32) NOT NULL,
  `server_group` enum('IT','DATA') DEFAULT 'IT',
  `server_OS` enum('Windows','Linux') DEFAULT 'Windows',
  `server_id` varchar(32) NOT NULL,
  `server_pw` varchar(256) NOT NULL,
  `server_status` enum('enable','disable') DEFAULT 'disable',
  `server_region` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_server_list`
--

LOCK TABLES `backup_server_list` WRITE;
/*!40000 ALTER TABLE `backup_server_list` DISABLE KEYS */;
INSERT INTO `backup_server_list` VALUES (1,'dc-l1-backup','172.16.0.64','IT','Linux','-','-','disable','region');
/*!40000 ALTER TABLE `backup_server_list` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-18  9:45:56
