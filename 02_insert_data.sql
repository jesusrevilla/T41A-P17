INSERT INTO usuarios (data)
VALUES 
  ('{"nombre": "Ana", "activo": true, "edad": 30}'),
  ('{"nombre": "Juan", "activo": false, "edad": 25}');

INSERT INTO productos (nombre, precio, activo, especificaciones) VALUES
  ('Laptop Pro 15',      1000.00, TRUE, '{"categoria":"computo","color":"gris","tamano":"15","marca":"Dell","ram":"16GB"}'),
  ('Smartphone X',        300.00, TRUE, '{"categoria":"telefonia","color":"negro","tamano":"6.5","marca":"Samsung","almacen":"128GB"}'),
  ('Monitor 27"',         220.00, TRUE, '{"categoria":"computo","color":"negro","tamano":"27","resolucion":"1440p"}'),
  ('Audifonos Air',        99.00, TRUE, '{"categoria":"audio","color":"blanco","tipo":"over-ear"}'),
  ('Teclado Mecanico',     75.00, TRUE, '{"categoria":"accesorios","color":"negro","tamano":"TKL","switches":"rojos"}');
