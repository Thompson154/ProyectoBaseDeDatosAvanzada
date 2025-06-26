db = db.getSiblingDB('videojuego');

// 1. Insertar users
db.users.insertMany([
    {
        email: "user01@example.com",
        username: "Slayer01",
        password: "Pass01!",
        created_at: new Date("2025-06-17T10:00:00-04:00")
    },
    {
        email: "user02@example.com",
        username: "Slayer02",
        password: "Pass02!",
        created_at: new Date("2025-06-16T15:30:00-04:00")
    },
    {
        email: "user03@example.com",
        username: "Slayer03",
        password: "Pass03!",
        created_at: new Date("2025-06-15T08:45:00-04:00")
    },
    {
        email: "user04@example.com",
        username: "Slayer04",
        password: "Pass04!",
        created_at: new Date("2025-06-14T12:20:00-04:00")
    },
    {
        email: "user05@example.com",
        username: "Slayer05",
        password: "Pass05!",
        created_at: new Date("2025-06-13T18:10:00-04:00")
    }
]);

// 2. Insertar players
db.players.insertMany([
    {
        user_id: ObjectId("507f1f77bcf86cd799439011"),
        created_at: new Date("2025-06-17T12:00:00-04:00"),
        player_stats: {
            hp: 100,
            stamina: 80,
            level: 1,
            xp: NumberLong(0)
        },
        inventory: {
            capacity: 30,
            items: [
                {
                    item_id: ObjectId("507f191e810c19729de860ea"),
                    quantity: 2,
                    estado: "new"
                }
            ]
        },
        skills_unlocked: [
            {
                skill_id: ObjectId("507f3b4c9f7e8d5f8b234567"),
                unlocked_at: new Date("2025-06-17T11:00:00-04:00")
            }
        ],
        missions: [
            {
                mission_id: ObjectId("507f2a3b8f6d9c4e7a123456"),
                state: "active",
                started_at: new Date("2025-06-17T11:00:00-04:00"),
                finished_at: null
            }
        ]
    },
    {
        user_id: ObjectId("507f1f77bcf86cd799439012"),
        created_at: new Date("2025-06-16T16:00:00-04:00"),
        player_stats: {
            hp: 90,
            stamina: 85,
            level: 2,
            xp: NumberLong(150)
        },
        inventory: {
            capacity: 30,
            items: [
                {
                    item_id: ObjectId("507f191e810c19729de860eb"),
                    quantity: 1,
                    estado: "used"
                },
                {
                    item_id: ObjectId("507f191e810c19729de860ee"),
                    quantity: 1,
                    estado: "new"
                }
            ]
        },
        skills_unlocked: [
            {
                skill_id: ObjectId("507f3b4c9f7e8d5f8b234567"),
                unlocked_at: new Date("2025-06-16T15:00:00-04:00")
            },
            {
                skill_id: ObjectId("507f3b4c9f7e8d5f8b234568"),
                unlocked_at: new Date("2025-06-16T15:00:00-04:00")
            }
        ],
        missions: [
            {
                mission_id: ObjectId("507f2a3b8f6d9c4e7a123457"),
                state: "completed",
                started_at: new Date("2025-06-16T14:00:00-04:00"),
                finished_at: new Date("2025-06-16T14:30:00-04:00")
            }
        ]
    },
    {
        user_id: ObjectId("507f1f77bcf86cd799439013"),
        created_at: new Date("2025-06-15T09:00:00-04:00"),
        player_stats: {
            hp: 95,
            stamina: 75,
            level: 1,
            xp: NumberLong(50)
        },
        inventory: {
            capacity: 30,
            items: []
        },
        skills_unlocked: [],
        missions: []
    },
    {
        user_id: ObjectId("507f1f77bcf86cd799439014"),
        created_at: new Date("2025-06-14T13:00:00-04:00"),
        player_stats: {
            hp: 85,
            stamina: 90,
            level: 3,
            xp: NumberLong(300)
        },
        inventory: {
            capacity: 30,
            items: [
                {
                    item_id: ObjectId("507f191e810c19729de860ec"),
                    quantity: 3,
                    estado: "new"
                }
            ]
        },
        skills_unlocked: [
            {
                skill_id: ObjectId("507f3b4c9f7e8d5f8b234568"),
                unlocked_at: new Date("2025-06-14T12:00:00-04:00")
            }
        ],
        missions: [
            {
                mission_id: ObjectId("507f2a3b8f6d9c4e7a123458"),
                state: "active",
                started_at: new Date("2025-06-14T12:00:00-04:00"),
                finished_at: null
            }
        ]
    },
    {
        user_id: ObjectId("507f1f77bcf86cd799439015"),
        created_at: new Date("2025-06-13T19:00:00-04:00"),
        player_stats: {
            hp: 100,
            stamina: 70,
            level: 1,
            xp: NumberLong(20)
        },
        inventory: {
            capacity: 30,
            items: [
                {
                    item_id: ObjectId("507f191e810c19729de860ee"),
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
                started_at: new Date("2025-06-13T18:00:00-04:00"),
                finished_at: null
            }
        ]
    }
]);

// 3. Insertar skills
db.skills.insertMany([
    {
        skill_name: "Block",
        description: "Timed defense"
    },
    {
        skill_name: "Dodge",
        description: "Sidestep"
    },
    {
        skill_name: "Drop Kick",
        description: "Aerial kick"
    },
    {
        skill_name: "Ground Slam",
        description: "Jump smash"
    },
    {
        skill_name: "Dash Strike",
        description: "Forward lunge"
    }
]);

// 4. Insertar items
db.items.insertMany([
    {
        name: "Baseball Bat",
        base_damage: 40,
        max_durability: 150,
        rarity: { rarity_name: "Common", color_hex: "#BFBFBF" }
    },
    {
        name: "Machete",
        base_damage: 45,
        max_durability: 120,
        rarity: { rarity_name: "Uncommon", color_hex: "#1EFF00" }
    },
    {
        name: "Katana",
        base_damage: 55,
        max_durability: 110,
        rarity: { rarity_name: "Rare", color_hex: "#0070DD" }
    },
    {
        name: "Shotgun",
        base_damage: 90,
        max_durability: 99999,
        rarity: { rarity_name: "Superior", color_hex: "#A335EE" }
    },
    {
        name: "Assault Rifle",
        base_damage: 70,
        max_durability: 99999,
        rarity: { rarity_name: "Legendary", color_hex: "#FF8000" }
    }
]);

// 5. Insertar maps
db.maps.insertMany([
    {
        map_name: "Bel-Air",
        max_players: 3,
        has_night_cycle: true
    },
    {
        map_name: "Halperin Hotel",
        max_players: 3,
        has_night_cycle: true
    },
    {
        map_name: "Beverly Hills",
        max_players: 3,
        has_night_cycle: true
    },
    {
        map_name: "Brentwood Sewers",
        max_players: 3,
        has_night_cycle: false
    },
    {
        map_name: "Venice Beach",
        max_players: 3,
        has_night_cycle: true
    }
]);

// 6. Insertar missions
db.missions.insertMany([
    {
        mission_name: "Flight of the Damned",
        map: { map_id: ObjectId("607f1f77bcf86cd799439011"), map_name: "Bel-Air" },
        types: [
            { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Story" }
        ],
        target_json: { kills: 20, reward: "100 XP" }
    },
    {
        mission_name: "Desperately Seeking Emma",
        map: { map_id: ObjectId("607f1f77bcf86cd799439011"), map_name: "Bel-Air" },
        types: [
            { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Story" }
        ],
        target_json: { escort: 1, reward: "150 XP" }
    },
    {
        mission_name: "Call the Cavalry",
        map: { map_id: ObjectId("607f1f77bcf86cd799439012"), map_name: "Halperin Hotel" },
        types: [
            { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Story" }
        ],
        target_json: { signal: 1, reward: "120 XP" }
    },
    {
        mission_name: "The Chaperone",
        map: { map_id: ObjectId("607f1f77bcf86cd799439013"), map_name: "Beverly Hills" },
        types: [
            { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Story" }
        ],
        target_json: { find_survivor: 1, reward: "170 XP" }
    },
    {
        mission_name: "Justifiable Zombicide",
        map: { map_id: ObjectId("607f1f77bcf86cd799439014"), map_name: "Brentwood Sewers" },
        types: [
            { type_id: ObjectId("607f2a3b8f6d9c4e7a123401"), type_name: "Story" }
        ],
        target_json: { slobbers: 2, reward: "210 XP" }
    }
]);

// 7. Insertar mission_types
db.mission_types.insertMany([
    {
        type_name: "Story"
    },
    {
        type_name: "Side Quest"
    },
    {
        type_name: "Lost & Found"
    },
    {
        type_name: "Challenge"
    }
]);

// 8. Insertar zombie_types
db.zombie_types.insertMany([
    {
        type_name: "Walker",
        base_hp: 100,
        base_damage: 10,
        lore_text: "Shambling",
        abilities: []
    },
    {
        type_name: "Runner",
        base_hp: 80,
        base_damage: 8,
        lore_text: "Sprinter",
        abilities: [
            { ability_name: "Fast Runner", effect_desc: "Moves quickly" }
        ]
    },
    {
        type_name: "Crusher",
        base_hp: 300,
        base_damage: 25,
        lore_text: "Tank",
        abilities: [
            { ability_name: "Heavy Smash", effect_desc: "Ground pound" }
        ]
    },
    {
        type_name: "Slobber",
        base_hp: 220,
        base_damage: 20,
        lore_text: "Bile spitter",
        abilities: [
            { ability_name: "Acid Spit", effect_desc: "Corrosive bile" }
        ]
    },
    {
        type_name: "Screamer",
        base_hp: 180,
        base_damage: 0,
        lore_text: "Piercing scream",
        abilities: [
            { ability_name: "Scream Stun", effect_desc: "Area stun" }
        ]
    }
]);

// 9. Insertar abilities
db.abilities.insertMany([
    {
        ability_name: "Fast Runner",
        effect_desc: "Moves quickly"
    },
    {
        ability_name: "Acid Spit",
        effect_desc: "Corrosive bile"
    },
    {
        ability_name: "Scream Stun",
        effect_desc: "Area stun"
    },
    {
        ability_name: "Heavy Smash",
        effect_desc: "Ground pound"
    },
    {
        ability_name: "Regeneration",
        effect_desc: "Heals limbs"
    }
]);

// 10. Insertar map_sessions
db.map_sessions.insertMany([
    {
        map: { map_id: ObjectId("607f1f77bcf86cd799439011"), map_name: "Bel-Air" },
        started_at: new Date("2025-06-17T14:00:00-04:00"),
        is_night: true,
        players: [
            {
                player_id: ObjectId("507f1f77bcf86cd799439011"),
                username: "Slayer01",
                joined_at: new Date("2025-06-17T14:00:00-04:00"),
                left_at: null,
                stats: { hp: 90, stamina: 80, level: 1 }
            },
            {
                player_id: ObjectId("507f1f77bcf86cd799439012"),
                username: "Slayer02",
                joined_at: new Date("2025-06-17T14:02:00-04:00"),
                left_at: null,
                stats: { hp: 85, stamina: 75, level: 2 }
            }
        ],
        zombies_active: [
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439001"),
                type: { type_name: "Walker", base_hp: 100, base_damage: 10, abilities: [] },
                current_hp: 100,
                spawned_at: new Date("2025-06-17T14:01:00-04:00"),
                is_enraged: false
            },
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439002"),
                type: { type_name: "Runner", base_hp: 80, base_damage: 8, abilities: [{ ability_name: "Fast Runner", effect_desc: "Moves quickly" }] },
                current_hp: 80,
                spawned_at: new Date("2025-06-17T14:03:00-04:00"),
                is_enraged: false
            }
        ]
    },
    {
        map: { map_id: ObjectId("607f1f77bcf86cd799439012"), map_name: "Halperin Hotel" },
        started_at: new Date("2025-06-17T14:05:00-04:00"),
        is_night: true,
        players: [
            {
                player_id: ObjectId("507f1f77bcf86cd799439013"),
                username: "Slayer03",
                joined_at: new Date("2025-06-17T14:05:00-04:00"),
                left_at: null,
                stats: { hp: 95, stamina: 70, level: 1 }
            }
        ],
        zombies_active: [
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439003"),
                type: { type_name: "Crusher", base_hp: 300, base_damage: 25, abilities: [{ ability_name: "Heavy Smash", effect_desc: "Ground pound" }] },
                current_hp: 250,
                spawned_at: new Date("2025-06-17T14:06:00-04:00"),
                is_enraged: true
            }
        ]
    },
    {
        map: { map_id: ObjectId("607f1f77bcf86cd799439013"), map_name: "Beverly Hills" },
        started_at: new Date("2025-06-17T14:10:00-04:00"),
        is_night: true,
        players: [
            {
                player_id: ObjectId("507f1f77bcf86cd799439014"),
                username: "Slayer04",
                joined_at: new Date("2025-06-17T14:10:00-04:00"),
                left_at: null,
                stats: { hp: 80, stamina: 85, level: 3 }
            },
            {
                player_id: ObjectId("507f1f77bcf86cd799439015"),
                username: "Slayer05",
                joined_at: new Date("2025-06-17T14:12:00-04:00"),
                left_at: null,
                stats: { hp: 100, stamina: 65, level: 1 }
            }
        ],
        zombies_active: [
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439004"),
                type: { type_name: "Slobber", base_hp: 220, base_damage: 20, abilities: [{ ability_name: "Acid Spit", effect_desc: "Corrosive bile" }] },
                current_hp: 200,
                spawned_at: new Date("2025-06-17T14:11:00-04:00"),
                is_enraged: false
            }
        ]
    },
    {
        map: { map_id: ObjectId("607f1f77bcf86cd799439014"), map_name: "Brentwood Sewers" },
        started_at: new Date("2025-06-17T14:15:00-04:00"),
        is_night: false,
        players: [
            {
                player_id: ObjectId("507f1f77bcf86cd799439011"),
                username: "Slayer01",
                joined_at: new Date("2025-06-17T14:15:00-04:00"),
                left_at: null,
                stats: { hp: 95, stamina: 78, level: 1 }
            }
        ],
        zombies_active: [
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439005"),
                type: { type_name: "Screamer", base_hp: 180, base_damage: 0, abilities: [{ ability_name: "Scream Stun", effect_desc: "Area stun" }] },
                current_hp: 180,
                spawned_at: new Date("2025-06-17T14:16:00-04:00"),
                is_enraged: false
            }
        ]
    },
    {
        map: { map_id: ObjectId("607f1f77bcf86cd799439015"), map_name: "Venice Beach" },
        started_at: new Date("2025-06-17T14:20:00-04:00"),
        is_night: true,
        players: [
            {
                player_id: ObjectId("507f1f77bcf86cd799439012"),
                username: "Slayer02",
                joined_at: new Date("2025-06-17T14:20:00-04:00"),
                left_at: null,
                stats: { hp: 88, stamina: 80, level: 2 }
            },
            {
                player_id: ObjectId("507f1f77bcf86cd799439013"),
                username: "Slayer03",
                joined_at: new Date("2025-06-17T14:22:00-04:00"),
                left_at: new Date("2025-06-17T14:25:00-04:00"),
                stats: { hp: 90, stamina: 72, level: 1 }
            }
        ],
        zombies_active: [
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439006"),
                type: { type_name: "Runner", base_hp: 80, base_damage: 8, abilities: [{ ability_name: "Fast Runner", effect_desc: "Moves quickly" }] },
                current_hp: 80,
                spawned_at: new Date("2025-06-17T14:21:00-04:00"),
                is_enraged: true
            },
            {
                zombie_id: ObjectId("707f1f77bcf86cd799439007"),
                type: { type_name: "Walker", base_hp: 100, base_damage: 10, abilities: [] },
                current_hp: 100,
                spawned_at: new Date("2025-06-17T14:23:00-04:00"),
                is_enraged: false
            }
        ]
    }
]);