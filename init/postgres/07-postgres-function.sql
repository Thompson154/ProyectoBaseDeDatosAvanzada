/* F1: umbral de level-up */
CREATE FUNCTION fn_level_threshold(lvl INT) RETURNS INT
LANGUAGE sql IMMUTABLE AS
$$ SELECT 1000 * lvl; $$;

/* F2: sumar XP y aplicar level-up */
CREATE OR REPLACE FUNCTION fn_add_xp(p_player_id INT, p_xp INT)
RETURNS TABLE (new_level INT, new_xp INT)
LANGUAGE plpgsql AS $$
DECLARE
  v_current_level INT;
  v_current_xp INT;
  v_new_level INT;
  v_new_xp INT;
BEGIN
  SELECT level, xp INTO v_current_level, v_current_xp
  FROM player_stats
  WHERE player_id = p_player_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Player with ID % does not exist in player_stats', p_player_id;
  END IF;

  v_new_xp := v_current_xp + p_xp;
  v_new_level := v_current_level;

  WHILE v_new_xp >= fn_level_threshold(v_new_level) LOOP
    v_new_xp := v_new_xp - fn_level_threshold(v_new_level);
    v_new_level := v_new_level + 1;
  END LOOP;

  UPDATE player_stats
  SET level = v_new_level, xp = v_new_xp
  WHERE player_id = p_player_id;

  RETURN QUERY SELECT v_new_level, v_new_xp;
END;
$$;

/* F3: El Jugador toma el daño */
CREATE OR REPLACE FUNCTION fn_damage_player(p_player_id INT, p_damage INT)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
  v_hp_remaining INT;
BEGIN
  UPDATE player_stats
  SET hp = GREATEST(hp - p_damage, 0)
  WHERE player_id = p_player_id
  RETURNING hp INTO v_hp_remaining;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Player with ID % does not exist in player_stats', p_player_id;
  END IF;

  RETURN v_hp_remaining;
END;
$$;