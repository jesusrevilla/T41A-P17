import psycopg2
import pytest
from pathlib import Path

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

@pytest.fixture(scope="module")
def db():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = True
    cur = conn.cursor()
    sql_dir = Path(".")

    for file in [
        "01_create_tables.sql",
        "02_insert_data.sql",
        "03_query_data.sql"
    ]:
        with open(sql_dir / file, "r") as f:
            cur.execute(f.read())

    yield conn

    cur.close()
    conn.close()


def run_query(conn, query, params=None):
    with conn.cursor() as cur:
        cur.execute(query, params)
        try:
            return cur.fetchall()
        except psycopg2.ProgrammingError:
            return None
def test_usuarios_activos(db):
    result = run_query(db,
        "SELECT data->>'nombre' FROM usuarios WHERE data->>'activo' = 'true';"
    )
    nombres = [r[0] for r in result]

    assert len(nombres) > 0
    assert all(isinstance(n, str) for n in nombres)
def test_json_contains(db):
    result = run_query(db,
        "SELECT * FROM usuarios WHERE data @> '{\"activo\": true}';"
    )
    assert len(result) > 0
def test_hstore_has_marca(db):
    result = run_query(db,
        "SELECT * FROM productos WHERE atributos ? 'marca';"
    )

    assert len(result) > 0
def test_hstore_multiple_keys(db):
    result = run_query(db,
        "SELECT * FROM productos WHERE atributos ?& ARRAY['color', 'peso'];"
    )

    assert isinstance(result, list)
def test_resumen_producto(db):
    result = run_query(db,
        "SELECT resumen_producto(atributos) FROM productos LIMIT 1;"
    )

    texto = result[0][0]
    assert "Producto:" in texto
    assert "marca=" in texto
    assert "color=" in texto
    assert "peso=" in texto
def test_hstore_to_json(db):
    result = run_query(db,
        "SELECT hstore_to_jsonb(atributos) FROM productos LIMIT 1;"
    )

    json_obj = result[0][0]
    assert isinstance(json_obj, dict)
def test_count_color(db):
    result = run_query(db,
        "SELECT COUNT(*) FROM productos WHERE atributos ? 'color';"
    )
    cantidad = result[0][0]

    assert cantidad >= 0

