/* SP1: atacar zombi */
CREATE PROCEDURE sp_attack_zombie(p_player INT, p_zombie INT, p_dmg INT, p_weapon INT)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO combat_logs(event_time,player_id,target_type,target_id,weapon_id,action,amount)
  VALUES (NOW(), p_player,'zombie',p_zombie,p_weapon,'damage',p_dmg);
END$$;

/* SP2: curar jugador */
CREATE PROCEDURE sp_heal_player(p_player INT, p_amt INT)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE player_stats SET hp = LEAST(hp + p_amt, 100)
  WHERE player_id = p_player;
END$$;

/* SP3: usar habilidad */
CREATE PROCEDURE sp_use_skill(p_player INT,p_skill INT,p_target INT,p_ttype TEXT)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO combat_logs(event_time,player_id,target_type,target_id,action,amount,notes)
  VALUES (NOW(),p_player,p_ttype,p_target,'skill',0,'skill='||p_skill);
END$$;

/* SP4: añadir objeto a inventario */
CREATE PROCEDURE sp_add_item(p_inv INT,p_item INT,p_qty INT)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO inventory_items(inventory_id,item_id,quantity)
  VALUES (p_inv,p_item,p_qty)
  ON CONFLICT (inventory_id,item_id) DO
    UPDATE SET quantity = inventory_items.quantity + EXCLUDED.quantity;
END$$;

/* SP5: iniciar misión */
CREATE PROCEDURE sp_start_mission(p_player INT,p_mission INT)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO player_missions(player_id,mission_id,state)
  VALUES (p_player,p_mission,'active')
  ON CONFLICT DO NOTHING;
END$$;

/* SP6: completar misión */
CREATE PROCEDURE sp_complete_mission(p_player INT,p_mission INT)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE player_missions
  SET state='completed', finished_at=NOW()
  WHERE player_id=p_player AND mission_id=p_mission;
  PERFORM fn_add_xp(p_player,500);
END$$;
