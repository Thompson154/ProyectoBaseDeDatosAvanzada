db = db.getSiblingDB('videojuego');
/* 1. users */
db.createCollection("users", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["email", "username", "password", "created_at"],
      properties: {
        email: { bsonType: "string" },
        username: { bsonType: "string" },
        password: { bsonType: "string" },
        created_at: { bsonType: "date" }
      }
    }
  }
});

/* 2. players (refiere a users) */
db.createCollection("players", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["user_id", "created_at"],
      properties: {
        user_id: { bsonType: "objectId" }, /* referencia a users._id */
        created_at: { bsonType: "date" },
        player_stats: {
          bsonType: "object",
          required: ["hp", "stamina", "level", "xp"],
          properties: {
            hp: { bsonType: "int" },
            stamina: { bsonType: "int" },
            level: { bsonType: "int" },
            xp: { bsonType: "long" }
          }
        },
        inventory: {
          bsonType: "object",
          required: ["capacity", "items"],
          properties: {
            capacity: { bsonType: "int" },
            items: {
              bsonType: "array",
              items: {
                bsonType: "object",
                required: ["item_id", "quantity"],
                properties: {
                  item_id: { bsonType: "objectId" }, /* referencia a items._id */
                  quantity: { bsonType: "int" },
                  estado: { bsonType: "string" }
                }
              }
            }
          }
        },
        skills_unlocked: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["skill_id", "unlocked_at"],
            properties: {
              skill_id: { bsonType: "objectId" }, /* referencia a skills._id */
              unlocked_at: { bsonType: "date" }
            }
          }
        },
        missions: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["mission_id", "state", "started_at"],
            properties: {
              mission_id: { bsonType: "objectId" }, /* referencia a missions._id */
              state: { bsonType: "string" },
              started_at: { bsonType: "date" },
              finished_at: { bsonType: ["date", "null"] }
            }
          }
        }
      }
    }
  }
});

/* 3. skills (catálogo) */
db.createCollection("skills", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["skill_name", "description"],
      properties: {
        skill_name: { bsonType: "string" },
        description: { bsonType: "string" }
      }
    }
  }
});

/* 4. items (embed rarity info) */
db.createCollection("items", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "base_damage", "max_durability", "rarity"],
      properties: {
        name: { bsonType: "string" },
        base_damage: { bsonType: "int" },
        max_durability: { bsonType: "int" },
        rarity: {
          bsonType: "object",
          required: ["rarity_name", "color_hex"],
          properties: {
            rarity_name: { bsonType: "string" },
            color_hex: { bsonType: "string" }
          }
        }
      }
    }
  }
});

/* 5. maps (catálogo) */
db.createCollection("maps", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["map_name", "max_players", "has_night_cycle"],
      properties: {
        map_name: { bsonType: "string" },
        max_players: { bsonType: "int" },
        has_night_cycle: { bsonType: "bool" }
      }
    }
  }
});

/* 6. missions (embed map info and mission types) */
db.createCollection("missions", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["mission_name", "map", "types", "target_json"],
      properties: {
        mission_name: { bsonType: "string" },
        map: {
          bsonType: "object",
          required: ["map_id", "map_name"],
          properties: {
            map_id: { bsonType: "objectId" }, /* referencia a maps._id */
            map_name: { bsonType: "string" }
          }
        },
        types: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["type_id", "type_name"],
            properties: {
              type_id: { bsonType: "objectId" }, /* referencia a mission_types._id */
              type_name: { bsonType: "string" }
            }
          }
        },
        target_json: { bsonType: "object" }
      }
    }
  }
});

/* 7. mission_types (catálogo) */
db.createCollection("mission_types", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["type_name"],
      properties: {
        type_name: { bsonType: "string" }
      }
    }
  }
});

/* 8. zombie_types (embed abilities) */
db.createCollection("zombie_types", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["type_name", "base_hp", "base_damage", "abilities"],
      properties: {
        type_name: { bsonType: "string" },
        base_hp: { bsonType: "int" },
        base_damage: { bsonType: "int" },
        lore_text: { bsonType: "string" },
        abilities: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["ability_name", "effect_desc"],
            properties: {
              ability_name: { bsonType: "string" },
              effect_desc: { bsonType: "string" }
            }
          }
        }
      }
    }
  }
});

/* 9. abilities (catálogo) */
db.createCollection("abilities", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["ability_name", "effect_desc"],
      properties: {
        ability_name: { bsonType: "string" },
        effect_desc: { bsonType: "string" }
      }
    }
  }
});

/* 10. map_sessions (embebido jugadores y zombis activos) */
db.createCollection("map_sessions", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["map", "started_at", "is_night", "players", "zombies_active"],
      properties: {
        map: {
          bsonType: "object",
          required: ["map_id", "map_name"],
          properties: {
            map_id: { bsonType: "objectId" },
            map_name: { bsonType: "string" }
          }
        },
        started_at: { bsonType: "date" },
        is_night: { bsonType: "bool" },
        players: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["player_id", "username", "joined_at", "left_at", "stats"],
            properties: {
              player_id: { bsonType: "objectId" },
              username: { bsonType: "string" },
              joined_at: { bsonType: "date" },
              left_at: { bsonType: ["date", "null"] },
              stats: {
                bsonType: "object",
                required: ["hp", "stamina", "level"],
                properties: {
                  hp: { bsonType: "int" },
                  stamina: { bsonType: "int" },
                  level: { bsonType: "int" }
                }
              }
            }
          }
        },
        zombies_active: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["zombie_id", "type", "current_hp", "spawned_at", "is_enraged"],
            properties: {
              zombie_id: { bsonType: "objectId" },
              type: {
                bsonType: "object",
                required: ["type_name", "base_hp", "base_damage", "abilities"],
                properties: {
                  type_name: { bsonType: "string" },
                  base_hp: { bsonType: "int" },
                  base_damage: { bsonType: "int" },
                  abilities: {
                    bsonType: "array",
                    items: {
                      bsonType: "object",
                      required: ["ability_name", "effect_desc"],
                      properties: {
                        ability_name: { bsonType: "string" },
                        effect_desc: { bsonType: "string" }
                      }
                    }
                  }
                }
              },
              current_hp: { bsonType: "int" },
              spawned_at: { bsonType: "date" },
              is_enraged: { bsonType: "bool" }
            }
          }
        }
      }
    }
  }
});


-- Colecciones Embebidas
-- player_stats dentro de players:
-- Las estadísticas (hp, stamina, level, xp) son datos íntimamente ligados a cada jugador y que se consultan y actualizan frecuentemente junto con el documento del jugador. Embebirlas dentro de players reduce la necesidad de hacer joins o múltiples consultas, mejorando la eficiencia y simplicidad en el acceso y modificación.

-- inventory e inventory_items dentro de players:
-- El inventario es propiedad directa y exclusiva del jugador. Embebir los items dentro del inventario que a su vez está embebido en players facilita obtener el inventario completo con una sola consulta y permite operaciones atómicas, mejorando rendimiento y consistencia.

-- skills_unlocked y missions dentro de players:
-- Las habilidades desbloqueadas y el progreso en misiones son atributos dinámicos y dependientes del jugador. Embebir esta información en players agiliza las consultas típicas de perfil y estado sin joins.

-- map_players y session_zombies embebidos en map_sessions:
-- Los jugadores y zombis activos en una sesión están muy ligados al contexto de la sesión. Embebidos evitan tener que consultar múltiples colecciones para ver el estado completo de una sesión.

-- abilities embebidas en zombie_types:
-- Las habilidades asociadas a un tipo de zombi se usan frecuentemente junto con los datos del tipo, por lo que embebidas facilitan lecturas rápidas sin hacer joins.

-- Colecciones Referenciales
-- users y players (referencia user_id):
-- La información de usuario es una entidad independiente que puede usarse en múltiples contextos, por eso se mantiene separada. Además, contiene datos sensibles que conviene centralizar y manejar con políticas específicas.

-- Catálogos globales como skills, items, rarities, maps, mission_types, abilities:
-- Estos datos son compartidos, relativamente estáticos y usados por muchas entidades, por lo que se mantienen en colecciones referenciales para evitar redundancia, facilitar actualizaciones globales y mejorar mantenimiento.

-- missions con referencias a maps y mission_types:
-- Aunque algunos datos se embeben para facilitar lectura, los catálogos base permanecen referenciales para evitar inconsistencias y duplicación innecesaria.

-- players referencian colecciones catálogo para skills y items:
-- Para mantener integridad y facilitar actualizaciones globales de atributos o descripciones.

-- Resumen
-- Tipo	Ejemplos clave	Justificación principal
-- Embebido	player_stats en players	Datos estrechamente ligados, accesos conjuntos frecuentes
-- inventory e items en players	Propiedad exclusiva, consultas eficientes
-- skills_unlocked, missions en players	Datos dinámicos dependientes del jugador
-- map_players, session_zombies en sesiones	Contexto local y acceso rápido
-- abilities en zombie_types	Lecturas frecuentes sin joins
-- Referencial	users, skills, items, maps, rarities	Catálogos compartidos, mantenimiento centralizado
-- players referencian users y catálogos	Evitar duplicación y manejar seguridad
-- missions referencian maps, mission_types	Evitar inconsistencias y facilitar actualización global

-- Esta combinación aprovecha lo mejor de MongoDB:

-- Embebidos para rendimiento y consistencia en datos que se consultan juntos.

-- Referenciales para datos compartidos y estáticos, facilitando mantenimiento y actualización.
