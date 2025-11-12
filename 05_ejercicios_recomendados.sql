CREATE IF NOT EXISTS TABLE productos_jsonb (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  especificaciones JSONB
);

INSERT INTO productos_jsonb (nombre, especificaciones) VALUES
('Laptop', '{"marca": "Dell", "color": "plata", "ram": 16, "categoria": "electronica"}'),
('Teclado', '{"marca": "Logitech", "color": "negro", "tipo": "mecanico", "categoria": "accesorios"}'),
('Monitor', '{"marca": "Samsung", "tamaño": 27, "resolucion": "4K", "categoria": "electronica"}'),
('Mouse', '{"marca": "Logitech", "color": "blanco", "dpi": 1600, "categoria": "accesorios"}'),
('Silla Gamer', '{"marca": "Corsair", "color": "rojo", "material": "cuero", "categoria": "muebles"}');

SELECT * FROM productos_jsonb WHERE especificaciones ->> 'color' = 'plata';
SELECT * FROM productos_jsonb WHERE (especificaciones ->> 'tamaño')::int = 27;
SELECT * FROM productos_jsonb WHERE especificaciones ->> 'categoria' = 'accesorios';

CREATE INDEX idx_gin_especificaciones ON productos_jsonb USING GIN (especificaciones);

EXPLAIN ANALYZE SELECT * FROM productos_jsonb WHERE especificaciones @> '{"marca": "Logitech"}';
