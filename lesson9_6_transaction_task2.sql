-- Lesson 9. Транзакции, переменные, представления.
-- task 2. Создать представление, которое выводит название товара name из таблицы products
-- и название каталога name из таблицы catalogs.

USE shop;
CREATE OR REPLACE VIEW nameprod (product, `catalog`)
AS SELECT name, (SELECT name FROM catalogs WHERE id = catalog_id) FROM products;
SELECT * FROM nameprod;