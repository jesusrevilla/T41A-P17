import psycopg2
import pytest
import psycopg2.extras

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

@pytest.fixture(scope="function")
def db_conn():
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        psycopg2.extras.register_hstore(conn)
        yield conn 
    finally:
        if conn:
            conn.rollback() 
            conn.close()

def run_query(conn, query, params=None):
    with conn.cursor() as cur:
        cur.execute(query, params)
        try:
            return cur.fetchall()
        except psycopg2.ProgrammingError:
            return None

# --- Pruebas del Ejercicio 1: JSONB ---

def test_jsonb_consulta_categoria_electronica(db_conn):
    """Prueba: Consultar productos por categoría 'electronica'."""
    result = run_query(db_conn, "SELECT COUNT(*) FROM productos WHERE especificaciones @> '{\"categoria\": \"electronica\"}';")
    assert result[0][0] == 2

def test_jsonb_consulta_color_azul(db_conn):
    result = run_query(db_conn, "SELECT COUNT(*) FROM productos WHERE especificaciones ->> 'color' = 'azul';")
    assert result[0][0] == 2

def test_jsonb_check_laptop_ram(db_conn):
    result = run_query(db_conn, "SELECT especificaciones ->> 'ram_gb' FROM productos WHERE nombre = 'Laptop Pro M3';")
    assert result[0][0] == '16'

# --- Pruebas del Ejercicio 2: HSTORE ---

def test_hstore_consulta_color_rojo(db_conn):
    result = run_query(db_conn, "SELECT COUNT(*) FROM productos_hstore WHERE atributos -> 'color' = 'rojo';")
    assert result[0][0] == 2

def test_hstore_actualizacion_peso_monitor(db_conn):
    run_query(db_conn, "UPDATE productos_hstore SET atributos = atributos || '\"peso\"=>\"4.5kg\"' WHERE nombre = 'Monitor Gaming';")
    result = run_query(db_conn, "SELECT atributos -> 'peso' FROM productos_hstore WHERE nombre = 'Monitor Gaming';")
    assert result[0][0] == '4.5kg'

def test_hstore_eliminacion_color_teclado(db_conn):
    run_query(db_conn, "UPDATE productos_hstore SET atributos = delete(atributos, 'color') WHERE nombre = 'Teclado Mecánico';")
    result = run_query(db_conn, "SELECT atributos -> 'color' FROM productos_hstore WHERE nombre = 'Teclado Mecánico';")
    assert result[0][0] is None

# --- Pruebas del Ejercicio 3: HSTORE ---

def test_hstore_filtro_clave_marca(db_conn):
    """Prueba: Usa el operador ? para encontrar productos que tengan 'marca'."""
    result = run_query(db_conn, "SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'marca';")
    assert result[0][0] > 0

def test_hstore_consulta_combinada_sony(db_conn):
    """Prueba: Productos con marca = 'Sony' y precio > 500."""
    result = run_query(db_conn, "SELECT nombre FROM productos_hstore WHERE (atributos -> 'marca' = 'Sony') AND (precio > 500);")
    assert len(result) == 1
    assert result[0][0] == 'Televisor Bravia'

def test_hstore_conteo_atributo_color(db_conn):
    result = run_query(db_conn, "SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'color';")
    assert result[0][0] > 0
    
# --- Pruebas del Ejercicio 4: HSTORE ---

def test_hstore_agregacion_marca(db_conn):
    query = "SELECT COUNT(*) FROM productos_hstore WHERE atributos -> 'marca' = 'Sony';"
    result = run_query(db_conn, query)
    assert result[0][0] > 0

def test_hstore_claves_multiples(db_conn):
    result = run_query(db_conn, "SELECT COUNT(*) FROM productos_hstore WHERE atributos ?& ARRAY['color', 'peso'];")
    assert result[0][0] == 3 
    
def test_hstore_funcion_resumen(db_conn):
    query = "SELECT resumir_producto(nombre, atributos) FROM productos_hstore WHERE nombre = 'Teclado Mecánico';"
    result = run_query(db_conn, query)
    assert result[0][0] == 'Producto Teclado Mecánico: marca=Logitech, color=N/A'


def test_nombre_ana(db_conn):
    result = run_query(db_conn, "SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    print(f'resultado del query: {result}')
    assert result[0][0] == "Ana"

def test_usuario_activo(db_conn):
    result = run_query(db_conn, "SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"

def test_edad_juan(db_conn):
    result = run_query(db_conn, "SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"
