INSERT INTO productos (nombre, precio, atributos)
VALUES 
  ('Laptop', 1200.00, 'marca => Dell, color => negro, ram => 16GB, peso => 2.5kg'),
  ('Teléfono', 800.00, 'marca => Samsung, color => azul, ram => 8GB, peso => 0.2kg'),
  ('Monitor', 300.00, 'marca => LG, color => rojo, resolucion => 1080p'),
  ('Teclado', 150.00, 'marca => Logitech, color => negro, tipo => mecanico'),
  ('TV', 600.00, 'marca => Sony, color => negro, resolucion => 4K');

RAISE NOTICE 'OK: 5 productos insertados en la tabla "productos".';

SELECT * FROM productos;
