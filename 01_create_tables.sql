CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE productos_jsonb (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    especificaciones JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS productos_hstore (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    atributos HSTORE
);

-- Crear índice GIN si es necesario
CREATE INDEX IF NOT EXISTS idx_productos_hstore_atributos ON productos_hstore USING GIN (atributos);

CREATE INDEX IF NOT EXISTS idx_productos_jsonb_especificaciones ON productos_jsonb USING GIN (especificaciones);
