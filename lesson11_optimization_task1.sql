-- Lesson 11.
-- task 1. Создать таблицу logs типа Archive. ПУсть при каждом создании записи в таблицах
-- users, catalogs, products в таблицу logs помещается время и дата создания записи,
-- название таблицы, идентификатор первичного ключа и поле name.

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	tablename VARCHAR(100) NOT NULL,
	pk_id BIGINT(15) NOT NULL,
	name VARCHAR(100) NOT NULL
) ENGINE = ARCHIVE;

-- Этапы решения:
-- создаем триггеры событий внесения записей в users, catalogs, products
-- 1. FOR users
DROP TRIGGER IF EXISTS log_for_users;
DELIMITER //
CREATE TRIGGER log_for_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (created_at, tablename, pk_id, name)
	VALUES(NOW(), 'users', NEW.id, NEW.name);
END//
DELIMITER ;

-- 2. FOR catalogs
DROP TRIGGER IF EXISTS log_for_catalogs;
DELIMITER //
CREATE TRIGGER log_for_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (created_at, tablename, pk_id, name)
	VALUES(NOW(), 'catalogs', NEW.id, NEW.name);
END//
DELIMITER ;

-- 3. FOR products
DROP TRIGGER IF EXISTS log_for_products;
DELIMITER //
CREATE TRIGGER log_for_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (created_at, tablename, pk_id, name)
	VALUES(NOW(), 'products', NEW.id, NEW.name);
END//
DELIMITER ;

-- Проверка:

INSERT INTO users (name, birthday_at) VALUES
  ('Michel', '1980-12-05'),
  ('Mary', '1983-10-10');

INSERT INTO catalogs VALUES
  (NULL, 'Мониторы'),
  (NULL, 'Клавиатуры');

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Xiaomi Mi Display 23.8', 'Монитор Xiaomi', 7890.00, 6),
  ('Logitech Corded Keyboard K280', 'Клавиатура Logitech', 800.00, 7);
 
SELECT * FROM users;
SELECT * FROM catalogs;
SELECT * FROM products;

SELECT * FROM logs;









