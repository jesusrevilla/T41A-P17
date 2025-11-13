
import psycopg2
import pytest

# Configuración de la BD (ajusta si es necesario)
DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(query, fetch=True):
    """Helper para ejecutar consultas"""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            if fetch:
                return cur.fetchall()

# --- Pruebas JSONB ---

def test_jsonb_insert_count():
    result = run_query("SELECT COUNT(*) FROM productos_jsonb;")
    assert result[0][0] >= 5

def test_jsonb_query_color_rojo():
    # J-3: Consultar por color rojo
    result = run_query("SELECT * FROM productos_jsonb WHERE especificaciones->>'color' = 'rojo';")
    assert len(result) == 2 # Camisa y Zapatos

def test_jsonb_query_categoria_electronica():
    # J-3: Consultar por categoria
    result = run_query("SELECT * FROM productos_jsonb WHERE especificaciones->>'categoria' = 'electronica';")
    assert len(result) == 2 # Laptop y Monitor

# --- Pruebas HSTORE (Básicas) ---

def test_hstore_insert_count():
    result = run_query("SELECT COUNT(*) FROM productos_hstore;")
    assert result[0][0] >= 5

def test_hstore_query_color_rojo():
    # B-3: Consultar por color rojo
    result = run_query("SELECT * FROM productos_hstore WHERE atributos->'color' = 'rojo';")
    assert len(result) == 1 # Teclado y Camisa

def test_hstore_update_valor():
    # B-4: Probar la actualización
    run_query("UPDATE productos_hstore SET atributos = atributos || 'peso => \"2.2kg\"'::hstore WHERE nombre = 'Laptop';", fetch=False)
    result = run_query("SELECT atributos->'peso' FROM productos_hstore WHERE nombre = 'Laptop';")
    assert result[0][0] == '2.2kg'

def test_hstore_delete_key():
    # B-5: Probar eliminar clave
    run_query("UPDATE productos_hstore SET atributos = delete(atributos, 'color') WHERE nombre = 'Teclado';", fetch=False)
    result = run_query("SELECT atributos->'color' FROM productos_hstore WHERE nombre = 'Teclado';")
    assert result[0][0] is None

# --- Pruebas HSTORE (Intermedias) ---

def test_hstore_query_contiene_marca():
    # I-1: Contiene clave 'marca'
    result = run_query("SELECT * FROM productos_hstore WHERE atributos ? 'marca';")
    assert len(result) == 5 # Todos menos 'Camisa'

def test_hstore_query_combinada():
    # I-2: Combinar (marca=Sony y precio > 500)
    result = run_query("SELECT * FROM productos_hstore WHERE atributos->'marca' = 'Sony' AND precio > 500;")
    assert len(result) == 1 # Solo Laptop

def test_hstore_query_contar_color():
    # I-4: Contar cuántos tienen 'color'
    # Nota: El test B-5 borró un color, así que el total baja.
    result = run_query("SELECT COUNT(*) FROM productos_hstore WHERE atributos ? 'color';")
    assert result[0][0] == 5 

# --- Pruebas HSTORE (Avanzadas) ---
    
def test_hstore_query_agrupar_marca():
    # A-2: Agrupar por marca
    result = run_query("SELECT atributos->'marca' AS marca, COUNT(*) FROM productos_hstore WHERE atributos ? 'marca' GROUP BY marca ORDER BY marca;")
    assert ('LG', 1) in result
    assert ('Logitech', 1) in result
    assert ('Samsung', 1) in result
    assert ('Sony', 2) in result

def test_hstore_query_multiples_claves():
    # A-4: Validar (color Y peso)
    result = run_query("SELECT * FROM productos_hstore WHERE atributos ?& ARRAY['color', 'peso'];")
    assert len(result) == 1 # Solo 'Laptop' (después de la actualización B-4)

def test_hstore_funcion_resumen():
    # A-5: Probar la función
    run_query("""
        CREATE OR REPLACE FUNCTION resumir_producto(p_nombre TEXT, p_atributos HSTORE)
        RETURNS TEXT AS $$
        BEGIN
            RETURN 'Producto ' || p_nombre || ': marca=' || COALESCE(p_atributos->'marca', 'N/A') || ', color=' || COALESCE(p_atributos->'color', 'N/A');
        END;
        $$ LANGUAGE plpgsql;
    """, fetch=False)
    result = run_query("SELECT resumir_producto(nombre, atributos) FROM productos_hstore WHERE nombre = 'Laptop';")
    assert result[0][0] == 'Producto Laptop: marca=Sony, color=plata'
