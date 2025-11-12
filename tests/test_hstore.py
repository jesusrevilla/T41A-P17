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
    Fixture de Pytest para gestionar la conexión y transacciones de la BD.

    - Se conecta ANTES de cada prueba.
    - ¡Registra el adaptador HSTORE!
    - Entrega (yield) el cursor.
    - Hace un ROLLBACK DESPUÉS de cada prueba para limpiar la BD.
    """
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        
        # --- ¡IMPORTANTE PARA HSTORE! ---
        # Registra el adaptador para poder leer y escribir
        # HSTORE como si fueran diccionarios de Python.
        register_hstore(conn)
        
        cur = conn.cursor()
        yield cur
        
    finally:
        if conn:
            conn.rollback()  # ¡La parte clave! Limpia la BD.
            conn.close()

# --- Pruebas Unitarias ---

def test_insertar_y_consultar_por_clave_rojo(db_cursor):
    """
    Prueba la inserción de múltiples productos (Req 2) y 
    la consulta por una clave específica (Req 3).
    """
    # 1. Preparación (Insertar registros)
    productos_data = [
        ('Sony', 2.5, {"color": "Negro", "tipo": "Audífonos", "bluetooth": "true"}),
        ('Oster', 3.1, {"color": "Rojo", "tipo": "Licuadora", "velocidades": "5"}),
        ('Logitech', 0.15, {"color": "Blanco", "tipo": "Mouse", "dpi": "16000"}),
        ('Nike', 0.8, {"color": "Rojo", "tipo": "Zapatillas", "talla": "US 10"}),
        ('IKEA', 15.0, {"color": "Rojo", "tipo": "Escritorio", "dimensiones": "120x60cm"})
    ]
    # Usa la nueva tabla 'productos2'
    insert_query = "INSERT INTO productos2 (nombre, peso, atributos_adicionales) VALUES (%s, %s, %s)"
    db_cursor.executemany(insert_query, productos_data)

    # 2. Ejecución (Consultar por color 'Rojo')
    # Usa la nueva tabla 'productos2'
    query = "SELECT nombre FROM productos2 WHERE atributos_adicionales -> 'color' = 'Rojo'"
    db_cursor.execute(query)
    resultados = db_cursor.fetchall()

    # 3. Validación (Assert)
    assert len(resultados) == 3
    nombres_encontrados = {row[0] for row in resultados}
    assert nombres_encontrados == {'Oster', 'Nike', 'IKEA'}

def test_actualizar_valor_en_hstore(db_cursor):
    """
    Prueba la actualización de un valor dentro del HSTORE (Req 4).
    """
    # 1. Preparación (Insertar el producto a modificar)
    ikea_attrs = {"color": "Rojo", "tipo": "Escritorio", "peso": "68kg"}
    db_cursor.execute(
        # Usa la nueva tabla 'productos2'
        "INSERT INTO productos2 (nombre, atributos_adicionales) VALUES (%s, %s) RETURNING id",
        ('IKEA', ikea_attrs)
    )
    producto_id = db_cursor.fetchone()[0]

    # 2. Ejecución (Actualizar el 'peso' usando la sintaxis de string HSTORE)
    update_hstore_string = 'peso => 79kg'
    
    db_cursor.execute(
        # Usa la nueva tabla 'productos2'
        "UPDATE productos2 SET atributos_adicionales = atributos_adicionales || %s WHERE id = %s",
        (update_hstore_string, producto_id)
    )

    # 3. Validación (Assert)
    # Usa la nueva tabla 'productos2'
    db_cursor.execute("SELECT atributos_adicionales FROM productos2 WHERE id = %s", (producto_id,))
    atributos_actualizados = db_cursor.fetchone()[0]
    
    assert atributos_actualizados['peso'] == '79kg'
    assert atributos_actualizados['color'] == 'Rojo' 

def test_eliminar_clave_de_hstore(db_cursor):
    """
    Prueba la eliminación de una clave de un registro (Req 5).
    """
    # 1. Preparación (Insertar el producto a modificar)
    oster_attrs = {"color": "Rojo", "tipo": "Licuadora", "material_vaso": "Vidrio"}
    db_cursor.execute(
        # Usa la nueva tabla 'productos2'
        "INSERT INTO productos2 (nombre, atributos_adicionales) VALUES (%s, %s) RETURNING id",
        ('Oster', oster_attrs)
    )
    producto_id = db_cursor.fetchone()[0]

    # 2. Ejecución (Eliminar el atributo 'material_vaso' como en tu SQL)
    db_cursor.execute(
        # Usa la nueva tabla 'productos2'
        "UPDATE productos2 SET atributos_adicionales = delete(atributos_adicionales, 'material_vaso') WHERE id = %s",
        (producto_id,)
    )

    # 3. Validación (Assert)
    # Usa la nueva tabla 'productos2'
    db_cursor.execute("SELECT atributos_adicionales FROM productos2 WHERE id = %s", (producto_id,))
    atributos_actualizados = db_cursor.fetchone()[0]

    # Verificar que 'material_vaso' ya no está en el diccionario
    assert 'material_vaso' not in atributos_actualizados
    # Verificar que las otras claves siguen presentes
    assert 'tipo' in atributos_actualizados
    assert atributos_actualizados['color'] == 'Rojo'
