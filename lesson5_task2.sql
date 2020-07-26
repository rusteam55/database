-- Задача 2. 
-- таблица users неудачно спроектирована поля created_at и updated_at заданы типом VARCHAR 
-- и в них помещены значения в формате 20.10.2017 8:10.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '20.10.2017 8:10', '21.10.2017 8:14'),
  ('Наталья', '1984-11-12', '14.03.2018 9:35', '30.03.2018 19:40'),
  ('Александр', '1985-05-20', '03.09.2018 14:47', '13.10.2018 19:07'),
  ('Сергей', '1988-02-14', '27.05.2019 16:04', '05.06.2019 20:04'),
  ('Иван', '1998-01-12', '15.02.2017 10:24', '10.09.2017 17:34'),
  ('Мария', '1992-08-29', '07.05.2018 20:07', '09.07.2018 10:07');

 
-- Необходимо преобразовать поля к типу DATETIME, сохранив значения:
UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'), updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;

