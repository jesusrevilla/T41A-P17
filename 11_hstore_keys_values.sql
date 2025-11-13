-- Lista todas las claves y valores por producto
SELECT ph.id, ph.nombre, skeys(ph.atributos) AS clave, svals(ph.atributos) AS valor
FROM productos_hs ph
ORDER BY ph.id;
