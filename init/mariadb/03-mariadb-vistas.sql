DELIMITER //

-- V1: Catálogo de tipos de zombis con sus habilidades asociadas
CREATE OR REPLACE VIEW v_zombie_abilities AS
SELECT 
    z.type_id,
    z.type_name,
    z.base_hp,
    z.base_damage,
    GROUP_CONCAT(a.ability_name ORDER BY a.ability_name SEPARATOR ', ') AS abilities,
    COUNT(a.ability_id) AS ability_count
FROM zombie_types z
LEFT JOIN zombie_type_abilities za 
    ON z.type_id = za.type_id
LEFT JOIN abilities a 
    ON za.ability_id = a.ability_id
GROUP BY z.type_id, z.type_name, z.base_hp, z.base_damage;
//

DELIMITER ;