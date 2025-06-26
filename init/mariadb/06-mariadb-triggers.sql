DELIMITER //

-- T1: Impide que un item tenga durabilidad negativa
CREATE TRIGGER trg_item_durability_chk
BEFORE INSERT ON items
FOR EACH ROW
BEGIN
    IF NEW.max_durability < 0 THEN
        SET NEW.max_durability = 0;
    END IF;
END //

-- T2: Asegura que el nombre de la habilidad sea único
CREATE TRIGGER trg_skill_unique
BEFORE INSERT ON skills
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM skills WHERE skill_name = NEW.skill_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Skill already exists';
    END IF;
END //

-- T3: Ver si se usa un item, que exista
CREATE TRIGGER check_item_id_before_insert
BEFORE INSERT ON player_inventory
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM items WHERE item_id = NEW.item_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid item_id: does not exist in items table';
    END IF;
END //


DELIMITER ;