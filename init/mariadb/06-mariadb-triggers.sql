/* T1: log si cambia daño de un arma */
CREATE TRIGGER trg_item_damage
AFTER UPDATE ON items
FOR EACH ROW
  IF OLD.base_damage <> NEW.base_damage THEN
     INSERT INTO item_change_log(item_id,old_damage,new_damage)
     VALUES (NEW.item_id,OLD.base_damage,NEW.base_damage);
  END IF;

/* T2: impedir item con durabilidad negativa */
CREATE TRIGGER trg_item_durability_chk
BEFORE INSERT ON items
FOR EACH ROW
  IF NEW.max_durability < 0 THEN
     SET NEW.max_durability = 0;
  END IF;

/* T3: asegurar nombre único de habilidad */
CREATE TRIGGER trg_skill_unique
BEFORE INSERT ON skills
FOR EACH ROW
  IF EXISTS (SELECT 1 FROM skills WHERE skill_name=NEW.skill_name) THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Skill already exists';
  END IF;

/* T4: rellenar color por defecto */
CREATE TRIGGER trg_rarity_color_default
BEFORE INSERT ON rarities
FOR EACH ROW
  IF NEW.color_hex IS NULL THEN
     SET NEW.color_hex = '#FFFFFF';
  END IF;

/* T5: auto-marca Story si map_id =1 */
CREATE TRIGGER trg_default_type_story
AFTER INSERT ON missions
FOR EACH ROW
  IF NEW.map_id = 1 THEN
     INSERT INTO missions_types_map VALUES (NEW.mission_id,1);
  END IF;

/* T6: cascada habilidad→zombie_type_abilities */
CREATE TRIGGER trg_add_default_ability
AFTER INSERT ON zombie_types
FOR EACH ROW
  INSERT INTO zombie_type_abilities(type_id,ability_id) VALUES (NEW.type_id,1);
