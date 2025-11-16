SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

SELECT data->>'Color' AS color, data->>'Tamaño' AS tamaño, data->>'Categoría' AS categoría
FROM productos;
CREATE INDEX idx_productos_gin ON productos USING GIN (data);
