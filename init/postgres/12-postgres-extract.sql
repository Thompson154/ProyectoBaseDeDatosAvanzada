/* ================= dim_player ============================= */
\COPY (
  SELECT  p.player_id   AS user_id,
          u.username,
          ps.level,
          u.created_at::date AS signup_date,
          'NA'::text        AS region       -- cambia si luego añades tabla de regiones
  FROM players p
  JOIN users        u  USING (user_id)
  JOIN player_stats ps USING (player_id)
) TO '/csv/player.csv' CSV HEADER;

/* ================= dim_time =============================== */
\COPY (
  SELECT  d::date                        AS full_date,
          EXTRACT(DAY    FROM d)::int    AS day,
          EXTRACT(MONTH  FROM d)::int    AS month,
          EXTRACT(YEAR   FROM d)::int    AS year,
          TO_CHAR(d, 'Dy')               AS weekday
  FROM generate_series('2024-01-01'::date,
                       '2026-12-31'::date,
                       '1 day') d
) TO '/csv/time.csv' CSV HEADER;


/* ================= fact_game_events ======================= */
\COPY (
  SELECT  ms.started_at                              AS event_timestamp,
          p.player_id,
          COALESCE(ii.item_id,0)                     AS item_id,
          ms.map_id,
          pm.mission_id,
          sz.type_id,
          1                                          AS kills,
          0                                          AS deaths,
          sz.current_hp                              AS damage_dealt,
          0                                          AS damage_taken,
          EXTRACT(EPOCH FROM (COALESCE(mp.left_at,now())-mp.joined_at))::int
                                                    AS session_leng_sec
  FROM session_zombies sz
  JOIN map_sessions  ms  USING (session_id)
  JOIN map_players   mp  USING (session_id)
  JOIN players       p   USING (player_id)
  LEFT JOIN inventory_items ii
         ON ii.inventory_id = (
            SELECT inventory_id
            FROM inventories
            WHERE player_id = p.player_id
            LIMIT 1)
  LEFT JOIN player_missions pm
         ON pm.player_id = p.player_id
) TO '/csv/fact_game_events.csv' CSV HEADER;
