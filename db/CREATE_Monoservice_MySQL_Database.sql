# author: 	J. Kraehemann
# created:	27.01.2019

SET time_zone='+00:00';

DROP DATABASE IF EXISTS MONOSERVICE;


CREATE DATABASE MONOSERVICE DEFAULT CHARACTER SET utf8;


USE MONOSERVICE;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `SERVICE_CONFIG`;


CREATE TABLE `SERVICE_CONFIG`
(
  `SERVICE_CONFIG_ID` INTEGER NOT NULL auto_increment,
  `PROFILE_NAME` VARCHAR(255) NOT NULL,
  `UPLOAD_MAX_AGE` TIMESTAMP DEFAULT 0,
  `DOWNLOAD_MAX_AGE` TIMESTAMP DEFAULT 0,
  `CLEAN_INTERVAL` TIMESTAMP DEFAULT 0,
  `LAST_CLEANED` TIMESTAMP DEFAULT 0,
  `SCHEDULED_UPLOAD` BOOLEAN,
  `UPLOAD_SCHEDULE_TIME` TIMESTAMP DEFAULT 0,
  `DELAYED_UPLOAD` BOOLEAN,
  `UPLOAD_DELAY_TIME` TIMESTAMP DEFAULT 0,
  `MOV_WIDTH` FLOAT DEFAULT 1080,
  `MOV_HEIGHT` FLOAT DEFAULT 1080,
  `MOV_FPS` FLOAT DEFAULT 25.0,
  `MOV_BITRATE` INTEGER DEFAULT 1200000,
  `SND_CHANNELS` INTEGER DEFAULT 2,
  `SND_SAMPLERATE` INTEGER DEFAULT 44100,
  `SND_BITRATE` INTEGER DEFAULT 128000,
  PRIMARY KEY (`SERVICE_CONFIG_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;


#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `USERS`;


CREATE TABLE `USERS`
(
  `USERS_ID` INTEGER NOT NULL auto_increment,
  `USERNAME` VARCHAR(255) NOT NULL,
  `PASSWORD` VARCHAR(255) NOT NULL,
  `STATUS` VARCHAR(255) NOT NULL,
  `LAST_WHISPER` VARCHAR(255),
  PRIMARY KEY (`USERS_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `ROLES`;


CREATE TABLE `ROLES`  
(
  `ROLES_ID` INTEGER NOT NULL auto_increment,
  `ROLE_NAME` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`ROLES_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `USERS_ROLES`;


CREATE TABLE `USERS_ROLES` (
  `USERS` INTEGER REFERENCES USERS(USERS_ID),
  `ROLES` INTEGER REFERENCES ROLES(ROLES_ID),
  PRIMARY KEY (`USERS`, `ROLES`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `PRODUCT`;


CREATE TABLE `PRODUCT`
(
  `PRODUCT_ID` INTEGER NOT NULL auto_increment,
  `PRODUCT_NAME` VARCHAR(255) NOT NULL,
  `PRICE` DECIMAL(15,2),
  PRIMARY KEY (`PRODUCT_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `BILLING_ADDRESS`;


CREATE TABLE `BILLING_ADDRESS`
(
  `BILLING_ADDRESS_ID` INTEGER NOT NULL auto_increment,
  `FIRSTNAME` VARCHAR(255),
  `SURNAME` VARCHAR(255),
  `PHONE` VARCHAR(255),
  `EMAIL` VARCHAR(255),
  `STREET` VARCHAR(255),
  `ZIP` VARCHAR(255),
  `CITY` VARCHAR(255),
  `COUNTRY` VARCHAR(255),
  PRIMARY KEY (`BILLING_ADDRESS_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `PAYMENT`;


CREATE TABLE `PAYMENT`
(
  `PAYMENT_ID` INTEGER NOT NULL auto_increment,
  `RECIPE_ID` VARCHAR(256) NOT NULL,  
  `INVOICE_AMOUNT` DECIMAL(15,2),
  `BILLING_ADDRESS` INTEGER,
  `DUE_DATE` TIMESTAMP DEFAULT 0,
  `CANCELED` BOOLEAN,
  `COMPLETED` BOOLEAN,
  PRIMARY KEY (`PAYMENT_ID`),
  CONSTRAINT PAYMENT_REF_BILLING_ADDRESS FOREIGN KEY (BILLING_ADDRESS) REFERENCES BILLING_ADDRESS (BILLING_ADDRESS_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `PURCHASE`;


CREATE TABLE `PURCHASE`
(
  `PURCHASE_ID` INTEGER NOT NULL auto_increment,
  `POSITION_ID` VARCHAR(256) NOT NULL,  
  `PAYMENT` INTEGER,
  `PRODUCT` INTEGER,
  `BILLING_TIME` TIMESTAMP DEFAULT 0,
  PRIMARY KEY (`PURCHASE_ID`),
  CONSTRAINT PURCHASE_REF_PAYMENT FOREIGN KEY (PAYMENT) REFERENCES PAYMENT (PAYMENT_ID),
  CONSTRAINT PURCHASE_REF_PRODUCT FOREIGN KEY (PRODUCT) REFERENCES PRODUCT (PRODUCT_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `MEDIA_ACCOUNT`;


CREATE TABLE `MEDIA_ACCOUNT`
(
  `MEDIA_ACCOUNT_ID` INTEGER NOT NULL auto_increment,
  `BILLING_ADDRESS` INTEGER,
  PRIMARY KEY (`MEDIA_ACCOUNT_ID`),
  CONSTRAINT MEDIA_ACCOUNT_REF_BILLING_ADDRESS FOREIGN KEY (BILLING_ADDRESS) REFERENCES BILLING_ADDRESS (BILLING_ADDRESS_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `SESSION_STORE`;


CREATE TABLE `SESSION_STORE`
(
  `SESSION_STORE_ID` INTEGER NOT NULL auto_increment,
  `MEDIA_ACCOUNT` INTEGER,
  `LAST_SEEN` TIMESTAMP DEFAULT 0,
  `ACTIVE` BOOLEAN,
  `SESSION_ID` VARCHAR(36) NOT NULL,
  `TOKEN` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`SESSION_STORE_ID`),
  CONSTRAINT SESSION_STORE_REF_MEDIA_ACCOUNT FOREIGN KEY (MEDIA_ACCOUNT) REFERENCES MEDIA_ACCOUNT (MEDIA_ACCOUNT_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `VIDEO_FILE`;


CREATE TABLE `VIDEO_FILE`
(
  `VIDEO_FILE_ID` INTEGER NOT NULL auto_increment,
  `MEDIA_ACCOUNT` INTEGER,
  `RESOURCE_ID` VARCHAR(36) NOT NULL,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `WIDTH` FLOAT DEFAULT 1080,
  `HEIGHT` FLOAT DEFAULT 1080,
  `FPS` FLOAT DEFAULT 25.0,
  `BITRATE` INTEGER DEFAULT 1200000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`VIDEO_FILE_ID`),
  CONSTRAINT VIDEO_FILE_REF_MEDIA_ACCOUNT FOREIGN KEY (MEDIA_ACCOUNT) REFERENCES MEDIA_ACCOUNT (MEDIA_ACCOUNT_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `RAW_VIDEO_FILE`;


CREATE TABLE `RAW_VIDEO_FILE`
(
  `RAW_VIDEO_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `WIDTH` FLOAT DEFAULT 1080,
  `HEIGHT` FLOAT DEFAULT 1080,
  `FPS` FLOAT DEFAULT 25.0,
  `BITRATE` INTEGER DEFAULT 1200000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`RAW_VIDEO_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `RAW_AUDIO_FILE`;


CREATE TABLE `RAW_AUDIO_FILE`
(
  `RAW_AUDIO_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `CHANNELS` INTEGER DEFAULT 2,
  `SAMPLERATE` INTEGER DEFAULT 44100,
  `BITRATE` INTEGER DEFAULT 128000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`RAW_AUDIO_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `VPROC_QUEUE_CAM_UPLOAD_FILE`;


CREATE TABLE `VPROC_QUEUE_CAM_UPLOAD_FILE`
(
  `VPROC_QUEUE` INTEGER REFERENCES VPROC_QUEUE(VPROC_QUEUE_ID),
  `CAM_UPLOAD_FILE` INTEGER REFERENCES CAM_UPLOAD_FILE (CAM_UPLOAD_FILE_ID),
  PRIMARY KEY (`VPROC_QUEUE`, `CAM_UPLOAD_FILE`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `VPROC_QUEUE_SCREEN_UPLOAD_FILE`;


CREATE TABLE `VPROC_QUEUE_SCREEN_UPLOAD_FILE`
(
  `VPROC_QUEUE` INTEGER REFERENCES VPROC_QUEUE(VPROC_QUEUE_ID),
  `SCREEN_UPLOAD_FILE` INTEGER REFERENCES SCREEN_UPLOAD_FILE (SCREEN_UPLOAD_FILE_ID),
  PRIMARY KEY (`VPROC_QUEUE`, `SCREEN_UPLOAD_FILE`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `APROC_QUEUE_MIC_UPLOAD_FILE`;


CREATE TABLE `APROC_QUEUE_MIC_UPLOAD_FILE`
(
  `APROC_QUEUE` INTEGER REFERENCES APROC_QUEUE(APROC_QUEUE_ID),
  `MIC_UPLOAD_FILE` INTEGER REFERENCES MIC_UPLOAD_FILE (MIC_UPLOAD_FILE_ID),
  PRIMARY KEY (`APROC_QUEUE`, `MIC_UPLOAD_FILE`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `APROC_QUEUE_SOUNDCARD_UPLOAD_FILE`;


CREATE TABLE `APROC_QUEUE_SOUNDCARD_UPLOAD_FILE`
(
  `APROC_QUEUE` INTEGER REFERENCES APROC_QUEUE(APROC_QUEUE_ID),
  `SOUNDCARD_UPLOAD_FILE` INTEGER REFERENCES SOUNDCARD_UPLOAD_FILE (SOUNDCARD_UPLOAD_FILE_ID),
  PRIMARY KEY (`APROC_QUEUE`, `SOUNDCARD_UPLOAD_FILE`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `TITLE_STRIP_VIDEO_FILE`;


CREATE TABLE `TITLE_STRIP_VIDEO_FILE`
(
  `TITLE_STRIP_VIDEO_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `DURATION` TIME(6) NOT NULL,
  `WIDTH` FLOAT DEFAULT 1080,
  `HEIGHT` FLOAT DEFAULT 1080,
  `FPS` FLOAT DEFAULT 25.0,
  `BITRATE` INTEGER DEFAULT 1200000,
  PRIMARY KEY (`TITLE_STRIP_VIDEO_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `TITLE_STRIP_AUDIO_FILE`;


CREATE TABLE `TITLE_STRIP_AUDIO_FILE`
(
  `TITLE_STRIP_AUDIO_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `DURATION` TIME(6) NOT NULL,
  `CHANNELS` INTEGER DEFAULT 2,
  `SAMPLERATE` INTEGER DEFAULT 44100,
  `BITRATE` INTEGER DEFAULT 128000,
  PRIMARY KEY (`TITLE_STRIP_AUDIO_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `END_CREDITS_VIDEO_FILE`;


CREATE TABLE `END_CREDITS_VIDEO_FILE`
(
  `END_CREDITS_VIDEO_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `DURATION` TIME(6) NOT NULL,
  `WIDTH` FLOAT DEFAULT 1080,
  `HEIGHT` FLOAT DEFAULT 1080,
  `FPS` FLOAT DEFAULT 25.0,
  `BITRATE` INTEGER DEFAULT 1200000,
  PRIMARY KEY (`END_CREDITS_VIDEO_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `END_CREDITS_AUDIO_FILE`;


CREATE TABLE `END_CREDITS_AUDIO_FILE`
(
  `END_CREDITS_AUDIO_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `DURATION` TIME(6) NOT NULL,
  `CHANNELS` INTEGER DEFAULT 2,
  `SAMPLERATE` INTEGER DEFAULT 44100,
  `BITRATE` INTEGER DEFAULT 128000,
  PRIMARY KEY (`END_CREDITS_AUDIO_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `CAM_UPLOAD_FILE`;


CREATE TABLE `CAM_UPLOAD_FILE`
(
  `CAM_UPLOAD_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `WIDTH` FLOAT DEFAULT 1080,
  `HEIGHT` FLOAT DEFAULT 1080,
  `FPS` FLOAT DEFAULT 25.0,
  `BITRATE` INTEGER DEFAULT 1200000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`CAM_UPLOAD_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `SCREEN_UPLOAD_FILE`;


CREATE TABLE `SCREEN_UPLOAD_FILE`
(
  `SCREEN_UPLOAD_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `WIDTH` FLOAT DEFAULT 1080,
  `HEIGHT` FLOAT DEFAULT 1080,
  `FPS` FLOAT DEFAULT 25.0,
  `BITRATE` INTEGER DEFAULT 1200000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`SCREEN_UPLOAD_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `MIC_UPLOAD_FILE`;


CREATE TABLE `MIC_UPLOAD_FILE`
(
  `MIC_UPLOAD_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `CHANNELS` INTEGER DEFAULT 2,
  `SAMPLERATE` INTEGER DEFAULT 44100,
  `BITRATE` INTEGER DEFAULT 128000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`MIC_UPLOAD_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `SOUNDCARD_UPLOAD_FILE`;


CREATE TABLE `SOUNDCARD_UPLOAD_FILE`
(
  `SOUNDCARD_UPLOAD_FILE_ID` INTEGER NOT NULL auto_increment,
  `FILENAME` VARCHAR(255) NOT NULL,
  `CREATION_TIME` TIMESTAMP DEFAULT 0,
  `DURATION` TIME(6) NOT NULL,
  `CHANNELS` INTEGER DEFAULT 2,
  `SAMPLERATE` INTEGER DEFAULT 44100,
  `BITRATE` INTEGER DEFAULT 128000,
  `AVAILABLE` BOOLEAN,
  PRIMARY KEY (`SOUNDCARD_UPLOAD_FILE_ID`)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `VPROC_QUEUE`;


CREATE TABLE `VPROC_QUEUE`
(
  `VPROC_QUEUE_ID` INTEGER NOT NULL auto_increment,
  `VIDEO_FILE` INTEGER,
  `RAW_VIDEO_FILE` INTEGER,
  `TITLE_STRIP_VIDEO_FILE` INTEGER,
  `END_CREDITS_VIDEO_FILE` INTEGER,
  `STARTED` BOOLEAN,
  `COMPLETED` BOOLEAN,
  PRIMARY KEY (`VPROC_QUEUE_ID`),
  CONSTRAINT VPROC_QUEUE_REF_VIDEO_FILE FOREIGN KEY (VIDEO_FILE) REFERENCES VIDEO_FILE (VIDEO_FILE_ID),
  CONSTRAINT VPROC_QUEUE_REF_RAW_VIDEO_FILE FOREIGN KEY (RAW_VIDEO_FILE) REFERENCES RAW_VIDEO_FILE (RAW_VIDEO_FILE_ID),
  CONSTRAINT VPROC_QUEUE_REF_TITLE_STRIP_VIDEO_FILE FOREIGN KEY (TITLE_STRIP_VIDEO_FILE) REFERENCES TITLE_STRIP_VIDEO_FILE (TITLE_STRIP_VIDEO_FILE_ID),
  CONSTRAINT VPROC_QUEUE_REF_END_CREDITS_VIDEO_FILE FOREIGN KEY (END_CREDITS_VIDEO_FILE) REFERENCES END_CREDITS_VIDEO_FILE (END_CREDITS_VIDEO_FILE_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `APROC_QUEUE`;


CREATE TABLE `APROC_QUEUE`
(
  `APROC_QUEUE_ID` INTEGER NOT NULL auto_increment,
  `VIDEO_FILE` INTEGER,
  `RAW_AUDIO_FILE` INTEGER,
  `TITLE_STRIP_AUDIO_FILE` INTEGER,
  `END_CREDITS_AUDIO_FILE` INTEGER,
  `STARTED` BOOLEAN,
  `COMPLETED` BOOLEAN,
  PRIMARY KEY (`APROC_QUEUE_ID`),
  CONSTRAINT APROC_QUEUE_REF_VIDEO_FILE FOREIGN KEY (VIDEO_FILE) REFERENCES VIDEO_FILE (VIDEO_FILE_ID),
  CONSTRAINT APROC_QUEUE_REF_RAW_AUDIO_FILE FOREIGN KEY (RAW_AUDIO_FILE) REFERENCES RAW_AUDIO_FILE (RAW_AUDIO_FILE_ID),
  CONSTRAINT APROC_QUEUE_REF_TITLE_STRIP_AUDIO_FILE FOREIGN KEY (TITLE_STRIP_AUDIO_FILE) REFERENCES TITLE_STRIP_AUDIO_FILE (TITLE_STRIP_AUDIO_FILE_ID),
  CONSTRAINT APROC_QUEUE_REF_END_CREDITS_AUDIO_FILE FOREIGN KEY (END_CREDITS_AUDIO_FILE) REFERENCES END_CREDITS_AUDIO_FILE (END_CREDITS_AUDIO_FILE_ID)
)ENGINE=InnoDB DEFAULT CHARSET utf8;

#----------------------------------------------------------------------------------------

ALTER TABLE USERS_ROLES
ADD CONSTRAINT USERS_ROLES_REF_USERS
FOREIGN KEY (USERS)
REFERENCES USERS(USERS_ID);

ALTER TABLE USERS_ROLES
ADD CONSTRAINT USERS_ROLES_REF_ROLES
FOREIGN KEY (ROLES)
REFERENCES ROLES(ROLES_ID);

#----------------------------------------------------------------------------------------

ALTER TABLE VPROC_QUEUE_CAM_UPLOAD_FILE
ADD CONSTRAINT VPROC_QUEUE_CAM_UPLOAD_FILE_REF_VPROC_QUEUE
FOREIGN KEY (VPROC_QUEUE)
REFERENCES VPROC_QUEUE(VPROC_QUEUE_ID);

ALTER TABLE VPROC_QUEUE_CAM_UPLOAD_FILE
ADD CONSTRAINT VPROC_QUEUE_CAM_UPLOAD_FILE_REF_CAM_UPLOAD_FILE
FOREIGN KEY (CAM_UPLOAD_FILE)
REFERENCES CAM_UPLOAD_FILE(CAM_UPLOAD_FILE_ID);

#----------------------------------------------------------------------------------------

ALTER TABLE VPROC_QUEUE_SCREEN_UPLOAD_FILE
ADD CONSTRAINT VPROC_QUEUE_SCREEN_UPLOAD_FILE_REF_VPROC_QUEUE
FOREIGN KEY (VPROC_QUEUE)
REFERENCES VPROC_QUEUE(VPROC_QUEUE_ID);

ALTER TABLE VPROC_QUEUE_SCREEN_UPLOAD_FILE
ADD CONSTRAINT VPROC_QUEUE_SCREEN_UPLOAD_FILE_REF_SCREEN_UPLOAD_FILE
FOREIGN KEY (SCREEN_UPLOAD_FILE)
REFERENCES SCREEN_UPLOAD_FILE(SCREEN_UPLOAD_FILE_ID);

#----------------------------------------------------------------------------------------

ALTER TABLE APROC_QUEUE_MIC_UPLOAD_FILE
ADD CONSTRAINT APROC_QUEUE_MIC_UPLOAD_FILE_REF_APROC_QUEUE
FOREIGN KEY (APROC_QUEUE)
REFERENCES APROC_QUEUE(APROC_QUEUE_ID);

ALTER TABLE APROC_QUEUE_MIC_UPLOAD_FILE
ADD CONSTRAINT APROC_QUEUE_MIC_UPLOAD_FILE_REF_MIC_UPLOAD_FILE
FOREIGN KEY (MIC_UPLOAD_FILE)
REFERENCES MIC_UPLOAD_FILE(MIC_UPLOAD_FILE_ID);

#----------------------------------------------------------------------------------------

ALTER TABLE APROC_QUEUE_SOUNDCARD_UPLOAD_FILE
ADD CONSTRAINT APROC_QUEUE_SOUNDCARD_UPLOAD_FILE_REF_APROC_QUEUE
FOREIGN KEY (APROC_QUEUE)
REFERENCES APROC_QUEUE(APROC_QUEUE_ID);

ALTER TABLE APROC_QUEUE_SOUNDCARD_UPLOAD_FILE
ADD CONSTRAINT APROC_QUEUE_SOUNDCARD_UPLOAD_FILE_REF_SOUNDCARD_UPLOAD_FILE
FOREIGN KEY (SOUNDCARD_UPLOAD_FILE)
REFERENCES SOUNDCARD_UPLOAD_FILE(SOUNDCARD_UPLOAD_FILE_ID);

#----------------------------------------------------------------------------------------
