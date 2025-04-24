-- --------------------------------------------------------
-- Hôte:                         192.168.50.252
-- Version du serveur:           11.5.2-MariaDB-ubu2404 - mariadb.org binary distribution
-- SE du serveur:                debian-linux-gnu
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET NAMES utf8 */
;
/*!50503 SET NAMES utf8mb4 */
;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */
;
/*!40103 SET TIME_ZONE='+00:00' */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;

-- Listage de la structure de la base pour bsa_db
CREATE DATABASE IF NOT EXISTS `bsa_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `bsa_db`;

-- Listage de la structure de table bsa_db. Agent
CREATE TABLE IF NOT EXISTS `Agent` (
    `idAgent` int(11) NOT NULL AUTO_INCREMENT,
    `nom` varchar(80) DEFAULT NULL,
    `prenom` varchar(80) NOT NULL,
    `tel` varchar(15) DEFAULT NULL,
    `login` varchar(50) NOT NULL,
    `pwd` varchar(180) NOT NULL,
    `role` ENUM(
        'Admin',
        'Utilisateur',
        'Inactif'
    ) NOT NULL DEFAULT 'Utilisateur',
    PRIMARY KEY (`idAgent`)
) ENGINE = InnoDB AUTO_INCREMENT = 11 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- Listage de la structure de table bsa_db. Tuteur
CREATE TABLE IF NOT EXISTS `Tuteur` (
    `idTuteur` int(11) NOT NULL AUTO_INCREMENT,
    `nom` varchar(80) DEFAULT NULL,
    `prenom` varchar(80) DEFAULT NULL,
    `tel` varchar(15) DEFAULT NULL,
    `informations` varchar(500) DEFAULT NULL,
    PRIMARY KEY (`idTuteur`)
) ENGINE = InnoDB AUTO_INCREMENT = 27 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- Listage de la structure de table bsa_db. Zone
CREATE TABLE IF NOT EXISTS `Zone` (
    `idZone` int(11) NOT NULL AUTO_INCREMENT,
    `type` ENUM(
        'archipel',
        'ile',
        'commune',
        'zone'
    ) NOT NULL,
    `lib` varchar(80) NOT NULL,
    `lat_1` decimal(20, 16) DEFAULT NULL,
    `long_1` decimal(20, 16) DEFAULT NULL,
    `lat_2` decimal(20, 16) DEFAULT NULL,
    `long_2` decimal(20, 16) DEFAULT NULL,
    `lat_centre` decimal(20, 16) DEFAULT NULL,
    `long_centre` decimal(20, 16) DEFAULT NULL,
    `active` BOOLEAN DEFAULT 1,
    `idParent` int(11) DEFAULT NULL,
    PRIMARY KEY (`idZone`),
    KEY `idParent` (`idParent`),
    CONSTRAINT `Zone_ibfk_1` FOREIGN KEY (`idParent`) REFERENCES `Zone` (`idZone`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 17 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- Listage de la structure de table bsa_db. Comptage
CREATE TABLE IF NOT EXISTS `Comptage` (
    `idComptage` int(11) NOT NULL AUTO_INCREMENT,
    `qtt` int(11) DEFAULT NULL,
    `date` DATETIME NOT NULL,
    `idAgent` int(11) NOT NULL,
    `idZone` int(11) NOT NULL,
    PRIMARY KEY (`idComptage`),
    KEY `idAgent` (`idAgent`),
    KEY `idZone` (`idZone`),
    CONSTRAINT `Comptage_ibfk_1` FOREIGN KEY (`idAgent`) REFERENCES `Agent` (`idAgent`),
    CONSTRAINT `Comptage_ibfk_2` FOREIGN KEY (`idZone`) REFERENCES `Zone` (`idZone`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- Listage de la structure de table bsa_db. Personne
CREATE TABLE IF NOT EXISTS `Personne` (
  `idPersonne` int(11) NOT NULL AUTO_INCREMENT,
	`residence` ENUM(
	'A la rue',
	'Famille d\'accueil - Unité de vie',
	'Hébergement associatif',
	'Autre'
	) NOT NULL DEFAULT "Autre",
  `nom` varchar(80) NOT NULL,
  `prenom` varchar(80) NOT NULL,
  `dateNaiss` date DEFAULT NULL,
  `dn` int(15) DEFAULT NULL,
  `genre` ENUM(
    'Homme',
    'Femme',
    'Autre'
    ) NOT NULL DEFAULT "Autre",
  `activite` varchar(50) DEFAULT "Aucune Activité / Au Chômage",
  `tel` varchar(15) DEFAULT "Aucun Numéro",
  `email` varchar(80) DEFAULT NULL,
  `typologie` ENUM(
    'Originaire des îles pour parcours de soins',
    'Originaire des îles pour recherche ou prise d\'emploi',
    'Originaire des îles pour poursuite d\'études',
    'Fa\'amu',
    'Recomposition familiale contraignante',
    'Troubles psychiques',
    'Personne âgée',
    'Violences intra-familiales',
    'Famille nombreuse, pressions et promiscuité',
    'Sortant de prison',
    'Eu(e) recourt à une mesure d\'assistance éducative',
    'Mineur(euse) sortant d\'établissement socio-éducatif',
    'Autre'
    ) NOT NULL DEFAULT "Autre",
  `nbEnfant` int(2) DEFAULT NULL,
  `dateCreation` date NOT NULL DEFAULT (CURRENT_DATE),
  `idTuteur` int(11) DEFAULT 1,
  `idIle` int(11) NOT NULL,
  PRIMARY KEY (`idPersonne`),
  KEY `idTuteur` (`idTuteur`),
  KEY `idIle` (`idIle`),
  CONSTRAINT `Personne_ibfk_1` FOREIGN KEY (`idTuteur`) REFERENCES `Tuteur` (`idTuteur`),
  CONSTRAINT `Personne_ibfk_2` FOREIGN KEY (`idIle`) REFERENCES `Zone` (`idZone`)
) ENGINE=InnoDB AUTO_INCREMENT=463 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage de la structure de table bsa_db. Releve
CREATE TABLE IF NOT EXISTS `Releve` (
    `idReleve` int(11) NOT NULL AUTO_INCREMENT,
    `commentaire` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `date` DATETIME NOT NULL,
    `idAgent` int(11) NOT NULL,
    `idPersonne` int(11) NOT NULL,
    PRIMARY KEY (`idReleve`),
    KEY `idAgent` (`idAgent`),
    KEY `idPersonne` (`idPersonne`),
    CONSTRAINT `Releve_ibfk_1` FOREIGN KEY (`idAgent`) REFERENCES `Agent` (`idAgent`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `Releve_ibfk_2` FOREIGN KEY (`idPersonne`) REFERENCES `Personne` (`idPersonne`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- Listage de la structure de table bsa_db. Revenu
CREATE TABLE IF NOT EXISTS `Revenu` (
    `idRevenu` int(11) NOT NULL AUTO_INCREMENT,
    `lib` varchar(80) DEFAULT NULL,
    `montant` int(7) DEFAULT NULL,
    `idPersonne` int(11) NOT NULL,
    PRIMARY KEY (`idRevenu`),
    KEY `idPersonne` (`idPersonne`),
    CONSTRAINT `Revenu_ibfk_1` FOREIGN KEY (`idPersonne`) REFERENCES `Personne` (`idPersonne`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `Token` (
    `idToken` int(11) NOT NULL AUTO_INCREMENT,
    `token` varchar(180) NOT NULL,
    `valid` DATETIME NOT NULL,
    `idAgent` int(11) NOT NULL,
    KEY `idAgent` (`idAgent`),
    PRIMARY KEY (`idToken`),
    CONSTRAINT `Token_ibfk_1` FOREIGN KEY (`idAgent`) REFERENCES `Agent` (`idAgent`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */
;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */
;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */
;

-- Création de l'utilisateur 'bsaroot' avec un mot de passe sécurisé
CREATE USER 'bsaroot' IDENTIFIED BY 'P@ssw0rd!Str0ng';

-- Attribution de tous les privilèges sur la base 'bsa_db'
GRANT ALL PRIVILEGES ON bsa_db.* TO 'bsaroot';

-- Appliquer les changements
FLUSH PRIVILEGES;