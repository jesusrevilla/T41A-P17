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

def run_query(query, params=None):
    with psycopg2.connect(**DB_CONFIG) as conn:
        psycopg2.extras.register_hstore(conn)
        
        with conn.cursor() as cur:
            cur.execute(query, params)
            return cur.fetchall()

def test_nombre_ana():
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "Ana"

def test_usuario_activo():
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"

def test_edad_juan():
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"

def test_hstore_laptop_marca():
    result = run_query("SELECT atributos FROM productos WHERE nombre = 'Laptop';")
    atributos = result[0][0]
    assert isinstance(atributos, dict)
    assert atributos['marca'] == 'Dell'

def test_hstore_laptop_peso_actualizado():
    result = run_query("SELECT atributos FROM productos WHERE nombre = 'Laptop';")
    atributos = result[0][0]
    assert atributos['peso'] == '2.2kg'
    assert '2.5kg' not in atributos.values()

def test_hstore_teclado_color_eliminado():
    result = run_query("SELECT atributos FROM productos WHERE nombre = 'Teclado';")
    atributos = result[0][0]
    assert 'color' not in atributos
    assert atributos['tipo'] == 'mecanico'
