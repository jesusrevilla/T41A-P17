SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

SELECT especificaciones->>'color' AS color, especificaciones->>'Tamaño' AS tamaño, especificaciones->>'Categoría' AS categoría
FROM productos;
CREATE INDEX idx_productos_gin ON productos USING GIN (especificaciones);

SELECT *
FROM productos1
WHERE atributos -> 'color' = 'rojo';

UPDATE productos1
SET atributos = atributos || 'peso => 10kg'
WHERE id = 1;

UPDATE productos1
SET atributos = delete(atributos, 'color')
WHERE id = 2;
--------------------------------------------------------------------
--1
SELECT *
FROM productos1
WHERE atributos ? 'marca';

--2
SELECT *
FROM productos1
WHERE atributos->'marca' = 'Sony'
AND id = 3;

--3
SELECT id, skeys(atributos) AS clave, svals(atributos) AS valor
FROM productos1;

--4
SELECT COUNT(*)
FROM productos1
WHERE atributos ? 'color';

--1
CREATE INDEX idx_productos1_gin
ON productos1
USING GIN (atributos);

--2
SELECT atributos->'marca' AS marca,
COUNT(*) AS total_productos
FROM productos1
GROUP BY atributos->'marca';

--3
SELECT id, json_to_hstore(especificaciones)
FROM productos;

SELECT id, hstore_to_json(especificaciones)
FROM productos;

--4
SELECT *
FROM productos1
WHERE atributos ?& ARRAY['color', 'peso'];

--5
CREATE OR REPLACE FUNCTION resumen_producto(attrs HSTORE)
RETURNS TEXT AS $$
BEGIN
    RETURN 
        'Producto: marca=' || COALESCE(attrs->'marca', 'N/A') ||
        ', color=' || COALESCE(attrs->'color', 'N/A') ||
        ', peso=' || COALESCE(attrs->'peso', 'N/A');
END;
$$ LANGUAGE plpgsql;

SELECT id, resumen_producto(atributos)
FROM productos1;
