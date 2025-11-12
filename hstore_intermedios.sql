-- CONFIGURACIÓN INICIAL (Necesaria)
CREATE EXTENSION IF NOT EXISTS hstore;

DROP TABLE IF EXISTS productos_hstore CASCADE;

CREATE TABLE productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  precio NUMERIC(10, 2) DEFAULT 0.00,
  atributos HSTORE
);

INSERT INTO productos_hstore (nombre, precio, atributos)
VALUES 
  ('Silla Ergonómica', 250.00, 'marca => HermanMiller, color => rojo, peso => 25kg, material => malla'),
  ('Mesa de Oficina', 350.50, 'marca => IKEA, color => blanco, peso => 50kg, ensamblaje => requerido'),
  ('Lámpara LED', 45.99, 'marca => Philips, color => negro, tipo => escritorio'),
  ('Estantería', 150.00, 'marca => IKEA, color => blanco, alto => 180cm, material => madera'),
  ('Archivero Metálico', 90.00, 'marca => Generic, color => gris, peso => 15kg, cerradura => si');

--- EJERCICIOS INTERMEDIOS ---

-- 1. Filtrar registros que contienen una clave (Usa el operador ? para encontrar productos que tengan el atributo 'material')
SELECT nombre
FROM productos_hstore
WHERE atributos ? 'material';

-- 2. Combinar HSTORE con otras columnas (Consulta productos que tengan marca = 'IKEA' y precio > 100)
SELECT nombre, precio, atributos -> 'marca' AS marca
FROM productos_hstore
WHERE (atributos -> 'marca') = 'IKEA' AND precio > 100.00;

-- 3. Extraer todas las claves y valores (Usa skeys() y svals() para listar todos los atributos de cada producto)
SELECT 
  nombre, 
  skeys(atributos) AS claves, 
  svals(atributos) AS valores
FROM productos_hstore;

-- 4. Contar cuántos productos tienen un atributo específico (¿Cuántos productos tienen el atributo 'peso'?)
SELECT COUNT(*) AS total_con_peso
FROM productos_hstore
WHERE atributos ? 'peso';
