-- Funcion de otorgar_recompensas_eventos
DELIMITER //
CREATE PROCEDURE otorgar_recompensas_eventos(IN p_jugador_id INT, IN p_item_id INT)
BEGIN
    DECLARE conteo_eventos INT;
    SELECT COUNT(*) INTO conteo_eventos
    FROM recompensa_evento
    WHERE jugador_id = p_jugador_id;
    IF conteo_eventos >= 3 THEN
        INSERT INTO drops (item_id, jugador_id, evento_id, fecha_drop)
        SELECT p_item_id, p_jugador_id, MAX(evento_id), NOW()
        FROM recompensa_evento
        WHERE jugador_id = p_jugador_id;
    END IF;
END //
DELIMITER ;

-- Insertar datos de prueba
INSERT INTO recompensa_evento (jugador_id, evento_id) VALUES (1, 1), (1, 2), (1, 3);

-- Llamar al procedimiento
CALL otorgar_recompensas_eventos(1, 10);


-- Probar obtener_exp_para_siguiente_nivel

DELIMITER //
CREATE FUNCTION obtener_exp_para_siguiente_nivel(p_jugador_id INT, p_habilidad_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nivel_actual INT;
    DECLARE exp_actual INT;
    DECLARE exp_necesaria INT;
    SELECT nivel, experiencia INTO nivel_actual, exp_actual
    FROM progreso_habilidad
    WHERE jugador_id = p_jugador_id AND habilidad_id = p_habilidad_id;
    SET exp_necesaria = (nivel_actual * 1000) - exp_actual; -- Ejemplo: 1000 EXP por nivel
    RETURN IF(exp_necesaria < 0, 0, exp_necesaria);
END //
DELIMITER ;

-- Insertar datos de prueba
INSERT INTO progreso_habilidad (jugador_id, habilidad_id, nivel, experiencia) 
VALUES (1, 1, 2, 1500);

-- Llamar a la función
SELECT obtener_exp_para_siguiente_nivel(1, 1) AS exp_necesaria;