const { createClient } = require("redis");
const postgres = require("postgres");

const sql = postgres("postgres://user:password@localhost:5432/database", {
  host: "localhost",
  port: 5432,
  database: "videojuego",
  username: "dbthompson",
  password: "thompson154",
});

const getPlayerStatsDB = async (playerId) => {
  const stats = await sql`
    SELECT hp, stamina, level, xp
    FROM player_stats
    WHERE player_id = ${playerId}
  `;
  return stats[0] || null;
};

const getInventoryDB = async (playerId) => {
  const capacity = await sql`
    SELECT capacity
    FROM inventories
    WHERE player_id = ${playerId}
  `;
  const items = await sql`
    SELECT item_id, quantity
    FROM inventory_items
    WHERE inventory_id = (SELECT inventory_id FROM inventories WHERE player_id = ${playerId})
  `;
  return { capacity: capacity[0]?.capacity, items };
};

const client = createClient({
  url: "redis://:root123@localhost:6379",
});

client.connect().catch(console.error);

const PLAYER_STATS_KEY = "player_stats:";
const INVENTORY_KEY = "inventory_items:";
const INVENTORY_CAPACITY_KEY = "inventory:";

const getPlayerCache = async (key) => {
  const cached = await client.get(key);
  if (cached) {
    return JSON.parse(cached);
  }
  return null;
};

const setPlayerCache = async (key, data, ttl) => {
  await client.setEx(key, ttl, JSON.stringify(data));
};

const getPlayerStats = async (playerId) => {
  const redisKey = `${PLAYER_STATS_KEY}${playerId}`;
  const cachedData = await getPlayerCache(redisKey);
  if (cachedData) {
    console.log("From Redis", cachedData);
    return cachedData;
  }

  const response = await getPlayerStatsDB(playerId);
  console.log(response);
  if (response) {
    await setPlayerCache(redisKey, response, 30); 
  }
  return response;
};

const getInventory = async (playerId) => {
  const redisKey = `${INVENTORY_KEY}${playerId}`;
  const cachedData = await getPlayerCache(redisKey);
  if (cachedData) {
    console.log("From Redis", cachedData);
    return cachedData;
  }

  const response = await getInventoryDB(playerId);
  console.log(response);
  if (response) {
    await setPlayerCache(redisKey, response, 60); 
  }
  return response;
};

const setPlayerStats = async (data) => {
  const redisKey = `${PLAYER_STATS_KEY}${data.playerId}`;
  const response = await setPlayerStatsData(data);
  if (response.ok) {
    await setPlayerCache(redisKey, response.data, 30); 
  }
  return response;
};

getPlayerStats(1);
getInventory(1);