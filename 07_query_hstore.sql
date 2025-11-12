-- 1. Consultar por una clave específica, encuentra todos los productos cuyo atributo color sea "rojo".
SELECT 
    nombre, 
    atributos -> 'color' AS color 
FROM 
    productos_hstore 
WHERE 
    atributos -> 'color' = 'rojo';

-- 2. Actualizar un valor dentro del HSTORE, cambia el valor de peso para un producto específico, que seria la silla gamer.
UPDATE productos_hstore
SET atributos = atributos || 'peso => 30kg' -- Uso del operador || para concatenar/actualizar
WHERE nombre = 'Silla Gamer';

-- Verificar la actualización
SELECT 
    nombre, 
    atributos -> 'peso' AS nuevo_peso 
FROM 
    productos_hstore 
WHERE 
    nombre = 'Silla Gamer';


-- 3. Eliminar una clave de un registro, Ejercicio 5: Eliminar el color de 'Teléfono X2', elimina el atributo 'color' de un producto.
UPDATE productos_hstore
SET atributos = delete(atributos, 'color') -- Uso de la función delete()
WHERE nombre = 'Teléfono X2';

-- Verificar la eliminación (debe devolver NULL)
SELECT 
    nombre, 
    atributos -> 'color' AS color_eliminado,
    atributos -- Mostrar todos los atributos restantes
FROM 
    productos_hstore 
WHERE 
    nombre = 'Teléfono X2';
