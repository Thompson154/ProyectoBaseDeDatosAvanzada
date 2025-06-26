/* T1: level-up cuando se actualiza xp */
CREATE FUNCTION fn_level_up_trigger() RETURNS TRIGGER AS $$
DECLARE
  cur_lvl  INT := NEW.level;
  cur_xp   BIGINT := NEW.xp;
BEGIN
  WHILE cur_xp >= fn_level_threshold(cur_lvl) LOOP
    cur_xp := cur_xp - fn_level_threshold(cur_lvl);
    cur_lvl := cur_lvl + 1;
  END LOOP;

  NEW.level := cur_lvl;
  NEW.xp := cur_xp;
  RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_lvl
BEFORE UPDATE OF xp ON player_stats
FOR EACH ROW EXECUTE FUNCTION fn_level_up_trigger();

/* T2: capacidad de inventario */
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

/* T3: reduce durabilidad del arma usada */
/*CREATE FUNCTION fn_decrease_durability() RETURNS TRIGGER AS $$
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
EXECUTE FUNCTION fn_decrease_durability();*/