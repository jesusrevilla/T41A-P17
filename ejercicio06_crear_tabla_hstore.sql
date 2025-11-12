CREATE EXTENSION IF NOT EXISTS hstore;


CREATE TABLE productos_hstore (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    atributos HSTORE
);
