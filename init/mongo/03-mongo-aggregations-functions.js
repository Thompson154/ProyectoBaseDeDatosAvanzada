db = db.getSiblingDB('videojuego');

    /*1. Sesiones activas con más jugadores*/
    db.map_sessions.aggregate([
        { $match: { "players.left_at": null } },
        { $unwind: "$players" },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            activePlayers: { $sum: 1 },
            playerUsernames: { $push: "$players.username" }
        } },
        { $project: {
            mapName: "$_id.map",
            activePlayers: 1,
            playerUsernames: 1,
            _id: 0
        } },
        { $sort: { activePlayers: -1 } },
        { $limit: 5 }
    ]);

    /*2. Zombis activos por tipo en sesiones*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $group: {
            _id: { map: "$map.map_name", zombie_type: "$zombies_active.type.type_name" },
            totalZombies: { $sum: 1 },
            avgHP: { $avg: "$zombies_active.current_hp" },
            enragedCount: { $sum: { $cond: ["$zombies_active.is_enraged", 1, 0] } }
        } },
        { $project: {
            map: "$_id.map",
            zombieType: "$_id.zombie_type",
            totalZombies: 1,
            avgHP: 1,
            enragedCount: 1,
            _id: 0
        } },
        { $sort: { totalZombies: -1 } }
    ]);

    /*3. Sesiones con más jugadores que abandonaron*/
    db.map_sessions.aggregate([
        { $unwind: { path: "$players", preserveNullAndEmptyArrays: true } },
        { $match: { "players.left_at": { $ne: null } } },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            playersLeft: { $sum: 1 }
            } },
        { $project: {
            map: "$_id.map",
            playersLeft: 1,
            _id: 0
            } },
        { $sort: { playersLeft: -1 } },
        { $limit: 5 }
        ]);

    /*4. Tipos de zombis más comunes en sesiones*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $group: {
            _id: "$zombies_active.type.type_name",
            totalZombies: { $sum: 1 },
            maps: { $addToSet: "$map.map_name" }
        } },
        { $project: {
            zombieType: "$_id",
            totalZombies: 1,
            mapCount: { $size: "$maps" },
            maps: 1,
            _id: 0
        } },
        { $sort: { totalZombies: -1 } }
    ]);

    /*5. Misiones con mayor recompensa de XP*/
    db.missions.aggregate([
        { $match: { "target_json.reward": { $exists: true } } },
        { $project: {
            missionName: "$mission_name",
            map: "$map.map_name",
            rewardXP: { $toInt: { $arrayElemAt: [{ $split: ["$target_json.reward", " "] }, 0] } },
            types: "$types.type_name"
        } },
        { $sort: { rewardXP: -1 } },
        { $limit: 5 }
    ]);

    /*6. Mapas con mayor actividad nocturna*/
    db.map_sessions.aggregate([
        { $match: { is_night: true } },
        { $group: {
            _id: "$map.map_name",
            nightSessions: { $sum: 1 },
            totalPlayers: { $sum: { $size: "$players" } }
        } },
        { $project: {
            map: "$_id",
            nightSessions: 1,
            totalPlayers: 1,
            _id: 0
        } },
        { $sort: { nightSessions: -1 } }
    ]);

    /*7. Habilidades de zombis más comunes en sesiones*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $unwind: "$zombies_active.type.abilities" },
        { $group: {
            _id: "$zombies_active.type.abilities.ability_name",
            totalOccurrences: { $sum: 1 },
            maps: { $addToSet: "$map.map_name" }
        } },
        { $project: {
            abilityName: "$_id",
            totalOccurrences: 1,
            mapCount: { $size: "$maps" },
            maps: 1,
            _id: 0
        } },
        { $sort: { totalOccurrences: -1 } }
    ]);

    /*8. Sesiones con mayor daño potencial de zombis*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            totalDamage: { $sum: "$zombies_active.type.base_damage" },
            zombieCount: { $sum: 1 }
        } },
        { $project: {
            map: "$_id.map",
            totalDamage: 1,
            zombieCount: 1,
            avgDamagePerZombie: { $divide: ["$totalDamage", "$zombieCount"] },
            _id: 0
        } },
        { $sort: { totalDamage: -1 } }
    ]);

    /*9. Mapas con mayor variedad de tipos de misiones*/
    db.missions.aggregate([
        { $unwind: "$types" },
        { $group: {
            _id: "$map.map_name",
            missionTypes: { $addToSet: "$types.type_name" },
            missionCount: { $sum: 1 }
        } },
        { $project: {
            map: "$_id",
            missionTypeCount: { $size: "$missionTypes" },
            missionTypes: 1,
            missionCount: 1,
            _id: 0
        } },
        { $sort: { missionTypeCount: -1 } }
    ]);

    db = db.getSiblingDB('videojuego');
    /*10. Sesiones con mayor variedad de tipos de zombis*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            zombieTypes: { $addToSet: "$zombies_active.type.type_name" },
            totalZombies: { $sum: 1 }
            } },
        { $project: {
            map: "$_id.map",
            zombieTypeCount: { $size: "$zombieTypes" },
            totalZombies: 1,
            zombieTypes: 1,
            _id: 0
            } },
        { $sort: { zombieTypeCount: -1, totalZombies: -1 } },
        { $limit: 5 }
        ]);

    /*11. Sesiones con mayor dificultad basada en zombis enfurecidos y HP*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $match: { "zombies_active.is_enraged": true } },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            enragedZombies: { $sum: 1 },
            totalHP: { $sum: "$zombies_active.current_hp" },
            playerCount: { $first: { $size: "$players" } }
            } },
        { $lookup: {
            from: "maps",
            localField: "_id.map",
            foreignField: "map_name",
            as: "map_details"
            } },
        { $unwind: "$map_details" },
        { $project: {
            map: "$_id.map",
            enragedZombies: 1,
            totalHP: 1,
            playerCount: 1,
            hasNightCycle: "$map_details.has_night_cycle",
            difficultyScore: { $multiply: ["$enragedZombies", "$totalHP"] },
            _id: 0
            } },
        { $sort: { difficultyScore: -1 } },
        { $limit: 5 }
        ]);

    /*12. Zombis con mayor daño potencial en sesiones nocturnas*/
    db.map_sessions.aggregate([
        { $match: { is_night: true } },
        { $unwind: "$zombies_active" },
        { $lookup: {
            from: "zombie_types",
            localField: "zombies_active.type.type_name",
            foreignField: "type_name",
            as: "zombie_details"
            } },
        { $unwind: "$zombie_details" },
        { $group: {
            _id: { map: "$map.map_name", zombieType: "$zombies_active.type.type_name" },
            totalDamage: { $sum: "$zombie_details.base_damage" },
            zombieCount: { $sum: 1 }
            } },
        { $project: {
            map: "$_id.map",
            zombieType: "$_id.zombieType",
            totalDamage: 1,
            zombieCount: 1,
            avgDamagePerZombie: { $divide: ["$totalDamage", "$zombieCount"] },
            _id: 0
            } },
        { $sort: { totalDamage: -1 } }
        ]);

    /*13. Jugadores con mayor XP acumulado por nivel*/
    db.players.aggregate([
        { $match: { "player_stats.xp": { $gt: 0 } } },
        { $group: {
            _id: { username: "$username", level: "$player_stats.level" },
            totalXP: { $sum: "$player_stats.xp" },
            missionCount: { $sum: { $size: "$missions" } }
            } },
        { $project: {
            username: "$_id.username",
            level: "$_id.level",
            totalXP: 1,
            missionCount: 1,
            avgXPPerMission: { $cond: [{ $gt: ["$missionCount", 0] }, { $divide: ["$totalXP", "$missionCount"] }, 0] },
            _id: 0
            } },
        { $sort: { totalXP: -1, level: -1 } },
        { $limit: 5 }
        ]);
    /*14. Mapas con mayor actividad de habilidades de zombis*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $unwind: "$zombies_active.type.abilities" },
        { $lookup: {
            from: "abilities",
            localField: "zombies_active.type.abilities.ability_name",
            foreignField: "ability_name",
            as: "ability_details"
            } },
        { $unwind: "$ability_details" },
        { $group: {
            _id: { map: "$map.map_name", ability: "$zombies_active.type.abilities.ability_name" },
            totalZombies: { $sum: 1 },
            enragedCount: { $sum: { $cond: ["$zombies_active.is_enraged", 1, 0] } }
            } },
        { $project: {
            map: "$_id.map",
            ability: "$_id.ability",
            totalZombies: 1,
            enragedCount: 1,
            effectDesc: "$ability_details.effect_desc",
            _id: 0
            } },
        { $sort: { totalZombies: -1 } }
        ]);

    /*15. Misiones con mayor recompensa de XP por tipo de misión*/
    db.missions.aggregate([
        { $unwind: "$types" },
        { $match: { "target_json.reward": { $exists: true } } },
        { $group: {
            _id: { missionType: "$types.type_name", map: "$map.map_name" },
            totalMissions: { $sum: 1 },
            totalXP: { $sum: { $toInt: { $arrayElemAt: [{ $split: ["$target_json.reward", " "] }, 0] } } }
            } },
        { $lookup: {
            from: "mission_types",
            localField: "_id.missionType",
            foreignField: "type_name",
            as: "type_details"
            } },
        { $unwind: "$type_details" },
        { $project: {
            missionType: "$_id.missionType",
            map: "$_id.map",
            totalMissions: 1,
            totalXP: 1,
            avgXPPerMission: { $divide: ["$totalXP", "$totalMissions"] },
            _id: 0
            } },
        { $sort: { totalXP: -1 } }
        ]);

    /*16. Jugadores con mayor número de ítems en inventario por mapa*/
    db.map_sessions.aggregate([
        { $unwind: { path: "$players", preserveNullAndEmptyArrays: true } },
        { $match: { "players.left_at": null } },
        { $lookup: {
            from: "players",
            localField: "players.player_id",
            foreignField: "_id",
            as: "player_details"
            } },
        { $unwind: { path: "$player_details", preserveNullAndEmptyArrays: true } },
        { $unwind: { path: "$player_details.inventory.items", preserveNullAndEmptyArrays: true } },
        { $group: {
            _id: { username: "$player_details.username", map: "$map.map_name" },
            totalItems: { $sum: "$player_details.inventory.items.quantity" },
            itemCount: { $sum: { $cond: [{ $ne: ["$player_details.inventory.items", null] }, 1, 0] } }
            } },
        { $project: {
            username: "$_id.username",
            map: "$_id.map",
            totalItems: 1,
            itemCount: 1,
            _id: 0
            } },
        { $sort: { totalItems: -1, itemCount: -1 } },
        { $limit: 5 }
        ]);

    /*17. Misiones activas con mayor duración promedio*/
    db.players.aggregate([
        { $unwind: { path: "$missions", preserveNullAndEmptyArrays: true } },
        { $match: { "missions.state": "active" } },
        { $lookup: {
            from: "missions",
            localField: "missions.mission_id",
            foreignField: "_id",
            as: "mission_details"
            } },
        { $unwind: { path: "$mission_details", preserveNullAndEmptyArrays: true } },
        { $group: {
            _id: { mission: "$mission_details.mission_name", map: "$mission_details.map.map_name" },
            playerCount: { $sum: 1 },
            avgDurationHours: { $avg: { $divide: [{ $subtract: [new Date(), "$missions.started_at"] }, 1000 * 60 * 60] } }
            } },
        { $project: {
            mission: "$_id.mission",
            map: "$_id.map",
            playerCount: 1,
            avgDurationHours: { $round: ["$avgDurationHours", 2] },
            _id: 0
            } },
        { $sort: { avgDurationHours: -1 } },
        { $limit: 5 }
        ]);

    /*18. Sesiones con mayor variedad de tipos de zombis*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            zombieTypes: { $addToSet: "$zombies_active.type.type_name" },
            totalZombies: { $sum: 1 }
            } },
        { $project: {
            map: "$_id.map",
            zombieTypeCount: { $size: "$zombieTypes" },
            totalZombies: 1,
            zombieTypes: 1,
            _id: 0
            } },
        { $sort: { zombieTypeCount: -1, totalZombies: -1 } },
        { $limit: 5 }
        ]);

    /*19. Jugadores con mayor nivel y misiones completadas*/
    db.players.aggregate([
        { $unwind: { path: "$missions", preserveNullAndEmptyArrays: true } },
        { $match: { "missions.state": "completed" } },
        { $group: {
            _id: { username: "$username", level: "$player_stats.level" },
            completedMissions: { $sum: 1 },
            totalXP: { $sum: "$player_stats.xp" }
            } },
        { $project: {
            username: "$_id.username",
            level: "$_id.level",
            completedMissions: 1,
            totalXP: 1,
            _id: 0
            } },
        { $sort: { level: -1, completedMissions: -1 } },
        { $limit: 5 }
        ]);

    /*20. Tipos de misiones más comunes en sesiones activas*/
    db.players.aggregate([
        { $unwind: { path: "$missions", preserveNullAndEmptyArrays: true } },
        { $match: { "missions.state": "active" } },
        { $lookup: {
            from: "missions",
            localField: "missions.mission_id",
            foreignField: "_id",
            as: "mission_details"
            } },
        { $unwind: { path: "$mission_details", preserveNullAndEmptyArrays: true } },
        { $unwind: { path: "$mission_details.types", preserveNullAndEmptyArrays: true } },
        { $lookup: {
            from: "mission_types",
            localField: "mission_details.types.type_name",
            foreignField: "type_name",
            as: "type_details"
            } },
        { $unwind: { path: "$type_details", preserveNullAndEmptyArrays: true } },
        { $group: {
            _id: { missionType: "$mission_details.types.type_name", map: "$mission_details.map.map_name" },
            missionCount: { $sum: 1 },
            players: { $addToSet: "$username" }
            } },
        { $project: {
            missionType: "$_id.missionType",
            map: "$_id.map",
            missionCount: 1,
            playerCount: { $size: "$players" },
            _id: 0
            } },
        { $sort: { missionCount: -1 } }
        ]);
    