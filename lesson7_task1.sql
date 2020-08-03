-- Lesson 7 task 1
-- Составить список пользователей users, 
-- которые осуществили хотя бы один заказ orders в интернет-магазине

USE shop;

-- Заполним таблицы:

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
 
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

INSERT INTO orders VALUES
(1, 1, '2020-08-03 12:30:51', '2020-08-03 13:10:09'),
(2, 1, '2020-08-03 12:31:51', '2020-08-03 13:10:09'),
(3, 2, '2020-08-03 12:32:51', '2020-08-03 13:10:09'),
(4, 2, '2020-08-03 12:33:51', '2020-08-03 13:10:09'),
(5, 4, '2020-08-03 12:34:51', '2020-08-03 12:34:51'),
(6, 4, '2020-08-03 12:34:51', '2020-08-03 12:34:51'),
(7, 4, '2020-08-03 12:34:51', '2020-08-03 12:34:51'),
(8, 4, '2020-08-03 12:35:51', '2020-08-03 12:35:51'),
(9, 6, '2020-08-03 12:40:51', '2020-08-03 12:40:51');


-- Составить список пользователей users, 
-- которые осуществили хотя бы один заказ orders в интернет-магазине

SELECT u.id as user_id, name, o.id as order_id
FROM 
	users u
RIGHT JOIN 
	orders o 
ON 
	u.id = o.user_id;


