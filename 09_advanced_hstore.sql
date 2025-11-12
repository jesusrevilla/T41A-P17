
-- 1. Filtrar registros que contienen una clave
-- Usa el operador ? para encontrar productos que tengan el atributo 'marca'.
SELECT 
    nombre, 
    atributos
FROM 
    productos_hstore
WHERE 
    atributos ? 'marca';

---

-- 2. Combinar HSTORE con otras columnas
-- Consulta productos que tengan marca = 'Nexus' y precio > 500.00.
SELECT 
    nombre, 
    precio, 
    atributos -> 'marca' AS marca
FROM 
    productos_hstore
WHERE 
    (atributos -> 'marca') = 'Nexus' 
    AND precio > 500.00;


-- 3. Extraer todas las claves y valores
-- Usa skeys() y svals() para listar todos los atributos de cada producto.
SELECT 
    nombre, 
    skeys(atributos) AS claves, 
    svals(atributos) AS valores
FROM 
    productos_hstore;

---

-- 4. Contar cuántos productos tienen un atributo específico
-- ¿Cuántos productos tienen el atributo 'color'?
SELECT 
    COUNT(*) AS total_con_color
FROM 
    productos_hstore 
WHERE 
    atributos ? 'color';

-- EJERCICIOS AVANZADOS 


-- 1. Indexar la columna HSTORE con GIN
-- Crea un índice para mejorar el rendimiento de búsquedas por clave.
CREATE INDEX IF NOT EXISTS idx_productos_atributos_gin 
ON productos_hstore USING GIN (atributos);

---

-- 2. Usar funciones agregadas con HSTORE
-- Agrupa productos por marca y cuenta cuántos hay por cada una.
SELECT
    atributos -> 'marca' AS marca,
    COUNT(*) AS total_productos_por_marca
FROM
    productos_hstore
WHERE
    atributos ? 'marca' -- Se asegura que solo cuenta los que tienen la clave 'marca'
GROUP BY 
    marca
ORDER BY 
    total_productos_por_marca DESC;

---

-- 3. Validar existencia de múltiples claves
-- Usa ?& para verificar si un producto tiene tanto 'color' como 'peso'.
SELECT 
    nombre, 
    atributos
FROM 
    productos_hstore
WHERE 
    atributos ?& ARRAY['color', 'peso'];

---

-- 4. Crear una función que reciba un HSTORE y devuelva un resumen
-- Devuelve un string de resumen del producto.
CREATE OR REPLACE FUNCTION get_producto_resumen(p_atributos HSTORE)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_marca TEXT := p_atributos -> 'marca';
    v_color TEXT := p_atributos -> 'color';
    v_resumen TEXT;
BEGIN
    -- Construye el resumen usando COALESCE para manejar atributos faltantes (NULL)
    v_resumen := 'Marca: ' || COALESCE(v_marca, 'N/D') || 
                 ', Color: ' || COALESCE(v_color, 'N/D') ||
                 ', Total Claves: ' || array_length(akeys(p_atributos), 1);
    
    RETURN 'Resumen {' || v_resumen || '}';
END;
$$;

-- Ejemplo de llamada a la nueva función
SELECT 
    nombre, 
    get_producto_resumen(atributos) AS resumen_producto
FROM 
    productos_hstore;
