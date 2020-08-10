-- Lesson 9. Хранимые процедуры и функции, триггеры.
-- task 2. В таблице products есть два текстовых поля: name и description.
-- Допустимо присутствие обоих полей или одного из них.
-- Ситуация, когда оба поля принимают значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы оба поля или одно были заполнены.
-- При попытке присвоить значение NULL - отменить операцию.

DELIMITER //
USE shop//
DROP TRIGGER IF EXISTS check_completing//
CREATE TRIGGER check_completing BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name and Description are NULL. INSERT canceled';
	END IF;
END
//

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 4500.00, 3); -- Trigger

INSERT INTO products (price, catalog_id)
VALUES (4500.00, 3); -- Trigger

INSERT INTO products (name, description, price, catalog_id)
VALUES ('Intel Core i7-9700', NULL, 27000.00, 1); -- Ok

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, 'Материнская плата ASUS ROG STRIX Z490-E GAMING', 25060.00, 2); -- Ok
 