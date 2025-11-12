UPDATE productos_hstore
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Mesa';
