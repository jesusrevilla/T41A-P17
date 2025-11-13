INSERT INTO usuarios (data)
VALUES 
  ('{"nombre": "Ana", "activo": true, "edad": 30}'),
  ('{"nombre": "Juan", "activo": false, "edad": 25}'),
  ('{"nombre": "Jhon", "activo": true, "edad": 20}'),
  ('{"nombre": "Sarah", "activo": false, "edad": 21}'),
  ('{"nombre": "Steve", "activo": false, "edad": 24}');

INSERT INTO productos_u (atributos)
VALUES 
  ('{"nombre": "Laptop", "categoria": "Dell", "tamaño ": "Pequeño"}'),
  ('{"nombre": "Teléfono", "categoria": "Samsung", "tamaño ": "Grande"}'),
  ('{"nombre": "Celular", "categoria": "Samsung", "tamaño ": "Medio"}'),
  ('{"nombre": "Control", "categoria": "LG", "tamaño ": "Grande"}'),
  ('{"nombre": "Mouse", "categoria": "Apple", "tamaño ": "Medio"}');

INSERT INTO productos (nombre, atributos)
VALUES 
  ('Jamón', 'marca => Fud, color => rosa, peso => 0.5kg'),
  ('Manzana', 'marca => Villa, color => rojo, peso => 1Kg'),
  ('Jugo', 'marca => Jumex, color => azul, peso => 0.5kg'),
  ('Tomate', 'marca => Costeña, color => rojo, peso => 0.7Kg'),
  ('Refresco', 'marca => Escuis, color => amarillo, peso => 0.6Kg');
