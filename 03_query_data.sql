SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

--Ejercicios básicos HSTORE
SELECT nombre
FROM productos
WHERE atributos -> 'color' = 'rojo';

UPDATE productos
SET atributos = atributos || 'peso => 0.8Kg'
WHERE nombre = 'Manzana';

UPDATE productos
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Tomate';

--Ejercicios intermedios 
CREATE INDEX idx_data_gin ON productos USING GIN (atributos);
SELECT * FROM productos
WHERE atributos ? 'marca';
https://onecompiler.com/postgresql/444agpzfh
https://onecompiler.com/postgresql/444ahdbyb
CREATE TABLE productos_u (
  id SERIAL PRIMARY KEY,
  atributos JSONB
);

INSERT INTO productos_u (atributos)
VALUES 
  ('{"nombre": "Laptop", "categoría": Dell, "tamaño ": Pequeño}'),
  ('{"nombre": "Teléfono", "categoría": Samsung, "tamaño ": Grande}'),
  ('{"nombre": "Celular", "categoría": Samsung, "tamaño ": Medio}'),
  ('{"nombre": "Control", "categoría": LG, "tamaño ": Grande}'),
  ('{"nombre": "Mouse", "categoría": Apple, "tamaño ": Medio}');
  
  CREATE INDEX idx_data_gin ON productos_u USING GIN (atributos);
