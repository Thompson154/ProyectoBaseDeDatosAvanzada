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

