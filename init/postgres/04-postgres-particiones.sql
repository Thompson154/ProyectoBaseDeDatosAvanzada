/* Combat log particionado por mes (rangos) */
CREATE TABLE combat_logs (
  log_id       BIGSERIAL,
  event_time   TIMESTAMPTZ NOT NULL,
  player_id    INTEGER REFERENCES players(player_id),
  target_type  VARCHAR(10),   -- 'zombie'|'player'
  target_id    INTEGER,
  weapon_id    INTEGER,
  action       VARCHAR(20),   -- 'damage'|'kill'|'skill'|'heal'
  amount       INTEGER,
  notes        TEXT,
  PRIMARY KEY (log_id, event_time)
) PARTITION BY RANGE (event_time);

CREATE TABLE combat_logs_2025_06 PARTITION OF combat_logs
  FOR VALUES FROM ('2025-06-01') TO ('2025-07-01');

CREATE TABLE combat_logs_2025_07 PARTITION OF combat_logs
  FOR VALUES FROM ('2025-07-01') TO ('2025-08-01');

  CREATE TABLE combat_logs_2025_08 PARTITION OF combat_logs
  FOR VALUES FROM ('2025-08-01') TO ('2025-09-01');

--Generar Data--------------------------------------------------------------------------------

INSERT INTO combat_logs (event_time, player_id, target_type, target_id, weapon_id, action, amount, notes)
SELECT
    -- Fechas distribuidas en junio, julio y agosto de 2025
    timestamp '2025-06-01' + 
    (CASE 
        WHEN g.rn % 3 = 0 THEN interval '0 days' + (random() * 29 * interval '1 day')
        WHEN g.rn % 3 = 1 THEN interval '30 days' + (random() * 30 * interval '1 day')
        ELSE interval '60 days' + (random() * 30 * interval '1 day')
    END) AS event_time,
    -- player_id de la tabla players (1 a 50, según tu inserción anterior)
    (random() * 49 + 1)::INTEGER AS player_id,
    -- target_type: 70% zombie, 30% player
    CASE WHEN random() < 0.7 THEN 'zombie' ELSE 'player' END AS target_type,
    -- target_id: ID de zombie (1-9) o player (1-50), según target_type
    CASE 
        WHEN random() < 0.7 THEN (random() * 8 + 1)::INTEGER 
        ELSE (random() * 49 + 1)::INTEGER 
    END AS target_id,
    -- weapon_id: ID de item (1-10, según tu tabla items), o NULL para acciones sin arma
    CASE WHEN random() < 0.8 THEN (random() * 9 + 1)::INTEGER ELSE NULL END AS weapon_id,
    -- action: distribución ponderada (50% damage, 20% kill, 20% skill, 10% heal)
    CASE 
        WHEN random() < 0.5 THEN 'damage'
        WHEN random() < 0.7 THEN 'kill'
        WHEN random() < 0.9 THEN 'skill'
        ELSE 'heal'
    END AS action,
    -- amount: valores realistas según la acción
    CASE 
        WHEN random() < 0.5 THEN (random() * 50 + 10)::INTEGER  -- damage: 10-60
        WHEN random() < 0.7 THEN (random() * 100 + 50)::INTEGER -- kill: 50-150
        WHEN random() < 0.9 THEN (random() * 20 + 5)::INTEGER   -- skill: 5-25
        ELSE (random() * 40 + 20)::INTEGER                      -- heal: 20-60
    END AS amount,
    -- notes: 20% de probabilidad de incluir una nota
    CASE WHEN random() < 0.2 THEN 
        format('Combat event: %s by player %s', 
               CASE 
                   WHEN random() < 0.5 THEN 'damage' 
                   WHEN random() < 0.7 THEN 'kill' 
                   WHEN random() < 0.9 THEN 'skill' 
                   ELSE 'heal' 
               END, 
               (random() * 49 + 1)::INTEGER)
    ELSE NULL 
    END AS notes
FROM generate_series(1, 10000) g(rn);
