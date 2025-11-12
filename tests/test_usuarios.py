import psycopg2
import pytest
from typing import List, Tuple

# --- CONFIGURACIÓN DE LA BASE DE DATOS ---
DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

# --- FUNCIONES DE UTILIDAD ---

def run_query(query: str) -> List[Tuple]:
    """Ejecuta una consulta SQL y retorna los resultados (fetchall)."""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            # conn.commit() # No es necesario para SELECTs
            try:
                return cur.fetchall()
            except psycopg2.ProgrammingError:
                # Captura el error si no hay resultados que obtener (ej. UPDATE/DELETE)
                return []

def run_dml_query(query: str):
    """Ejecuta una consulta DML (UPDATE, DELETE, CALL) y retorna el número de filas afectadas."""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            conn.commit()
            return cur.rowcount

# --- PRUEBAS EXISTENTES (Tabla usuarios - JSONB) ---
# Asumen que los datos de Ana (ID 1) y Juan (ID 2) ya están insertados.

def test_nombre_ana():
    """Verifica que el nombre de usuario 1 sea 'Ana'."""
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    assert result and result[0][0] == "Ana"

def test_usuario_activo():
    """Verifica que el usuario 1 esté activo (data->>'activo' = 'true')."""
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result and result[0][0] == "true"

def test_edad_juan():
    """Verifica que la edad del usuario 2 sea '25'."""
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result and result[0][0] == "25"

# ----------------------------------------------------------------------------------
# --- NUEVAS PRUEBAS PARA HSTORE (Basadas en 05_ a 09_) ---
# ----------------------------------------------------------------------------------

def test_hstore_table_exists():
    """Verifica que la tabla productos_hstore y la extensión hstore existan."""
    result = run_query("SELECT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'productos_hstore');")
    assert result[0][0] is True, "La tabla 'productos_hstore' no existe."
    
def test_hstore_initial_data_count():
    """Verifica que se insertaron al menos 5 productos en la tabla hstore."""
    result = run_query("SELECT COUNT(*) FROM productos_hstore;")
    assert result[0][0] >= 5, "Se esperaban al menos 5 registros en productos_hstore."

def test_hstore_query_by_key():
    """Verifica el Ejercicio Intermedio 1: Filtrar registros que contienen la clave 'marca'."""
    result = run_query("SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'marca';")
    # Esperamos que 4 de los 5 productos de la inserción inicial tengan 'marca'.
    assert result[0][0] >= 4, "No se encontraron suficientes productos con el atributo 'marca'."

def test_hstore_aggregate_by_brand():
    """Verifica el Ejercicio Avanzado 2: Agrupar por marca."""
    # Contamos el producto 'Razer' (Silla Gamer)
    query = "SELECT COUNT(*) FROM productos_hstore WHERE atributos -> 'marca' = 'Razer';"
    result = run_query(query)
    assert result[0][0] == 1, "La agregación por marca 'Razer' falló."

def test_hstore_function_resumen():
    """Verifica el Ejercicio Avanzado 4: La función get_producto_resumen existe y funciona."""
    # Seleccionamos un resumen del primer producto
    query = """
    SELECT get_producto_resumen(atributos) 
    FROM productos_hstore 
    WHERE nombre = 'Silla Gamer';
    """
    result = run_query(query)
    # Esperamos que el resultado contenga la marca y el color
    assert result and "Marca: Razer" in result[0][0] and "Color: negro" in result[0][0], \
           "La función get_producto_resumen no retornó el formato esperado."

# ----------------------------------------------------------------------------------
# --- NUEVAS PRUEBAS PARA JSONB (Basadas en 10_ y 11_) ---
# ----------------------------------------------------------------------------------

def test_jsonb_products_table_exists():
    """Verifica que la tabla productos_jsonb exista."""
    result = run_query("SELECT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'productos_jsonb');")
    assert result[0][0] is True, "La tabla 'productos_jsonb' no existe."

def test_jsonb_initial_data_count():
    """Verifica que se insertaron al menos 5 productos en la tabla jsonb."""
    result = run_query("SELECT COUNT(*) FROM productos_jsonb;")
    assert result[0][0] >= 5, "Se esperaban al menos 5 registros en productos_jsonb."

def test_jsonb_query_by_category():
    """Verifica el Ejercicio JSONB 3: Consulta por categoría ('Muebles')."""
    query = """
    SELECT COUNT(*) 
    FROM productos_jsonb 
    WHERE especificaciones ->> 'categoria' = 'Muebles';
    """
    result = run_query(query)
    # Esperamos 1 producto ('Silla Ejecutiva')
    assert result[0][0] == 1, "La consulta por categoría 'Muebles' falló."

def test_jsonb_query_by_nested_value():
    """Verifica consulta avanzada usando el operador @> (existencia de sub-objeto)."""
    query = """
    SELECT COUNT(*) 
    FROM productos_jsonb 
    WHERE especificaciones @> '{"tamano": "extragrande"}';
    """
    result = run_query(query)
    # Esperamos 1 producto ('Mouse Pad XXL')
    assert result[0][0] == 1, "La consulta JSONB con operador @> falló."
