CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);
