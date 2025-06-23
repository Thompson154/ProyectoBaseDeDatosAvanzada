/* 1. 50 usuarios ------------------------------------------------------ */
INSERT INTO users (email, username, password)
SELECT
  'user'   || lpad(i::text, 2, '0') || '@example.com',
  'Slayer' || lpad(i::text, 2, '0'),
  'Pass'   || lpad(i::text, 2, '0') || '!'
FROM generate_series(1, 50) AS s(i);

/* 2. 50 jugadores ----------------------------------------------------- */
INSERT INTO players (user_id)
SELECT user_id FROM users;

/* 3. Estadísticas iniciales ------------------------------------------ */
INSERT INTO player_stats (player_id, level, xp)
SELECT player_id,
       (random()*10 + 1)::INT,
       (random()*2000)::INT
FROM players;

/* 4. Inventarios ------------------------------------------------------ */
INSERT INTO inventories (player_id, capacity)
SELECT player_id, 30 FROM players;

/* 5. Skills base (IDs 1 y 2) ----------------------------------------- */
INSERT INTO player_skills (player_id, skill_id)
SELECT p.player_id, s.skill_id
FROM players p
CROSS JOIN (VALUES (1),(2)) AS s(skill_id);

/* 6. 10 sesiones de mapa --------------------------------------------- */
INSERT INTO map_sessions (map_id, is_night)
SELECT (random()*9 + 1)::INT, (random() < 0.5)
FROM generate_series(1, 10);

/* 7. Distribuir jugadores (5 por sesión) ----------------------------- */
WITH ord AS (
  SELECT player_id, row_number() OVER () - 1 AS rn FROM players
),
sess AS (
  SELECT session_id, row_number() OVER () - 1 AS rn FROM map_sessions
)
INSERT INTO map_players (session_id, player_id)
SELECT s.session_id, o.player_id
FROM ord o
JOIN sess s ON (o.rn % 10) = s.rn;

/* 8. 1000 zombis (100 por sesión) ------------------------------------ */
INSERT INTO session_zombies (session_id, type_id, current_hp, is_enraged)
SELECT ms.session_id,
       (random()*8 + 1)::INT,          -- 9 tipos (1-9) en MariaDB
       100 + (random()*200)::INT,
       (random() < 0.1)
FROM map_sessions ms, generate_series(1, 100);



-- Despues de esta linea se deberia de insertar desde un bigdadta ya que pertenece a mariaDB

/* -----  Inventory_items: 3 ítems random por jugador  ----- */
WITH inv AS (
  SELECT inventory_id FROM inventories
), itm AS (
  SELECT item_id FROM generate_series(1,10) AS g(item_id)  -- 10 ítems que creamos en MariaDB
)
INSERT INTO inventory_items (inventory_id, item_id, quantity)
SELECT inv.inventory_id,
       itm.item_id,
       (random()*3 + 1)::INT      -- 1-4 unidades
FROM inv
JOIN itm ON random() < 0.3;       -- ≈3 ítems por inventario

/* -----  Player_missions: cada jugador recibe 1 misión story  ----- */
WITH ply AS (
  SELECT player_id FROM players
), mis AS (
  SELECT mission_id FROM generate_series(1,10) AS g(mission_id)  -- 10 misiones de MariaDB
)
INSERT INTO player_missions (player_id, mission_id, state)
SELECT ply.player_id,
       mis.mission_id,
       'active'
FROM ply
JOIN mis ON (ply.player_id + mis.mission_id) % 10 = 0;  -- reparte una por jugador
