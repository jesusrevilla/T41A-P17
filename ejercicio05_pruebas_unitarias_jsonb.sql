DO $$
BEGIN
    IF (SELECT COUNT(*) FROM productos_jsonb) = 5 THEN
        RAISE NOTICE 'Prueba OK: hay 5 productos.';
    ELSE
        RAISE WARNING 'Error: número de productos incorrecto.';
    END IF;
END$$;
