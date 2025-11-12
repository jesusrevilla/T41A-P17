import psycopg2
import pytest
import os

# CONFIGURACIÓN DE LA BASE DE DATOS
# ¡IMPORTANTE! Asegúrate de que esta configuración coincida con tu entorno PostgreSQL.
DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres", # Cambia esto si tu contraseña es diferente
    "host": "localhost",
    "port": 5432
}

# --- FIXTURE PARA MANEJAR LA CONEXIÓN ---
@pytest.fixture(scope="module")
def db_connection():
    """
    Establece y cierra la conexión a la base de datos para todos los tests.
    """
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        # Opcional: Asegurarse de que el setup SQL fue ejecutado
        print("\nConexión a la base de datos establecida.")
        
        yield conn
        
    except psycopg2.OperationalError as e:
        # En caso de fallo de conexión (DB apagada, credenciales incorrectas, etc.)
        pytest.skip(f"FALLO DE CONEXIÓN: Asegúrate de que PostgreSQL esté corriendo y la DB exista. Error: {e}")
        
    finally:
        if conn:
            conn.close()
            print("Conexión a la base de datos cerrada.")

def run_query(conn, query):
    """Ejecuta una consulta SQL usando la conexión proporcionada y devuelve los resultados."""
    with conn.cursor() as cur:
        cur.execute(query)
        # conn.commit() # No es necesario para SELECTs
        return cur.fetchall()

# --- TESTS DE VALIDACIÓN DE JSONB ---

def test_nombre_ana(db_connection):
    """
    Verifica que el nombre en el registro con ID=1 sea 'Ana'.
    Esto valida la inserción del primer registro.
    """
    query = "SELECT data->>'nombre' FROM usuarios WHERE id = 1;"
    result = run_query(db_connection, query)
    
    # Se espera una lista de tuplas: [('Ana',)]
    assert result[0][0] == "Ana"
    print("Test OK: Nombre 'Ana' encontrado para ID 1.")

def test_usuario_activo(db_connection):
    """
    Verifica que el estado 'activo' para ID=1 sea 'true'.
    El operador ->> devuelve el valor booleano como string 'true'.
    """
    query = "SELECT data->>'activo' FROM usuarios WHERE id = 1;"
    result = run_query(db_connection, query)
    
    # JSONB ->> 'activo' extrae el valor booleano como texto 'true'
    assert result[0][0] == "true"
    print("Test OK: Usuario con ID 1 está 'activo'.")

def test_edad_juan(db_connection):
    """
    Verifica que la edad para el registro con ID=2 sea '25'.
    Esto valida la inserción del segundo registro.
    """
    query = "SELECT data->>'edad' FROM usuarios WHERE id = 2;"
    result = run_query(db_connection, query)
    
    # JSONB ->> 'edad' extrae el valor numérico como texto '25'
    assert result[0][0] == "25"
    print("Test OK: Edad '25' encontrada para ID 2 (Juan).")

# --- PASOS PARA EJECUTAR ESTOS TESTS ---
# 1. Asegúrate de haber instalado: pip install psycopg2-binary pytest
# 2. Asegúrate de que tu base de datos 'test_db' esté corriendo y las credenciales sean correctas.
# 3. Asegúrate de haber ejecutado el script SQL 'setup_test_db.sql' para crear y poblar la tabla 'usuarios'.
# 4. Ejecuta el test desde tu terminal: pytest test_db_queries.py
