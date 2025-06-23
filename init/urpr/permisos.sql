GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;


GRANT SELECT, INSERT, UPDATE, DELETE ON 
    users, players, player_stats, inventories, inventory_items,
    player_skills, map_sessions, map_players, player_missions, session_zombies 
TO gm;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO gm;


GRANT SELECT, INSERT, UPDATE ON 
    players, player_stats, inventories, inventory_items, player_skills, player_missions, map_players 
TO player;


GRANT SELECT ON 
    users, players, player_stats, map_sessions, map_players, session_zombies 
TO reporter;


--MariaDB

GRANT ALL PRIVILEGES ON game_meta.* TO 'admin'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE ON 
    items, skills, maps, missions, zombie_types, abilities, missions_types_map 
TO 'gm'@'%';

GRANT SELECT ON 
    items, skills, maps, missions 
TO 'player'@'%';

GRANT SELECT ON game_meta.* TO 'reporter'@'%';
