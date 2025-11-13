CREATE INDEX idx_atributos_hstore_gin ON productos_hstore USING GIN (atributos);
RAISE NOTICE 'OK: Índice GIN creado en productos_hstore(atributos).';

CREATE OR REPLACE FUNCTION resumir_producto(p_nombre TEXT, p_atributos HSTORE)
RETURNS TEXT AS $$
DECLARE
  resumen TEXT;
  marca TEXT;
  color TEXT;
BEGIN
  marca := COALESCE(p_atributos->'marca', 'N/A');
  color := COALESCE(p_atributos->'color', 'N/A');

  resumen := 'Producto ' || p_nombre || ': marca=' || marca || ', color=' || color;
  RETURN resumen;
END;
$$ LANGUAGE plpgsql;

RAISE NOTICE 'OK: Función resumir_producto() creada.';

RAISE NOTICE '--- Probando la función resumir_producto() ---';

SELECT resumir_producto(nombre, atributos) AS resumen
FROM productos_hstore;
