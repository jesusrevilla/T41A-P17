SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

  CREATE INDEX idx_prod_gin ON productos_u USING GIN (atributos);

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

SELECT * FROM productos
WHERE atributos -> 'marca' = 'Fud' AND atributos -> 'peso' > '0.1Kg';

SELECT skeys(atributos) AS clave, svals(atributos) AS valor
FROM productos;

SELECT COUNT(*) FROM productos
WHERE atributos ? 'color';

--Ejercicios avanzados
CREATE INDEX idx_hstore_gin ON productos USING GIN (atributos);
