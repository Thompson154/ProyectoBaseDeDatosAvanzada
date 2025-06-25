use deadisland;

    db.users.insertMany([
        {
            email: "juan.perez@example.com",
            username: "JuanP",
            password: "pass1234",
            created_at: new Date("2025-06-17T10:00:00Z")
            },
        {
            email: "maria.gomez@example.com",
            username: "MaraG",
            password: "secure5678",
            created_at: new Date("2025-06-16T15:30:00Z")
            },
        {
            email: "carlos.lopez@example.com",
            username: "Carlitos",
            password: "myPass90",
            created_at: new Date("2025-06-15T08:45:00Z")
            },
        {
            email: "ana.martinez@example.com",
            username: "AnaM",
            password: "ana2025",
            created_at: new Date("2025-06-14T12:20:00Z")
            },
        {
            email: "luis.rodriguez@example.com",
            username: "LuisR",
            password: "lrod789",
            created_at: new Date("2025-06-13T18:10:00Z")
            },
        {
            email: "sofia.hernandez@example.com",
            username: "SofiH",
            password: "sofiaPass",
            created_at: new Date("2025-06-12T09:00:00Z")
            },
        {
            email: "diego.sanchez@example.com",
            username: "DiegoS",
            password: "diego123",
            created_at: new Date("2025-06-11T14:50:00Z")
            }
        ]);

    ////////////

    db.players.insertMany([
        {
            user_id: ObjectId("507f1f77bcf86cd799439011"),
            created_at: new Date("2025-06-17T12:00:00Z"),
            player_stats: {
                hp: 100,
                stamina: 80,
                level: 1,
                xp: NumberLong(0)
                },
            inventory: {
                capacity: 10,
                items: [
                    {
                        item_id: ObjectId("507f191e810c19729de860ea"),
                        quantity: 2,
                        estado: "new"
                        }
                    ]
                },
            skills_unlocked: [],
            missions: [
                {
                    mission_id: ObjectId("507f2a3b8f6d9c4e7a123456"),
                    state: "active",
                    started_at: new Date("2025-06-17T11:00:00Z"),
                    finished_at: null
                    }
                ]
            },
        {
            user_id: ObjectId("507f1f77bcf86cd799439012"),
            created_at: new Date("2025-06-16T16:00:00Z"),
            player_stats: {
                hp: 90,
                stamina: 85,
                level: 2,
                xp: NumberLong(150)
                },
            inventory: {
                capacity: 12,
                items: []
                },
            skills_unlocked: [
                {
                    skill_id: ObjectId("507f3b4c9f7e8d5f8b234567"),
                    unlocked_at: new Date("2025-06-16T15:00:00Z")
                    }
                ],
            missions: []
            },
        {
            user_id: ObjectId("507f1f77bcf86cd799439013"),
            created_at: new Date("2025-06-15T09:00:00Z"),
            player_stats: {
                hp: 95,
                stamina: 75,
                level: 1,
                xp: NumberLong(50)
                },
            inventory: {
                capacity: 10,
                items: [
                    {
                        item_id: ObjectId("507f191e810c19729de860eb"),
                        quantity: 1,
                        estado: "used"
                        },
                    {
                        item_id: ObjectId("507f191e810c19729de860ec"),
                        quantity: 3,
                        estado: "new"
                        }
                    ]
                },
            skills_unlocked: [],
            missions: [
                {
                    mission_id: ObjectId("507f2a3b8f6d9c4e7a123457"),
                    state: "completed",
                    started_at: new Date("2025-06-15T08:00:00Z"),
                    finished_at: new Date("2025-06-15T08:30:00Z")
                    }
                ]
            },
        {
            user_id: ObjectId("507f1f77bcf86cd799439014"),
            created_at: new Date("2025-06-14T13:00:00Z"),
            player_stats: {
                hp: 85,
                stamina: 90,
                level: 3,
                xp: NumberLong(300)
                },
            inventory: {
                capacity: 15,
                items: []
                },
            skills_unlocked: [
                {
                    skill_id: ObjectId("507f3b4c9f7e8d5f8b234568"),
                    unlocked_at: new Date("2025-06-14T12:00:00Z")
                    }
                ],
            missions: []
            },
        {
            user_id: ObjectId("507f1f77bcf86cd799439015"),
            created_at: new Date("2025-06-13T19:00:00Z"),
            player_stats: {
                hp: 100,
                stamina: 70,
                level: 1,
                xp: NumberLong(20)
                },
            inventory: {
                capacity: 10,
                items: [
                    {
                        item_id: ObjectId("507f191e810c19729de860ea"),
                        quantity: 5,
                        estado: "new"
                        }
                    ]
                },
            skills_unlocked: [],
            missions: [
                {
                    mission_id: ObjectId("507f2a3b8f6d9c4e7a123456"),
                    state: "active",
                    started_at: new Date("2025-06-13T18:00:00Z"),
                    finished_at: null
                    }
                ]
            }
        ]);

    ////////////

    db.skills.insertMany([
        {
            skill_name: "Afilado",
            description: "Aumenta el daño de las armas blancas en un 15%."
            },
        {
            skill_name: "Sprint Resistente",
            description: "Reduce el consumo de stamina al correr en un 20%."
            },
        {
            skill_name: "Golpe Crítico",
            description: "Aumenta la probabilidad de golpe crítico en un 10%."
            },
        {
            skill_name: "Sigilo",
            description: "Reduce el ruido al moverte, dificultando la detección por zombis."
            },
        {
            skill_name: "Primeros Auxilios",
            description: "Aumenta la efectividad de los kits médicos en un 25%."
            },
        {
            skill_name: "Carga Pesada",
            description: "Aumenta la capacidad del inventario en 5 espacios."
            },
        {
            skill_name: "Tiro Preciso",
            description: "Mejora la precisión de las armas de fuego en un 15%."
            },
        {
            skill_name: "Fuerza Bruta",
            description: "Aumenta el daño de los ataques cuerpo a cuerpo en un 20%."
            },
        {
            skill_name: "Superviviente",
            description: "Reduce el daño recibido de zombis en un 10%."
            },
        {
            skill_name: "Fabricación Rápida",
            description: "Reduce el tiempo de fabricación de ítems en un 30%."
            },
        {
            skill_name: "Visión Nocturna",
            description: "Mejora la visibilidad en entornos oscuros."
            },
        {
            skill_name: "Explosivos Caseros",
            description: "Permite fabricar granadas y trampas explosivas."
            },
        {
            skill_name: "Regeneración",
            description: "Recupera 1 HP por segundo cuando la salud está por debajo del 20%."
            },
        {
            skill_name: "Ataque Rápido",
            description: "Aumenta la velocidad de ataque con armas ligeras en un 15%."
            },
        {
            skill_name: "Maestro de Armas",
            description: "Reduce el desgaste de las armas en un 25%."
            }
        ]);

    //////////

    db.items.insertMany([
        {
            name: "Machete Oxidado",
            base_damage: 20,
            max_durability: 50,
            rarity: { rarity_name: "Común", color_hex: "#FFFFFF" }
            },
        {
            name: "Pistola Casera",
            base_damage: 30,
            max_durability: 40,
            rarity: { rarity_name: "Poco Común", color_hex: "#00FF00" }
            },
        {
            name: "Bate de Béisbol",
            base_damage: 25,
            max_durability: 60,
            rarity: { rarity_name: "Común", color_hex: "#FFFFFF" }
            },
        {
            name: "Cóctel Molotov",
            base_damage: 50,
            max_durability: 1,
            rarity: { rarity_name: "Raro", color_hex: "#0000FF" }
            },
        {
            name: "Botiquín Básico",
            base_damage: 0,
            max_durability: 1,
            rarity: { rarity_name: "Común", color_hex: "#FFFFFF" }
            },
        {
            name: "Cuchillo de Combate",
            base_damage: 35,
            max_durability: 70,
            rarity: { rarity_name: "Poco Común", color_hex: "#00FF00" }
            },
        {
            name: "Escopeta Recortada",
            base_damage: 60,
            max_durability: 30,
            rarity: { rarity_name: "Raro", color_hex: "#0000FF" }
            },
        {
            name: "Llave Inglesa",
            base_damage: 15,
            max_durability: 80,
            rarity: { rarity_name: "Común", color_hex: "#FFFFFF" }
            },
        {
            name: "Granada Casera",
            base_damage: 70,
            max_durability: 1,
            rarity: { rarity_name: "Épico", color_hex: "#800080" }
            },
        {
            name: "Botas Reforzadas",
            base_damage: 10,
            max_durability: 100,
            rarity: { rarity_name: "Poco Común", color_hex: "#00FF00" }
            },
        {
            name: "Katana Afilada",
            base_damage: 50,
            max_durability: 90,
            rarity: { rarity_name: "Épico", color_hex: "#800080" }
            },
        {
            name: "Botiquín Avanzado",
            base_damage: 0,
            max_durability: 1,
            rarity: { rarity_name: "Raro", color_hex: "#0000FF" }
            },
        {
            name: "Martillo Pesado",
            base_damage: 30,
            max_durability: 65,
            rarity: { rarity_name: "Poco Común", color_hex: "#00FF00" }
            },
        {
            name: "Rifle de Asalto",
            base_damage: 45,
            max_durability: 50,
            rarity: { rarity_name: "Épico", color_hex: "#800080" }
            },
        {
            name: "Linterna Táctica",
            base_damage: 5,
            max_durability: 120,
            rarity: { rarity_name: "Común", color_hex: "#FFFFFF" }
            },
        {
            name: "Hacha de Fuego",
            base_damage: 55,
            max_durability: 80,
            rarity: { rarity_name: "Legendario", color_hex: "#FFD700" }
            },
        {
            name: "Chaleco Antibalas",
            base_damage: 0,
            max_durability: 150,
            rarity: { rarity_name: "Raro", color_hex: "#0000FF" }
            },
        {
            name: "Cuchillo Eléctrico",
            base_damage: 40,
            max_durability: 60,
            rarity: { rarity_name: "Épico", color_hex: "#800080" }
            },
        {
            name: "Trampa de Púas",
            base_damage: 25,
            max_durability: 3,
            rarity: { rarity_name: "Poco Común", color_hex: "#00FF00" }
            },
        {
            name: "Espada de Plasma",
            base_damage: 65,
            max_durability: 100,
            rarity: { rarity_name: "Legendario", color_hex: "#FFD700" }
            }
        ]);

    ////////////////


    db.maps.insertMany([
        {
            map_name: "Playa Banoi",
            max_players: 8,
            has_night_cycle: true
            },
        {
            map_name: "Jungla de Moresby",
            max_players: 6,
            has_night_cycle: true
            },
        {
            map_name: "Resort Abandonado",
            max_players: 10,
            has_night_cycle: true
            },
        {
            map_name: "Aldea de Pescadores",
            max_players: 6,
            has_night_cycle: false
            },
        {
            map_name: "Ciudad en Ruinas",
            max_players: 12,
            has_night_cycle: true
            },
        {
            map_name: "Sewers of Banoi",
            max_players: 4,
            has_night_cycle: false
            },
        {
            map_name: "Base Militar Derruida",
            max_players: 10,
            has_night_cycle: true
            },
        {
            map_name: "Cueva de la Costa",
            max_players: 4,
            has_night_cycle: false
            },
        {
            map_name: "Pueblo Fantasma",
            max_players: 8,
            has_night_cycle: true
            },
        {
            map_name: "Hotel Infestado",
            max_players: 8,
            has_night_cycle: true
            },
        {
            map_name: "Manglares Oscuros",
            max_players: 6,
            has_night_cycle: true
            },
        {
            map_name: "Laboratorio Abandonado",
            max_players: 6,
            has_night_cycle: false
            },
        {
            map_name: "Carretera Costera",
            max_players: 10,
            has_night_cycle: true
            },
        {
            map_name: "Mercado en Ruinas",
            max_players: 8,
            has_night_cycle: true
            },
        {
            map_name: "Templo Antiguo",
            max_players: 6,
            has_night_cycle: true
            },
        {
            map_name: "Puerto Devastado",
            max_players: 12,
            has_night_cycle: true
            },
        {
            map_name: "Cementerio de Banoi",
            max_players: 6,
            has_night_cycle: true
            },
        {
            map_name: "Fábrica Abandonada",
            max_players: 10,
            has_night_cycle: false
            },
        {
            map_name: "Acantilados Sangrientos",
            max_players: 8,
            has_night_cycle: true
            },
        {
            map_name: "Asentamiento Superviviente",
            max_players: 12,
            has_night_cycle: true
            }
        ]);

    /////////

    db.missions.insertMany([
        {
            mission_name: "Limpieza en la Playa",
            map: { map_id: ObjectId("607f1f77bcf86cd799439011"), map_name: "Playa Banoi" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Eliminación" }
                ],
            target_json: { zombies_to_kill: 20, reward: "100 XP" }
            },
        {
            mission_name: "Exploración de la Jungla",
            map: { map_id: ObjectId("607f1f77bcf86cd799439012"), map_name: "Jungla de Moresby" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123402"), type_name: "Exploración" }
                ],
            target_json: { locations_to_visit: 5, reward: "150 XP" }
            },
        {
            mission_name: "Rescate en el Resort",
            map: { map_id: ObjectId("607f1f77bcf86cd799439013"), map_name: "Resort Abandonado" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123403"), type_name: "Rescate" }
                ],
            target_json: { survivors_to_rescue: 3, reward: "200 XP" }
            },
        {
            mission_name: "Suministros en la Aldea",
            map: { map_id: ObjectId("607f1f77bcf86cd799439014"), map_name: "Aldea de Pescadores" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123404"), type_name: "Recolección" }
                ],
            target_json: { items_to_collect: { "Botiquín Básico": 5 }, reward: "120 XP" }
            },
        {
            mission_name: "Asalto a la Ciudad",
            map: { map_id: ObjectId("607f1f77bcf86cd799439015"), map_name: "Ciudad en Ruinas" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Eliminación" }
                ],
            target_json: { zombies_to_kill: 30, reward: "250 XP" }
            },
        {
            mission_name: "Infiltración en las Cloacas",
            map: { map_id: ObjectId("607f1f77bcf86cd799439016"), map_name: "Sewers of Banoi" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123402"), type_name: "Exploración" }
                ],
            target_json: { secrets_to_find: 2, reward: "180 XP" }
            },
        {
            mission_name: "Defensa de la Base",
            map: { map_id: ObjectId("607f1f77bcf86cd799439017"), map_name: "Base Militar Derruida" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Eliminación" },
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123403"), type_name: "Rescate" }
                ],
            target_json: { zombies_to_kill: 25, survivors_to_protect: 2, reward: "300 XP" }
            },
        {
            mission_name: "Cueva Oculta",
            map: { map_id: ObjectId("607f1f77bcf86cd799439018"), map_name: "Cueva de la Costa" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123402"), type_name: "Exploración" }
                ],
            target_json: { artifacts_to_find: 3, reward: "160 XP" }
            },
        {
            mission_name: "Pueblo en Llamas",
            map: { map_id: ObjectId("607f1f77bcf86cd799439019"), map_name: "Pueblo Fantasma" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Eliminación" }
                ],
            target_json: { zombies_to_kill: 15, reward: "140 XP" }
            },
        {
            mission_name: "Sobrevivir en el Hotel",
            map: { map_id: ObjectId("607f1f77bcf86cd79943901a"), map_name: "Hotel Infestado" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123403"), type_name: "Rescate" }
                ],
            target_json: { survivors_to_rescue: 4, reward: "220 XP" }
            },
        {
            mission_name: "Atravesar los Manglares",
            map: { map_id: ObjectId("607f1f77bcf86cd79943901b"), map_name: "Manglares Oscuros" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123402"), type_name: "Exploración" }
                ],
            target_json: { waypoints_to_reach: 4, reward: "170 XP" }
            },
        {
            mission_name: "Investigación en el Laboratorio",
            map: { map_id: ObjectId("607f1f77bcf86cd79943901c"), map_name: "Laboratorio Abandonado" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123402"), type_name: "Exploración" },
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123404"), type_name: "Recolección" }
                ],
            target_json: { documents_to_collect: 3, reward: "200 XP" }
            },
        {
            mission_name: "Carretera Peligrosa",
            map: { map_id: ObjectId("607f1f77bcf86cd79943901d"), map_name: "Carretera Costera" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Eliminación" }
                ],
            target_json: { zombies_to_kill: 20, reward: "180 XP" }
            },
        {
            mission_name: "Saqueo en el Mercado",
            map: { map_id: ObjectId("607f1f77bcf86cd79943901e"), map_name: "Mercado en Ruinas" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123404"), type_name: "Recolección" }
                ],
            target_json: { items_to_collect: { "Machete Oxidado": 3 }, reward: "150 XP" }
            },
        {
            mission_name: "Ritual en el Templo",
            map: { map_id: ObjectId("607f1f77bcf86cd79943901f"), map_name: "Templo Antiguo" },
            types: [
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123402"), type_name: "Exploración" },
                { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Eliminación" }
                ],
            target_json: { zombies_to_kill: 10, artifacts_to_find: 2, reward: "250 XP" }
            }
        ]);

    /////////


    db.mission_types.insertMany([
        {
            type_name: "Eliminación"
            },
        {
            type_name: "Exploración"
            },
        {
            type_name: "Rescate"
            },
        {
            type_name: "Recolección"
            },
        {
            type_name: "Defensa"
            },
        {
            type_name: "Sabotaje"
            },
        {
            type_name: "Escolta"
            },
        {
            type_name: "Supervivencia"
            },
        {
            type_name: "Asalto"
            },
        {
            type_name: "Investigación"
            },
        {
            type_name: "Reconocimiento"
            },
        {
            type_name: "Caza"
            },
        {
            type_name: "Construcción"
            },
        {
            type_name: "Liberación"
            },
        {
            type_name: "Infiltración"
            },
        {
            type_name: "Evacuación"
            },
        {
            type_name: "Búsqueda"
            },
        {
            type_name: "Reparación"
            },
        {
            type_name: "Exterminio"
            },
        {
            type_name: "Protección"
            }
        ]);

    ///////////

    db.zombie_types.insertMany([
        {
            type_name: "Caminante",
            base_hp: 100,
            base_damage: 10,
            lore_text: "Un zombi común, lento pero persistente, vagando sin rumbo.",
            abilities: [
                { ability_name: "Mordida Infecciosa", effect_desc: "Causa daño y ralentiza al jugador." }
                ]
            },
        {
            type_name: "Corredor Infectado",
            base_hp: 80,
            base_damage: 15,
            abilities: [
                { ability_name: "Carga Rápida", effect_desc: "Se mueve rápidamente hacia el jugador." },
                { ability_name: "Golpe Frenético", effect_desc: "Ataca con golpes rápidos." }
                ]
            },
        {
            type_name: "Bruto",
            base_hp: 300,
            base_damage: 30,
            lore_text: "Un zombi masivo con fuerza devastadora.",
            abilities: [
                { ability_name: "Golpe Aplastante", effect_desc: "Causa daño masivo en área." },
                { ability_name: "Resistencia", effect_desc: "Reduce el daño recibido en un 20%." }
                ]
            },
        {
            type_name: "Escupidor",
            base_hp: 120,
            base_damage: 20,
            abilities: [
                { ability_name: "Escupitajo Ácido", effect_desc: "Lanza ácido que daña con el tiempo." }
                ]
            },
        {
            type_name: "Gritón",
            base_hp: 90,
            base_damage: 5,
            lore_text: "Un zombi que atrae a otros con sus gritos.",
            abilities: [
                { ability_name: "Rugido Aturdidor", effect_desc: "Aturde a los jugadores cercanos." },
                { ability_name: "Llamada de Horda", effect_desc: "Atrae zombis adicionales al área." }
                ]
            },
        {
            type_name: "Acechador",
            base_hp: 110,
            base_damage: 25,
            abilities: [
                { ability_name: "Sigilo", effect_desc: "Se mueve silenciosamente para emboscar." },
                { ability_name: "Ataque Sorpresa", effect_desc: "Causa daño extra en el primer golpe." }
                ]
            },
        {
            type_name: "Mutante Explosivo",
            base_hp: 150,
            base_damage: 40,
            lore_text: "Un zombi inestable que explota al morir.",
            abilities: [
                { ability_name: "Explosión Mortal", effect_desc: "Explota al morir, dañando a todos cerca." }
                ]
            },
        {
            type_name: "Zombi Blindado",
            base_hp: 250,
            base_damage: 20,
            abilities: [
                { ability_name: "Armadura Natural", effect_desc: "Reduce el daño recibido en un 30%." },
                { ability_name: "Carga Pesada", effect_desc: "Empuja a los jugadores al impactar." }
                ]
            },
        {
            type_name: "Infestador",
            base_hp: 130,
            base_damage: 15,
            lore_text: "Propaga infecciones que debilitan a los jugadores.",
            abilities: [
                { ability_name: "Nube Tóxica", effect_desc: "Libera gas que reduce la stamina." }
                ]
            },
        {
            type_name: "Titán",
            base_hp: 500,
            base_damage: 50,
            lore_text: "Un coloso zombi, casi imparable.",
            abilities: [
                { ability_name: "Golpe Devastador", effect_desc: "Causa daño masivo y derriba al jugador." },
                { ability_name: "Regeneración Lenta", effect_desc: "Recupera 5 HP por segundo." }
                ]
            },
        {
            type_name: "Zombi Ágil",
            base_hp: 70,
            base_damage: 20,
            abilities: [
                { ability_name: "Esquiva Rápida", effect_desc: "Evade el 20% de los ataques." },
                { ability_name: "Salto Ágil", effect_desc: "Salta hacia los jugadores desde lejos." }
                ]
            },
        {
            type_name: "Necrófago",
            base_hp: 140,
            base_damage: 25,
            lore_text: "Un zombi que se alimenta de restos, ganando fuerza.",
            abilities: [
                { ability_name: "Devorar", effect_desc: "Gana HP al atacar jugadores debilitados." }
                ]
            },
        {
            type_name: "Zombi Eléctrico",
            base_hp: 160,
            base_damage: 30,
            abilities: [
                { ability_name: "Descarga Eléctrica", effect_desc: "Causa daño y aturde con electricidad." }
                ]
            },
        {
            type_name: "Merodeador",
            base_hp: 100,
            base_damage: 15,
            abilities: [
                { ability_name: "Ataque en Grupo", effect_desc: "Gana daño extra cuando ataca con otros zombis." }
                ]
            },
        {
            type_name: "Mutante Químico",
            base_hp: 180,
            base_damage: 35,
            lore_text: "Expuesto a químicos, este zombi es altamente corrosivo.",
            abilities: [
                { ability_name: "Aura Corrosiva", effect_desc: "Daña a los jugadores cercanos con el tiempo." },
                { ability_name: "Explosión Química", effect_desc: "Libera una nube tóxica al morir." }
                ]
            }
        ]);

    ///////////

    db.abilities.insertMany([
        {
            ability_name: "Mordida Infecciosa",
            effect_desc: "Causa daño y ralentiza al jugador durante 5 segundos."
            },
        {
            ability_name: "Carga Rápida",
            effect_desc: "Se mueve rápidamente hacia el jugador, aumentando la velocidad en un 50%."
            },
        {
            ability_name: "Golpe Aplastante",
            effect_desc: "Causa daño masivo en área, derribando a los jugadores cercanos."
            },
        {
            ability_name: "Escupitajo Ácido",
            effect_desc: "Lanza ácido que daña a los jugadores con el tiempo."
            },
        {
            ability_name: "Rugido Aturdidor",
            effect_desc: "Aturde a los jugadores cercanos durante 3 segundos."
            },
        {
            ability_name: "Llamada de Horda",
            effect_desc: "Atrae zombis adicionales al área."
            },
        {
            ability_name: "Sigilo",
            effect_desc: "Se mueve silenciosamente, dificultando su detección."
            },
        {
            ability_name: "Ataque Sorpresa",
            effect_desc: "Causa un 50% de daño extra en el primer golpe."
            },
        {
            ability_name: "Explosión Mortal",
            effect_desc: "Explota al morir, causando daño en un radio de 5 metros."
            },
        {
            ability_name: "Armadura Natural",
            effect_desc: "Reduce el daño recibido en un 30%."
            },
        {
            ability_name: "Nube Tóxica",
            effect_desc: "Libera gas que reduce la stamina de los jugadores cercanos."
            },
        {
            ability_name: "Regeneración Lenta",
            effect_desc: "Recupera 5 HP por segundo cuando no está bajo ataque."
            },
        {
            ability_name: "Esquiva Rápida",
            effect_desc: "Evade el 20% de los ataques recibidos."
            },
        {
            ability_name: "Devorar",
            effect_desc: "Gana 10 HP al atacar a jugadores debilitados."
            },
        {
            ability_name: "Descarga Eléctrica",
            effect_desc: "Causa daño y aturde a los jugadores con una descarga eléctrica."
            }
        ]);

    //////


    db.map_sessions.insertMany([
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439011"), map_name: "Playa Banoi" },
            started_at: new Date("2025-06-17T14:00:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439011"),
                    username: "JuanP",
                    joined_at: new Date("2025-06-17T14:00:00-04:00"),
                    left_at: null,
                    stats: { hp: 90, stamina: 80, level: 1 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439012"),
                    username: "MaraG",
                    joined_at: new Date("2025-06-17T14:02:00-04:00"),
                    left_at: null,
                    stats: { hp: 85, stamina: 75, level: 2 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439001"),
                    type: { type_name: "Caminante", base_hp: 100, base_damage: 10, abilities: [{ ability_name: "Mordida Infecciosa", effect_desc: "Causa daño y ralentiza al jugador." }] },
                    current_hp: 100,
                    spawned_at: new Date("2025-06-17T14:01:00-04:00"),
                    is_enraged: false
                    },
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439002"),
                    type: { type_name: "Corredor Infectado", base_hp: 80, base_damage: 15, abilities: [{ ability_name: "Carga Rápida", effect_desc: "Se mueve rápidamente hacia el jugador." }] },
                    current_hp: 80,
                    spawned_at: new Date("2025-06-17T14:03:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439012"), map_name: "Jungla de Moresby" },
            started_at: new Date("2025-06-17T14:05:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439013"),
                    username: "Carlitos",
                    joined_at: new Date("2025-06-17T14:05:00-04:00"),
                    left_at: null,
                    stats: { hp: 95, stamina: 70, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439003"),
                    type: { type_name: "Bruto", base_hp: 300, base_damage: 30, abilities: [{ ability_name: "Golpe Aplastante", effect_desc: "Causa daño masivo en área." }] },
                    current_hp: 250,
                    spawned_at: new Date("2025-06-17T14:06:00-04:00"),
                    is_enraged: true
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439013"), map_name: "Resort Abandonado" },
            started_at: new Date("2025-06-17T14:10:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439014"),
                    username: "AnaM",
                    joined_at: new Date("2025-06-17T14:10:00-04:00"),
                    left_at: null,
                    stats: { hp: 80, stamina: 85, level: 3 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439015"),
                    username: "LuisR",
                    joined_at: new Date("2025-06-17T14:12:00-04:00"),
                    left_at: new Date("2025-06-17T14:15:00-04:00"),
                    stats: { hp: 100, stamina: 65, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439004"),
                    type: { type_name: "Escupidor", base_hp: 120, base_damage: 20, abilities: [{ ability_name: "Escupitajo Ácido", effect_desc: "Lanza ácido que daña con el tiempo." }] },
                    current_hp: 120,
                    spawned_at: new Date("2025-06-17T14:11:00-04:00"),
                    is_enraged: false
                    },
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439005"),
                    type: { type_name: "Gritón", base_hp: 90, base_damage: 5, abilities: [{ ability_name: "Rugido Aturdidor", effect_desc: "Aturde a los jugadores cercanos." }] },
                    current_hp: 90,
                    spawned_at: new Date("2025-06-17T14:13:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439014"), map_name: "Aldea de Pescadores" },
            started_at: new Date("2025-06-17T14:15:00-04:00"),
            is_night: false,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439011"),
                    username: "JuanP",
                    joined_at: new Date("2025-06-17T14:15:00-04:00"),
                    left_at: null,
                    stats: { hp: 95, stamina: 78, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439006"),
                    type: { type_name: "Caminante", base_hp: 100, base_damage: 10, abilities: [{ ability_name: "Mordida Infecciosa", effect_desc: "Causa daño y ralentiza al jugador." }] },
                    current_hp: 100,
                    spawned_at: new Date("2025-06-17T14:16:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439015"), map_name: "Ciudad en Ruinas" },
            started_at: new Date("2025-06-17T14:20:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439012"),
                    username: "MaraG",
                    joined_at: new Date("2025-06-17T14:20:00-04:00"),
                    left_at: null,
                    stats: { hp: 88, stamina: 80, level: 2 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439013"),
                    username: "Carlitos",
                    joined_at: new Date("2025-06-17T14:22:00-04:00"),
                    left_at: null,
                    stats: { hp: 90, stamina: 72, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439007"),
                    type: { type_name: "Acechador", base_hp: 110, base_damage: 25, abilities: [{ ability_name: "Sigilo", effect_desc: "Se mueve silenciosamente para emboscar." }] },
                    current_hp: 110,
                    spawned_at: new Date("2025-06-17T14:21:00-04:00"),
                    is_enraged: false
                    },
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439008"),
                    type: { type_name: "Mutante Explosivo", base_hp: 150, base_damage: 40, abilities: [{ ability_name: "Explosión Mortal", effect_desc: "Explota al morir, dañando a todos cerca." }] },
                    current_hp: 150,
                    spawned_at: new Date("2025-06-17T14:23:00-04:00"),
                    is_enraged: true
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439016"), map_name: "Sewers of Banoi" },
            started_at: new Date("2025-06-17T14:25:00-04:00"),
            is_night: false,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439014"),
                    username: "AnaM",
                    joined_at: new Date("2025-06-17T14:25:00-04:00"),
                    left_at: null,
                    stats: { hp: 82, stamina: 88, level: 3 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439009"),
                    type: { type_name: "Infestador", base_hp: 130, base_damage: 15, abilities: [{ ability_name: "Nube Tóxica", effect_desc: "Libera gas que reduce la stamina." }] },
                    current_hp: 130,
                    spawned_at: new Date("2025-06-17T14:26:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439017"), map_name: "Base Militar Derruida" },
            started_at: new Date("2025-06-17T14:30:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439015"),
                    username: "LuisR",
                    joined_at: new Date("2025-06-17T14:30:00-04:00"),
                    left_at: null,
                    stats: { hp: 98, stamina: 70, level: 1 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439011"),
                    username: "JuanP",
                    joined_at: new Date("2025-06-17T14:32:00-04:00"),
                    left_at: null,
                    stats: { hp: 92, stamina: 82, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd79943900a"),
                    type: { type_name: "Titán", base_hp: 500, base_damage: 50, abilities: [{ ability_name: "Golpe Devastador", effect_desc: "Causa daño masivo y derriba al jugador." }] },
                    current_hp: 400,
                    spawned_at: new Date("2025-06-17T14:31:00-04:00"),
                    is_enraged: true
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439018"), map_name: "Cueva de la Costa" },
            started_at: new Date("2025-06-17T14:35:00-04:00"),
            is_night: false,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439012"),
                    username: "MaraG",
                    joined_at: new Date("2025-06-17T14:35:00-04:00"),
                    left_at: null,
                    stats: { hp: 90, stamina: 77, level: 2 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd79943900b"),
                    type: { type_name: "Zombi Ágil", base_hp: 70, base_damage: 20, abilities: [{ ability_name: "Esquiva Rápida", effect_desc: "Evade el 20% de los ataques." }] },
                    current_hp: 70,
                    spawned_at: new Date("2025-06-17T14:36:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd799439019"), map_name: "Pueblo Fantasma" },
            started_at: new Date("2025-06-17T14:40:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439013"),
                    username: "Carlitos",
                    joined_at: new Date("2025-06-17T14:40:00-04:00"),
                    left_at: null,
                    stats: { hp: 87, stamina: 75, level: 1 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439014"),
                    username: "AnaM",
                    joined_at: new Date("2025-06-17T14:42:00-04:00"),
                    left_at: new Date("2025-06-17T14:45:00-04:00"),
                    stats: { hp: 85, stamina: 90, level: 3 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd79943900c"),
                    type: { type_name: "Necrófago", base_hp: 140, base_damage: 25, abilities: [{ ability_name: "Devorar", effect_desc: "Gana HP al atacar jugadores debilitados." }] },
                    current_hp: 140,
                    spawned_at: new Date("2025-06-17T14:41:00-04:00"),
                    is_enraged: false
                    },
                {
                    zombie_id: ObjectId("707f1f77bcf86cd79943900d"),
                    type: { type_name: "Caminante", base_hp: 100, base_damage: 10, abilities: [{ ability_name: "Mordida Infecciosa", effect_desc: "Causa daño y ralentiza al jugador." }] },
                    current_hp: 100,
                    spawned_at: new Date("2025-06-17T14:43:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd79943901a"), map_name: "Hotel Infestado" },
            started_at: new Date("2025-06-17T14:45:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439015"),
                    username: "LuisR",
                    joined_at: new Date("2025-06-17T14:45:00-04:00"),
                    left_at: null,
                    stats: { hp: 95, stamina: 68, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd79943900e"),
                    type: { type_name: "Zombi Eléctrico", base_hp: 160, base_damage: 30, abilities: [{ ability_name: "Descarga Eléctrica", effect_desc: "Causa daño y aturde con electricidad." }] },
                    current_hp: 160,
                    spawned_at: new Date("2025-06-17T14:46:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd79943901b"), map_name: "Manglares Oscuros" },
            started_at: new Date("2025-06-17T14:50:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439011"),
                    username: "JuanP",
                    joined_at: new Date("2025-06-17T14:50:00-04:00"),
                    left_at: null,
                    stats: { hp: 88, stamina: 79, level: 1 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439012"),
                    username: "MaraG",
                    joined_at: new Date("2025-06-17T14:52:00-04:00"),
                    left_at: null,
                    stats: { hp: 92, stamina: 82, level: 2 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd79943900f"),
                    type: { type_name: "Merodeador", base_hp: 100, base_damage: 15, abilities: [{ ability_name: "Ataque en Grupo", effect_desc: "Gana daño extra cuando ataca con otros zombis." }] },
                    current_hp: 100,
                    spawned_at: new Date("2025-06-17T14:51:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd79943901c"), map_name: "Laboratorio Abandonado" },
            started_at: new Date("2025-06-17T14:55:00-04:00"),
            is_night: false,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439013"),
                    username: "Carlitos",
                    joined_at: new Date("2025-06-17T14:55:00-04:00"),
                    left_at: null,
                    stats: { hp: 93, stamina: 73, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439010"),
                    type: { type_name: "Mutante Químico", base_hp: 180, base_damage: 35, abilities: [{ ability_name: "Aura Corrosiva", effect_desc: "Daña a los jugadores cercanos con el tiempo." }] },
                    current_hp: 180,
                    spawned_at: new Date("2025-06-17T14:56:00-04:00"),
                    is_enraged: true
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd79943901d"), map_name: "Carretera Costera" },
            started_at: new Date("2025-06-17T15:00:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439014"),
                    username: "AnaM",
                    joined_at: new Date("2025-06-17T15:00:00-04:00"),
                    left_at: null,
                    stats: { hp: 87, stamina: 86, level: 3 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439015"),
                    username: "LuisR",
                    joined_at: new Date("2025-06-17T15:02:00-04:00"),
                    left_at: null,
                    stats: { hp: 90, stamina: 70, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439011"),
                    type: { type_name: "Caminante", base_hp: 100, base_damage: 10, abilities: [{ ability_name: "Mordida Infecciosa", effect_desc: "Causa daño y ralentiza al jugador." }] },
                    current_hp: 100,
                    spawned_at: new Date("2025-06-17T15:01:00-04:00"),
                    is_enraged: false
                    },
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439012"),
                    type: { type_name: "Corredor Infectado", base_hp: 80, base_damage: 15, abilities: [{ ability_name: "Carga Rápida", effect_desc: "Se mueve rápidamente hacia el jugador." }] },
                    current_hp: 80,
                    spawned_at: new Date("2025-06-17T15:03:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd79943901e"), map_name: "Mercado en Ruinas" },
            started_at: new Date("2025-06-17T15:05:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439011"),
                    username: "JuanP",
                    joined_at: new Date("2025-06-17T15:05:00-04:00"),
                    left_at: null,
                    stats: { hp: 94, stamina: 81, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439013"),
                    type: { type_name: "Acechador", base_hp: 110, base_damage: 25, abilities: [{ ability_name: "Sigilo", effect_desc: "Se mueve silenciosamente para emboscar." }] },
                    current_hp: 110,
                    spawned_at: new Date("2025-06-17T15:06:00-04:00"),
                    is_enraged: false
                    }
                ]
            },
        {
            map: { map_id: ObjectId("607f1f77bcf86cd79943901f"), map_name: "Templo Antiguo" },
            started_at: new Date("2025-06-17T15:10:00-04:00"),
            is_night: true,
            players: [
                {
                    player_id: ObjectId("507f1f77bcf86cd799439012"),
                    username: "MaraG",
                    joined_at: new Date("2025-06-17T15:10:00-04:00"),
                    left_at: null,
                    stats: { hp: 89, stamina: 79, level: 2 }
                    },
                {
                    player_id: ObjectId("507f1f77bcf86cd799439013"),
                    username: "Carlitos",
                    joined_at: new Date("2025-06-17T15:12:00-04:00"),
                    left_at: null,
                    stats: { hp: 91, stamina: 74, level: 1 }
                    }
                ],
            zombies_active: [
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439014"),
                    type: { type_name: "Zombi Blindado", base_hp: 250, base_damage: 20, abilities: [{ ability_name: "Armadura Natural", effect_desc: "Reduce el daño recibido en un 30%." }] },
                    current_hp: 250,
                    spawned_at: new Date("2025-06-17T15:11:00-04:00"),
                    is_enraged: false
                    },
                {
                    zombie_id: ObjectId("707f1f77bcf86cd799439015"),
                    type: { type_name: "Necrófago", base_hp: 140, base_damage: 25, abilities: [{ ability_name: "Devorar", effect_desc: "Gana HP al atacar jugadores debilitados." }] },
                    current_hp: 140,
                    spawned_at: new Date("2025-06-17T15:13:00-04:00"),
                    is_enraged: false
                    }
                ]
            }
        ]);