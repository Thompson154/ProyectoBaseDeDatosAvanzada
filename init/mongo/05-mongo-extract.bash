# Exportar inventarios completos por si necesitas enriquecer dim_item
mongoexport --db=deadisland --collection=items \
  --type=csv --fields=_id,name,rarity.rarity_name,base_damage \
  --out=/tmp/items_mongo.csv                      # :contentReference[oaicite:2]{index=2}

# Exportar snapshots de partidas (opcional para métricas de longitud de sesión)
mongoexport --db=deadisland --collection=map_sessions \
  --type=json --out=/tmp/map_sessions.json
