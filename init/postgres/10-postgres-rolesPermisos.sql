CREATE USER admin WITH PASSWORD 'admin123';
CREATE USER gm WITH PASSWORD 'gm123';
CREATE USER player WITH PASSWORD 'player123';
CREATE USER reporter WITH PASSWORD 'report123';


CREATE ROLE role_admin;
CREATE ROLE role_gm;
CREATE ROLE role_player;
CREATE ROLE role_reporter;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_admin;


GRANT SELECT, INSERT, UPDATE, DELETE ON 
    users, players, player_stats, inventories, inventory_items,
    player_skills, map_sessions, map_players, player_missions, session_zombies 
TO role_gm;


GRANT SELECT, INSERT, UPDATE ON 
    players, player_stats, inventories, inventory_items, 
    player_skills, player_missions, map_players 
TO role_player;


GRANT SELECT ON 
    users, players, player_stats, map_sessions, map_players, session_zombies 
TO role_reporter;


-- Paso 4: Asignar roles de grupo a usuarios
GRANT role_admin TO admin;
GRANT role_gm TO gm;
GRANT role_player TO player;
GRANT role_reporter TO reporter;

-- Revocaciones
-- REVOKE ALL ON ALL TABLES IN SCHEMA public FROM role_admin, role_gm, role_player, role_reporter;
-- REVOKE role_admin FROM admin;
-- REVOKE role_gm FROM gm;
-- REVOKE role_player FROM player;
-- REVOKE role_reporter FROM reporter;
-- DROP ROLE role_admin, role_gm, role_player, role_reporter;