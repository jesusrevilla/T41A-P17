-- 1. Activar la extensión HSTORE
CREATE EXTENSION IF NOT EXISTS hstore;

-- 2. Crear una tabla 'productos' con columna HSTORE
CREATE TABLE productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  precio NUMERIC,
  atributos HSTORE
);
