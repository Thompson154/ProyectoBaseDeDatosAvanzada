INSERT INTO eventos_zombi (nombre_evento, tipo_evento, fecha_inicio, fecha_fin, activo)
SELECT
    CONCAT('Evento Zombi #', s.i),
    CASE FLOOR(1 + RAND() * 5)
        WHEN 1 THEN 'Horda'
        WHEN 2 THEN 'Infección'
        WHEN 3 THEN 'Defensa de Base'
        WHEN 4 THEN 'Caza de Jefe'
        ELSE 'Supervivencia'
    END,
    NOW() - INTERVAL FLOOR(RAND() * 30) DAY, 
    NOW() + INTERVAL FLOOR(RAND() * 5 + 1) DAY, 
    IF(RAND() > 0.3, TRUE, FALSE)
FROM (
    SELECT a.i
    FROM (
        SELECT 1 AS i UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    ) a
) AS s;


INSERT INTO partidas (jugador_id, fecha_inicio, fecha_fin, resultado, enemigos_derrotados, evento_id)
SELECT
    FLOOR(RAND() * 1000) + 1 AS jugador_id, 
    NOW() - INTERVAL FLOOR(RAND() * 180) DAY AS fecha_inicio, 
    NOW() - INTERVAL FLOOR(RAND() * 180) DAY + INTERVAL FLOOR(RAND() * 7200) MINUTE AS fecha_fin, 
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'Victoria'
        WHEN 1 THEN 'Derrota'
        ELSE 'Abandonada'
    END AS resultado,
    FLOOR(RAND() * 50) AS enemigos_derrotados,
    FLOOR(RAND() * 10) + 1 AS evento_id 
FROM
    (SELECT a.N + b.N * 1000 + c.N * 10000 + 1 AS n
     FROM
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) c
     WHERE a.N + b.N * 1000 + c.N * 10000 < 30000) numbers;

DELIMITER $$

CREATE PROCEDURE insertar_logs_combate()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE partida_id_max INT;
    SELECT MAX(id) INTO partida_id_max FROM partidas;

    WHILE i < 30000 DO
        SET @partida_id = FLOOR(1 + RAND() * partida_id_max);
        INSERT INTO log_combate (jugador_id, enemigo_id, accion, valor, momento, partida_id)
        SELECT
            p.jugador_id, 
            FLOOR(1 + RAND() * 500), 
            ELT(FLOOR(1 + RAND() * 3), 'atacar', 'curar', 'esquivar'),
            FLOOR(5 + RAND() * 95), 
            p.fecha_inicio + INTERVAL FLOOR(RAND() * TIMESTAMPDIFF(MINUTE, p.fecha_inicio, p.fecha_fin)) MINUTE,
            p.id
        FROM partidas p
        WHERE p.id = @partida_id;
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

CALL insertar_logs_combate();


INSERT INTO drops (enemigo_id, item_id, probabilidad, evento_id)
SELECT
    FLOOR(RAND() * 500) + 1 AS enemigo_id, 
    FLOOR(RAND() * 200) + 1 AS item_id, 
    ROUND(RAND() * 100, 2) AS probabilidad,
    FLOOR(RAND() * 10) + 1 AS evento_id 
FROM
    (SELECT a.N + b.N * 1000 + c.N * 10000 + 1 AS n
     FROM
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) c
     WHERE a.N + b.N * 1000 + c.N * 10000 < 30000) numbers
ON DUPLICATE KEY UPDATE probabilidad = ROUND(RAND() * 100, 2);

INSERT INTO progreso_habilidad (jugador_id, habilidad, nivel, experiencia, ultima_actualizacion, partida_id)
SELECT
    p.jugador_id,
    ELT(
        FLOOR(1 + RAND() * 6),
        'Resistencia',
        'Fuerza',
        'Agilidad',
        'Precisión',
        'Sigilo',
        'Supervivencia'
    ) AS habilidad,
    CASE
        WHEN p.resultado = 'Victoria' THEN FLOOR(5 + RAND() * 6)
        ELSE FLOOR(1 + RAND() * 4)
    END AS nivel,
    FLOOR(RAND() * 1000) AS experiencia, 
    p.fecha_fin AS ultima_actualizacion, 
    p.id AS partida_id
FROM partidas p
WHERE p.resultado IS NOT NULL
LIMIT 1000;

INSERT INTO recompensa_evento (evento_id, jugador_id, recompensa, fecha_entrega)
SELECT
    e.id AS evento_id,
    FLOOR(RAND() * 1000) + 1 AS jugador_id,
    CASE FLOOR(1 + RAND() * 5)
        WHEN 1 THEN 'Carta de Habilidad'
        WHEN 2 THEN 'Granada'
        WHEN 3 THEN 'Katana rara'
        WHEN 4 THEN 'Arma Corta'
        ELSE 'Rifle'
    END AS recompensa,
    e.fecha_inicio + INTERVAL FLOOR(RAND() * TIMESTAMPDIFF(MINUTE, e.fecha_inicio, e.fecha_fin)) MINUTE AS fecha_entrega
FROM eventos_zombi e
WHERE e.id BETWEEN 1 AND 10
LIMIT 50;