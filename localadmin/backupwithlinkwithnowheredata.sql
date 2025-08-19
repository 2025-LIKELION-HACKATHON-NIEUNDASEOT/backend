-- MySQL dump 10.13  Distrib 9.4.0, for Win64 (x86_64)
--
-- Host: localhost    Database: villit
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add 카테고리',7,'add_category'),(26,'Can change 카테고리',7,'change_category'),(27,'Can delete 카테고리',7,'delete_category'),(28,'Can view 카테고리',7,'view_category'),(29,'Can add 사용자',8,'add_user'),(30,'Can change 사용자',8,'change_user'),(31,'Can delete 사용자',8,'delete_user'),(32,'Can view 사용자',8,'view_user'),(33,'Can add 사용자 관심 지역',9,'add_userregion'),(34,'Can change 사용자 관심 지역',9,'change_userregion'),(35,'Can delete 사용자 관심 지역',9,'delete_userregion'),(36,'Can view 사용자 관심 지역',9,'view_userregion'),(37,'Can add 사용자 관심 주제',10,'add_usercategory'),(38,'Can change 사용자 관심 주제',10,'change_usercategory'),(39,'Can delete 사용자 관심 주제',10,'delete_usercategory'),(40,'Can view 사용자 관심 주제',10,'view_usercategory'),(41,'Can add 챗봇 메시지',11,'add_chatbotmessage'),(42,'Can change 챗봇 메시지',11,'change_chatbotmessage'),(43,'Can delete 챗봇 메시지',11,'delete_chatbotmessage'),(44,'Can view 챗봇 메시지',11,'view_chatbotmessage'),(45,'Can add 챗봇 세션',12,'add_chatbotsession'),(46,'Can change 챗봇 세션',12,'change_chatbotsession'),(47,'Can delete 챗봇 세션',12,'delete_chatbotsession'),(48,'Can view 챗봇 세션',12,'view_chatbotsession'),(49,'Can add 챗봇 스크랩',13,'add_chatbotscrap'),(50,'Can change 챗봇 스크랩',13,'change_chatbotscrap'),(51,'Can delete 챗봇 스크랩',13,'delete_chatbotscrap'),(52,'Can view 챗봇 스크랩',13,'view_chatbotscrap'),(53,'Can add 공문 스크랩',14,'add_documentscrap'),(54,'Can change 공문 스크랩',14,'change_documentscrap'),(55,'Can delete 공문 스크랩',14,'delete_documentscrap'),(56,'Can view 공문 스크랩',14,'view_documentscrap'),(57,'Can add 공문',15,'add_document'),(58,'Can change 공문',15,'change_document'),(59,'Can delete 공문',15,'delete_document'),(60,'Can view 공문',15,'view_document'),(61,'Can add region',16,'add_region'),(62,'Can change region',16,'change_region'),(63,'Can delete region',16,'delete_region'),(64,'Can view region',16,'view_region'),(65,'Can add 알림',17,'add_notification'),(66,'Can change 알림',17,'change_notification'),(67,'Can delete 알림',17,'delete_notification'),(68,'Can view 알림',17,'view_notification'),(69,'Can add FCM 디바이스',18,'add_fcmdevice'),(70,'Can change FCM 디바이스',18,'change_fcmdevice'),(71,'Can delete FCM 디바이스',18,'delete_fcmdevice'),(72,'Can view FCM 디바이스',18,'view_fcmdevice');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$600000$NLpGC6kOBzblM7vEWpO1qq$cZ5qxSkphB4hEnBABzo3+WsKqnFUbr/ppfV9JNrfW/M=','2025-08-15 11:44:28.469625',1,'admin','','','admin@naver.com',1,1,'2025-08-15 11:44:18.150009');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'교통',1),(2,'문화',1),(3,'주택',1),(4,'경제',1),(5,'환경',1),(6,'안전',1),(7,'복지',1),(8,'행정',1),(9,'일반',1);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_message`
--

DROP TABLE IF EXISTS `chatbot_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_message` (
  `created_at` datetime(6) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `speaker` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `chatbot_session_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chatbot_message_chatbot_session_id_e54b841a_fk_chatbot_s` (`chatbot_session_id`),
  CONSTRAINT `chatbot_message_chatbot_session_id_e54b841a_fk_chatbot_s` FOREIGN KEY (`chatbot_session_id`) REFERENCES `chatbot_session` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_message`
--

LOCK TABLES `chatbot_message` WRITE;
/*!40000 ALTER TABLE `chatbot_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_scrap`
--

DROP TABLE IF EXISTS `chatbot_scrap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_scrap` (
  `created_at` datetime(6) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `summary` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ai_message_id` int NOT NULL,
  `chatbot_session_id` int NOT NULL,
  `user_id` bigint NOT NULL,
  `user_message_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chatbot_scrap_user_id_user_message_id__00a6e82d_uniq` (`user_id`,`user_message_id`,`ai_message_id`),
  KEY `chatbot_scrap_ai_message_id_3f5f6179_fk_chatbot_message_id` (`ai_message_id`),
  KEY `chatbot_scrap_chatbot_session_id_934bc3ca_fk_chatbot_session_id` (`chatbot_session_id`),
  KEY `chatbot_scrap_user_message_id_71c23f6b_fk_chatbot_message_id` (`user_message_id`),
  CONSTRAINT `chatbot_scrap_ai_message_id_3f5f6179_fk_chatbot_message_id` FOREIGN KEY (`ai_message_id`) REFERENCES `chatbot_message` (`id`),
  CONSTRAINT `chatbot_scrap_chatbot_session_id_934bc3ca_fk_chatbot_session_id` FOREIGN KEY (`chatbot_session_id`) REFERENCES `chatbot_session` (`id`),
  CONSTRAINT `chatbot_scrap_user_id_30767458_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `chatbot_scrap_user_message_id_71c23f6b_fk_chatbot_message_id` FOREIGN KEY (`user_message_id`) REFERENCES `chatbot_message` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_scrap`
--

LOCK TABLES `chatbot_scrap` WRITE;
/*!40000 ALTER TABLE `chatbot_scrap` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_scrap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_scrap_categories`
--

DROP TABLE IF EXISTS `chatbot_scrap_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_scrap_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `chatbotscrap_id` int NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chatbot_scrap_categories_chatbotscrap_id_category_7c3361ad_uniq` (`chatbotscrap_id`,`category_id`),
  KEY `chatbot_scrap_categories_category_id_432343df_fk_category_id` (`category_id`),
  CONSTRAINT `chatbot_scrap_catego_chatbotscrap_id_6df95f70_fk_chatbot_s` FOREIGN KEY (`chatbotscrap_id`) REFERENCES `chatbot_scrap` (`id`),
  CONSTRAINT `chatbot_scrap_categories_category_id_432343df_fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_scrap_categories`
--

LOCK TABLES `chatbot_scrap_categories` WRITE;
/*!40000 ALTER TABLE `chatbot_scrap_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_scrap_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_session`
--

DROP TABLE IF EXISTS `chatbot_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_session` (
  `created_at` datetime(6) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) DEFAULT NULL,
  `document_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `document_id` (`document_id`),
  UNIQUE KEY `chatbot_session_user_id_document_id_516732f0_uniq` (`user_id`,`document_id`),
  CONSTRAINT `chatbot_session_document_id_7edb6837_fk_document_document_id` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`),
  CONSTRAINT `chatbot_session_user_id_36114853_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_session`
--

LOCK TABLES `chatbot_session` WRITE;
/*!40000 ALTER TABLE `chatbot_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2025-08-15 12:14:04.352713','1040','[공지] 2025 도봉 여름 와글와글 물놀이장 임시휴장 안내',2,'[{\"changed\": {\"fields\": [\"\\ub9c8\\uac10\\uc77c\"]}}]',15,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(11,'chatbot','chatbotmessage'),(12,'chatbot','chatbotsession'),(5,'contenttypes','contenttype'),(15,'document','document'),(18,'notification','fcmdevice'),(17,'notification','notification'),(16,'region','region'),(13,'scrap','chatbotscrap'),(14,'scrap','documentscrap'),(6,'sessions','session'),(7,'user','category'),(8,'user','user'),(10,'user','usercategory'),(9,'user','userregion');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-08-12 10:05:52.389945'),(2,'auth','0001_initial','2025-08-12 10:05:53.127708'),(3,'admin','0001_initial','2025-08-12 10:05:53.356288'),(4,'admin','0002_logentry_remove_auto_add','2025-08-12 10:05:53.368700'),(5,'admin','0003_logentry_add_action_flag_choices','2025-08-12 10:05:53.384876'),(6,'contenttypes','0002_remove_content_type_name','2025-08-12 10:05:53.563157'),(7,'auth','0002_alter_permission_name_max_length','2025-08-12 10:05:53.641665'),(8,'auth','0003_alter_user_email_max_length','2025-08-12 10:05:53.678412'),(9,'auth','0004_alter_user_username_opts','2025-08-12 10:05:53.691585'),(10,'auth','0005_alter_user_last_login_null','2025-08-12 10:05:53.785118'),(11,'auth','0006_require_contenttypes_0002','2025-08-12 10:05:53.791311'),(12,'auth','0007_alter_validators_add_error_messages','2025-08-12 10:05:53.803770'),(13,'auth','0008_alter_user_username_max_length','2025-08-12 10:05:53.910414'),(14,'auth','0009_alter_user_last_name_max_length','2025-08-12 10:05:54.016429'),(15,'auth','0010_alter_group_name_max_length','2025-08-12 10:05:54.047326'),(16,'auth','0011_update_proxy_permissions','2025-08-12 10:05:54.058902'),(17,'auth','0012_alter_user_first_name_max_length','2025-08-12 10:05:54.144130'),(18,'region','0001_initial','2025-08-12 10:05:54.284204'),(19,'region','0002_alter_region_options_remove_region_code_and_more','2025-08-12 10:05:54.776635'),(20,'region','0003_alter_region_city_alter_region_district_and_more','2025-08-12 10:05:54.804300'),(21,'user','0001_initial','2025-08-12 10:05:55.200785'),(22,'document','0001_initial','2025-08-12 10:05:55.260083'),(23,'chatbot','0001_initial','2025-08-12 10:05:55.300248'),(24,'chatbot','0002_initial','2025-08-12 10:05:55.368048'),(25,'chatbot','0003_initial','2025-08-12 10:05:55.552079'),(26,'document','0002_initial','2025-08-12 10:05:55.748635'),(27,'scrap','0001_initial','2025-08-12 10:05:55.859847'),(28,'scrap','0002_initial','2025-08-12 10:05:56.464862'),(29,'sessions','0001_initial','2025-08-12 10:05:56.515151'),(30,'document','0003_document_keywords_document_purpose_and_more','2025-08-15 05:54:56.441379'),(31,'notification','0001_initial','2025-08-15 05:54:56.886158'),(32,'notification','0002_alter_notification_content','2025-08-15 05:54:56.968521'),(33,'scrap','0003_alter_chatbotscrap_summary','2025-08-15 05:54:56.985137'),(34,'scrap','0004_alter_chatbotscrap_summary','2025-08-15 05:54:57.003147'),(35,'document','0004_document_summary','2025-08-15 08:34:43.975146'),(36,'document','0005_document_link_url','2025-08-17 10:12:00.669671');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('kb48in5pva6i83zb7lh1y4pgt5iaarfc','.eJxVjEEOwiAURO_C2hCg8KEu3fcM5AMfqRpISrsy3t026UJ3k3lv5s08bmvxW6fFz4ldmWSX3y5gfFI9QHpgvTceW12XOfBD4SftfGqJXrfT_Tso2Mu-Bm2Nsw41ksIcYnJK26jGNGLIANYEEaRAIcAOBqKkDASD22O2JFVmny_ilTfd:1umsrE:VmMzfBFpIrS9UiCvYP6fgbRYdhQtpTA3aE9mOTStT_4','2025-08-29 11:44:28.485553');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document` (
  `created_at` datetime(6) NOT NULL,
  `document_id` int NOT NULL AUTO_INCREMENT,
  `doc_title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `doc_content` longtext COLLATE utf8mb4_unicode_ci,
  `doc_type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pub_date` datetime(6) NOT NULL,
  `dead_date` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `region_id` int NOT NULL,
  `image_url` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keywords` longtext COLLATE utf8mb4_unicode_ci,
  `purpose` longtext COLLATE utf8mb4_unicode_ci,
  `related_departments` longtext COLLATE utf8mb4_unicode_ci,
  `summary` longtext COLLATE utf8mb4_unicode_ci,
  `link_url` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`document_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1239 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document`
--

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
INSERT INTO `document` VALUES ('2025-08-12 10:24:35.231582',1,'2025 하반기 도시농업교육 「매력텃밭교실」모집 안내','2025하반기 도시농업교육「매력텃밭교실」수강생 모집 안내도봉구민 대상으로 허브를 활용한 먹거리,차 등을 만들고 힐링교육을 실시하는「매력텃밭교실」을 다음과 같이 모집합니다.1.교 육 명: 2025년 매력텃밭교실2.대 상:도봉구 주민3.신청기간:2025. 8. 18.(월) 10:00∼마감시까지4.교육기간:2025. 9. 12. ~ 10. 17. (매주 금10시','PARTICIPATION','2025-08-11 07:46:00.000000',NULL,1,6,NULL,'도시농업, 텃밭교실, 허브, 힐링교육, 도봉구','도봉구민 대상 허브 활용 도시농업 교육 프로그램인 \'매력텃밭교실\' 수강생 모집','도봉구청','도봉구 주민을 대상으로 허브를 활용한 먹거리, 차 만들기 및 힐링 교육을 제공하는 \'매력텃밭교실\' 수강생을 모집합니다. 신청기간은 2025년 8월 18일(월) 10시부터 마감 시까지이며, 교육기간은 2025년 9월 12일부터 10월 17일까지 매주 금요일 10시에 진행됩니다.','https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737639&code=10008769'),('2025-08-12 10:24:35.270296',2,'2025 하반기 도시농업교육 「슈퍼푸드 쿠킹클래스」모집 안내','2025하반기 도시농업교육「슈퍼푸드 쿠킹 클래스」수강생 모집 안내도봉구민 대상으로 계절에 맞는 작물을 특성에 따라 활용하여 요리하는「슈퍼푸드 쿠킹 클래스」수강생을 다음과 같이 모집합니다.1.교 육 명:슈퍼푸드 쿠킹 클래스2.대 상:도봉구 주민3.신청기간:2025. 8. 18.(월) 10:00∼8. 27.(수) 18:004.교육기간:2025. 9. 5. ~','PARTICIPATION','2025-08-11 07:43:00.000000',NULL,1,6,NULL,'도시농업, 쿠킹클래스, 슈퍼푸드, 교육, 수강생 모집, 도봉구','도봉구민을 대상으로 계절 작물을 활용한 요리 교육인 슈퍼푸드 쿠킹 클래스 수강생을 모집하는 안내','도봉구청','도봉구 주민을 대상으로 하는 슈퍼푸드 쿠킹 클래스 수강생을 모집합니다. 신청기간은 2025년 8월 18일(월) 10시부터 8월 27일(수) 18시까지이며, 교육기간은 2025년 9월 5일부터입니다.','https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737638&code=10008769'),('2025-08-12 10:24:35.278414',3,'2025 하반기 도시농업교육 「팜시티 아카데미」모집 안내','2025하반기 도시농업교육「팜시티 아카데미」수강생 모집 안내도봉구민 대상으로 계절에 맞는 식물 식재 및 도시농업의 다양한 측면에 대한 교육을 실시하는「팜시티 아카데미」를 다음과 같이 모집합니다.1.교 육 명:팜시티 아카데미2.대 상:도봉구 주민3.신청기간:2025. 8. 18.(월) 10:00∼8. 27.(수) 18:004.교육기간:2025. 9. 4. ~','PARTICIPATION','2025-08-11 07:41:00.000000',NULL,1,6,NULL,'청년, 농업, 교육','도봉구민 대상 도시농업 교육 실시',NULL,'계절에 맞는 식물 식재 및 도시농업의 다양한 측면에 대한 교육을 제공하는 팜시티 아카데미 수강생을 모집합니다. (모집기간: 2025. 8. 18. ~ 8. 27.)','https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737637&code=10008769'),('2025-08-12 10:24:35.286220',4,'2025년 장애인일자리(복지일자리) 참여자 모집공고(3차)-사단법인장애인의열린공감터','2025년 장애인일자리(복지일자리) 참여자 모집공고1.근무조건 및 모집내용●근무기간: 2025년 9월 1일 ~ 12월 31일(4개월 간)●근무시간: 주 14시간 이내 근무(월 56시간)●보수: 월 561,680원(고용보험 개인부담금액에 따라 실수령액 차이 있을 수 있음)●모집인원: 총 2명●모집기간: 2025. 8. 12.(화) ~ 8. 21.(목) 18:','PARTICIPATION','2025-08-11 04:20:00.000000',NULL,1,6,NULL,'장애인일자리, 복지일자리, 모집공고, 구직','2025년 장애인 복지일자리 참여자 2명 모집','장애인복지과, 고용센터',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737633&code=10008769'),('2025-08-12 10:24:35.293703',5,'2025년 생활밀착형 소규모시설 맞춤형 경사로 설치 지원사업 안내','2025년 생활밀착형 소규모시설 맞춤형경사로 지원사업?모집기간:2025. 8. 8.(금) ~예산 소진 시까지?사업대상:경사로 설치를 희망하는 도봉구 내 생활밀착형 소규모 시설※단차가 있지만 경사로가 설치되어 있지 않은 편의점,약국,의원,음식점,카페,서점 등다중이용시설의1층 주출입구?사업내용:생활밀착형 소규모 시설 주출입구의 단차에 적합한 경사로 설치※시설에','PARTICIPATION','2025-08-08 01:36:00.000000',NULL,1,6,NULL,'경사로 지원사업, 소규모시설, 도봉구, 장애인 편의시설','도봉구 내 생활밀착형 소규모 시설의 접근성 향상을 위한 경사로 설치 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737570&code=10008769'),('2025-08-12 10:24:35.302379',6,'2025년 도봉청년 해외인턴십 지원사업 참여자 추가모집','구직 청년의 해외 일자리 경험 및 취업 경쟁력 향상을 지원하기 위하여 다음과 같이「2025년도봉 청년 해외인턴십 지원사업(미국)」참가자를 추가모집하오니 관심 있는 청년들의 많은 신청 바랍니다.2025년8월7일서울특별시 도봉구청장○모집기간:2025. 8. 7.(목)부터8. 18.(월) 16:00까지○선발인원:일반선발2명○대 상:①도봉구 거주②30세 미만 청년','PARTICIPATION','2025-08-07 06:41:00.000000',NULL,1,6,NULL,'해외인턴십, 청년취업, 미국, 도봉구','구직 청년의 해외 일자리 경험 및 취업 경쟁력 향상 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737544&code=10008769'),('2025-08-12 10:24:35.309843',7,'★양성평등주간 기념★ “박지선 교수” 명사특강 신청 안내','양성평등주간(9.1.~9.7.)을 맞이하여 개최하는「2025년 양성평등주간 기념행사」에 초청합니다.올해 명사특강은“박지선 숙명여대 사회심리학과 교수”와함께합니다.참석을 희망하시는 분들은 사전 신청 부탁드립니다.(신청기간 종료후 참석 대상자에 한해 안내 문자를 드립니다.)□행사개요○행사일시:2025. 9. 2.(화) 14:00~16:00○행사장소:도봉구청2층','PARTICIPATION','2025-08-06 23:09:00.000000',NULL,1,6,NULL,'양성평등주간, 기념행사, 명사특강, 박지선 교수, 사전신청','2025년 양성평등주간 기념행사 참석을 요청합니다.','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737525&code=10008769'),('2025-08-12 10:24:35.318623',8,'2026년 행정안전부 간판개선사업 공모 신청 안내','2026년 행정안전부 간판개선사업 공모신청에 대하여안내해드리니 붙임 서식을 참고하여 신청해 주시기 바랍니다.○(추진배경)주변 건물과 조화롭고 아름다운 간판으로 개선하여,쾌적한주민생활 공간 조성 및 지역상권 활성화 도모○(사업내용)벽면이용간판,창문이용광고물 등 옥외광고물 개선[설치된 간판 철거 후 벽면이용간판1개(곡각지점2개)설치)]○(사업대상)주민이 간판개','PARTICIPATION','2025-08-06 08:20:00.000000',NULL,1,6,NULL,'간판개선, 공모, 행정안전부, 옥외광고물, 지역상권 활성화','2026년 행정안전부 간판개선사업 공모 신청을 안내하고, 붙임 서식을 참고하여 신청을 독려하기 위함.','행정안전부',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737523&code=10008769'),('2025-08-12 10:24:35.325854',9,'\'\'25년 3분기 화물자동차 유가보조금 지급 신청 안내','2025. 3분기 화물자동차 유가보조금 서면 신청안내1. 9월 1일(월)부터 5일(금)까지 2025년 3분기(25년 6월~8월) 화물자동차 유가보조금 서면신청이 가능합니다.2.신청 대상에 해당하신 분은 아래 내용을 확인하시고, 도봉구청 2층 교통행정과 14번 창구에서구비 서류를 가지고 신청해주시기 바랍니다.◎ 신청대상 1)현재 도봉구에 등록된 영업용 화물차','PARTICIPATION','2025-08-05 05:58:00.000000',NULL,1,6,NULL,'화물자동차, 유가보조금, 서면신청, 도봉구','2025년 3분기(6월~8월) 화물자동차 유가보조금 서면 신청 안내 및 접수','도봉구청 교통행정과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737490&code=10008769'),('2025-08-12 10:24:35.335031',10,'도봉땡겨요상품권 발행 안내','서울배달+땡겨요,최대30%할인 혜택□도봉땡겨요상품권 발행(15%)○일   시:2025. 8. 8.(금) 10:00○할 인 율:15%○규   모: 5억○구매한도:월20만원(보유한도100만원)○사 용 처:도봉구 내 땡겨요 가맹점○유효기간:구매일로부터1년○구 매 앱:서울페이플러스(서울Pay+)○사 용 앱:배달앱 땡겨요※페이백(10%)및 땡겨요 포인트(5%)○일','NOTICE','2025-08-05 05:42:00.000000',NULL,1,6,NULL,'도봉땡겨요상품권, 서울페이플러스, 땡겨요, 할인, 배달앱','도봉구민을 위한 도봉땡겨요상품권 발행 및 서울배달+땡겨요 이용 시 최대 30% 할인 혜택 제공 안내','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737489&code=10008769'),('2025-08-12 10:24:35.341764',11,'[배달강좌 삼삼오오] 4기 신청 안내','[배달강좌 삼삼오오] 4기 신청 안내드립니다○사업명:2025년 배달강좌 삼삼오오4기○참여대상:도봉구민13팀(1팀당 최소5인 이상,취약계층3인 이상)※추첨제○신청기간:2025. 8. 1. (금) ~ 8. 11. (월) 18시 까지 -기한 및 시간 엄수※18시1분 접수 미인정 -대표자1인, 1건의 접수만 가능(타 팀 지원서 대리 제출 불가)○추첨방법:자','PARTICIPATION','2025-08-02 09:31:00.000000',NULL,1,6,NULL,'배달강좌, 삼삼오오, 4기, 신청, 도봉구, 취약계층','2025년 배달강좌 삼삼오오 4기 참여자 모집 안내','도봉구',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737435&code=10008769'),('2025-08-12 10:24:35.350050',12,'어르신 스포츠상품권 신청 안내','스포츠시설에서 사용할 수 있는「어르신 스포츠상품권」신청방법을 아래와 같이 안내드립니다.■지원대상: 65세 이상기초연금수급자■신청기간:2025. 8. 4.(월) 09:00 ~ 2025. 8. 13.(수) 18:00※선착순아님■신청방법:온라인 신청(http://ssvoucher.co.kr) 또는 전용 콜센터(☎1551-9998)에서 유선 신청■지원내용:스포츠시','PARTICIPATION','2025-08-01 06:39:00.000000',NULL,1,6,NULL,'어르신, 스포츠상품권, 신청, 기초연금, 스포츠시설','스포츠시설 이용 가능한 어르신 스포츠상품권 신청 방법 안내','관련 부서 명칭 (공문에 명시되지 않아 추정 불가)',NULL,NULL),('2025-08-12 10:24:35.358710',13,'오존주의보 발령(8월 1일 14시)','2025. 8. 1.(금) 14시 오존 주의보가 발령되어 안내하오니 건강관리에 유의하시기 바랍니다.발 령 일: 2025. 8.1.(금) 14시발령지역: 서울시안내사항○ 실외 활동과 과격한 운동 자제○ 어린이집, 유치원, 학교 실외수업 자제 또는 제한○ 승용차 운행 자제, 대중교통 이용○ 스프레이, 드라이클리닝, 페인트칠, 신나 사용을 줄임 ○ 한낮의 더운','NOTICE','2025-08-01 05:00:00.000000',NULL,1,6,NULL,'오존 주의보, 대기오염, 건강관리, 서울시','2025년 8월 1일 14시 서울시에 발령된 오존 주의보에 대한 시민 안내 및 건강 관리 권고','서울시청, 보건환경 관련 부서',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737418&code=10008769'),('2025-08-12 10:24:35.361665',14,'중랑천 물놀이장(녹천교 하류) 재개장 안내 [7.31.(목)~]','- 중랑천 물놀이장(녹천교 하류) 재개장 안내 -2025년 도봉구 중랑천 물놀이장 중 1개소(창동 주공17단지아파트 인근 녹천교 하류)가 청소 및 정비를 마치고 재개장함을 알려드립니다.[중랑천 물놀이장 2개소 모두 재개장 완료](중랑천 물놀이장은 매일 상수도 급수 및 염소투입을 통해 수질관리하고 있으며,\'가동 개시일 기준 운영기간 동안 1회/15일 이상 수','NOTICE','2025-07-31 10:49:00.000000',NULL,1,6,NULL,'중랑천, 물놀이장, 녹천교, 재개장, 도봉구, 창동','2025년 도봉구 중랑천 물놀이장 녹천교 하류(창동 주공17단지 인근) 재개장 안내','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737394&code=10008769'),('2025-08-12 10:24:35.371876',15,'정보통신설비 유지보수·관리자 선임 제도 시행 안내','정보통신공사업법 일부개정[정보통신공사업법 제37조의2(정보통신설비의 유지보수·관리기준)]에 따라 일정 규모 이상의 건축물 관리자는 건축물 내 정보통신설비에 대한 유지보수를 선임해야만 하며, 선임된 유지보수 관리자는 매년유지보수점검 및 성능점검을 실시하도록 의무화 하였습니다.이에 건축물 관리자가 준수하셔야 할 사항을 붙임과 같이 안내드리니 참고하시기 바랍니다','NOTICE','2025-07-31 05:05:00.000000',NULL,1,6,NULL,'정보통신공사업법, 정보통신설비, 유지보수, 건축물 관리, 점검','정보통신공사업법 제37조의2에 따른 정보통신설비 유지보수·관리 기준 안내 및 준수 사항 명시','건축물 관리 부서, 정보통신 관련 부서',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737388&code=10008769'),('2025-08-12 10:24:35.378618',16,'2025년 가스열펌프 저감장치 부착 지원사업 모집 공고(3차)','서울특별시 공고 제2025-2283호2025년도『가스열펌프 배출가스 저감장치부착 지원사업』공고(3차)서울시는 질소산화물 등 대기오염물질 배출저감을 위해「가스열펌프 배출가스 저감장치 부착 지원사업」을 실시하고자 다음과 같이 공고합니다.2025. 7. 31.서울특별시장','PARTICIPATION','2025-07-31 00:03:00.000000',NULL,1,6,NULL,'가스열펌프, 배출가스, 저감장치, 지원사업, 대기오염물질, 질소산화물','가스열펌프 배출가스 저감장치 부착 지원사업 공고 및 지원','서울특별시',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737376&code=10008769'),('2025-08-12 10:24:35.389977',17,'「도봉구 아동 돌봄 실태 조사」 참여 안내','[도봉구 아동 돌봄 실태 조사 참여] 안내최근 잇따른 돌봄공백 속 화재사고로 가정 내 아동 돌봄 공백으로 인한 안전 문제가 사회적으로 큰 관심을 받고 있습니다.이에 도봉구에서는 만 12세 이하 아동을 대상으로 한 돌봄 실태 전수조사를 실시하여, 아동의 안전한 돌봄환경 조성과 맞춤형 지원 체계 마련을 위한 기초자료로 활용하고자 합니다.이번 조사는 지자체 중','PARTICIPATION','2025-07-30 07:44:00.000000',NULL,1,6,NULL,'아동 돌봄, 실태 조사, 안전, 도봉구, 만 12세 이하','만 12세 이하 아동 대상 돌봄 실태 전수조사를 통해 아동의 안전한 돌봄 환경 조성 및 맞춤형 지원 체계 마련을 위한 기초자료 확보','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737369&code=10008769'),('2025-08-12 10:24:35.397073',18,'AI 음악 콘텐츠 제작 교육 프로그램 모집(AI아트웨이브 교육)','도봉구 및 OPCD 협력 기업인 ALUX에서 \"AI를 활용한 콘텐츠 제작 교육 수강생\"을 모집하고 있습니다.AI를 이용하여 음악 창작 기초(음원 분리, 샘플링 등)부터 작곡 및 편곡 실습, 뮤직비디오 제작까지 배울 수 있는 기회로, 평소 AI 음악 콘텐츠 제작에 관심 있었던 많은청년 아티스트들을 기다리고 있습니다.o 교육기간: 2025년 8월 19일(화)','PARTICIPATION','2025-07-30 07:29:00.000000',NULL,1,6,NULL,'AI, 콘텐츠 제작, 교육, 음악, 작곡, 편곡, 뮤직비디오, 청년 아티스트, 도봉구, OPCD, ALUX','AI를 활용한 음악 콘텐츠 제작 교육 수강생 모집','도봉구, OPCD, ALUX',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737367&code=10008769'),('2025-08-12 10:24:35.405483',19,'2023년 제3차 건축위원회(전문위원회) 심의 결과 안내','2023년 제3차 건축위원회(전문위원회) 개최 결과를 첨부와 같이 알려드립니다.(※ 2023년에 누락)','NOTICE','2025-07-30 04:53:00.000000',NULL,1,6,NULL,'건축위원회, 전문위원회, 개최 결과','2023년 제3차 건축위원회(전문위원회) 개최 결과를 알림','건축위원회',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737357&code=10008769'),('2025-08-12 10:24:35.408621',20,'[모집] 도봉구 반려견 방범대 ‘오!써방 히어로’ 추가 모집 안내','[도봉구 반려견 방범대] 오! 써방 히어로 추가모집도봉문화재단에서 우리 도봉구를 동네 산책으로 지킬 멋쟁이 반려견 오!써방히어로를 추가 모집합니다.여러분의 많은 참여와 관심 부탁드립니다!■ 신청방법1) 구글폼 작성 모집 :https://forms.gle/XR4GM1SzA1kPTYKu9■ 모집대상도봉구 거주 반려인 누구나■ 모집일정오!써방히어로 방범대 활동복','PARTICIPATION','2025-07-29 01:10:00.000000',NULL,1,6,NULL,'반려견, 방범대, 오!써방 히어로, 도봉구, 모집','도봉구의 안전한 동네 산책을 위해 반려견과 함께 활동할 오!써방 히어로 추가 모집','도봉문화재단',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737305&code=10008769'),('2025-08-12 10:24:35.539981',21,'[마감]도봉구 청년 직업적성 및 흥미검사 프로그램(4회차) 참여자 모집','취업준비생 등청년을 대상으로‘STRONG 직업흥미검사 해석 프로그램’을 실시하여청년들의 자기이해 도모 및 진로·직업 흥미에 대한 가치관 파악과 진로탐색을지원하오니 청년들의 많은 참여 바랍니다.*교 육 명:도봉구 청년 직업흥미검사 개인 해석 상담(STRONG 검사 기반)*교육기간:2025. 8. 13.(수) ~ 9. 19(금)*교육방법: 온라인 검사 및 비대','PARTICIPATION','2025-07-28 01:56:00.000000',NULL,1,6,NULL,'청년, 취업준비생, 직업흥미검사, STRONG 검사, 진로탐색, 상담, 도봉구','취업준비생 등 청년들의 자기이해 도모 및 진로·직업 흥미에 대한 가치관 파악과 진로탐색 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737278&code=10008769'),('2025-08-12 10:24:35.550776',22,'\'\'7월27일 도봉구 여름 물놀이장으로 장애인 가족 초대\'\'','올해 무더운 여름 7월27일!!도봉구 물놀이장에서 장애인 가족을 초대합니다!도봉구 문화체육과에서 운영하고 있는 물놀이장을 자유롭게 이용할 수 없는 장애인 가족분들을 초대하여 마음껏 즐길 수 있는 자리를 마련하고자 하오니 많은 관심과 참여바랍니다.□ 제  목:‘도봉구 여름 물놀이장으로 초대’ 장애인 가족의 시원한 여름이야기□ 운영시간:2025. 7. 27.(','PARTICIPATION','2025-07-26 05:40:00.000000',NULL,1,6,NULL,'장애인, 가족, 물놀이장, 도봉구, 여름행사','장애인 가족을 도봉구 물놀이장에 초대하여 무료로 이용할 수 있도록 함으로써 즐거운 여름을 선사하고자 함.','도봉구 문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737254&code=10008769'),('2025-08-12 10:24:35.560535',23,'중랑천 물놀이장(녹천교 하류) 휴장 안내 [7.20.(일)~]','- 중랑천 물놀이장(녹천교 하류) 휴장 안내 -중랑천 물놀이장 중 1개소(녹천교 하류)가 중랑천 범람피해 재정비로 인해 휴장중임을 알려드립니다.빠른 시일내에 점검완료 후 재개장하도록 하겠습니다.□ 장   소: 중랑천 물놀이장 1개소(창동 녹천교 하류)□휴장 일시: 2025.7.20.(일)~ ※ 재개장 시 도봉구청 홈페이지 공지 예정입니다.□문의: 치수과 하','NOTICE','2025-07-25 07:18:00.000000',NULL,1,6,NULL,'중랑천, 물놀이장, 휴장, 녹천교, 범람, 재정비','중랑천 녹천교 하류 물놀이장의 범람피해 재정비로 인한 휴장을 알리고 재개장 시기를 안내','도봉구청, 치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737242&code=10008769'),('2025-08-12 10:24:35.565712',24,'2025년 8월 식품접객업소 위생 및 원산지 지도서비스 사전 예고문 게시','서울시는2025. 8월중「식품접객업소 위생 및 원산지지도서비스」를실시합니다.「식품접객업소 위생 및 원산지 지도서비스」는안전한 먹을거리를제공해야 하는 영업주의 의무와 책임을 환기시키고,영업주의자율적 위생관리 참여를 유도함으로써 서울시 식품접객업소의 위생수준 향상을 도모하고안전한 외식문화를 조성하기 위한사업입니다.대상업소 관계자분께서는 영업에 다소 불편하시더라','PARTICIPATION','2025-07-25 00:43:00.000000',NULL,1,6,NULL,'식품접객업소, 위생, 원산지, 지도서비스, 서울시','서울시 식품접객업소의 위생수준 향상 및 안전한 외식문화 조성','서울시',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737230&code=10008769'),('2025-08-12 10:24:35.574357',25,'2025년「스포츠강좌이용권 단기스포츠체험강좌」변경사항 안내(※현재 중단)','스포츠강좌이용권 단기스포츠체험강좌 프로그램 내용이 변경되었으니 참조하시기 바랍니다.강좌 안내>※프로그램별로 참여 조건이 다르므로 참가 전 꼭 확인 바랍니다!!!■참여일시: ~2025년 8월 (재개 일정은 추후 재공지)■참가자격: 5세~18세 기초생활수급,차상위,법정한부모가정 자녀※보호자1인 동반 가능(보호자2인 이상이면1인 비용만 지원)■신청일시:전월1일~','PARTICIPATION','2025-07-24 08:52:00.000000',NULL,1,6,NULL,'스포츠강좌이용권, 단기스포츠체험강좌, 프로그램 변경, 참여 조건','스포츠강좌이용권 단기스포츠체험강좌 프로그램 내용 변경 사항 안내','스포츠 관련 부서, 아동복지 관련 부서',NULL,NULL),('2025-08-12 10:24:35.584705',26,'2025년 도봉구 청년 어학 및 자격증 시험 응시료 지원사업(3분기)','도봉구 미취업 청년들의 취업 경쟁력 향상과 경제적 부담 완화를 위해「도봉구 미취업 청년 어학 및 자격증 응시료 지원 사업(2025년 3분기)을 추진하오니 관내 청년의 많은 지원 바랍니다.- 사업 개요 -○ 사 업 명: 2025년 도봉구 미취업 청년 어학 및 자격증 응시료 지원사업(3분기)○ 접수기간(3분기):2025. 8. 1.(금) ~ 8. 20.(수)[','PARTICIPATION','2025-07-24 07:32:00.000000',NULL,1,6,NULL,'미취업 청년, 취업 지원, 어학, 자격증, 응시료 지원, 도봉구','도봉구 미취업 청년들의 취업 경쟁력 향상과 경제적 부담 완화','도봉구청',NULL,NULL),('2025-08-12 10:24:35.595563',27,'쌍문동26번지 일대 민간재개발사업 주민참여단 모집','우리 구 쌍문동26번지 일대 구역이 신속통합기획 민간재개발 후보지로 선정(2025.05.12.)됨에 따라주민과의 원활한 소통을 통한 기획안을수립하기 위하여 주민참여단을 구성하고자 하오니,관심 있는주민 여러분의 많은 참여 바랍니다.□주민참여단 모집 안내○모집기간: 2025. 7. 24. ~ 2025. 8. 5. 17:00까지○모집인원: 10명○접수방법:온라인','PARTICIPATION','2025-07-24 00:40:00.000000',NULL,1,6,NULL,'재정','신속통합기획 민간재개발 사업 추진을 위한 주민참여단 구성 및 주민 의견 수렴',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737204&code=10008769'),('2025-08-12 10:24:35.605887',28,'중랑천 물놀이장(서원아파트 앞) 재개장 안내 [7.23.(수)~]','- 중랑천 물놀이장(서원아파트 앞) 재개장 안내 -2025년 도봉구 중랑천 물놀이장 중 1개소(도봉동 서원아파트 앞)가 청소 및 정비를 마치고 재개장함을 알려드립니다.녹천교 하류 중랑천 물놀이장도 빠른 시일내에 점검완료 후 재개장하도록 하겠습니다.(중랑천 물놀이장은 매일 염소투입을 통해 수질관리하고 있으며,\'가동 개시일 기준 운영기간 동안 1회/15일 이상','NOTICE','2025-07-23 04:38:00.000000',NULL,1,6,NULL,'환경, 복지','중랑천 물놀이장 재개장 안내','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737181&code=10008769'),('2025-08-12 10:24:35.612824',29,'우이천 음악분수 재가동 안내[7.23.(수)~]','- 우이천 음악분수 재가동 안내 -우천 및 우이천 범람으로 중단되었던우이천 음악분수가재가동됨을 알려드립니다.○재가동 일시: 2025.7.23.(수)~※우천(예보)시 가동 중지○ 문의: 치수과(02-2091-4142)','NOTICE','2025-07-23 04:33:00.000000',NULL,1,6,NULL,'환경','우이천 음악분수 재가동 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737180&code=10008769'),('2025-08-12 10:24:35.625020',30,'2025년「장애인 스포츠강좌이용권」이용자 추가모집 알림','2025년 장애인 스포츠강좌이용권 불용 인원 발생으로 추가 대상자를 모집하고자 하오니 관심 있으신 분들의 많은 신청 바랍니다.신청 안내>■신청기간:2025. 7. 23.(수) ~ 2025. 7. 31.(목)※선착순아님■신청방법:장애인스포츠강좌이용권 홈페이지(http://dvoucher.kspo.or.kr)에서 온라인 신청또는 구청 문화체육과(7층)방문 신청','PARTICIPATION','2025-07-22 07:04:00.000000',NULL,1,6,NULL,'스포츠, 복지','2025년 장애인 스포츠강좌이용권 불용 인원 발생에 따른 추가 대상자 모집','구청 문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737163&code=10008769'),('2025-08-12 10:24:35.634776',31,'2025년 도봉구 장애인친화미용실 운영 안내','-운영기간: 2025년 8월 ~-사업대상: 도봉구 관내 장애인-참여업체: 총 14개소 미용실(동별 1개소)※동별 장애인친화 미용실 현황쌍문1동쌍문2동쌍문3동쌍문4동방학1동방학2동방학3동오땡큐헤어르호봇헤어클럽마르떼헤어나인헤어핀컬스토리헤어아카페미용실온스타일헤어방학점창1동창2동창3동창4동창5동도봉1동도봉2동구구미용실한가희헤어샵오옥희헤어샵영헤어hair doo비제이','PARTICIPATION','2025-07-21 23:56:00.000000',NULL,1,6,NULL,'복지','도봉구 관내 장애인에게 미용 서비스 제공','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737145&code=10008769'),('2025-08-12 10:24:35.643510',32,'2025년 제10차 건축위원회(서면) 심의 개최 결과 알림','2025년 제10차 건축위원회(서면) 심의 개최 결과를 첨부와 같이 알려드립니다.','NOTICE','2025-07-21 09:31:00.000000',NULL,1,6,NULL,NULL,'2025년 제10차 건축위원회(서면) 심의 개최 결과 알림',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737141&code=10008769'),('2025-08-12 10:24:35.648857',33,'방학동 모아타운(1구역) 조합설립 공공지원을 위한 주민대표(후보자) 공모 공고','방학동 모아타운(1구역)조합설립 공공지원을 위한 주민대표(후보자)공모 공고□목 적○방학동(1구역)SH참여형 모아타운 공공관리사업의주민대표(후보자)를 선정하여SH와 소통 및 해당 구역의 조합설립이 원활하게 추진될 수 있도록사업시행 초기단계를 지원하고자 합니다.□일 정○공 고 일: 2025. 7. 21.(월), SH·도봉구청 홈페이지 게시○신청기간: 2025.','PARTICIPATION','2025-07-21 08:45:00.000000',NULL,1,6,NULL,'주택, 도시계획, 재정','방학동(1구역) SH참여형 모아타운 공공관리사업의 주민대표(후보자)를 선정하여 SH와 소통 및 해당 구역의 조합설립이 원활하게 추진될 수 있도록 사업시행 초기단계를 지원','SH공사, 도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737139&code=10008769'),('2025-08-12 10:24:35.661203',34,'\'\'도봉구 여름 물놀이장으로 장애인 가족 초대\'\'','올해 무더운 여름!!장애인 가족의 시원한 여름이야기!도봉구 문화체육과에서 운영하고 있는 물놀이장을 자유롭게 이용할 수 없는 장애인 가족분들을 초대하여 마음껏 즐길 수 있는 자리를 마련하고자 하오니 많은 관심과 참여바랍니다.□ 제  목:‘도봉구 여름 물놀이장으로 초대’ 장애인 가족의 시원한 여름이야기□ 운영시간:2025. 7. 27.(일) 13:00 ~17:','PARTICIPATION','2025-07-21 04:40:00.000000',NULL,1,6,NULL,'복지, 스포츠','장애인 가족의 무더운 여름을 시원하게 보낼 수 있도록 물놀이장 이용 기회 제공','도봉구 문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737131&code=10008769'),('2025-08-12 10:24:35.673926',35,'2025년 서울 매력일자리 사업 \'\'전통시장 매니저\'\' 채용 공고','2025년 서울 매력일자리 사업 \'전통시장 매니저\' 채용을 다음과 같이 공고합니다.1. 채용인원: 2명2. 공고기간: 2025. 7. 21.(월) ~ 7. 31.(목) [10일간]3. 접수기간: 2025. 7. 25.(금) ~ 7. 31.(목) 17:00까지 [5일간]4. 접수방법 - 방문 접수: 도봉구청 6층 지역경제과 - 전자우편 접수:haein0920','PARTICIPATION','2025-07-21 00:09:00.000000',NULL,1,6,NULL,'청년, 재정','2025년 서울 매력일자리 사업 \'전통시장 매니저\' 채용','도봉구청 지역경제과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737118&code=10008769'),('2025-08-12 10:24:35.685240',36,'중랑천 물놀이장 우천피해 휴장 [7.20.(일)~]','- 우천피해 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천 및 중랑천 수위 상승으로 인하여 오염되어 휴장함을 알려드립니다.청소 및 시설물 점검 후 재개장 예정입니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.20.(일)~□문의: 치수과(02-2091-4142)','NOTICE','2025-07-20 00:30:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천 및 중랑천 수위 상승으로 인한 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737109&code=10008769'),('2025-08-12 10:24:35.693909',37,'중랑천 물놀이장 우천 휴장[7.19.(토)]','- 우천 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천 및 중랑천 수위 상승으로 인하여 휴장함을 알려드립니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.19.(토)□문의: 치수과(02-2091-4142)','NOTICE','2025-07-18 07:01:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천 및 중랑천 수위 상승으로 인한 중랑천 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737092&code=10008769'),('2025-08-12 10:24:35.704595',38,'2025 도봉 여름 와글와글 물놀이장 개장연기 안내','2025. 7. 18.(금) 개장 예정이던, 2025 도봉 와글와글 물놀이장이 우천으로 인하여개장을 연기함을 알려드립니다.○ 개장일시: 2025. 7. 20.(일) 10시 추후 휴장시, 홈페이지에 별도 안내할 예정이오니, 도봉구청 홈페이지를 참고하여 주시기 바랍니다.물놀이장 콜센터 ☎ 010-2548-7826문화체육과 ☎ 2091-2544','NOTICE','2025-07-18 00:47:00.000000',NULL,1,6,NULL,'스포츠, 청년, 복지','2025 도봉 와글와글 물놀이장 개장 연기 안내','문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737071&code=10008769'),('2025-08-12 10:24:35.716042',39,'2025년 도봉구 양성평등상 표창 추천 공고','여성친화도시 도봉구에서는 양성평등의 촉진, 여성의 사회참여 확대, 여성의 인권보호및 권익증진 등 양성평등 정책에 공적이 큰 구민 및 단체(기관)를 발굴하여 도봉구 양성평등상을 표창하고자 하오니 공적이 우수한 후보자를 추천하여 주시기 바랍니다.1. 추천기간: 2025. 7. 18.(금) ~ 8. 6.(수)2. 표창부문: 3개 분야 각 5명이내(개인 또는 단체','PARTICIPATION','2025-07-18 00:38:00.000000',NULL,1,6,NULL,'복지, 교육','양성평등 정책에 공적이 큰 구민 및 단체(기관) 발굴 및 포상','여성가족과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737070&code=10008769'),('2025-08-12 10:24:35.727577',40,'중랑천 물놀이장 우천 휴장[7.18.(금)]','- 우천 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천 및 중랑천 수위 상승으로 인하여 휴장함을 알려드립니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.18.(금)□문의: 치수과(02-2091-4142)','NOTICE','2025-07-18 00:08:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천 및 중랑천 수위 상승으로 인한 중랑천 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737068&code=10008769'),('2025-08-12 10:24:35.849815',41,'민생회복 소비쿠폰 신청 안내','「민생회복 소비쿠폰」신청방법을 아래와 같이 안내드리오니 아래의 내용을 참고하시어 신청기간내에 신청하여 주시기 바랍니다.※ 민생회복 소비쿠폰 지급을 사칭한 스미싱·스팸문자를 주의하세요!(정부 및 카드사 등은 URL이나 링크가 포함된 문자메세지를 보내지 않습니다. 신고 ☎ 118 상담센터)가. 대   상 : 도봉구민※ 미성년자는 주민등록 세대주 신청?수령, 주','PARTICIPATION','2025-07-17 05:35:00.000000',NULL,1,6,NULL,'재정, 복지','민생회복 소비쿠폰 신청방법 안내',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737054&code=10008769'),('2025-08-12 10:24:35.864155',42,'신축 공동주택 실내공기질 자가측정 결과서(롯데캐슬 골든파크)','?실내공기질 관리법? 제9조제2항의 규정에 따라붙임과 같이 신축 공동주택 실내공기질 자가측정 결과를 구 누리집에 게시하고자 합니다.붙임 실내공기질 자가측정 결과보고서(롯데캐슬 골든파크) 1부. 끝.','REPORT','2025-07-16 07:06:00.000000',NULL,1,6,NULL,'환경','실내공기질 관리법 제9조제2항에 따른 신축 공동주택 실내공기질 자가측정 결과 게시',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737030&code=10008769'),('2025-08-12 10:24:35.876295',43,'중랑천 물놀이장 우천 휴장 [7.16.(수)~7.17.(목))','- 우천 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천으로 인하여 휴장함을 알려드립니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.16.(수)~7.17.(목)□문의: 치수과(02-2091-4142)','NOTICE','2025-07-16 00:27:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천으로 인한 중랑천 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737020&code=10008769'),('2025-08-12 10:24:35.887097',44,'「2026학년도 대입 수시  전략 설명회」개최 안내','- 2025년 도봉구 진학 아카데미 -「2026학년도 대입 수시 전략 설명회」개최 안내 도봉구 교육지원과에서는 「2026학년도 대입 수시 전략 설명회」를       다음과같이 개최하오니, 많은 참여 바랍니다.○ 일시:2025. 8. 5.(화) 18:30~20:30○ 장소: 도봉구청 2층 선인봉홀○ 대상: 2026학년도 대입준비생 및 학부모 3','PARTICIPATION','2025-07-15 02:22:00.000000',NULL,1,6,NULL,'교육','2026학년도 대입 수시 전략 설명회 개최','도봉구 교육지원과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736989&code=10008769'),('2025-08-12 10:24:35.894322',45,'2025년 서울시(도봉구) 평생교육 이용권 2차 추가 모집 접수 안내','도봉구에서는 경제적 여건에 따른 교육격차를 해소하고 도봉구민의 평생학습 기회를 확대 제공하기 위하여「2025년 서울시(도봉구)평생교육 이용권(2차)」신청 접수를 받았으나,접수 마지막날(7.10.)온라인 접수 홈페이지 동시접속자가 폭증하여 신청접수가 불가한 상황이 발생하여 다음과 같이 추가 모집 접수를 공고합니다.■추가 접수기간:2025년7월16일(수) 09','PARTICIPATION','2025-07-14 10:25:00.000000',NULL,1,6,NULL,'교육, 복지','경제적 여건에 따른 교육격차 해소 및 평생학습 기회 확대','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736981&code=10008769'),('2025-08-12 10:24:35.904634',46,'덜 달달 9988 원정대 사업 안내(초등4~6학년 대상)','서울시에서는 (조)부모와 자녀가 함께 참여하는 아동청소년의 당류 섭취 저감 인식개선 프로그램인 \'덜 달달 원정대\' 운영 준비중이며, \'손목닥터 9988\' 앱을 통해2025. 7. 16.(수)정식 오픈할 예정입니다. 이와 관련하여 오프라인 행사도 아래와같이 진행하오니, 아이들이 건강한 식습관을 형성할 수 있도록 많은 관심과 참여 부탁드립니다.□덜 달달 998','PARTICIPATION','2025-07-14 07:58:00.000000',NULL,1,6,NULL,'청년, 교육, 복지','아동청소년의 당류 섭취 저감 및 건강한 식습관 형성',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736976&code=10008769'),('2025-08-12 10:24:35.913087',47,'2025년 하반기 신중년 아카데미 수강생 모집','◆ 프로그램 안내                           프로그램교육기간교육장소모집인원수강료아로마 관리사2급 자격증 과정8. 13. ~ 10. 1.[8회](매주 수)14:00 ~ 15:30삼육대학교평생교육원302호 강의실20명18,000원실버인지놀이지도사1급 자격증 과정8. 12. ~ 9. 30.[8회](매주 화)15:40 ~ 17:40도봉구청지하1','PARTICIPATION','2025-07-14 05:12:00.000000',NULL,1,6,NULL,'교육','','삼육대학교평생교육원, 도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736970&code=10008769'),('2025-08-12 10:24:35.916998',48,'2025년 플랫폼종사자 고용·산재 보험료 지원사업 공고','사회보험 사각지대에 있던 플랫폼종사자에 대해 사회보험 가입 장려 및 사회안전망 강화를 도모하고자 『2025년 플랫폼종사자 고용·산재보험료』 지원사업을 다음과 같이 시행함을 공고합니다.1. 사 업 명: 2025년 플랫폼종사자 고용·산재보험료 지원사업2. 신청기간- (1차) 2025. 7. 8. ~ 8. 14.- (2차) 2025. 11. 1. ~ 11. 30','PARTICIPATION','2025-07-14 02:24:00.000000',NULL,1,6,NULL,'복지','사회보험 사각지대에 있던 플랫폼종사자에 대해 사회보험 가입 장려 및 사회안전망 강화',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736962&code=10008769'),('2025-08-12 10:24:35.924446',49,'2025년 『함께 만들어요! 안전 배달 문화』 배달 플랫폼종사자 안전운전 캠페인 참여자 모집','배달 플랫폼종사자의 안전사고 예방 및 휴게공간 제공을 위하여 「배달 플랫폼종사자 안전운전 캠페인」을 시행하고, 안전운전 캠페인 참여자를 대상으로 달달쉼터 이용 바우처를 지급하고자 하오니 많은 관심과 참여 바랍니다.□ 사업개요1. 사업기간: 2025. 7. 14. ~ 8. 22.(6주)2. 사업대상: 도봉구 거주 또는 도봉구가 노무 제공장소인 배달 플랫폼종사','PARTICIPATION','2025-07-14 02:22:00.000000',NULL,1,6,NULL,'복지, 안전','배달 플랫폼종사자의 안전사고 예방 및 휴게공간 제공','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736961&code=10008769'),('2025-08-12 10:24:35.931287',50,'탄소공감마일리지 환경의 달 이벤트 결과 안내','\'2050 탄소중립\' 실현 주체인 주민의 자발적 실천을 촉진하고자 개발한 도봉형 환경마일리지인 \'탄소공(Zero)감(減)마일리지\'가 환경의 날(6.5.)을 맞아 이벤트를 진행하고 다음과 같이 결과를 안내드립니다.□이벤트 기간:2025. 6. 5.(목) ~ 6. 26.(목)□이벤트 대상:도봉구민 및 도봉구 생활권자(탄소공감 인증회원)□이벤트 결과①신규가입 인','NOTICE','2025-07-11 07:56:00.000000',NULL,1,6,NULL,'환경','탄소중립 실현을 위한 주민 참여 독려 및 탄소공감마일리지 홍보','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736916&code=10008769'),('2025-08-12 10:24:35.938226',51,'배달종사자 온열질환 예방가이드 알림','?? 배달종사자 여러분!폭염 속 건강, 이렇게 지켜주세요!여름철 폭염은 배달·대리운전 종사자 여러분의건강과 생명에 큰 위협이 될 수 있습니다.특히체감온도 31℃ 이상의 환경에서는온열질환(열사병, 열탈진 등)위험이 급격히 높아지므로 아래 수칙을 꼭 실천해 주세요.? 폭염 대응 5대 기본수칙1.물을 자주 마셔요!(갈증을 느끼기 전에 수시로 섭취)2.그늘이나 시','NOTICE','2025-07-10 01:35:00.000000',NULL,1,6,NULL,'복지','폭염으로 인한 배달종사자의 온열질환 예방',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736873&code=10008769'),('2025-08-12 10:24:35.944120',52,'도봉 아카데미‘드론 크리에이터’ 수강생 모집 안내 게재','◆프로그램 안내○교육장소:창동아우르네 대강당(마들로13길 84)교육명교육기간인원수강료드론 크리에이터8. 5. ~ 8. 14.(화,목) 14:00~16:00[4회]30명9,000원※프로그램과 관련된 상세 일정 및 내용은 홈페이지 수강 신청 시 강의계획서를 통해 확인하실 수 있습니다!◆수강 신청 안내○모집기간: 2025. 7. 28.(월) 10:00 ~ 8.','PARTICIPATION','2025-07-09 00:37:00.000000',NULL,1,6,NULL,'교육','드론 크리에이터 교육 프로그램 운영',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736846&code=10008769'),('2025-08-12 10:24:35.951735',53,'[마감]도봉구 청년 직업적성 및 흥미검사 프로그램(3회차) 참여자 모집','취업준비생 등청년을 대상으로‘STRONG직업흥미검사 해석 프로그램’을 실시하여청년들의 자기이해 도모 및 진로·직업 흥미에 대한 가치관 파악과 진로탐색을지원하오니 청년들의 많은 참여 바랍니다.*교 육 명:도봉구 청년 직업흥미검사 집단 해석 특강(STRONG검사 기반)*교육일정:2025. 8. 6.(수) 15:00 ~ 17:00*교육장소:도봉구청2층 세미나실1','PARTICIPATION','2025-07-09 00:37:00.000000',NULL,1,6,NULL,'청년, 교육','취업준비생 등 청년들의 자기이해 도모 및 진로·직업 흥미에 대한 가치관 파악과 진로탐색 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736845&code=10008769'),('2025-08-12 10:24:35.957827',54,'도봉 아카데미‘알기쉬운 부동산 경매 재테크 여행’ 수강생 모집 안내 게재','◆프로그램 안내○교육장소:도봉구청 지하1층 은행나무방(마들로 656)교육명교육기간인원수강료알기쉬운 부동산 경매재테크 여행8. 7. ~ 9. 25.(목)10:00~12:00[8회]25명18,000원※프로그램과 관련된 상세 일정 및 내용은 홈페이지 수강 신청 시 강의계획서를 통해 확인하실 수 있습니다!◆수강 신청 안내○모집기간: 2025. 7. 28.(월) 1','PARTICIPATION','2025-07-09 00:35:00.000000',NULL,1,6,NULL,'교육, 재정','부동산 경매 재테크 관련 교육 제공','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736844&code=10008769'),('2025-08-12 10:24:35.965029',55,'2025년「도봉구 청소년 미래인재캠프」참여자 선정 결과 알림','2025년「도봉구 청소년 미래인재 캠프」참여자 선정결과를 다음과 같이 안내 드립니다.□선발 개요○모집기간: 2025. 7. 1.(화)~7. 10.(목)※1일차 선착순 마감 및 접수 종료○접수인원:총40명 -선착순 선정 인원: 30명 -예비 선정 인원: 10명○선발방법: 참여자의주소지 자격 검증 후 최종 선발□선발 결과: [붙임]파일 참고○2025. 7. 1','PARTICIPATION','2025-07-08 07:20:00.000000',NULL,1,6,NULL,'청년, 교육','2025년「도봉구 청소년 미래인재 캠프」참여자 선정결과 안내',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736832&code=10008769'),('2025-08-12 10:24:35.972677',56,'오존주의보 발령','2025. 7. 7.(월) 16시오존 주의보가 발령되어 안내하오니 건강관리에 유의하시기 바랍니다.발 령 일: 2025. 7. 7.(월) 16시발령지역:서울시[안내사항]○실외 활동과 과격한 운동 자제○어린이집,유치원,학교 실외수업 자제 또는 제한○승용차 운행 자제,대중교통 이용○스프레이,드라이클리닝,페인트칠,신나 사용을 줄임 ○한낮의 더운 시간대를 피해 아침','NOTICE','2025-07-07 07:01:00.000000',NULL,1,6,NULL,'환경','오존 주의보 발령에 따른 시민 건강 관리 안내','서울시',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736806&code=10008769'),('2025-08-12 10:24:35.975957',57,'도봉구 중소기업창업보육센터 입주기업 모집','《도봉구 중소기업창업보육센터 입주자 모집》■모집기간:2025. 7. 8.(화) ~ 7. 21.(월)■모집센터:도봉구 제1중소기업창업보육센터(마들로13길61,씨드큐브 창동5층)■입주대상:공고일 기준,설립7년 미만의 중소기업 창업자(사업자등록必)■입주기간:최장3년(최초2년, 1회에 한해1년 연장 가능)■신청방법:담당자 이메일 접수(jhj9852@dobong.g','PARTICIPATION','2025-07-07 00:10:00.000000',NULL,1,6,NULL,'청년, ','중소기업 창업 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736791&code=10008769'),('2025-08-12 10:24:35.986817',58,'2025년 제9차 건축위원회 심의 결과 안내','2025년 제9차 건축위원회 개최 결과를 첨부와 같이 알려드립니다.','NOTICE','2025-07-04 02:15:00.000000',NULL,1,6,NULL,NULL,'',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736749&code=10008769'),('2025-08-12 10:24:35.989755',59,'2025년 중소기업육성기금 융자 지원 신청 안내','○ 지원규모: 32억 원○ 지원대상: 사업자등록증상 소재지가 도봉구인 중소기업 및 소상공인○지원내용: 업체당 1억 원 이내, 연리 1.5%(2년 거치 3년 균등분할상환)○ 지원조건: 부동산 또는 신용보증서 담보(서울신용보증재단 발급)○신청방법: 국민은행 신도봉지점 방문 신청○접수기간: 2025. 7. 7.(월) ~ 7. 21.(월)○ 문  의- 도봉구청 지','PARTICIPATION','2025-07-03 01:01:00.000000',NULL,1,6,NULL,'재정, 중소기업','중소기업 및 소상공인의 경영 안정 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736708&code=10008769'),('2025-08-12 10:24:36.001004',60,'[신청마감/유선문의] 나민애 교수 초청 「학부모 아카데미 명사특강」 개최 안내','도봉구 교육지원과에서 서울대학교 글쓰기 과목 교수이자 시 큐레이터로 활동 중인 나민애 교수님을 초빙하여 명사특강을 운영할 예정이오니 구민 여러분의 많은 관심과 참여 부탁드립니다. 1. 일  시: 2025. 7. 22.(화) 10:00 ~ 11:30 2. 장  소: 도봉구청 2층 선인봉홀 3. 대  상: 구민 400명 4. 주  제: 독서가 공부머리를 만든다','PARTICIPATION','2025-07-02 06:55:00.000000',NULL,1,6,NULL,'교육','구민 대상 명사특강 운영','도봉구 교육지원과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736681&code=10008769'),('2025-08-12 10:24:36.121094',61,'2025년 여름방학 「우리동네 돌봄터 가요」 수강생 모집(7. 7. ~ 7. 11. 18:00까지)','여름방학 중 돌봄이 필요한 초등학생을 대상으로 학교 밖 교육공간에서 운영되는‘우리동네돌봄터가요’를운영하오니학생들의 많은 신청 바랍니다.○신청기간:2025. 7. 7.(월)09:00 ∼ 7. 11.(금) 18:00○신청방법:도봉구교육포털도봉배움e홈페이지에서 신청(http://edu.dobong.go.kr)   ※추첨운영, 1인2개까지 신청 가능○신청대상:도봉','PARTICIPATION','2025-07-02 05:16:00.000000',NULL,1,6,NULL,'교육, 복지','여름방학 중 돌봄이 필요한 초등학생에게 교육 및 돌봄 서비스 제공','도봉구청 교육 관련 부서',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736678&code=10008769'),('2025-08-12 10:24:36.135649',62,'2025년「도봉구-귀뚜라미 문화재단」장학생 추천 알림 및 신청 안내','- 2025년『도봉구-귀뚜라미 문화재단』-장학생 신청 안내귀뚜라미 문화재단에서 도봉구 장학생 지원 결정에 따라지역사회에공헌할관내 우수 인재를 장학생으로 추천하여 지원 예정이니 많은 관심과신청 바랍니다.※세부내용:【붙임1】『도봉구-귀뚜라미 문화재단』장학생 추천 공고문 참고○접수기간: 2025. 7. 10.(목) ~ 7. 17.(목) (8일간)○추천인원:총70','PARTICIPATION','2025-07-01 09:20:00.000000',NULL,1,6,NULL,'청년, 교육, 재정','지역사회에 공헌할 관내 우수 인재 장학생 선발 및 지원','도봉구청, 귀뚜라미 문화재단',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736656&code=10008769'),('2025-08-12 10:24:36.146319',63,'&lt;&lt; 2025년 하반기「청년구정체험단」(舊대학생아르바이트) 부서배치 안내 &gt;&gt;','년 하반기「청년구정체험단」(舊대학생아르바이트)부서배치 안내>1.부서배치 명단:붙임파일 참고 2. 2025년 하반기 청년구정체험단 근무 안내  -근무기간:2025. 7. 4.(금) ~ 8. 1.(금)  -근무조건:주5일, 1일5시간  ※부서사정에 따라 토,일,공휴일 근무,평일 휴무 형태로 진행될 수 있으며,09:00~20:00중1일5시간 범위 내에서 근무시간','NOTICE','2025-07-01 01:02:00.000000',NULL,1,6,NULL,'청년, 교육','청년구정체험단 부서 배치 안내 및 근무 안내',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736629&code=10008769'),('2025-08-12 10:24:36.150921',64,'취업준비 청년 공기업/공공기관 NCS 필기 대비과정(기본+심화 문제풀이) 참여자 모집','공기업/공공기관 채용 전형의 첫번째 관문인 NCS 필기 대비과정을 운영하니, 관심있는 청년들의 많은 참여 바랍니다!■ 교육개요/커리큘럼○기 간: 2025년 7월 7일(월) ~ 7월 25일(금) 월/수/금 13:30 ~ 17:30회차강의일정교육내용1회차7/7(월) 13:30공기업 NCS 전반 · 유형별 문제풀이 전략 소개2회차7/9(수) 13:30의사소통 영','PARTICIPATION','2025-06-30 09:17:00.000000',NULL,1,6,NULL,'청년, 교육','공기업/공공기관 채용 NCS 필기시험 대비',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736619&code=10008769'),('2025-08-12 10:24:36.154828',65,'2025년제8차 건축위원회 심의 결과 안내','2025년 제8차 건축위원회 개최 결과를 첨부와 같이 알려드립니다.','NOTICE','2025-06-30 02:04:00.000000',NULL,1,6,NULL,NULL,'',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736602&code=10008769'),('2025-08-12 10:24:36.157329',66,'도봉구청 광장 야외 영화상영 취소 안내','비 예보로 인하여6월 28일(토) 예정되었던 도봉구청 광장 야외 무료 영화상영이사전 취소되었음을 안내드립니다.구민 여러분의 많은 양해 바랍니다.','NOTICE','2025-06-28 08:51:00.000000',NULL,1,6,NULL,'복지, 스포츠','야외 무료 영화상영 취소 안내','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736579&code=10008769'),('2025-08-12 10:24:36.163190',67,'2025년 공원 내 물놀이장 운영 안내','2025년 공원 내 물놀이장 운영 안내올여름 무더위를 식혀줄 어린이 물놀이장을 운영하니 많은 이용 바랍니다.○ 장 소: 3개소- 다락원체육공원(창포원로 45), 둘리뮤지엄(시루봉로1길 6), 방학사계광장(방학동 710)○ 이용대상: 13세 이하 어린이○ 이 용 료: 무료○ 기타사항- 영유아는 보호자 반드시 함께 이용- 수영복과 모자, 물놀이용 신발 등 착용','NOTICE','2025-06-27 05:08:00.000000',NULL,1,6,NULL,'청년, , 스포츠, 교육, , 환경, 재정','어린이 물놀이장 운영을 통한 무더위 해소',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736562&code=10008769'),('2025-08-12 10:24:36.166446',68,'쌍문3주택정비형재개발구역 주민협의체 제6차 회의 결과 공고','- 쌍문3주택정비형재개발구역 -주민협의체 제6차 회의 결과 공고도봉구 쌍문3주택정비형재개발구역에 대하여 「조합설립 지원을 위한 업무기준」 제14조에 따라 주민협의체 제6차 회의를 개최하고 결과를 붙임와 같이 공고합니다.붙임 쌍문3주택정비형재개발구역 주민협의체 제6차 회의 결과 공고문 1부. 끝.','PARTICIPATION','2025-06-25 09:12:00.000000',NULL,1,6,NULL,'재정','쌍문3주택정비형재개발구역 주민협의체 제6차 회의 결과 공고',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736510&code=10008769'),('2025-08-12 10:24:36.173500',69,'6월 식품접객업소 위생점검 사전예고문 게시','서울시에서「대학가 주변 및 유흥업소 밀집지역 등 주류 판매 접객업소」에대한 위생 점검을 시행합니다.식품접객업소의 위생 수준을 높이고 안전한 먹거리에 대한 시민들의 신뢰 제고를 위해 기획점검을 진행하며,점검의 투명성과 실효성 확보를 위하여 민관합동 및 자치구별 교차점검으로 추진합니다.2025년6월 식품접객업소 위생점검을 아래와 같이 시행함을사전에 예고드리니,',NULL,'2025-06-25 05:26:00.000000',NULL,1,6,NULL,'복지, 환경','식품접객업소 위생 수준 향상 및 안전한 먹거리에 대한 시민 신뢰 제고','서울시',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736498&code=10008769'),('2025-08-12 10:24:36.178830',70,'2025년 안심집수리 융자 지원사업 참여자 모집 변경공고','-2025년 안심 집수리 융자 지원사업 변경공고-저층주거지 노후주택 집수리를 위한2025년 안심 집수리 융자 지원사업의 일부 사항이 개선되어 변경 사항을 공고 드리오니,구민 분들의 많은 참여 바랍니다.□사업내용:노후 저층주택 집수리 비용 융자지원□접수기간: 2025. 4. 9.(수)~8. 8.(금)[단,예산 소진 시까지]□대상주택:서울시 내 사용승인 후20','PARTICIPATION','2025-06-25 04:38:00.000000',NULL,1,6,NULL,'복지, 재정','노후 저층주택 집수리 비용 융자 지원',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736496&code=10008769'),('2025-08-12 10:24:36.187966',71,'세상에서 가장 아름다운 약속 「무연고 어르신 유산기부 지원 사업」','-세상에서 가장 아름다운 약속-무연고 어르신 유산기부 지원사업무연고 어르신 사망 시,어렵게 일군 재산이 내 생각과 다르게 처리될 수 있습니다.소중한 유산이 주변의 이웃에게 희망으로 이어질 수 있도록도봉구가 안전하고 투명한 기부 절차를 지원 및 연계해드립니다.○사 업 명:세상에서 가장 아름다운 약속「무연고 어르신 유산기부 지원 사업」-서울사회복지공동모금회 유','PARTICIPATION','2025-06-25 01:41:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736491&code=10008769'),('2025-08-12 10:24:36.195364',72,'&lt;쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정 용역&gt; 제안서 평가위원 모집 안내','우리 구에서 추진중인‘쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정용역’과 관련하여,「지방자치단체를 당사자로 하는 계약에 관한 법률 시행령」제43조에 따라 제안서 평가를 위한 평가위원(후보자)을 다음과 같이 모집합니다.가.용역명:쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정 용역나.모집기간: 2025.06.24.~ 07.03','PARTICIPATION','2025-06-24 08:30:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736474&code=10008769'),('2025-08-12 10:24:36.204066',73,'★모집기간 연장★ 2025 도봉취업아카데미 아파트시설관리자 양성과정 수강생 모집','서울특별시 기술교육원 북부캠퍼스와 도봉구청이 함께하는\'아파트시설관리자 양성과정\' 교육생을 아래와 같이 모집합니다.관심 있는 도봉구민 여러분의 많은 참여 바랍니다.□ 모집안내· 모집대상: 도봉구민· 모집기간: 2025. 6. 18.(수) ~7. 10.(목)모집기간 연장· 모집정원: 20명· 면접일정: 7월 9일 (수) ※개별연락· 합격자발표: 7월 10일 (','PARTICIPATION','2025-06-23 08:28:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736448&code=10008769'),('2025-08-12 10:24:36.213542',75,'「2025년 장애인 스포츠강좌이용권」추가모집 알림','2025년 장애인 스포츠강좌이용권 불용 인원 발생으로 추가 대상자를 모집하고자 하오니 관심 있으신 분들의 많은 신청 바랍니다.신청 안내>■신청기간:2025. 6. 23.(월) ~ 2025. 6. 29.(일)※선착순아님■신청방법:장애인스포츠강좌이용권 홈페이지(http://dvoucher.kspo.or.kr)에서 온라인 신청또는 구청 문화체육과(7층)방문 신청','PARTICIPATION','2025-06-23 00:10:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736408&code=10008769'),('2025-08-12 10:24:36.223373',76,'2025년 서울시(도봉구) 평생교육 이용권 신청 접수(2차) 공고','도봉구에서는 경제적 여건에 따른 교육 격차를 해소하고 도봉구민의 평생 학습 기회를 확대 제공하기 위하여다음과 같이「2025년 서울시(도봉구) 평생교육 이용권(2차)」신청 접수를 공고합니다.■ 접수기간:2025. 6. 26. (목) 10:00 ~ 7. 10. (목) 18:00※ 7월 말 선정 예정■ 지원기간:2025. 8월(예정) ~ 12. 31. (수)■','PARTICIPATION','2025-06-22 08:51:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736397&code=10008769'),('2025-08-12 10:24:36.234130',77,'2025년 도봉구 청년 경제금융교육 신청 안내','도봉구 청년의 올바른 금융가치관 형성 및 안정적인 자산 관리를 지원하고자 다음과 같이\"도봉구 청년 경제금융교육\"을 운영하오니관심있는 도봉구 청년들의 많은 참여 바랍니다. ○모집대상:도봉구 청년(19세~45세)및 관심있는 구민 누구나(※선착순 마감) ○모집인원:회차별 선착순50명 이내(※중복신청 가능) ○신청방법:https://forms.gle/bFrxWof','PARTICIPATION','2025-06-20 04:21:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736374&code=10008769'),('2025-08-12 10:24:36.246329',78,'시원한 여름, 따뜻한 겨울 \'\'2025년도 에너지바우처\'\'','○시원한 여름,따뜻한 겨울“2025년도 에너지바우처”에너지취약계층의 냉·난방비(전기, 도시가스, 지역난방, 등유, LPG, 연탄 등)를 지원하는 제도입니다.1.신청장소: 주민등록상 거주지 동 행정복지센터※거동이 불편한 분은 대리신청 또는 담당 공무원의 직권신청도 가능하니 동 행정복지센터에 사전 문의2. 신청기간: 2025. 6. 9. ~2025. 12. 3','PARTICIPATION','2025-06-20 04:15:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736373&code=10008769'),('2025-08-12 10:24:36.258710',79,'2025년 도봉구 중랑천 물놀이장 개장','-2025년 도봉구 중랑천 물놀이장 개장-무더위를 식혀줄 을 개장합니다.○ 장소:중랑천 물놀이장 2개소(도봉동 서원아파트 106동 앞, 창동 17단지아파트 인근 녹천교 하류)○일시:2025.7.4.(금)~8.24.(일) ※ 매주 화요일 및 우천(예보)시 휴장○시간: 11시~16시40분(40분 물놀이, 20분 휴식)○이용대상: 만2세~중학생 미만 아동 및 동',NULL,'2025-06-20 04:13:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736372&code=10008769'),('2025-08-12 10:24:36.272898',80,'2025년 제2차 생활안정자금 융자 신청 안내','「2025년 제2차 생활안정자금 융자 신청 안내」관련 내용을 구 홈페이지 공지사항에 아래와 같이 게시하고자 합니다.?게재 내용○제 목:2025년 제2차 생활안정자금 융자 신청 안내○신청대상1.주민등록상 주소지가 도봉구로서 정기소득이 있는 구민(1세대1인 신청)2.신용등급1~6등급으로서 금융기관 여신 관리규정상 여신 적격자3.가구합산 재산세 연30만원 이하이','PARTICIPATION','2025-06-19 06:37:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736351&code=10008769'),('2025-08-12 10:24:36.489574',82,'2025년 하반기 청년구정체험단(舊대학생아르바이트) 추첨결과 및 선발등록 안내','>1.선발자 명단: 붙임파일 참고-2025. 6. 23.(월) 18:00까지 반드시 선발 등록(=구비서류 제출)-기한 내 미등록 시 선발 자동취소되며 예비선발 대상자에게 선발기회가 부여됩니다.※ 모집결과: 총 접수인원 702명, 경쟁률 8.8 :12. 당첨자 등록- 등록기간: 2025. 6. 23.(월) 18:00까지-등록방법: 증빙서류 이메일 제출(이메일','PARTICIPATION','2025-06-18 06:39:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736328&code=10008769'),('2025-08-12 10:24:36.510856',84,'위해 축산물(축산물가공품)긴급회수문 게시','광주광역시 소재 식육가공업소 부적합 제품［제품명: 류시윤한우한마리곰국(식육추출가공품)］의 검사 결과 대장균군 부적합 내역이 있어 긴급회수하고자 긴급회수문을 게시하고자 합니다.붙임 위해 축산물 긴급회수문 1부. 끝.','ANNOUNCEMENT','2025-06-18 01:47:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736323&code=10008769'),('2025-08-12 10:24:36.516577',85,'쌍문3주택정비형재개발구역 주민협의체 제6차 회의 개최 공고','-쌍문3주택정비형재개발구역-주민협의체 제6차 회의 개최 공고도봉구 쌍문3주택정비형재개발구역에 대하여「조합설립 지원을 위한 업무기준」제14조 제1항에 따라 주민협의체 제5차 회의를 개최하고자 붙임와 같이 공고하오니 해당 위원님께서는 참석하여 주시기 바랍니다.붙임 쌍문3주택정비형재개발구역 주민협의체 제6차 회의 개최 공고문1부.끝.','PARTICIPATION','2025-06-17 08:28:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736300&code=10008769'),('2025-08-12 10:24:36.526167',86,'붉은등우단털파리(러브버그) 이렇게 대처하세요','붉은등우단털파리(러브버그) 대처방법에 대해 알려드립니다■발생시기: 6~7월■특징(1)성충의 수명 7일 내외(2)성충은 화분매개자, 애벌레는 토양 유기물 분해하여 토양을 기름지게 하는 역할로 익충임(3)독성이 없고 사람을 물거나 질병을 옮기지 않음■대처요령(1)야간 조명 밝기 최소화(2)출입문 틈새 및 방충망 점검(3)실내 유입 시 휴지, 빗자루 등 물리적',NULL,'2025-06-17 06:48:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736294&code=10008769'),('2025-08-12 10:24:36.528751',87,'2025년 1차 배달 플랫폼종사자 안전교육 참여자 모집','2025년1차『함께 만들어요!안전 배달 문화』배달플랫폼종사자 안전교육 참여자 모집 공고배달 플랫폼종사자의 안전사고 예방을 위하여「배달 플랫폼종사자 안전교육」을 운영하고,교육 이수자의 안전을위한안전용품을다음과 같이 지원하고자 하니 많은 관심과 참여 바랍니다.※안전용품:블랙박스,액션캠中택11.사업개요가.교육일시:2025. 7. 15.(화) 14:00 ~ 16:','PARTICIPATION','2025-06-15 02:15:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736239&code=10008769'),('2025-08-12 10:24:36.539246',88,'2025년 제3회『도봉 양말 디자인 그림 공모전』수상자 발표','2025년 제3회 『도봉 양말 디자인 그림 공모전』수상자 발표우리 도봉구의 대표 산업인 양말제조업을 알리고자 실시한2025년 제3회『도봉 양말 디자인 그림공모전』에 참여해 주신 모든 분들께 감사드리며,붙임과 같이 수상자를 선정하여 알려드립니다.붙임『도봉 양말 디자인 그림 공모전』수상자 명단1부. 끝.','PARTICIPATION','2025-06-13 06:08:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736217&code=10008769'),('2025-08-12 10:24:36.546245',90,'지진안전 시설물 인증 지원사업 안내','「지진·화산재해대책법」제16조의3(지진안전 시설물의 인증 및 인증의 취소)에 따라 민간소유 건축물에 대한 내진보강을 권장하기 위하여지진안전 시설물 인증지원사업수요조사를 다음과 같이 실시하오니 희망하는 분들은 신청하여 주시기 바랍니다.□사업개요○사업목적:민간건축물 내진보강을 통해 전국민 안전 확보○사업기한:~’26.12.31.○사업대상:지진안전 시설물 인증을','PARTICIPATION','2025-06-13 01:21:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736211&code=10008769'),('2025-08-12 10:24:36.556441',91,'오존 주의보 발령','2025. 6. 12.(목) 17시오존 주의보가 발령되어 안내하오니 건강관리에 유의하시기 바랍니다.발 령 일: 2025. 6. 12.(목) 17시발령지역:서울시[안내사항]○실외 활동과 과격한 운동 자제○어린이집,유치원,학교 실외수업 자제 또는 제한○승용차 운행 자제,대중교통 이용○스프레이,드라이클리닝,페인트칠,신나 사용을 줄임 ○한낮의 더운 시간대를 피해','NOTICE','2025-06-12 08:01:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736200&code=10008769'),('2025-08-12 10:24:36.559430',92,'2025 도봉구 「청소년 미래인재 캠프」참가자 모집','도봉구에서는 국립청소년수련시설의 우수한 시설과 다양한 활동 프로그램을 통해또래 관계 협동심 및 공동체 의식을 함양하고 꿈을 설계할 수 있는도봉구 청소년 미래인재 캠프참가자를 모집합니다. 많은 관심과 참여 바랍니다.○ 캠프개요- 캠프기간: 2025. 8. 6.(수)~8. 8.(금), 2박3일- 캠프대상:관내 초등학교5~6학년30명(도봉구민에 한함)- 캠프장소','PARTICIPATION','2025-06-12 06:20:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736197&code=10008769'),('2025-08-12 10:24:36.569069',93,'지역문화예술인 「우리소리 버스킹」 안내','지역문화예술인 「우리소리 버스킹」 안내도봉구 지역문화예술인 버스킹 공연이 열립니다!7080, 트로트, 민요 등 다양한 장르의 음악 공연과 더불어 마술 공연을 즐길 수 있는도봉구 지역문화예술인 버스킹 공연에도봉구민 여러분의 많은 관심 부탁드립니다.1. 일  시: 2025. 6. 20.(금) 17:00 ~ 18:302. 장  소: 창동역 1번 출구 앞 광장3.','NOTICE','2025-06-11 08:48:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736169&code=10008769'),('2025-08-12 10:24:36.576587',94,'[-농구선수 우지원과 함께하는- 스포츠가치 교육캠프] 모집 안내','스포츠강좌이용권 이용자 대상 스포츠가치 교육캠프를 운영하오니 대상자분들의 많은신청 바랍니다.운영안내>■일 시: 2025년6월28일(토)~29일(일)※ 출발시간08:30■장 소: KSPO스포츠가치센터(경남진주시)※집결지:서울고속버스터미널■신청자격:5세~18세기초생활수급,차상위,법정한부모가정 자녀※보호자 동반 필수■모집일시: 6월9일(월)~6월22일(일)■접수','PARTICIPATION','2025-06-10 08:05:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736134&code=10008769'),('2025-08-12 10:24:36.585783',95,'2025년 소규모사업장(4·5종) 대기배출원조사표 제출 안내','환경부 국가미세먼지정보센터는 「대기환경보전법」 제17조 등에 근거하여 매년 소규모사업장(4·5종) 대기배출원조사를 실시하고 있어 안내하오니, 해당 사업장에서는 조사표를 작성하여 제출하여 주시기 바랍니다.가. 제출대상 : 2024년 기준 소규모 대기배출사업장(4·5종)나. 제출기한 : 2025. 9. 12. (금)다. 작성방법 : 「4·5종 대기배출원조사표」','NOTICE','2025-06-10 08:01:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736132&code=10008769'),('2025-08-12 10:24:36.594314',96,'2025년 대·중소기업 동반성장 유공 포상 안내','2025년 대·중소기업 동반성장 유공 포상 후보자를 다음과 같이 모집하오니, 많은 신청 바랍니다.o포 상 명:2025년 대·중소기업 동반성장 유공 포상o포상목적: 동반성장 및 상생협력 확산 등에 기여한 자를 선정, 포상하여 대·중소기업 간 동반성장 촉진을 유도o포상대상: 대·중소기업 동반성장을 통하여 기업의 경쟁력을 향상시키고, 국가 경제발전에 기여한 개인','PARTICIPATION','2025-06-10 07:28:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736125&code=10008769'),('2025-08-12 10:24:36.606963',97,'2025년 소상공인 창업교육 수강생 모집','2025년 소상공인 창업교육 수강생 모집□ 모집기간:2025. 6. 11.(수) ~ 6. 29.(일)※ 선착순 모집으로 모집인원 충족 시 조기마감□ 모집대상: 예비 창업자, 소상공인, 업종 전환자 등 40명□ 교육일시:2024. 7. 3.(목) ~ 7. 4.(금) 10:00~17:00□ 교육장소: 도봉구청 M4층 위당홀(마들로656)□ 신청방법:소상공인아카','PARTICIPATION','2025-06-10 06:34:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736124&code=10008769'),('2025-08-12 10:24:36.613991',98,'2025년 시각,청각장애인용TV 보급사업 유상보급 신청 안내','2025년 시각,청각장애인용TV 신청 안내(유상보급, 2차)1. 보급대수:전국 15,000대(유상보급)2. 사업대상:보건복지부 등록시각,청각장애인또는국가보훈부 등록눈,귀 상이등급자3. 부담비용:선정시자부담50,000원4. 신청기간:2025. 6. 9.(월) ~ 6. 27.(금)※ 신청기간 외 접수 불가5. 신청방법:주소지 관할 동주민센터방문신청또는홈페이지','PARTICIPATION','2025-06-10 02:22:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736115&code=10008769'),('2025-08-12 10:24:36.622688',99,'탄소공감마일리지 환경의 날 이벤트','\'2050 탄소중립\' 실현 주체인 주민의 자발적 실천을 촉진하고자 개발한 도봉형 환경마일리지인 \'탄소공(Zero)감(減)마일리지\'가환경의 날(6.5.)을 맞아 다음과 같이이벤트를 진행하오니, 많은 참여 부탁드립니다.●기  간: 2025. 6. 5.(목) ~ 6. 26.(목)●대  상:도봉구민 및 도봉구 생활권자*(탄소공감 인증회원)●방  법: 탄소공감 설치','PARTICIPATION','2025-06-10 01:51:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736112&code=10008769'),('2025-08-12 10:24:36.629966',100,'[방학1동] 2025년 제3기(7~9월) 자치회관 교양강좌 수강생 모집','2025년도 방학1동 자치회관제3기(7~9월)교양강좌 수강생 모집◎수강기간: 2025. 7. ~ 9. (3개월)*법정/임시공휴일 제외◎접수기간▶방학1동 주민:2025.6.24.(화)~마감 시(09:00~18:00,선착순,토·일/공휴일 제외)▶다른 동 주민:2025.6.27.(금)~마감 시(09:00~18:00,선착순,토·일/공휴일 제외)◎접수방법:정원 범위','PARTICIPATION','2025-06-10 00:15:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736101&code=10008769'),('2025-08-14 21:04:44.055101',201,'2025 도봉 여름 와글와글 물놀이장 임시휴장 안내','2025 도봉 와글와글 물놀이장이 우천으로 인하여 2025. 8. 14.(목) 임시 휴장함을알려드립니다.○ 휴장일시: 2025. 8. 14.(목) 10:00~17:00 일정 변경시, 홈페이지에 별도 안내할 예정이오니, 도봉구청 홈페이지를 참고하여 주시기 바랍니다.물놀이장 콜센터 ☎ 010-2548-7826문화체육과 ☎ 2091-2544','NOTICE','2025-08-13 23:34:00.000000',NULL,1,6,NULL,'물놀이장, 휴장, 우천, 도봉구, 임시휴장','2025. 8. 14.(목) 우천으로 인한 도봉 와글와글 물놀이장 임시 휴장 안내','문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737694&code=10008769'),('2025-08-14 21:04:44.185591',202,'중랑천 물놀이장 하천 범람 피해 휴장[8.13.(수)~]','- 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 하천 범람으로 인하여 오염되어 휴장함을 알려드립니다.(복구가 완료되면 홈페이지를 통해 재개장 공지 예정입니다.)○ 장   소:중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)○휴장 일시: 2025.8.13.(수)~○ 문   의: 치수과(02-2091-4142)','NOTICE','2025-08-13 08:19:00.000000',NULL,1,6,NULL,'휴장, 물놀이장, 중랑천, 도봉구, 하천 범람, 오염','하천 범람으로 인한 중랑천 물놀이장 휴장을 알리고 재개장 시기를 홈페이지를 통해 공지할 것을 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737692&code=10008769'),('2025-08-14 21:04:44.199784',203,'2025년 제8회 도봉구 인권작품 공모전','2025년 제8회 도봉구 인권작품 공모전1. 공 모 명 :2025년 제8회 도봉구 인권작품 공모전2. 접수기간 :2025. 8. 20.(수) ~ 10. 15.(수)※ 등기우편의 경우, 접수 마감일 18시까지 소인분에 한함3. 공모주제 : 학교/직장, 존중, 자유, 기후환경 등 인권 관련4. 공모분야 :그림, 운문(시, 동시, 시조 등), 영상5. 접수방법','PARTICIPATION','2025-08-13 00:20:00.000000',NULL,1,6,NULL,'인권, 공모전, 도봉구, 그림, 운문, 영상','인권 관련 작품 공모를 통한 인권 의식 고취','도봉구',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737679&code=10008769'),('2025-08-14 21:04:44.227873',205,'쌍문3동 통장 모집 공고(19통)','쌍문3동 19통 통장 공개모집 공고를 다음과 같이 게재하고자 합니다.□ 모집대상: 쌍문3동 19통□ 통장 신청자격: 해당 통의 관할 구역 내에 주민등록이 되어있고 거주하는 사람□ 제출서류 ○ 신청서 1부(동 주민센터 비치 및 첨부파일 참조)  - 해당 통 반장 2명 이상 또는 세대주 10명 이상 연명 ○ 이력서 1부(반명함판 사진 1매 부착) ○ 자기소개서','PARTICIPATION','2025-08-12 05:57:00.000000',NULL,1,6,NULL,'통장, 공개모집, 쌍문3동, 19통','쌍문3동 19통 통장을 공개 모집하기 위함','쌍문3동 주민센터',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737669&code=10008769'),('2025-08-14 21:04:44.239833',206,'2025년 지역주택조합 실태조사 결과','우리구에서 시행한 \"2025년 지역주택조합 실태조사 결과\"를 게시합니다.□ 대   상: 쌍문동137번지 지역주택조합□ 조사기간: 2025. 6. 16.~7. 16.□ 조사방법: 전문가(변호사, 회계사), 구 합동점검□ 조사결과: 첨부파일 참조','ANNOUNCEMENT','2025-08-12 04:47:00.000000',NULL,1,6,NULL,'지역주택조합, 실태조사, 쌍문동137번지, 합동점검','2025년 쌍문동 137번지 지역주택조합 실태조사 결과 공개','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737661&code=10008769'),('2025-08-14 21:04:44.414581',218,'어르신 스포츠상품권 신청 안내(8. 20.까지 기한 연장)','스포츠시설에서 사용할 수 있는「어르신 스포츠상품권」신청방법을 아래와 같이 안내드립니다.■지원대상: 65세 이상기초연금수급자■신청기간:2025. 8. 4.(월) 09:00 ~2025. 8. 20.(수)■신청방법:온라인 신청(http://ssvoucher.co.kr) 또는 전용 콜센터(☎1551-9998)에서 전화 신청■지원내용:스포츠시설 이용료5만 원 지급○','PARTICIPATION','2025-08-01 06:39:00.000000',NULL,1,6,NULL,'어르신, 스포츠상품권, 신청, 기초연금, 스포츠시설','스포츠시설 이용료 지원을 위한 어르신 스포츠상품권 신청 방법 안내','관련 부서 명칭(추정)',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737425&code=10008769'),('2025-08-14 21:04:44.734669',231,'2025년「스포츠강좌이용권 단기스포츠체험강좌」변경사항 안내','스포츠강좌이용권 단기스포츠체험강좌 프로그램 내용이 변경되었으니 참조하시기 바랍니다.강좌 안내>※프로그램별로 참여 조건이 다르므로 참가 전 꼭 확인 바랍니다!!!■참여일시: ~2025년 12월■참가자격: 5세~18세 기초생활수급,차상위,법정한부모가정 자녀※보호자1인 동반 가능(보호자2인 이상이면1인 비용만 지원)■신청일시:전월1일~20일(※날짜별선착순신청)■','PARTICIPATION','2025-07-24 08:52:00.000000',NULL,1,6,NULL,'스포츠강좌이용권, 단기스포츠체험강좌, 프로그램 변경, 참여 조건','스포츠강좌이용권 단기스포츠체험강좌 프로그램 내용 변경 사항 안내','스포츠 관련 부서, 아동복지 관련 부서',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737222&code=10008769'),('2025-08-17 00:18:39.836394',1140,'[백인제가옥] 2025년 온라인교육 \'백인제가옥의 숨겨진 비밀을 찾아라!\'(8월)',' 가족(학부모 1인, 자녀 1인)',NULL,'2025-08-17 00:23:37.113749',NULL,1,24,NULL,'복지, 교육','',NULL,NULL,NULL),('2025-08-17 00:18:39.861328',1141,'2025 백인제가옥 전시해설 예약',' 제한없음',NULL,'2025-08-17 00:23:37.162229',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:39.880244',1142,'2025년 목편만들기(매주 일 14:00~16:00)',' 유아(만5세이상), 초등학생',NULL,'2025-08-17 00:23:37.184603',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:39.898405',1143,'2025년 미니장승만들기(매주 토 10:30~12:30)',' 유아(만5세이상), 초등학생',NULL,'2025-08-17 00:23:37.202871',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:39.916962',1144,'2025년 미니솟대만들기( 매주 토 14:00~16:00)',' 유아(만5세이상), 초등학생',NULL,'2025-08-17 00:23:37.222523',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:39.936234',1145,'2025년 짚공예 체험(매주 일요일 10:30~12:30)',' 유아(만5세이상), 초등학생',NULL,'2025-08-17 00:23:37.245486',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:39.955430',1146,'[청계천박물관] 8월 개방형교육 <우리들의 친구, 청계천박물관> 모집 안내',' 유아(유아교육기관 및 가족)','PARTICIPATION','2025-08-17 00:23:37.266294',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:39.974374',1147,'[청계천박물관] (광복 80주년 기념) 8월 22일 유아가족교육 <궁금이의 그림책 박물관> 모집 안내',' 가족(6~8세 유아 및 동반가족)','PARTICIPATION','2025-08-17 00:23:37.289885',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:39.993611',1148,'[청계천박물관] 초등 4~6학년 학급단체 교육 <졸졸졸 개천, 콸콸콸 준천> 모집 안내 (수/하반기)',' 어린이(초등4~6학년 학급단체)','PARTICIPATION','2025-08-17 00:23:37.311074',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:40.013866',1149,'[청계천박물관] 유아 단체 교육 <꼬물꼬물 청계천 보물찾기> 모집 안내',' 유아(유아 단체( 5~7세))','PARTICIPATION','2025-08-17 00:23:37.334826',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.034722',1150,'[청계천박물관] 초등 특수학급 단체 교육 <오감으로 만지는 청계천이야기> 모집 안내',' 어린이(초등1-6학년특수학급단체)','PARTICIPATION','2025-08-17 00:23:37.356964','2025-01-05 15:00:00.000000',1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.054404',1151,'[청계천박물관] 2025년 하반기 온라인 교육 <톡톡톡 청계천> 참여기관 모집',' 어린이(지역아동센터 및 초등돌봄교실)','PARTICIPATION','2025-08-17 00:23:37.374306',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.073942',1152,'[청계천박물관] 8월 29일 유아가족교육 <궁금이의 그림책 박물관> 모집 안내',' 가족(6~8세 유아 및 동반가족)','PARTICIPATION','2025-08-17 00:23:37.391041',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.093524',1153,'경교장 전시해설 사전예약 (8월)',' 제한없음',NULL,'2025-08-17 00:23:37.406816',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.112419',1154,'[월드컵공원] 꿈나무정원사 (평일 유아, 8월, 냠냠, 향기를 먹자)',' 유아',NULL,'2025-08-17 00:23:37.422090',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.134044',1155,'(도봉구)꽃동네책쉼터,숲속놀이터 가족프로그램(토요일)',' 초등학생(초등생이상 가족)',NULL,'2025-08-17 00:23:37.437505',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.154084',1156,'(야간_8월)쉼이 있는 한양도성-충신성곽마을',' 성인(성인만 참여가능)','PARTICIPATION','2025-08-17 00:23:37.453429',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:40.175435',1157,'〔산림치유〕서울대공원 치유의 숲, 2025 행복숲(사회적약자 단체)',' 성인',NULL,'2025-08-17 00:23:37.469988',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.195236',1158,'〔산림치유〕서울대공원 치유의 숲, 2025.8월 하늘빛 마중숲(개인,유료)',' 성인',NULL,'2025-08-17 00:23:37.486970',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.217760',1159,'〔산림치유〕서울대공원 치유의 숲, 2025.9월 하늘빛 마중숲(개인,유료)',' 성인',NULL,'2025-08-17 00:23:37.504936',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.240924',1160,'〔산림치유〕서울대공원 치유의 숲, 2025.8월 힐링숲(단체, 유료)',' 성인',NULL,'2025-08-17 00:23:37.522432',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.261397',1161,'〔산림치유〕서울대공원 치유의 숲, 2025.9월 힐링숲(단체, 유료)',' 성인',NULL,'2025-08-17 00:23:37.538112',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.286481',1162,'[산림치유] 서울대공원 산림치유센터, 2025.8월 여유드림(개인,유료)',' 성인',NULL,'2025-08-17 00:23:37.555979',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.306736',1163,'[산림치유] 서울대공원 산림치유센터, 2025.9월 여유드림(개인,유료)',' 성인',NULL,'2025-08-17 00:23:37.573954',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.325315',1164,'[보라매공원-정기체험] 어린이 공원 늘봄(화) (8월)',' 어린이',NULL,'2025-08-17 00:23:37.593090',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.345731',1165,'[보라매공원-정기체험] 유쾌한 숲으로 초대 - (단체신청) (목) (8월)',' 성인','PARTICIPATION','2025-08-17 00:23:37.609834',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.367259',1166,'[보라매공원-정기체험] 유쾌한 숲으로 초대 (개인신청) (목) (8월)',' 성인','PARTICIPATION','2025-08-17 00:23:37.626111',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.388127',1167,'[보라매공원-정기체험] 보라매 컬러가든투어(금) (8월)',' 성인',NULL,'2025-08-17 00:23:37.642940',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.409049',1168,'[보라매공원-정기체험] 보라매 가족나들이(토) (8월)',' 가족',NULL,'2025-08-17 00:23:37.660245',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.430887',1169,'(고덕) 풀 숲속 비밀 친구들',' 가족',NULL,'2025-08-17 00:23:37.678274',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.450943',1170,'(고덕) 응답하라 어린이 생태탐정 식물편',' 가족',NULL,'2025-08-17 00:23:37.695969',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.471774',1171,'(고덕) 달맞이꽃은 밤에만 필까?',' 가족',NULL,'2025-08-17 00:23:37.715630',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.490528',1172,'(고덕) 한강의 초본식물 이야기',' 가족',NULL,'2025-08-17 00:23:37.731690',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.510642',1173,'[한강야생탐사센터/특화] 한강에서우리함께',' 제한없음',NULL,'2025-08-17 00:23:37.746890',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.529634',1174,'(한강야생탐사센터/특화) 곤충을알다',' 성인, 초등학생(4학년이상)',NULL,'2025-08-17 00:23:37.762817',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:40.549075',1175,'(한강야생탐사센터/특화) 알기쉬운 곤충이야기',' 제한없음',NULL,'2025-08-17 00:23:37.778555',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.569504',1176,'(한강야생탐사센터/특화) 춤추는곤충',' 제한없음',NULL,'2025-08-17 00:23:37.797648',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.589480',1177,'[한강야생탐사센터/특화] 탐험가의 자격 시즌2',' 제한없음',NULL,'2025-08-17 00:23:37.816919',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.609655',1178,'(한강야생탐사센터/특화) 한강스마트팜체험',' 제한없음',NULL,'2025-08-17 00:23:37.833755',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.631187',1179,'(한강야생탐사센터/특화) 한강즐기기1,2',' 초등학생(3학년~6학년)',NULL,'2025-08-17 00:23:37.851683',NULL,1,24,NULL,'교육','','교육부',NULL,NULL),('2025-08-17 00:18:40.650950',1180,'(한강야생탐사센터/상시) 한강의 초본식물이야기',' 제한없음',NULL,'2025-08-17 00:23:37.870173',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.672220',1181,'[성북구](토) 8월 북한산 야간숲길여행',' 제한없음',NULL,'2025-08-17 00:23:37.888161',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.692785',1182,'[성북구](주말) 8월 북한산 숲길여행',' 가족',NULL,'2025-08-17 00:23:37.904340',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.713056',1183,'[성북구]2025년 가을철 북한산 자연놀이',' 유아',NULL,'2025-08-17 00:23:37.918629',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.733665',1184,'[성북구](토) 8월 개운산 야간숲길여행',' 제한없음',NULL,'2025-08-17 00:23:37.933125',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.754073',1185,'(토) 호현당에서 다함께 차차차(茶茶茶)',' 가족(7세이상 동반 가족)',NULL,'2025-08-17 00:23:37.949121',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.770702',1186,'[성북구](주말) 8월 개운산 숲길여행',' 가족',NULL,'2025-08-17 00:23:37.965542',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.787273',1187,'(토)신비한 꿀벌교실 꿀벌의 꿀잼생활',' 어린이(초등학생 저학년 동반 가족)',NULL,'2025-08-17 00:23:37.981626',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.802924',1188,'(목,금)신비한 꿀벌교실 꿀벌의 꿀잼생활',' 어린이(초등학생 저학년 동반 가족)',NULL,'2025-08-17 00:23:37.998546',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.832425',1189,'신비한 꿀벌교실 꿀벌의 꿀잼생활(유아단체)',' 유아(7세 어린이(유아단체))',NULL,'2025-08-17 00:23:38.016006',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.851734',1190,'(정원문화 특별) 잡학다식 식집사',' 성인',NULL,'2025-08-17 00:23:38.033107',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.871324',1191,'(토)남산숲 자연놀이',' 가족(초등학생이상 동반가족)',NULL,'2025-08-17 00:23:38.049988',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.891128',1192,'석호정 야간활쏘기',' 성인',NULL,'2025-08-17 00:23:38.066124',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.910204',1193,'석호정 가족활쏘기(어린이 동반가족)',' 가족(어린이(10세이상) 동반가족)',NULL,'2025-08-17 00:23:38.080475',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.930547',1194,'석호정 성인체험활쏘기',' 성인',NULL,'2025-08-17 00:23:38.095017',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:40.950065',1195,'호현당 서당체험(유아 단체)',' 어린이(6세, 7세 어린이)',NULL,'2025-08-17 00:23:38.110142',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.971569',1196,'호현당 서당체험(가족)',' 어린이(6세이상 어린이 동반 가족)',NULL,'2025-08-17 00:23:38.124549',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:40.991954',1197,'(일)노래로 배우는 사자소학',' 가족(7세이상 어린이 동반 가족)',NULL,'2025-08-17 00:23:38.138870',NULL,1,24,NULL,'청년, 교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.012548',1198,'(토) 호현당에서 심신다파(心身茶破)',' 성인(성인 누구나)',NULL,'2025-08-17 00:23:38.154655',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.031288',1199,'(일)서울 한양도성의 비밀',' 초등학생(초등 고학년이상 가족)',NULL,'2025-08-17 00:23:38.171167',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.049616',1200,'석호정 활쏘기',' 성인(성인(유료))',NULL,'2025-08-17 00:23:38.205086',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.083599',1201,'활쏘기 체험교육장(대학생)',' 성인(성인(유료))',NULL,'2025-08-17 00:23:38.221937',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.103224',1202,'전통활쏘기 교육프로그램(수금반)',' 성인(성인(유료))',NULL,'2025-08-17 00:23:38.242056',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.120671',1203,'전통활쏘기 교육프로그램(주말오전반)',' 성인(직장인(유료))',NULL,'2025-08-17 00:23:38.262136',NULL,1,24,NULL,'청년','',NULL,NULL,NULL),('2025-08-17 00:18:41.138217',1204,'전통활쏘기 교육프로그램(화목반)',' 성인(성인(유료))',NULL,'2025-08-17 00:23:38.281353',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.155283',1205,'(일) 남산 숲탐정 명탐정',' 가족(초등이상 가족)',NULL,'2025-08-17 00:23:38.296662',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.172592',1206,'한남 숲놀이터 (덩굴식물과 친구하기)',' 유아(유아를 동반한 가족)',NULL,'2025-08-17 00:23:38.310824',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.188821',1207,'(토) 낙산의 좌룡정 활시위를 당겨라',' 가족(초등3학년이상 가족)',NULL,'2025-08-17 00:23:38.329158',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.204276',1208,'2025년 그린웨딩 참여자 추가모집',' 성인(그린웨딩을 희망하는 예비부부)','PARTICIPATION','2025-08-17 00:23:38.344657',NULL,1,24,NULL,'환경','',NULL,NULL,NULL),('2025-08-17 00:18:41.219555',1209,'(토) 용산가족공원 숲티어링',' 초등학생(초등학생 동반 가족)',NULL,'2025-08-17 00:23:38.359684',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:41.234355',1210,'용산가족공원 꼬물꼬물 호기심 숲 (유아단체)',' 유아(6~7세 유아단체)',NULL,'2025-08-17 00:23:38.374278',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:41.249443',1211,'(일)(월) 여름숲의 오줌싸게 매미',' 가족(유아4세~10세 )',NULL,'2025-08-17 00:23:38.390578',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.264538',1212,'(토) 물의 정원, 식물 이야기',' 성인(개인 또는 단체 )',NULL,'2025-08-17 00:23:38.406728',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.280024',1213,'염주씨가 아름다워(팔찌)',' 가족(어린이 동반가족)',NULL,'2025-08-17 00:23:38.423118',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.296564',1214,'텃밭에 사는 곤충들 (유아단체)',' 유아',NULL,'2025-08-17 00:23:38.439120',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.313426',1215,'목화체험(전통기구 체험)',' 제한없음',NULL,'2025-08-17 00:23:38.454917',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.330777',1216,'자연물 염색 (유아단체)',' 유아',NULL,'2025-08-17 00:23:38.468819',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.347729',1217,'길동생태공원 입장예약(2025년)',' 제한없음',NULL,'2025-08-17 00:23:38.484647',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.364078',1218,'2025년 서울월드컵경기장 스타디움 투어 예약안내',' 제한없음','NOTICE','2025-08-17 00:23:38.498770',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.381516',1219,'토닥토닥(토)',' 제한없음',NULL,'2025-08-17 00:23:38.512283',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.401742',1220,'(중랑구) 숲해설 정기반 수시반 모집',' 제한없음(기관및 단체)','PARTICIPATION','2025-08-17 00:23:38.526059',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.422223',1221,'숲해설',' 제한없음',NULL,'2025-08-17 00:23:38.539645',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.442903',1222,'사제동행 숲해설',' 청소년',NULL,'2025-08-17 00:23:38.553615',NULL,1,24,NULL,'청년, 교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.464786',1223,'성북 역사문화 도보탐방(성북동,석관동,정릉)',' 제한없음(단, 초등학생 이상 ※ 초등학교 4학년까지는 보호자 동반 필수)',NULL,'2025-08-17 00:23:38.567685',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:41.485882',1224,'퇴근 후 정원생활(가을학기-2차)',' 성인',NULL,'2025-08-17 00:23:38.581580',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.506369',1225,'정원처방',' 제한없음',NULL,'2025-08-17 00:23:38.595713',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.526043',1226,'숲해설(유아대상)',' 유아',NULL,'2025-08-17 00:23:38.609037',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.550238',1227,'[유아단체] 2025 하반기 서울약령시한의약박물관 <내 친구 약초> 모집',' 유아(유아단체 )','PARTICIPATION','2025-08-17 00:23:38.623138',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.570561',1228,'[성북구](금) 8월 오동공원 야간숲길여행',' 제한없음',NULL,'2025-08-17 00:23:38.639645',NULL,1,24,NULL,NULL,'',NULL,NULL,NULL),('2025-08-17 00:18:41.591631',1229,'[성북구](주말) 8월 오동공원 숲길여행',' 가족',NULL,'2025-08-17 00:23:38.655601',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.611965',1230,'(관악구 당일체험형) 8/14(목)~8/17(일) 관악산 계곡 캠핑숲 - 피크닉 온 캠핑 \"샌드위치 한입! 파르페 한입!\"',' 가족(7세이상어린이동반가족)',NULL,'2025-08-17 00:23:38.671047',NULL,1,24,NULL,'청년, ','',NULL,NULL,NULL),('2025-08-17 00:18:41.631862',1231,'[성북구]2025년 가을철 개운산 자연놀이',' 유아',NULL,'2025-08-17 00:23:38.686415',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.649675',1232,'(중랑구) 용마산유아숲 주중 프로그램 (개인/단체/가족)',' 유아',NULL,'2025-08-17 00:23:38.702224',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.665884',1233,'양천구 생활안전체험교육관 교육 신청',' 가족(가족단위 토요교육 가능), 성인','PARTICIPATION','2025-08-17 00:23:38.718083',NULL,1,24,NULL,'교육','',NULL,NULL,NULL),('2025-08-17 00:18:41.681661',1234,'[온라인 교육&현장 교육] 2025 \'다정한 박물관 - 서울 속 세계\' 모집',' 초등학생(초등학교 3~5학년 학급 단체)','PARTICIPATION','2025-08-17 00:23:38.733324',NULL,1,24,NULL,'교육','','교육부, 시/도 교육청, 초등학교',NULL,NULL),('2025-08-17 00:18:41.696407',1235,'[은평역사한옥박물관] 초등 학급 대상 \"지혜가 담긴 한옥\"',' 어린이',NULL,'2025-08-17 00:23:38.748907',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.712141',1236,'(토)들숲날숲, 우리 가족의 꿈숲',' 가족',NULL,'2025-08-17 00:23:38.764061',NULL,1,24,NULL,'복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.727134',1237,'2025년 <느낌 있는 박물관> 교육생 모집 안내',' 장애인(중고등학교 특수학급 단체)','PARTICIPATION','2025-08-17 00:23:38.780921',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL),('2025-08-17 00:18:41.742920',1238,'[경의선숲길] 숲길 따라 교과 산책 (평일 초등, 8월, 똑똑한 식물들의 여름나기)',' 어린이(8~11세)',NULL,'2025-08-17 00:23:38.797935',NULL,1,24,NULL,'교육, 복지','',NULL,NULL,NULL);
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_categories`
--

DROP TABLE IF EXISTS `document_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `document_categories_document_id_category_id_346cc05e_uniq` (`document_id`,`category_id`),
  KEY `document_categories_category_id_e7fe262c_fk_category_id` (`category_id`),
  CONSTRAINT `document_categories_category_id_e7fe262c_fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `document_categories_document_id_4cc29f20_fk_document_document_id` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1727 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_categories`
--

LOCK TABLES `document_categories` WRITE;
/*!40000 ALTER TABLE `document_categories` DISABLE KEYS */;
INSERT INTO `document_categories` VALUES (1,1,8),(2,2,8),(3,3,8),(4,4,4),(5,4,7),(6,5,7),(8,6,4),(9,6,7),(7,6,8),(11,7,2),(10,7,8),(13,8,4),(14,8,6),(12,8,8),(16,9,7),(15,9,8),(17,10,7),(19,11,7),(18,11,8),(21,12,7),(20,12,8),(22,14,3),(23,14,5),(24,15,8),(25,16,7),(26,17,5),(27,17,6),(28,17,7),(29,18,2),(31,20,2),(32,20,6),(30,20,8),(33,21,7),(34,22,2),(35,22,7),(36,24,2),(37,24,5),(38,24,6),(40,25,7),(39,25,8),(42,26,4),(43,26,7),(41,26,8),(45,27,3),(44,27,8),(46,28,3),(47,28,5),(48,29,2),(50,30,2),(51,30,7),(49,30,8),(52,31,7),(54,33,7),(53,33,8),(55,34,2),(56,34,7),(58,35,4),(57,35,8),(59,36,3),(60,36,5),(61,37,3),(62,38,2),(63,39,8),(64,40,3),(65,41,8),(66,42,3),(67,43,3),(68,44,7),(70,45,4),(69,45,8),(71,46,2),(72,46,5),(73,46,7),(75,48,4),(76,48,6),(77,48,7),(74,48,8),(78,49,2),(79,49,6),(80,50,5),(81,51,5),(82,52,8),(83,53,7),(85,54,3),(84,54,8),(87,55,5),(86,55,8),(89,57,4),(88,57,8),(91,59,3),(92,59,4),(93,59,7),(90,59,8),(95,60,7),(94,60,8),(97,61,7),(96,61,8),(99,62,2),(100,62,7),(98,62,8),(101,66,2),(102,68,3),(103,68,7),(104,69,6),(106,70,3),(107,70,7),(105,70,8),(108,71,6),(109,71,7),(110,72,3),(111,73,3),(113,75,2),(114,75,7),(112,75,8),(116,76,4),(117,76,7),(115,76,8),(119,77,4),(120,77,7),(118,77,8),(122,78,7),(121,78,8),(123,79,3),(124,79,7),(126,80,4),(125,80,8),(127,82,8),(128,85,3),(129,85,7),(130,87,2),(131,87,6),(132,87,7),(134,90,6),(135,90,7),(133,90,8),(136,92,5),(137,93,2),(139,94,7),(138,94,8),(140,95,5),(141,95,6),(143,96,4),(142,96,8),(145,97,4),(144,97,8),(147,98,7),(146,98,8),(148,99,5),(149,100,8),(266,201,2),(267,202,3),(269,203,5),(268,203,8),(271,205,8),(272,206,3),(293,218,7),(292,218,8),(312,231,7),(311,231,8),(1627,1140,9),(1628,1141,2),(1629,1142,9),(1630,1143,9),(1631,1144,9),(1632,1145,9),(1633,1146,9),(1634,1147,9),(1635,1148,9),(1636,1149,9),(1637,1150,9),(1638,1151,7),(1639,1152,9),(1640,1153,2),(1641,1154,9),(1642,1155,9),(1643,1156,9),(1644,1157,9),(1645,1158,9),(1646,1159,9),(1647,1160,9),(1648,1161,9),(1649,1162,9),(1650,1163,9),(1651,1164,9),(1652,1165,8),(1653,1166,8),(1654,1167,9),(1655,1168,9),(1656,1169,9),(1657,1170,9),(1658,1171,9),(1659,1172,9),(1660,1173,9),(1661,1174,9),(1662,1175,9),(1663,1176,9),(1664,1177,9),(1665,1178,9),(1666,1179,9),(1667,1180,9),(1668,1181,9),(1669,1182,9),(1670,1183,9),(1671,1184,9),(1672,1185,9),(1673,1186,9),(1674,1187,9),(1675,1188,9),(1676,1189,9),(1677,1190,2),(1678,1191,9),(1679,1192,9),(1680,1193,9),(1681,1194,9),(1682,1195,9),(1683,1196,9),(1684,1197,9),(1685,1198,9),(1686,1199,9),(1687,1200,9),(1688,1201,9),(1689,1202,2),(1690,1203,2),(1691,1204,2),(1692,1205,9),(1693,1206,9),(1694,1207,9),(1695,1208,9),(1696,1209,9),(1697,1210,9),(1698,1211,9),(1699,1212,9),(1700,1213,9),(1701,1214,9),(1702,1215,9),(1703,1216,9),(1704,1217,9),(1705,1218,9),(1706,1219,9),(1707,1220,9),(1708,1221,9),(1709,1222,5),(1710,1223,2),(1711,1224,9),(1712,1225,9),(1713,1226,9),(1714,1227,9),(1715,1228,9),(1716,1229,9),(1717,1230,9),(1718,1231,9),(1719,1232,9),(1721,1233,6),(1720,1233,8),(1722,1234,9),(1723,1235,9),(1724,1236,9),(1725,1237,7),(1726,1238,9);
/*!40000 ALTER TABLE `document_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_scrap`
--

DROP TABLE IF EXISTS `document_scrap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_scrap` (
  `created_at` datetime(6) NOT NULL,
  `document_scrap_id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`document_scrap_id`),
  UNIQUE KEY `document_scrap_user_id_document_id_e8e3195e_uniq` (`user_id`,`document_id`),
  KEY `document_scrap_document_id_d854b8e9_fk_document_document_id` (`document_id`),
  CONSTRAINT `document_scrap_document_id_d854b8e9_fk_document_document_id` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`),
  CONSTRAINT `document_scrap_user_id_2ddb2436_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_scrap`
--

LOCK TABLES `document_scrap` WRITE;
/*!40000 ALTER TABLE `document_scrap` DISABLE KEYS */;
INSERT INTO `document_scrap` VALUES ('2025-08-14 21:08:09.586250',1,1,1),('2025-08-15 11:48:41.205596',2,3,1);
/*!40000 ALTER TABLE `document_scrap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fcm_device`
--

DROP TABLE IF EXISTS `fcm_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fcm_device` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `registration_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `registration_token` (`registration_token`),
  UNIQUE KEY `fcm_device_user_id_registration_token_e10882a3_uniq` (`user_id`,`registration_token`),
  CONSTRAINT `fcm_device_user_id_2a87d251_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fcm_device`
--

LOCK TABLES `fcm_device` WRITE;
/*!40000 ALTER TABLE `fcm_device` DISABLE KEYS */;
/*!40000 ALTER TABLE `fcm_device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `created_at` datetime(6) NOT NULL,
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL,
  `notification_time` datetime(6) NOT NULL,
  `read_time` datetime(6) DEFAULT NULL,
  `document_id` int NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notification_document_id_595194a8_fk_document_document_id` (`document_id`),
  KEY `notificatio_user_id_d569bc_idx` (`user_id`,`is_read`),
  KEY `notificatio_notific_9c41ca_idx` (`notification_time`),
  CONSTRAINT `notification_document_id_595194a8_fk_document_document_id` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`),
  CONSTRAINT `notification_user_id_1002fc38_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region_region`
--

DROP TABLE IF EXISTS `region_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region_region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `city` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `region_code` (`region_code`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region_region`
--

LOCK TABLES `region_region` WRITE;
/*!40000 ALTER TABLE `region_region` DISABLE KEYS */;
INSERT INTO `region_region` VALUES (1,'서울특별시',NULL,'11'),(2,'서울특별시','강남구','11230'),(3,'서울특별시','강동구','11250'),(4,'서울특별시','강북구','11090'),(5,'서울특별시','강서구','11160'),(6,'서울특별시','관악구','11210'),(7,'서울특별시','광진구','11050'),(8,'서울특별시','구로구','11170'),(9,'서울특별시','금천구','11180'),(10,'서울특별시','노원구','11110'),(11,'서울특별시','도봉구','11100'),(12,'서울특별시','동대문구','11060'),(13,'서울특별시','동작구','11200'),(14,'서울특별시','마포구','11140'),(15,'서울특별시','서대문구','11130'),(16,'서울특별시','서초구','11220'),(17,'서울특별시','성동구','11040'),(18,'서울특별시','성북구','11080'),(19,'서울특별시','송파구','11240'),(20,'서울특별시','양천구','11150'),(21,'서울특별시','영등포구','11190'),(22,'서울특별시','용산구','11030'),(23,'서울특별시','은평구','11120'),(24,'서울특별시','종로구','11010'),(25,'서울특별시','중구','11020'),(26,'서울특별시','중랑구','11070'),(27,'부산광역시',NULL,'21'),(28,'부산광역시','강서구','21120'),(29,'부산광역시','금정구','21110'),(30,'부산광역시','기장군','21510'),(31,'부산광역시','남구','21070'),(32,'부산광역시','동구','21030'),(33,'부산광역시','동래구','21060'),(34,'부산광역시','부산진구','21050'),(35,'부산광역시','북구','21080'),(36,'부산광역시','사상구','21150'),(37,'부산광역시','사하구','21100'),(38,'부산광역시','서구','21020'),(39,'부산광역시','수영구','21140'),(40,'부산광역시','연제구','21130'),(41,'부산광역시','영도구','21040'),(42,'부산광역시','중구','21010'),(43,'부산광역시','해운대구','21090'),(44,'대구광역시',NULL,'22'),(45,'대구광역시','군위군','22520'),(46,'대구광역시','남구','22040'),(47,'대구광역시','달서구','22070'),(48,'대구광역시','달성군','22510'),(49,'대구광역시','동구','22020'),(50,'대구광역시','북구','22050'),(51,'대구광역시','서구','22030'),(52,'대구광역시','수성구','22060'),(53,'대구광역시','중구','22010'),(54,'인천광역시',NULL,'23'),(55,'인천광역시','강화군','23510'),(56,'인천광역시','계양구','23070'),(57,'인천광역시','남동구','23050'),(58,'인천광역시','동구','23020'),(59,'인천광역시','미추홀구','23090'),(60,'인천광역시','부평구','23060'),(61,'인천광역시','서구','23080'),(62,'인천광역시','연수구','23040'),(63,'인천광역시','옹진군','23520'),(64,'인천광역시','중구','23010'),(65,'광주광역시',NULL,'24'),(66,'광주광역시','광산구','24050'),(67,'광주광역시','남구','24030'),(68,'광주광역시','동구','24010'),(69,'광주광역시','북구','24040'),(70,'광주광역시','서구','24020'),(71,'대전광역시',NULL,'25'),(72,'대전광역시','대덕구','25050'),(73,'대전광역시','동구','25010'),(74,'대전광역시','서구','25030'),(75,'대전광역시','유성구','25040'),(76,'대전광역시','중구','25020'),(77,'울산광역시',NULL,'26'),(78,'울산광역시','남구','26020'),(79,'울산광역시','동구','26030'),(80,'울산광역시','북구','26040'),(81,'울산광역시','울주군','26510'),(82,'울산광역시','중구','26010'),(83,'세종특별자치시',NULL,'29'),(84,'세종특별자치시','세종시','29010'),(85,'경기도',NULL,'31'),(86,'경기도','가평군','31570'),(87,'경기도','고양시 덕양구','31101'),(88,'경기도','고양시 일산동구','31103'),(89,'경기도','고양시 일산서구','31104'),(90,'경기도','과천시','31110'),(91,'경기도','광명시','31060'),(92,'경기도','광주시','31250'),(93,'경기도','구리시','31120'),(94,'경기도','군포시','31160'),(95,'경기도','김포시','31230'),(96,'경기도','남양주시','31130'),(97,'경기도','동두천시','31080'),(98,'경기도','부천시 소사구','31052'),(99,'경기도','부천시 오정구','31053'),(100,'경기도','부천시 원미구','31051'),(101,'경기도','성남시 분당구','31023'),(102,'경기도','성남시 수정구','31021'),(103,'경기도','성남시 중원구','31022'),(104,'경기도','수원시 권선구','31012'),(105,'경기도','수원시 영통구','31014'),(106,'경기도','수원시 장안구','31011'),(107,'경기도','수원시 팔달구','31013'),(108,'경기도','시흥시','31150'),(109,'경기도','안산시 단원구','31092'),(110,'경기도','안산시 상록구','31091'),(111,'경기도','안성시','31220'),(112,'경기도','안양시 동안구','31042'),(113,'경기도','안양시 만안구','31041'),(114,'경기도','양주시','31260'),(115,'경기도','양평군','31580'),(116,'경기도','여주시','31280'),(117,'경기도','연천군','31550'),(118,'경기도','오산시','31140'),(119,'경기도','용인시 기흥구','31192'),(120,'경기도','용인시 수지구','31193'),(121,'경기도','용인시 처인구','31191'),(122,'경기도','의왕시','31170'),(123,'경기도','의정부시','31030'),(124,'경기도','이천시','31210'),(125,'경기도','파주시','31200'),(126,'경기도','평택시','31070'),(127,'경기도','포천시','31270'),(128,'경기도','하남시','31180'),(129,'경기도','화성시','31240'),(130,'강원특별자치도',NULL,'32'),(131,'강원특별자치도','강릉시','32030'),(132,'강원특별자치도','고성군','32600'),(133,'강원특별자치도','동해시','32040'),(134,'강원특별자치도','삼척시','32070'),(135,'강원특별자치도','속초시','32060'),(136,'강원특별자치도','양구군','32580'),(137,'강원특별자치도','양양군','32610'),(138,'강원특별자치도','영월군','32530'),(139,'강원특별자치도','원주시','32020'),(140,'강원특별자치도','인제군','32590'),(141,'강원특별자치도','정선군','32550'),(142,'강원특별자치도','철원군','32560'),(143,'강원특별자치도','춘천시','32010'),(144,'강원특별자치도','태백시','32050'),(145,'강원특별자치도','평창군','32540'),(146,'강원특별자치도','홍천군','32510'),(147,'강원특별자치도','화천군','32570'),(148,'강원특별자치도','횡성군','32520'),(149,'충청북도',NULL,'33'),(150,'충청북도','괴산군','33560'),(151,'충청북도','단양군','33580'),(152,'충청북도','보은군','33520'),(153,'충청북도','영동군','33540'),(154,'충청북도','옥천군','33530'),(155,'충청북도','음성군','33570'),(156,'충청북도','제천시','33030'),(157,'충청북도','증평군','33590'),(158,'충청북도','진천군','33550'),(159,'충청북도','청주시 상당구','33041'),(160,'충청북도','청주시 서원구','33042'),(161,'충청북도','청주시 청원구','33044'),(162,'충청북도','청주시 흥덕구','33043'),(163,'충청북도','충주시','33020'),(164,'충청남도',NULL,'34'),(165,'충청남도','계룡시','34070'),(166,'충청남도','공주시','34020'),(167,'충청남도','금산군','34510'),(168,'충청남도','논산시','34060'),(169,'충청남도','당진시','34080'),(170,'충청남도','보령시','34030'),(171,'충청남도','부여군','34530'),(172,'충청남도','서산시','34050'),(173,'충청남도','서천군','34540'),(174,'충청남도','아산시','34040'),(175,'충청남도','예산군','34570'),(176,'충청남도','천안시 동남구','34011'),(177,'충청남도','천안시 서북구','34012'),(178,'충청남도','청양군','34550'),(179,'충청남도','태안군','34580'),(180,'충청남도','홍성군','34560'),(181,'전북특별자치도',NULL,'35'),(182,'전북특별자치도','고창군','35570'),(183,'전북특별자치도','군산시','35020'),(184,'전북특별자치도','김제시','35060'),(185,'전북특별자치도','남원시','35050'),(186,'전북특별자치도','무주군','35530'),(187,'전북특별자치도','부안군','35580'),(188,'전북특별자치도','순창군','35560'),(189,'전북특별자치도','완주군','35510'),(190,'전북특별자치도','익산시','35030'),(191,'전북특별자치도','임실군','35550'),(192,'전북특별자치도','장수군','35540'),(193,'전북특별자치도','전주시 덕진구','35012'),(194,'전북특별자치도','전주시 완산구','35011'),(195,'전북특별자치도','정읍시','35040'),(196,'전북특별자치도','진안군','35520'),(197,'전라남도',NULL,'36'),(198,'전라남도','강진군','36590'),(199,'전라남도','고흥군','36550'),(200,'전라남도','곡성군','36520'),(201,'전라남도','광양시','36060'),(202,'전라남도','구례군','36530'),(203,'전라남도','나주시','36040'),(204,'전라남도','담양군','36510'),(205,'전라남도','목포시','36010'),(206,'전라남도','무안군','36620'),(207,'전라남도','보성군','36560'),(208,'전라남도','순천시','36030'),(209,'전라남도','신안군','36680'),(210,'전라남도','여수시','36020'),(211,'전라남도','영광군','36640'),(212,'전라남도','영암군','36610'),(213,'전라남도','완도군','36660'),(214,'전라남도','장성군','36650'),(215,'전라남도','장흥군','36580'),(216,'전라남도','진도군','36670'),(217,'전라남도','함평군','36630'),(218,'전라남도','해남군','36600'),(219,'전라남도','화순군','36570'),(220,'경상북도',NULL,'37'),(221,'경상북도','경산시','37100'),(222,'경상북도','경주시','37020'),(223,'경상북도','고령군','37570'),(224,'경상북도','구미시','37050'),(225,'경상북도','김천시','37030'),(226,'경상북도','문경시','37090'),(227,'경상북도','봉화군','37610'),(228,'경상북도','상주시','37080'),(229,'경상북도','성주군','37580'),(230,'경상북도','안동시','37040'),(231,'경상북도','영덕군','37550'),(232,'경상북도','영양군','37540'),(233,'경상북도','영주시','37060'),(234,'경상북도','영천시','37070'),(235,'경상북도','예천군','37600'),(236,'경상북도','울릉군','37630'),(237,'경상북도','울진군','37620'),(238,'경상북도','의성군','37520'),(239,'경상북도','청도군','37560'),(240,'경상북도','청송군','37530'),(241,'경상북도','칠곡군','37590'),(242,'경상북도','포항시 남구','37011'),(243,'경상북도','포항시 북구','37012'),(244,'경상남도',NULL,'38'),(245,'경상남도','거제시','38090'),(246,'경상남도','거창군','38590'),(247,'경상남도','고성군','38540'),(248,'경상남도','김해시','38070'),(249,'경상남도','남해군','38550'),(250,'경상남도','밀양시','38080'),(251,'경상남도','사천시','38060'),(252,'경상남도','산청군','38570'),(253,'경상남도','양산시','38100'),(254,'경상남도','의령군','38510'),(255,'경상남도','진주시','38030'),(256,'경상남도','창녕군','38530'),(257,'경상남도','창원시 마산합포구','38113'),(258,'경상남도','창원시 마산회원구','38114'),(259,'경상남도','창원시 성산구','38112'),(260,'경상남도','창원시 의창구','38111'),(261,'경상남도','창원시 진해구','38115'),(262,'경상남도','통영시','38050'),(263,'경상남도','하동군','38560'),(264,'경상남도','함안군','38520'),(265,'경상남도','함양군','38580'),(266,'경상남도','합천군','38600'),(267,'제주특별자치도',NULL,'39'),(268,'제주특별자치도','서귀포시','39020'),(269,'제주특별자치도','제주시','39010');
/*!40000 ALTER TABLE `region_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `user_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth` date DEFAULT NULL,
  `gender` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'2025-08-12 10:18:39.065207','GUEST1','김덕사','2000-01-01','F');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_category`
--

DROP TABLE IF EXISTS `user_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_category_user_id_category_id_7ad801ba_uniq` (`user_id`,`category_id`),
  KEY `user_category_category_id_93714e6f_fk_category_id` (`category_id`),
  CONSTRAINT `user_category_category_id_93714e6f_fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `user_category_user_id_30474d1a_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_category`
--

LOCK TABLES `user_category` WRITE;
/*!40000 ALTER TABLE `user_category` DISABLE KEYS */;
INSERT INTO `user_category` VALUES (11,1,1),(12,2,1);
/*!40000 ALTER TABLE `user_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_region`
--

DROP TABLE IF EXISTS `user_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_region_user_id_region_id_dd1cc9ee_uniq` (`user_id`,`region_id`),
  KEY `user_region_region_id_5e8d346c_fk_region_region_id` (`region_id`),
  CONSTRAINT `user_region_region_id_5e8d346c_fk_region_region_id` FOREIGN KEY (`region_id`) REFERENCES `region_region` (`id`),
  CONSTRAINT `user_region_user_id_5d3a3fd0_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_region`
--

LOCK TABLES `user_region` WRITE;
/*!40000 ALTER TABLE `user_region` DISABLE KEYS */;
INSERT INTO `user_region` VALUES (5,'거주지',11,1),(6,'관심지역',4,1);
/*!40000 ALTER TABLE `user_region` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-19  1:23:07
