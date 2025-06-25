/*View 1: Progreso del Jugador*/
CREATE VIEW v_player_progress AS
SELECT 
    u.username,
    p.player_id,
    ps.level,
    ps.xp,
    ps.hp,
    ps.stamina,
    i.capacity AS inventory_capacity,
    COUNT(ii.item_id) AS items_in_inventory,
    COUNT(psk.skill_id) AS skills_unlocked,
    COUNT(pm.mission_id) AS active_missions,
    COUNT(CASE WHEN pm.state = 'completed' THEN 1 END) AS completed_missions
FROM users u
INNER JOIN players p ON u.user_id = p.user_id
INNER JOIN player_stats ps ON p.player_id = ps.player_id
INNER JOIN inventories i ON p.player_id = i.player_id
INNER JOIN inventory_items ii ON i.inventory_id = ii.inventory_id
INNER JOIN player_skills psk ON p.player_id = psk.player_id
INNER JOIN player_missions pm ON p.player_id = pm.player_id
GROUP BY u.username, p.player_id, ps.level, ps.xp, ps.hp, ps.stamina, i.capacity
ORDER BY ps.level DESC, ps.xp DESC;

/*View 2: Actividad de las sesiones*/
CREATE VIEW v_active_map_sessions AS
SELECT 
    ms.session_id,
    ms.map_id,
    ms.started_at,
    ms.is_night,
    COUNT(mp.player_id) AS players_in_session,
    COUNT(sz.zombie_id) AS zombies_in_session
FROM map_sessions ms
LEFT JOIN map_players mp ON ms.session_id = mp.session_id AND mp.left_at IS NULL
LEFT JOIN session_zombies sz ON ms.session_id = sz.session_id
GROUP BY ms.session_id, ms.map_id, ms.started_at, ms.is_night
ORDER BY ms.started_at DESC;

/*Vista 3: Resumen de Progreso*/
CREATE VIEW v_mission_progress_summary AS
SELECT 
    u.username,
    p.player_id,
    pm.mission_id,
    pm.state,
    pm.started_at,
    pm.finished_at,
    EXTRACT(EPOCH FROM (COALESCE(pm.finished_at, NOW()) - pm.started_at))/60 AS minutes_to_complete
FROM users u
INNER JOIN players p ON u.user_id = p.user_id
INNER JOIN player_missions pm ON p.player_id = pm.player_id
ORDER BY u.username, pm.started_at DESC;