import psycopg2
import pytest

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def test_database_connection():
    """Test básico de conexión a la base de datos"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.close()
        assert True
    except Exception as e:
        pytest.fail(f"Error de conexión: {e}")

def test_tables_exist():
    """Verificar que las tablas existen"""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public'
                AND table_name IN ('usuarios', 'productos_jsonb', 'productos_hstore');
            """)
            tables = [row[0] for row in cur.fetchall()]
            assert len(tables) == 3

def test_jsonb_data():
    """Verificar datos en productos_jsonb"""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM productos_jsonb;")
            count = cur.fetchone()[0]
            assert count >= 5

def test_hstore_data():
    """Verificar datos en productos_hstore"""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM productos_hstore;")
            count = cur.fetchone()[0]
            assert count >= 5
