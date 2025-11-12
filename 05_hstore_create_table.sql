DROP TABLE IF EXISTS productos_hs CASCADE;
CREATE TABLE IF NOT EXISTS productos_hs (
  id        SERIAL PRIMARY KEY,
  nombre    TEXT NOT NULL,
  precio    NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
  atributos HSTORE NOT NULL
);
