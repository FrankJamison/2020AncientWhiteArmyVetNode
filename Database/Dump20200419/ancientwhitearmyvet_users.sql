-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: ancientwhitearmyvet
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET NAMES utf8mb4 */;

DROP TABLE IF EXISTS users;

CREATE TABLE users
(
  user_id int NOT NULL
  AUTO_INCREMENT,
  username varchar
  (255) NOT NULL,
  email varchar
  (255) NOT NULL,
  password varchar
  (255) NOT NULL,
  PRIMARY KEY
  (user_id),
  UNIQUE KEY username
  (username)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

  INSERT INTO users
  VALUES
    (1, 'admin', 'admin@example.com', '$2a$10$vlfyiVQ31mK6ez2TWxAwgO.p3jbQbAjdXMzlxBoJXiMLazGxAvk06'),
    (2, 'admin2', 'admin2@example.com', '$2a$10$Y71EWwKY4HpxI3g3gF3lXeZVfflEnqgdC4rCo5RsGStETiGnKM3Ti'),
    (3, 'admin3', 'admin3@example.com', '$2a$10$q/Kw7TlxvGV6xNDX3s5JYuwnf0qM9p8nSwGBEnW19Ri7BHUuT.HiW');

-- Dump completed on 2020-04-19 19:12:28
