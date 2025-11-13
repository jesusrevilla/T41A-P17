-- Actualizar valor dentro de HSTORE (cambia "peso" de un producto)
UPDATE productos_hs
SET atributos = atributos || 'peso => 1.30kg'
WHERE nombre = 'Laptop Dell XPS';

-- Eliminar clave "color" de un registro (ejemplo: Bocina JBL Go)
UPDATE productos_hs
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Bocina JBL Go';
