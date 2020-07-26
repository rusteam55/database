-- Агрегация. Задача 2.
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
  ('Сергей', '1988-02-13'),
  ('Иван', '1998-01-12'),
  ('Антон', '1993-12-07'),
  ('Мария', '1992-08-29');
  
 -- Подсчитать количество ДР, которые приходятся на каждый из дней недели в текущем году.
 
SELECT name, birthday_at, DAYNAME(CONCAT(YEAR (NOW()), '-', SUBSTRING(birthday_at, 6, 10))) as weekday_of_bithday FROM users;

SELECT 
	DAYNAME(CONCAT(YEAR (NOW()), '-', SUBSTRING(birthday_at, 6, 10))) as weekday_of_birthday,
	COUNT(DAYNAME(CONCAT(YEAR (NOW()), '-', SUBSTRING(birthday_at, 6, 10)))) as weekdays
FROM users
GROUP BY weekday_of_birthday;
 