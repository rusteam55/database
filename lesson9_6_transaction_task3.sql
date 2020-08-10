-- Lesson 9. Транзакции, переменные, представления.
-- task 3. Имеется таблица с календарным полем created_at. В ней размещены
-- записи за август 2018года: 2018-08-01, 2018-08-04, 2018-08-16, 2018-08-17.
-- Вывести полный список дат за август, выставляя в соседнем поле 1, если
-- дата присутствует, 0 - если дата отсутствует.

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
('2018-08-17');

-- 2. Создаем таблицу со всеми датами августа (с помощью CTE)
WITH RECURSIVE cte as 
	(
	select '2018-08-01' as startdt
	UNION
	select DATE_ADD(cte.startdt, INTERVAL 1 DAY) 
	FROM 
		cte 
	WHERE
		DATE_ADD(cte.startdt, INTERVAL 1 DAY) <= '2018-08-31'
	)

-- 3. С помощью Join сопоставляем данные двух таблиц (CTE и schedule) 
SELECT 
	cte.startdt,
	(CASE WHEN schedule.created_at IS NULL THEN '0' ELSE '1' END) -- присваиваем значение 0, если совпадения отсутствуют
FROM 
	cte
LEFT JOIN
	schedule
ON 
	cte.startdt = schedule.created_at
;
