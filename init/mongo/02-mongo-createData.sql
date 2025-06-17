-- Perfil Completo del Jugador

{
  "_id": "1",    -- player_id
  "user": {
    "user_id": 123,
    "email": "player123@example.com",
    "username": "ZombieHunter99",
    "created_at": "2025-01-10T10:00:00Z"
  },
  "stats": {
    "hp": 85,
    "stamina": 70,
    "level": 28,
    "xp": 95000
  },
  "inventory": {
    "capacity": 30,
    "items": [
      {
        "item_id": 501,
        "name": "Machete de combate",
        "rarity": {
          "rarity_id": 3,
          "rarity_name": "Legendario",
          "color_hex": "#FFD700"
        },
        "base_damage": 42,
        "max_durability": 85,
        "quantity": 1,
        "mods": [
          {
            "skill_id": 10,
            "skill_name": "Afilado",
            "description": "Aumenta daño",
            "unlocked_at": "2025-03-15T12:00:00Z"
          }
        ],
        "estado": "equipado"
      },
      {
        "item_id": 502,
        "name": "Granada de fragmentación",
        "rarity": {
          "rarity_id": 2,
          "rarity_name": "Raro",
          "color_hex": "#1E90FF"
        },
        "base_damage": 60,
        "max_durability": 1,
        "quantity": 4,
        "mods": [],
        "estado": "en mochila"
      }
    ]
  },
  "skills_unlocked": [
    {
      "skill_id": 10,
      "skill_name": "Afilado",
      "description": "Aumenta daño",
      "unlocked_at": "2025-03-15T12:00:00Z"
    },
    {
      "skill_id": 11,
      "skill_name": "Camuflaje",
      "description": "Reduce detección por enemigos",
      "unlocked_at": "2025-04-10T16:00:00Z"
    }
  ],
  "missions": [
    {
      "mission_id": 1001,
      "mission_name": "Erradicar la infección",
      "map": {
        "map_id": 5,
        "map_name": "Distrito Oeste",
        "max_players": 4,
        "has_night_cycle": true
      },
      "types": [
        { "type_id": 1, "type_name": "Eliminación" },
        { "type_id": 3, "type_name": "Exploración" }
      ],
      "state": "active",
      "started_at": "2025-05-01T10:00:00Z",
      "finished_at": null,
      "target_json": {
        "objectives": [
          "Encontrar foco infeccioso",
          "Eliminar infectados",
          "Reportar base"
        ],
        "rewards": {
          "xp": 1800,
          "items": [501, 503]
        }
      }
    }
  ],
  "last_login": "2025-06-12T22:45:00Z"
}



-- Documento Sesión de Mapa con Jugadores y Zombis Activos
{
  "_id": "1",  -- session_id
  "map": {
    "map_id": 5,
    "map_name": "Distrito Oeste",
    "max_players": 4,
    "has_night_cycle": true
  },
  "started_at": "2025-06-12T20:00:00Z",
  "is_night": false,
  "players": [
    {
      "player_id": 123,
      "username": "ZombieHunter99",
      "joined_at": "2025-06-12T20:05:00Z",
      "left_at": null,
      "stats": { "hp": 80, "stamina": 60, "level": 28 }
    },
    {
      "player_id": 124,
      "username": "SurvivorX",
      "joined_at": "2025-06-12T20:10:00Z",
      "left_at": null,
      "stats": { "hp": 75, "stamina": 50, "level": 26 }
    }
  ],
  "zombies_active": [
    {
      "zombie_id": 555,
      "type": {
        "type_id": 2,
        "type_name": "Mutante",
        "base_hp": 300,
        "base_damage": 40,
        "abilities": [
          {
            "ability_id": 10,
            "ability_name": "Carga furiosa",
            "effect_desc": "Golpea con fuerza aumentando daño"
          }
        ]
      },
      "current_hp": 250,
      "spawned_at": "2025-06-12T20:10:00Z",
      "is_enraged": true
    }
  ]
}


-- Documento Item Completo con Rareza y Mods
{
  "_id": "1",  -- item_id
  "name": "Machete de combate",
  "rarity": {
    "rarity_id": 3,
    "rarity_name": "Legendario",
    "color_hex": "#FFD700"
  },
  "base_damage": 42,
  "max_durability": 85,
  "mods": [
    {
      "skill_id": 10,
      "skill_name": "Afilado",
      "description": "Aumenta daño",
      "unlocked_at": "2025-03-15T12:00:00Z"
    }
  ]
}



-- Documento Misión con Tipos y Objetivos 
{
  "_id": "1",  -- mission_id
  "mission_name": "Erradicar la infección",
  "map": {
    "map_id": 5,
    "map_name": "Distrito Oeste"
  },
  "types": [
    { "type_id": 1, "type_name": "Eliminación" },
    { "type_id": 3, "type_name": "Exploración" }
  ],
  "target_json": {
    "objectives": [
      "Encontrar foco infeccioso",
      "Eliminar infectados",
      "Reportar base"
    ]
  }
}


-- Documento Zombie Tipo con Habilidades
{
  "_id": "1",  -- type_id
  "type_name": "Mutante",
  "base_hp": 300,
  "base_damage": 40,
  "lore_text": "Un zombie poderoso con ataques feroces.",
  "abilities": [
    {
      "ability_id": 10,
      "ability_name": "Carga furiosa",
      "effect_desc": "Golpea con fuerza aumentando daño"
    }
  ]
}

