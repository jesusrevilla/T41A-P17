-- #############################################
-- EJERCICIOS HSTORE: USANDO TABLA SEPARADA
-- #############################################

-- 1. Activar la extensión HSTORE
CREATE EXTENSION IF NOT EXISTS hstore;

-- 2. Crear una tabla de HSTORE separada (para no interferir con la tabla 'usuarios' del test)
DROP TABLE IF EXISTS productos_hstore CASCADE;

CREATE TABLE productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  precio NUMERIC(10, 2) DEFAULT 0.00,
  atributos HSTORE
);

-- 3. Insertar datos de HSTORE (usando la nueva tabla)
INSERT INTO productos_hstore (nombre, precio, atributos)
VALUES 
  ('Silla Ergonómica', 250.00, 'marca => HermanMiller, color => rojo, peso => 25kg, material => malla'),
  ('Mesa de Oficina', 350.50, 'marca => IKEA, color => blanco, peso => 50kg, ensamblaje => requerido');

--- EJERCICIOS BÁSICOS ---

-- Consultar por una clave específica
SELECT nombre, atributos -> 'color' AS color
FROM productos_hstore
WHERE atributos -> 'color' = 'rojo';

-- Actualizar un valor dentro del HSTORE
UPDATE productos_hstore
SET atributos = atributos || 'peso => 20kg'
WHERE nombre = 'Silla Ergonómica';

--- EJERCICIOS INTERMEDIOS ---

-- Filtrar registros que contienen una clave
SELECT nombre
FROM productos_hstore
WHERE atributos ? 'material';

-- Combinar HSTORE con otras columnas
SELECT nombre, precio
FROM productos_hstore
WHERE (atributos -> 'marca') = 'IKEA' AND precio > 100.00;

--- EJERCICIOS AVANZADOS ---

-- Indexar la columna HSTORE con GIN
CREATE INDEX IF NOT EXISTS idx_productos_hstore_gin ON productos_hstore USING GIN (atributos);

-- Validar existencia de múltiples claves
SELECT nombre
FROM productos_hstore
WHERE atributos ?& ARRAY['color', 'peso'];
