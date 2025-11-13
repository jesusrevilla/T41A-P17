CREATE TABLE productos_json (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  especificaciones JSONB
);

RAISE NOTICE 'OK: Tabla productos_json (JSONB) creada.';
