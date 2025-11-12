DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'hstore') THEN
        RAISE WARNING '⚠️  La extensión HSTORE no está instalada.';
    ELSE
        RAISE NOTICE '✅  HSTORE está habilitado.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp') THEN
        RAISE WARNING '⚠️  La extensión UUID-OSSP no está instalada.';
    ELSE
        RAISE NOTICE '✅  UUID-OSSP está habilitado.';
    END IF;
END$$;



DO $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count FROM productos_jsonb;
    IF v_count = 5 THEN
        RAISE NOTICE '✅ Tabla productos_jsonb tiene 5 registros.';
    ELSE
        RAISE WARNING '❌ Tabla productos_jsonb tiene % registros, se esperaban 5.', v_count;
    END IF;
END$$;



DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE indexname = 'idx_productos_jsonb_especificaciones'
    ) THEN
        RAISE NOTICE '✅ Índice GIN en JSONB existe.';
    ELSE
        RAISE WARNING '❌ Falta índice GIN en productos_jsonb.';
    END IF;
END$$;



DO $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count FROM productos_hstore;
    IF v_count = 5 THEN
        RAISE NOTICE '✅ Tabla productos_hstore tiene 5 registros.';
    ELSE
        RAISE WARNING '❌ Tabla productos_hstore tiene % registros, se esperaban 5.', v_count;
    END IF;
END$$;



DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE indexname = 'idx_productos_hstore_atributos'
    ) THEN
        RAISE NOTICE '✅ Índice GIN en HSTORE existe.';
    ELSE
        RAISE WARNING '❌ Falta índice GIN en productos_hstore.';
    END IF;
END$$;



DO $$
DECLARE
    v_color_rojo INT;
BEGIN
    SELECT COUNT(*) INTO v_color_rojo FROM productos_hstore WHERE atributos -> 'color' = 'rojo';
    IF v_color_rojo > 0 THEN
        RAISE NOTICE '✅ Existen productos con color rojo.';
    ELSE
        RAISE WARNING '❌ No se encontró ningún producto con color rojo.';
    END IF;
END$$;
