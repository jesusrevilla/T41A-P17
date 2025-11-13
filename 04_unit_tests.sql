DO $$
BEGIN
  -- Usuarios del README
  IF EXISTS (SELECT 1 FROM usuarios WHERE id = 1 AND data->>'nombre' = 'Ana') THEN
    RAISE NOTICE 'OK: nombre correcto para id 1 (usuarios)';
  ELSE
    RAISE EXCEPTION 'Fallo: nombre incorrecto para id 1 (usuarios)';
  END IF;

  IF EXISTS (SELECT 1 FROM usuarios WHERE id = 1 AND data->>'activo' = 'true') THEN
    RAISE NOTICE 'OK: usuario activo para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: usuario id 1 no activo';
  END IF;

  IF EXISTS (SELECT 1 FROM usuarios WHERE id = 2 AND data->>'edad' = '25') THEN
    RAISE NOTICE 'OK: edad correcta para id 2';
  ELSE
    RAISE EXCEPTION 'Fallo: edad incorrecta para id 2';
  END IF;

  -- Productos JSONB
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_name='productos' AND column_name='especificaciones' AND data_type='jsonb'
  ) THEN
    RAISE NOTICE 'OK: columna especificaciones (jsonb) existe en productos';
  ELSE
    RAISE EXCEPTION 'Fallo: falta columna especificaciones jsonb en productos';
  END IF;

  IF EXISTS (SELECT 1 FROM productos WHERE especificaciones @> '{"color":"negro"}') THEN
    RAISE NOTICE 'OK: hay productos color negro';
  ELSE
    RAISE EXCEPTION 'Fallo: no hay productos color negro';
  END IF;

  IF EXISTS (SELECT 1 FROM productos WHERE especificaciones->>'tamano' = '27') THEN
    RAISE NOTICE 'OK: hay productos tamano 27';
  ELSE
    RAISE EXCEPTION 'Fallo: no hay productos tamano 27';
  END IF;

  IF EXISTS (SELECT 1 FROM productos WHERE especificaciones @> '{"categoria":"computo"}') THEN
    RAISE NOTICE 'OK: hay productos de computo';
  ELSE
    RAISE EXCEPTION 'Fallo: no hay productos de computo';
  END IF;
END;
$$;
