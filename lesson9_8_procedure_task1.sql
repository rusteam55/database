-- Lesson 9. Хранимые процедуры и функции, триггеры.
-- task 1. Создать функцию hello(), которая будет возвращать приветствие в зависимости от текущего времени суток.
-- С 6 до 12 "Доброе утро", с 12 до 18 - "Добрый день", с 18 до 00 - "Добрый вечер", с 00 до 6 - "Доброй ночи".

DELIMITER //

DROP PROCEDURE IF EXISTS hello//
CREATE PROCEDURE hello()
BEGIN
	IF(CURTIME() BETWEEN '06:00:00' AND '11:59:59') THEN 
	SELECT 'Доброе утро';
	ELSEIF(CURTIME() BETWEEN '12:00:00' AND '17:59:59') THEN 
	SELECT 'Добрый день';
	ELSEIF(CURTIME() BETWEEN '18:00:00' AND '23:59:59') THEN 
	SELECT 'Добрый вечер';
	ELSE 
	SELECT 'Доброй ночи';
	END IF;
END
//

CALL hello();

