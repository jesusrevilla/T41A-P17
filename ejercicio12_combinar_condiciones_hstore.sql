ALTER TABLE productos_hstore ADD COLUMN precio NUMERIC;


UPDATE productos_hstore SET precio = 1200 WHERE nombre = 'Laptop';
UPDATE productos_hstore SET precio = 700 WHERE nombre = 'Celular';
UPDATE productos_hstore SET precio = 30 WHERE nombre = 'Camiseta';
UPDATE productos_hstore SET precio = 250 WHERE nombre = 'Mesa';
UPDATE productos_hstore SET precio = 600 WHERE nombre = 'Auriculares';


SELECT nombre, atributos, precio
FROM productos_hstore
WHERE atributos -> 'marca' = 'Sony' AND precio > 500;
