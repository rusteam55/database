-- Lesson 9. Транзакции, переменные, представления.
-- task 1. В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных.
-- Переместите запись id = 1  из таблицы shop.users в таблицу sample.users.


-- 1. Создаем БД с аналогичной таблицей.
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
USE sample;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

-- 2. Перемещение: а) вставляем запись id = 1 из shop.users в таблицу sample.users
--  б) удаляем запись id = 1 из shop.users.
USE sample;
START TRANSACTION;
INSERT INTO users SELECT * FROM shop.users WHERE id = 1; -- а)
DELETE FROM shop.users WHERE id = 1; -- б)
COMMIT;
SELECT * FROM users;

