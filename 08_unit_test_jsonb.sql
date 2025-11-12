DO $$
BEGIN
  RAISE NOTICE 'Iniciando pruebas unitarias JSONB...';

  IF NOT EXISTS (
    SELECT 1 FROM productos_json
    WHERE nombre = 'Laptop' AND especificaciones @> '{"color": "negro", "marca": "Dell"}'
  ) THEN
    RAISE EXCEPTION 'Fallo: La Laptop Dell no se encontró o no es negra.';
  ELSE
    RAISE NOTICE 'OK: Laptop Dell encontrada.';
  END IF;

  IF (SELECT COUNT(*) FROM productos_json WHERE especificaciones->>'categoria' = 'accesorios') <> 2 THEN
    RAISE EXCEPTION 'Fallo: El conteo de accesorios no es 2.';
  ELSE
    RAISE NOTICE 'OK: Conteo de accesorios es 2.';
  END IF;

  RAISE NOTICE 'Pruebas JSONB pasaron.';
END;
$$;
