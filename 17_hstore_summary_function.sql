CREATE OR REPLACE FUNCTION fn_resumen_hstore(p_nombre TEXT, p_atributos HSTORE)
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT format(
    'Producto %s: marca=%s, color=%s',
    p_nombre,
    COALESCE(p_atributos->'marca','?'),
    COALESCE(p_atributos->'color','?')
  );
$$;

CREATE OR REPLACE FUNCTION fn_resumen_producto_hs(p_id INT)
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT fn_resumen_hstore(nombre, atributos)
  FROM productos_hs
  WHERE id = p_id;
$$;

-- Ejemplo de uso:
-- SELECT fn_resumen_producto_hs(1);
