-- Activar la extensión HSTORE
CREATE EXTENSION IF NOT EXISTS hstore;

-- Crear tabla productos si no existe
DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  atributos HSTORE
);

-- Insertar datos
INSERT INTO productos (nombre, atributos)
VALUES
  ('Laptop', 'marca => "Dell", color => "negro", ram => "16GB"'),
  ('Teléfono', 'marca => "Samsung", color => "azul", ram => "8GB"');

-- Actualizar la RAM de la Laptop
UPDATE productos
SET atributos = atributos || 'ram => "32GB"'
WHERE nombre = 'Laptop';
