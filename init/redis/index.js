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
const INVENTORY_ITEMS_SET_KEY = "inventory_items_set:";
const INVENTORY_QUANTITIES_KEY = "inventory_quantities:";
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

const getInventoryItemsCache = async (playerId) => {
  const setKey = `${INVENTORY_ITEMS_SET_KEY}${playerId}`;
  const hashKey = `${INVENTORY_QUANTITIES_KEY}${playerId}`;

  const itemIds = await client.sMembers(setKey);
  if (itemIds.length === 0) return null;

  const items = [];
  for (const itemId of itemIds) {
    const quantity = await client.hGet(hashKey, itemId);
    if (quantity) {
      items.push({ item_id: parseInt(itemId), quantity: parseInt(quantity) });
    }
  }

  return items;
};

const setInventoryItemsCache = async (playerId, items, ttl) => {
  const setKey = `${INVENTORY_ITEMS_SET_KEY}${playerId}`;
  const hashKey = `${INVENTORY_QUANTITIES_KEY}${playerId}`;

  await client.del(setKey);
  await client.del(hashKey);

  for (const item of items) {
    await client.sAdd(setKey, item.item_id.toString());
    await client.hSet(hashKey, item.item_id.toString(), item.quantity.toString());
  }

  await client.expire(setKey, ttl);
  await client.expire(hashKey, ttl);
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
  const redisCapacityKey = `${INVENTORY_CAPACITY_KEY}${playerId}`;
  const cachedItems = await getInventoryItemsCache(playerId);
  const cachedCapacity = await getPlayerCache(redisCapacityKey);

  if (cachedItems && cachedCapacity) {
    console.log("From Redis", { capacity: cachedCapacity, items: cachedItems });
    return { capacity: cachedCapacity, items: cachedItems };
  }

  const response = await getInventoryDB(playerId);
  console.log(response);
  if (response) {
    await setPlayerCache(redisCapacityKey, response.capacity, 60);
    if (response.items.length > 0) {
      await setInventoryItemsCache(playerId, response.items, 60);
    }
  }
  return response;
};


(async () => {
  await getPlayerStats(1);
  await getInventory(1);
})();

