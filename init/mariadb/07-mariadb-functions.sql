DELIMITER //

-- F1: Calcula el XP que otorga un tipo de zombi
CREATE FUNCTION fn_zombie_xp(tid INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT base_hp / 4 FROM zombie_types WHERE type_id = tid);
END //

-- F2: Calcula la experiencia ganada por una misión
CREATE OR REPLACE FUNCTION fn_calculate_mission_reward(mid INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_xp INT DEFAULT 0;
    DECLARE target_json JSON;
    DECLARE map_difficulty INT;

    -- Obtener el JSON de objetivos y la dificultad del mapa
    SELECT m.target_json, (mp.max_players * 10) 
    INTO target_json, map_difficulty
    FROM missions m 
    JOIN maps mp ON m.map_id = mp.map_id
    WHERE m.mission_id = mid;

    -- Sumar XP basado en los objetivos del JSON
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.kills')) AS SIGNED) * 10, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.escort')) AS SIGNED) * 50, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.zombies')) AS SIGNED) * 5, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.signal')) AS SIGNED) * 30, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.items')) AS SIGNED) * 20, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.find_survivor')) AS SIGNED) * 40, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.fetch')) AS SIGNED) * 15, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.slobbers')) AS SIGNED) * 25, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.reach_pier')) AS SIGNED) * 35, 0);
    SET total_xp = total_xp + COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(target_json, '$.boss')) AS SIGNED) * 100, 0);

    -- Ajustar XP según la dificultad del mapa
    SET total_xp = ROUND(total_xp * (1 + (map_difficulty / 100)));

    -- Garantizar un mínimo de 50 XP
    RETURN GREATEST(50, total_xp);
END //

-- F3: Obtiene el color hexadecimal según la rareza
CREATE FUNCTION fn_rarity_color(rid INT) 
RETURNS VARCHAR(7)
DETERMINISTIC
BEGIN
    RETURN (SELECT color_hex FROM rarities WHERE rarity_id = rid);
END //

-- F4: Obtiene la descripción de una habilidad
CREATE FUNCTION fn_skill_desc(sid INT) 
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN (SELECT description FROM skills WHERE skill_id = sid);
END //

DELIMITER ;