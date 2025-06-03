-- Colocar todas las FUNCIONES

-- Funcion para obtener la dificultad del mapa
CREATE OR REPLACE FUNCTION obtener_dificultad_mapa(p_id INT) RETURNS VARCHAR(20) AS $$
BEGIN
    RETURN (SELECT dificultad FROM mapas WHERE id = p_id);
END;
$$ LANGUAGE plpgsql;

-- Funcion para ver si si un mapa es dificil
CREATE OR REPLACE FUNCTION es_mapa_dificil(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (SELECT dificultad = 'Difícil' FROM mapas WHERE id = p_id);
END;
$$ LANGUAGE plpgsql;

--Funcion para sugerir_misiones
CREATE OR REPLACE FUNCTION sugerir_misiones(p_jugador_id INT)
RETURNS TABLE (mision_id INT, titulo VARCHAR(100), nivel_recomendado INT, dificultad_mapa VARCHAR(20)) AS $$
DECLARE
    nivel_jugador INT;
BEGIN
    SELECT nivel INTO nivel_jugador
    FROM jugadores
    WHERE id = p_jugador_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Jugador con ID % no encontrado', p_jugador_id;
    END IF;

    IF nivel_jugador IS NULL THEN
        RAISE EXCEPTION 'El nivel del jugador con ID % es nulo', p_jugador_id;
    END IF;

    RETURN QUERY
    SELECT m.id, m.titulo, m.nivel_recomendado, mp.dificultad
    FROM misiones m
    JOIN mapas mp ON m.mapa_id = mp.id
    WHERE m.nivel_recomendado BETWEEN GREATEST(1, nivel_jugador - 2) AND nivel_jugador + 2
    AND NOT EXISTS (
        SELECT 1
        FROM jugador_mision jm
        WHERE jm.mision_id = m.id
        AND jm.jugador_id = p_jugador_id
        AND jm.estado = 'completada'
    )
    ORDER BY m.nivel_recomendado;
END;
$$ LANGUAGE plpgsql;


--Funcion para contar jugadores activos
CREATE OR REPLACE FUNCTION contar_jugadores_activos()
RETURNS INT AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM jugadores WHERE estado = 'activo');
END;
$$ LANGUAGE plpgsql;


--Funcion para obtener recompensas de mision
CREATE OR REPLACE FUNCTION obtener_recompensa_mision(p_mision_id INT)
RETURNS TEXT AS $$
BEGIN
    RETURN (SELECT recompensa FROM misiones WHERE id = p_mision_id);
END;
$$ LANGUAGE plpgsql;



-- Total de enemigos derrotados por un jugador en todas sus partidas
CREATE OR REPLACE FUNCTION total_enemigos_derrotados_por_jugador(p_jugador_id INT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COALESCE(SUM(enemigos_derrotados), 0)
    INTO total
    FROM partidas
    WHERE jugador_id = p_jugador_id;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

