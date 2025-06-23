CREATE INDEX idx_items_rarity     ON items(rarity_id);
CREATE INDEX idx_missions_map     ON missions(map_id);
CREATE INDEX idx_ztypes_damage_hp ON zombie_types(base_damage,base_hp);
CREATE INDEX idx_skill_name       ON skills(skill_name);
CREATE INDEX idx_mission_type     ON missions_types_map(type_id);
CREATE INDEX idx_ztype_ability    ON zombie_type_abilities(ability_id);
