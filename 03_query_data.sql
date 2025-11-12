SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

-- Consultar productos de color negro
SELECT nombre
FROM productos
WHERE atributos -> 'color' = 'negro';

-- Consultar productos que tienen la clave 'marca'
SELECT nombre
FROM productos
WHERE atributos ? 'marca';

-- Extraer claves y valores de atributos
SELECT id, skeys(atributos) AS clave, svals(atributos) AS valor
FROM productos;

-- Contar productos con atributo 'color'
SELECT COUNT(*) FROM productos WHERE atributos ? 'color';
