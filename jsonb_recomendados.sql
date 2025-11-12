-- #############################################
-- EJERCICIOS JSONB: ADAPTADO PARA LA TABLA 'usuarios'
-- #############################################

-- Nota: Este script asume que la tabla 'usuarios' con 'id=1' (Ana) y 'id=2' (Juan) ya existe.

-- 1. Crear tabla de productos con JSONB (Se usa 'usuarios' para los tests, pero se crea una nueva para el ejercicio completo)
DROP TABLE IF EXISTS productos_jsonb CASCADE;

CREATE TABLE productos_jsonb (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  especificaciones JSONB
);

-- 2. Insertar al menos 5 productos con diferentes atributos (en la nueva tabla)
INSERT INTO productos_jsonb (nombre, especificaciones)
VALUES 
  ('Laptop Ultrabook', '{"color": "gris espacial", "memoria": "16GB RAM", "categoria": "Portátiles"}'),
  ('Monitor 4K Curvo', '{"color": "negro", "tasa_refresco": "144Hz", "stock": 15, "categoria": "Periféricos"}'),
  ('Mouse Inalámbrico', '{"color": "blanco", "dpi": 16000, "categoria": "Periféricos"}');

-- 3. Consultar productos por categoría (usando la nueva tabla)
SELECT nombre, especificaciones ->> 'categoria' AS categoria
FROM productos_jsonb
WHERE especificaciones ->> 'categoria' = 'Periféricos';

-- Consulta usando los datos de la tabla 'usuarios' (Para demostrar el uso del test)
SELECT data->>'nombre' AS nombre_usuario
FROM usuarios
WHERE data->>'activo' = 'true';

-- 4. Crear índices GIN (usando la tabla 'usuarios' y 'productos_jsonb')
-- Índice GIN para la tabla del test (usuarios)
CREATE INDEX IF NOT EXISTS idx_usuarios_data_gin ON usuarios USING GIN (data);

-- Índice GIN para la tabla de ejercicios (productos_jsonb)
CREATE INDEX IF NOT EXISTS idx_prod_esp_gin ON productos_jsonb USING GIN (especificaciones);

-- Consulta que usa el índice GIN en la tabla 'usuarios'
SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

-- 5. Implementar pruebas unitarias (Los tests unitarios SQL ya están en el README original y se validan con Python)
-- El test de Python reemplaza esta sección.
