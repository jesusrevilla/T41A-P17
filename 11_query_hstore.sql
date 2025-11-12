RAISE NOTICE '--- HSTORE Básico: Consultar por color = rojo ---';
SELECT nombre, atributos->'marca' AS marca
FROM productos_hstore
WHERE atributos -> 'color' = 'rojo';

RAISE NOTICE '--- HSTORE Básico: Actualizar peso de Laptop ---';
UPDATE productos_hstore
SET atributos = atributos || 'peso => 2.2kg'::hstore
WHERE nombre = 'Laptop';
SELECT * FROM productos_hstore WHERE nombre = 'Laptop';

RAISE NOTICE '--- HSTORE Básico: Eliminar color de Teléfono ---';
UPDATE productos_hstore
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teléfono';
SELECT * FROM productos_hstore WHERE nombre = 'Teléfono';

RAISE NOTICE '--- HSTORE Intermedio: Filtrar productos que SÍ tienen color (operador ?) ---';
SELECT nombre, atributos->'color' AS color
FROM productos_hstore
WHERE atributos ? 'color';

RAISE NOTICE '--- HSTORE Intermedio: Combinar HSTORE (marca=Sony) y columna (precio>100) ---';
SELECT nombre, precio, atributos
FROM productos_hstore
WHERE (atributos -> 'marca' = 'Sony') AND (precio > 100);

RAISE NOTICE '--- HSTORE Intermedio: Extraer claves (skeys) y valores (svals) ---';
SELECT nombre, skeys(atributos) AS claves, svals(atributos) AS valores
FROM productos_hstore;

RAISE NOTICE '--- HSTORE Avanzado: Agrupar por marca ---';
SELECT
  atributos->'marca' AS marca,
  COUNT(*) AS total_productos
FROM productos_hstore
WHERE atributos ? 'marca'
GROUP BY atributos->'marca'
ORDER BY total_productos DESC;

RAISE NOTICE '--- HSTORE Avanzado: HSTORE a JSONB ---';
SELECT nombre, hstore_to_jsonb(atributos) AS especificaciones_jsonb
FROM productos_hstore
WHERE nombre = 'Laptop';

RAISE NOTICE '--- HSTORE Avanzado: Validar múltiples claves (color Y peso) (operador ?&) ---';
SELECT nombre, atributos
FROM productos_hstore
WHERE atributos ?& ARRAY['color', 'peso'];