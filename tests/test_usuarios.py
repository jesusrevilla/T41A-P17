import psycopg2

def run_query(query):
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="postgres",
        host="localhost"
    )
    cur = conn.cursor()
    cur.execute(query)
    result = cur.fetchall()
    conn.close()
    return result

def test_marca_laptop():
    result = run_query("SELECT atributos -> 'marca' FROM productos WHERE nombre = 'Laptop';")
    assert result[0][0] == "Dell"

def test_color_telefono():
    result = run_query("SELECT atributos -> 'color' FROM productos WHERE nombre = 'Teléfono';")
    assert result[0][0] == "azul"

def test_ram_laptop_actualizada():
    result = run_query("SELECT atributos -> 'ram' FROM productos WHERE nombre = 'Laptop';")
    assert result[0][0] == "32GB"
