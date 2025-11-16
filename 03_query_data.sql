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
