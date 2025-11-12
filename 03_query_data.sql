SELECT id, data->>'nombre' AS nombre, data->>'edad' AS edad
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT id, data
FROM usuarios
WHERE data @> '{"activo": true}';
