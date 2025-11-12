-- EJERCICIOS INTERMEDIOS
-- 1. Filtrar registros que contienen una clave (operador ?)
RAISE NOTICE '--- Intermedio 1: Productos con atributo "marca"';
SELECT nombre, atributos FROM productos WHERE atributos ? 'marca';

-- 2. Combinar HSTORE con otras columnas (marca = 'Sony' y precio > 500)
RAISE NOTICE '--- Intermedio 2: Productos Sony con precio > 500';
SELECT * FROM productos
WHERE (atributos -> 'marca' = 'Sony') AND precio > 500;

-- 3. Extraer todas las claves y valores (skeys, svals)
RAISE NOTICE '--- Intermedio 3: Claves y valores de todos los productos';
SELECT nombre, skeys(atributos) AS claves, svals(atributos) AS valores
FROM productos;

-- 4. Contar cuántos productos tienen un atributo específico (tienen 'color')
RAISE NOTICE '--- Intermedio 4: Conteo de productos con atributo "color"';
SELECT count(*) AS total_con_color
FROM productos
WHERE atributos ? 'color';

-- EJERCICIOS AVANZADOS
-- 1. Indexar la columna HSTORE con GIN
CREATE INDEX IF NOT EXISTS idx_productos_atributos_gin ON productos USING GIN (atributos);
RAISE NOTICE 'OK - Avanzado 1: Índice GIN creado en "atributos".';

-- 2. Usar funciones agregadas con HSTORE (Agrupar por marca)
RAISE NOTICE '--- Avanzado 2: Conteo de productos por marca';
SELECT 
  atributos -> 'marca' AS marca,
  count(*) AS cantidad
FROM productos
WHERE atributos ? 'marca'
GROUP BY marca;

-- 3. Convertir HSTORE a JSON y viceversa
RAISE NOTICE '--- Avanzado 3: Convertir HSTORE a JSONB (Laptop)';
SELECT nombre, hstore_to_jsonb(atributos) AS datos_jsonb
FROM productos
WHERE nombre = 'Laptop';

RAISE NOTICE '--- Avanzado 3: Convertir JSONB a HSTORE';
SELECT jsonb_to_hstore('{"nuevo": "valor", "stock": "100"}');

-- 4. Validar existencia de múltiples claves (operador ?&)
RAISE NOTICE '--- Avanzado 4: Productos con "color" Y "peso"';
SELECT nombre, atributos FROM productos
WHERE atributos ?& ARRAY['color', 'peso'];

-- 5. Crear una función que reciba un HSTORE y devuelva un resumen
CREATE OR REPLACE FUNCTION resumen_producto_hstore(p_id INT)
RETURNS TEXT AS $$
DECLARE
    rec_producto RECORD;
    resumen TEXT;
    claves_valores TEXT[];
BEGIN
    SELECT nombre, atributos INTO rec_producto FROM productos WHERE id = p_id;
    IF NOT FOUND THEN RETURN 'Producto no encontrado.'; END IF;

    resumen := 'Producto: ' || rec_producto.nombre || ' (';
    
    SELECT array_agg(clave || ' = ' || valor) INTO claves_valores
    FROM each(rec_producto.atributos);
    
    IF claves_valores IS NOT NULL THEN
        resumen := resumen || array_to_string(claves_valores, ', ') || ')';
    ELSE
        resumen := resumen || 'Sin atributos)';
    END IF;
    
    RETURN resumen;
END;
$$ LANGUAGE plpgsql;

RAISE NOTICE 'OK - Avanzado 5: Función "resumen_producto_hstore" creada.';

RAISE NOTICE '--- Probando función de resumen:';
SELECT resumen_producto_hstore(1) AS resumen_laptop;
SELECT resumen_producto_hstore(3) AS resumen_monitor;
