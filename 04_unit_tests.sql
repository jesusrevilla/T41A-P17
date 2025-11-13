DO $$
BEGIN
  RAISE NOTICE 'Iniciando pruebas unitarias SQL...';

  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 1 AND data->>'nombre' = 'Ana'
  ) THEN
    RAISE NOTICE 'OK: Usuario Ana encontrado.';
  ELSE
    RAISE EXCEPTION 'Fallo: Usuario Ana no encontrado.';
  END IF;

  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 2 AND data->>'edad' = '25'
  ) THEN
    RAISE NOTICE 'OK: Edad correcta para Juan.';
  ELSE
    RAISE EXCEPTION 'Fallo: edad incorrecta para id 2';
  END IF;

  RAISE NOTICE 'Todas las pruebas SQL pasaron.';
END;
$$;
