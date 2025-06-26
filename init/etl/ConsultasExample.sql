/* filas y muestra */
SELECT COUNT(*) FROM fact_game_events;
SELECT * FROM dim_item LIMIT 5;

/* kills por rareza */
SELECT di.rarity, SUM(f.kills) AS kills
FROM fact_game_events f
JOIN dim_item di USING (item_key)
GROUP BY di.rarity
ORDER BY kills DESC;

/* DPS promedio por mapa */
SELECT dm.map_name,
       ROUND(SUM(f.damage_dealt)::numeric / NULLIF(SUM(f.session_leng_sec),0),2) AS dps
FROM fact_game_events f
JOIN dim_map dm USING (map_key)
GROUP BY dm.map_name
ORDER BY dps DESC;
