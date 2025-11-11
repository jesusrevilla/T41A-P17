-- Activar la extensión HSTORE
CREATE EXTENSION IF NOT EXISTS hstore;

-- 1.(Productos)
CREATE TABLE productos_jsonb (
    id SERIAL PRIMARY KEY,
    especificaciones JSONB
);

-- 2. Tabla para Ejercicios HSTORE (Productos)
CREATE TABLE productos_hstore (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    precio NUMERIC(10, 2), -- Para el ejercicio intermedio 2
    atributos HSTORE
);
