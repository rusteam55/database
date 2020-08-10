-- Lesson 9. Транзакции, переменные, представления.
-- task 4. Имеется таблица с календарным полем created_at. 
-- Создать запрос, который удаляет устаревшие записи, оставляя только  самых свежих.

-- 1. Создаем таблицу с календарным полем created_at и размещаем в ней заданные даты.
USE shop;
DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule(
created_at DATE
);

INSERT INTO schedule VALUES
('2018-08-01'),
('2018-08-04'),
('2018-08-16'),
('2019-01-01'),
('2019-02-02'),
('2019-03-10'),
('2019-08-16'),
('2020-01-03'),
('2020-04-14'),
('2020-07-16'),
('2020-08-10');

-- 1. Выводим 5 свежих записей
SELECT * FROM schedule ORDER BY created_at DESC LIMIT 5;

-- 2. Выводим все оставшиеся записи за исключением 5 свежих.
SELECT created_at 
FROM schedule 
WHERE created_at NOT IN
	(
	SELECT *
	FROM (
		SELECT * 
		FROM schedule 
		ORDER BY created_at 
		DESC LIMIT 5
		) as tbl
	);

-- 3. Удаляем все оставшиеся записи за исключением 5 свежих.
DELETE  
FROM schedule 
WHERE created_at NOT IN
	(
	SELECT *
	FROM (
		SELECT * 
		FROM schedule 
		ORDER BY created_at 
		DESC LIMIT 5
		) as tbl
	);

-- 4. В таблице осталось 5 последних записей.
SELECT * FROM schedule ORDER BY created_at






