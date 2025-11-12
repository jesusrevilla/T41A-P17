
SELECT * FROM productos_hstore WHERE atributos ? 'marca';

SELECT * FROM productos_hstore
WHERE (atributos -> 'marca' = 'Sony') AND precio > 500;

SELECT nombre, skeys(atributos) FROM productos_hstore;
SELECT nombre, svals(atributos) FROM productos_hstore;

SELECT count(*) FROM productos_hstore WHERE atributos ? 'color';
