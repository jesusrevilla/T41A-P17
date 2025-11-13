CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

CREATE TABLE productos_u (
  id SERIAL PRIMARY KEY,
  atributos JSONB
);
CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  atributos HSTORE
);
