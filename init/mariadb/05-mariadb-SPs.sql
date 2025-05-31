-- DELIMITER $$

-- DROP PROCEDURE IF EXISTS insertar_recompensas_evento $$
-- CREATE PROCEDURE insertar_recompensas_evento()
-- BEGIN
--     DECLARE evento_id INT;
--     DECLARE jugador_id INT;
--     DECLARE recompensas INT;
--     DECLARE i INT;

--     SET evento_id = 1;

--     WHILE evento_id <= 5 DO
--         SET recompensas = FLOOR(1 + RAND() * 3); -- entre 1 y 3 recompensas por evento
--         SET i = 1;

--         WHILE i <= recompensas DO
--             SET jugador_id = FLOOR(1 + RAND() * 3); -- jugadores 1 a 3
--             INSERT INTO recompensa_evento (evento_id, jugador_id, recompensa, fecha_entrega)
--             VALUES (
--                 evento_id,
--                 jugador_id,
--                 ELT(FLOOR(1 + RAND() * 5), 'Carta de Habilidad', 'Granada', 'Katana rara', 'Arma Corta', 'Rifle'),
--                 NOW() - INTERVAL FLOOR(RAND() * 1000) MINUTE
--             );
--             SET i = i + 1;
--         END WHILE;

--         SET evento_id = evento_id + 1;
--     END WHILE;
-- END $$
-- DELIMITER ;

-- -- Llamar al procedimiento
-- CALL insertar_recompensas_evento();