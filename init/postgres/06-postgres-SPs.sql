-- Colocar todos los SP

-- SP para agregar mapas en algun futuro
CREATE OR REPLACE PROCEDURE agregar_mapa(
    p_nombre VARCHAR(50),
    p_zona VARCHAR(50),
    p_dificultad VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre del mapa no puede ser nulo o vacío';
    END IF;
    IF p_zona IS NULL OR p_zona = '' THEN
        RAISE EXCEPTION 'La zona del mapa no puede ser nula o vacía';
    END IF;
    IF p_dificultad NOT IN ('Facil', 'Medio', 'Dificil') THEN
        RAISE EXCEPTION 'La dificultad debe ser fácil, medio o difícil';
    END IF;

    INSERT INTO mapas (nombre, zona, dificultad)
    VALUES (p_nombre, p_zona, p_dificultad);

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'El mapa con nombre % ya existe', p_nombre;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al agregar mapa: %', SQLERRM;
END;
$$;

-- SP para actualizar la dificultad del mapa 
CREATE OR REPLACE PROCEDURE actualizar_dificultad_mapa(
    p_id INT,
    p_dificultad VARCHAR(20)
)
LANGUAGE plpgsql AS $$
DECLARE
    filas_afectadas INT;
BEGIN
    IF p_id IS NULL THEN
        RAISE EXCEPTION 'El ID del mapa no puede ser nulo';
    END IF;
    IF p_dificultad IS NULL OR p_dificultad = '' THEN
        RAISE EXCEPTION 'La dificultad no puede ser nula o vacía';
    END IF;
    IF p_dificultad NOT IN ('Facil', 'Medio', 'Dificil') THEN
        RAISE EXCEPTION 'La dificultad debe ser fácil, medio o difícil';
    END IF;

    UPDATE mapas
    SET dificultad = p_dificultad
    WHERE id = p_id;
END;
$$;


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

-- SP para generar enemigos en cierto mapa
CREATE OR REPLACE PROCEDURE generar_enemigo_mapa(
    p_mapa_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO enemigos (nombre, tipo, nivel, vida, es_jefe, mapa_id)
    VALUES ('Zombi_' || (SELECT nextval('enemigos_id_seq')), 'Caminante', 1, 100, FALSE, p_mapa_id);
END;
$$;

--SP para agregar Items al Inventario
CREATE OR REPLACE PROCEDURE agregar_item_inventario(
    p_jugador_id INT,
    p_item_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO inventario (jugador_id, item_id, cantidad, durabilidad_actual)
    SELECT p_jugador_id, p_item_id, 1, i.durabilidad_max
    FROM items i
    WHERE i.id = p_item_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Item % no encontrado', p_item_id;
    END IF;
END;
$$;

