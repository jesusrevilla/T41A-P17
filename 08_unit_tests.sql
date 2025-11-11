DO $$
DECLARE
    v_color_count INT;
    v_peso_silla_gamer TEXT;
    v_color_telefono_x2 TEXT;
BEGIN
   
    SELECT COUNT(*) INTO v_color_count
    FROM productos_hstore
    WHERE atributos -> 'color' = 'rojo';

    IF v_color_count = 1 THEN
        RAISE NOTICE 'OK: Se encontró 1 producto con color rojo.';
    ELSE
        RAISE EXCEPTION 'FALLO: Se esperaban 1 producto con color rojo, se encontraron %.', v_color_count;
    END IF;

    -- Asumimos que la actualización de peso a 30kg ya se ejecutó en 07_query_hstore.sql
    SELECT atributos -> 'peso' INTO v_peso_silla_gamer
    FROM productos_hstore
    WHERE nombre = 'Silla Gamer';

    IF v_peso_silla_gamer = '30kg' THEN
        RAISE NOTICE 'OK: Peso de Silla Gamer actualizado correctamente a 30kg.';
    ELSE
        RAISE EXCEPTION 'FALLO: El peso de Silla Gamer es %, se esperaba 30kg.', v_peso_silla_gamer;
    END IF;
    -- Asumimos que la eliminación de la clave 'color' ya se ejecutó en 07_query_hstore.sql
    SELECT atributos -> 'color' INTO v_color_telefono_x2
    FROM productos_hstore
    WHERE nombre = 'Teléfono X2';

    IF v_color_telefono_x2 IS NULL THEN
        RAISE NOTICE 'OK: La clave "color" fue eliminada correctamente del Teléfono X2.';
    ELSE
        RAISE EXCEPTION 'FALLO: La clave "color" aún existe con el valor %.', v_color_telefono_x2;
    END IF;

END;
$$;
