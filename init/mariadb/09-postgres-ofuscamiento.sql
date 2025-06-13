/* Borra textos narrativos que pudieran ser copyright-sensitive */
UPDATE zombie_types  SET lore_text = NULL;
UPDATE abilities     SET effect_desc = NULL;
UPDATE missions      SET mission_name = CONCAT('Mission_', mission_id);
