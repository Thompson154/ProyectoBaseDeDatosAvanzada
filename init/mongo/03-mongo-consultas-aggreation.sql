use deadisland;

/* 1. Contar jugadores por nivel */
db.players.aggregate([
  { $group: { _id: "$stats.level", totalPlayers: { $sum: 1 } } },
  { $sort: { _id: 1 } }
]);

/* 2. Filtrar jugadores con HP menor a 50 y agrupar por nivel */
db.players.aggregate([
  { $match: { "stats.hp": { $lt: 50 } } },
  { $group: { _id: "$stats.level", count: { $sum: 1 } } },
  { $sort: { _id: 1 } }
]);

/* 3. Unir players con users y proyectar username y stats */
db.players.aggregate([
  { $lookup: { from: "users", localField: "user_id", foreignField: "_id", as: "user_info" } },
  { $unwind: "$user_info" },
  { $project: { username: "$user_info.username", hp: "$stats.hp", level: "$stats.level" } }
]);

/* 4. Contar ítems por rareza en inventarios */
db.players.aggregate([
  { $unwind: "$inventory.items" },
  { $lookup: { from: "items", localField: "inventory.items.item_id", foreignField: "_id", as: "item_info" } },
  { $unwind: "$item_info" },
  { $group: { _id: "$item_info.rarity.rarity_name", totalItems: { $sum: "$inventory.items.quantity" } } }
]);

/* 5. Jugadores con misiones activas y su mapa */
db.players.aggregate([
  { $unwind: "$missions" },
  { $match: { "missions.state": "active" } },
  { $lookup: { from: "missions", localField: "missions.mission_id", foreignField: "_id", as: "mission_info" } },
  { $unwind: "$mission_info" },
  { $lookup: { from: "maps", localField: "mission_info.map.map_id", foreignField: "_id", as: "map_info" } },
  { $unwind: "$map_info" },
  { $project: { player_id: "$_id", mission_name: "$mission_info.mission_name", map_name: "$map_info.map_name" } }
]);

/* 6. Promedio de XP por nivel */
db.players.aggregate([
  { $group: { _id: "$stats.level", avgXP: { $avg: "$stats.xp" } } },
  { $sort: { _id: 1 } }
]);

/* 7. Jugadores con más de 3 ítems en inventario */
db.players.aggregate([
  { $unwind: "$inventory.items" },
  { $group: { _id: "$_id", itemCount: { $sum: 1 } } },
  { $match: { itemCount: { $gt: 3 } } },
  { $project: { player_id: "$_id", itemCount: 1 } }
]);

/* 8. Zombis activos por tipo en sesiones */
db.map_sessions.aggregate([
  { $unwind: "$zombies_active" },
  { $group: { _id: "$zombies_active.type.type_name", totalZombies: { $sum: 1 } } }
]);

/* 9. Jugadores con habilidades desbloqueadas específicas */
db.players.aggregate([
  { $unwind: "$skills_unlocked" },
  { $lookup: { from: "skills", localField: "skills_unlocked.skill_id", foreignField: "_id", as: "skill_info" } },
  { $unwind: "$skill_info" },
  { $match: { "skill_info.skill_name": "Afilado" } },
  { $project: { player_id: "$_id", skill_name: "$skill_info.skill_name", unlocked_at: "$skills_unlocked.unlocked_at" } }
]);

/* 10. Misiones completadas por mapa */
db.players.aggregate([
  { $unwind: "$missions" },
  { $match: { "missions.state": "completed" } },
  { $group: { _id: "$missions.map.map_name", completedMissions: { $sum: 1 } } }
]);

/* 11. Total de daño base en inventarios por jugador */
db.players.aggregate([
  { $unwind: "$inventory.items" },
  { $lookup: { from: "items", localField: "inventory.items.item_id", foreignField: "_id", as: "item_info" } },
  { $unwind: "$item_info" },
  { $group: { _id: "$_id", totalDamage: { $sum: "$item_info.base_damage" } } },
  { $project: { player_id: "$_id", totalDamage: 1 } }
]);

/* 12. Jugadores en sesiones nocturnas */
db.map_sessions.aggregate([
  { $match: { is_night: true } },
  { $unwind: "$players" },
  { $project: { player_id: "$players.player_id", username: "$players.username", map_name: "$map.map_name" } }
]);

/* 13. Habilidades más comunes entre zombis */
db.zombie_types.aggregate([
  { $unwind: "$abilities" },
  { $group: { _id: "$abilities.ability_name", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]);

/* 14. Jugadores con inventario lleno */
db.players.aggregate([
  { $unwind: "$inventory.items" },
  { $group: { _id: "$_id", totalItems: { $sum: "$inventory.items.quantity" }, capacity: { $first: "$inventory.capacity" } } },
  { $match: { $expr: { $gte: ["$totalItems", "$capacity"] } } },
  { $project: { player_id: "$_id", totalItems: 1, capacity: 1 } }
]);

/* 15. Promedio de HP de zombis activos por mapa */
db.map_sessions.aggregate([
  { $unwind: "$zombies_active" },
  { $group: { _id: "$map.map_name", avgZombieHP: { $avg: "$zombies_active.current_hp" } } }
]);

/* 16. Unir missions con mission_types y filtrar por tipo */
db.missions.aggregate([
  { $unwind: "$types" },
  { $match: { "types.type_name": "Eliminación" } },
  { $project: { mission_name: 1, map_name: "$map.map_name", type_name: "$types.type_name" } }
]);

/* 17. Jugadores con más de 2 misiones activas */
db.players.aggregate([
  { $unwind: "$missions" },
  { $match: { "missions.state": "active" } },
  { $group: { _id: "$_id", activeMissions: { $sum: 1 } } },
  { $match: { activeMissions: { $gt: 2 } } },
  { $project: { player_id: "$_id", activeMissions: 1 } }
]);

/* 18. Total de jugadores por mapa en sesiones */
db.map_sessions.aggregate([
  { $unwind: "$players" },
  { $group: { _id: "$map.map_name", totalPlayers: { $sum: 1 } } },
  { $sort: { totalPlayers: -1 } }
]);

/* 19. Ítems legendarios en inventarios */
db.players.aggregate([
  { $unwind: "$inventory.items" },
  { $lookup: { from: "items", localField: "inventory.items.item_id", foreignField: "_id", as: "item_info" } },
  { $unwind: "$item_info" },
  { $match: { "item_info.rarity.rarity_name": "Legendario" } },
  { $project: { player_id: "$_id", item_name: "$item_info.name", base_damage: "$item_info.base_damage" } }
]);

/* 20. Zombis enfurecidos por tipo y mapa */
db.map_sessions.aggregate([
  { $unwind: "$zombies_active" },
  { $match: { "zombies_active.is_enraged": true } },
  { $group: { _id: { map: "$map.map_name", type: "$zombies_active.type.type_name" }, count: { $sum: 1 } } },
  { $project: { map: "$_id.map", zombie_type: "$_id.type", count: 1 } }
]);