db = db.getSiblingDB('videojuego');
    /*1. Jugadores con más XP por nivel*/
    db.players.aggregate([
        { $match: { "player_stats.level": { $gte: 1 } } },
        { $group: {
            _id: "$player_stats.level",
            totalXP: { $sum: "$player_stats.xp" },
            players: { $push: { username: "$user_id", xp: "$player_stats.xp" } },
            count: { $sum: 1 }
        } },
        { $lookup: {
            from: "users",
            localField: "_id.username",
            foreignField: "_id",
            as: "user_info"
        } },
        { $unwind: "$user_info" },
        { $project: {
            level: "$_id",
            totalXP: 1,
            count: 1,
            topPlayer: { $arrayElemAt: ["$players", 0] },
            _id: 0
        } },
        { $sort: { level: -1 } }
    ]);

    /*2. Inventario total por rareza de ítems*/
    db.players.aggregate([
        { $unwind: "$inventory.items" },
        { $lookup: {
            from: "items",
            localField: "inventory.items.item_id",
            foreignField: "_id",
            as: "item_info"
        } },
        { $unwind: "$item_info" },
        { $group: {
            _id: "$item_info.rarity.rarity_name",
            totalItems: { $sum: "$inventory.items.quantity" },
            totalDamage: { $sum: { $multiply: ["$inventory.items.quantity", "$item_info.base_damage"] } }
        } },
        { $project: {
            rarity: "$_id",
            totalItems: 1,
            totalDamage: 1,
            _id: 0
        } },
        { $sort: { totalItems: -1 } }
    ]);

    /*3. Jugadores con misiones completadas por tipo*/
    db.players.aggregate([
        { $unwind: "$missions" },
        { $match: { "missions.state": "completed" } },
        { $lookup: {
            from: "missions",
            localField: "missions.mission_id",
            foreignField: "_id",
            as: "mission_info"
        } },
        { $unwind: "$mission_info" },
        { $unwind: "$mission_info.types" },
        { $group: {
            _id: "$mission_info.types.type_name",
            completedCount: { $sum: 1 },
            players: { $addToSet: "$user_id" }
        } },
        { $lookup: {
            from: "users",
            localField: "players",
            foreignField: "_id",
            as: "player_info"
        } },
        { $project: {
            missionType: "$_id",
            completedCount: 1,
            playerCount: { $size: "$players" },
            playerNames: "$player_info.username",
            _id: 0
        } }
    ]);

    /*4. Sesiones activas con más jugadores*/
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

    /*5. Zombis activos por tipo en sesiones*/
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

    /*6. Habilidades más desbloqueadas por jugadores*/
    db.players.aggregate([
        { $unwind: "$skills_unlocked" },
        { $lookup: {
            from: "skills",
            localField: "skills_unlocked.skill_id",
            foreignField: "_id",
            as: "skill_info"
        } },
        { $unwind: "$skill_info" },
        { $group: {
            _id: "$skill_info.skill_name",
            unlockCount: { $sum: 1 },
            players: { $addToSet: "$user_id" }
        } },
        { $lookup: {
            from: "users",
            localField: "players",
            foreignField: "_id",
            as: "player_info"
        } },
        { $project: {
            skillName: "$_id",
            unlockCount: 1,
            playerCount: { $size: "$players" },
            playerNames: "$player_info.username",
            _id: 0
        } },
        { $sort: { unlockCount: -1 } }
    ]);

    /*7. Daño promedio de ítems en inventarios*/
    db.players.aggregate([
        { $unwind: "$inventory.items" },
        { $lookup: {
            from: "items",
            localField: "inventory.items.item_id",
            foreignField: "_id",
            as: "item_info"
        } },
        { $unwind: "$item_info" },
        { $match: { "item_info.base_damage": { $gt: 0 } } },
        { $group: {
            _id: "$user_id",
            avgDamage: { $avg: "$item_info.base_damage" },
            totalItems: { $sum: "$inventory.items.quantity" }
        } },
        { $lookup: {
            from: "users",
            localField: "_id",
            foreignField: "_id",
            as: "user_info"
        } },
        { $unwind: "$user_info" },
        { $project: {
            username: "$user_info.username",
            avgDamage: 1,
            totalItems: 1,
            _id: 0
        } },
        { $sort: { avgDamage: -1 } }
    ]);

    /*8. Sesiones con mayor actividad de zombis enfurecidos*/
    db.map_sessions.aggregate([
        { $unwind: "$zombies_active" },
        { $match: { "zombies_active.is_enraged": true } },
        { $group: {
            _id: { session: "$_id", map: "$map.map_name" },
            enragedZombies: { $sum: 1 },
            totalHP: { $sum: "$zombies_active.current_hp" }
        } },
        { $project: {
            map: "$_id.map",
            enragedZombies: 1,
            totalHP: 1,
            _id: 0
        } },
        { $sort: { enragedZombies: -1 } },
        { $limit: 5 }
    ]);

    /*9. Misiones activas por mapa*/
    db.players.aggregate([
        { $unwind: "$missions" },
        { $match: { "missions.state": "active" } },
        { $lookup: {
            from: "missions",
            localField: "missions.mission_id",
            foreignField: "_id",
            as: "mission_info"
        } },
        { $unwind: "$mission_info" },
        { $group: {
            _id: "$mission_info.map.map_name",
            activeMissions: { $sum: 1 },
            missionNames: { $push: "$mission_info.mission_name" }
        } },
        { $project: {
            map: "$_id",
            activeMissions: 1,
            missionNames: 1,
            _id: 0
        } },
        { $sort: { activeMissions: -1 } }
    ]);

    /*10. Jugadores con mayor capacidad de inventario*/
    db.players.aggregate([
        { $match: { "inventory.capacity": { $gt: 0 } } },
        { $lookup: {
            from: "users",
            localField: "user_id",
            foreignField: "_id",
            as: "user_info"
        } },
        { $unwind: "$user_info" },
        { $project: {
            username: "$user_info.username",
            inventoryCapacity: "$inventory.capacity",
            itemCount: { $size: "$inventory.items" },
            level: "$player_stats.level",
            _id: 0
        } },
        { $sort: { inventoryCapacity: -1 } },
        { $limit: 5 }
    ]);

    /*11. Tipos de zombis más comunes en sesiones*/
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

    /*12. Misiones con mayor recompensa de XP*/
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

    /*13. Jugadores con más ítems legendarios*/
    db.players.aggregate([
        { $unwind: "$inventory.items" },
        { $lookup: {
            from: "items",
            localField: "inventory.items.item_id",
            foreignField: "_id",
            as: "item_info"
        } },
        { $unwind: "$item_info" },
        { $match: { "item_info.rarity.rarity_name": "Legendario" } },
        { $group: {
            _id: "$user_id",
            legendaryCount: { $sum: "$inventory.items.quantity" }
        } },
        { $lookup: {
            from: "users",
            localField: "_id",
            foreignField: "_id",
            as: "user_info"
        } },
        { $unwind: "$user_info" },
        { $project: {
            username: "$user_info.username",
            legendaryCount: 1,
            _id: 0
        } },
        { $sort: { legendaryCount: -1 } }
    ]);

    /*14. Mapas con mayor actividad nocturna*/
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

    /*15. Habilidades de zombis más comunes en sesiones*/
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

    /*16. Progreso promedio de misiones por jugador*/
    db.players.aggregate([
        { $unwind: "$missions" },
        { $group: {
            _id: "$user_id",
            totalMissions: { $sum: 1 },
            completedMissions: { $sum: { $cond: [{ $eq: ["$missions.state", "completed"] }, 1, 0] } }
        } },
        { $lookup: {
            from: "users",
            localField: "_id",
            foreignField: "_id",
            as: "user_info"
        } },
        { $unwind: "$user_info" },
        { $project: {
            username: "$user_info.username",
            totalMissions: 1,
            completedMissions: 1,
            completionRate: { $divide: ["$completedMissions", "$totalMissions"] },
            _id: 0
        } },
        { $sort: { completionRate: -1 } }
    ]);

    /*17. Sesiones con mayor daño potencial de zombis*/
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

    /*18. Jugadores con más sesiones activas*/
    db.map_sessions.aggregate([
        { $unwind: "$players" },
        { $match: { "players.left_at": null } },
        { $group: {
            _id: "$players.player_id",
            activeSessions: { $sum: 1 },
            maps: { $addToSet: "$map.map_name" }
        } },
        { $lookup: {
            from: "users",
            localField: "_id",
            foreignField: "_id",
            as: "user_info"
        } },
        { $unwind: "$user_info" },
        { $project: {
            username: "$user_info.username",
            activeSessions: 1,
            mapCount: { $size: "$maps" },
            maps: 1,
            _id: 0
        } },
        { $sort: { activeSessions: -1 } }
    ]);

    /*19. Ítems más usados en sesiones*/
    db.map_sessions.aggregate([
        { $unwind: "$players" },
        { $lookup: {
            from: "players",
            localField: "players.player_id",
            foreignField: "_id",
            as: "player_info"
        } },
        { $unwind: "$player_info" },
        { $unwind: "$player_info.inventory.items" },
        { $lookup: {
            from: "items",
            localField: "player_info.inventory.items.item_id",
            foreignField: "_id",
            as: "item_info"
        } },
        { $unwind: "$item_info" },
        { $group: {
            _id: "$item_info.name",
            totalQuantity: { $sum: "$player_info.inventory.items.quantity" },
            maps: { $addToSet: "$map.map_name" }
        } },
        { $project: {
            itemName: "$_id",
            totalQuantity: 1,
            mapCount: { $size: "$maps" },
            maps: 1,
            _id: 0
        } },
        { $sort: { totalQuantity: -1 } }
    ]);

    /*20. Mapas con mayor variedad de tipos de misiones*/
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