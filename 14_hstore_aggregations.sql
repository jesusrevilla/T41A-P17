-- Conteo por marca
SELECT atributos -> 'marca' AS marca, COUNT(*) AS total
FROM productos_hs
GROUP BY atributos -> 'marca'
ORDER BY total DESC;
