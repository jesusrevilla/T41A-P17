import psycopg2
import pytest
import os

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(query):
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()

def run_sql_file(filepath):
    test_dir = os.path.dirname(os.path.abspath(__file__))
    full_path = os.path.join(test_dir, filepath)

    try:
        with open(full_path, 'r') as f:
            sql_content = f.read()
        
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor() as cur:
                cur.execute(sql_content)
        
        return True, ""
    
    except (Exception, psycopg2.Error) as error:
        return False, str(error)

def test_nombre_ana():
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    print(f'resultado del query: {result}')
    assert result[0][0] == "Ana"

def test_usuario_activo():
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"

def test_edad_juan():
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"

sql_exercise_files = [
    "05_ejercicios_recomendados.sql",
    "06_ejercicios_basicos_de_hstore.sql",
    "07_ejercicios_intermedios.sql",
    "08_ejercicios_avanzados.sql"
]
@pytest.mark.parametrize("filename", sql_exercise_files)
def test_sql_exercise_file_execution(filename):
    success, error_message = run_sql_file(filename)
    assert success, f"El script {filename} falló al ejecutarse:\n{error_message}"





