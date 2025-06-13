-- ----------------- SPs para MariaDB------------------------

-- ---- SP para generar Combo de Combate------------------
-- DELIMITER //
-- CREATE PROCEDURE generar_combo_combate(
--     IN p_jugador_id INT,
--     IN p_enemigo_id INT,
--     IN p_arma_id INT,
--     IN p_num_combates INT
-- )
-- BEGIN
--     DECLARE i INT DEFAULT 0;
--     WHILE i < p_num_combates DO
--         INSERT INTO log_combate (jugador_id, enemigo_id, arma_id, dano_infligido, dano_recibido, fecha_combate)
--         VALUES (p_jugador_id, p_enemigo_id, p_arma_id, 100, 20, NOW());
--         SET i = i + 1;
--     END WHILE;
--     IF p_num_combates >= 3 THEN
--         INSERT INTO progreso_habilidad (jugador_id, habilidad_id, nivel, experiencia)
--         VALUES (p_jugador_id, p_arma_id, 1, 100)
--         ON DUPLICATE KEY UPDATE experiencia = experiencia + 100;
--     END IF;
-- END //
-- DELIMITER ;

-- -------- SP para mejorar Arma con Drops
-- DELIMITER //
-- CREATE PROCEDURE mejorar_arma(
--     IN p_jugador_id INT,
--     IN p_drop_arma_id INT,
--     IN p_drop_material_id INT,
--     IN p_new_item_id INT
-- )
-- BEGIN
--     DECLARE drop_count INT;
--     SELECT COUNT(*) INTO drop_count
--     FROM drops
--     WHERE jugador_id = p_jugador_id AND id IN (p_drop_arma_id, p_drop_material_id);
--     IF drop_count = 2 THEN
--         UPDATE drops SET item_id = p_new_item_id WHERE id = p_drop_arma_id;
--         DELETE FROM drops WHERE id = p_drop_material_id;
--     ELSE
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drops inválidos para mejora';
--     END IF;
-- END //
-- DELIMITER ;


-- -- SP de otorgar_recompensas_eventos
-- DELIMITER //
-- CREATE PROCEDURE otorgar_recompensas_eventos(IN p_jugador_id INT, IN p_item_id INT)
-- BEGIN
--     DECLARE conteo_eventos INT;
--     SELECT COUNT(*) INTO conteo_eventos
--     FROM recompensa_evento
--     WHERE jugador_id = p_jugador_id;
--     IF conteo_eventos >= 3 THEN
--         INSERT INTO drops (item_id, jugador_id, evento_id, fecha_drop)
--         SELECT p_item_id, p_jugador_id, MAX(evento_id), NOW()
--         FROM recompensa_evento
--         WHERE jugador_id = p_jugador_id;
--     END IF;
-- END //
-- DELIMITER ;


-- Podemos insertar un nuevo evento zombie enviando en los parametros donde este se crea el evento zombie y este se relaciona insertando
-- en la tabla de partidas 
-- DELIMITER $$

-- CREATE PROCEDURE insertar_evento_con_partida(
--     IN p_nombre_evento VARCHAR(100),
--     IN p_tipo_evento VARCHAR(30),
--     IN p_jugador_id INT
-- )
-- BEGIN
--     DECLARE v_evento_id INT;
--     INSERT INTO eventos_zombi(nombre_evento, tipo_evento, fecha_inicio, fecha_fin, activo)
--     VALUES (p_nombre_evento, p_tipo_evento, NOW(), NOW() + INTERVAL 2 DAY, TRUE);

--     SET v_evento_id = LAST_INSERT_ID();

--     -- Crear partida relacionada
--     INSERT INTO partidas(jugador_id, fecha_inicio, fecha_fin, resultado, enemigos_derrotados, evento_id)
--     VALUES (p_jugador_id, NOW(), NOW() + INTERVAL 30 MINUTE, 'pendiente', 0, v_evento_id);
-- END$$

-- DELIMITER ;