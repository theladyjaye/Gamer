/*
 Navicat Premium Data Transfer

 Source Server         : Local
 Source Server Type    : MySQL
 Source Server Version : 50153
 Source Host           : localhost
 Source Database       : gamer

 Target Server Type    : MySQL
 Target Server Version : 50153
 File Encoding         : utf-8

 Date: 12/12/2010 20:40:50 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` char(64) NOT NULL,
  `token` char(32) NOT NULL,
  `active` int(1) NOT NULL,
  `created_on` char(24) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_index` (`email`),
  UNIQUE KEY `username_index` (`username`),
  UNIQUE KEY `email+username_index` (`username`,`email`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `user`
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', 'aventurella', 'aventurella@gmail.com', 'a87d1e4fc0b9b73f3913a431ded62c5a5807d3fb4e6c979c6938936b17640b55', 'c8d503934fd020c2d702919b89cdf381', '1', '2010-12-06T05:16:05+0000'), ('2', 'system', 'system@gamepop.com', '', 'a35dec05633be98c00ebc27a46f54365', '1', '2010-12-06T05:16:05+0000');
COMMIT;

-- ----------------------------
--  Table structure for `user_alias`
-- ----------------------------
DROP TABLE IF EXISTS `user_alias`;
CREATE TABLE `user_alias` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `platform` varchar(24) NOT NULL,
  `alias` varchar(75) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `alias_platform_index` (`platform`,`alias`),
  UNIQUE KEY `alias_index` (`user_id`,`platform`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `user_alias`
-- ----------------------------
BEGIN;
INSERT INTO `user_alias` VALUES ('1', '1', 'xbox360', 'logix812'), ('2', '1', 'battlenet', '99CandlesOfPainOnTheWall'), ('4', '1', 'playstation3', 'LogixB0mb'), ('6', '1', 'playstation2', 'logix9');
COMMIT;

-- ----------------------------
--  Table structure for `user_verification`
-- ----------------------------
DROP TABLE IF EXISTS `user_verification`;
CREATE TABLE `user_verification` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` char(32) NOT NULL,
  `created_on` char(24) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_index` (`token`),
  UNIQUE KEY `user_index` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS = 1;
