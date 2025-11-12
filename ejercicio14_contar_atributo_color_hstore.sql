SELECT COUNT(*) AS productos_con_color
FROM productos_hstore
WHERE atributos ? 'color';
