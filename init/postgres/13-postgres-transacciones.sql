/*Transacción 1 para simular un ataque de jugador a zombi con contraataque*/
BEGIN;

-- Paso 1: Jugador 1 ataca al zombi 50 con 30 de daño usando el arma 2
CALL sp_attack_zombie(1, 50, 30, 2);

-- Paso 2: Verificar si el zombi sigue vivo
DO $$
DECLARE
    v_hp_remaining INTEGER;
BEGIN
    SELECT current_hp INTO v_hp_remaining
    FROM session_zombies
    WHERE zombie_id = 50;

    -- Paso 3: Si el zombi sigue vivo, contraataca al jugador con 20 de daño
    IF v_hp_remaining > 0 THEN
        PERFORM fn_damage_player(1, 20);
        INSERT INTO combat_logs (
            event_time, player_id, target_type, target_id, weapon_id, action, amount, notes
        ) VALUES (
            NOW(), 50, 'player', 1, NULL, 'damage', 20, 'Zombie 50 counterattacks player 1'
        );
    -- Paso 4: Si el zombi murió, otorgar 100 XP al jugador
    ELSE
        PERFORM fn_add_xp(1, 100);
        INSERT INTO combat_logs (
            event_time, player_id, target_type, target_id, weapon_id, action, amount, notes
        ) VALUES (
            NOW(), 1, 'zombie', 50, NULL, 'kill', 100, 'Player 1 killed zombie 50 and gained 100 XP'
        );
    END IF;
END $$;

COMMIT;



/*Transacción 2 para completar una misión y otorgar una recompensa*/
BEGIN;

-- Paso 1: Completar la misión 3 para el jugador 2
CALL sp_complete_mission(2, 3);

-- Paso 2: Obtener el inventario del jugador
DO $$
DECLARE
    v_inventory_id INTEGER;
BEGIN
    SELECT inventory_id INTO v_inventory_id
    FROM inventories
    WHERE player_id = 2;

    -- Paso 3: Agregar un ítem (ID 5, cantidad 2) como recompensa
    CALL sp_add_item(v_inventory_id, 5, 2);
END $$;

-- Paso 4: Registrar la recompensa en combat_logs
INSERT INTO combat_logs (
    event_time, player_id, target_type, target_id, weapon_id, action, amount, notes
) VALUES (
    NOW(), 2, 'mission', 3, NULL, 'reward', 2, 'Player 2 received item 5 (x2) for completing mission 3'
);

COMMIT;



/*Transacción 3 para curar un jugador y desbloquear una habilidad*/
BEGIN;

-- Paso 1: Curar al jugador 3 con 40 HP
CALL sp_heal_player(3, 40);

-- Paso 2: Verificar si el jugador cumple con el nivel para desbloquear la habilidad 3
DO $$
DECLARE
    v_level INTEGER;
BEGIN
    SELECT level INTO v_level
    FROM player_stats
    WHERE player_id = 3;

    -- Si el nivel es 5 o mayor, desbloquear la habilidad 3
    IF v_level >= 5 THEN
        INSERT INTO player_skills (player_id, skill_id, unlocked_at)
        VALUES (3, 3, NOW())
        ON CONFLICT (player_id, skill_id) DO NOTHING;
    END IF;
END $$;

-- Paso 3: Registrar la curación y desbloqueo en combat_logs
INSERT INTO combat_logs (
    event_time, player_id, target_type, target_id, weapon_id, action, amount, notes
) VALUES (
    NOW(), 3, 'player', 3, NULL, 'heal', 40, 'Player 3 healed for 40 HP'
),
(
    NOW(), 3, 'skill', 3, NULL, 'unlock', 1, 'Player 3 unlocked skill 3'
);

COMMIT;