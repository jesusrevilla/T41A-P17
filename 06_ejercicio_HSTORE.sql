CREATE EXTENSION IF NOT EXISTS hstore;
-- 1. Crear una tabla con columna HSTORE
CREATE TABLE productos_hstore (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    atributos HSTORE
);

-- 2. Insertar registros con múltiples pares clave-valor
INSERT INTO productos_hstore (nombre, atributos) VALUES
('Ferrari de Juguete', 
 'marca => "HotWheels", color => "rojo", peso => "50g", material => "metal"'),

('Teclado Mecánico', 
 'marca => "Logitech", color => "negro", switch => "cherry mx red", idioma => "español"'),

('Manzana', 
 'tipo => "fruta", color => "rojo", peso => "200g", origen => "local"'),

('Monitor Gaming', 
 'marca => "Samsung", resolucion => "4K", tasa_refresco => "144Hz", peso => "5kg"'),

('Silla de Oficina', 
 'marca => "Herman Miller", color => "gris", peso => "15kg", material => "malla"');
 
 -- 3. Consultar por una clave específica
SELECT id, nombre, atributos
FROM productos_hstore
WHERE atributos -> 'color' = 'rojo';

-- 4. Actualizar un valor dentro del HSTORE
UPDATE productos_hstore
SET atributos = atributos || '"peso"=>"4.5kg"'
WHERE nombre = 'Monitor Gaming';

-- Verificamos el cambio
SELECT nombre, atributos -> 'peso' as nuevo_peso 
FROM productos_hstore 
WHERE nombre = 'Monitor Gaming';

-- 5. Eliminar una clave de un registro
UPDATE productos_hstore
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teclado Mecánico';

-- Verificamos que la clave 'color' ya no exista
SELECT nombre, atributos 
FROM productos_hstore 
WHERE nombre = 'Teclado Mecánico';
