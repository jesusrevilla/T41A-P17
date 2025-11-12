-- 1. Crear una tabla de productos con especificaciones en JSONB.
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creado_en TIMESTAMPTZ DEFAULT NOW(),
    especificaciones JSONB
);

-- 2. Insertar al menos 5 productos con diferentes atributos.
INSERT INTO productos (nombre, especificaciones) VALUES
('Laptop Pro M3', 
 '{ "categoria": "electronica", "color": "gris espacial", "tamaño": "14 pulgadas", "ram_gb": 16, "almacenamiento": "512GB SSD" }'),

('Camiseta de Algodón', 
 '{ "categoria": "ropa", "color": "azul", "tamaño": "M", "material": "algodon" }'),

('Taza de Cerámica', 
 '{ "categoria": "hogar", "color": "blanco", "capacidad_ml": 350, "apto_microondas": true }'),

('Smartphone Nexus Z', 
 '{ "categoria": "electronica", "color": "negro", "almacenamiento": "256GB", "pantalla": "6.7 pulgadas" }'),

('Jeans Slim Fit', 
 '{ "categoria": "ropa", "color": "azul", "tamaño": "32x30", "material": "denim" }');
 
-- 3. Consultar productos por color, tamaño o categoría.
SELECT id, nombre, especificacionesa
FROM productos
WHERE especificaciones ->> 'color' = 'azul';

SELECT id, nombre, especificaciones
FROM productos
WHERE especificaciones @> '{"tamaño": "M"}';

SELECT id, nombre, especificaciones
FROM productos
WHERE especificaciones @> '{"categoria": "electronica"}';

-- 4. Crear índices GIN y medir el rendimiento.
CREATE INDEX idx_productos_especificaciones_gin
ON productos
USING GIN (especificaciones);

EXPLAIN ANALYZE
SELECT * FROM productos
WHERE especificaciones @> '{"categoria": "electronica"}';

-- 5. Implementar pruebas unitarias.
CREATE OR REPLACE FUNCTION test_verificar_insercion_laptop()
RETURNS BOOLEAN AS $$
DECLARE
    v_ram_gb INT;
BEGIN
    -- 1. Buscar la laptop
    SELECT (especificaciones ->> 'ram_gb')::INT INTO v_ram_gb
    FROM productos
    WHERE nombre = 'Laptop Pro M3';

    -- 2. Afirmar (Assert) que la RAM es 16
    IF v_ram_gb = 16 THEN
        RAISE NOTICE 'PRUEBA OK: La RAM de la Laptop Pro M3 es 16 GB.';
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'PRUEBA FALLIDA: Se esperaba 16 GB de RAM, pero se encontraron % GB', v_ram_gb;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'PRUEBA FALLIDA: No se encontró el producto Laptop Pro M3.';
END;
$$ LANGUAGE plpgsql;

-- Ejecutar la prueba
SELECT test_verificar_insercion_laptop();

CREATE OR REPLACE FUNCTION test_verificar_conteo_categoria()
RETURNS BOOLEAN AS $$
DECLARE
    v_conteo INT;
BEGIN
    -- 1. Contar productos de 'ropa'
    SELECT COUNT(*) INTO v_conteo
    FROM productos
    WHERE especificaciones @> '{"categoria": "ropa"}';

    -- 2. Afirmar (Assert) que son 2
    IF v_conteo = 2 THEN
        RAISE NOTICE 'PRUEBA OK: Se encontraron 2 productos de ropa.';
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'PRUEBA FALLIDA: Se esperaban 2 productos de ropa, pero se encontraron %', v_conteo;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Ejecutar la prueba
SELECT test_verificar_conteo_categoria();
