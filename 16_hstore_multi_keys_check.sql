-- Productos que tienen simultáneamente 'color' y 'peso'
SELECT id, nombre
FROM productos_hs
WHERE atributos ?& ARRAY['color', 'peso'];
