CREATE TABLE productos_jsonb (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  especificaciones JSONB,
  precio DECIMAL(10,2),
  categoria TEXT
);
