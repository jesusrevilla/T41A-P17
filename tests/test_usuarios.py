import psycopg2
import pytest

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
######################################################################################
def test_color_producto_1():
    result = run_query("SELECT especificaciones->>'color' FROM productos WHERE id = 1;")
    print(f"resultado del query: {result}")
    assert result[0][0] == "Verde"

def test_categoria_producto_3():
    result = run_query("SELECT especificaciones->>'Categoría' FROM productos WHERE id = 3;")
    assert result[0][0] == "Ocio"

def test_tamano_producto_5():
    result = run_query("SELECT especificaciones->>'Tamaño' FROM productos WHERE id = 5;")
    assert result[0][0] == "Enorme"

def test_marca_producto1_id2():
    result = run_query("SELECT atributos->'marca' FROM productos1 WHERE id = 2;")
    assert result[0][0] == "Apple"

def test_color_producto1_id4():
    result = run_query("SELECT atributos->'color' FROM productos1 WHERE id = 4;")
    assert result[0][0] == "rojo"

def test_producto1_tiene_color_y_peso():
    result = run_query("""
        SELECT COUNT(*) 
        FROM productos1 
        WHERE atributos ?& ARRAY['color','peso'];
    """)
    assert result[0][0] == 4

def test_hstore_convertido_a_json():
    result = run_query("SELECT hstore_to_json(atributos)::text FROM productos1 WHERE id = 1;")
    assert '"marca": "Dell"' in result[0][0]

def test_hstore_clave_marca_existe():
    result = run_query("SELECT atributos ? 'marca' FROM productos1 LIMIT 1;")
    assert result[0][0] is True

def test_resumen_producto_funcion():
    result = run_query("""
        SELECT resumen_producto(atributos)
        FROM productos1
        WHERE id = 1;
    """)
    esperado = "Producto: marca=Dell, color=negro, peso=10kg"
    assert result[0][0] == esperado


