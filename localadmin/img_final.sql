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
) ENGINE=InnoDB AUTO_INCREMENT=1636 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document`
--

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
INSERT INTO `document` VALUES ('2025-08-12 10:24:35.612824',29,'우이천 음악분수 재가동 안내[7.23.(수)~]','- 우이천 음악분수 재가동 안내 -우천 및 우이천 범람으로 중단되었던우이천 음악분수가재가동됨을 알려드립니다.○재가동 일시: 2025.7.23.(수)~※우천(예보)시 가동 중지○ 문의: 치수과(02-2091-4142)','NOTICE','2025-07-23 04:33:00.000000',NULL,1,6,NULL,'환경','우이천 음악분수 재가동 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737180&code=10008769'),('2025-08-12 10:24:35.625020',30,'2025년「장애인 스포츠강좌이용권」이용자 추가모집 알림','2025년 장애인 스포츠강좌이용권 불용 인원 발생으로 추가 대상자를 모집하고자 하오니 관심 있으신 분들의 많은 신청 바랍니다.신청 안내>■신청기간:2025. 7. 23.(수) ~ 2025. 7. 31.(목)※선착순아님■신청방법:장애인스포츠강좌이용권 홈페이지(http://dvoucher.kspo.or.kr)에서 온라인 신청또는 구청 문화체육과(7층)방문 신청','PARTICIPATION','2025-07-22 07:04:00.000000',NULL,1,6,NULL,'스포츠, 복지','2025년 장애인 스포츠강좌이용권 불용 인원 발생에 따른 추가 대상자 모집','구청 문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737163&code=10008769'),('2025-08-12 10:24:35.634776',31,'2025년 도봉구 장애인친화미용실 운영 안내','-운영기간: 2025년 8월 ~-사업대상: 도봉구 관내 장애인-참여업체: 총 14개소 미용실(동별 1개소)※동별 장애인친화 미용실 현황쌍문1동쌍문2동쌍문3동쌍문4동방학1동방학2동방학3동오땡큐헤어르호봇헤어클럽마르떼헤어나인헤어핀컬스토리헤어아카페미용실온스타일헤어방학점창1동창2동창3동창4동창5동도봉1동도봉2동구구미용실한가희헤어샵오옥희헤어샵영헤어hair doo비제이','PARTICIPATION','2025-07-21 23:56:00.000000',NULL,1,6,NULL,'복지','도봉구 관내 장애인에게 미용 서비스 제공','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737145&code=10008769'),('2025-08-12 10:24:35.643510',32,'2025년 제10차 건축위원회(서면) 심의 개최 결과 알림','2025년 제10차 건축위원회(서면) 심의 개최 결과를 첨부와 같이 알려드립니다.','NOTICE','2025-07-21 09:31:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/f5fb4fe0e3cd0f327aa66aa5349cff63.files/1.png','건축, 주택','2025년 제10차 건축위원회(서면) 심의 개최 결과 알림',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737141&code=10008769'),('2025-08-12 10:24:35.648857',33,'방학동 모아타운(1구역) 조합설립 공공지원을 위한 주민대표(후보자) 공모 공고','방학동 모아타운(1구역)조합설립 공공지원을 위한 주민대표(후보자)공모 공고□목 적○방학동(1구역)SH참여형 모아타운 공공관리사업의주민대표(후보자)를 선정하여SH와 소통 및 해당 구역의 조합설립이 원활하게 추진될 수 있도록사업시행 초기단계를 지원하고자 합니다.□일 정○공 고 일: 2025. 7. 21.(월), SH·도봉구청 홈페이지 게시○신청기간: 2025.','PARTICIPATION','2025-07-21 08:45:00.000000',NULL,1,6,NULL,'주택, 도시계획, 재정','방학동(1구역) SH참여형 모아타운 공공관리사업의 주민대표(후보자)를 선정하여 SH와 소통 및 해당 구역의 조합설립이 원활하게 추진될 수 있도록 사업시행 초기단계를 지원','SH공사, 도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737139&code=10008769'),('2025-08-12 10:24:35.661203',34,'\'\'도봉구 여름 물놀이장으로 장애인 가족 초대\'\'','올해 무더운 여름!!장애인 가족의 시원한 여름이야기!도봉구 문화체육과에서 운영하고 있는 물놀이장을 자유롭게 이용할 수 없는 장애인 가족분들을 초대하여 마음껏 즐길 수 있는 자리를 마련하고자 하오니 많은 관심과 참여바랍니다.□ 제  목:‘도봉구 여름 물놀이장으로 초대’ 장애인 가족의 시원한 여름이야기□ 운영시간:2025. 7. 27.(일) 13:00 ~17:','PARTICIPATION','2025-07-21 04:40:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/223bb760aae6c637c3ee12b14ae5897f.files/image.jpg','복지, 스포츠','장애인 가족의 무더운 여름을 시원하게 보낼 수 있도록 물놀이장 이용 기회 제공','도봉구 문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737131&code=10008769'),('2025-08-12 10:24:35.673926',35,'2025년 서울 매력일자리 사업 \'\'전통시장 매니저\'\' 채용 공고','2025년 서울 매력일자리 사업 \'전통시장 매니저\' 채용을 다음과 같이 공고합니다.1. 채용인원: 2명2. 공고기간: 2025. 7. 21.(월) ~ 7. 31.(목) [10일간]3. 접수기간: 2025. 7. 25.(금) ~ 7. 31.(목) 17:00까지 [5일간]4. 접수방법 - 방문 접수: 도봉구청 6층 지역경제과 - 전자우편 접수:haein0920','PARTICIPATION','2025-07-21 00:09:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/bbda15a492976d3ed677741f7e0c16a0.files/1.png','청년, 재정','2025년 서울 매력일자리 사업 \'전통시장 매니저\' 채용','도봉구청 지역경제과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737118&code=10008769'),('2025-08-12 10:24:35.685240',36,'중랑천 물놀이장 우천피해 휴장 [7.20.(일)~]','- 우천피해 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천 및 중랑천 수위 상승으로 인하여 오염되어 휴장함을 알려드립니다.청소 및 시설물 점검 후 재개장 예정입니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.20.(일)~□문의: 치수과(02-2091-4142)','NOTICE','2025-07-20 00:30:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천 및 중랑천 수위 상승으로 인한 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737109&code=10008769'),('2025-08-12 10:24:35.693909',37,'중랑천 물놀이장 우천 휴장[7.19.(토)]','- 우천 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천 및 중랑천 수위 상승으로 인하여 휴장함을 알려드립니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.19.(토)□문의: 치수과(02-2091-4142)','NOTICE','2025-07-18 07:01:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천 및 중랑천 수위 상승으로 인한 중랑천 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737092&code=10008769'),('2025-08-12 10:24:35.704595',38,'2025 도봉 여름 와글와글 물놀이장 개장연기 안내','2025. 7. 18.(금) 개장 예정이던, 2025 도봉 와글와글 물놀이장이 우천으로 인하여개장을 연기함을 알려드립니다.○ 개장일시: 2025. 7. 20.(일) 10시 추후 휴장시, 홈페이지에 별도 안내할 예정이오니, 도봉구청 홈페이지를 참고하여 주시기 바랍니다.물놀이장 콜센터 ☎ 010-2548-7826문화체육과 ☎ 2091-2544','NOTICE','2025-07-18 00:47:00.000000',NULL,1,6,NULL,'스포츠, 청년, 복지','2025 도봉 와글와글 물놀이장 개장 연기 안내','문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737071&code=10008769'),('2025-08-12 10:24:35.716042',39,'2025년 도봉구 양성평등상 표창 추천 공고','여성친화도시 도봉구에서는 양성평등의 촉진, 여성의 사회참여 확대, 여성의 인권보호및 권익증진 등 양성평등 정책에 공적이 큰 구민 및 단체(기관)를 발굴하여 도봉구 양성평등상을 표창하고자 하오니 공적이 우수한 후보자를 추천하여 주시기 바랍니다.1. 추천기간: 2025. 7. 18.(금) ~ 8. 6.(수)2. 표창부문: 3개 분야 각 5명이내(개인 또는 단체','PARTICIPATION','2025-07-18 00:38:00.000000',NULL,1,6,NULL,'복지, 교육','양성평등 정책에 공적이 큰 구민 및 단체(기관) 발굴 및 포상','여성가족과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737070&code=10008769'),('2025-08-12 10:24:35.727577',40,'중랑천 물놀이장 우천 휴장[7.18.(금)]','- 우천 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천 및 중랑천 수위 상승으로 인하여 휴장함을 알려드립니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.18.(금)□문의: 치수과(02-2091-4142)','NOTICE','2025-07-18 00:08:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천 및 중랑천 수위 상승으로 인한 중랑천 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737068&code=10008769'),('2025-08-12 10:24:35.849815',41,'민생회복 소비쿠폰 신청 안내','「민생회복 소비쿠폰」신청방법을 아래와 같이 안내드리오니 아래의 내용을 참고하시어 신청기간내에 신청하여 주시기 바랍니다.※ 민생회복 소비쿠폰 지급을 사칭한 스미싱·스팸문자를 주의하세요!(정부 및 카드사 등은 URL이나 링크가 포함된 문자메세지를 보내지 않습니다. 신고 ☎ 118 상담센터)가. 대   상 : 도봉구민※ 미성년자는 주민등록 세대주 신청?수령, 주','PARTICIPATION','2025-07-17 05:35:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/b49dbbc394eeb1cfe681019803dda578.files/image.jpg','재정, 복지','민생회복 소비쿠폰 신청방법 안내',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737054&code=10008769'),('2025-08-12 10:24:35.864155',42,'신축 공동주택 실내공기질 자가측정 결과서(롯데캐슬 골든파크)','?실내공기질 관리법? 제9조제2항의 규정에 따라붙임과 같이 신축 공동주택 실내공기질 자가측정 결과를 구 누리집에 게시하고자 합니다.붙임 실내공기질 자가측정 결과보고서(롯데캐슬 골든파크) 1부. 끝.','REPORT','2025-07-16 07:06:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/90a7798ed5a475c3ce5be7319909c149.files/1.png','환경','실내공기질 관리법 제9조제2항에 따른 신축 공동주택 실내공기질 자가측정 결과 게시',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737030&code=10008769'),('2025-08-12 10:24:35.876295',43,'중랑천 물놀이장 우천 휴장 [7.16.(수)~7.17.(목))','- 우천 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 우천으로 인하여 휴장함을 알려드립니다.□ 장   소: 중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)□휴장 일시: 2025.7.16.(수)~7.17.(목)□문의: 치수과(02-2091-4142)','NOTICE','2025-07-16 00:27:00.000000',NULL,1,6,NULL,'스포츠, 환경','우천으로 인한 중랑천 물놀이장 휴장 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737020&code=10008769'),('2025-08-12 10:24:35.887097',44,'「2026학년도 대입 수시  전략 설명회」개최 안내','- 2025년 도봉구 진학 아카데미 -「2026학년도 대입 수시 전략 설명회」개최 안내 도봉구 교육지원과에서는 「2026학년도 대입 수시 전략 설명회」를       다음과같이 개최하오니, 많은 참여 바랍니다.○ 일시:2025. 8. 5.(화) 18:30~20:30○ 장소: 도봉구청 2층 선인봉홀○ 대상: 2026학년도 대입준비생 및 학부모 3','PARTICIPATION','2025-07-15 02:22:00.000000',NULL,1,6,NULL,'교육','2026학년도 대입 수시 전략 설명회 개최','도봉구 교육지원과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736989&code=10008769'),('2025-08-12 10:24:35.894322',45,'2025년 서울시(도봉구) 평생교육 이용권 2차 추가 모집 접수 안내','도봉구에서는 경제적 여건에 따른 교육격차를 해소하고 도봉구민의 평생학습 기회를 확대 제공하기 위하여「2025년 서울시(도봉구)평생교육 이용권(2차)」신청 접수를 받았으나,접수 마지막날(7.10.)온라인 접수 홈페이지 동시접속자가 폭증하여 신청접수가 불가한 상황이 발생하여 다음과 같이 추가 모집 접수를 공고합니다.■추가 접수기간:2025년7월16일(수) 09','PARTICIPATION','2025-07-14 10:25:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/a29a14e4efa5178a72cb6c68e1e64142.files/image.jpg','교육, 복지','경제적 여건에 따른 교육격차 해소 및 평생학습 기회 확대','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736981&code=10008769'),('2025-08-12 10:24:35.904634',46,'덜 달달 9988 원정대 사업 안내(초등4~6학년 대상)','서울시에서는 (조)부모와 자녀가 함께 참여하는 아동청소년의 당류 섭취 저감 인식개선 프로그램인 \'덜 달달 원정대\' 운영 준비중이며, \'손목닥터 9988\' 앱을 통해2025. 7. 16.(수)정식 오픈할 예정입니다. 이와 관련하여 오프라인 행사도 아래와같이 진행하오니, 아이들이 건강한 식습관을 형성할 수 있도록 많은 관심과 참여 부탁드립니다.□덜 달달 998','PARTICIPATION','2025-07-14 07:58:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/44f408ca6641b8a4aafa81c77909e8e5.files/image.jpg','청년, 교육, 복지','아동청소년의 당류 섭취 저감 및 건강한 식습관 형성',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736976&code=10008769'),('2025-08-12 10:24:35.913087',47,'2025년 하반기 신중년 아카데미 수강생 모집','◆ 프로그램 안내                           프로그램교육기간교육장소모집인원수강료아로마 관리사2급 자격증 과정8. 13. ~ 10. 1.[8회](매주 수)14:00 ~ 15:30삼육대학교평생교육원302호 강의실20명18,000원실버인지놀이지도사1급 자격증 과정8. 12. ~ 9. 30.[8회](매주 화)15:40 ~ 17:40도봉구청지하1','PARTICIPATION','2025-07-14 05:12:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/caa59f916b7b947dd685c0037813a2cc.files/image.jpg','교육','','삼육대학교평생교육원, 도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736970&code=10008769'),('2025-08-12 10:24:35.916998',48,'2025년 플랫폼종사자 고용·산재 보험료 지원사업 공고','사회보험 사각지대에 있던 플랫폼종사자에 대해 사회보험 가입 장려 및 사회안전망 강화를 도모하고자 『2025년 플랫폼종사자 고용·산재보험료』 지원사업을 다음과 같이 시행함을 공고합니다.1. 사 업 명: 2025년 플랫폼종사자 고용·산재보험료 지원사업2. 신청기간- (1차) 2025. 7. 8. ~ 8. 14.- (2차) 2025. 11. 1. ~ 11. 30','PARTICIPATION','2025-07-14 02:24:00.000000',NULL,1,6,NULL,'복지','사회보험 사각지대에 있던 플랫폼종사자에 대해 사회보험 가입 장려 및 사회안전망 강화',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736962&code=10008769'),('2025-08-12 10:24:35.924446',49,'2025년 『함께 만들어요! 안전 배달 문화』 배달 플랫폼종사자 안전운전 캠페인 참여자 모집','배달 플랫폼종사자의 안전사고 예방 및 휴게공간 제공을 위하여 「배달 플랫폼종사자 안전운전 캠페인」을 시행하고, 안전운전 캠페인 참여자를 대상으로 달달쉼터 이용 바우처를 지급하고자 하오니 많은 관심과 참여 바랍니다.□ 사업개요1. 사업기간: 2025. 7. 14. ~ 8. 22.(6주)2. 사업대상: 도봉구 거주 또는 도봉구가 노무 제공장소인 배달 플랫폼종사','PARTICIPATION','2025-07-14 02:22:00.000000',NULL,1,6,NULL,'복지, 안전','배달 플랫폼종사자의 안전사고 예방 및 휴게공간 제공','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736961&code=10008769'),('2025-08-12 10:24:35.931287',50,'탄소공감마일리지 환경의 달 이벤트 결과 안내','\'2050 탄소중립\' 실현 주체인 주민의 자발적 실천을 촉진하고자 개발한 도봉형 환경마일리지인 \'탄소공(Zero)감(減)마일리지\'가 환경의 날(6.5.)을 맞아 이벤트를 진행하고 다음과 같이 결과를 안내드립니다.□이벤트 기간:2025. 6. 5.(목) ~ 6. 26.(목)□이벤트 대상:도봉구민 및 도봉구 생활권자(탄소공감 인증회원)□이벤트 결과①신규가입 인','NOTICE','2025-07-11 07:56:00.000000',NULL,1,6,NULL,'환경','탄소중립 실현을 위한 주민 참여 독려 및 탄소공감마일리지 홍보','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736916&code=10008769'),('2025-08-12 10:24:35.938226',51,'배달종사자 온열질환 예방가이드 알림','?? 배달종사자 여러분!폭염 속 건강, 이렇게 지켜주세요!여름철 폭염은 배달·대리운전 종사자 여러분의건강과 생명에 큰 위협이 될 수 있습니다.특히체감온도 31℃ 이상의 환경에서는온열질환(열사병, 열탈진 등)위험이 급격히 높아지므로 아래 수칙을 꼭 실천해 주세요.? 폭염 대응 5대 기본수칙1.물을 자주 마셔요!(갈증을 느끼기 전에 수시로 섭취)2.그늘이나 시','NOTICE','2025-07-10 01:35:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/5fb9ec3deffca07ae3fb01ca2e31d894.files/1.png','복지','폭염으로 인한 배달종사자의 온열질환 예방',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736873&code=10008769'),('2025-08-12 10:24:35.944120',52,'도봉 아카데미‘드론 크리에이터’ 수강생 모집 안내 게재','◆프로그램 안내○교육장소:창동아우르네 대강당(마들로13길 84)교육명교육기간인원수강료드론 크리에이터8. 5. ~ 8. 14.(화,목) 14:00~16:00[4회]30명9,000원※프로그램과 관련된 상세 일정 및 내용은 홈페이지 수강 신청 시 강의계획서를 통해 확인하실 수 있습니다!◆수강 신청 안내○모집기간: 2025. 7. 28.(월) 10:00 ~ 8.','PARTICIPATION','2025-07-09 00:37:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/11dc669a486dbd5ce27337cb2973a5c8.files/1.png','교육','드론 크리에이터 교육 프로그램 운영',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736846&code=10008769'),('2025-08-12 10:24:35.951735',53,'[마감]도봉구 청년 직업적성 및 흥미검사 프로그램(3회차) 참여자 모집','취업준비생 등청년을 대상으로‘STRONG직업흥미검사 해석 프로그램’을 실시하여청년들의 자기이해 도모 및 진로·직업 흥미에 대한 가치관 파악과 진로탐색을지원하오니 청년들의 많은 참여 바랍니다.*교 육 명:도봉구 청년 직업흥미검사 집단 해석 특강(STRONG검사 기반)*교육일정:2025. 8. 6.(수) 15:00 ~ 17:00*교육장소:도봉구청2층 세미나실1','PARTICIPATION','2025-07-09 00:37:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/0bd938f27f728d4b6ee5328548fb10d6.files/image.jpg','청년, 교육','취업준비생 등 청년들의 자기이해 도모 및 진로·직업 흥미에 대한 가치관 파악과 진로탐색 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736845&code=10008769'),('2025-08-12 10:24:35.957827',54,'도봉 아카데미‘알기쉬운 부동산 경매 재테크 여행’ 수강생 모집 안내 게재','◆프로그램 안내○교육장소:도봉구청 지하1층 은행나무방(마들로 656)교육명교육기간인원수강료알기쉬운 부동산 경매재테크 여행8. 7. ~ 9. 25.(목)10:00~12:00[8회]25명18,000원※프로그램과 관련된 상세 일정 및 내용은 홈페이지 수강 신청 시 강의계획서를 통해 확인하실 수 있습니다!◆수강 신청 안내○모집기간: 2025. 7. 28.(월) 1','PARTICIPATION','2025-07-09 00:35:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/89f64b855c454a47be614839d2058572.files/1.png','교육, 재정','부동산 경매 재테크 관련 교육 제공','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736844&code=10008769'),('2025-08-12 10:24:35.965029',55,'2025년「도봉구 청소년 미래인재캠프」참여자 선정 결과 알림','2025년「도봉구 청소년 미래인재 캠프」참여자 선정결과를 다음과 같이 안내 드립니다.□선발 개요○모집기간: 2025. 7. 1.(화)~7. 10.(목)※1일차 선착순 마감 및 접수 종료○접수인원:총40명 -선착순 선정 인원: 30명 -예비 선정 인원: 10명○선발방법: 참여자의주소지 자격 검증 후 최종 선발□선발 결과: [붙임]파일 참고○2025. 7. 1','PARTICIPATION','2025-07-08 07:20:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/a02a1551166f1e86a7a02c2225c4c851.files/1.png','청년, 교육','2025년「도봉구 청소년 미래인재 캠프」참여자 선정결과 안내',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736832&code=10008769'),('2025-08-12 10:24:35.972677',56,'오존주의보 발령','2025. 7. 7.(월) 16시오존 주의보가 발령되어 안내하오니 건강관리에 유의하시기 바랍니다.발 령 일: 2025. 7. 7.(월) 16시발령지역:서울시[안내사항]○실외 활동과 과격한 운동 자제○어린이집,유치원,학교 실외수업 자제 또는 제한○승용차 운행 자제,대중교통 이용○스프레이,드라이클리닝,페인트칠,신나 사용을 줄임 ○한낮의 더운 시간대를 피해 아침','NOTICE','2025-07-07 07:01:00.000000',NULL,1,6,NULL,'환경','오존 주의보 발령에 따른 시민 건강 관리 안내','서울시',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736806&code=10008769'),('2025-08-12 10:24:35.975957',57,'도봉구 중소기업창업보육센터 입주기업 모집','《도봉구 중소기업창업보육센터 입주자 모집》■모집기간:2025. 7. 8.(화) ~ 7. 21.(월)■모집센터:도봉구 제1중소기업창업보육센터(마들로13길61,씨드큐브 창동5층)■입주대상:공고일 기준,설립7년 미만의 중소기업 창업자(사업자등록必)■입주기간:최장3년(최초2년, 1회에 한해1년 연장 가능)■신청방법:담당자 이메일 접수(jhj9852@dobong.g','PARTICIPATION','2025-07-07 00:10:00.000000',NULL,1,6,NULL,'청년, ','중소기업 창업 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736791&code=10008769'),('2025-08-12 10:24:35.986817',58,'2025년 제9차 건축위원회 심의 결과 안내','2025년 제9차 건축위원회 개최 결과를 첨부와 같이 알려드립니다.','NOTICE','2025-07-04 02:15:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/9b088e8740d778ffae9997665cf68048.files/1.png','주택, 건축','2025년 제9차 건축위원회 개최 결과 알림',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736749&code=10008769'),('2025-08-12 10:24:35.989755',59,'2025년 중소기업육성기금 융자 지원 신청 안내','○ 지원규모: 32억 원○ 지원대상: 사업자등록증상 소재지가 도봉구인 중소기업 및 소상공인○지원내용: 업체당 1억 원 이내, 연리 1.5%(2년 거치 3년 균등분할상환)○ 지원조건: 부동산 또는 신용보증서 담보(서울신용보증재단 발급)○신청방법: 국민은행 신도봉지점 방문 신청○접수기간: 2025. 7. 7.(월) ~ 7. 21.(월)○ 문  의- 도봉구청 지','PARTICIPATION','2025-07-03 01:01:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/6a032fef82423534a4decddb73d70967.files/1.png','재정, 중소기업','중소기업 및 소상공인의 경영 안정 지원','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736708&code=10008769'),('2025-08-12 10:24:36.001004',60,'[신청마감/유선문의] 나민애 교수 초청 「학부모 아카데미 명사특강」 개최 안내','도봉구 교육지원과에서 서울대학교 글쓰기 과목 교수이자 시 큐레이터로 활동 중인 나민애 교수님을 초빙하여 명사특강을 운영할 예정이오니 구민 여러분의 많은 관심과 참여 부탁드립니다. 1. 일  시: 2025. 7. 22.(화) 10:00 ~ 11:30 2. 장  소: 도봉구청 2층 선인봉홀 3. 대  상: 구민 400명 4. 주  제: 독서가 공부머리를 만든다','PARTICIPATION','2025-07-02 06:55:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/6afb6ce2ab3c0f0c52bc9a09fd4fdcdc.files/image.jpg','교육','구민 대상 명사특강 운영','도봉구 교육지원과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736681&code=10008769'),('2025-08-12 10:24:36.121094',61,'2025년 여름방학 「우리동네 돌봄터 가요」 수강생 모집(7. 7. ~ 7. 11. 18:00까지)','여름방학 중 돌봄이 필요한 초등학생을 대상으로 학교 밖 교육공간에서 운영되는‘우리동네돌봄터가요’를운영하오니학생들의 많은 신청 바랍니다.○신청기간:2025. 7. 7.(월)09:00 ∼ 7. 11.(금) 18:00○신청방법:도봉구교육포털도봉배움e홈페이지에서 신청(http://edu.dobong.go.kr)   ※추첨운영, 1인2개까지 신청 가능○신청대상:도봉','PARTICIPATION','2025-07-02 05:16:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/938e8178b6df54987cfa9107f2d1651b.files/image.jpg','교육, 복지','여름방학 중 돌봄이 필요한 초등학생에게 교육 및 돌봄 서비스 제공','도봉구청 교육 관련 부서',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736678&code=10008769'),('2025-08-12 10:24:36.135649',62,'2025년「도봉구-귀뚜라미 문화재단」장학생 추천 알림 및 신청 안내','- 2025년『도봉구-귀뚜라미 문화재단』-장학생 신청 안내귀뚜라미 문화재단에서 도봉구 장학생 지원 결정에 따라지역사회에공헌할관내 우수 인재를 장학생으로 추천하여 지원 예정이니 많은 관심과신청 바랍니다.※세부내용:【붙임1】『도봉구-귀뚜라미 문화재단』장학생 추천 공고문 참고○접수기간: 2025. 7. 10.(목) ~ 7. 17.(목) (8일간)○추천인원:총70','PARTICIPATION','2025-07-01 09:20:00.000000',NULL,1,6,NULL,'청년, 교육, 재정','지역사회에 공헌할 관내 우수 인재 장학생 선발 및 지원','도봉구청, 귀뚜라미 문화재단',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736656&code=10008769'),('2025-08-12 10:24:36.146319',63,'&lt;&lt; 2025년 하반기「청년구정체험단」(舊대학생아르바이트) 부서배치 안내 &gt;&gt;','년 하반기「청년구정체험단」(舊대학생아르바이트)부서배치 안내>1.부서배치 명단:붙임파일 참고 2. 2025년 하반기 청년구정체험단 근무 안내  -근무기간:2025. 7. 4.(금) ~ 8. 1.(금)  -근무조건:주5일, 1일5시간  ※부서사정에 따라 토,일,공휴일 근무,평일 휴무 형태로 진행될 수 있으며,09:00~20:00중1일5시간 범위 내에서 근무시간','NOTICE','2025-07-01 01:02:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/ee71c388d349dbd92817334f2cc023f5.files/1.png','청년, 교육','청년구정체험단 부서 배치 안내 및 근무 안내',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736629&code=10008769'),('2025-08-12 10:24:36.150921',64,'취업준비 청년 공기업/공공기관 NCS 필기 대비과정(기본+심화 문제풀이) 참여자 모집','공기업/공공기관 채용 전형의 첫번째 관문인 NCS 필기 대비과정을 운영하니, 관심있는 청년들의 많은 참여 바랍니다!■ 교육개요/커리큘럼○기 간: 2025년 7월 7일(월) ~ 7월 25일(금) 월/수/금 13:30 ~ 17:30회차강의일정교육내용1회차7/7(월) 13:30공기업 NCS 전반 · 유형별 문제풀이 전략 소개2회차7/9(수) 13:30의사소통 영','PARTICIPATION','2025-06-30 09:17:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/b0f7d8236e81f512c1795a8c1946c356.files/image.png','청년, 교육','공기업/공공기관 채용 NCS 필기시험 대비',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736619&code=10008769'),('2025-08-12 10:24:36.154828',65,'2025년제8차 건축위원회 심의 결과 안내','2025년 제8차 건축위원회 개최 결과를 첨부와 같이 알려드립니다.','NOTICE','2025-06-30 02:04:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/012eac6bbaa686b8e5f01b3fbd8eac69.files/1.png','주택, 건축','2025년 제8차 건축위원회 개최 결과 알림',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736602&code=10008769'),('2025-08-12 10:24:36.157329',66,'도봉구청 광장 야외 영화상영 취소 안내','비 예보로 인하여6월 28일(토) 예정되었던 도봉구청 광장 야외 무료 영화상영이사전 취소되었음을 안내드립니다.구민 여러분의 많은 양해 바랍니다.','NOTICE','2025-06-28 08:51:00.000000',NULL,1,6,NULL,'복지, 스포츠','야외 무료 영화상영 취소 안내','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736579&code=10008769'),('2025-08-12 10:24:36.163190',67,'2025년 공원 내 물놀이장 운영 안내','2025년 공원 내 물놀이장 운영 안내올여름 무더위를 식혀줄 어린이 물놀이장을 운영하니 많은 이용 바랍니다.○ 장 소: 3개소- 다락원체육공원(창포원로 45), 둘리뮤지엄(시루봉로1길 6), 방학사계광장(방학동 710)○ 이용대상: 13세 이하 어린이○ 이 용 료: 무료○ 기타사항- 영유아는 보호자 반드시 함께 이용- 수영복과 모자, 물놀이용 신발 등 착용','NOTICE','2025-06-27 05:08:00.000000',NULL,1,6,NULL,'청년, , 스포츠, 교육, , 환경, 재정','어린이 물놀이장 운영을 통한 무더위 해소',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736562&code=10008769'),('2025-08-12 10:24:36.166446',68,'쌍문3주택정비형재개발구역 주민협의체 제6차 회의 결과 공고','- 쌍문3주택정비형재개발구역 -주민협의체 제6차 회의 결과 공고도봉구 쌍문3주택정비형재개발구역에 대하여 「조합설립 지원을 위한 업무기준」 제14조에 따라 주민협의체 제6차 회의를 개최하고 결과를 붙임와 같이 공고합니다.붙임 쌍문3주택정비형재개발구역 주민협의체 제6차 회의 결과 공고문 1부. 끝.','PARTICIPATION','2025-06-25 09:12:00.000000',NULL,1,6,NULL,'재정','쌍문3주택정비형재개발구역 주민협의체 제6차 회의 결과 공고',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736510&code=10008769'),('2025-08-12 10:24:36.173500',69,'6월 식품접객업소 위생점검 사전예고문 게시','서울시에서「대학가 주변 및 유흥업소 밀집지역 등 주류 판매 접객업소」에대한 위생 점검을 시행합니다.식품접객업소의 위생 수준을 높이고 안전한 먹거리에 대한 시민들의 신뢰 제고를 위해 기획점검을 진행하며,점검의 투명성과 실효성 확보를 위하여 민관합동 및 자치구별 교차점검으로 추진합니다.2025년6월 식품접객업소 위생점검을 아래와 같이 시행함을사전에 예고드리니,',NULL,'2025-06-25 05:26:00.000000',NULL,1,6,NULL,'복지, 환경','식품접객업소 위생 수준 향상 및 안전한 먹거리에 대한 시민 신뢰 제고','서울시',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736498&code=10008769'),('2025-08-12 10:24:36.178830',70,'2025년 안심집수리 융자 지원사업 참여자 모집 변경공고','-2025년 안심 집수리 융자 지원사업 변경공고-저층주거지 노후주택 집수리를 위한2025년 안심 집수리 융자 지원사업의 일부 사항이 개선되어 변경 사항을 공고 드리오니,구민 분들의 많은 참여 바랍니다.□사업내용:노후 저층주택 집수리 비용 융자지원□접수기간: 2025. 4. 9.(수)~8. 8.(금)[단,예산 소진 시까지]□대상주택:서울시 내 사용승인 후20','PARTICIPATION','2025-06-25 04:38:00.000000',NULL,1,6,NULL,'복지, 재정','노후 저층주택 집수리 비용 융자 지원',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736496&code=10008769'),('2025-08-12 10:24:36.187966',71,'세상에서 가장 아름다운 약속 「무연고 어르신 유산기부 지원 사업」','-세상에서 가장 아름다운 약속-무연고 어르신 유산기부 지원사업무연고 어르신 사망 시,어렵게 일군 재산이 내 생각과 다르게 처리될 수 있습니다.소중한 유산이 주변의 이웃에게 희망으로 이어질 수 있도록도봉구가 안전하고 투명한 기부 절차를 지원 및 연계해드립니다.○사 업 명:세상에서 가장 아름다운 약속「무연고 어르신 유산기부 지원 사업」-서울사회복지공동모금회 유','PARTICIPATION','2025-06-25 01:41:00.000000',NULL,1,6,NULL,'복지, 청년','무연고 어르신 사망 시 재산의 안전하고 투명한 기부 절차 지원 및 연계','도봉구',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736491&code=10008769'),('2025-08-12 10:24:36.195364',72,'&lt;쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정 용역&gt; 제안서 평가위원 모집 안내','우리 구에서 추진중인‘쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정용역’과 관련하여,「지방자치단체를 당사자로 하는 계약에 관한 법률 시행령」제43조에 따라 제안서 평가를 위한 평가위원(후보자)을 다음과 같이 모집합니다.가.용역명:쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정 용역나.모집기간: 2025.06.24.~ 07.03','PARTICIPATION','2025-06-24 08:30:00.000000',NULL,1,6,NULL,'주택, 법, 재정','쌍문동26번지 일대 주택재개발 정비계획 수립 및 정비구역 지정 용역 제안서 평가위원 모집',NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736474&code=10008769'),('2025-08-12 10:24:36.204066',73,'★모집기간 연장★ 2025 도봉취업아카데미 아파트시설관리자 양성과정 수강생 모집','서울특별시 기술교육원 북부캠퍼스와 도봉구청이 함께하는\'아파트시설관리자 양성과정\' 교육생을 아래와 같이 모집합니다.관심 있는 도봉구민 여러분의 많은 참여 바랍니다.□ 모집안내· 모집대상: 도봉구민· 모집기간: 2025. 6. 18.(수) ~7. 10.(목)모집기간 연장· 모집정원: 20명· 면접일정: 7월 9일 (수) ※개별연락· 합격자발표: 7월 10일 (','PARTICIPATION','2025-06-23 08:28:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/5f948d30be4e1b9f662ca35f46387582.files/image.jpg','교육, 주택','아파트시설관리자 양성','서울특별시 기술교육원 북부캠퍼스, 도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736448&code=10008769'),('2025-08-12 10:24:36.213542',75,'「2025년 장애인 스포츠강좌이용권」추가모집 알림','2025년 장애인 스포츠강좌이용권 불용 인원 발생으로 추가 대상자를 모집하고자 하오니 관심 있으신 분들의 많은 신청 바랍니다.신청 안내>■신청기간:2025. 6. 23.(월) ~ 2025. 6. 29.(일)※선착순아님■신청방법:장애인스포츠강좌이용권 홈페이지(http://dvoucher.kspo.or.kr)에서 온라인 신청또는 구청 문화체육과(7층)방문 신청','PARTICIPATION','2025-06-23 00:10:00.000000',NULL,1,6,NULL,'스포츠, 청년, 복지, 문화','2025년 장애인 스포츠강좌이용권 불용 인원 발생에 따른 추가 대상자 모집','구청 문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736408&code=10008769'),('2025-08-12 10:24:36.223373',76,'2025년 서울시(도봉구) 평생교육 이용권 신청 접수(2차) 공고','도봉구에서는 경제적 여건에 따른 교육 격차를 해소하고 도봉구민의 평생 학습 기회를 확대 제공하기 위하여다음과 같이「2025년 서울시(도봉구) 평생교육 이용권(2차)」신청 접수를 공고합니다.■ 접수기간:2025. 6. 26. (목) 10:00 ~ 7. 10. (목) 18:00※ 7월 말 선정 예정■ 지원기간:2025. 8월(예정) ~ 12. 31. (수)■','PARTICIPATION','2025-06-22 08:51:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/d4ebd325288da0a6ede27f56d8ccd54b.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736397&code=10008769'),('2025-08-12 10:24:36.234130',77,'2025년 도봉구 청년 경제금융교육 신청 안내','도봉구 청년의 올바른 금융가치관 형성 및 안정적인 자산 관리를 지원하고자 다음과 같이\"도봉구 청년 경제금융교육\"을 운영하오니관심있는 도봉구 청년들의 많은 참여 바랍니다. ○모집대상:도봉구 청년(19세~45세)및 관심있는 구민 누구나(※선착순 마감) ○모집인원:회차별 선착순50명 이내(※중복신청 가능) ○신청방법:https://forms.gle/bFrxWof','PARTICIPATION','2025-06-20 04:21:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/7c0364066f7fb4cf672ad028ba4cd46e.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736374&code=10008769'),('2025-08-12 10:24:36.246329',78,'시원한 여름, 따뜻한 겨울 \'\'2025년도 에너지바우처\'\'','○시원한 여름,따뜻한 겨울“2025년도 에너지바우처”에너지취약계층의 냉·난방비(전기, 도시가스, 지역난방, 등유, LPG, 연탄 등)를 지원하는 제도입니다.1.신청장소: 주민등록상 거주지 동 행정복지센터※거동이 불편한 분은 대리신청 또는 담당 공무원의 직권신청도 가능하니 동 행정복지센터에 사전 문의2. 신청기간: 2025. 6. 9. ~2025. 12. 3','PARTICIPATION','2025-06-20 04:15:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/86c1c9ee6400253d07b3673c4cf4b1e5.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736373&code=10008769'),('2025-08-12 10:24:36.258710',79,'2025년 도봉구 중랑천 물놀이장 개장','-2025년 도봉구 중랑천 물놀이장 개장-무더위를 식혀줄 을 개장합니다.○ 장소:중랑천 물놀이장 2개소(도봉동 서원아파트 106동 앞, 창동 17단지아파트 인근 녹천교 하류)○일시:2025.7.4.(금)~8.24.(일) ※ 매주 화요일 및 우천(예보)시 휴장○시간: 11시~16시40분(40분 물놀이, 20분 휴식)○이용대상: 만2세~중학생 미만 아동 및 동',NULL,'2025-06-20 04:13:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/9addbae715ff2c25c02223c075eea381.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736372&code=10008769'),('2025-08-12 10:24:36.272898',80,'2025년 제2차 생활안정자금 융자 신청 안내','「2025년 제2차 생활안정자금 융자 신청 안내」관련 내용을 구 홈페이지 공지사항에 아래와 같이 게시하고자 합니다.?게재 내용○제 목:2025년 제2차 생활안정자금 융자 신청 안내○신청대상1.주민등록상 주소지가 도봉구로서 정기소득이 있는 구민(1세대1인 신청)2.신용등급1~6등급으로서 금융기관 여신 관리규정상 여신 적격자3.가구합산 재산세 연30만원 이하이','PARTICIPATION','2025-06-19 06:37:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736351&code=10008769'),('2025-08-12 10:24:36.489574',82,'2025년 하반기 청년구정체험단(舊대학생아르바이트) 추첨결과 및 선발등록 안내','>1.선발자 명단: 붙임파일 참고-2025. 6. 23.(월) 18:00까지 반드시 선발 등록(=구비서류 제출)-기한 내 미등록 시 선발 자동취소되며 예비선발 대상자에게 선발기회가 부여됩니다.※ 모집결과: 총 접수인원 702명, 경쟁률 8.8 :12. 당첨자 등록- 등록기간: 2025. 6. 23.(월) 18:00까지-등록방법: 증빙서류 이메일 제출(이메일','PARTICIPATION','2025-06-18 06:39:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/da6ed5719fb15d2dd533e5bb968bcb5d.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736328&code=10008769'),('2025-08-12 10:24:36.510856',84,'위해 축산물(축산물가공품)긴급회수문 게시','광주광역시 소재 식육가공업소 부적합 제품［제품명: 류시윤한우한마리곰국(식육추출가공품)］의 검사 결과 대장균군 부적합 내역이 있어 긴급회수하고자 긴급회수문을 게시하고자 합니다.붙임 위해 축산물 긴급회수문 1부. 끝.','ANNOUNCEMENT','2025-06-18 01:47:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736323&code=10008769'),('2025-08-12 10:24:36.516577',85,'쌍문3주택정비형재개발구역 주민협의체 제6차 회의 개최 공고','-쌍문3주택정비형재개발구역-주민협의체 제6차 회의 개최 공고도봉구 쌍문3주택정비형재개발구역에 대하여「조합설립 지원을 위한 업무기준」제14조 제1항에 따라 주민협의체 제5차 회의를 개최하고자 붙임와 같이 공고하오니 해당 위원님께서는 참석하여 주시기 바랍니다.붙임 쌍문3주택정비형재개발구역 주민협의체 제6차 회의 개최 공고문1부.끝.','PARTICIPATION','2025-06-17 08:28:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736300&code=10008769'),('2025-08-12 10:24:36.526167',86,'붉은등우단털파리(러브버그) 이렇게 대처하세요','붉은등우단털파리(러브버그) 대처방법에 대해 알려드립니다■발생시기: 6~7월■특징(1)성충의 수명 7일 내외(2)성충은 화분매개자, 애벌레는 토양 유기물 분해하여 토양을 기름지게 하는 역할로 익충임(3)독성이 없고 사람을 물거나 질병을 옮기지 않음■대처요령(1)야간 조명 밝기 최소화(2)출입문 틈새 및 방충망 점검(3)실내 유입 시 휴지, 빗자루 등 물리적',NULL,'2025-06-17 06:48:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/312e7e81b6091ac37984508603902229.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736294&code=10008769'),('2025-08-12 10:24:36.528751',87,'2025년 1차 배달 플랫폼종사자 안전교육 참여자 모집','2025년1차『함께 만들어요!안전 배달 문화』배달플랫폼종사자 안전교육 참여자 모집 공고배달 플랫폼종사자의 안전사고 예방을 위하여「배달 플랫폼종사자 안전교육」을 운영하고,교육 이수자의 안전을위한안전용품을다음과 같이 지원하고자 하니 많은 관심과 참여 바랍니다.※안전용품:블랙박스,액션캠中택11.사업개요가.교육일시:2025. 7. 15.(화) 14:00 ~ 16:','PARTICIPATION','2025-06-15 02:15:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/dc14d4dc89b64b93bcd07ba7847a1f8d.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736239&code=10008769'),('2025-08-12 10:24:36.539246',88,'2025년 제3회『도봉 양말 디자인 그림 공모전』수상자 발표','2025년 제3회 『도봉 양말 디자인 그림 공모전』수상자 발표우리 도봉구의 대표 산업인 양말제조업을 알리고자 실시한2025년 제3회『도봉 양말 디자인 그림공모전』에 참여해 주신 모든 분들께 감사드리며,붙임과 같이 수상자를 선정하여 알려드립니다.붙임『도봉 양말 디자인 그림 공모전』수상자 명단1부. 끝.','PARTICIPATION','2025-06-13 06:08:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736217&code=10008769'),('2025-08-12 10:24:36.546245',90,'지진안전 시설물 인증 지원사업 안내','「지진·화산재해대책법」제16조의3(지진안전 시설물의 인증 및 인증의 취소)에 따라 민간소유 건축물에 대한 내진보강을 권장하기 위하여지진안전 시설물 인증지원사업수요조사를 다음과 같이 실시하오니 희망하는 분들은 신청하여 주시기 바랍니다.□사업개요○사업목적:민간건축물 내진보강을 통해 전국민 안전 확보○사업기한:~’26.12.31.○사업대상:지진안전 시설물 인증을','PARTICIPATION','2025-06-13 01:21:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736211&code=10008769'),('2025-08-12 10:24:36.556441',91,'오존 주의보 발령','2025. 6. 12.(목) 17시오존 주의보가 발령되어 안내하오니 건강관리에 유의하시기 바랍니다.발 령 일: 2025. 6. 12.(목) 17시발령지역:서울시[안내사항]○실외 활동과 과격한 운동 자제○어린이집,유치원,학교 실외수업 자제 또는 제한○승용차 운행 자제,대중교통 이용○스프레이,드라이클리닝,페인트칠,신나 사용을 줄임 ○한낮의 더운 시간대를 피해','NOTICE','2025-06-12 08:01:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736200&code=10008769'),('2025-08-12 10:24:36.559430',92,'2025 도봉구 「청소년 미래인재 캠프」참가자 모집','도봉구에서는 국립청소년수련시설의 우수한 시설과 다양한 활동 프로그램을 통해또래 관계 협동심 및 공동체 의식을 함양하고 꿈을 설계할 수 있는도봉구 청소년 미래인재 캠프참가자를 모집합니다. 많은 관심과 참여 바랍니다.○ 캠프개요- 캠프기간: 2025. 8. 6.(수)~8. 8.(금), 2박3일- 캠프대상:관내 초등학교5~6학년30명(도봉구민에 한함)- 캠프장소','PARTICIPATION','2025-06-12 06:20:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/0f1f9443b4e564044b15fdbbe759988c.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736197&code=10008769'),('2025-08-12 10:24:36.569069',93,'지역문화예술인 「우리소리 버스킹」 안내','지역문화예술인 「우리소리 버스킹」 안내도봉구 지역문화예술인 버스킹 공연이 열립니다!7080, 트로트, 민요 등 다양한 장르의 음악 공연과 더불어 마술 공연을 즐길 수 있는도봉구 지역문화예술인 버스킹 공연에도봉구민 여러분의 많은 관심 부탁드립니다.1. 일  시: 2025. 6. 20.(금) 17:00 ~ 18:302. 장  소: 창동역 1번 출구 앞 광장3.','NOTICE','2025-06-11 08:48:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/57fbccc18f015d1beb95187de5be2a49.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736169&code=10008769'),('2025-08-12 10:24:36.576587',94,'[-농구선수 우지원과 함께하는- 스포츠가치 교육캠프] 모집 안내','스포츠강좌이용권 이용자 대상 스포츠가치 교육캠프를 운영하오니 대상자분들의 많은신청 바랍니다.운영안내>■일 시: 2025년6월28일(토)~29일(일)※ 출발시간08:30■장 소: KSPO스포츠가치센터(경남진주시)※집결지:서울고속버스터미널■신청자격:5세~18세기초생활수급,차상위,법정한부모가정 자녀※보호자 동반 필수■모집일시: 6월9일(월)~6월22일(일)■접수','PARTICIPATION','2025-06-10 08:05:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/ca785d44b2ab3d25cc861e3af26a7b26.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736134&code=10008769'),('2025-08-12 10:24:36.585783',95,'2025년 소규모사업장(4·5종) 대기배출원조사표 제출 안내','환경부 국가미세먼지정보센터는 「대기환경보전법」 제17조 등에 근거하여 매년 소규모사업장(4·5종) 대기배출원조사를 실시하고 있어 안내하오니, 해당 사업장에서는 조사표를 작성하여 제출하여 주시기 바랍니다.가. 제출대상 : 2024년 기준 소규모 대기배출사업장(4·5종)나. 제출기한 : 2025. 9. 12. (금)다. 작성방법 : 「4·5종 대기배출원조사표」','NOTICE','2025-06-10 08:01:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/c8ae2b86acea5b6bf980801e909d1f9d.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736132&code=10008769'),('2025-08-12 10:24:36.594314',96,'2025년 대·중소기업 동반성장 유공 포상 안내','2025년 대·중소기업 동반성장 유공 포상 후보자를 다음과 같이 모집하오니, 많은 신청 바랍니다.o포 상 명:2025년 대·중소기업 동반성장 유공 포상o포상목적: 동반성장 및 상생협력 확산 등에 기여한 자를 선정, 포상하여 대·중소기업 간 동반성장 촉진을 유도o포상대상: 대·중소기업 동반성장을 통하여 기업의 경쟁력을 향상시키고, 국가 경제발전에 기여한 개인','PARTICIPATION','2025-06-10 07:28:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/d403d6fe09d4cec40d6eb0ac6aa1d1fa.files/1.png',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736125&code=10008769'),('2025-08-12 10:24:36.606963',97,'2025년 소상공인 창업교육 수강생 모집','2025년 소상공인 창업교육 수강생 모집□ 모집기간:2025. 6. 11.(수) ~ 6. 29.(일)※ 선착순 모집으로 모집인원 충족 시 조기마감□ 모집대상: 예비 창업자, 소상공인, 업종 전환자 등 40명□ 교육일시:2024. 7. 3.(목) ~ 7. 4.(금) 10:00~17:00□ 교육장소: 도봉구청 M4층 위당홀(마들로656)□ 신청방법:소상공인아카','PARTICIPATION','2025-06-10 06:34:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/3c0d054c5141ed06aacfcde7978a88d1.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736124&code=10008769'),('2025-08-12 10:24:36.613991',98,'2025년 시각,청각장애인용TV 보급사업 유상보급 신청 안내','2025년 시각,청각장애인용TV 신청 안내(유상보급, 2차)1. 보급대수:전국 15,000대(유상보급)2. 사업대상:보건복지부 등록시각,청각장애인또는국가보훈부 등록눈,귀 상이등급자3. 부담비용:선정시자부담50,000원4. 신청기간:2025. 6. 9.(월) ~ 6. 27.(금)※ 신청기간 외 접수 불가5. 신청방법:주소지 관할 동주민센터방문신청또는홈페이지','PARTICIPATION','2025-06-10 02:22:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736115&code=10008769'),('2025-08-12 10:24:36.622688',99,'탄소공감마일리지 환경의 날 이벤트','\'2050 탄소중립\' 실현 주체인 주민의 자발적 실천을 촉진하고자 개발한 도봉형 환경마일리지인 \'탄소공(Zero)감(減)마일리지\'가환경의 날(6.5.)을 맞아 다음과 같이이벤트를 진행하오니, 많은 참여 부탁드립니다.●기  간: 2025. 6. 5.(목) ~ 6. 26.(목)●대  상:도봉구민 및 도봉구 생활권자*(탄소공감 인증회원)●방  법: 탄소공감 설치','PARTICIPATION','2025-06-10 01:51:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/88e30ee2c96085ded5784ec2fc7232ff.files/image.jpg',NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736112&code=10008769'),('2025-08-12 10:24:36.629966',100,'[방학1동] 2025년 제3기(7~9월) 자치회관 교양강좌 수강생 모집','2025년도 방학1동 자치회관제3기(7~9월)교양강좌 수강생 모집◎수강기간: 2025. 7. ~ 9. (3개월)*법정/임시공휴일 제외◎접수기간▶방학1동 주민:2025.6.24.(화)~마감 시(09:00~18:00,선착순,토·일/공휴일 제외)▶다른 동 주민:2025.6.27.(금)~마감 시(09:00~18:00,선착순,토·일/공휴일 제외)◎접수방법:정원 범위','PARTICIPATION','2025-06-10 00:15:00.000000',NULL,1,6,NULL,NULL,NULL,NULL,NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12736101&code=10008769'),('2025-08-14 21:04:44.055101',201,'2025 도봉 여름 와글와글 물놀이장 임시휴장 안내','2025 도봉 와글와글 물놀이장이 우천으로 인하여 2025. 8. 14.(목) 임시 휴장함을알려드립니다.○ 휴장일시: 2025. 8. 14.(목) 10:00~17:00 일정 변경시, 홈페이지에 별도 안내할 예정이오니, 도봉구청 홈페이지를 참고하여 주시기 바랍니다.물놀이장 콜센터 ☎ 010-2548-7826문화체육과 ☎ 2091-2544','NOTICE','2025-08-13 23:34:00.000000',NULL,1,6,NULL,'물놀이장, 휴장, 우천, 도봉구, 임시휴장','2025. 8. 14.(목) 우천으로 인한 도봉 와글와글 물놀이장 임시 휴장 안내','문화체육과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737694&code=10008769'),('2025-08-14 21:04:44.185591',202,'중랑천 물놀이장 하천 범람 피해 휴장[8.13.(수)~]','- 휴장 안내 -2025년 도봉구 중랑천 물놀이장이 하천 범람으로 인하여 오염되어 휴장함을 알려드립니다.(복구가 완료되면 홈페이지를 통해 재개장 공지 예정입니다.)○ 장   소:중랑천 물놀이장 2개소(도봉동 서원아파트 앞, 창동 녹천교 하류)○휴장 일시: 2025.8.13.(수)~○ 문   의: 치수과(02-2091-4142)','NOTICE','2025-08-13 08:19:00.000000',NULL,1,6,NULL,'휴장, 물놀이장, 중랑천, 도봉구, 하천 범람, 오염','하천 범람으로 인한 중랑천 물놀이장 휴장을 알리고 재개장 시기를 홈페이지를 통해 공지할 것을 안내','치수과',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737692&code=10008769'),('2025-08-14 21:04:44.199784',203,'2025년 제8회 도봉구 인권작품 공모전','2025년 제8회 도봉구 인권작품 공모전1. 공 모 명 :2025년 제8회 도봉구 인권작품 공모전2. 접수기간 :2025. 8. 20.(수) ~ 10. 15.(수)※ 등기우편의 경우, 접수 마감일 18시까지 소인분에 한함3. 공모주제 : 학교/직장, 존중, 자유, 기후환경 등 인권 관련4. 공모분야 :그림, 운문(시, 동시, 시조 등), 영상5. 접수방법','PARTICIPATION','2025-08-13 00:20:00.000000',NULL,1,6,NULL,'인권, 공모전, 도봉구, 그림, 운문, 영상','인권 관련 작품 공모를 통한 인권 의식 고취','도봉구',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737679&code=10008769'),('2025-08-14 21:04:44.227873',205,'쌍문3동 통장 모집 공고(19통)','쌍문3동 19통 통장 공개모집 공고를 다음과 같이 게재하고자 합니다.□ 모집대상: 쌍문3동 19통□ 통장 신청자격: 해당 통의 관할 구역 내에 주민등록이 되어있고 거주하는 사람□ 제출서류 ○ 신청서 1부(동 주민센터 비치 및 첨부파일 참조)  - 해당 통 반장 2명 이상 또는 세대주 10명 이상 연명 ○ 이력서 1부(반명함판 사진 1매 부착) ○ 자기소개서','PARTICIPATION','2025-08-12 05:57:00.000000',NULL,1,6,NULL,'통장, 공개모집, 쌍문3동, 19통','쌍문3동 19통 통장을 공개 모집하기 위함','쌍문3동 주민센터',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737669&code=10008769'),('2025-08-14 21:04:44.239833',206,'2025년 지역주택조합 실태조사 결과','우리구에서 시행한 \"2025년 지역주택조합 실태조사 결과\"를 게시합니다.□ 대   상: 쌍문동137번지 지역주택조합□ 조사기간: 2025. 6. 16.~7. 16.□ 조사방법: 전문가(변호사, 회계사), 구 합동점검□ 조사결과: 첨부파일 참조','ANNOUNCEMENT','2025-08-12 04:47:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/d8a8803e7101b370975a31ece0d851d4.files/1.png','지역주택조합, 실태조사, 쌍문동137번지, 합동점검','2025년 쌍문동 137번지 지역주택조합 실태조사 결과 공개','도봉구청',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737661&code=10008769'),('2025-08-14 21:04:44.414581',218,'어르신 스포츠상품권 신청 안내(8. 20.까지 기한 연장)','스포츠시설에서 사용할 수 있는「어르신 스포츠상품권」신청방법을 아래와 같이 안내드립니다.■지원대상: 65세 이상기초연금수급자■신청기간:2025. 8. 4.(월) 09:00 ~2025. 8. 20.(수)■신청방법:온라인 신청(http://ssvoucher.co.kr) 또는 전용 콜센터(☎1551-9998)에서 전화 신청■지원내용:스포츠시설 이용료5만 원 지급○','PARTICIPATION','2025-08-01 06:39:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/a1242dc0b602d2157130db27f3c78e3a.files/image.jpg','어르신, 스포츠상품권, 신청, 기초연금, 스포츠시설','스포츠시설 이용료 지원을 위한 어르신 스포츠상품권 신청 방법 안내','관련 부서 명칭(추정)',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737425&code=10008769'),('2025-08-14 21:04:44.734669',231,'2025년「스포츠강좌이용권 단기스포츠체험강좌」변경사항 안내','스포츠강좌이용권 단기스포츠체험강좌 프로그램 내용이 변경되었으니 참조하시기 바랍니다.강좌 안내>※프로그램별로 참여 조건이 다르므로 참가 전 꼭 확인 바랍니다!!!■참여일시: ~2025년 12월■참가자격: 5세~18세 기초생활수급,차상위,법정한부모가정 자녀※보호자1인 동반 가능(보호자2인 이상이면1인 비용만 지원)■신청일시:전월1일~20일(※날짜별선착순신청)■','PARTICIPATION','2025-07-24 08:52:00.000000',NULL,1,6,'https://viewer.dobong.go.kr/WEB_FILE/bbs/bcode22/docView/1e3556af70bc70b48c07cb29dea1d02b.files/1.png','스포츠강좌이용권, 단기스포츠체험강좌, 프로그램 변경, 참여 조건','스포츠강좌이용권 단기스포츠체험강좌 프로그램 내용 변경 사항 안내','스포츠 관련 부서, 아동복지 관련 부서',NULL,'https://www.dobong.go.kr/bbs.asp?bmode=D&pcode=12737222&code=10008769'),('2025-08-18 17:16:05.604838',1557,'2025년 종로구 여름방학 원어민 영어캠프 참가자 명단 발표','상명대학교 및 성균관대학교와 종로구가 관학협력사업으로 추진하는\n2025년 종로구 여름방학 원어민 영어캠프 참가학생 명단을 붙임과 같이 공지합니다.\n\n※ 당초 신청화면(당첨/미당첨)이 아닌 엑셀 명단으로 확인해주시기 바랍니다. &nbsp;\n※ 중복신청, 자격요건 등 확인 후 추첨을 완료하였음을 안내드립니다.\n※ 수강료 입금 및 오리엔테이션 등 세부 사항은 추후 문자를 통해 개별 안내 예정\n&nbsp;\n○ 캠프 관련 문의 : 종로구청 아동청소년교육과(☎02-2148-1985)','PARTICIPATION','2025-06-29 15:00:00.000000','2025-02-20 15:00:00.000000',1,24,NULL,'교육, 청소년','2025년 종로구 여름방학 원어민 영어캠프 참가학생 명단 공지','종로구청 아동청소년교육과',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255054&menuId=1753'),('2025-08-18 17:16:05.611396',1558,'2025년 민방위 기본 교육 통지서 반송에 따른 공시송달 공고','&nbsp;\n1.공 고 명: 2025년 민방위 기본교육 통지서 반송에 따른 공시송달 공고\n2. 대 상: 박*희 외 10명(붙임 참조)\n3. 공고기간: 2025. 6. 27 . ~ 7. 12.(15일간)\n4. 방 법: 전국 시군구 홈페이지 및 게시판 공고\n5. 교육내용\n&nbsp; &nbsp;가. 교육구분: 2025년 민방위 기본교육\n&nbsp; &nbsp;나. 공고방법: 전국 시군구 홈페이지및 동 게시판 공고\n&nbsp; &nbsp;다. 교육대상: 종로구 종로5&middot;6가동 소속 민방위대원\n&nbsp; &nbsp;라. 교육기간: 2025.6.17.(화)~7.4.(금)\n&nbsp; &nbsp;마. 교육장소: 종로구민방위교육장\n&nbsp; &nbsp;바. 문 의 처: 고객센터(1566-8448) 또는 종로5&middot;6가동 민방위 담당자 (☏02-2148-5292)\n6. 민방위 교육을 이수하지 않을 경우 ？민방위기본법？ 제39조제1항의 규정에 따라 과태료가 부과될 수 있음을 알려드립니다.\n&nbsp;\n','ANNOUNCEMENT','2025-06-26 15:00:00.000000','2025-06-16 15:00:00.000000',1,24,NULL,'안전, 교육','2025년 민방위 기본교육 통지서 반송자에 대한 공시송달','종로구청, 종로5·6가동',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255045&menuId=1753'),('2025-08-18 17:16:05.617693',1559,'위해식품 긴급회수 알림 [아미노산원액] 종료','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가. 회수 제품명: 아미노산원액\n나. 소비기한: 2027.5.7.\n다. 회수사유: 3-MCPD 기준 초과 검출\n라. 회수방법: 강제회수[2등급]\n마. 회수영업자: 주식회사 오복아미노\n바. 영업자주소: 경남 김해시 장유로55번길 29-37\n사. 연락처: 055-346-2511\n아. 기타: 위해식품 등 긴급회수 관련 협조요청','NOTICE','2025-06-29 15:00:00.000000','2027-05-06 15:00:00.000000',1,24,NULL,'안전, 건강','식품위생법 제45조에 따른 긴급회수 조치','식품의약품안전처',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255052&menuId=1753'),('2025-08-18 17:16:05.624590',1560,'위해식품 긴급회수 알림 [유기농 아로니아 동결건조 분말]','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가. 회수 제품명: 유기농 아로니아 동결건조 분말\n나. 소비기한: 2026.11.14.\n다. 회수사유: 금속성 이물 기준 초과 검출\n라. 회수방법: 강제회수[3등급]\n마. 회수영업자: (주)매홍엘앤에프\n바. 영업자주소: 양양군 양양읍 포월새말길 41-56\n사. 연락처: 033-635-6210\n아. 기타: 위해식품 등 긴급회수 관련 협조요청','NOTICE','2025-06-29 15:00:00.000000','2026-11-13 15:00:00.000000',1,24,NULL,'식품, 안전, 건강','식품위생법 제45조에 따른 긴급회수 조치 안내','식품의약품안전처',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255051&menuId=1753'),('2025-08-18 17:16:05.631330',1561,'위해식품 긴급회수 알림 [고칼슘 딸기크림롤케이크 등 2건] 종료','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가-1. 회수 제품명: 고칼슘 딸기크림롤케이크\n나-1. 제조일 및 소비기한: 2025.4.16 / 2025.10.12.\n\n가-2. 회수 제품명: 고칼슘 우리밀 초코바나나빵\n나-2. 제조일 및 소비기한: 2025.3.26. / 2025.9.21.\n\n다. 회수사유: 살모넬라균 검출\n라. 회수방법: 거래처 및 판매처를 통한 영업자 회수\n마. 회수영업자: 유한회사 마더구스\n바. 영업자주소: 경기도 안양시 만안구 전파로24번길 35-37\n사. 기타: 위해식품 등 긴급회수 관련 협조요청','NOTICE','2025-06-29 15:00:00.000000','2025-04-15 15:00:00.000000',1,24,NULL,'건강, 안전','식품위생법 제45조에 따른 식품 등 긴급회수 조치','식품의약품안전처',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255050&menuId=1753'),('2025-08-18 17:16:05.638606',1562,'위해식품 긴급회수 알림 [몽고간장 국 1.8L] 종료','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가. 회수 제품명: 몽고간장 국 1.8L\n나. 제조일 및 소비기한\n- 2025.4.1. / 2027.3.31.\n- 2025.4.29. / 2027.4.28.\n다. 회수사유: 발암가능물질 3-MCPD 기준 부적합\n라. 회수방법: 거래처 및 판매처를 통한 영업자 회수\n마. 회수영업자: (주)오복식품\n바. 영업자주소: 경남 창원시 의창구 팔용로371번길 18\n사. 연락처: 055-296-2210\n아. 기타: 위해식품 등 긴급회수 관련 협조요청','NOTICE','2025-06-29 15:00:00.000000','2025-03-31 15:00:00.000000',1,24,NULL,'안전, 건강','식품위생법 제45조에 따른 긴급회수 조치','식품의약품안전처',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255049&menuId=1753'),('2025-08-18 17:16:05.648704',1563,'위해식품 긴급회수 알림 [오복간장 등 3건] 종료','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가-1. 회수 제품명: 오복간장[금표]\n나-1. 소비기한: 2027.2.25.\n다-1. 회수사유: 발암가능물질 3-MCPD 기준 부적합\n\n가-2. 회수 제품명: 오복간장[청표]\n나-2. 소비기한: 2027.2.25.\n다-2. 회수사유: 발암가능물질 3-MCPD 기준 부적합\n\n가-3. 회수 제품명: 오복순진간장\n나-3. 소비기한: 2027.2.25.\n다-3. 회수사유: 발암가능물질 3-MCPD 기준 부적합\n\n라. 회수방법: 거래처 및 판매처를 통한 영업자 회수\n마. 회수영업자: (주)오복식품\n바. 영업자주소: 부산광역시 사하구 올숙도대로 867\n사. 연락처: 051-205-8911\n아. 기타: 위해식품 등 긴급회수 관련 협조요청','NOTICE','2025-06-29 15:00:00.000000','2027-02-24 15:00:00.000000',1,24,NULL,'건강, 안전','식품위생법 제45조에 따른 부적합 식품 긴급회수','식품의약품안전처',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255048&menuId=1753'),('2025-08-18 17:16:05.662253',1564,'가축(가금) 등에 대한 일시 이동중지(Standstill) 명령 발령 알림','1. 광주광역시 전통시장 가금판매소에서 고병원성 조류인플루엔자가 발생됨에 따라 확산을 차단하기 위하여 아래와 같이 「가축(닭) 등에 대한 일시 이동중지(Standstill)」 명령을 발령합니다.\n\n2. 일시 이동중지 명령은 고병원성 AI 발생 또는 전파 가능성이 있는 가축 및 사람&middot;차량 등의 이동을 제한한 상태에서 일제 세척&middot;소독 등 조치로 전파의 위험요인을 최대한 제거하기 위한 긴급조치이니, 동 명령의 효과가 극대화될 수 있도록 아래의 조치사항을 적극 이행하여 주시기 바랍니다.\n\n□ 일시이동중지 명령 개요\n가. (적용기간) 2025. 5. 20. 19:00 ~ 5. 21. 19:00 (24시간)\n&nbsp; * 일시 이동중지는 &#39;25. 5. 20. 19:00부터 실시하되, 명령 위반에 대한 처벌은&#39;25. 5. 20. 22:00부터 적용\n나. (적용지역) 광주광역시, 전라남도, 전북특별자치도\n다. (적용대상) 가금사육 축산농장, 작업장&middot;종사자, 축산차량, 전통시장 가금판매소 등\n&nbsp; * (이동 허용 조건) 부득이한 상황 발생으로 사람 또는 차량의 이동이 필요한 경우,이동승인서 발급 후 허용\n라. (위반한 경우) 가축전염병예방법 제57조에 따라 1년 이하의 징역 또는 1,000만원 이하의 벌금\n\n붙임 (공고) 가축 등에 대한 일시 이동중지 명령&nbsp; 1부\n','ANNOUNCEMENT','2025-05-20 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254990&menuId=1753'),('2025-08-18 17:16:05.669975',1565,'2025년 종로구 등산로 범죄에방 CCTV 설치에 따른 행정예고','서울특별시 종로구 공고 제2025-912호\n2025년 종로구 등산로 범죄에방 CCTV 설치에 따른 행정예고\n&nbsp;\n종로구 산지형 공원 내 방범 및 다목적 CCTV 설치에 따른 공원 내 시설물 보호 및 사건？사고 및 범죄 예방을 위하여 방범용 CCTV를 설치함에 있어 설치목적 및 주요내용을『개인정보 보호법』제25조 및 같은 법 시행령 제23조, 『행정절차법』제46조 규정에 의거 아래와 같이 행정예고를 실시하오니, 공고내용에 의견이 있으신 분은 공고기간 내에 의견서를 제출하여 주시기 바랍니다.\n\n1. 사 업 명 : 2025년 종로구 등산로 범죄예방 CCTV 설치\n2. 공고기간 : 2025. 6. 25. ~ 7. 16.\n3. 의견제출 : 2025. 6. 25. ~ 7. 16.\n4. 공고장소 : 종로구청 홈페이지\n5. 시 행 청 : 서울특별시 종로구청\n6. 사업내용 : 종로구 등산로 내 CCTV 15개소 46대 설치 등\n7. 설치목적 : 범죄예방 및 사건발생 시 증거자료 확보\n8. 촬영시간 : 24시간 촬영, 연중 운영\n9. 의견제출 : 본 행정예고에 대하여 의견이 있는 기관？단체 또는 개인은 공고 기간내에 의견제출서를 종로구청 도시녹지과로 서면 제출하여 주시기 바랍니다.\n10. 문의처 : 서울특별시 종로구청 도시녹지과(☎02-2148-2834, 담당자 김중겸)\n\n붙임 1. 행정예고문 1부\n&nbsp; &nbsp; &nbsp; &nbsp; 2. 위치도 1부\n&nbsp; &nbsp; &nbsp; &nbsp; 3. 의견제출 양식 1부\n','ANNOUNCEMENT','2025-06-24 15:00:00.000000',NULL,1,24,NULL,'안전, 청소년','종로구 산지형 공원 내 방범 및 다목적 CCTV 설치에 따른 공원 내 시설물 보호 및 사건·사고 및 범죄 예방','서울특별시 종로구청, 종로구청 도시녹지과',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255042&menuId=1753'),('2025-08-18 17:16:05.676999',1566,'6월 식품접객업소 위생점검 사전예고문','서울시에서「대학가 주변 및 유흥업소 밀집지역 등 주류 판매 접객업소」에 대한 위생 점검을 시행합니다.\n&nbsp;\n식품접객업소의 위생 수준을 높이고 안전한 먹거리에 대한 시민들의 신뢰 제고를 위해 기획점검을 진행하며, 점검의 투명성과 실효성 확보를 위하여 민관합동 및 자치구별 교차점검으로 추진합니다.\n&nbsp;\n2025년 6월 식품접객업소 위생점검을 아래와 같이 시행함을 사전에 예고드리니, 대상 업소 관계자분들께서는 적극적인 협조 부탁드립니다.\n&nbsp;\n다만, 민원유발업소, 문제업소 등에 대해서는 종전과 같이 사전예고 없이 불시점검을 실시하고 있으니 참고하여주시기 바랍니다.\n\n점검 상세사항은 붙임 파일 참고바랍니다.\n\n','REPORT','2025-06-23 15:00:00.000000',NULL,1,24,NULL,'안전, 건강','식품접객업소 위생 수준 향상 및 안전한 먹거리에 대한 시민 신뢰 제고','서울시',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255041&menuId=1753'),('2025-08-18 17:16:05.684095',1567,'오존주의보 해제 알림(2025. 6. 23. 월. 19시)','2025. 6. 23.(월) 19시 부로 오존주의보 해제 기준(0.12ppm 미만)을 충족하여 오존 주의보를 해제합니다.\n','NOTICE','2025-06-22 15:00:00.000000',NULL,1,24,NULL,'환경, 안전','오존주의보 해제 공고','환경부',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255040&menuId=1753'),('2025-08-18 17:16:05.691031',1568,'오존주의보 발령 알림(2025. 6. 23. 14시)','2025. 6. 23.(월) 14시 부로 &quot;오존주의보&quot;가 발령되었습니다.\n\n&lt; 오존주의보 발령 사항&gt;\n○ 발령일시 : 2025. 6. 23.(월) 14:00 ~\n○ 대상지역 : 서울권역\n○ 발령요건 : 시간당 평균 0.12ppm 이상시\n\n어린이 및 노약자 등께서는 외출을 자제하여 주시고 부득이 외출 시 고농도 오존 시민행동\n요령 https://cleanair.seoul.go.kr/information/o3Tips 을 따라 주시기 바랍니다.\n&nbsp;\n※ 서울시 대기질 정보문자서비스 신청(무료): https://cleanair.seoul.go.kr/citizen/sms\n\n','PARTICIPATION','2025-06-22 15:00:00.000000',NULL,1,24,NULL,'환경, 건강, 안전','오존주의보 발령 사항 안내 및 시민 행동 요령 안내','서울시',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255039&menuId=1753'),('2025-08-18 17:16:05.696496',1569,'2025년 제11차 건축자산전문위원회 심의결과 공지','2025년 제11차 건축자산전문위원회 심의 결과를 붙임과 같이 공지하오니 참고하시기 바라며,\n다음 사항을 유의하여 주시기 바랍니다.\n&nbsp;\n가. 건축자산전문위원회 심의는 건축허가(사용승인 포함)절차 등에 따른 관련 법령의 저촉 여부에 대한 심의가 아니므로 건축\n허가(신고) 및 사용승인(준공)시 관련 법령을 검토 및 적용하여야 하며,\n나. 서울특별시 한옥 등 건축자산의 진흥에 관한 조례 시행규칙 제12조제1항에 의거, 한옥수선계획 변경 시에는 한옥 수선\n공사 착수 전 변경된 수선 계획을 제출하여 지원 여부 및 지원 금액 결정을 위한 심의를 다시 받으셔야합니다.\n다. 만약 위 사항을 위반할 경우, 동 조례 시행규칙 제15조제3항에 의거, 보조금 확정을 위한 완료심의 시 변경사항의 적정성\n여부를 심의하여 비용 지원 금액이 조정 또는 취소 될 수 있습니다.','ANNOUNCEMENT','2025-06-19 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255038&menuId=1753'),('2025-08-18 17:16:05.702499',1570,'오존주의보 해제 알림(2025. 6. 18. 수. 19시)','2025. 6. 18.(수) 19시 부로 오존주의보 해제 기준(0.12ppm 미만)을 충족하여 오존 주의보를 해제합니다.\n','NOTICE','2025-06-17 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255037&menuId=1753'),('2025-08-18 17:16:05.708738',1571,'2025년 제12차 건축안전전문위원회 심의 안건 및 참석위원 명부 공개','○ 2025년 제12차 건축안전전문위원회 개최 일정\n&nbsp; - 일 &nbsp; &nbsp;시: 2025. 6. 25.(수) 15:00\n&nbsp; - 장 &nbsp; &nbsp;소: 종로구청 3층 다목적실\n&nbsp; - 안 &nbsp; &nbsp;건: 총 4건(굴토 2건, 해체 2건)','NOTICE','2025-06-17 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255036&menuId=1753'),('2025-08-18 17:16:05.715118',1572,'오존주의보 발령 알림(2025. 6. 18. 13시)','2025. 6. 18.(수) 13시 부로 &quot;오존주의보&quot;가 발령되었습니다.\n\n&lt; 오존주의보 발령 사항&gt;\n○ 발령일시 : 2025. 6. 18.(수) 13:00 ~\n○ 대상지역 : 서울권역\n○ 발령요건 : 시간당 평균 0.12ppm 이상시\n\n어린이 및 노약자 등께서는 외출을 자제하여 주시고 부득이 외출 시 고농도 오존 시민행동\n요령 https://cleanair.seoul.go.kr/information/o3Tips 을 따라 주시기 바랍니다.\n&nbsp;\n※ 서울시 대기질 정보문자서비스 신청(무료): https://cleanair.seoul.go.kr/citizen/sms\n&nbsp;\n','PARTICIPATION','2025-06-17 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255035&menuId=1753'),('2025-08-18 17:16:05.721914',1573,'2025년 청소년한부모 정책 안내','여성가족부 및 한국건강가정진흥원에서는 청소년한부모가족이 필요한 공공 및 민간의 복지서비스를 빠짐없이 안내 받을 수 있도록 「2025년 청소년한부모 정책 안내」를 전자파일로 제작하여 배포하오니, 붙임 파일을 참고하여 주시기 바랍니다.\n\n추가로 궁금한 사항이 있으실 경우 거주지 동주민센터 한부모 담당 또는 종로구 아동복지과 한부모 담당(☎02-2148-2994)으로 문의주십시오. 감사합니다.\n\n※참고 : 청소년한부모의 연령 기준은 24세 이하입니다.','NOTICE','2025-06-16 15:00:00.000000','2025-02-20 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255033&menuId=1753'),('2025-08-18 17:16:05.728170',1574,'2025년 제10차 건축위원회 및 8차 건축계획위원회 심의 결과 공지','2025년 제10차 건축위원회 및 8차 건축계획위원회 심의 결과 공지','REPORT','2025-06-16 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255032&menuId=1753'),('2025-08-18 17:16:05.735487',1575,'6월은 자동차세(제1기분) 납부의 달입니다','6월은 자동차세(제1기분) 납부의 달입니다.\n(단, 이전에 2025년 연세액을 미리 납부하신 분은 제외됩니다.)\n\n납세의무자\n2025. 6. 1. 현재 자동차&middot;건설기계 등 등록원부상 소유자\n\n납부기간\n2025. 6. 16. ~ 2025. 6. 30.\n납부기한이 지나면 3%의 납부지연가산세를 더 내셔야 합니다.\n\n납부방법\n- 은행방문 : 시중은행, 농협, 수협, 신협, 우체국, 새마을금고 등\n- 인터넷 : ETAX(etax.seoul.go.kr), 은행 홈페이지 등\n- 스마트폰 : STAX(서울시 세금납부앱), 간편결제사앱(카카오페이, 네이버 페이 등)\n- 은행 무인공과금기, 현금인출기(CD/ATM)\n- ARS(1599-3900)\n\n\n문의\n종로구청 지방소득세과 ☎(02)2148-1172, 2148-1173\n','NOTICE','2025-06-15 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255031&menuId=1753'),('2025-08-18 17:16:05.741624',1576,'2025 종로구 일자리박람회 개최','\n[참여기업 목록]\n\n\n[사전참여신청]\n&nbsp;https://naver.me/GEiBwmcq\n&nbsp;\n&nbsp;','PARTICIPATION','2025-06-12 15:00:00.000000',NULL,1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000208773&amp;fileSn=6',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255030&menuId=1753'),('2025-08-18 17:16:05.747081',1577,'종로구 실내 놀이복합문화공간 조성사업 설계공모 질의답변 게시','종로구 실내 놀이복합문화공간 조성사업 설계공모와 관련 접수된 질의에 대한 답변을 아래와 같이 게시합니다.\n\n1. 게시내용 : 종로구 실내 놀이복합문화공간 조성사업 설계공모 질의답변서 1부.','PARTICIPATION','2025-06-12 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255029&menuId=1753'),('2025-08-18 17:16:05.753395',1578,'2025년 종로구 여름방학 원어민 영어캠프 참가자 모집 안내','우리 구에서는 종로구에 거주하거나 관내 학교 재학 중인 초중등 학생을 대상으로 겨울방학 원어민 영어캠프를 개최합니다.\n관내 소재 대학교(상명대학교, 성균관대학교)의 우수한 교육 인프라를 활용하여 저렴한 비용으로 해외연수를 대체할 수 있는 통학형 영어캠프 프로그램을 제공하고자 하니 관심있는 학부모님 및 학생들의 많은 신청 바랍니다.\n\n&lt;2025년 종로구 여름방학 원어민 영어캠프&gt;\n\n영어캠프 개요\n□ 운영기간 : 2025.7.28.(월) ~ 8.8.(금) (2주간, 평일 10회)\n□ 모집대상 : 종로구에 거주(주민등록상 거주지)하거나 관내 학교 재학중인 초중등 학생\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ※ 모집인원 대비 신청인원 초과 시 종로구민 우선 선발\n□ 교육장소 : 상명대학교 미래백년관(종로구 관내 한정 통학버스 운행), 성균관대학교 호암관(통학버스 미운행)\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ※ 상명대 통학버스 노선은 참가자 확정 후 거주지 고려하여 운행 예정\n□ 모집인원 : 175명[상명대학교 105명(초등), 성균관대학교 70명(초등 3~6학년, 중등)]\n□ 운영내용 : 저렴한 비용으로 원어민과 함께하는 통학형 영어캠프 &nbsp; ※ 학교별 상세내용 : 붙임 참조&nbsp;\n□ 수 강 료 : 1인당 80만원\n&nbsp; ○ 일 &nbsp; 반 : 40만원(40만원 구비지원)\n&nbsp; ○ 셋째아 : 30만원(50만원 구비지원)\n&nbsp; ○ 저소득 : 무료(전액 구비지원)\n&nbsp; &nbsp; ※ 감면혜택(셋째아 이상, 저소득) : 종로구민에 한함\n&nbsp; &nbsp; ※ 셋째아 : 자녀가 세명 이상인 가정의 셋째아부터 지원(첫째, 둘째 해당 없음)\n&nbsp; &nbsp; ※ 저소득 범위 : 기초생활수급권자 및 차상위계층, 한부모가정 자녀\n\n모집개요\n□ 접수방법 : 종로구청 홈페이지 &rarr; 종합민원 &rarr; 민원신청 &rarr; 통합신청\n□ 접수기간 : 2025.6.16.(월) 09:00 ~ 6.23.(월) 18:00 ※ 모집인원 미달 시, 추가모집\n□ 선정방법 : 전산에 의한 무작위 추첨 ※ 추첨과정 비공개\n□ 선정발표 : 2025.6.30.(월) 17:00 홈페이지 공지 및 개별 문자 발송\n\n★ 자세한 내용은 붙임의 모집안내문을 확인해주시기 바랍니다.\n☎ 문의 : 아동청소년교육과 (2148-1985)','ANNOUNCEMENT','2025-06-12 15:00:00.000000','2025-07-27 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255028&menuId=1753'),('2025-08-18 17:16:05.759700',1579,'오존주의보 해제 알림(2025. 6. 12. 목. 21시)','2025. 6. 12.(목) 21시 부로 오존주의보 해제 기준(0.12ppm 미만)을 충족하여 오존주의보를 해제합니다.\n','NOTICE','2025-06-11 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255027&menuId=1753'),('2025-08-18 17:16:05.764640',1580,'2025년 7월 건축안전전문위원회(구조,굴토,해체) 심의 일정 안내','*중요*\n심의접수 및 심의도서의 세부사항 등에 관한 사항은 각 동 인허가 담당(정비구역의 경우 도시개발과 담당)에게 문의하시고,\n심의 일정 및 참석 여부에 관한 사항만 심의담당에게 문의하시기 바랍니다.\n\n[건축안전전문(구조, 굴토, 해체)위원회] 개최일정\n- 심의 개최일 : [13차] 2025. 7. 9.(수) &nbsp;/ &nbsp;[14차] 2025. 7. 23.(수)\n&nbsp; ※ 심의 신청은 심의 개최 2주 전 수요일 [ [13차] 2025. 6. 25.(수) &nbsp;/ &nbsp;[14차] 2025. 7. 9.(수)] 18:00까지\n&nbsp; &nbsp; &nbsp; &nbsp;세움터로 접수(신청서 및 도서 제출 완료)하여 주시기 바랍니다.\n\n- 심의안건 및 참석위원명부 구 홈페이지 공개 : [13차] 7. 2.(수) / [14차] 7. 16.(수)\n\n※ 제출서류 및 업로드 위치\n[안전전문위원회 - 구조]\n&nbsp; ▶ 위임장 pdf (대지사용승낙서 등 )\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 일반문서 &rarr; 위임서\n&nbsp; ▶ 구조 심의도서(개략 건축도면 포함) pdf 1부, 구조계산서 pdf 1부\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 설계문서 &rarr; 기타\n\n[안전전문위원회 - 굴토]\n&nbsp; ▶ 위임장 pdf (대지사용승낙서 등 )\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 일반문서 &rarr; 위임서\n&nbsp; ▶ 굴토 심의도서(개략 건축도면 포함) pdf 1부,\n&nbsp; &nbsp; &nbsp; 지반조사보고서 pdf 1부, 흙막이계산서 pdf 1부\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 설계문서 &rarr; 기타\n\n[안전전문위원회 - 해체]\n&nbsp; ▶ 위임장 pdf\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 일반문서 &rarr; 위임서\n&nbsp; ▶ 해체 심의도서 pdf 1부, 건물구조계산서 pdf 1부\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 설계문서 &rarr; 기타\n\n※ 첨부의 &#39;건축안전전문위원회 심의도서 작성기준&#39; 꼭 확인하여 반영\n&nbsp; &nbsp; - 심의도서에 설계자, 건축사사무소명 표기 금지\n&nbsp; &nbsp; - 심의도서 하단에 페이지 번호 표기\n&nbsp; &nbsp; - 심의상정 사유 구체적으로 명확히 표기\n\n※ 세움터 업로드 유의사항\n&nbsp; &nbsp; - 기존 보완 파일 반드시 삭제 ! (최종 파일만 올릴 수 있도록)\n&nbsp; &nbsp; - 업로드 위치, 파일 제목 상기 내용과 동일하게 업로드\n&nbsp; &nbsp; - 심의 관련 문서는 가능한 하나의 파일로 작성요망\n\n\n아울러, 심의내용은 인허가 담당과 미리 협의하여주시기 바랍니다\n\n**건축안전전문위원회 심의 총괄: 홍지혜 주무관 02-2148-2822','ANNOUNCEMENT','2025-06-11 15:00:00.000000','2025-02-20 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255026&menuId=1753'),('2025-08-18 17:16:05.770878',1581,'2025년 제11차 건축안전전문위원회 심의결과 공지','○ 2025년 제11차 건축안전전문위원회\n&nbsp; - 개최일시: 2025. 6. 11.(수) 15:00\n&nbsp; - 개최장소: 종로구청 3층 다목적실\n&nbsp; - 참 석 &nbsp;자: 위원장 등 심의위원 8인(서면 제출 1인 포함)\n&nbsp; - 심의결과: 조건부의결 5건, 재심의결 1건','REPORT','2025-06-11 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255025&menuId=1753'),('2025-08-18 17:16:05.776155',1582,'환경친화적 자동차의 개발 및 보급 촉진에 관한 법률 위반에 따른 과태료 사전통지, 수시분, 독촉분 공시송달 공고(5월)','환경친화적 자동차의 개발 및 보급 촉진에 관한 법률 위반에 따른 과태료 사전통지, 수시분, 독촉분 공시송달 공고\n&nbsp;\n「환경친화적 자동차의 개발 및 보급 촉진에 관한 법률」 제11조의2 및 제16조에 따라 과태료 고지서를 송달하였으나, 폐문부재 등의 사유로 송달이 불가능하여 「행정절차법」 제14조 제4항 규정에 따라 다음과 같이 공시송달(공고)합니다.','ANNOUNCEMENT','2025-06-11 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255024&menuId=1753'),('2025-08-18 17:16:05.780372',1583,'오존주의보 발령 알림(2025. 6. 12.목. 17시)','2025. 6. 12.(목) 17시 부로 &quot;오존주의보&quot;가 발령되었습니다.\n\n&lt; 오존주의보 발령 사항&gt;\n○ 발령일시 : 2025. 6. 12.(목) 17:00 ~\n○ 대상지역 : 서울권역\n○ 발령요건 : 시간당 평균 0.12ppm 이상시\n\n어린이 및 노약자 등께서는 외출을 자제하여 주시고 부득이 외출 시 고농도 오존 시민행동\n요령 https://cleanair.seoul.go.kr/information/o3Tips 을 따라 주시기 바랍니다.\n&nbsp;\n※ 서울시 대기질 정보문자서비스 신청(무료): https://cleanair.seoul.go.kr/citizen/sms\n\n','PARTICIPATION','2025-06-11 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255023&menuId=1753'),('2025-08-18 17:16:05.785754',1584,'2025년 제10차 건축자산전문위원회 심의결과 공지','2025년 제10차 건축자산전문위원회 심의 결과를 붙임과 같이 공지하오니 참고하시기 바라며,\n다음 사항을 유의하여 주시기 바랍니다.\n&nbsp;\n가. 건축자산전문위원회 심의는 건축허가(사용승인 포함)절차 등에 따른 관련 법령의 저촉 여부에 대한 심의가 아니므로 건축\n허가(신고) 및 사용승인(준공)시 관련 법령을 검토 및 적용하여야 하며,\n나. 서울특별시 한옥 등 건축자산의 진흥에 관한 조례 시행규칙 제12조제1항에 의거, 한옥수선계획 변경 시에는 한옥 수선\n공사 착수 전 변경된 수선 계획을 제출하여 지원 여부 및 지원 금액 결정을 위한 심의를 다시 받으셔야합니다.\n다. 만약 위 사항을 위반할 경우, 동 조례 시행규칙 제15조제3항에 의거, 보조금 확정을 위한 완료심의 시 변경사항의 적정성\n여부를 심의하여 비용 지원 금액이 조정 또는 취소 될 수 있습니다.','ANNOUNCEMENT','2025-06-10 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255022&menuId=1753'),('2025-08-18 17:16:05.792017',1585,'2025년 6월 식품접객업소 위생 및 원산지 지도서비스 시행 안내','- 2025년 6월 -\n식품접객업소 위생 및 원산지 지도서비스 시행 안내\n&nbsp;\n서울시는 2025. 6월중「식품접객업소 위생 및 원산지 지도서비스」를 실시합니다.\n&nbsp;\n「식품접객업소 위생 및 원산지 지도서비스」는 안전한 먹을거리를 제공해야 하는 영업주의 의무와 책임을 환기시키고, 영업주의 자율적 위생관리 참여를 유도함으로써 서울시 식품접객업소의 위생수준 향상을 도모하고 안전한 외식문화를 조성하기 위한 사업입니다.\n&nbsp;\n대상업소 관계자분께서는 영업에 다소 불편하시더라도 식품접객업소의 위생수준 향상을 위한 기회임을 감안하여, 방문하는 지도 요원의 활동에 적극 협조하여 주시기 바랍니다.\n\n○ 지도기간 : 2025.6.19.(목) ~ 7.1.(화) * 기간 내 5일간 시행\n○ 지도대상 : 소규모 일반음식점(단, 주류를 취급하는 소주방, 호프 등은 제외)\n○ 지도요원 : 서울시 소비자식품위생감시원(농수산물 명예감시원)\n○ 지도방법 : 소비자식품위생감시원(2인 1조)이 대상업소 방문하여 지도\n○ 지도사항 : 음식점 위생 및 원산지 표시 준수 여부\n&nbsp; ① 식품 등의 위생적 취급기준 준수 여부\n&nbsp; ② 시설기준, 영업자 준수사항 및 건강진단 실시 여부\n&nbsp; ③ 원산지 표시에 관한 사항, 기타 지도 &middot; 권고사항 등\n○ 지도 과정에서 위반이 있을 경우, 적발된 날로부터 5일간 자체 시정\n○ 확인점검 : 시정기한 종료 후 관할 자치구에서 미시정 업소 행정처분','PARTICIPATION','2025-06-09 15:00:00.000000','2025-06-18 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255021&menuId=1753'),('2025-08-18 17:16:05.798615',1586,'2025년 소규모 대기배출사업장(4·5종) 대기배출원조사표 제출 안내','1. 환경부 국가미세먼지정보센터는「대기환경보전법」제17조 등에 근거하여 매년 소규모 대기배출사업장(4&middot;5종) 대기배출원조사를 실시하고 있습니다.\n\n2. 이에 따라, 관내 소규모 대기배출사업장은 아래 안내에 따라 대기배출원조사표를 작성하여 기한 내 제출하여 주시기 바랍니다.\n\n\n&nbsp;\n\n&nbsp;&nbsp;□ 요청사항: 소규모사업장(4&middot;5종) 대기배출원조사표 작성 및 제출[붙임1 양식]\n\n&nbsp;&nbsp;&nbsp; ※ 조사표 양식은 대기배출원관리시스템(sems.air.go.kr) 공지사항에서 다운로드 가능\n\n&nbsp;&nbsp;□ 제출대상: 2024년 기준 소규모 대기배출사업장(4&middot;5종)\n\n&nbsp;&nbsp;□ 제출기한: 2025. 9. 12.(금)&nbsp; ※ 기한엄수\n\n&nbsp;&nbsp;□ 제출방법: 전자메일, 팩스, 문자(수신전용), 우편 중 택 1\n\n&nbsp;&nbsp;&nbsp;&nbsp;○ 전자메일: nair@korea.kr\n\n&nbsp;&nbsp;&nbsp;&nbsp;○ 팩스번호: 070-4850-8793\n\n&nbsp;&nbsp;&nbsp;&nbsp;○ 문&nbsp; &nbsp; &nbsp; &nbsp;자: 010-3264-5696(수신전용)\n\n&nbsp;&nbsp;&nbsp;&nbsp;○ 우편주소: 서울특별시 구로구 디지털로30길 28, 마리오타워 406호 소규모사업장 대기배출원조사 사업단 (우편번호 08389)\n\n&nbsp;&nbsp;□ 문의전화: 안내센터 1833-5696\n\n\n&nbsp;\n\n붙임&nbsp; 1. 대기배출원조사표 작성양식 1부.\n\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2. 대기배출원조사표 작성안내 1부.\n\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;3. 대기배출원조사 소개자료 1부.&nbsp; 끝.','ANNOUNCEMENT','2025-06-09 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255020&menuId=1753'),('2025-08-18 17:16:05.805670',1587,'2025년 민방위 사이버 교육 통지서 반송에 따른 공시송달 공고','1.「민방위기본법」제23조(민방위대원의 교육훈련) 및 제24조(교육훈련 통지서의 전달 등)에 의하여 2025년 민방위 사이버교육 통지서를 등기우편으로 발송하였으나,\n폐문부재 등의 사유로 교부가 불가능하여「행정절차법」제14조 제4항에 따라 아래와 같이 공고합니다.\n\n가. 공 고 명 : 2025년 민방위 사이버 교육 통지서 반송에 따른 공시송달 공고\n나. 공고대상 : 안*호 외 5명(붙임 참조)\n다. 공고기간 : 2025. 6. 2. ~ 2025. 6. 20. (15일간)\n라. 공고방법 : 전국 읍면동 게시판 및 홈페이지 공고\n마. 교육내용\n1) 교육구분 : 2025년 민방위 사이버 교육\n2) 교육방법 : PC 및 모바일을 통한 온라인 교육(www.cdec.kr)\n\n2. 민방위 교육을 이수하지 않을 경우, 민방위기본법 제39조 제1항의 규정에 따라 10만원의 과태료가 부과됨을 알려드립니다.','ANNOUNCEMENT','2025-06-01 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255012&menuId=1753'),('2025-08-18 17:16:05.812039',1588,'2025년 제11차 건축안전전문위원회 심의 안건 및 참석위원 명부 공개','○ 2025년 제11차 건축안전전문위원회 개최 일정\n&nbsp; - 일 &nbsp; &nbsp;시: 2025. 6. 11.(수) 15:00\n&nbsp; - 장 &nbsp; &nbsp;소: 종로구청 3층 다목적실\n&nbsp; - 안 &nbsp; &nbsp;건: 총 6건(굴토 3건, 해체 3건)','NOTICE','2025-06-03 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255018&menuId=1753'),('2025-08-18 17:16:05.820583',1589,'2025년 제10차 건축안전전문위원회 심의결과 공지','○ 2025년 제10차 건축안전전문위원회\n&nbsp; - 개최일시: 2025. 5. 28.(수) 15:00\n&nbsp; - 개최장소: 종로구청 3층 다목적실\n&nbsp; - 참 석 &nbsp;자: 위원장 등 심의위원 9인(서면 제출 1인 포함)\n&nbsp; - 심의결과: 조건부의결 5건','REPORT','2025-06-03 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255017&menuId=1753'),('2025-08-18 17:16:05.827692',1590,'2026 지진안전 시설물 인증 지원사업 수요조사','&nbsp;\n\n행정안전부에서는 민간건축물 내진보강 활성화를 위해 「지진안전 시설물 인증 지원사업」을 추진 하고 있습니다.\n&#39;26년 원활한 사업추진 및 예산 반영을 위하여 자치구별 사업 수요를 파악하고 있으니,\n참여 희망 대상은 아래의 제출서류를 기한 내 제출하시기 바랍니다.\n\n\n\n\n가. 사업개요\n\n&nbsp;&nbsp;&nbsp;1) 사업기간: 2026. 1. ~ 12.\n\n&nbsp;&nbsp;&nbsp;2) 지원대상: 지진안전 시설물 인증을 받고자 하는 민간 건축물\n\n&nbsp;&nbsp;&nbsp;3) 지원내용: 내진성능평가 비용 및 인증 수수료 보조금 지원\n&nbsp;\n\n\n&nbsp;나. 수요조사\n\n&nbsp;&nbsp;&nbsp;1) 제출서류:&nbsp;&nbsp;&#39;26년 지진안전 시설물 인증 지원사업 수요조사 [sheet1,2 작성]\n\n&nbsp;&nbsp;&nbsp;2) 제출기한 : 2025. 6.11.(수)&nbsp;\n\n&nbsp;&nbsp;&nbsp;3) 제출방법 : 담당자(cherrybae13@mail.jongno.go.kr)메일 제출\n','PARTICIPATION','2025-06-01 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255016&menuId=1753'),('2025-08-18 17:16:05.836893',1591,'&#039;26년 지진안전 시설물 인증 지원사업 수요조사 실시','&nbsp;행정안전부에서는 민간건축물 내진보강 활성화를 위해\n「지진안전 시설물 인증 지원사업」을 추진 하고 있습니다.\n&nbsp;&#39;26년 원활한 사업추진 및 예산 반영을 위하여&nbsp;자치구별 사업 수요조사를 실시합니다.\n&nbsp;\n\n&nbsp;가. 사업개요\n\n&nbsp;&nbsp;&nbsp;1) 사업기간: 2026. 1. ~ 12.\n\n&nbsp;&nbsp;&nbsp;2) 지원대상: 지진안전 시설물 인증을 받고자 하는 민간 건축물\n\n&nbsp;&nbsp;&nbsp;3) 지원내용: 내진성능평가 비용 및 인증 수수료 보조금 지원\n\n\n\n&nbsp;나. 수요조사\n\n&nbsp;&nbsp;&nbsp;1) 제출자료 : 대상 시설물 주소 및 시설물명\n\n\n&nbsp;&nbsp;&nbsp;2) 제출기한 : 2025. 6.11.(수)&nbsp;\n\n&nbsp;&nbsp;&nbsp;3) 제출방법 : 담당자(cherrybae13@mail.jongno.go.kr)메일로 제출\n','REPORT','2025-06-01 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255015&menuId=1753'),('2025-08-18 17:16:05.845580',1592,'「시설물의 안전 및 유지관리에 관한 특별법」에 따른 D등급 시설물 안내','「시설물의 안전 및 유지관리에 관한 특별법」에 따른 D등급 시설물 안내\n\n아래의 시설물은 「시설물의 안전 및 유지관리에 관한 특별법」제25조에 따라 구조안전상 위험이 있어 주의가 필요한 시설물(D등급)로 지정되었음을 알려드립니다.\n\n해당 시설물을 이용하시는 주민 여러분께서는 통행 시 각별히 유의하여 주시기 바랍니다.\n\n□ 시설명 : 평창4교\n□ 소재지 : 평창동 411-5\n□ 관리자 : 종로구 도로과(도로계획팀장 유용규, 담당 우경준, 02-2148-3164)\n□ 지정등급 : D등급\n\n※ 해당 시설물에 대해서는 정기적인 안전점검 및 보수계획을 수립하여 관리하고 있으며, 필요 시 통행제한 등 조치를 취할 수 있습니다.','ANNOUNCEMENT','2025-06-01 15:00:00.000000','2025-11-04 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255014&menuId=1753'),('2025-08-18 17:16:05.853956',1593,'2025년 제9차 건축위원회 심의 결과 공지','2025년 제9차 건축위원회 심의 결과 공지','REPORT','2025-06-01 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255013&menuId=1753'),('2025-08-18 17:16:05.865664',1594,'2025년 제6차 해체공사장 시공자 사전교육 일정 공지','2025년 제6차 해체공사장 시공자 사전교육 일정을 공지하오니 해체공사(허가, 신고) 현장대리인께서는\n신청 후 교육을 수료(최초 교육일로부터 2년간 유효)하시기 바랍니다.\n\n□ 교 육 &nbsp;명: 2025년 제6차 해체공사장 시공자 사전교육\n□ 교육일시: 2025. 6. 23.(월) 15:00~17:00\n□ 교육장소: 종로구청 3층 세미나실\n□ 교육강사: 김재연 교수\n□ 교육대상자: 해체허가(해체착공 전), 신고(해체완료 전)대상 공사장 시공자\n□ 교육내용\n&nbsp; ○ 건설기계 및 해체장비 운용\n&nbsp; &nbsp; - 건설기계 관련법 이해\n&nbsp; &nbsp; - 건설기계 및 해체장비 종류별 구조, 특성 및 원리 이해\n&nbsp; &nbsp; - 사고 사례와 대책 방안\n□ 교육신청기한: 2025. 6. 19.(목)까지\n&nbsp; &nbsp; &nbsp;* 신청방법: 이메일(hjh0903@mail.jongno.go.kr) 접수\n\n&nbsp; ※ 자세한 사항은 붙임 참고','ANNOUNCEMENT','2025-05-29 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255011&menuId=1753'),('2025-08-18 17:16:05.881003',1596,'오존주의보 해제 알림(2025. 5. 28.(수). 18시)','2025. 5. 28.(수) 18시 부로 오존 주의보 해제 기준(0.12ppm 미만)을 충족하여 오존 주의보를 해제합니다.\n','NOTICE','2025-05-27 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255009&menuId=1753'),('2025-08-18 17:16:05.890365',1597,'위해식품 긴급회수 알림 [궁복] 종료','\n	\n		\n			식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n			\n			가. 회수 제품명: 궁복\n			나. 소비기한: 2026.1.21., 2026.4.29.\n			다. 회수사유: 자가품질검사 결과 세균발육 기준 위반\n			라. 회수방법: 영업자 회수\n			마. 회수영업자: (주)청산바다\n			바. 영업자주소: 전라남도 완도군 농공단지4길 22-7\n			사. 연락처: 061-553-5900\n			아.&nbsp;기타: 위해식품 등 긴급회수 관련 협조요청\n		\n	\n','REPORT','2025-05-27 15:00:00.000000','2026-01-20 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255007&menuId=1753'),('2025-08-18 17:16:05.898730',1598,'오존주의보 발령 알림(2025. 5. 28.수. 14시)','2025. 5. 28.(수) 14시 부로 &quot;오존주의보&quot;가 발령되었습니다.\n\n&lt; 오존주의보 발령 사항&gt;\n○ 발령일시 : 2025. 5. 28.(수) 14:00 ~\n○ 대상지역 : 서울권역\n○ 발령요건 : 시간당 평균 0.12ppm 이상시\n\n어린이 및 노약자 등께서는 외출을 자제하여 주시고 부득이 외출 시 고농도 오존 시민행동\n요령 https://cleanair.seoul.go.kr/information/o3Tips 을 따라 주시기 바랍니다.\n&nbsp;\n※ 서울시 대기질 정보문자서비스 신청(무료): https://cleanair.seoul.go.kr/citizen/sms\n&nbsp;\n','PARTICIPATION','2025-05-27 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255006&menuId=1753'),('2025-08-18 17:16:05.906972',1599,'우산 고쳐쓰기 사업 운영 일정 변경 안내','제21대 대통령 선거와 관련하여 2025년 우산 고쳐쓰기 사업 운영 일정을 다음과 같이 변경하오니 이용에 참고하시기 바랍니다.\n\n\n\n\n* 운영시간\n- 09:00 ~ 16:00 (공휴일 휴무)\n- 14:30 접수 마감, 각 동 마지막일 13:00 접수 마감\n\n* 자세한 사항은 동별 일정(첨부)를 확인해주시기 바랍니다.','PARTICIPATION','2025-05-27 15:00:00.000000',NULL,1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000207700&amp;fileSn=1',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255005&menuId=1753'),('2025-08-18 17:16:05.914024',1600,'오존주의보 해제 알림(2025. 5. 27.화. 19시)','2025. 5. 27.(화) 19시 부로 오존주의보 해제 기준(0.12ppm 미만)을 충족하여 오존 주의보를 해제합니다.\n','NOTICE','2025-05-26 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255004&menuId=1753'),('2025-08-18 17:16:05.923759',1601,'오존주의보 발령 알림(2025. 5. 27.화. 14시)','2025. 5. 27.(화) 14시 부로 &quot;오존 주의보&quot;가 발령되었습니다.\n\n&lt; 오존주의보 발령 사항&gt;\n○ 발령일시 : 2025. 5. 27.(화) 14:00 ~\n○ 대상지역 : 서울권역\n○ 발령요건 : 시간당 평균 0.12ppm 이상시\n\n어린이 및 노약자 등께서는 외출을 자제하여 주시고 부득이 외출 시 고농도 오존 시민행동\n요령 https://cleanair.seoul.go.kr/information/o3Tips 을 따라 주시기 바랍니다.\n&nbsp;\n※ 서울시 대기질 정보문자서비스 신청(무료): https://cleanair.seoul.go.kr/citizen/sms\n\n\n&nbsp;\n&nbsp;\n&nbsp;\n','PARTICIPATION','2025-05-26 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255002&menuId=1753'),('2025-08-18 17:16:05.932978',1602,'수도권광역급행철도 A노선 민간투자사업 환경영향평가 준공통보서 게시','&nbsp;국토교통부 광역급행철도건설과- 1428(2025.5.22.)호와 관련입니다.\n\n「환경영향평가법」 제37조에 따라&nbsp;국토교통부에 접수된 &#39;수도권광역급행철도 A노선 민간투자사업&#39;의\n&nbsp;&nbsp;환경영향평가 준공통보서를 붙임과 같이 첨부하오니, 참고하여 주시기 바랍니다.\n&nbsp;\n\n&nbsp;참조 문의처 : 국토교통부 광역급행철도건설과(044-201-4024)','PARTICIPATION','2025-05-25 15:00:00.000000','2025-05-21 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255001&menuId=1753'),('2025-08-18 17:16:05.943897',1603,'2025년 6월 건축안전전문위원회(구조,굴토,해체) 심의 일정 안내','*중요*\n심의접수 및 심의도서의 세부사항 등에 관한 사항은 각 동 인허가 담당(정비구역의 경우 도시개발과 담당)에게 문의하시고,\n심의 일정 및 참석 여부에 관한 사항만 심의담당에게 문의하시기 바랍니다.\n\n[건축안전전문(구조, 굴토, 해체)위원회] 개최일정\n- 심의 개최일 : [11차] 2025. 6. 11.(수) &nbsp;/ &nbsp;[12차] 2025. 6. 25.(수)\n&nbsp; ※ 심의 신청은 [ [11차] 2025. 5. 28.(수) &nbsp;/ &nbsp;[12차] 2025. 6. 11.(수)] 18:00까지\n&nbsp; &nbsp; &nbsp; &nbsp;세움터로 접수(신청서 및 도서 제출 완료)하여 주시기 바랍니다.\n\n- 심의안건 및 참석위원명부 구 홈페이지 공개 : [11차] 6. 4.(수) / [12차] 6. 18.(수)\n\n※ 제출서류 및 업로드 위치\n[안전전문위원회 - 구조]\n&nbsp; ▶ 위임장 pdf (대지사용승낙서 등 )\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 일반문서 &rarr; 위임서\n&nbsp; ▶ 구조 심의도서(개략 건축도면 포함) pdf 1부, 구조계산서 pdf 1부\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 설계문서 &rarr; 기타\n\n[안전전문위원회 - 굴토]\n&nbsp; ▶ 위임장 pdf (대지사용승낙서 등 )\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 일반문서 &rarr; 위임서\n&nbsp; ▶ 굴토 심의도서(개략 건축도면 포함) pdf 1부,\n&nbsp; &nbsp; &nbsp; 지반조사보고서 pdf 1부, 흙막이계산서 pdf 1부\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 설계문서 &rarr; 기타\n\n[안전전문위원회 - 해체]\n&nbsp; ▶ 위임장 pdf\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 일반문서 &rarr; 위임서\n&nbsp; ▶ 해체 심의도서 pdf 1부, 건물구조계산서 pdf 1부\n&nbsp; &nbsp; - 업로드 위치 : 기본설계도서 &rarr; 문서 &rarr; 설계문서 &rarr; 기타\n\n※ 첨부의 &#39;건축안전전문위원회 심의도서 작성기준&#39; 꼭 확인하여 반영\n&nbsp; &nbsp; - 심의도서에 설계자, 건축사사무소명 표기 금지\n&nbsp; &nbsp; - 심의도서 하단에 페이지 번호 표기\n&nbsp; &nbsp; - 심의상정 사유 구체적으로 명확히 표기\n\n※ 세움터 업로드 유의사항\n&nbsp; &nbsp; - 기존 보완 파일 반드시 삭제 ! (최종 파일만 올릴 수 있도록)\n&nbsp; &nbsp; - 업로드 위치, 파일 제목 상기 내용과 동일하게 업로드\n&nbsp; &nbsp; - 심의 관련 문서는 가능한 하나의 파일로 작성요망\n\n\n아울러, 심의내용은 인허가 담당과 미리 협의하여주시기 바랍니다\n\n**건축안전전문위원회 심의 총괄: 홍지혜 주무관 02-2148-2822','ANNOUNCEMENT','2025-05-25 15:00:00.000000','2025-02-20 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=255000&menuId=1753'),('2025-08-18 17:16:05.960666',1605,'2025년 제9차 건축위원회 심의안건 및 참석위원 명부 공개','2025년 제9차 건축위원회 심의안건 및 참석위원 명부 공개','NOTICE','2025-05-25 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254998&menuId=1753'),('2025-08-18 17:16:05.973266',1606,'2025년 꿈나래 통장 모집','서울특별시 공고 제2025-1544호\n&nbsp;\n2025년『꿈나래통장』신규 참여자 모집 공고\n서울시에서는 자녀의 교육비 마련을 지원하는「꿈나래통장」의 2025년 신규 참여자를 아래와 같이 모집합니다.\n2025년 5월 26일\n서울특별시장\n1. 사업개요\n○ 『꿈나래통장』사업은 참여자가 자녀 교육비 마련을 위하여 매월 일정 금액을 3년 또는 5년간 저축하면 본인 저축액의 1/2 금액을 서울시와 민간후원금으로 적립&middot;지원함\n○ 자녀 교육비 마련 목적의 저축에 지원함\n〈 월 저축 가능 금액 및 지원내용 〉\n&nbsp;\n\n	\n		\n			본인저축액\n			5만원\n			10만원\n			12만원(3자녀 이상만)\n		\n		\n			매칭지원액\n			2.5만원\n			5만원\n			6만원\n		\n		\n			총\n			적립금\n			3년\n			270만원\n			540만원\n			648만원\n		\n		\n			5년\n			450만원\n			900만원\n			1,080만원\n		\n	\n\n2. 신청자격\n○ 공고일 기준(&rsquo;25. 5. 26.) 다음 ① &sim;②에 모두 해당하는 경우 신청 가능\n① 서울시 거주 중이며 만 14세 이하인 자녀를 둔 만 18세 이상 부모 등(친권자, 후견인)\n※ 신청인(친권자, 후견인)：만 18세 이상인 자(2007. 12. 31. 이전 출생자)\n대 상 아 동：만 14세 이하인 자(2010. 1. 1. 이후 출생자)\n② 동일 가구원(가족관계증명서 기준)의 소득인정액이 기준 중위소득 51%이상 80% 이하 가구？\n※ 한 가정에 1명의 자녀만 신청 가능\n* 동일 가구원 : 세대분리와 관계없이 가족관계증명서(및 기본증명서) 기준으로 산정\n&nbsp;\n\n	\n		\n			신청자가 대상아동의 친권자인 경우\n			신청인 가족관계증명서 기준\n		\n		\n			신청자가 대상아동의 친권자 외 후견인인 경우\n			대상아동 가족관계증명서 기준\n		\n	\n\n** 소득인정액 : 가구원의 소득과 보유재산을 일정비율로 환산한 금액\n&nbsp;\n\n	\n		\n			【 참고 】중위소득 확인 방법 (기준중위소득 80%)\n		\n		\n			&nbsp;\n			\n				\n					\n						가구원수\n						소득기준\n						(원)\n						건강보험료 본인부담금\n						예시(혼합가구 경우)\n					\n					\n						직장가입자\n						지역가입자\n						혼합\n					\n					\n						2인\n						3,147,000\n						112,371\n						37,001\n						113,324\n						가구원이 4명인 가구가\n						합산 170,000원인 경우\n						(신청인 직장가입\n						건강보험료 본인부담금 90,000원\n						배우자 지역가입 건강보험료 본인부담금 80,000원)\n						4인가구 혼합 기준 176,291원보다 작아 신청가능\n					\n					\n						3인\n						4,021,000\n						143,298\n						75,675\n						144,905\n					\n					\n						4인\n						4,879,000\n						174,082\n						113,431\n						176,291\n					\n					\n						5인\n						5,687,000\n						201,632\n						134,274\n						204,525\n					\n					\n						6인\n						6,452,000\n						229,454\n						167,069\n						232,948\n					\n					\n						7인\n						7,191,000\n						256,716\n						202,363\n						261,360\n					\n					\n						8인\n						7,930,000\n						282,728\n						235,277\n						288,617\n					\n					\n						9인\n						8,669,000\n						311,031\n						269,976\n						320,322\n					\n				\n			\n			\n		\n	\n\n○ 다음의 항목 중 하나라도 해당되는 경우 신청 제외\n① 신청인이 수급자(생계, 의료, 주거, 교육) 및 차상위계층\n② 신청인 본인 명의의 통장 개설이 불가능한 자\n③ 신청인 및 가구원이 아래 유사사업에 참여 중 또는 참여 이력(만기/중도해지 등)이 있는 자 ※ 단, 중도해지자 중 지원금을 받지 않은 경우는 신청 가능\n&nbsp;\n\n	\n		\n			- 신청인 본인의 중복가입 불가\n			[서울시] 희망두배 청년통장&middot;희망플러스통장&middot;꿈나래통장&middot;이룸통장 [보건복지부] 디딤씨앗통장\n			- 신청인 가구원(상기 동일 가구원 기준과 동일)의 중복가입 불가\n			[서울시] 희망플러스통장&middot;꿈나래통장&middot;이룸통장 [보건복지부] 디딤씨앗통장(CDA)\n		\n	\n\n3. 신청접수\n○ 모집인원 : 총 300명\n&nbsp;\n\n	\n		\n			합계\n			종로\n			중\n			용산\n			성동\n			광진\n			동대문\n			중랑\n			성북\n			강북\n			도봉\n			노원\n			은평\n		\n		\n			300\n			4\n			3\n			6\n			9\n			9\n			10\n			10\n			14\n			7\n			8\n			16\n			14\n		\n		\n			서대문\n			마포\n			양천\n			강서\n			구로\n			금천\n			영등포\n			동작\n			관악\n			서초\n			강남\n			송파\n			강동\n		\n		\n			10\n			11\n			17\n			18\n			12\n			5\n			11\n			11\n			9\n			18\n			24\n			25\n			19\n		\n		\n			\n		\n	\n\n○ 신청기간 : 2025. 6. 9.(월) ~ 6. 20.(금) 18:00 ※ 신청기간 외 접수 불가\n※ 접수일시 마감일 6. 20(금)에는 접수처가 혼잡하오니 사전에 미리 신청 바랍니다.\n○ 신청방법 : 온라인 신청(PC사용) 또는 주소지 동주민센터 방문\n- 온라인 신청 주소 : 서울시자산형성지원사업 홈페이지 https://account.welfare.seoul.kr\n- 주소지 동주민센터 방문: 근무일 중 09:00&sim;18:00 접수\n※ 접수 시작일과 마감일에 시스템 접속자 증가로 접속 지연에 유의(추가 연장 불가)\n- 제출 서류의 미비, 누락, 비밀번호등으로 식별 불가시 선발 제외 되므로 유의(작성 및 제출에 대한 책임은 본인에게 있으며 접수 기간 동안 수정 가능)\n&nbsp;\n\n	\n		\n			【 온라인 신청 시 준비 서류 】\n			※ 동주민센터 방문 불필요\n		\n		\n			① 가족관계증명서(일반출력) ※ 신청자 기준 발급, 주민번호 모두 표기\n			② 기본증명서(특정-친권？미성년후견 현재)[온라인 발급:정부24(전자가족관계등록시스템)]\n			- (발급기준) 대상아동 ※ 주민등록번호 전부 공개 선택\n		\n		\n			【 동주민센터 방문 신청 시 준비 서류 】\n			양식 다운로드 주소:\n			https://account.welfare.seoul.kr\n		\n		\n			① 꿈나래 통장 가입신청서\n			② 개인정보 수집？이용 및 제3자 제공？조회동의서(행정정보 공동이용 사전 동의서)\n			③ 사회보장급여 신청서\n			④ 금융정보 제공 동의서\n			⑤ 가족관계증명서(일반출력) ※ 신청자 기준 발급, 주민번호 모두 표기\n			⑥ 기본증명서(특정-친권？미성년후견 현재) [온라인 발급:정부24]\n			- (발급기준) 대상아동 ※ 주민등록번호 전부 공개 선택\n		\n		\n			【 해당자 추가서류 】\n			\n		\n		\n			① 가구 특성 ※ 해당사항 있는 경우 모두 제출, 제출자에 한해 반영\n			- (국가보훈) 국가유공자(유족)확인 또는 국가유공자에 준하는 군경(유족또는가족)등\n			확인서 또는 보훈보상대상자(유족)확인 등\n			- (북한이탈) 북한이탈주민확인서\n			② 가족관계 해체 사유서\n		\n	\n\n4. 선발방법\n○ 1차 심사：신청자격 적합 확인 및 서류 심사\n○ 2차 심사：선정심사표에 따라 자치구별 고득점순으로 선발\n- ① 가구의 소득인정액 ② 가구원수 ③ 서울시 거주기간 ④ 지원의 시급성\n⑤ 가구특성 ⑥ 만기 시 사용계획\n※ 신청자격 적합이더라도 모두 참여자로 선발되는 것이 아님에 유의\n&nbsp;\n\n	\n		\n			【 신청자 확인사항 】\n			\n		\n		\n			？ 소득？재산 사항은 사회보장정보시스템 조회 결과 적용\n			- 신청 이후 소득？재산 조회하므로 신청 전에 적격 여부 확인 및 상세내역 안내 불가\n			※ 신청 후 소득？재산 조사 동안 타시？도 전출 후 재전입, 소득？조사 불가하여 신청제외됨\n			？ 연락처(전화번호) 변경된 경우, 콜센터(1688-1453)를 통해 연락처 변경 내역 알림 필수\n			※ 선정 및 선정 이후 안내가 문자(SMS)로 진행되며 연락처 오기입 및 신청 이후\n			연락처 변경을 하지 않아 연락을 받지 못한 경우 참여 포기 간주\n		\n	\n\n5. 최종 참여대상자 선발\n○ 최종대상자 발표 : 2025. 11. 4.(화) 예정 ※ 발표일정은 사정에 따라 변동될 수 있음\n- 선발결과는 서울시복지재단 자산형성지원사업 홈페이지에서 신청자가 직접 확인\n○ 선정 이후 안내 및 이행사항\n① 선정자에게 선정 안내 문자 제공(미선정자 별도 연락 없음)\n② 서울시자산형성지원사업 홈페이지 선정 조회(동주민센터 신청자는 회원가입)\n③ 서울시 자산형성지원사업 홈페이지 약정실시 11월 10일 까지(저축 계약)\n④ 11월 25일(화) 저축계좌 확인 후 저축 실시(홈페이지 로그인시 확인 가능)\n- 선발자 발표 후 7일 이내에 약정 미완료 시 포기로 간주\n○ 약정 주요내용：저축 이행(매칭 지원액을 지급받기 위한 조건) 계약\n- 약정기간 내 서울시 연속 거주(등본상 주소지 서울시 외 지역 변경시 중도해지)\n- 약정기간의 50% 이상 월 1회 저축\n- 연 1회 이상 금융교육 이수\n6. 유의사항\n○ 신청서류 기재 내용이 사실과 다르거나 허위사실이 발견된 경우, 즉시 최종 선발을 취소할 수 있습니다.\n○ 우편 제출의 경우 신청자가 입력한 정보 또는 첨부파일 증빙자료가 부정확하거나 확인이 불가능한 경우 신청 제외되니 정확하게 작성&middot;제출하시기 바랍니다.\n○ 제출한 서류는 일체 반환하지 않으므로, 중요한 서류는 반드시 사본을 제출하여 주시기 바랍니다.\n○ 선발 이후 참가자의 약정위반사항(중복가입 등)이 확인되는 경우, 약정서에 의하여 중도 해지되고 매칭지원금은 지급되지 않습니다. 만기로 적립금을 수령한 경우 매칭지원금은 환수조치 될 수 있습니다.\n○ 선정 이후 문자(SMS) 안내된 기간 내 약정을 진행하지 않았을 경우 포기로 간주하며 별도에 추가 안내가 실시되지 않음에 유의하시기 바랍니다.\n7. 문의처\n○ 서울시 희망두배청년통장&middot;꿈나래통장 콜센터 ☎(국번없이)1688-1453\n8. 제출서류 제출 관련 홈페이지(컴퓨터로 접속 권장)\n○ 꿈나래 통장 신청 양식\n&nbsp;\n\n	\n		\n			신청서 및 부대 서류 일체\n			※ 온라인 신청시 시스템에서 작성\n		\n		\n			https://account.welfare.seoul.kr/ ？ 게시판 ？ 공지사항 ？ 꿈나래 통장 모집 안내\n		\n	\n\n○ 가족관계증명서(신청자)\n&nbsp;\n\n	\n		\n			가족관계증명서\n			신청자 기준, 주민번호 모두표기\n		\n		\n			https://efamily.scourt.go.kr/index.jsp ？ 가족관계증명서 발급\n		\n	\n\n○ 기본증명서(아동)\n&nbsp;\n\n	\n		\n			기본증명서 선택: 특정-친권？미성년후견 현재\n			주민번호 모두 표기\n		\n		\n			https://efamily.scourt.go.kr/index.jsp ？ 기본증명서 발급\n		\n	\n\n○ 주민등록초본\n&nbsp;\n\n	\n		\n			주민등록 초본(전체발급)\n			주민번호, 주소이전내역 모두 표기\n		\n		\n			https://www.gov.kr/ ？ 주민등록초본 발급\n		\n	\n\n\n','ANNOUNCEMENT','2025-05-25 15:00:00.000000','2025-05-25 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254997&menuId=1753'),('2025-08-18 17:16:05.986186',1607,'2025년 희망두배청년통장 모집','서울특별시 공고 제2025-1543호\n2025년『희망두배 청년통장』신규 참여자 모집 공고\n\n서울시에서는 일하는 청년들이 희망찬 미래를 준비할 수 있도록 자산형성을 지원하는「희망두배 청년통장」의 2025년 신규 참여자를 아래와 같이 모집합니다.\n2025년 5월 26일\n서울특별시장\n1. 사업개요\n○ 『희망두배 청년통장』사업은 서울시 거주 일하는 청년이 월 15만원을 2년 또는 3년간 저축하면, 본인 저축액과 동일한 금액을 서울시와 시민의 후원금으로 적립&middot;지원함\n○ 주거&middot;결혼&middot;교육&middot;창업&middot;미래대비저축 등 자립기반 조성 목적의 저축에 지원함\n〈 월 저축 가능 금액 및 지원내용 〉\n&nbsp;\n\n	\n		\n			구분\n			비고\n		\n		\n			본인저축액\n			15만원\n			이자 별도\n		\n		\n			매칭지원액\n			15만원\n		\n		\n			총적립금\n			2년\n			720만원\n		\n		\n			3년\n			1,080만원\n		\n	\n\n2. 신청자격\n○ 공고일 기준(&rsquo;25. 5. 26.) 다음 ① &sim; ⑤에 모두 해당하는 경우 신청 가능\n① 서울시 거주자 ※주민등록번호 부여자만 신청 가능(재외국인 및 재외국민 신청불가)\n② 만 18세 ~ 만 34세 청년 ※ 출생년월일이 1990. 1. 1. ~ 2007. 12. 31.인 자\n※ 제대군인의 경우 복무기간만큼 신청 가능 연령 상향\n(예: 군복무 2년시 신청가능 연령은 만 36세)\n③ 공고일 기준 최근 1년간 3개월 이상(월 10일 이상 또는 월 60시간 이상 근로 시 1개월 인정) 근로하였거나 현재 3개월 이상 근로 중인 자 ※근로 종류 무관, 공고문 상 안내된 증빙서류 종류만 인정\n④ 본인 근로소득 세전 월 평균 255만원 이하 (기준기간: 2024.06.01. ~ 2025.5.31.)\n⑤ 부&middot;모(기혼시 배우자) 소득 연 1억(세전 월평균 834만원) 미만이며 재산 9억 미만\n※ 세대분리 여부 무관, 미혼자는 부&middot;모 합산 기혼자는 배우자를 적용\n○ 다음의 항목 중 하나라도 해당되는 경우 신청 제외 및 선정된 후에도 참여 불가\n① 신청인 본인이 생계&middot;의료&middot;주거&middot;교육급여 수급자(보장시설 수급자 포함)\n② 신청인 본인 명의의 통장 개설이 불가능한 자 ※신용유의자, 전년도 약정자 중 약정 취소 및 중도해지자(1년 이내 동일상품 가입불가)\n③ 신청인 본인이 유사자산형성사업에 참여 이력이 있는 경우 ※ 붙임1 참조\n④ 사치&middot;향락&middot;도박&middot;사행 등 비사회적 업종 종사자\n- 사행산업통합감독위원회법, 사행행위 등 규제 및 처벌 특례법 등\n⑤ 군 의무 복무 중인자(현역, 상근, 전환, 사회복무, 대체복무, 산업기능, 전문연구 등)\n※ 입영 前 신청 후 입대로 인해 약정(저축 약속), 은행 방문 불가한 경우 선정 제외\n⑥ 서울시 청년수당(수혜) 중인 자 또는 근로장학생(장학금은 급여로 불인정)\n- 청년수당 2025년 수혜자는 희망두배 청년통장 공고월 이전(4월말)까지 중도해지 완료한 경우에만 신청 가능, 희망두배 신청 이후 심사 기간 중 청년수당 선정 확인시 희망두배 청년통장 선발 제외\n3. 신청접수\n○ 선발인원 : 총 10,000명\n○ 신청기간 : 2025. 6. 9.(월) ~ 6. 20.(금) 18:00 ※ 신청기간 외 접수 불가\n○ 신청방법 : 온라인 신청(PC만 신청 가능)\n- 접수처: 서울시 자산형성지원사업 홈페이지: https://account.welfare.seoul.kr\n※ 접수 시작일과 마감일에 시스템 접속자 증가로 접속 지연에 유의(추가 연장 불가)\n- 제출 서류의 미비, 누락, 비밀번호 등으로 식별 불가 시 선발 제외되므로 유의(작성 및\n제출에 대한 책임은 본인에게 있으며 접수 기간 동안 수정 가능)\n&nbsp;\n&nbsp;\n\n	\n		\n			【 제출서류 】\n			※ 공고일 이후 발급분 인정\n		\n		\n			① 주민등록초본(전체발급)\n			② 가족관계증명서(일반출력) ※ 신청자 기준 발급, 주민번호 모두 표기\n			③ 근로 증빙 서류: 2024년 6월 ~ 2025년 5월 내 3개월 이상 근로 확인 가능 서류\n			※ 근로 인정 증빙서류 종류: 붙임 2 참조\n			※ 근로 증빙서류가 많을 경우 ZIP파일로 묶어 1개 파일로 제출\n		\n		\n			【 해당자 추가서류 】\n			※ 해당사항 있는 경우 1개 선택 제출\n		\n		\n			① 청소년 쉼터 퇴소 확인서(해당 쉼터 발급)\n			② 정원(외)관리 증명서(초,중등과정)(정부24 발급)\n			③ 고등학교 제적증명서(고등과정)(정부24 발급)\n		\n	\n\n4. 선발방법\n○ 1차 심사：신청 자격 적합 확인 및 서류 심사\n○ 2차 심사：심사표에 따라 고득점순으로 선발\n- 심사 항목: 신청인 본인 ①재산 ②연령 ③서울시 거주기간 ④소득 ⑤근로기간\n⑥청소년 시설 퇴소 및 학교 밖 청년 ⑦부&middot;모 (기혼시 배우자) 소득\n⑧부&middot;모 (기혼시 배우자) 재산\n※ 신청자격 적합이더라도 모두 선발되는 것이 아님에 유의\n&nbsp;\n\n	\n		\n			【 신청자 확인사항 】\n			\n		\n		\n			？ 소득？재산 사항은 사회보장정보시스템 조회 결과 적용\n			- 신청 이후 소득？재산 조회하므로 신청 전에 적격 여부 확인 및 상세내역 안내 불가\n			※ 신청 후 소득？재산 조사 동안 타시？도 전출 후 재전입, 소득？조사 불가하여 신청제외\n			？ 연락처(전화번호) 변경된 경우, 신청 사이트를 통해 변경 내역 등록 필수\n			※ 선정 및 선정 이후 안내가 문자(SMS)로 진행되며 연락처 오기입 및 신청 이후\n			연락처 변경을 하지 않아 연락을 받지 못한 경우 참여 포기 간주\n			？ 유사자산형성사업 참여 이력이 있는 경우 지원금을 받지 않았음을 증빙하는 서류 제출(미제출자는 참여 이력 확인시 선정 제외)\n			※예시:공제금 지급내역서(청년내일채움공제), 해지 확인서(청년내일저축계좌),\n			참가 확인서(희망두배 청년통장)\n		\n	\n\n5. 선정자 발표\n○ 선정자 발표 : 2025. 11. 4.(화) 예정 ※ 발표일정은 사정에 따라 변동될 수 있음\n- 선정 결과는 서울시 자산형성지원사업 홈페이지에서 신청자가 직접 확인\n○ 선정자 이행 사항(참가자 등록 절차)\n① 서울시자산형성지원사업 홈페이지 약정 진행\n② 신한은행 본인명의 입출금 계좌 개설 후 희망두배 청년통장 적금 계좌 개설\n- 선발자 발표 후 7일 이내에 약정 미완료 및 계좌 개설 미실시는 포기로 간주\n- 약정 포기자 등 발생 시 부족 인원만큼 예비대상자 중에서 고득점순으로 추가 안내\n○ 참가자 의무사항\n- 약정기간 내 서울시 거주(등본상 주소지 서울시 외 지역 변경시 중도해지)\n- 약정기간의 50% 이상 근로 및 저축\n- 연 1회 이상 금융교육 이수\n6. 유의사항\n○ 신청서류 기재 내용이 사실과 다르거나 허위사실이 발견 시, 즉시 최종 선발을 취소할 수 있습니다.\n○ 신청인이 입력한 정보 또는 첨부파일 증빙자료가 부정확하거나 암호 설정 등으로 확인이 불가능한 경우 신청 제외되니 정확하게 작성&middot;제출하시기 바랍니다.\n○ 선발 이후 참가자의 약정위반사항(중복가입 등)이 확인되는 경우, 약정서에 의하여 중도 해지되며 매칭지원금은 지급되지 않습니다. 적립금을 수령한 경우 매칭지원금은 환수됩니다.\n○ 선정 이후 문자(SMS) 안내된 기간 내 통장 개설 및 약정을 진행하지 않았을 경우 포기로 간주하며 별도에 추가 안내가 실시되지 않음에 유의하시기 바랍니다.\n7. 문의처\n○ 서울시 희망두배청년통장&middot;꿈나래통장 콜센터 ☎(국번없이)1688-1453\n&nbsp;\n&nbsp;\n&nbsp;\n&nbsp;\n8. 제출서류 제출 관련 홈페이지(컴퓨터로 접속 권장)\n○ 주민등록초본\n&nbsp;\n\n	\n		\n			주민등록 초본(전체발급)\n			주민번호, 병역사항, 주소이전내역 모두 표기\n		\n		\n			https://www.gov.kr/ ？ 주민등록초본 발급\n		\n	\n\n○ 가족관계증명서\n&nbsp;\n\n	\n		\n			가족관계증명서\n			신청자 기준, 주민번호 모두표기\n		\n		\n			https://efamily.scourt.go.kr/index.jsp ？ 가족관계증명서 발급\n		\n	\n\n○ 근로 증빙서류\n\n\n	\n		\n			건강보험 자격득실 확인서\n			신청시 비밀번호 해제 후 업로드\n		\n		\n			https://www.gov.kr/portal/main/nologin ？ 검색란 건강보험자격득실 확인서\n		\n		\n			고용？산재보험 자격이력 내역서\n			신청시 비밀번호 해제 후 업로드\n		\n		\n			https://total.comwel.or.kr ？ 메뉴 고용？산재보험 자격 이력 내역서\n		\n		\n			본인 발급 원천징수영수증\n			홈택스(24년 발급 가능)\n			25년 원천징수영수증은 근로한 사업장에 요청\n		\n		\n			http://www.hometax.go.kr ？ 개인공동인증서 로그인 ？ MY홈택스 ？ 소득？연말정산 ？ 원천징수영수증 내역\n		\n		\n			사업자등록증명원\n			정부24\n		\n		\n			https://www.gov.kr/portal/main/nologin ？ 검색란 사업자등록증명원\n		\n		\n			세금신고내역\n			홈택스\n		\n		\n			http://www.hometax.go.kr ？ 로그인 ？ 세금신고 ？ 신고서 조회/삭제/부속서류 ？ 전자신고결과조회\n		\n		\n			매출집계표\n			홈택스\n		\n		\n			http://www.hometax.go.kr ？ 로그인 ？ MY홈택스 ？ 현금영수증, 신용카드 분기별 합계\n		\n		\n			고용임금확인서\n			서울시 자산형성지원사업 홈페이지\n		\n		\n			https://account.welfare.seoul.kr/web/main/index.lp ？ 게시판 ？ 공지사항 ？ 모집안내\n		\n		\n			급여 입금 내역\n			신청자의 거래중인 은행 홈페이지\n		\n		\n			입금내역이 회사명, 월급, 급여 등의 표기가 아닌 사업주 또는 관련자의 이름인 경우\n			관계입증이 가능한 사업자 등록증 등을 추가 제출\n		\n		\n			플랫폼 업무내역\n			플랫폼 홈페이지 또는 앱을 통해 조회되는 업무 내역\n		\n		\n			플랫폼에서 지급하는 급여가 아닐 경우 불인정(개인간 거래)\n		\n	\n\n&nbsp;\n붙임 1. 희망두배청년통장 온라인 신청 가이드&nbsp; 1부.&nbsp;\n&nbsp; &nbsp; &nbsp; &nbsp; 2. 희망두배청년통장 고용임금확인서 양식 1부.\n&nbsp; &nbsp; &nbsp; &nbsp; 3. 희망두배청년통장 포스터 1부.\n&nbsp; &nbsp; &nbsp; &nbsp; 4. 유사사업 중복참여 가이드 및 근로인정서류 참조 1부.&nbsp; &nbsp;끝.\n&nbsp;\n','ANNOUNCEMENT','2025-05-25 15:00:00.000000','2025-05-25 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254996&menuId=1753'),('2025-08-18 17:16:05.996508',1608,'2025년 제8차 건축위원회 및 제7차 건축계획전문위원회 심의 결과 공지','2025년 제8차 건축위원회 및 제7차 건축계획전문위원회 심의 결과 공지','REPORT','2025-05-22 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254995&menuId=1753'),('2025-08-18 17:16:06.005634',1609,'「종로 굿라이프 챌린지」 참여자 모집','어르신의 행복한 노후생활을 도모하여 고령친화도시를 조성하고자 추진하는 2025 어르신 솔로 프로젝트 1탄 「종로 굿라이프 챌린지」참여자 모집을 다음과 같이 안내하니, 종로구 어르신들의 많은 관심과 참여신청을 바랍니다.\n&nbsp;\n가. 행사개요\n○ 행 사 명 : 2025 어르신 솔로 프로젝트 1탄 「종로 굿라이프 챌린지」\n○ 일 시 : 2025. 6. 12.(목) 15:00 ~ 18:00\n○ 장 소 : 무계원(종로구 창의문로5가길 2) ※ 날씨 등 상황에 따라 장소변경 가능\n○ 행사내용 : 어르신 친구만들기 행사\n&nbsp;\n나. 참여자 모집\n○ 모집기간 : 2025. 5. 21. ~ 6. 2.(평일, 9일간)\n○ 모집대상 : 65세 이상 종로구 거주 혼자 계시는 어르신\n○ 모집인원 : 40명 이내(남, 여 각 20명 이내)\n○ 접수방법 : 방문접수(종로구청 7층 어르신복지과)\n○ 제출서류\n- 행사참가신청서, 개인정보 수집 이용 및 제공 동의서\n-&nbsp;주민등록표 초본, 혼인관계증명서는&nbsp;접수 시 확인 후 반환\n\n\n※ 행사참가신청서식 첨부파일참조\n&nbsp;','PARTICIPATION','2025-05-22 15:00:00.000000',NULL,1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000207578&amp;fileSn=3',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254994&menuId=1753'),('2025-08-18 17:16:06.015840',1610,'2025년 제9차 건축자산전문위원회 심의결과 공지','2025년 제9차 건축자산전문위원회 심의 결과를 붙임과 같이 공지하오니 참고하시기 바라며,\n다음 사항을 유의하여 주시기 바랍니다.\n&nbsp;\n가. 건축자산전문위원회 심의는 건축허가(사용승인 포함)절차 등에 따른 관련 법령의 저촉 여부에 대한 심의가 아니므로 건축\n허가(신고) 및 사용승인(준공)시 관련 법령을 검토 및 적용하여야 하며,\n나. 서울특별시 한옥 등 건축자산의 진흥에 관한 조례 시행규칙 제12조제1항에 의거, 한옥수선계획 변경 시에는 한옥 수선\n공사 착수 전 변경된 수선 계획을 제출하여 지원 여부 및 지원 금액 결정을 위한 심의를 다시 받으셔야합니다.\n다. 만약 위 사항을 위반할 경우, 동 조례 시행규칙 제15조제3항에 의거, 보조금 확정을 위한 완료심의 시 변경사항의 적정성\n여부를 심의하여 비용 지원 금액이 조정 또는 취소 될 수 있습니다.\n','ANNOUNCEMENT','2025-05-21 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254993&menuId=1753'),('2025-08-18 17:16:06.025607',1611,'위해식품 긴급회수 알림 [서분례명인 매실식초] 종료','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가. 회수 제품명: 서분례명인 매실식초\n나. 제조일자 및 소비기한\n- 제조일: 2025.3.11.\n- 소비기한: 2027.3.10.\n다. 회수사유: 자가품질검사 결과 보존료 기준 위반\n라. 회수방법: 영업자 회수\n마. 회수영업자: 서일농원\n바. 영업자주소: 경기도 일죽면 금일로 332-17\n사.&nbsp;기타: 위해식품 등 긴급회수 관련 협조요청','REPORT','2025-05-21 15:00:00.000000','2025-03-10 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254992&menuId=1753'),('2025-08-18 17:16:06.036114',1612,'2025년 제10차 건축안전전문위원회 심의 안건 및 참석위원 명부 공개','○ 2025년 제10차 건축안전전문위원회 개최 일정\n&nbsp; - 일 &nbsp; &nbsp;시: 2025. 5. 28.(수) 15:00\n&nbsp; - 장 &nbsp; &nbsp;소: 종로구청 3층 다목적실\n&nbsp; - 안 &nbsp; &nbsp;건: 총 5건(굴토 1건, 해체 4건)','NOTICE','2025-05-20 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254991&menuId=1753'),('2025-08-18 17:16:06.061811',1614,'2025년 제9차 건축안전전문위원회 심의결과 공지','2025년 제9차 건축안전전문위원회 심의결과 공지\n\n○ 2025년 제9차 건축안전전문위원회\n&nbsp; - 개최일시: 2025. 5. 14.(수) 15:00\n&nbsp; - 개최장소: 종로구청 3층 다목적실\n&nbsp; - 참 석 &nbsp;자: 위원장 등 심의위원 9인\n&nbsp; - 심의결과: 조건부의결 6건, 재심의결 1건','REPORT','2025-05-19 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254988&menuId=1753'),('2025-08-18 17:16:06.068666',1615,'종로구 실내 놀이복합문화공간 조성사업 설계공모 공고','서울특별시 종로구 공고 제 2025-740호\n\n종로구 실내 놀이복합문화공간 조성사업 설계(일반) 공모 공고\n\n2025. 5. 20.\n종로구청장\n\no 용역개요\n- (위치) 서울특별시 종로구 삼청동 1-6번지\n- (내용) 외부 여건(기온, 황사 등)에 제약없이 4계절 이용할 수 있는 &lsquo;지붕 있는 바깥 놀이터&rsquo;로서 실내놀이터 및 숲과 정원 속 휴식&middot;여가기능을 갖춘 복합문화공간을 종로 특색에 맞는 목조건축을 활용 조성\n- (예정공사비) 금2,091,200,000원 (부가가치세 포함)\n- (설계용역비) 금&nbsp; &nbsp; 99,669,000원 (부가가치세, 손해배상보험료 포함)\n\no 추진일정\n- (응모 등록) 2025. 5. 29.(목) 17시까지\n- (작품 접수) 2025. 7. 18.(금) 9~17시\n- (작품 심사) 2025. 7. 25.(금)(예정)\n- (결과 발표) 2025. 7. 31.(목)&nbsp; * 일정은 변동 가능\n\no 문의처\n- (주소) 종로구 종로1길 36, 종로구청 9층 도시녹지과\n- (전화) 02-2148-2834\n\n기타 자세한 사항은 붙임 문서를 참고하여 주시기 바랍니다.','ANNOUNCEMENT','2025-05-19 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254987&menuId=1753'),('2025-08-18 17:16:06.082573',1617,'종로구 「2025 여름철 종합대책」 알림','- 종로구 「2025 여름철 종합대책」 알림 -\n\n○ 추진기간 : 2025. 5. 15.(목)~10. 15.(수), 5개월간\n\n○ 추진내용 : 주민 모두가 건강하고 안전하게 여름나기\n&nbsp; &middot; (폭염대책) 폭염 대비 비상체제가동, 어르신&middot;노숙인 등 폭염 취약계층 보호&middot;지원 등\n&nbsp; &middot; (수방대책) 수해 대비 방재시설 확충&middot;점검, 신속&middot;정확한 상황 파악 및 복구 등\n&nbsp; &middot; (안전대책) 여름철 재난취약시설 안전점검 및 관리, 수난사고 대비 등\n&nbsp; &middot; (보건대책) 감염병 지속 감시&middot;관리, 식중독 예방, 맞춤형 해충 방제 실시 등\n\n○ 소관부서 : 분야별 대책반 구성&middot;운영\n&nbsp; &middot; (폭염분야) 안전도시과 폭염대책반 ☎2148-3008\n&nbsp; &middot; (수방분야) 치수과 수방대책반 ☎2148-3223\n&nbsp; &middot; (안전분야) 안전도시과 안전대책반 ☎2148-3013\n&nbsp; &middot; (보건분야) ①의약과 ☎2148-3752 ②보건정책과 ☎2148-3533\n\n○ 동주민센터(17개동)\n▲ 청운효자동 ☎2148-5002&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;▲ 사직동 ☎2148-5032&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 삼청동 ☎2148-5062&nbsp;\n▲ 부암동 ☎2148-5092&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 평창동 ☎2148-5123&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 무악동 ☎2148-5152\n▲ 교남동 ☎2148-5182&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 가회동 ☎2148-5212&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 종로1&middot;2&middot;3&middot;4가동 ☎2148-5242\n▲ 종로5&middot;6가동 ☎2148-5272&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ▲ 이화동 ☎2148-5303&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 혜화동 ☎2148-5332\n▲ 창신1동 ☎2148-5392&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;▲ 창신2동 ☎2148-5422&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;▲ 창신3동 ☎2148-5452&nbsp;\n▲ 숭인1동 ☎2148-5482&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;▲ 숭인2동 ☎2148-5512\n\n\n\n\n\n','NOTICE','2025-05-14 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254984&menuId=1753'),('2025-08-18 17:16:06.089339',1618,'2025 종로복지재단 기간제 근로자 채용공고(3차)','- 재단법인 종로복지재단 공고문 -\n\n* 2025년 종로복지재단 기간제 근로자 채용공고(3차) *\n\n종로구 출연기관 [재단법인 종로복지재단]에서 운영 중인 종로구 1인가구 지원센터 및 종로구 자원봉사센터의 근무직원을\n붙임과 같이 공개 모집하오니 많은 응모 바랍니다.\n\n* 채용분야 : 기간제근로자 총 2명 / 1인가구 지원센터 1명, 자원봉사센터 1명&nbsp;&nbsp;\n\n* 원서접수기간 : 25.5.19.(월) ~ 5.23.(금)&nbsp;&nbsp;\n\n* 기타문의 : 070-4297-8402 (종로복지재단 운영협력팀)\n\n&nbsp;&nbsp;관련상세사항 붙임파일 확인바랍니다.\n&nbsp;&nbsp;\n\n\n붙임 : 기간제근로자 채용공고 및 제출서식 각 1부.&nbsp;&nbsp;끝.','ANNOUNCEMENT','2025-05-13 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254982&menuId=1753'),('2025-08-18 17:16:06.095008',1619,'2025년 정화조 악취저감장치 설치 지원사업 신청자 모집 공고','서울특별시 종로구 공고 제2025-729호\n2025년 정화조 악취저감장치 설치 지원사업 신청자 모집 공고\n\n정화조 악취 없는 쾌적한 종로를 만들기 위해 악취저감장치 지원사업을 다음과 같이 공고하니 주민 여러분의 많은 관심과 참여 바랍니다.\n\n&nbsp;&lt; 2025년 정화조 악취저감장치 설치 지원사업 신청자 모집 &gt;\n&nbsp;ㅇ 사업대상: 부패식 정화조 건물 소유자 또는 관리자(200인조 미만 강제배출&middot;1,000인조 미만 자연유하)\n&nbsp;ㅇ 지원내용: 정화조 악취저감장치 설치비용 지원(총 7개소)&nbsp;※ 1개소 당 지원금액 : 2,500천원 이내\n&nbsp;ㅇ 신청기간: 2025. 5. 13. (화) ~ 2025. 6. 5.(목)\n&nbsp;ㅇ 신청방법\n&nbsp; &nbsp;- 방문 접수 : 종로구 새문안로 41, (신문로2가) 종로구청 별관 9층 청소행정과\n&nbsp; &nbsp;- 메일(rudfla14@mail.jongno.go.kr) 또는 팩스(02-2148-5825) 접수\n&nbsp;ㅇ 문의사항: 종로구청 청소행정과(02-2148-2363)\n&nbsp;ㅇ 접수서류\n&nbsp; &nbsp;-&nbsp;정화조 악취저감장치 설치지원 사업 신청서 1부(별지 제1호 서식)\n&nbsp; &nbsp;- 개인정보 수집&middot;이용&middot;제공 동의서 (별지 제2호 서식)\n&nbsp;\n\n\n&nbsp;','ANNOUNCEMENT','2025-05-13 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254981&menuId=1753'),('2025-08-18 17:16:06.101533',1620,'동물등록 자진신고 및 집중단속기간 운영','\n□&nbsp;&nbsp;운영개요\n\n○ 자진신고 기간 : (1차) 5. 1. ~ 6. 30. (2차) 9. 1. ~ 10. 31.\n&nbsp; &nbsp; &nbsp;※ 집중단속 기간: (1차) 7. 1. ~ 7. 31. (2차) 11. 1. ~ 11. 30.\n\n○ 운영내용 : 자진신고 기간 내 동물등록 또는 변경신고 시 과태료 면제\n\n○ 등록대상 : 2개월령 이상의 개(고양이는 내장형으로 선택적 등록 가능)\n\n○ 신규등록\n&nbsp; ① 반려동물과 함께 동물등록 대행기관(동물병원) 방문\n&nbsp; ② 동물에 무선식별장치 시술 또는 부착 ③ 등록 완료\n&nbsp; &nbsp; &nbsp; ※ 동물등록 대행기관: 국가동물보호정보시스템(https://www.animal.go.kr) 확인 가능\n\n○ 변경신고 : 동물등록 후 소유자 정보 변경 시 정해진 기간 내 신고\n&nbsp; &nbsp;- 신고방법: 등록대행기관 방문 또는 온라인(정부24, 국가동물보호정보시스템) 신고\n&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;1) 정부 24(www.gov.kr) : 소유자 변경(변경된 소유자, 전 소유자 모두 신고 후 자치구 승인), 동물 사망&middot;분실, 중성화 여부\n\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) 국가동물보호정보시스템(www.animal.go.kr) : 소유자 주소&middot;전화번호, 동물 사망&middot;분실\n&nbsp; &nbsp;- 변경신고 대상: 소유자&middot;소유자 인적사항 변경, 동물 정보변경\n\n','ANNOUNCEMENT','2025-05-11 15:00:00.000000',NULL,1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000207306&amp;fileSn=1',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254980&menuId=1753'),('2025-08-18 17:16:06.108619',1621,'주택 임대차 계약 신고제  및 과태료 부과 시행 안내','&nbsp;&nbsp;\n\n주택 임대차 신고제 계도기간이 2025. 5. 31. 종료됩니다.&nbsp;\n\n2025. 6. 1. 이후 주택 임대차 계약을 체결하고&nbsp;임대차 신고를 하지 않을 경우 과태료가\n\n부과되오니 반드시 신고하여 주시기 바랍니다.\n\n\n□ 주택 임대차 계약 신고제\n\n&nbsp; ㅇ신고대상 : 주택임대차보호법상 주택으로 보증금 6천만 원 또는 월차임 30만 원 초과하는 임대차 계약\n\n&nbsp; ㅇ신고의무 : 임대인&middot;임차인이 계약체결일로부터 30일 이내 공동신고\n\n&nbsp; ㅇ신고방법 : 주택 관할 동주민센터 방문 또는 온라인(부동산거래관리시스템), 모바일 신고\n&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*부동산거래관리시스템 : https://rtms.molit.go.kr\n\n&nbsp; ㅇ제재사항 : 미신고 및 지연신고 최대 30만원, 거짓신고 100만원 과태료\n&nbsp;\n□ 과태료 부과\n\n&nbsp; ㅇ &rsquo;25.6.1.이후 체결된 주택 임대차 계약 중 지연(미)신고 또는 거짓 신고한 경우, 임대인&middot;임차인에게 각각 부과\n\n&nbsp; ㅇ 부과 기준\n\n&nbsp;','ANNOUNCEMENT','2025-05-11 15:00:00.000000',NULL,1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000207302&amp;fileSn=1',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254979&menuId=1753'),('2025-08-18 17:16:06.116502',1622,'2025년 가스열펌프(GHP) 배출가스 저감장치 부착 지원사업 재공고','2025년 가스열펌프(GHP) 배출가스 저감장치 부착 지원사업을 아래와 같이 공고&middot;시행하고자 합니다.\n\n□ 사업내용: 가스열펌프(GHP) 배출가스 저감장치 설치비의 90% 보조금 지원\n\n□ 사업기간: 2025. 5. ~ 12.(단, 사업비 소진 시 조기 마감)\n\n□ 지원대상: 2022. 12. 31. 이전 GHP를 설치하여 운영 중인 민간시설\n&nbsp; -&nbsp;①병원&nbsp;②사회복지시설 ③설치 대수가 많은 사업장 ④신청일자 순으로 우선 지원\n&nbsp; &nbsp; ※ 보조금 지원대상 선정 후 GHP 철거 등 지원사업장의 취소분 발생시 후순위(예비) 사업장에 보조금 지원자격이 부여됨\n&nbsp; &nbsp;&nbsp;(단, 엔진형식 단가가 상이하여 취소된 금액을 초과할 시 취소된 금액 내에서 지원하며, 초과분은 사업장에서 부담함)\n&nbsp; &nbsp; ※ 제외대상\n&nbsp; &nbsp; &nbsp; ▶ 16년 이상 운영 노후 GHP는 노후화 정도 및 지자체 집행계획 등에 따라 지원 대상(2009년 이후 운영)에서 제외될 수 있음\n&nbsp; &nbsp; &nbsp; ▶ (교육부 지원대상) 초&middot;중&middot;고 및 국공립 대학&middot;유치원\n\n□ 지원금액: 첨부파일 참고\n\n□ 신청기간: 2025. 5. 19. ~ 6. 11.\n\n□ 지원조건: 지원시설 2년 이상 운영 및 사후관리 협조\n\n□ 지원내역: 저감장치 부착 비용의 약 90% 지원(국비 50%, 시비 40%)\n\n□ 신청방법: 방문접수 및 등기우편(접수처: 종로구청 환경과 대기관리팀)','ANNOUNCEMENT','2025-05-11 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254978&menuId=1753'),('2025-08-18 17:16:06.122518',1623,'2025년 1인 가게 안심경광등 지원사업 신청안내','\n\n○ 신청대상: 서울특별시 내 1인이 상시 근무하는 소규모 점포\n&nbsp; &nbsp;&nbsp;※ 직원이 2인 이상이라도 교대근무 등으로 혼자서 근무하는 경우 지원 가능\n○ 1차 신청기간: 2025. 5. 27.(화)~6. 5.(목)\n○ 신청방법: 서울시 홈페이지(www.seoul.go.kr)에서 신청서 작성\n○ 주요기능: 긴급 신고 시 자체 경고음, 점멸등 발생 및 경찰신고 가능','PARTICIPATION','2025-05-11 15:00:00.000000',NULL,1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000207281&amp;fileSn=1',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254977&menuId=1753'),('2025-08-18 17:16:06.127116',1624,'제4기 종로사랑 구민기자단 모집','&nbsp; &nbsp; &nbsp; &nbsp;제4기 종로사랑 구민기자단 모집\n\n\n종로구 소식지 &#39;종로사랑&#39;에서 활동할 구민기자를 모집합니다.&nbsp;\n내가 직접 취재한 종로구의 생생한 소식을 알리고 싶으시다면 지금 바로 지원해 주시기 바랍니다.&nbsp;\n구민 여러분의 많은 참여 기다립니다.&nbsp;\n\n○ 모집기간: 2025. 5. 12.(월)~6. 9.(월)\n\n○ 모집인원: 총 10명 내외\n\n○ 모집대상\n&nbsp; &nbsp;- 청소년(2007년~2016년 관내 학생), 대학생,\n&nbsp; &nbsp;- 19세 이상 종로구민 또는 종로구 소재 기업체 및 단체 소속자\n\n○ 제출서류: 지원서 및 샘플기사(자유주제)\n\n○ 제출방법: 소식지 담당자 전자메일(sera414@seoul.go.kr) 제출\n\n○ 활동내용\n&nbsp; &nbsp;- 기 간 : 2025년 7월~2027년 6월(2년) ※1회 연임 가능\n&nbsp; &nbsp;- 내 용 : 종로사랑 현장취재, 우리동네 미담사례 등 발굴 기사 작성\n&nbsp; &nbsp;- 활동지원: 기사 게재 시 원고료(5만원), 기자증 발급, 교육 제공\n\n○ 심사선정: 서류심사\n&nbsp; &nbsp;- 구정 관심도, 제출기사의 참신성&middot;적합성&middot;완성도, 관련분야 경험 등\n\n○ 합격발표: 6. 25.(수) 종로사랑 7월호 명단 게재\n\n○ 문 의: 종로구청 홍보과(☎ 02-2148-1674)\n\n','ANNOUNCEMENT','2025-05-10 15:00:00.000000','2025-02-20 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254976&menuId=1753'),('2025-08-18 17:16:06.134649',1625,'2024년 장기요양기관 재가급여 수시평가 결과','\n&nbsp; &nbsp; ※평가기간: 2024.10.1.&sim;2025.1.30.(4개월)','REPORT','2025-05-08 15:00:00.000000','2024-09-30 15:00:00.000000',1,24,'http://www.jongno.go.kr/portal/cmm/fms/FileDown.do?atchFileId=FILE_000000000207246&amp;fileSn=2',NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254975&menuId=1753'),('2025-08-18 17:16:06.142568',1626,'2025년 제8차 건축위원회 및 제7차 건축계획전문위원회 심의안건, 참석위원 명부 공개','2025년 제8차 건축위원회 및 제7차 건축계획전문위원회 심의안건, 참석위원 명부 공개','NOTICE','2025-05-08 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254974&menuId=1753'),('2025-08-18 17:16:06.150634',1627,'2025년 제7차 건축위원회 및 제6차 건축계획전문위원회 심의 결과 공지','2025년 제7차 건축위원회 및 제6차 건축계획전문위원회 심의 결과 공지','REPORT','2025-05-08 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254973&menuId=1753'),('2025-08-18 17:16:06.159901',1628,'2025년 제9차 건축안전전문위원회 심의 안건 및 참석위원 명부 공개','○ 2025년 제9차 건축안전전문위원회 개최 일정\n&nbsp; - 일 &nbsp; &nbsp;시: 2025. 5. 14.(수) 15:00\n&nbsp; - 장 &nbsp; &nbsp;소: 종로구청 3층 다목적실\n&nbsp; - 안 &nbsp; &nbsp;건: 총 8건(굴토 5건, 해체 3건)','NOTICE','2025-05-07 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254972&menuId=1753'),('2025-08-18 17:16:06.169403',1629,'광화문스퀘어 미디어폴 설치 및 운영사업자 선정 제안서 평가위원회 결과 공개','광화문스퀘어 미디어폴 설치 및 운영사업자 선정 제안서 평가위원회를 개최하고 그 결과를 붙임과 같이 공개합니다.','ANNOUNCEMENT','2025-05-06 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254971&menuId=1753'),('2025-08-18 17:16:06.178451',1630,'위해식품 긴급회수 알림 [토디팜째] 종료','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가. 회수 제품명: 토디팜째\n나. 제조일자 및 소비기한&nbsp;\n- 제조일: 2025.4.22.\n- 소비기한: 2025.4.27.\n다. 회수사유: 자가품질검사 결과 세균수 기준 규격 위반\n라. 회수방법: 판매처를 통한 영업자 회수\n마. 회수영업자: 비엣코\n바. 영업자주소: 경기도 부천시 소사구 서촌로38번길 22, 1\n사. 연락처: 054-956-9970\n아. 기타: 위해식품 등 긴급회수 관련 협조요청','REPORT','2025-05-06 15:00:00.000000','2025-04-21 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254970&menuId=1753'),('2025-08-18 17:16:06.186953',1631,'위해식품 긴급회수 알림 [문어모양소떡롤]','식품위생법 제45조에 따라 아래의 식품 등을 긴급회수 합니다.\n\n가. 회수 제품명: 문어모양 소떡롤\n나. 소비기한 및 (제조일)\n-2025.9.29. (2024.9.30.)\n-2025.10.6. (2024.10.7.)\n-2025.12.15. (2024.12.16.)\n다. 회수사유: 표시대상 알레르기 유발물질을 표시하지 않은 식품\n라. 회수방법: 거래처 및 판매처를 통한 영업자 회수\n마. 회수영업자: 농업회사법인주식회사 진영식품\n바. 영업자주소: 화성시 장안면 황골길 94\n사. 연락처: 031-357-1364\n아. 기타: 위해식품 등 긴급회수 관련 협조요청','NOTICE','2025-05-06 15:00:00.000000','2025-09-28 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254969&menuId=1753'),('2025-08-18 17:16:06.194937',1632,'2025년 정화조 악취저감장치 모니터링시스템 설치 지원 안내','2025년 악취저감장치가 설치된 정화조에 대한 모니터링시스템 설치 지원사업을 추진하고자 하니, 사업 신청을 희망하시는\n정화조 건물 소유자 및 관리자께서는 2025. 5. 9. (금)까지&nbsp; 모니터링시스템 참여동의서를 제출하여 주시기 바랍니다.\n&nbsp;\n&nbsp;○ 2025년 정화조 악취저감장치 모니터링시스템 설치 지원 개요\n&nbsp; - 신청기간 : 2025. 4. 16. (수) ~ 5. 9. (금)\n&nbsp; - 사업대상 : 518개소(악취저감장치가 설치된 자연유하&middot;강제배출 정화조)\n&nbsp; - 사업내용 : 정화조 악취저감장치 가동 모니터링 시스템을 구축, 미가동 시\n&nbsp; &nbsp; 시스템에 이상신호를 표시하여 현장 가동상태를 확인\n&nbsp; - 사업효과 : 원격 모니터링을 통해 가동여부를 실시간 확인하여 악취민원 저감\n&nbsp;\n&nbsp;&nbsp;- 신청방법 : 종로구청 별관 청소행정과 방문(새문안로 41, 9층)\n&nbsp; &nbsp; 이메일(rudfla14@mail.jongno.go.kr), 팩스(02-2148-5825)\n&nbsp;&nbsp;- 제출서류 : &ldquo;자세히보기&rdquo; 클릭\n&nbsp;&nbsp;- 문 의 : 종로구청 청소행정과 ☎02-2148-2363\n','PARTICIPATION','2025-05-01 15:00:00.000000','2025-02-20 15:00:00.000000',1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254968&menuId=1753'),('2025-08-18 17:16:06.205262',1633,'2025년 제8차 건축자산전문위원회 심의결과 공지','2025년 제8차 건축자산전문위원회 심의 결과를 붙임과 같이 공지하오니 참고하시기 바라며,\n다음 사항을 유의하여 주시기 바랍니다.\n&nbsp;\n가. 건축자산전문위원회 심의는 건축허가(사용승인 포함)절차 등에 따른 관련 법령의 저촉 여부에 대한 심의가 아니므로 건축\n&nbsp; &nbsp; &nbsp;허가(신고) 및 사용승인(준공)시 관련 법령을 검토 및 적용하여야 하며,\n나. 서울특별시 한옥 등 건축자산의 진흥에 관한 조례 시행규칙 제12조제1항에 의거, 한옥수선계획 변경 시에는 한옥 수선\n&nbsp; &nbsp; &nbsp;공사 착수 전 변경된 수선 계획을 제출하여 지원 여부 및 지원 금액 결정을 위한 심의를 다시 받으셔야합니다.\n다. 만약 위 사항을 위반할 경우, 동 조례 시행규칙 제15조제3항에 의거, 보조금 확정을 위한 완료심의 시 변경사항의 적정성\n&nbsp; &nbsp; &nbsp;여부를 심의하여 비용 지원 금액이 조정 또는 취소 될 수 있습니다.\n','ANNOUNCEMENT','2025-04-30 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254967&menuId=1753'),('2025-08-18 17:16:06.271691',1634,'2025년 제5차 해체공사장 시공자 사전교육 일정 공지','2025년 제5차 해체공사장 시공자 사전교육 일정을 공지하오니 해체공사(허가, 신고) 현장대리인께서는\n신청 후 교육을 수료(최초 교육일로부터 2년간 유효)하시기 바랍니다.\n\n□ 교 육 &nbsp;명: 2025년 제5차 해체공사장 시공자 사전교육\n□ 교육일시: 2025. 5. 26.(월) 15:00~17:00\n□ 교육장소: 종로구청 3층 세미나실\n□ 교육강사: 김재연 교수\n□ 교육대상자: 해체허가(해체착공 전), 신고(해체완료 전)대상 공사장 시공자\n□ 교육내용\n&nbsp; ○ 건설기계 및 해체장비 운용\n&nbsp; &nbsp; - 건설기계 관련법 이해\n&nbsp; &nbsp; - 건설기계 및 해체장비 종류별 구조, 특성 및 원리 이해\n&nbsp; &nbsp; - 사고 사례와 대책 방안\n□ 교육신청기한: 2025. 5. 22.(목)까지\n&nbsp; &nbsp; &nbsp;* 신청방법: 이메일(hjh0903@mail.jongno.go.kr) 접수\n\n&nbsp; ※ 자세한 사항은 붙임 참고','ANNOUNCEMENT','2025-04-30 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254966&menuId=1753'),('2025-08-18 17:16:06.282024',1635,'2025 인사동 지역발전 공모사업 최종 선정 결과','2025 인사동 지역발전 공모사업 최종 선정 결과를 붙임과 같이 공지합니다.\n\n※ 신청사업자에 대해 신청 결과 개별 안내 예정','ANNOUNCEMENT','2025-04-29 15:00:00.000000',NULL,1,24,NULL,NULL,NULL,'',NULL,'https://www.jongno.go.kr/portal/bbs/selectBoardArticle.do?bbsId=BBSMSTR_000000000201&nttId=254965&menuId=1753');
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
) ENGINE=InnoDB AUTO_INCREMENT=2242 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_categories`
--

LOCK TABLES `document_categories` WRITE;
/*!40000 ALTER TABLE `document_categories` DISABLE KEYS */;
INSERT INTO `document_categories` VALUES (48,29,2),(50,30,2),(51,30,7),(49,30,8),(52,31,7),(54,33,7),(53,33,8),(55,34,2),(56,34,7),(58,35,4),(57,35,8),(59,36,3),(60,36,5),(61,37,3),(62,38,2),(63,39,8),(64,40,3),(65,41,8),(66,42,3),(67,43,3),(68,44,7),(70,45,4),(69,45,8),(71,46,2),(72,46,5),(73,46,7),(75,48,4),(76,48,6),(77,48,7),(74,48,8),(78,49,2),(79,49,6),(80,50,5),(81,51,5),(82,52,8),(83,53,7),(85,54,3),(84,54,8),(87,55,5),(86,55,8),(89,57,4),(88,57,8),(91,59,3),(92,59,4),(93,59,7),(90,59,8),(95,60,7),(94,60,8),(97,61,7),(96,61,8),(99,62,2),(100,62,7),(98,62,8),(101,66,2),(102,68,3),(103,68,7),(104,69,6),(106,70,3),(107,70,7),(105,70,8),(108,71,6),(109,71,7),(110,72,3),(111,73,3),(113,75,2),(114,75,7),(112,75,8),(116,76,4),(117,76,7),(115,76,8),(119,77,4),(120,77,7),(118,77,8),(122,78,7),(121,78,8),(123,79,3),(124,79,7),(126,80,4),(125,80,8),(127,82,8),(128,85,3),(129,85,7),(130,87,2),(131,87,6),(132,87,7),(134,90,6),(135,90,7),(133,90,8),(136,92,5),(137,93,2),(139,94,7),(138,94,8),(140,95,5),(141,95,6),(143,96,4),(142,96,8),(145,97,4),(144,97,8),(147,98,7),(146,98,8),(148,99,5),(149,100,8),(266,201,2),(267,202,3),(269,203,5),(268,203,8),(271,205,8),(272,206,3),(293,218,7),(292,218,8),(312,231,7),(311,231,8),(2109,1557,5),(2110,1557,7),(2108,1557,8),(2111,1558,9),(2112,1559,9),(2113,1560,9),(2114,1561,9),(2115,1562,9),(2116,1563,9),(2118,1564,6),(2117,1564,8),(2120,1565,5),(2121,1565,6),(2119,1565,8),(2123,1566,6),(2122,1566,8),(2124,1567,9),(2125,1568,8),(2127,1569,7),(2126,1569,8),(2128,1570,9),(2129,1571,6),(2130,1572,8),(2132,1573,5),(2133,1573,7),(2131,1573,8),(2134,1574,9),(2135,1575,4),(2137,1576,4),(2136,1576,8),(2139,1577,2),(2138,1577,8),(2141,1578,5),(2142,1578,7),(2140,1578,8),(2143,1579,9),(2145,1580,6),(2144,1580,8),(2146,1581,6),(2148,1582,5),(2147,1582,8),(2149,1583,8),(2151,1584,7),(2150,1584,8),(2153,1585,2),(2154,1585,5),(2155,1585,6),(2152,1585,8),(2156,1586,5),(2157,1586,6),(2169,1587,8),(2159,1588,6),(2160,1589,6),(2162,1590,6),(2163,1590,7),(2161,1590,8),(2165,1591,6),(2166,1591,7),(2164,1591,8),(2167,1592,6),(2168,1593,9),(2171,1594,6),(2170,1594,8),(2173,1596,9),(2174,1597,9),(2175,1598,8),(2176,1599,8),(2177,1600,9),(2178,1601,8),(2180,1602,4),(2181,1602,5),(2179,1602,8),(2183,1603,6),(2182,1603,8),(2185,1605,9),(2187,1606,3),(2188,1606,4),(2189,1606,7),(2186,1606,8),(2190,1607,3),(2191,1607,4),(2192,1607,5),(2193,1607,7),(2194,1607,8),(2195,1608,9),(2197,1609,7),(2196,1609,8),(2199,1610,7),(2198,1610,8),(2200,1611,9),(2201,1612,6),(2203,1614,6),(2205,1615,2),(2206,1615,5),(2204,1615,8),(2209,1617,6),(2210,1617,7),(2208,1617,8),(2212,1618,4),(2213,1618,7),(2211,1618,8),(2215,1619,5),(2216,1619,7),(2214,1619,8),(2217,1620,9),(2218,1621,3),(2220,1622,5),(2221,1622,7),(2219,1622,8),(2223,1623,7),(2222,1623,8),(2225,1624,5),(2226,1624,7),(2224,1624,8),(2227,1625,7),(2228,1626,9),(2229,1627,9),(2230,1628,6),(2231,1629,9),(2232,1630,9),(2233,1631,9),(2235,1632,5),(2236,1632,7),(2234,1632,8),(2238,1633,7),(2237,1633,8),(2240,1634,6),(2239,1634,8),(2241,1635,8);
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

-- Dump completed on 2025-08-19  3:54:35
