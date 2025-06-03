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

-- Generar 1000 Jugadores
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


-- Se borra esta generacion de 1000 usuarios si no funciona
INSERT INTO usuarios (jugador_id, username, correo, password)
SELECT
    id AS jugador_id,
    'user' || id AS username,
    'user' || id || '@gmail.com' AS correo,
    '1234' AS password
FROM jugadores
WHERE id <= 1000;
---- Se borra lo de arriba si no funciona

--Generar los mapas
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


--Generar Enemigos
INSERT INTO enemigos (nombre, tipo, nivel, vida, es_jefe, mapa_id)
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
    (SELECT id FROM mapas ORDER BY RANDOM() LIMIT 1) AS mapa_id
FROM generate_series(1, 500);


-- Agregando datos de items a jugadores en la tabla de inventario
INSERT INTO inventario (jugador_id, item_id, cantidad, durabilidad_actual)
SELECT
  jugadores.jugador_id,
  FLOOR(1 + random() * 33)::INT AS item_id,
  1 AS cantidad,
  100 AS durabilidad_actual
FROM (
  SELECT generate_series(1, 3) AS jugador_id -- 3 jugadores
) AS jugadores,
LATERAL (
  SELECT generate_series(1, 20) AS item_repetido -- 30 ítems por jugador
) AS repeticiones;


-- Genera jefes zombies
INSERT INTO jefe_zombi (enemigo_id, nombre_alias, habilidad_especial, recompensa_unica)
SELECT
    e.id AS enemigo_id,
    'Alias_' || e.id AS nombre_alias,
    CASE FLOOR(RANDOM() * 4 + 1)
        WHEN 1 THEN 'Explosión ácida'
        WHEN 2 THEN 'Regeneración rápida'
        WHEN 3 THEN 'Grito paralizante'
        ELSE 'Velocidad extrema'
    END AS habilidad_especial,
    CASE FLOOR(RANDOM() * 4 + 1)
        WHEN 1 THEN 'Espada legendaria'
        WHEN 2 THEN 'Katana Dragon Rojo'
        WHEN 3 THEN 'Inyección mutante'
        ELSE 'Paquete de suministros'
    END AS recompensa_unica
FROM (
    SELECT id FROM enemigos WHERE es_jefe = true ORDER BY RANDOM() LIMIT 15
) AS e;




-- genera codigo de misiones
INSERT INTO misiones (titulo, descripcion, tipo, nivel_recomendado, recompensa, mapa_id)
SELECT
  'Misión #' || s.i AS titulo,
  'Esta es una misión generada automáticamente con ID ' || s.i AS descripcion,
  CASE FLOOR(RANDOM() * 4 + 1)
    WHEN 1 THEN 'Principal'
    WHEN 2 THEN 'Secundaria'
    WHEN 3 THEN 'Desafío'
    ELSE 'Exploración'
  END AS tipo,
  FLOOR(RANDOM() * 10 + 1) AS nivel_recomendado,
  CASE FLOOR(RANDOM() * 5 + 1)
    WHEN 1 THEN 'XP + Arma rara'
    WHEN 2 THEN 'Dinero + Consumibles'
    WHEN 3 THEN 'Llave secreta'
    WHEN 4 THEN 'Objeto legendario'
    ELSE 'Acceso a zona nueva'
  END AS recompensa,
  (SELECT id FROM mapas ORDER BY RANDOM() LIMIT 1) AS mapa_id
FROM generate_series(1, 50) AS s(i)
WHERE EXISTS (SELECT 1 FROM mapas);

-- Genera datos de jugador mision
INSERT INTO jugador_mision (jugador_id, mision_id, estado, fecha_inicio, fecha_fin)
SELECT DISTINCT ON (jugador_id, mision_id)
  j.id AS jugador_id,
  m.id AS mision_id,
  CASE FLOOR(RANDOM() * 3 + 1)
      WHEN 1 THEN 'en progreso'
      WHEN 2 THEN 'completada'
      ELSE 'fallida'      -- trigger de insertar un jugador_mision --- UDPADTE de esto 
  END AS estado,
  fecha_ini,
  fecha_ini + (INTERVAL '1 hour' * FLOOR(RANDOM() * 24 + 1)) AS fecha_fin
FROM (
    SELECT id FROM jugadores ORDER BY RANDOM() LIMIT 100
) AS j,
LATERAL (
    SELECT id FROM misiones ORDER BY RANDOM() LIMIT 100
) AS m,
LATERAL (
    SELECT NOW() - (INTERVAL '1 day' * FLOOR(RANDOM() * 30 + 1)) AS fecha_ini
) AS f
LIMIT 100;