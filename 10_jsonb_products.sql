-- 1. Crear la tabla de productos con especificaciones en JSONB
DROP TABLE IF EXISTS productos_jsonb;

CREATE TABLE productos_jsonb (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  precio NUMERIC,
  especificaciones JSONB
);

-- 2. Insertar al menos 5 productos con diferentes atributos
INSERT INTO productos_jsonb (nombre, precio, especificaciones)
VALUES 
  ('Silla Ejecutiva', 250.00, '{"color": "negro", "tamano": "grande", "material": ["cuero", "metal"], "categoria": "Muebles"}'),
  ('Lámpara de Escritorio', 55.99, '{"color": "blanco", "tamano": "mediano", "bombilla": "LED", "categoria": "Iluminacion"}'),
  ('Mouse Pad XXL', 19.99, '{"color": "rojo", "tamano": "extragrande", "material": ["tela", "goma"], "categoria": "Accesorios"}'),
  ('Disco SSD 1TB', 89.90, '{"color": "gris", "categoria": "Componentes", "lectura": 550, "escritura": 520}'),
  ('Cámara Web 4K', 120.00, '{"color": "negro", "categoria": "Perifericos", "resolucion": "4K", "autofocus": true}');

-- 3. Crear índices GIN para búsquedas eficientes (Ejercicio JSONB 4)
CREATE INDEX idx_productos_specs_gin ON productos_jsonb USING GIN (especificaciones);
