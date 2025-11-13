import uuid
import psycopg2
import decimal

DEC = decimal.Decimal

def connect():
    return psycopg2.connect(
        dbname='test_db', user='postgres', password='postgres',
        host='localhost', port='5432'
    )

def make_tmp(cur, nombre, precio, hs_pairs):
    cur.execute(
        "INSERT INTO productos_hs(nombre, precio, atributos) VALUES (%s,%s,%s) RETURNING id;",
        (nombre, DEC(precio), hs_pairs)
    )
    return cur.fetchone()[0]

def test_b1_query_color_rojo():
    conn = connect(); cur = conn.cursor()
    cur.execute("""
      SELECT nombre FROM productos_hs
      WHERE atributos -> 'color' = 'rojo'
      ORDER BY nombre;
    """)
    nombres = [r[0] for r in cur.fetchall()]
    assert 'Cámara Sony Alpha' in nombres
    # Bocina perdió "color" en 08_hstore_update_delete.sql; aceptamos que quizá no aparezca.
    cur.close(); conn.close()

def test_b2_update_weight_and_delete_color_are_possible():
    conn = connect(); cur = conn.cursor()
    tmp_name = f"TMP_{uuid.uuid4().hex[:6]}"
    pid = make_tmp(cur, tmp_name, '10.00', 'marca => Tmp, color => verde, peso => 1kg')
    conn.commit()

    # update peso
    cur.execute("""
      UPDATE productos_hs
      SET atributos = atributos || 'peso => 2kg'
      WHERE id = %s;
    """, (pid,))
    conn.commit()
    cur.execute("SELECT atributos -> 'peso' FROM productos_hs WHERE id = %s;", (pid,))
    assert cur.fetchone()[0] == '2kg'

    # delete color
    cur.execute("UPDATE productos_hs SET atributos = delete(atributos, 'color') WHERE id = %s;", (pid,))
    conn.commit()
    cur.execute("SELECT (atributos ? 'color') FROM productos_hs WHERE id = %s;", (pid,))
    assert cur.fetchone()[0] is False

    cur.execute("DELETE FROM productos_hs WHERE id = %s;", (pid,))
    conn.commit(); cur.close(); conn.close()

def test_i1_has_key_marca():
    conn = connect(); cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM productos_hs WHERE atributos ? 'marca';")
    assert cur.fetchone()[0] >= 5
    cur.close(); conn.close()

def test_i2_combine_with_columns():
    conn = connect(); cur = conn.cursor()
    cur.execute("""
      SELECT nombre FROM productos_hs
      WHERE atributos -> 'marca' = 'Sony' AND precio > 500;
    """)
    resultados = {r[0] for r in cur.fetchall()}
    assert 'Televisor Sony 55' in resultados or 'Cámara Sony Alpha' in resultados
    cur.close(); conn.close()

def test_i3_skeys_svals_and_count_attr_color():
    conn = connect(); cur = conn.cursor()
    cur.execute("""
      SELECT skeys(atributos), svals(atributos)
      FROM productos_hs
      WHERE nombre = 'Televisor Sony 55';
    """)
    rows = cur.fetchall()
    assert rows  # debe devolver claves/valores
    cur.execute("SELECT COUNT(*) FROM productos_hs WHERE atributos ? 'color';")
    assert cur.fetchone()[0] >= 3
    cur.close(); conn.close()

def test_a1_index_gin_explain_mentions_index():
    conn = connect(); cur = conn.cursor()
    cur.execute("""
      EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
      SELECT id FROM productos_hs WHERE atributos -> 'color' = 'rojo';
    """)
    plan = "\n".join(r[0] for r in cur.fetchall())
    assert 'productos_hs_atributos_gin' in plan  # creado en 13_hstore_index_gin.sql
    cur.close(); conn.close()

def test_a2_aggregations_by_brand():
    conn = connect(); cur = conn.cursor()
    cur.execute("""
      SELECT (atributos -> 'marca') AS marca, COUNT(*)
      FROM productos_hs
      GROUP BY (atributos -> 'marca')
      ORDER BY COUNT(*) DESC;
    """)
    rows = cur.fetchall()
    assert rows and any(r[0] is not None for r in rows)
    cur.close(); conn.close()

def test_a3_json_conversion_roundtrip():
    conn = connect(); cur = conn.cursor()
    cur.execute("SELECT hstore_to_json(atributos)::text FROM productos_hs LIMIT 1;")
    assert cur.fetchone()[0].startswith('{')
    cur.execute("SELECT hstore('{\"a\"=>\"1\"}')::text;")
    assert '=>"1"' in cur.fetchone()[0]
    cur.close(); conn.close()

def test_a4_multi_keys_check():
    conn = connect(); cur = conn.cursor()
    cur.execute("""
      SELECT COUNT(*) FROM productos_hs
      WHERE atributos ?& ARRAY['color','peso'];
    """)
    assert cur.fetchone()[0] >= 2
    cur.close(); conn.close()

def test_a5_summary_function():
    conn = connect(); cur = conn.cursor()
    cur.execute("SELECT id FROM productos_hs WHERE nombre = 'Televisor Sony 55';")
    pid = cur.fetchone()[0]
    cur.execute("SELECT fn_resumen_producto_hs(%s);", (pid,))
    s = cur.fetchone()[0]
    assert 'Producto' in s and 'marca=' in s
    cur.close(); conn.close()
