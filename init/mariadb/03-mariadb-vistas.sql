/* V1: catálogo completo de armas con color */
CREATE VIEW v_items_full AS
SELECT i.item_id,i.name,fn_rarity_label(i.rarity_id) AS rarity,
       i.base_damage,i.max_durability
FROM items i;

/* V2: habilidades por tipo de zombi */
CREATE VIEW v_zombie_type_skills AS
SELECT z.type_name,a.ability_name
FROM zombie_types z
JOIN zombie_type_abilities za USING(type_id)
JOIN abilities a USING(ability_id);

/* V3: misiones con tipo y mapa */
CREATE VIEW v_mission_catalog AS
SELECT m.mission_id,m.mission_name,fn_map_name(m.map_id) AS map,
       GROUP_CONCAT(mt.type_name) AS types
FROM missions m
LEFT JOIN missions_types_map mm USING(mission_id)
LEFT JOIN mission_types mt USING(type_id)
GROUP BY m.mission_id;
