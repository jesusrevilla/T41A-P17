import os
import psycopg2
import psycopg2.extras
import pytest

DB_CONFIG = {
    "dbname": os.environ.get("PGDATABASE", "test_db"),
    "user": os.environ.get("PGUSER", "postgres"),
    "password": os.environ.get("PGPASSWORD", "postgres"),
    "host": os.environ.get("PGHOST", "localhost"),
    "port": os.environ.get("PGPORT", 5432)
}

def run_query(query, fetch=True):
    with psycopg2.connect(**DB_CONFIG) as conn:
        psycopg2.extras.register_hstore(conn)
        
        with conn.cursor() as cur:
            cur.execute(query)
            if fetch:
                return cur.fetchall()

def test_jsonb_usuario_ana():
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "Ana"

def test_jsonb_usuario_juan_edad():
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"

def test_jsonb_usuario_ana_activa():
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"

def test_hstore_insert_count():
    result = run_query("SELECT COUNT(*) FROM productos;")
    assert result[0][0] >= 5

def test_hstore_query_color_rojo():
    result = run_query("SELECT * FROM productos WHERE atributos->'color' = 'rojo';")
    assert len(result) == 1 

def test_hstore_VERIFY_update_valor():
    result = run_query("SELECT atributos->'peso' FROM productos WHERE nombre = 'Laptop';")
    assert result[0][0] == '2.2kg'

def test_hstore_VERIFY_delete_key():
    result = run_query("SELECT atributos->'color' FROM productos WHERE nombre = 'Teclado';")
    assert result[0][0] is None

def test_hstore_query_contiene_marca():
    result = run_query("SELECT * FROM productos WHERE atributos ? 'marca';")
    assert len(result) == 5

def test_hstore_query_combinada():
    result = run_query("SELECT * FROM productos WHERE atributos->'marca' = 'Sony' AND precio > 500;")
    assert len(result) == 1 

def test_hstore_query_contar_color():
    result = run_query("SELECT COUNT(*) FROM productos WHERE atributos ? 'color';")
    assert result[0][0] == 4
    
def test_hstore_query_agrupar_marca():
    result = run_query("SELECT atributos->'marca' AS marca, COUNT(*) FROM productos WHERE atributos ? 'marca' GROUP BY marca ORDER BY marca;")
    assert ('Dell', 1) in result
    assert ('LG', 1) in result
    assert ('Logitech', 1) in result
    assert ('Samsung', 1) in result
    assert ('Sony', 1) in result
    assert len(result) == 5

def test_hstore_query_multiples_claves():
    result = run_query("SELECT * FROM productos WHERE atributos ?& ARRAY['color', 'peso'];")
    assert len(result) == 2 

def test_hstore_funcion_resumen():
    result = run_query("SELECT resumen_producto_hstore(1);") 
    
    resumen_laptop = result[0][0]
    assert 'Producto: Laptop' in resumen_laptop
    assert 'marca = Dell' in resumen_laptop
    assert 'peso = 2.2kg' in resumen_laptop
