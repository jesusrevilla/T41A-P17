CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);


CREATE IF NOT EXISTS TABLE productos_jsonb (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  especificaciones JSONB
);
