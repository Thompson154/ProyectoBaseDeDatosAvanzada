/* SP1: atacar zombi */
CREATE OR REPLACE PROCEDURE sp_attack_zombie(
    p_player_id INT,
    p_zombie_id INT,
    p_damage INT,
    p_weapon_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_session_id INTEGER;
    v_hp_remaining INTEGER;
    v_action VARCHAR(20);
    v_notes TEXT;
BEGIN
    SELECT session_id INTO v_session_id
    FROM session_zombies
    WHERE zombie_id = p_zombie_id;

    v_action := CASE
                    WHEN p_weapon_id IS NOT NULL THEN 'item_use'
                    ELSE 'melee_attack'
                END;

    UPDATE session_zombies
    SET current_hp = GREATEST(current_hp - p_damage, 0)
    WHERE zombie_id = p_zombie_id
    RETURNING current_hp INTO v_hp_remaining;

    v_notes := CASE
                  WHEN v_hp_remaining = 0 THEN 'Zombie defeated'
                  ELSE format('Jugador %s hizo daño de %s al zombie %s', p_player_id, p_damage, p_zombie_id)
               END;

    INSERT INTO combat_logs (
        event_time,
        player_id,
        target_type,
        target_id,
        weapon_id,
        action,
        amount,
        notes
    ) VALUES (
        NOW(),
        p_player_id,
        'zombie',
        p_zombie_id,
        p_weapon_id,
        v_action,
        p_damage,
        v_notes
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in sp_attack_zombie: %', SQLERRM;
        ROLLBACK;
END;
$$;

/* SP2: curar jugador */
CREATE PROCEDURE sp_heal_player(p_player INT, p_amt INT)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE player_stats SET hp = LEAST(hp + p_amt, 100)
  WHERE player_id = p_player;
END$$;


/* SP3: añadir objeto a inventario */
CREATE PROCEDURE sp_add_item(p_inv INT,p_item INT,p_qty INT)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO inventory_items(inventory_id,item_id,quantity)
  VALUES (p_inv,p_item,p_qty)
  ON CONFLICT (inventory_id,item_id) DO
    UPDATE SET quantity = inventory_items.quantity + EXCLUDED.quantity;
END$$;

/* SP4: iniciar misión */
CREATE PROCEDURE sp_start_mission(p_player INT,p_mission INT)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO player_missions(player_id,mission_id,state)
  VALUES (p_player,p_mission,'active')
  ON CONFLICT DO NOTHING;
END$$;

/* SP5: completar misión */
CREATE PROCEDURE sp_complete_mission(p_player INT,p_mission INT)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE player_missions
  SET state='completed', finished_at=NOW()
  WHERE player_id=p_player AND mission_id=p_mission;
  PERFORM fn_add_xp(p_player,500);
END$$;
