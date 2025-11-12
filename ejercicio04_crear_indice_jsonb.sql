CREATE INDEX idx_productos_jsonb_especificaciones
ON productos_jsonb USING GIN (especificaciones);
