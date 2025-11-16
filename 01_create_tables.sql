CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  especificaciones JSONB
);

CREATE TABLE productos1 (
  id SERIAL PRIMARY KEY,
  atributos HSTORE
);
