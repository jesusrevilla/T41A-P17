CREATE EXTENSION IF NOT EXISTS hstore;

CREATE INDEX IF NOT EXISTS idx_gin_atributos ON productos_hstore USING GIN (atributos);

SELECT atributos -> 'marca' AS marca, count(*)
FROM productos_hstore
WHERE atributos ? 'marca'
GROUP BY marca;

SELECT nombre, hstore_to_jsonb(atributos) FROM productos_hstore LIMIT 1;
SELECT jsonb_to_hstore('{"marca": "Test", "ram": "8"}'::jsonb);

SELECT * FROM productos_hstore WHERE atributos ?& ARRAY['color', 'peso'];

CREATE OR REPLACE FUNCTION resumir_producto(attrs HSTORE)
RETURNS TEXT AS $$
BEGIN
  RETURN 'Producto: marca=' || (attrs -> 'marca') || ', color=' || (attrs -> 'color');
END;
$$ LANGUAGE plpgsql;

SELECT nombre, resumir_producto(atributos)
FROM productos_hstore
WHERE atributos ?& ARRAY['marca', 'color'];
