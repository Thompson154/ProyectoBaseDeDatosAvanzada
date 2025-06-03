-- ACA AGREGAR TODO EL CODIGO PARA INSERTAR DATA -----------------------------------------------
-- Agregando 15000 datos en la tabal de log_combate
-- Hacemos con DELIMITER POR QUE NO TENEMOS la falta de generate_series(). en mariadb

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


-- Insertar 5 eventos zombis
INSERT INTO eventos_zombi (nombre_evento, tipo_evento, fecha_inicio, fecha_fin, activo)
SELECT
  CONCAT('Evento Especial #', s.i),
  CASE FLOOR(1 + RAND() * 5)
    WHEN 1 THEN 'Horda'
    WHEN 2 THEN 'Infección'
    WHEN 3 THEN 'Defensa de Base'
    WHEN 4 THEN 'Caza de Jefe'
    ELSE 'Supervivencia'
  END,
  NOW() - INTERVAL FLOOR(RAND() * 30) DAY,
  NOW() + INTERVAL FLOOR(RAND() * 3 + 1) DAY,
  IF(RAND() > 0.3, TRUE, FALSE)
FROM (
  SELECT 1 AS i UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) AS s;

-- Insertar recompensas por evento
INSERT INTO recompensa_evento (evento_id, jugador_id, recompensa, fecha_entrega)
SELECT
  e.id AS evento_id,
  j.jugador_id,
  CASE FLOOR(1 + RAND() * 5)
    WHEN 1 THEN 'Carta de Habilidad'
    WHEN 2 THEN 'Granada'
    WHEN 3 THEN 'Katana rara'
    WHEN 4 THEN 'Arma Corta'
    ELSE 'Rifle'
  END AS recompensa,
  NOW() - INTERVAL FLOOR(RAND() * 1000) MINUTE AS fecha_entrega
FROM (
  SELECT id FROM eventos_zombi ORDER BY id DESC LIMIT 5
) AS e,
(
  SELECT 1 AS jugador_id UNION ALL SELECT 2 UNION ALL SELECT 3
) AS j
WHERE RAND() < 0.7;


--inserta progreso habilidad
INSERT INTO progreso_habilidad (jugador_id, habilidad, nivel, experiencia, ultima_actualizacion)
SELECT
    FLOOR(1 + RAND() * 1000) AS jugador_id, -- Jugadores del 1 al 1000
    ELT(
        FLOOR(1 + RAND() * 6),
        'Resistencia',
        'Fuerza',
        'Agilidad',
        'Precisión',
        'Sigilo',
        'Supervivencia'
    ) AS habilidad,
    FLOOR(1 + RAND() * 10) AS nivel, -- Nivel entre 1 y 10
    FLOOR(RAND() * 1000) AS experiencia, -- Experiencia entre 0 y 999
    NOW() - INTERVAL FLOOR(RAND() * 90) DAY AS ultima_actualizacion -- Últimos 90 días
FROM (
    -- Generar una secuencia de 100 números (1 a 100)
    SELECT a.N + b.N * 10 + 1 AS n
    FROM
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    WHERE a.N + b.N * 10 < 100
) numbers;
