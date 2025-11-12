SELECT id, data->>'nombre' AS nombre, data->>'edad' AS edad
FROM usuarios
WHERE data->>'activo' = 'true';

SELECT id, data
FROM usuarios
WHERE data @> '{"activo": true}';