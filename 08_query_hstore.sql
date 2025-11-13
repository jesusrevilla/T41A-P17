-- Consultar por color
SELECT nombre FROM productos WHERE atributos -> 'color' = 'negro';

-- Actualizar un valor
UPDATE productos
SET atributos = atributos || 'ram => 32GB'
WHERE nombre = 'Laptop';

-- Eliminar una clave
UPDATE productos
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teléfono';

-- Ver todas las claves y valores
SELECT skeys(atributos) AS clave, svals(atributos) AS valor FROM productos;
