/* T1: daño al jugador */
CREATE TRIGGER trg_player_damage
AFTER INSERT ON combat_logs
WHEN (NEW.target_type='player' AND NEW.action='damage')
FOR EACH ROW EXECUTE FUNCTION fn_damage_player();

/* T2: daño al zombi */
CREATE TRIGGER trg_zombie_damage
AFTER INSERT ON combat_logs
WHEN (NEW.target_type='zombie' AND NEW.action='damage')
FOR EACH ROW EXECUTE FUNCTION fn_damage_zombie();

/* T3: level-up cuando se actualiza xp */
CREATE FUNCTION fn_level_up_trigger() RETURNS TRIGGER AS $$
BEGIN
  PERFORM fn_check_level_up(NEW.player_id);
  RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_lvl
AFTER UPDATE OF xp ON player_stats
FOR EACH ROW EXECUTE FUNCTION fn_level_up_trigger();

/* T4: capacidad de inventario */
CREATE FUNCTION fn_inv_capacity() RETURNS TRIGGER AS $$
DECLARE total INT;
BEGIN
  SELECT COALESCE(SUM(quantity),0)
  INTO   total
  FROM   inventory_items
  WHERE  inventory_id = NEW.inventory_id;

  IF total + NEW.quantity > (SELECT capacity FROM inventories WHERE inventory_id=NEW.inventory_id) THEN
     RAISE EXCEPTION 'Exceeds inventory capacity';
  END IF;
  RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inv_capacity
BEFORE INSERT OR UPDATE ON inventory_items
FOR EACH ROW EXECUTE FUNCTION fn_inv_capacity();

/* T5: reduce durabilidad del arma usada */
CREATE FUNCTION fn_decrease_durability() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.weapon_id IS NOT NULL THEN
     UPDATE inventory_items
     SET quantity = quantity       -- placeholder; durabilidad sería otra col.
     WHERE item_id = NEW.weapon_id
       AND inventory_id = (SELECT inventory_id FROM inventories i WHERE i.player_id = NEW.player_id);
  END IF;
  RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_weapon_use
AFTER INSERT ON combat_logs
WHEN (NEW.action = 'damage')
EXECUTE FUNCTION fn_decrease_durability();

/* T6: bloquear suicidio de transacción de zombi repetido */
CREATE FUNCTION fn_unique_kill() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM kill_logs WHERE zombie_type=NEW.zombie_type AND player_id=NEW.player_id AND session_id=NEW.session_id) THEN
     RETURN NULL; -- ignora duplicates
  END IF;
  RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_unique_kill
BEFORE INSERT ON kill_logs
FOR EACH ROW EXECUTE FUNCTION fn_unique_kill();
