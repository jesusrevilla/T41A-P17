CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  precio NUMERIC(10, 2),
  atributos HSTORE
);

RAISE NOTICE 'OK: Extensión HSTORE activada y tabla productos_hstore creada.';