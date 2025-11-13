-- marca = 'Sony' y precio > 500
SELECT id, nombre, precio
FROM productos_hs
WHERE atributos -> 'marca' = 'Sony'
  AND precio > 500
ORDER BY precio DESC;
