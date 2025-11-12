-- 1.Indexar la columna HSTORE con GIN

CREATE INDEX idx_productos_hstore_gin
ON productos_hstore
USING GIN (atributos);

-- 2.Usar funciones agregadas con HSTORE
SELECT
    atributos -> 'marca' AS marca,
    COUNT(*) AS total
FROM productos_hstore
GROUP BY marca
ORDER BY total DESC;

-- 3. Convertir HSTORE a JSON y viceversa
SELECT 
    nombre, 
    atributos, 
    hstore_to_jsonb(atributos) AS atributos_jsonb
FROM productos_hstore
WHERE nombre = 'Monitor Gaming';

SELECT hstore(array_agg(key), array_agg(value))
FROM jsonb_each_text('{"nuevo_attr": "valor1", "garantia": "1 año"}'::jsonb);

-- 4. Validar existencia de múltiples claves
SELECT nombre, atributos
FROM productos_hstore
WHERE atributos ?& ARRAY['color', 'peso'];

-- 5. Crear una función que reciba un HSTORE y devuelva un resumen
CREATE OR REPLACE FUNCTION resumir_producto(
    nombre_prod TEXT,
    attrs HSTORE
)
RETURNS TEXT AS $$
DECLARE
    resumen TEXT;
    marca_prod TEXT;
    color_prod TEXT;
BEGIN
    -- Extraemos los valores. Si no existen, serán NULL.
    marca_prod := attrs -> 'marca';
    color_prod := attrs -> 'color';

    -- Usamos COALESCE para mostrar 'N/A' si el valor es NULL.
    resumen := format(
        'Producto %s: marca=%s, color=%s',
        nombre_prod,
        COALESCE(marca_prod, 'N/A'),
        COALESCE(color_prod, 'N/A')
    );
    
    RETURN resumen;
END;
$$ LANGUAGE plpgsql;

SELECT 
    nombre, 
    resumir_producto(nombre, atributos) AS resumen
FROM productos_hstore;
