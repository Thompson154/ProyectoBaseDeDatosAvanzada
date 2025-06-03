----------------- SPs para MariaDB------------------------

---- SP para generar Combo de Combate------------------
DELIMITER //
CREATE PROCEDURE generar_combo_combate(
    IN p_jugador_id INT,
    IN p_enemigo_id INT,
    IN p_arma_id INT,
    IN p_num_combates INT
)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < p_num_combates DO
        INSERT INTO log_combate (jugador_id, enemigo_id, arma_id, dano_infligido, dano_recibido, fecha_combate)
        VALUES (p_jugador_id, p_enemigo_id, p_arma_id, 100, 20, NOW());
        SET i = i + 1;
    END WHILE;
    IF p_num_combates >= 3 THEN
        INSERT INTO progreso_habilidad (jugador_id, habilidad_id, nivel, experiencia)
        VALUES (p_jugador_id, p_arma_id, 1, 100)
        ON DUPLICATE KEY UPDATE experiencia = experiencia + 100;
    END IF;
END //
DELIMITER ;

-- comprobacion de funcionamiento para generar_combo_combate
CALL generar_combo_combate(1, 1, 1, 3);
SELECT experiencia FROM progreso_habilidad WHERE jugador_id = 1 AND habilidad_id = 1;




-------- SP para mejorar Arma con Drops
DELIMITER //
CREATE PROCEDURE mejorar_arma(
    IN p_jugador_id INT,
    IN p_drop_arma_id INT,
    IN p_drop_material_id INT,
    IN p_new_item_id INT
)
BEGIN
    DECLARE drop_count INT;
    SELECT COUNT(*) INTO drop_count
    FROM drops
    WHERE jugador_id = p_jugador_id AND id IN (p_drop_arma_id, p_drop_material_id);
    IF drop_count = 2 THEN
        UPDATE drops SET item_id = p_new_item_id WHERE id = p_drop_arma_id;
        DELETE FROM drops WHERE id = p_drop_material_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drops inválidos para mejora';
    END IF;
END //
DELIMITER ;

--comprobacion de funcionamiento para mejorar_arma
INSERT INTO drops (item_id, jugador_id, evento_id, fecha_drop)
VALUES (1, 1, 1, NOW()), (2, 1, 1, NOW());
CALL mejorar_arma(1, (SELECT MAX(id) FROM drops), (SELECT MAX(id)-1 FROM drops), 3);
SELECT item_id FROM drops WHERE jugador_id = 1 AND item_id = 3;