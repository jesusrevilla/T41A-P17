UPDATE productos_hstore
SET atributos = atributos || 'peso=>"180g"'
WHERE nombre = 'Celular';
