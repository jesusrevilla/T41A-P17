CREATE EXTENSION IF NOT EXISTS hstore;
DROP TABLE IF EXISTS productos;

-- 1. Tabla con columna HSTORE
CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  precio NUMERIC(10, 2), 
  atributos HSTORE
);

RAISE NOTICE 'OK: Tabla "productos" creada.';
