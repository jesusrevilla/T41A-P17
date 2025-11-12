SELECT id, nombre, precio
FROM productos_hs
WHERE atributos -> 'color' = 'rojo'
ORDER BY precio;
