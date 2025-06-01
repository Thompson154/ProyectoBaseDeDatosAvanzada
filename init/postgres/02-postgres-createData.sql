------------------- Insercion de datos -------------------------

-----Insercion de datos de la tabla enemigos -----------

INSERT INTO enemigos(nombre, tipo, nivel, vida, es_jefe, mapa_id)
SELECT
    'Zombi_' || generate_series(1, 500) AS nombre,
    CASE (generate_series % 7)
        WHEN 0 THEN 'Caminante'
        WHEN 1 THEN 'Corredor'
        WHEN 2 THEN 'Mutante'
        WHEN 3 THEN 'Caminante Fuego'
        WHEN 4 THEN 'Chillona Electrica'
        WHEN 5 THEN 'Carnicero'
        WHEN 6 THEN 'Ahogado con Parasitos'
        ELSE 'Jefe'
    END AS tipo,
    FLOOR(RANDOM() * 10 + 1)::INT AS nivel,
    FLOOR(RANDOM() * 500 + 100)::INT AS vida,
    CASE WHEN generate_series % 50 = 0 THEN TRUE ELSE FALSE END AS es_jefe,
    FLOOR(RANDOM() * 50 + 1)::INT AS mapa_id
FROM generate_series(1, 500);


-----Insercion de datos de la tabla inventario -----------

DO $$
DECLARE
    x INT := 100;
    i INT := 0;
    jugador_id INT;
    item_id INT;
BEGIN
    IF (SELECT COUNT(*) FROM jugadores) = 0 THEN
        RAISE EXCEPTION 'No hay jugadores en la tabla jugadores.';
    END IF;

    IF (SELECT COUNT(*) FROM items) = 0 THEN
        RAISE EXCEPTION 'No hay ítems en la tabla items.';
    END IF;

    WHILE i < x LOOP
        jugador_id := (SELECT id FROM jugadores ORDER BY RANDOM() LIMIT 1);
        item_id := (SELECT id FROM items ORDER BY RANDOM() LIMIT 1);

        BEGIN
            INSERT INTO inventario (jugador_id, item_id, cantidad, durabilidad_actual)
            VALUES (
                jugador_id,
                item_id,
                FLOOR(RANDOM() * 5 + 1),
                FLOOR(RANDOM() * 100 + 1)
            );
            i := i + 1;
        EXCEPTION WHEN unique_violation THEN
            CONTINUE;
        END;
    END LOOP;
END $$;


-----Insercion de datos de la tabla items -----------

INSERT INTO items (nombre, tipo, rareza, durabilidad_max) VALUES
('Brass Knuckles', 'arma cuerpo a cuerpo', 'común', 100),
('Fire Axe', 'arma cuerpo a cuerpo', 'raro', 120),
('Baseball Bat', 'arma cuerpo a cuerpo', 'poco común', 95),
('Claymore', 'arma cuerpo a cuerpo', 'legendario', 150),
('Military Knife', 'arma cuerpo a cuerpo', 'común', 85),
('Katana', 'arma cuerpo a cuerpo', 'legendario', 145),
('Meat Mallet', 'arma contundente', 'común', 92),
('Mace', 'arma contundente', 'raro', 112),
('Shovel', 'arma improvisada', 'poco común', 88),
('Electrocutor Sword', 'arma modificada', 'legendario', 160),
('Zombie Claw', 'arma especial', 'único', 200),
('Brass Knuckles', 'arma cuerpo a cuerpo', 'raro', 105),
('Fire Axe', 'arma cuerpo a cuerpo', 'legendario', 130),
('Baseball Bat', 'arma cuerpo a cuerpo', 'común', 90),
('Claymore', 'arma cuerpo a cuerpo', 'épico', 155),
('Military Knife', 'arma cuerpo a cuerpo', 'raro', 95),
('Katana v2', 'arma cuerpo a cuerpo', 'único', 148),
('Meat Mallet', 'arma contundente', 'poco común', 98),
('Mace', 'arma contundente', 'épico', 118),
('Shovel', 'arma improvisada', 'común', 82),
('Electrocutor Sword', 'arma modificada', 'épico', 165),
('Zombie Claw', 'arma especial', 'único', 210),
('Brass Knuckles', 'arma cuerpo a cuerpo', 'épico', 110),
('Fire Axe', 'arma cuerpo a cuerpo', 'poco común', 125),
('Baseball Bat', 'arma cuerpo a cuerpo', 'raro', 92),
('Claymore', 'arma cuerpo a cuerpo', 'único', 160),
('Military Knife', 'arma cuerpo a cuerpo', 'épico', 90),
('Katana', 'arma cuerpo a cuerpo', 'épico', 150),
('Meat Mallet', 'arma contundente', 'raro', 100),
('Mace', 'arma contundente', 'legendario', 115),
('Shovel', 'arma improvisada', 'raro', 86),
('Electrocutor Sword', 'arma modificada', 'único', 170),
('Zombie Claw', 'arma especial', 'épico', 220);


-----Insercion de datos de la tabla jefe_zombi -----------

DO $$
DECLARE
    x INT := 100;
    i INT := 0;
    enemigo_id_actual INT;
BEGIN
    IF (SELECT COUNT(*) FROM enemigos WHERE es_jefe = true) < x THEN
        RAISE EXCEPTION 'No hay suficientes enemigos marcados como jefes para insertar % registros en jefe_zombi.', x;
    END IF;

    FOR enemigo_id_actual IN 
        SELECT id FROM enemigos WHERE es_jefe = true ORDER BY RANDOM() LIMIT x
    LOOP
        INSERT INTO jefe_zombi (enemigo_id, nombre_alias, habilidad_especial, recompensa_unica)
        VALUES (
            enemigo_id_actual,
            'Alias_' || enemigo_id_actual,
            ELT(FLOOR(RANDOM() * 4 + 1), 
                'Explosión ácida', 
                'Regeneración rápida', 
                'Grito paralizante', 
                'Velocidad extrema'),
            ELT(FLOOR(RANDOM() * 4 + 1), 
                'Espada legendaria', 
                'Armadura reforzada', 
                'Inyección mutante', 
                'Paquete de suministros')
        );
    END LOOP;
END $$;


-----Insercion de datos de la tabla jugador_mision -----------

DO $$
DECLARE
    x INT := 100;
    i INT := 0;
    jugador_id INT;
    mision_id INT;
    estados TEXT[] := ARRAY['en progreso', 'completada', 'fallida'];
    fecha_ini TIMESTAMP;
BEGIN
    IF (SELECT COUNT(*) FROM jugadores) = 0 THEN
        RAISE EXCEPTION 'No hay jugadores en la tabla jugadores.';
    END IF;

    IF (SELECT COUNT(*) FROM misiones) = 0 THEN
        RAISE EXCEPTION 'No hay misiones en la tabla misiones.';
    END IF;

    WHILE i < x LOOP
        jugador_id := (SELECT id FROM jugadores ORDER BY RANDOM() LIMIT 1);
        mision_id := (SELECT id FROM misiones ORDER BY RANDOM() LIMIT 1);
        fecha_ini := NOW() - INTERVAL '1 day' * FLOOR(RANDOM() * 30 + 1); -- fecha en los últimos 30 días

        BEGIN
            INSERT INTO jugador_mision (
                jugador_id, mision_id, estado, fecha_inicio, fecha_fin
            ) VALUES (
                jugador_id,
                mision_id,
                estados[FLOOR(RANDOM() * array_length(estados, 1) + 1)],
                fecha_ini,
                fecha_ini + INTERVAL '1 hour' * FLOOR(RANDOM() * 24 + 1)
            );
            i := i + 1;
        EXCEPTION WHEN unique_violation THEN
            CONTINUE;
        END;
    END LOOP;
END $$;


-----Insercion de datos de la tabla jugadores -----------

INSERT INTO jugadores (nombre, clase, experiencia, nivel, estado)
SELECT
    'Player_' || generate_series(1, 1000) AS nombre,
    CASE (generate_series % 3)
        WHEN 0 THEN 'Guerrero'
        WHEN 1 THEN 'Cazador'
        ELSE 'Médico'
    END AS clase,
    FLOOR(RANDOM() * 10000)::INT AS experiencia,
    FLOOR(RANDOM() * 10 + 1)::INT AS nivel,
    CASE WHEN RANDOM() < 0.9 THEN 'activo' ELSE 'inactivo' END AS estado
FROM generate_series(1, 1000);


-----Insercion de datos de la tabla mapas -----------

INSERT INTO mapas (nombre, zona, dificultad) VALUES
  ('Beverly Hills Mall', 'Ciudad', 'Difícil'),
  ('Muelle de Ocean Avenue', 'Playa', 'Normal'),
  ('Sewers de Downtown LA', 'Zona Industrial', 'Difícil'),
  ('Parque Griffith', 'Selva', 'Normal'),
  ('Mansión de Monarch Studios', 'Suburbio', 'Fácil'),
  ('Cementerio de Hollywood', 'Ciudad', 'Normal'),
  ('Canales de Venice', 'Playa', 'Fácil'),
  ('Estadio de LA', 'Zona Industrial', 'Difícil'),
  ('Barrio de Silver Lake', 'Suburbio', 'Normal'),
  ('Puerto de Long Beach', 'Zona Industrial', 'Fácil');


-----Insercion de datos de la tabla misiones -----------

DO $$
DECLARE
    x INT := 50;
    i INT := 1;
    tipos TEXT[] := ARRAY['Principal', 'Secundaria', 'Desafío', 'Exploración'];
    recompensas TEXT[] := ARRAY['XP + Arma rara', 'Dinero + Consumibles', 'Llave secreta', 'Objeto legendario', 'Acceso a zona nueva'];
    mapa_id_actual INT;
BEGIN
    IF (SELECT COUNT(*) FROM mapas) = 0 THEN
        RAISE EXCEPTION 'No hay mapas en la tabla mapas.';
    END IF;

    WHILE i <= x LOOP
        mapa_id_actual := (SELECT id FROM mapas ORDER BY RANDOM() LIMIT 1);

        INSERT INTO misiones (
            titulo,
            descripcion,
            tipo,
            nivel_recomendado,
            recompensa,
            mapa_id
        ) VALUES (
            'Misión #' || i,
            'Esta es una misión generada automáticamente con ID ' || i,
            tipos[FLOOR(RANDOM() * array_length(tipos, 1) + 1)],
            FLOOR(RANDOM() * 10 + 1),
            recompensas[FLOOR(RANDOM() * array_length(recompensas, 1) + 1)],
            mapa_id_actual
        );

        i := i + 1;
    END LOOP;
END $$;
