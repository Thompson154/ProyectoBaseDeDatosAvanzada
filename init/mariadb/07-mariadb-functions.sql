--Funciones

-- DELIMITER //
-- CREATE FUNCTION obtener_exp_para_siguiente_nivel(p_jugador_id INT, p_habilidad_id INT)
-- RETURNS INT
-- DETERMINISTIC
-- BEGIN
--     DECLARE nivel_actual INT;
--     DECLARE exp_actual INT;
--     DECLARE exp_necesaria INT;
--     SELECT nivel, experiencia INTO nivel_actual, exp_actual
--     FROM progreso_habilidad
--     WHERE jugador_id = p_jugador_id AND habilidad_id = p_habilidad_id;
--     SET exp_necesaria = (nivel_actual * 1000) - exp_actual; -- Ejemplo: 1000 EXP por nivel
--     RETURN IF(exp_necesaria < 0, 0, exp_necesaria);
-- END //
-- DELIMITER ;


-- Calcula el total de enemmigos
-- DELIMITER $$

-- CREATE FUNCTION total_enemigos_derrotados(p_jugador_id INT)
-- RETURNS INT
-- DETERMINISTIC
-- BEGIN
--     DECLARE total INT;
--     SELECT SUM(enemigos_derrotados) INTO total
--     FROM partidas
--     WHERE jugador_id = p_jugador_id;
--     RETURN IFNULL(total, 0);
-- END$$

-- DELIMITER ;
