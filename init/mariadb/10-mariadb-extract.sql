/* ============= dim_item ================================ */
USE videojuego;
SELECT  i.item_id,
        i.name,
        r.rarity_name,
        i.base_damage
INTO OUTFILE '/csv/items.csv'
FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'
LINES  TERMINATED BY '\n'
FROM items i
JOIN rarities r USING (rarity_id);

/* ============= dim_map ================================= */
SELECT  map_id,
        map_name,
        has_night_cycle,
        max_players
INTO OUTFILE '/csv/maps.csv'
FIELDS TERMINATED BY ','  ENCLOSED BY '"'
LINES  TERMINATED BY '\n'
FROM maps;

/* ============= dim_mission ============================= */
SELECT  m.mission_id,
        m.mission_name,
        GROUP_CONCAT(mt.type_name) AS mission_type,
        m.target_json
INTO OUTFILE '/csv/missions.csv'
FIELDS TERMINATED BY ','  ENCLOSED BY '"'
LINES  TERMINATED BY '\n'
FROM missions m
LEFT JOIN missions_types_map mm USING (mission_id)
LEFT JOIN mission_types      mt USING (type_id)
GROUP BY m.mission_id;

/* ============= dim_zombie_type ========================= */
SELECT  z.type_id,
        z.type_name,
        z.base_hp,
        z.base_damage,
        GROUP_CONCAT(a.ability_name SEPARATOR ';') AS abilities_csv
INTO OUTFILE '/csv/zombie_types.csv'
FIELDS TERMINATED BY ','  ENCLOSED BY '"'
LINES  TERMINATED BY '\n'
FROM zombie_types z
LEFT JOIN zombie_type_abilities za USING (type_id)
LEFT JOIN abilities             a  USING (ability_id)
GROUP BY z.type_id;
