-- 1. Inserts para productos_jsonb
INSERT INTO productos_jsonb (especificaciones) VALUES
('{"nombre": "Laptop", "categoria": "electronica", "color": "plata", "tamaño": "15in"}'),
('{"nombre": "Teclado", "categoria": "accesorios", "color": "negro", "layout": "es"}'),
('{"nombre": "Monitor", "categoria": "electronica", "color": "negro", "tamaño": "27in"}'),
('{"nombre": "Camisa", "categoria": "ropa", "color": "rojo", "tamaño": "M"}'),
('{"nombre": "Mouse", "categoria": "accesorios", "color": "blanco", "dpi": 1600}'),
('{"nombre": "Zapatos", "categoria": "ropa", "color": "rojo", "tamaño": "10"}');

-- 2. Inserts para productos_hstore 
INSERT INTO productos_hstore (nombre, precio, atributos) VALUES
('Laptop', 1200, 'marca => "Sony", color => "plata", peso => "2.1kg"'),
('Teléfono', 800, 'marca => "Samsung", color => "negro", ram => "12GB"'),
('Monitor', 450, 'marca => "LG", color => "negro", resolucion => "4K"'),
('Teclado', 150, 'marca => "Logitech", color => "rojo", tipo => "mecanico"'),
('Mouse', 80, 'marca => "Sony", color => "blanco", dpi => "3200"'),
('Camisa', 50, 'color => "rojo", talla => "M"'); 
