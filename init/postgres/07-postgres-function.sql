-- Colocar todas las FUNCIONES

-- Funcion para obtener la dificultad del mapa
CREATE OR REPLACE FUNCTION obtener_dificultad_mapa(p_id INT) RETURNS VARCHAR(20) AS $$
BEGIN
    RETURN (SELECT dificultad FROM mapas WHERE id = p_id);
END;
$$ LANGUAGE plpgsql;

-- Insertar datos de prueba mínimos
INSERT INTO mapas (id, nombre, dificultad) VALUES 
    (1, 'Bosque Maldito', 'Media'),
    (2, 'Cueva del Terror', 'Difícil');

INSERT INTO jugadores (id, nivel) VALUES (1, 5);

INSERT INTO misiones (id, titulo, nivel_recomendado, mapa_id) VALUES 
    (1, 'Explorar Bosque', 4, 1),
    (2, 'Derrotar Jefe', 6, 2);

INSERT INTO jefe_zombi (id, mapa_id) VALUES (1, 1), (2, 1);

INSERT INTO jugador_mision (jugador_id, mision_id, estado) VALUES (1, 1, 'completada');

-- Probar obtener_dificultad_mapa
SELECT obtener_dificultad_mapa(1) AS dificultad;
SELECT obtener_dificultad_mapa(999) AS no_existe;



-- Funcion para ver si si un mapa es dificil
CREATE OR REPLACE FUNCTION es_mapa_dificil(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (SELECT dificultad = 'Difícil' FROM mapas WHERE id = p_id);
END;
$$ LANGUAGE plpgsql;
-- Probar es_mapa_dificil
SELECT es_mapa_dificil(2) AS es_dificil;
SELECT es_mapa_dificil(1) AS no_dificil;





CREATE OR REPLACE PROCEDURE analizar_encuentros_jefes()
LANGUAGE plpgsql AS $$
BEGIN
    SELECT mp.nombre AS mapa, mp.dificultad, COUNT(jz.id) AS conteo_jefes
    FROM mapas mp
    LEFT JOIN jefe_zombi jz ON mp.id = jz.mapa_id
    GROUP BY mp.nombre, mp.dificultad
    ORDER BY conteo_jefes DESC;
END;
$$;

-- Probar analizar_encuentros_jefes
CALL analizar_encuentros_jefes();




CREATE OR REPLACE FUNCTION sugerir_misiones(p_jugador_id INT)
RETURNS TABLE (mision_id INT, titulo VARCHAR(100), nivel_recomendado INT, dificultad_mapa VARCHAR(20)) AS $$
DECLARE
    nivel_jugador INT;
BEGIN
    SELECT nivel INTO nivel_jugador FROM jugadores WHERE id = p_jugador_id;
    RETURN QUERY
    SELECT m.id, m.titulo, m.nivel_recomendado, mp.dificultad
    FROM misiones m
    JOIN mapas mp ON m.mapa_id = mp.id
    WHERE m.nivel_recomendado BETWEEN nivel_jugador - 2 AND nivel_jugador + 2
    AND m.id NOT IN (SELECT mision_id FROM jugador_mision WHERE jugador_id = p_jugador_id AND estado = 'completada');
END;
$$ LANGUAGE plpgsql;

-- Probar sugerir_misiones
SELECT * FROM sugerir_misiones(1);

