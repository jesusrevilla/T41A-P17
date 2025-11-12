-- 11_jsonb_queries.sql

-- Consultar productos por color, tamaño o categoría (Ejercicio JSONB 3)

-- 1. Consultar productos por color (usando operador ->> para extraer valor como texto)
SELECT 
    nombre, 
    especificaciones ->> 'color' AS color
FROM 
    productos_jsonb
WHERE 
    especificaciones ->> 'color' = 'negro';

---

-- 2. Consultar productos por tamaño (usando operador @> para verificar la existencia del sub-objeto/clave)
-- Busca productos que contengan la especificación 'tamano: extragrande'
SELECT 
    nombre, 
    especificaciones ->> 'tamano' AS tamano
FROM 
    productos_jsonb
WHERE 
    especificaciones @> '{"tamano": "extragrande"}';

---

-- 3. Consultar productos por categoría y precio
SELECT 
    nombre, 
    precio,
    especificaciones ->> 'categoria' AS categoria
FROM 
    productos_jsonb
WHERE 
    especificaciones ->> 'categoria' = 'Accesorios'
    AND precio < 30.00;
