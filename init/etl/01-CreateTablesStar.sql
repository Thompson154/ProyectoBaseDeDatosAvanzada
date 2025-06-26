/* ============================= DIMENSIONES ============================= */
CREATE TABLE dim_time (
  time_key        SERIAL PRIMARY KEY,
  full_date       DATE UNIQUE,
  day             INT,
  month           INT,
  year            INT,
  weekday         VARCHAR(10)
);

CREATE TABLE dim_player (
  player_key      SERIAL PRIMARY KEY,
  user_id         INT UNIQUE,          -- BK p/ traza
  username        VARCHAR(40),
  level           INT,
  signup_date     DATE,
  region          VARCHAR(40)
);

CREATE TABLE dim_item (
  item_key        SERIAL PRIMARY KEY,
  item_id         INT UNIQUE,          -- BK
  name            VARCHAR(60),
  rarity          VARCHAR(30),
  base_damage     INT
);

CREATE TABLE dim_map (
  map_key         SERIAL PRIMARY KEY,
  map_id          INT UNIQUE,
  map_name        VARCHAR(60),
  has_night_cycle BOOLEAN,
  max_players     INT
);

CREATE TABLE dim_mission (
  mission_key     SERIAL PRIMARY KEY,
  mission_id      INT UNIQUE,
  mission_name    VARCHAR(80),
  mission_type    VARCHAR(40),
  target          JSONB
);

CREATE TABLE dim_zombie_type (
  zombie_type_key SERIAL PRIMARY KEY,
  type_id         INT UNIQUE,
  type_name       VARCHAR(60),
  base_hp         INT,
  base_damage     INT,
  abilities_csv   TEXT
);

/* =============================== HECHOS ================================ */
CREATE TABLE fact_game_events (
  fact_id           BIGSERIAL PRIMARY KEY,
  time_key          INT REFERENCES dim_time(time_key),
  player_key        INT REFERENCES dim_player(player_key),
  item_key          INT REFERENCES dim_item(item_key),
  map_key           INT REFERENCES dim_map(map_key),
  mission_key       INT REFERENCES dim_mission(mission_key),
  zombie_type_key   INT REFERENCES dim_zombie_type(zombie_type_key),
  kills             INT,
  deaths            INT,
  damage_dealt      INT,
  damage_taken      INT,
  session_leng_sec  INT
);
