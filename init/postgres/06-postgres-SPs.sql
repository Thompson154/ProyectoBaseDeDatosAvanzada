-- Colocar todos los SP

-- SP para agregar mapas en algun futuro
CREATE OR REPLACE PROCEDURE agregar_mapa(
    p_nombre VARCHAR(50),
    p_zona VARCHAR(50),
    p_dificultad VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    BEGIN
        INSERT INTO mapas (nombre, zona, dificultad)
        VALUES (p_nombre, p_zona, p_dificultad);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Error al agregar mapa: %', SQLERRM;
    END;
END;
$$;

-- Llamar al procedimiento para agregar un mapa
CALL agregar_mapa('Bosque Oscuro', 'Zona Norte', 'Media');

-- Verificar resultado
SELECT * FROM mapas WHERE nombre = 'Bosque Oscuro';

-- Probar con un caso de error (por ejemplo, nombre demasiado largo si hay restricción)
-- CALL agregar_mapa('NombreQueExcedeElLimiteDeCaracteresParaProbarError', 'Zona Sur', 'Alta');




-- SP para actualizar la dificultad del mapa 
CREATE OR REPLACE PROCEDURE actualizar_dificultad_mapa(
    p_id INT,
    p_dificultad VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    BEGIN
        UPDATE mapas
        SET dificultad = p_dificultad
        WHERE id = p_id;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE NOTICE 'Error al actualizar dificultad: %', SQLERRM;
    END;
END;
$$;

-- Insertar un mapa de prueba
INSERT INTO mapas (nombre, zona, dificultad) VALUES ('Cueva Profunda', 'Zona Este', 'Baja') RETURNING id;

-- Obtener el ID del mapa insertado (suponiendo que el ID es 1 para el ejemplo)
CALL actualizar_dificultad_mapa(1, 'Alta');

-- Verificar resultado
-- SELECT * FROM mapas WHERE id = 1;

-- Probar con un ID no existente para verificar manejo de errores
-- CALL actualizar_dificultad_mapa(999, 'Media');



-- SP para Actualizar Estado de Misión
CREATE OR REPLACE PROCEDURE actualizar_estado_mision(
    p_jugador_id INT,
    p_mision_id INT,
    p_estado VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE jugador_mision
    SET estado = p_estado, fecha_fin = CASE WHEN p_estado = 'completada' THEN NOW() ELSE fecha_fin END
    WHERE jugador_id = p_jugador_id AND mision_id = p_mision_id;
    IF p_estado = 'completada' THEN
        UPDATE jugadores
        SET nivel = nivel + 1
        WHERE id = p_jugador_id;
    END IF;
END;
$$;

-- comprobacion de funcionamiento de actualizar_estado_mision
CALL actualizar_estado_mision(1, 1, 'completada');
SELECT nivel FROM jugadores WHERE id = 1;

-- SP para Generar Trampa en Mapa
CREATE OR REPLACE PROCEDURE generar_trampa_mapa(
    p_mapa_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_jefe_id INT;
BEGIN
    INSERT INTO jefe_zombi (nombre, mapa_id, habilidad_especial)
    VALUES ('Trampa Zombi', p_mapa_id, 'Embestida')
    RETURNING id INTO v_jefe_id;
    UPDATE jugador_mision
    SET estado = 'peligro'
    WHERE mision_id IN (SELECT id FROM misiones WHERE mapa_id = p_mapa_id) AND estado = 'en progreso';
END;
$$;

-- comprobacion de funcionamiento de generar_trampa_mapa
INSERT INTO jugador_mision (jugador_id, mision_id, estado, fecha_inicio)
VALUES (1, 1, 'en progreso', NOW());
CALL generar_trampa_mapa(1);
SELECT estado FROM jugador_mision WHERE jugador_id = 1 AND mision_id = 1;