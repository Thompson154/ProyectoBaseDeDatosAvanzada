import pandas as pd
from pathlib import Path

src = Path("/init/etl/csv")            # origen de los .csv extraídos
dst = Path("/csv")      # destino intermedio (crea carpeta)
dst.mkdir(exist_ok=True)

# ---------- Dim Tiempo ----------
df_time = pd.read_csv(src / "dim_time.csv")
df_time["time_key"] = range(1, len(df_time)+1)
df_time.to_csv(dst / "dim_time_xf.csv", index=False)

# ---------- Dim Player ----------
df_player = pd.read_csv(src / "dim_player.csv")
df_player["player_key"] = range(1, len(df_player)+1)
df_player.to_csv(dst / "dim_player_xf.csv", index=False)

# ---------- Dim Item ----------
df_item = pd.read_csv(src / "dim_item.csv")
df_item["item_key"] = range(1, len(df_item)+1)
df_item.to_csv(dst / "dim_item_xf.csv", index=False)

# ---------- Dim Map ----------
df_map = pd.read_csv(src / "dim_map.csv")
df_map["map_key"] = range(1, len(df_map)+1)
df_map.to_csv(dst / "dim_map_xf.csv", index=False)

# ---------- Dim Mission ----------
df_mis = pd.read_csv(src / "dim_mission.csv")
df_mis["mission_key"] = range(1, len(df_mis)+1)
df_mis.to_csv(dst / "dim_mission_xf.csv", index=False)

# ---------- Dim Zombie ----------
df_z = pd.read_csv(src / "dim_zombie_type.csv")
df_z["zombie_type_key"] = range(1, len(df_z)+1)
df_z.to_csv(dst / "dim_zombie_type_xf.csv", index=False)

# ---------- Hechos -------------
df_fact = pd.read_csv(src / "fact_game_events.csv")

# mapear BK ➜ surrogate keys
merge_cols = {
    "item_id": ("item_key", df_item[["item_id", "item_key"]]),
    "player_id": ("player_key", df_player[["user_id", "player_key"]].rename(columns={"user_id":"player_id"})),
    "map_id": ("map_key", df_map[["map_id", "map_key"]]),
    "mission_id": ("mission_key", df_mis[["mission_id", "mission_key"]]),
    "type_id": ("zombie_type_key", df_z[["type_id", "zombie_type_key"]])
}

for src_col, (tgt_col, dim) in merge_cols.items():
    df_fact = df_fact.merge(dim, on=src_col, how="left")
    df_fact.drop(columns=[src_col], inplace=True)

# time_key por fecha
df_fact = df_fact.merge(df_time[["full_date","time_key"]],
                        left_on=pd.to_datetime(df_fact["event_timestamp"]).dt.date,
                        right_on=df_time["full_date"], how="left") \
                 .drop(columns=["event_timestamp","full_date_y"]).rename(columns={"full_date_x":"event_date"})

df_fact.to_csv(dst / "fact_game_events_xf.csv", index=False)
print("Transform terminado ✔")
