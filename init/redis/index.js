const { createClient } = require("redis");
const postgres = require("postgres");

const sql = postgres("postgres://dbthompson:thompson154@localhost:5432/videojuego", {
  host: "localhost",
  port: 5432,
  database: "videojuego",
  username: "dbthompson",
  password: "thompson154",
});

const client = createClient({
  url: "redis://:root123@localhost:6379",
});

client.connect().catch(console.error);

const INVENTORY_CAPACITY_KEY = "inventory:";
const PLAYER_SKILLS_KEY = "player_skills:";


const getInventoryCapacity = async (playerId) => {
  const redisKey = `${INVENTORY_CAPACITY_KEY}${playerId}`;
  const cachedCapacity = await client.hGet(redisKey, "capacity");
  if (cachedCapacity) {
    console.log("Desde Redis:", { capacity: parseInt(cachedCapacity) });
    return { capacity: parseInt(cachedCapacity) };
  }

  const capacityData = await sql`
    SELECT capacity
    FROM inventories
    WHERE player_id = ${playerId}
  `;
  const capacity = capacityData[0]?.capacity;
  if (capacity) {
    await client.hSet(redisKey, "capacity", capacity.toString());
    await client.expire(redisKey, 86400); 
    console.log("Desde DB:", { capacity });
    return { capacity };
  }

  return null;
};

const getPlayerSkills = async (playerId) => {
  const redisKey = `${PLAYER_SKILLS_KEY}${playerId}`;
  const cachedSkills = await client.hGetAll(redisKey);
  if (Object.keys(cachedSkills).length > 0) {
    const skills = Object.keys(cachedSkills).map((skillId) => ({
      skill_id: parseInt(skillId),
      unlocked_at: new Date(cachedSkills[skillId]),
    }));
    console.log("Desde Redis:", skills);
    return skills;
  }

  const skills = await sql`
    SELECT skill_id, unlocked_at
    FROM player_skills
    WHERE player_id = ${playerId}
  `;
  if (skills.length > 0) {
    const hashData = {};
    skills.forEach((skill) => {
      hashData[skill.skill_id.toString()] = skill.unlocked_at.toISOString();
    });
    await client.hSet(redisKey, hashData);
    await client.expire(redisKey, 43200);
    console.log("Desde DB:", skills);
    return skills;
  }

  return [];
};

const getCompletedMissions = async (playerId) => {
  const redisKey = `completed_missions:${playerId}`;
  const cachedMissions = await client.hGetAll(redisKey);
  if (Object.keys(cachedMissions).length > 0) {
    const missions = Object.keys(cachedMissions).map((missionId) => ({
      mission_id: parseInt(missionId),
      finished_at: new Date(cachedMissions[missionId]),
    }));
    console.log("Desde Redis:", missions);
    return missions;
  }

 
  const missions = await sql`
    SELECT mission_id, finished_at
    FROM player_missions
    WHERE player_id = ${playerId} AND state = 'completed'
  `;
  if (missions.length > 0) {
    const hashData = {};
    missions.forEach((mission) => {
      hashData[mission.mission_id.toString()] = mission.finished_at.toISOString();
    });
    await client.hSet(redisKey, hashData);
    await client.expire(redisKey, 604800);
    console.log("Desde DB:", missions);
    return missions;
  }

  return [];
};

(async () => {

  const capacity = await getInventoryCapacity(1);
  console.log("Capacidad:", capacity);

  const skills = await getPlayerSkills(1);
  console.log("Habilidades:", skills);

  const completedMissions = await getCompletedMissions(19);
  console.log("Misiones completadas:", completedMissions);

})();
