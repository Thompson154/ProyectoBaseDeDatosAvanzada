-- Trigger para Actualizar Experiencia de Habilidad tras Combate
DELIMITER //
CREATE TRIGGER after_combat_skill_progress
AFTER INSERT ON log_combate
FOR EACH ROW
BEGIN
    DECLARE habilidad_relacionada INT;
    -- Asumir arma_id está ligada a habilidad_id (simplificación)
    SET habilidad_relacionada = NEW.arma_id;
    IF NEW.dano_infligido > 100 THEN
        INSERT INTO progreso_habilidad (jugador_id, habilidad_id, nivel, experiencia)
        VALUES (NEW.jugador_id, habilidad_relacionada, 1, 50)
        ON DUPLICATE KEY UPDATE experiencia = experiencia + 50;
    END IF;
END //
DELIMITER ;

-- comprobacion de funcionamiento de after_combat_skill_progress
INSERT INTO log_combate (jugador_id, enemigo_id, arma_id, dano_infligido, dano_recibido, fecha_combate)
VALUES (1, 1, 1, 150, 50, NOW());
SELECT experiencia FROM progreso_habilidad WHERE jugador_id = 1 AND habilidad_id = 1;




-- Trigger para Registrar Recompensa por Partida Victoriosa en Evento
DELIMITER //
CREATE TRIGGER before_partida_end
BEFORE UPDATE ON partidas
FOR EACH ROW
BEGIN
    DECLARE evento_activo INT;
    IF NEW.fecha_fin IS NOT NULL AND NEW.victoria = 1 THEN
        SELECT id INTO evento_activo
        FROM eventos_zombi
        WHERE NEW.fecha_inicio BETWEEN fecha_inicio AND fecha_fin
        LIMIT 1;
        IF evento_activo IS NOT NULL THEN
            INSERT INTO recompensa_evento (jugador_id, evento_id, recompensa_obtenida, fecha_registro)
            VALUES (NEW.jugador_id, evento_activo, 'Bonus Victoria', NOW());
        END IF;
    END IF;
END //
DELIMITER ;

-- comprobacion de funcionamiento de before_partida_end
UPDATE partidas SET fecha_fin = NOW(), victoria = 1 WHERE jugador_id = 1 AND fecha_fin IS NULL LIMIT 1;
SELECT * FROM recompensa_evento WHERE jugador_id = 1 ORDER BY fecha_registro DESC LIMIT 1;