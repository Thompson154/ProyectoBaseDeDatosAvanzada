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

