CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

-- Productos con especificaciones en JSONB (JSONB declarado al crear la tabla)
CREATE TABLE IF NOT EXISTS productos (
  id               SERIAL PRIMARY KEY,
  nombre           TEXT NOT NULL,
  precio           NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
  activo           BOOLEAN NOT NULL DEFAULT TRUE,
  especificaciones JSONB NOT NULL DEFAULT '{}'::jsonb,  -- <-- JSONB aquí
  created_at       TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Auditoría de productos
CREATE TABLE IF NOT EXISTS auditoria_productos (
  id             SERIAL PRIMARY KEY,
  producto_id    INT NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
  accion         TEXT NOT NULL,          -- 'INSERT'|'UPDATE'|'DELETE'
  campo          TEXT,                   -- campo afectado (precio, nombre, etc.)
  valor_anterior TEXT,
  valor_nuevo    TEXT,
  realizado_en   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Mantener updated_at en productos
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS productos_set_updated_at ON productos;
CREATE TRIGGER productos_set_updated_at
BEFORE UPDATE ON productos
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
