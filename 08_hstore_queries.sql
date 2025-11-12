-- Básico 3: Consultar por clave 'color' = 'rojo'
SELECT * FROM productos_hstore WHERE atributos->'color' = 'rojo';

-- Básico 4: Actualizar un valor (cambiar peso de Laptop)
UPDATE productos_hstore
SET atributos = atributos || 'peso => "2.2kg"'::hstore
WHERE nombre = 'Laptop';

-- Básico 5: Eliminar una clave (quitar color a Teclado)
UPDATE productos_hstore
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teclado';

-- Intermedio 1: Filtrar si CONTIENE la clave 'marca'
SELECT * FROM productos_hstore WHERE atributos ? 'marca';

-- Intermedio 2: Combinar HSTORE (marca='Sony') y columna normal (precio > 500)
SELECT * FROM productos_hstore
WHERE atributos->'marca' = 'Sony' AND precio > 500;

-- Intermedio 3: Extraer claves y valores
SELECT nombre, skeys(atributos) AS claves, svals(atributos) AS valores
FROM productos_hstore;

-- Intermedio 4: Contar cuántos tienen el atributo 'color'
SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'color';

-- Avanzado 1: Indexar HSTORE con GIN
CREATE INDEX idx_hstore_atributos ON productos_hstore USING GIN (atributos);

-- Avanzado 2: Agrupar por marca y contar
SELECT atributos->'marca' AS marca, COUNT(*)
FROM productos_hstore
WHERE atributos ? 'marca'
GROUP BY marca;

-- Avanzado 3: Convertir HSTORE a JSONB
SELECT nombre, hstore_to_jsonb(atributos) FROM productos_hstore;

-- Avanzado 4: Validar existencia de múltiples claves (color Y peso)
SELECT * FROM productos_hstore WHERE atributos ?& ARRAY['color', 'peso'];

-- Avanzado 5: Función de resumen
CREATE OR REPLACE FUNCTION resumir_producto(p_nombre TEXT, p_atributos HSTORE)
RETURNS TEXT AS $$
BEGIN
    RETURN 'Producto ' || p_nombre || ': marca=' || COALESCE(p_atributos->'marca', 'N/A') || ', color=' || COALESCE(p_atributos->'color', 'N/A');
END;
$$ LANGUAGE plpgsql;

-- Prueba de la función
SELECT resumir_producto(nombre, atributos) FROM productos_hstore;
