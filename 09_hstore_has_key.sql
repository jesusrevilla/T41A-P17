-- Productos que tienen la clave "marca"
SELECT id, nombre
FROM productos_hs
WHERE atributos ? 'marca';
