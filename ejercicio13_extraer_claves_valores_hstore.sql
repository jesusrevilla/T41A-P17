SELECT nombre, skeys(atributos) AS clave, svals(atributos) AS valor
FROM productos_hstore;
