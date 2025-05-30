
-- MariaDB - Dead Island 2 - Tablas transaccionales (sin referencias a tablas externas)

CREATE TABLE partidas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    resultado VARCHAR(20),
    enemigos_derrotados INT
    -- FOREIGN KEY eliminado: jugadores está en PostgreSQL
);

CREATE TABLE log_combate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT,
    enemigo_id INT,
    accion VARCHAR(50),
    valor INT,
    momento DATETIME DEFAULT CURRENT_TIMESTAMP
    -- FOREIGN KEY eliminado: jugadores y enemigos están en PostgreSQL
);

CREATE TABLE eventos_zombi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_evento VARCHAR(100),
    tipo_evento VARCHAR(30),
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE drops (
    enemigo_id INT,
    item_id INT,
    probabilidad DECIMAL(5,2),
    PRIMARY KEY (enemigo_id, item_id)
    -- FOREIGN KEY eliminado: enemigos e items están en PostgreSQL
);

CREATE TABLE progreso_habilidad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT,
    habilidad VARCHAR(50),
    nivel INT DEFAULT 1,
    experiencia INT DEFAULT 0,
    ultima_actualizacion DATETIME
    -- FOREIGN KEY eliminado: jugadores está en PostgreSQL
);

CREATE TABLE recompensa_evento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT,
    jugador_id INT,
    recompensa TEXT,
    fecha_entrega DATETIME,
    FOREIGN KEY (evento_id) REFERENCES eventos_zombi(id)
    -- jugador_id sin FK: jugadores está en PostgreSQL
);

-- ACA AGREGAR TODO EL CODIGO PARA INSERTAR CODIGO -----------------------------------------------
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








