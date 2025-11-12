INSERT INTO productos_hstore (nombre, precio, atributos) VALUES
('Laptop', 1200.00, 'marca => Dell, color => negro, peso => 2.1kg'),
('Teléfono', 800.00, 'marca => Samsung, color => rojo, peso => 0.3kg'),
('Monitor', 450.00, 'marca => Sony, color => plata, peso => 3.5kg'),
('Teclado', 150.00, 'marca => Logitech, color => rojo, peso => 0.8kg'),
('Mouse', 70.00, 'marca => Sony, peso => 0.2kg');

RAISE NOTICE 'OK: 5 productos insertados en productos_hstore.';