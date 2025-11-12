-- CONFIGURACIÓN INICIAL (Necesaria)
CREATE EXTENSION IF NOT EXISTS hstore;

-- Recrear la tabla y datos para la prueba, si no existen
DROP TABLE IF EXISTS productos_hstore CASCADE;

CREATE TABLE productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  precio NUMERIC(10, 2) DEFAULT 0.00,
  atributos HSTORE
);

INSERT INTO productos_hstore (nombre, precio, atributos)
VALUES 
  ('Laptop Gamer', 1200.00, 'marca => Dell, color => negro, categoria => Electronica'),
  ('Smartphone Pro', 850.50, 'marca => Samsung, color => azul, categoria => Electronica'),
  ('Monitor Ultrawide', 350.00, 'marca => Sony, color => plata, peso => 5.0kg, resolucion => 4K'),
  ('Teclado Mecánico', 90.00, 'marca => Logitech, tipo_tecla => blue'),
  ('Disco Duro', 80.00, 'marca => Seagate, peso => 0.5kg');

--- EJERCICIOS AVANZADOS ---

-- 1. Indexar la columna HSTORE con GIN 
CREATE INDEX IF NOT EXISTS idx_productos_hstore_gin ON productos_hstore USING GIN (atributos);

-- 2. Usar funciones agregadas con HSTORE (Agrupa productos por 'marca' y cuenta cuántos hay por cada una)
SELECT 
  atributos -> 'marca' AS marca, 
  COUNT(*) AS cantidad_productos
FROM productos_hstore
GROUP BY 1
ORDER BY 2 DESC;

-- 3. Convertir HSTORE a JSON y viceversa 
SELECT 
  nombre, 
  hstore_to_json(atributos) AS atributos_json
FROM productos_hstore
WHERE nombre = 'Monitor Ultrawide';

-- 4. Validar existencia de múltiples claves (Usa ?& para verificar si un producto tiene 'color' y 'peso')
SELECT nombre
FROM productos_hstore
WHERE atributos ?& ARRAY['color', 'peso'];

-- 5. Crear una función que reciba un HSTORE y devuelva un resumen
CREATE OR REPLACE FUNCTION resumen_hstore(p_nombre TEXT, p_atributos HSTORE)
RETURNS TEXT AS $$
BEGIN
  RETURN p_nombre || ': marca=' || COALESCE(p_atributos -> 'marca', 'N/A') || ', peso=' || COALESCE(p_atributos -> 'peso', 'N/A');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Uso de la función
SELECT 
  resumen_hstore(nombre, atributos) AS resumen
FROM productos_hstore;
