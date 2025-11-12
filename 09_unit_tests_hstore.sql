DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Laptop' AND atributos -> 'marca' = 'Dell'
  ) THEN
    RAISE NOTICE 'OK: marca correcta para Laptop';
  ELSE
    RAISE EXCEPTION 'Fallo: marca incorrecta para Laptop';
  END IF;

  IF EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Teléfono' AND atributos -> 'color' = 'azul'
  ) THEN
    RAISE NOTICE 'OK: color correcto para Teléfono';
  ELSE
    RAISE EXCEPTION 'Fallo: color incorrecto para Teléfono';
  END IF;
END;
$$;
