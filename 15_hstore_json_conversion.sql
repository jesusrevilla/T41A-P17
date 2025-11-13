-- HSTORE -> JSON
SELECT id, nombre, hstore_to_json(atributos) AS atributos_json
FROM productos_hs;

-- JSON -> HSTORE (portable en PG14)
-- Construimos el hstore a partir de las parejas (key,value) del JSON:
--   json_each_text() -> agrega pares a arrays -> hstore(text[], text[])
WITH datos AS (
  SELECT '{"marca":"TestBrand","color":"verde","peso":"1kg"}'::json AS j
),
pares AS (
  SELECT key, value FROM json_each_text((SELECT j FROM datos))
)
SELECT hstore(array_agg(key), array_agg(value)) AS atributos_desde_json
FROM pares;