DELIMITER //

/* SP1: registrar arma */
CREATE PROCEDURE sp_add_weapon (p_name VARCHAR(60), p_rarity INT, p_dmg INT, p_dur INT)
BEGIN
  INSERT INTO items(rarity_id,name,base_damage,max_durability)
  VALUES (p_rarity,p_name,p_dmg,p_dur);
END;

/* SP2: asignar habilidad a tipo de zombi */
CREATE PROCEDURE sp_assign_ability (p_type INT,p_ab INT)
BEGIN
  REPLACE INTO zombie_type_abilities(type_id,ability_id) VALUES (p_type,p_ab);
END;

/* SP3: crear misión */
CREATE PROCEDURE sp_create_mission (p_map INT,p_name VARCHAR(80),p_json JSON)
BEGIN
  INSERT INTO missions(map_id,mission_name,target_json) VALUES (p_map,p_name,p_json);
END;

/* SP4: rareza label */
CREATE PROCEDURE sp_get_rarity_label (p_rarity INT, OUT p_label VARCHAR(50))
BEGIN
  SET p_label = fn_rarity_label(p_rarity);
END;

/* SP5: stats de arma */
CREATE PROCEDURE sp_weapon_stats (p_item INT)
BEGIN
  SELECT i.name,r.rarity_name,i.base_damage,i.max_durability
  FROM items i JOIN rarities r USING(rarity_id) WHERE i.item_id=p_item;
END;

/* SP6: loot aleatorio según rareza */
CREATE PROCEDURE sp_random_loot (p_rarity INT, OUT p_item INT)
BEGIN
  SELECT item_id INTO p_item
  FROM items WHERE rarity_id=p_rarity
  ORDER BY RAND() LIMIT 1;
END;
//
DELIMITER ;
