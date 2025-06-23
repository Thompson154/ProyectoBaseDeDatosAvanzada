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

-- primer partition de ejemplo
CREATE TABLE combat_logs_2025_06 PARTITION OF combat_logs
  FOR VALUES FROM ('2025-06-01') TO ('2025-07-01');

/* Registro de muertes */
CREATE TABLE kill_logs (
  kill_id     BIGSERIAL PRIMARY KEY,
  event_time  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  player_id   INTEGER REFERENCES players(player_id),
  zombie_type INTEGER,
  session_id  INTEGER
);
