--Задача 5.
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

-- из Таблицы catalogs извлекаются заданные записи. Отсортировать в заданном порядке.

 SELECT * FROM catalogs WHERE id IN(5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);

 