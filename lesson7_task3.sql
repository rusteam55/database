-- Lesson 7 task 3
-- Имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to, label содержат английские наименования городов, поле name - русское.
-- Вывести список рейсов flights с русским наименованием городов.

DROP DATABASE IF EXISTS flights;
CREATE DATABASE flights;
USE DATABASE flights;


DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
	label VARCHAR(100) PRIMARY KEY,
	name VARCHAR(255)
	);

INSERT INTO cities VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
	id SERIAL PRIMARY KEY,
	from_city VARCHAR(100) NOT NULL,
	to_city VARCHAR(100) NOT NULL,
	FOREIGN KEY(from_city) REFERENCES cities(label),
	FOREIGN KEY(to_city) REFERENCES cities(label)
	);

INSERT INTO flights VALUES
  (NULL, 'moscow', 'omsk'),
  (NULL, 'novgorod', 'kazan'),
  (NULL, 'irkutsk', 'moscow'),
  (NULL, 'omsk', 'irkutsk'),
  (NULL, 'moscow', 'kazan');
  
 
 -- Вывести список рейсов flights с русским наименованием городов.
SELECT 
	id as 'Номер рейса',
	(select name from cities where label = from_city) as 'Откуда',
	(select name from cities where label = to_city) as 'Куда'
FROM 
	flights
ORDER BY
	id;
 
 
 
 
 
 
