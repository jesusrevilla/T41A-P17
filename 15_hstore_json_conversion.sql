-- HSTORE -> JSON
SELECT id, nombre, hstore_to_json(atributos) AS atributos_json
FROM productos_hs;

-- JSON -> HSTORE (ejemplo práctico)
WITH datos AS (
  SELECT '{"marca":"TestBrand","color":"verde","peso":"1kg"}'::json AS j
)
SELECT hstore(datos.j) AS atributos_desde_json
FROM datos;
