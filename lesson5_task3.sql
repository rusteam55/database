-- Задача 3.
-- В поле value встречаются разные цифры: 0, если товар закончился, больше 0, если товар имеется на складе.


DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products
  (storehouse_id, product_id, value)
VALUES
  (1, 1, 500),
  (1, 2, 100),
  (1, 3, 0),
  (1, 4, 1500),
  (1, 5, 500),
  (1, 6, 0),
  (1, 7, 10),
  (2, 1, 0),
  (2, 2, 10),
  (2, 3, 0),
  (2, 4, 15),
  (2, 5, 50),
  (2, 6, 0),
  (2, 7, 100),
  (3, 1, 10),
  (3, 2, 20),
  (3, 3, 10),
  (3, 4, 10),
  (3, 5, 30),
  (3, 6, 0),
  (3, 7, 1);
 
 
 -- Небходимо отсортировать записи по возрастанию, но нулевые запасы выводятся в конце.
 
 SELECT * FROM storehouses_products ORDER BY IF(value = 0, 1, 0), value;

 
  