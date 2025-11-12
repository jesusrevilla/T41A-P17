import psycopg2
import pytest
from psycopg2.extras import register_hstore

# Configuración de la base de datos de PRUEBA
DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

@pytest.fixture
def db_cursor():
    """
    Fixture de Pytest que gestiona la conexión Y
    ASEGURA QUE LAS TABLAS ESTÉN LIMPIAS antes de cada prueba.
    """
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        register_hstore(conn)
        cur = conn.cursor()

        # Vacía las tablas antes de que la prueba comience
        # RESTART IDENTITY reinicia los contadores SERIAL (buena práctica)
        cur.execute("TRUNCATE TABLE productos, productos2 RESTART IDENTITY;")
        
        yield cur
        
    finally:
        if conn:
            conn.rollback()  # Deshace lo que la prueba haya hecho
            conn.close()

# --- Pruebas Unitarias ---

def test_insertar_y_consultar_por_clave_rojo(db_cursor):
    """
    Prueba Req 2 (Insertar) y Req 3 (Consultar por color='rojo')
    """
    # 1. Preparación (Insertar registros, AHORA CON PRECIO)
    # Datos actualizados para coincidir con tu SQL
    productos_data = [
        ('Sony WH-1000XM4', 550.00, {"marca":"Sony", "peso":"2.5", "color":"negro", "tipo":"Audífonos", "bluetooth":"true"}),
        ('Oster Licuadora', 89.50, {"marca":"Oster", "peso":"3.1", "color":"rojo", "tipo":"Licuadora", "velocidades":"5"}),
        ('Logitech G Pro', 129.99, {"marca":"Logitech", "peso":"0.15", "color":"blanco", "tipo":"Mouse", "dpi":"16000"}),
        ('Nike Air Max', 150.00, {"marca":"Nike", "peso":"0.8", "color":"rojo", "tipo":"Zapatillas", "talla":"US 10"}),
        ('IKEA Micke', 79.00, {"marca":"IKEA", "peso":"15.0", "color":"rojo", "tipo":"Escritorio", "dimensiones":"120x60cm"})
    ]
    
    # NUEVO: Se añade 'precio' a la consulta INSERT
    insert_query = "INSERT INTO productos2 (nombre, precio, atributos) VALUES (%s, %s, %s)"
    db_cursor.executemany(insert_query, productos_data)

    # 2. Ejecución (Esta parte no cambia)
    query = "SELECT nombre FROM productos2 WHERE atributos -> 'color' = 'rojo'"
    db_cursor.execute(query)
    resultados = db_cursor.fetchall()

    # 3. Validación (Esta parte no cambia)
    assert len(resultados) == 3
    nombres_encontrados = {row[0] for row in resultados}
    assert nombres_encontrados == {'Oster Licuadora', 'Nike Air Max', 'IKEA Micke'}

def test_actualizar_valor_en_hstore(db_cursor):
    """
    Prueba Req 4 (Actualizar 'peso' del escritorio IKEA)
    """
    # 1. Preparación (Insertar el producto a modificar, AHORA CON PRECIO)
    ikea_attrs = {"marca":"IKEA", "peso":"15.0", "color":"rojo", "tipo":"Escritorio", "dimensiones":"120x60cm"}
    
    # NUEVO: Se añade 'precio' (79.00) a la consulta INSERT
    db_cursor.execute(
        "INSERT INTO productos2 (nombre, precio, atributos) VALUES (%s, %s, %s) RETURNING id",
        ('IKEA Micke', 79.00, ikea_attrs)
    )
    producto_id = db_cursor.fetchone()[0]

    # 2. Ejecución (Esta parte no cambia)
    update_hstore_string = '"peso" => "17.5"'
    
    db_cursor.execute(
        "UPDATE productos2 SET atributos = atributos || %s WHERE id = %s",
        (update_hstore_string, producto_id)
    )

    # 3. Validación (Esta parte no cambia)
    db_cursor.execute("SELECT atributos FROM productos2 WHERE id = %s", (producto_id,))
    atributos_actualizados = db_cursor.fetchone()[0]
    
    assert atributos_actualizados['peso'] == '17.5'
    assert atributos_actualizados['color'] == 'rojo' 

def test_eliminar_clave_de_hstore(db_cursor):
    """
    Prueba Req 5 (Eliminar 'color' de la licuadora Oster)
    """
    # 1. Preparación (Insertar el producto a modificar, AHORA CON PRECIO)
    oster_attrs = {"marca":"Oster", "peso":"3.1", "color":"rojo", "tipo":"Licuadora", "velocidades":"5"}

    # NUEVO: Se añade 'precio' (89.50) a la consulta INSERT
    db_cursor.execute(
        "INSERT INTO productos2 (nombre, precio, atributos) VALUES (%s, %s, %s) RETURNING id",
        ('Oster Licuadora', 89.50, oster_attrs)
    )
    producto_id = db_cursor.fetchone()[0]

    # 2. Ejecución (Esta parte no cambia)
    db_cursor.execute(
        "UPDATE productos2 SET atributos = delete(atributos, 'color') WHERE id = %s",
        (producto_id,)
    )

    # 3. Validación (Esta parte no cambia)
    db_cursor.execute("SELECT atributos FROM productos2 WHERE id = %s", (producto_id,))
    atributos_actualizados = db_cursor.fetchone()[0]

    assert 'color' not in atributos_actualizados
    assert 'marca' in atributos_actualizados
    assert atributos_actualizados['tipo'] == 'Licuadora'
    assert atributos_actualizados['peso'] == '3.1'
