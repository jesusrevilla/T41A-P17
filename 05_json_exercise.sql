CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  especificaciones JSONB NOT NULL
);

INSERT INTO productos(nombre, especificaciones) VALUES 
('mouse', '{"inalambrico":true, "baterias":true, "color":"negro", "tamano":"estandar", "categoria":"periferico"}'),
('monitor', '{"tipo":"hdmi", "resolucion":1080, "color":"negro", "tamano":"27 pulgadas", "categoria":"monitor"}'),
('teclado', '{"lenguaje":"español", "recargable":true, "color":"gris", "tamano":"grande", "categoria":"periferico"}'),
('procesador', '{"velocidad":"5Ghz", "familia":"Ryzen 5", "color":null, "tamano":null, "categoria":"componente"}'),
('GPU', '{"memoria":"ddr5", "cantidad_puertos":2, "color":"blanco", "tamano":"grande", "categoria":"componente"}');

SELECT id,nombre FROM productos WHERE especificaciones ->> 'color' = 'negro' ;
SELECT id,nombre FROM productos WHERE especificaciones ->> 'tamano' = 'grande';
SELECT id,nombre FROM productos WHERE especificaciones ->> 'categoria' = 'componente';

EXPLAIN ANALYZE
SELECT id, nombre FROM productos
WHERE especificaciones @> '{"color": "negro"}';

CREATE INDEX idx_productos ON productos USING GIN (especificaciones);

ANALYZE productos;

EXPLAIN ANALYZE
SELECT id, nombre FROM productos
WHERE especificaciones @> '{"color": "negro"}';

