INSERT INTO productos_jsonb (nombre, especificaciones) VALUES
('Laptop', '{"color": "gris", "tamaño": "15 pulgadas", "categoria": "Electrónica"}'),
('Celular', '{"color": "negro", "tamaño": "6 pulgadas", "categoria": "Electrónica"}'),
('Camiseta', '{"color": "rojo", "tamaño": "M", "categoria": "Ropa"}'),
('Mesa', '{"color": "marrón", "tamaño": "1.5m", "categoria": "Muebles"}'),
('Auriculares', '{"color": "blanco", "categoria": "Accesorios"}');


INSERT INTO productos_hstore (nombre, atributos) 
VALUES 
('Celular', 'color => "rojo", peso => "150"'),
('Mesa', 'color => "azul", peso => "300"');
