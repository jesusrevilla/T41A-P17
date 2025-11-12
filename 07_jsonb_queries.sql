-- Ejercicio J-3: Consultar por color 'rojo'
SELECT * FROM productos_jsonb WHERE especificaciones->>'color' = 'rojo';

-- Ejercicio J-3: Consultar por categoria 'electronica'
SELECT * FROM productos_jsonb WHERE especificaciones->>'categoria' = 'electronica';

-- Ejercicio J-3: Consultar por tamaño '15in'
SELECT * FROM productos_jsonb WHERE especificaciones->>'tamaño' = '15in';

-- Ejercicio J-4: Crear índice GIN
CREATE INDEX idx_jsonb_especificaciones ON productos_jsonb USING GIN (especificaciones);

-- Medir rendimiento
EXPLAIN ANALYZE SELECT * FROM productos_jsonb WHERE especificaciones @> '{"color": "rojo"}';
