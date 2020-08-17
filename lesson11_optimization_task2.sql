-- Lesson 11.
-- task 2. Создать запрос помещающий в таблицу users миллион записей.

-- Создадим клон таблицы users
USE shop;
DROP TABLE IF EXISTS users_2;
CREATE TABLE users_2(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя покупателя',
  	birthday_at DATE COMMENT 'Дата рождения',
  	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  
 -- Созданим процедуру вставки записей
DROP PROCEDURE IF EXISTS insert_million;
DELIMITER //
CREATE PROCEDURE insert_million()
BEGIN
	DECLARE max_str INT DEFAULT 10000; -- возьмем 10 тыс. записей вместо 1 млн.
	DECLARE min_str INT DEFAULT 0;
	WHILE max_str > 0 DO
		INSERT INTO users_2(name, birthday_at)
		VALUES (CONCAT('user#', min_str), NOW() - INTERVAL min_str DAY);
		SET min_str = min_str + 1;
		SET max_str = max_str -1;
	END WHILE;
END //
DELIMITER ;

-- Запускаем процедуру
CALL insert_million();

-- Проверяем заполнение
SELECT * FROM users_2 LIMIT 127;




 
 