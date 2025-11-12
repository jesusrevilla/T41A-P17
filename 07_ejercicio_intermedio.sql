ALTER TABLE productos_hstore ADD COLUMN precio NUMERIC(10, 2);

UPDATE productos_hstore SET precio = 15.50 WHERE nombre = 'Ferrari de Juguete';
UPDATE productos_hstore SET precio = 150.00 WHERE nombre = 'Teclado Mecánico';
UPDATE productos_hstore SET precio = 0.50 WHERE nombre = 'Manzana';
UPDATE productos_hstore SET precio = 499.99 WHERE nombre = 'Monitor Gaming';
UPDATE productos_hstore SET precio = 800.00 WHERE nombre = 'Silla de Oficina';

INSERT INTO productos_hstore (nombre, precio, atributos) VALUES
('Televisor Bravia', 650.00, 'marca => "Sony", color => "negro", resolucion => "4K"');

-- 1. Filtrar registros que contienen una clave
SELECT id, nombre, atributos
FROM productos_hstore
WHERE atributos ? 'marca';

-- 2. Combinar HSTORE con otras columnas
SELECT id, nombre, precio, atributos
FROM productos_hstore
WHERE 
    (atributos -> 'marca' = 'Sony')
    AND 
    (precio > 500);

-- 3. Extraer todas las claves y valores
SELECT 
    nombre,
    skeys(atributos) AS todas_las_claves,
    svals(atributos) AS todos_los_valores
FROM productos_hstore;

-- 4. Contar cuántos productos tienen un atributo específico
SELECT COUNT(*) AS total_con_color
FROM productos_hstore
WHERE atributos ? 'color';
