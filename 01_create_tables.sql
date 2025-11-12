CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);


CREATE TABLE IF NOT EXISTS productos_jsonb (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  especificaciones JSONB
);

CREATE TABLE IF NOT EXISTS productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10, 2),
  atributos HSTORE
);

