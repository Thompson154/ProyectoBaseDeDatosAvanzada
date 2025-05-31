-- ACA AGREGAR TODO EL CODIGO PARA INSERTAR DATA -----------------------------------------------
-- Agregando 15000 datos en la tabal de log_combate
DELIMITER $$

DROP PROCEDURE IF EXISTS insertar_logs_combate $$
CREATE PROCEDURE insertar_logs_combate()
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < 15000 DO
        INSERT INTO log_combate (jugador_id, enemigo_id, accion, valor, momento)
        VALUES (
            FLOOR(1 + RAND() * 3),  -- jugadores 1 a 3
            FLOOR(1 + RAND() * 50), -- enemigos 1 a 50
            ELT(FLOOR(1 + RAND() * 3), 'atacar', 'curar', 'esquivar'),
            FLOOR(5 + RAND() * 95), -- valor de 5 a 100
            NOW() - INTERVAL FLOOR(RAND() * 1000) MINUTE
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

-- Llamar al procedimiento
CALL insertar_logs_combate();

--Poner los records de las partidas

INSERT INTO partidas (jugador_id, fecha_inicio, fecha_fin, resultado, enemigos_derrotados)
SELECT
    FLOOR(RAND() * 1000) + 1 AS jugador_id,
    NOW() - INTERVAL FLOOR(RAND() * 365) DAY AS fecha_inicio,
    NOW() - INTERVAL FLOOR(RAND() * 365) DAY + INTERVAL FLOOR(RAND() * 7200) MINUTE AS fecha_fin,
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'Victoria'
        WHEN 1 THEN 'Derrota'
        ELSE 'Abandonada'
    END AS resultado,
    FLOOR(RAND() * 50) AS enemigos_derrotados
FROM
    (SELECT a.N + b.N * 1000 + c.N * 10000 + 1 AS n
     FROM
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) c
     WHERE a.N + b.N * 1000 + c.N * 10000 < 30000) numbers;

--Datos para generar los drops
INSERT INTO drops (enemigo_id, item_id, probabilidad)
SELECT
    FLOOR(RAND() * 500) + 1 AS enemigo_id,
    FLOOR(RAND() * 200) + 1 AS item_id,
    ROUND(RAND() * 100, 2) AS probabilidad
FROM
    (SELECT a.N + b.N * 1000 + 1 AS n
     FROM
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
          UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14) b
     WHERE a.N + b.N * 1000 < 15000) numbers
ON DUPLICATE KEY UPDATE probabilidad = ROUND(RAND() * 100, 2);