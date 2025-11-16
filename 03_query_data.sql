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

SELECT atributos->'marca' AS marca,
       COUNT(*) AS total
FROM productos
GROUP BY atributos->'marca';
--Falta uno
SELECT nombre,
       hstore_to_jsonb(atributos) AS atributos_jsonb
FROM productos;

SELECT *
FROM productos
WHERE atributos ?& ARRAY['color', 'peso'];

CREATE OR REPLACE FUNCTION resumen_producto(attrs HSTORE)
RETURNS TEXT AS $$
DECLARE
    marca TEXT := attrs->'marca';
    color TEXT := attrs->'color';
    peso  TEXT := attrs->'peso';
BEGIN
    RETURN 'Producto: marca=' || COALESCE(marca, 'N/A') ||
           ', color=' || COALESCE(color, 'N/A') ||
           ', peso=' || COALESCE(peso, 'N/A');
END;
$$ LANGUAGE plpgsql;
