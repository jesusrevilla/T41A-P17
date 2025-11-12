CREATE TABLE productos_hstore (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10, 2),
  atributos HSTORE
);

INSERT INTO productos_hstore (nombre, precio, atributos) VALUES
('Laptop', 1200.00, 'marca=>"Dell", color=>"plata", peso=>"2.1kg"'),
('Teclado', 150.00, 'marca=>"Logitech", color=>"negro", tipo=>"mecanico"'),
('Monitor', 600.00, 'marca=>"Sony", color=>"negro", resolucion=>"4K"'),
('Mouse', 80.00, 'marca=>"Logitech", color=>"rojo", dpi=>"1600"'),
('Silla', 300.00, 'marca=>"Ikea", color=>"azul", material=>"tela"');

SELECT * FROM productos_hstore WHERE atributos -> 'color' = 'rojo';

UPDATE productos_hstore
SET atributos = atributos || 'peso=>"1.9kg"'::hstore
WHERE nombre = 'Laptop';

UPDATE productos_hstore
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Silla';
