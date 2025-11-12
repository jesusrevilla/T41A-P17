RAISE NOTICE '--- Consultando productos JSONB por color negro ---';
SELECT nombre, especificaciones->>'marca' AS marca
FROM productos_json
WHERE especificaciones->>'color' = 'negro';

RAISE NOTICE '--- Consultando productos JSONB por categoría (operador @>) ---';
SELECT nombre
FROM productos_json
WHERE especificaciones @> '{"categoria": "accesorios"}';

CREATE INDEX idx_especificaciones_gin ON productos_json USING GIN (especificaciones);

RAISE NOTICE 'OK: Índice GIN creado en productos_json(especificaciones).';