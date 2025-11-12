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
