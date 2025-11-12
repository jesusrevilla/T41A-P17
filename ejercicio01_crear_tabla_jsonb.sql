CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE productos_jsonb (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    especificaciones JSONB NOT NULL
);


