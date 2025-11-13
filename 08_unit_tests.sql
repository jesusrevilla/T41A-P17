-- Pruebas unitarias para HSTORE
RAISE NOTICE '--- Ejecutando Pruebas Unitarias (HSTORE)...';
DO $$
BEGIN
  -- Prueba 1: Verificar inserción (Laptop marca Dell)
  IF EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Laptop' AND atributos -> 'marca' = 'Dell'
  ) THEN
    RAISE NOTICE 'OK: (Prueba 1) Laptop es marca Dell.';
  ELSE
    RAISE EXCEPTION 'FALLO: (Prueba 1) Marca incorrecta para Laptop.';
  END IF;

  -- Prueba 2: Verificar inserción (Monitor color rojo)
  IF EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Monitor' AND atributos -> 'color' = 'rojo'
  ) THEN
    RAISE NOTICE 'OK: (Prueba 2) Monitor es color rojo.';
  ELSE
    RAISE EXCEPTION 'FALLO: (Prueba 2) Color incorrecto para Monitor.';
  END IF;

  -- Prueba 3: Verificar la actualización de 'Laptop'
  IF EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Laptop' AND atributos -> 'peso' = '2.2kg'
  ) THEN
    RAISE NOTICE 'OK: (Prueba 3) Peso de Laptop actualizado a 2.2kg.';
  ELSE
    RAISE NOTICE 'ADVERTENCIA: (Prueba 3) El peso de Laptop no es 2.2kg (¿Ejecutaste 07_query_hstore.sql?)';
  END IF;

  -- Prueba 4: Verificar la eliminación de clave
  IF NOT EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Teclado' AND atributos ? 'color'
  ) THEN
    RAISE NOTICE 'OK: (Prueba 4) El color fue eliminado de Teclado.';
  ELSE
    RAISE NOTICE 'ADVERTENCIA: (Prueba 4) El color aun existe en Teclado (¿Ejecutaste 07_query_hstore.sql?)';
  END IF;
END;
$$;
