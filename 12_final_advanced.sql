-- 1. Convertir HSTORE a JSONB (para migración o visualización)
SELECT 
    nombre,
    atributos,
    hstore_to_jsonb(atributos) AS jsonb_data
FROM 
    productos_hstore
WHERE 
    nombre = 'Bocina Compacta';

---

-- 2. Convertir JSONB a HSTORE (para procesamiento o integración)
-- Paso A: Crear una tabla temporal con una columna JSONB de ejemplo
DROP TABLE IF EXISTS temp_json_data;
CREATE TEMPORARY TABLE temp_json_data (
    id INT,
    json_specs JSONB
);

INSERT INTO temp_json_data (id, json_specs)
VALUES (1, '{"marca": "Logi", "conexion": "USB", "tipo": "ergonomico"}');

-- Paso B: Convertir la columna JSONB a HSTORE
SELECT
    id,
    json_specs,
    jsonb_to_hstore(json_specs) AS hstore_attributes
FROM 
    temp_json_data;
