-- ¿Cuántos productos tienen el atributo "color"?
SELECT COUNT(*) AS con_color
FROM productos_hs
WHERE atributos ? 'color';
