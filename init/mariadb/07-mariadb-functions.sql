DELIMITER //

/* F1: color por rareza */
CREATE FUNCTION fn_rarity_color(rid INT) RETURNS VARCHAR(7)
DETERMINISTIC RETURN (SELECT color_hex FROM rarities WHERE rarity_id=rid);

/* F2: dps base de un arma */
CREATE FUNCTION fn_weapon_dps(iid INT) RETURNS INT
DETERMINISTIC
RETURN (SELECT base_damage FROM items WHERE item_id=iid);

/* F3: XP que da un tipo de zombi */
CREATE FUNCTION fn_zombie_xp(tid INT) RETURNS INT
DETERMINISTIC
RETURN (SELECT base_hp/4 FROM zombie_types WHERE type_id=tid);

/* F4: nombre de mapa */
CREATE FUNCTION fn_map_name(mid INT) RETURNS VARCHAR(60)
DETERMINISTIC RETURN (SELECT map_name FROM maps WHERE map_id=mid);

/* F5: texto de habilidad */
CREATE FUNCTION fn_skill_desc(sid INT) RETURNS TEXT
DETERMINISTIC RETURN (SELECT description FROM skills WHERE skill_id=sid);

/* F6: nombre de rareza + color */
CREATE FUNCTION fn_rarity_label(rid INT) RETURNS VARCHAR(50)
DETERMINISTIC
RETURN CONCAT((SELECT rarity_name FROM rarities WHERE rarity_id=rid),
              ' (',fn_rarity_color(rid),')');

//
DELIMITER ;
