CREATE INDEX IF NOT EXISTS productos_hs_atributos_gin
ON productos_hs USING GIN (atributos);

-- Ver plan (debe mencionar el índice)
EXPLAIN (ANALYZE, BUFFERS)
SELECT id FROM productos_hs WHERE atributos -> 'color' = 'rojo';
