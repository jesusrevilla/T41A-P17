-- 3. Consultar por una clave específica
RAISE NOTICE '--- Basico 3: Productos de color "rojo"';
SELECT * FROM productos WHERE atributos -> 'color' = 'rojo';


-- 4. Actualizar un valor dentro del HSTORE
UPDATE productos
SET atributos = atributos || 'peso => 2.2kg'::hstore
WHERE nombre = 'Laptop';
RAISE NOTICE 'OK - Basico 4: Peso de "Laptop" actualizado a 2.2kg.';


-- 5. Eliminar una clave de un registro
UPDATE productos
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teclado';
RAISE NOTICE 'OK - Basico 5: Atributo "color" eliminado de "Teclado".';
