-- 1. Insertar registros con múltiples pares clave-valor
INSERT INTO productos_hstore (nombre, precio, atributos)
VALUES
    ('Silla Gamer', 180.00, 'marca => Razer, color => negro, peso => 25kg, categoria => Muebles'),
    ('Teléfono X2', 650.00, 'marca => Nexus, color => azul, ram => 8GB, almacenamiento => 128GB'),
    ('Bocina Compacta', 45.50, 'marca => JBL, color => rojo, resistente_agua => si, potencia => 10W'),
    ('Mochila Ejecutiva', 75.00, 'color => gris, material => nylon, laptop_size => 15.6, tipo => Accesorios'),
    ('Adaptador USB-C', 15.00, 'color => negro, puertos => 4, marca => generico, peso => 0.1kg');
