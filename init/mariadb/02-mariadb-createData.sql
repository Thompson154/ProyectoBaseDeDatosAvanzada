-------Transacciones de insercion de datos-------

----Insercion de datos en la tabla drops--------

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


----Insercion de datos en la tabla eventos_zombie--------

CREATE PROCEDURE insertar_eventos_zombi(IN x INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE tipos_evento TEXT;
    DECLARE tipo_actual VARCHAR(30);
    DECLARE fecha_ini DATETIME;
    DECLARE fecha_fin DATETIME;

    WHILE i <= x DO
        SET tipos_evento = 'Horda,Infección,Defensa de Base,Caza de Jefe,Supervivencia';
        SET tipo_actual = ELT(FLOOR(1 + RAND() * 5), 'Horda', 'Infección', 'Defensa de Base', 'Caza de Jefe', 'Supervivencia');

        SET fecha_ini = NOW() - INTERVAL FLOOR(RAND() * 30) DAY;
        SET fecha_fin = fecha_ini + INTERVAL FLOOR(RAND() * 3 + 1) DAY;

        INSERT INTO eventos_zombi (nombre_evento, tipo_evento, fecha_inicio, fecha_fin, activo)
        VALUES (
            CONCAT('Evento Especial #', i),
            tipo_actual,
            fecha_ini,
            fecha_fin,
            IF(RAND() > 0.3, TRUE, FALSE)
        );

        SET i = i + 1;
    END WHILE;
END;

-- Llamar al procedimiento con la cantidad deseada
CALL insertar_eventos_zombi(50);


----Insercion de datos en la tabla log_combate--------

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
END;

-- Llamar al procedimiento
CALL insertar_logs_combate();


----Insercion de datos en la tabla partidas--------

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


----Insercion de datos en la tabla progreso_habilidad--------

CREATE PROCEDURE insertar_progreso_habilidad(IN x INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE jugador_id INT;
    DECLARE habilidad_actual VARCHAR(50);
    DECLARE habilidades TEXT;

    WHILE i <= x DO
        SET jugador_id = FLOOR(1 + RAND() * 1000); -- Jugadores del 1 al 1000 (ajustable)

        SET habilidad_actual = ELT(
            FLOOR(1 + RAND() * 6),
            'Resistencia',
            'Fuerza',
            'Agilidad',
            'Precisión',
            'Sigilo',
            'Supervivencia'
        );

        INSERT INTO progreso_habilidad (
            jugador_id,
            habilidad,
            nivel,
            experiencia,
            ultima_actualizacion
        ) VALUES (
            jugador_id,
            habilidad_actual,
            FLOOR(1 + RAND() * 10),
            FLOOR(RAND() * 1000),
            NOW() - INTERVAL FLOOR(RAND() * 90) DAY
        );

        SET i = i + 1;
    END WHILE;
END;

-- Ejecutar el procedimiento con la cantidad deseada
CALL insertar_progreso_habilidad(100);


----Insercion de datos en la tabla recompensa_evento--------

CREATE PROCEDURE insertar_recompensas_evento_x(IN x INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE jugador_id INT;
    DECLARE evento_id INT;
    DECLARE recompensa_txt TEXT;

    WHILE i <= x DO
        SELECT id INTO evento_id
        FROM eventos_zombi
        ORDER BY RAND()
        LIMIT 1;

        SET jugador_id = FLOOR(1 + RAND() * 1000);

        SET recompensa_txt = ELT(
            FLOOR(1 + RAND() * 6),
            'Granada fragmentación',
            'Katana rara',
            'Rifle automático',
            'XP +500',
            'Carta de habilidad',
            'Botiquín avanzado'
        );

        INSERT INTO recompensa_evento (
            evento_id,
            jugador_id,
            recompensa,
            fecha_entrega
        ) VALUES (
            evento_id,
            jugador_id,
            recompensa_txt,
            NOW() - INTERVAL FLOOR(RAND() * 60) DAY
        );

        SET i = i + 1;
    END WHILE;
END;

-- Ejecutar con la cantidad deseada
CALL insertar_recompensas_evento_x(50);

