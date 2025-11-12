import psycopg2
import pytest

# Configuración de conexión a PostgreSQL
DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(query):
    """Ejecuta una consulta SQL y devuelve el resultado."""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            if cur.description:
                return cur.fetchall()
            return None

# ============================================================
# TESTS JSONB
# ============================================================

def test_tabla_jsonb_existe():
    result = run_query("""
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_name = 'productos_jsonb';
    """)
    assert result[0][0] == 1, "La tabla productos_jsonb no existe"

def test_jsonb_tiene_5_registros():
    result = run_query("SELECT COUNT(*) FROM productos_jsonb;")
    assert result[0][0] == 5, "productos_jsonb no tiene 5 registros"

def test_producto_jsonb_color_rojo():
    result = run_query("""
        SELECT COUNT(*) FROM productos_jsonb
        WHERE especificaciones->>'color' = 'rojo';
    """)
    assert result[0][0] >= 1, "No se encontró producto color rojo en JSONB"

def test_indice_jsonb_existe():
    result = run_query("""
        SELECT COUNT(*) FROM pg_indexes
        WHERE indexname = 'idx_productos_jsonb_especificaciones';
    """)
    assert result[0][0] == 1, "Falta índice GIN en productos_jsonb"

# ============================================================
# TESTS HSTORE
# ============================================================

def test_tabla_hstore_existe():
    result = run_query("""
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_name = 'productos_hstore';
    """)
    assert result[0][0] == 1, "La tabla productos_hstore no existe"

def test_hstore_tiene_5_registros():
    result = run_query("SELECT COUNT(*) FROM productos_hstore;")
    assert result[0][0] == 5, "productos_hstore no tiene 5 registros"

def test_producto_color_rojo_hstore():
    result = run_query("""
        SELECT COUNT(*) FROM productos_hstore
        WHERE atributos->'color' = 'rojo';
    """)
    assert result[0][0] >= 1, "No se encontró producto color rojo en HSTORE"

def test_actualizacion_peso():
    result = run_query("""
        SELECT atributos->'peso' FROM productos_hstore WHERE nombre = 'Celular';
    """)
    assert result[0][0] == "180g", "El peso del celular no fue actualizado correctamente"

def test_color_eliminado_en_mesa():
    result = run_query("""
        SELECT atributos ? 'color' FROM productos_hstore WHERE nombre = 'Mesa';
    """)
    assert result[0][0] is False, "La clave 'color' no fue eliminada de Mesa"

def test_indice_hstore_existe():
    result = run_query("""
        SELECT COUNT(*) FROM pg_indexes
        WHERE indexname = 'idx_productos_hstore_atributos';
    """)
    assert result[0][0] == 1, "Falta índice GIN en productos_hstore"

def test_consulta_por_marca_existe():
    result = run_query("""
        SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'marca';
    """)
    assert result[0][0] >= 1, "No hay productos con clave 'marca'"

def test_funcion_resumen_producto():
    # Ejecuta la función resumen_producto (creada en el ejercicio correspondiente)
    result = run_query("""
        SELECT resumen_producto(nombre, atributos)
        FROM productos_hstore
        ORDER BY id LIMIT 1;
    """)
    assert "Producto" in result[0][0], "La función resumen_producto no devuelve el formato esperado"

# ============================================================
# TESTS ADICIONALES
# ============================================================

def test_atributo_color_contado_correctamente():
    result = run_query("""
        SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'color';
    """)
    assert result[0][0] >= 1, "No hay productos con atributo color"

def test_conversion_hstore_json_funciona():
    result = run_query("SELECT hstore_to_json(atributos) FROM productos_hstore LIMIT 1;")
    assert isinstance(result[0][0], dict) or isinstance(result[0][0], str), \
        "La conversión hstore_to_json no devolvió un formato válido"
