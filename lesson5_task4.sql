-- Задача 4.

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
  
 -- Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
 
 SELECT 
 	name, 
 	birthday_at,
 	CASE
 		WHEN DATE_FORMAT(birthday_at, '%m') = 05 THEN 'May'
 		WHEN DATE_FORMAT(birthday_at, '%m') = 08 THEN 'August'
 	END AS birthmonth
 FROM users
 WHERE DATE_FORMAT(birthday_at, '%m') = 05 OR DATE_FORMAT(birthday_at, '%m') = 08;
 