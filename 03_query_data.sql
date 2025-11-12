SELECT nombre, especificaciones
FROM productos_jsonb
WHERE especificaciones ->> 'color' = 'rojo'
   OR especificaciones ->> 'tamaño' = '6 pulgadas'
   OR especificaciones ->> 'categoria' = 'Ropa';
