/*Transacción 1: Intercambio de ítems entre jugadores en una sesión*/
BEGIN;

SET LOCAL session_id_var = 0;

SELECT session_id INTO session_id_var
FROM map_players mp1
WHERE mp1.player_id = 1 AND mp1.left_at IS NULL
  AND EXISTS (
      SELECT 1 FROM map_players mp2
      WHERE mp2.session_id = mp1.session_id AND mp2.player_id = 2 AND mp2.left_at IS NULL
  );

SELECT CASE
    WHEN session_id_var = 0 THEN
        (SELECT RAISE('ERROR', 'Ambos jugadores deben estar en la misma sesión activa'))
    ELSE session_id_var
END;

UPDATE inventory_items
SET quantity = quantity - 1
WHERE inventory_id = (SELECT inventory_id FROM inventories WHERE player_id = 1)
  AND item_id = 5
  AND quantity > 0;

CALL sp_add_item(
    (SELECT inventory_id FROM inventories WHERE player_id = 2),
    5,
    1
);

INSERT INTO combat_logs (event_time, player_id, target_type, target_id, action, amount, notes)
VALUES (CURRENT_TIMESTAMP, 1, 'player', 2, 'item_trade', 1, 'Transferred item_id 5 to player 2');

COMMIT;



/*Transacción 2: Curación de un jugador y desbloqueo de habilidad tras alcanzar nivel*/
BEGIN;

SET LOCAL new_level_var = 0;

CALL sp_heal_player(1, 30);

SELECT fn_add_xp(1, 500) INTO new_level_var;

INSERT INTO player_skills (player_id, skill_id, unlocked_at)
SELECT 1, 3, CURRENT_TIMESTAMP
WHERE new_level_var >= 5
ON CONFLICT (player_id, skill_id) DO NOTHING;

COMMIT;



/*Transacción 3: Reasignación de estadísticas del jugador con auditoría*/
BEGIN;

SET LOCAL max_stats_var = 0;

SELECT level * 50 INTO max_stats_var
FROM player_stats
WHERE player_id = 1;

UPDATE player_stats
SET hp = 80, stamina = 120
WHERE player_id = 1
  AND 80 + 120 <= max_stats_var;
SELECT CASE
    WHEN (SELECT ROW_COUNT()) = 0 THEN
        (SELECT RAISE('ERROR', 'Suma de HP y Stamina excede el límite basado en el nivel'))
    ELSE 1
END;

INSERT INTO combat_logs (event_time, player_id, target_type, target_id, action, amount, notes)
VALUES (CURRENT_TIMESTAMP, 1, 'player', 1, 'stats_reassign', 0, 'Reassigned HP to 80, Stamina to 120');

COMMIT;