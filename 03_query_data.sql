SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

CREATE INDEX IF NOT EXISTS idx_usuarios_data_gin
  ON usuarios USING GIN (data);

CREATE INDEX IF NOT EXISTS productos_especificaciones_gin
  ON productos USING GIN (especificaciones);

-- Usuarios activos usando @>
SELECT * FROM usuarios WHERE data @> '{"activo": true}';

-- Productos por color (usa GIN con @>)
SELECT id, nombre FROM productos
WHERE especificaciones @> '{"color":"negro"}';

-- Por tamaño exacto (->> como texto)
SELECT id, nombre FROM productos
WHERE especificaciones->>'tamano' = '27';

-- Por categoría (usa GIN con @>)
SELECT id, nombre FROM productos
WHERE especificaciones @> '{"categoria":"computo"}';

-- Combinada
SELECT id, nombre FROM productos
WHERE especificaciones @> '{"color":"negro","categoria":"computo"}';

-- Ver plan y uso de índice
EXPLAIN (ANALYZE, BUFFERS)
SELECT id FROM productos WHERE especificaciones @> '{"color":"negro"}';

