-- 13_hstore_index_gin.sql
CREATE INDEX IF NOT EXISTS productos_hs_atributos_gin
ON productos_hs USING GIN (atributos);

-- Usar predicados index-friendly:
--   @>  (contains)  y  ? (key existence)
-- Esto permite que el GIN se utilice en el plan.

EXPLAIN (ANALYZE, BUFFERS)
SELECT id
FROM productos_hs
WHERE atributos @> 'color=>"rojo"'::hstore;