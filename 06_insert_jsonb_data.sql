INSERT INTO productos_json (nombre, especificaciones) VALUES
('Laptop', '{"marca": "Dell", "color": "negro", "ram_gb": 16, "categoria": "electronica"}'),
('Mouse', '{"marca": "Logitech", "color": "negro", "inalambrico": true, "categoria": "accesorios"}'),
('Teclado', '{"marca": "Keychron", "color": "gris", "mecanico": true, "categoria": "accesorios"}'),
('Monitor', '{"marca": "Samsung", "color": "blanco", "tamano_pulgadas": 27, "categoria": "electronica"}'),
('Silla', '{"marca": "Herman Miller", "color": "negro", "ergonomica": true, "categoria": "mobiliario"}');

RAISE NOTICE 'OK: 5 productos insertados en productos_json.';
