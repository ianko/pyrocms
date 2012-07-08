DROP TABLE IF EXISTS `core_users`;
DROP TABLE IF EXISTS `core_settings`;
DROP TABLE IF EXISTS `core_sites`;
  
CREATE TABLE core_settings (
  `slug` varchar( 30 ) NOT NULL ,
  `default` text NOT NULL,
  `value` text NULL,
  PRIMARY KEY ( `slug` ) ,
  UNIQUE ( `slug` )
);

INSERT INTO `core_settings` (`slug`, `default`) VALUES 
  ('date_format', 'g:ia -- m/d/y'),
  ('lang_direction', 'ltr'),
  ('status_message', 'This site has been disabled by a super-administrator.');

CREATE TABLE `core_sites` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `ref` VARCHAR(20) NOT NULL,
  `domain` VARCHAR(100),
  `active` TINYINT(1) NOT NULL default '1',
  `created_on` INTEGER NOT NULL default '0',
  `updated_on` INTEGER null,
  UNIQUE (`ref`),
  UNIQUE (`domain`)
);

DROP TABLE IF EXISTS `{site_ref}_users`;

CREATE TABLE IF NOT EXISTS `{site_ref}_users` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `email` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `salt` varchar(6) NOT NULL DEFAULT '',
  `group_id` INTEGER DEFAULT NULL,
  `ip_address` varchar(16) DEFAULT NULL,
  `active` int(1) DEFAULT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `created_on` INTEGER NOT NULL,
  `last_login` INTEGER NOT NULL,
  `username` varchar(20) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  UNIQUE (`email`),
  UNIQUE ('username')
);

INSERT INTO `{site_ref}_users` (`id`, `email`, `password`, `salt`, `group_id`, `ip_address`, `active`, `activation_code`, `created_on`, `last_login`, `username`) 
VALUES (1, :email, :password, :salt, 1, '', 1, '', :unix_now, :unix_now, :username);
  
CREATE TABLE IF NOT EXISTS `core_users` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `email` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `salt` varchar(6) NOT NULL DEFAULT '',
  `group_id` INTEGER DEFAULT NULL,
  `ip_address` varchar(16) DEFAULT NULL,
  `active` int(1) DEFAULT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `created_on` INTEGER NOT NULL,
  `last_login` INTEGER NOT NULL,
  `username` varchar(20) DEFAULT NULL,
  `forgotten_password_code` varchar(40) DEFAULT NULL,
  `remember_code` varchar(40) DEFAULT NULL,
  UNIQUE (`email`)
);

INSERT INTO core_users SELECT * FROM {site_ref}_users;

DROP TABLE IF EXISTS `{site_ref}_profiles`;

CREATE TABLE IF NOT EXISTS `{site_ref}_profiles` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` INTEGER unsigned NOT NULL,
  `display_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `company` varchar(100) DEFAULT NULL,
  `lang` varchar(2) NOT NULL DEFAULT 'en',
  `bio` text,
  `dob` INTEGER DEFAULT NULL,
  `gender` CHAR(1) NOT NULL DEFAULT ('m'),
  `phone` varchar(20) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `address_line3` varchar(255) DEFAULT NULL,
  `postcode` varchar(20) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `updated_on` INTEGER unsigned DEFAULT NULL,
  UNIQUE (`user_id`)
);

INSERT INTO `{site_ref}_profiles` (`id`, `user_id`, `first_name`, `last_name`, `display_name`, `company`, `lang`)
VALUES (1, 1, :firstname, :lastname, :displayname, '', 'en');

CREATE TABLE IF NOT EXISTS {site_ref}_migrations (
  `version` INTEGER DEFAULT NULL
);

INSERT INTO {site_ref}_migrations VALUES (:migration);

CREATE TABLE `{site_ref}_modules` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `slug` varchar(50) NOT NULL,
  `version` varchar(20) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `skip_xss` tinyint(1) NOT NULL,
  `is_frontend` tinyint(1) NOT NULL,
  `is_backend` tinyint(1) NOT NULL,
  `menu` varchar(20) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `installed` tinyint(1) NOT NULL,
  `is_core` tinyint(1) NOT NULL,
  `updated_on` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE (`slug`)
);

CREATE TABLE `{session_table}` (
 `session_id` varchar(40) DEFAULT '0' NOT NULL,
 `ip_address` varchar(16) DEFAULT '0' NOT NULL,
 `user_agent` varchar(120) NOT NULL,
 `last_activity` int(10) unsigned DEFAULT 0 NOT NULL,
 `user_data` text NULL,
  PRIMARY KEY (`session_id`)
);
