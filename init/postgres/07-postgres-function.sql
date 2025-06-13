/* F1: umbral de level-up */
CREATE FUNCTION fn_level_threshold(lvl INT) RETURNS INT
LANGUAGE sql IMMUTABLE AS
$$ SELECT 1000 * lvl; $$;

/* F2: sumar XP y aplicar level-up */
CREATE FUNCTION fn_add_xp(p_player INT, p_xp INT) RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE player_stats
  SET xp = xp + p_xp
  WHERE player_id = p_player;

  PERFORM fn_check_level_up(p_player);
END$$;

/* F3: chequeo y subida de nivel */
CREATE FUNCTION fn_check_level_up(p_player INT) RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
  cur_lvl  INT;
  cur_xp   INT;
BEGIN
  SELECT level, xp INTO cur_lvl, cur_xp
  FROM   player_stats
  WHERE  player_id = p_player;

  WHILE cur_xp >= fn_level_threshold(cur_lvl) LOOP
    cur_xp := cur_xp - fn_level_threshold(cur_lvl);
    cur_lvl := cur_lvl + 1;
  END LOOP;

  UPDATE player_stats
  SET level = cur_lvl, xp = cur_xp
  WHERE player_id = p_player;
END$$;

/* F4: bajar HP de jugador */
CREATE FUNCTION fn_damage_player() RETURNS TRIGGER AS $$
BEGIN
  UPDATE player_stats
  SET hp = GREATEST(hp - NEW.amount, 0)
  WHERE player_id = NEW.target_id;
  RETURN NEW;
END$$ LANGUAGE plpgsql;

/* F5: bajar HP de zombi y otorgar XP si muere */
CREATE FUNCTION fn_damage_zombie() RETURNS TRIGGER AS $$
DECLARE
  hp_left INT;
BEGIN
  UPDATE session_zombies
  SET current_hp = current_hp - NEW.amount
  WHERE zombie_id = NEW.target_id
  RETURNING current_hp INTO hp_left;

  IF hp_left <= 0 THEN
    INSERT INTO kill_logs(player_id,zombie_type,session_id)
    SELECT NEW.player_id, type_id, session_id
    FROM   session_zombies
    WHERE  zombie_id = NEW.target_id;

    PERFORM fn_add_xp(NEW.player_id, 250);  -- recompensa fija
  END IF;
  RETURN NEW;
END$$ LANGUAGE plpgsql;

-- Falta F6
