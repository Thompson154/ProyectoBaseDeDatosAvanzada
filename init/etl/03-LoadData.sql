/* =================== CARGA DE DIMENSIONES =================== */

/* dim_time */
COPY dim_time(full_date,day,month,year,weekday,time_key)
FROM '/csv/time.csv' CSV HEADER;

/* dim_player */
COPY dim_player(user_id,username,level,signup_date,region,player_key)
FROM '/csv/player.csv' CSV HEADER;

/* dim_item  (4 columnas: item_key se autogenera) */
COPY dim_item(item_id,name,rarity,base_damage)
FROM '/csv/items.csv' CSV HEADER;

/* dim_map */
COPY dim_map(map_id,map_name,has_night_cycle,max_players,map_key)
FROM '/csv/maps.csv' CSV HEADER;

/* dim_mission */
COPY dim_mission(mission_id,mission_name,mission_type,target,mission_key)
FROM '/csv/missions.csv' CSV HEADER;

/* dim_zombie_type */
COPY dim_zombie_type(type_id,type_name,base_hp,base_damage,abilities_csv,zombie_type_key)
FROM '/csv/zombie_types.csv' CSV HEADER;

/* ====================== CARGA DE HECHOS ===================== */
COPY fact_game_events(time_key,player_key,item_key,map_key,mission_key,
                      zombie_type_key,kills,deaths,damage_dealt,damage_taken,
                      session_leng_sec)
FROM '/csv/fact_game_events.csv' CSV HEADER;
