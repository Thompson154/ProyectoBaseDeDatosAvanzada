import { MongoClient } from "mongodb";
import { execSync } from "child_process";

async function main() {
  console.log("Arrancando docker-compose...");
  execSync("docker-compose up -d", { stdio: "inherit" });

  console.log("Esperando 15 segundos para que arranquen los servicios...");
  await new Promise(r => setTimeout(r, 15000));

  // Conexión a configsvr (replica set)
  const configClient = new MongoClient("mongodb://localhost:27019");
  await configClient.connect();
  console.log("Conectado a config server");

  const configDb = configClient.db("admin");

  // Iniciar configsvr replicaset
  try {
    const res = await configDb.command({
      replSetInitiate: {
        _id: "configReplSet",
        configsvr: true,
        members: [{ _id: 0, host: "configsvr:27019" }]
      }
    });
    console.log("Configsvr replSetInitiate:", res);
  } catch (e) {
    console.error("Error al iniciar configsvr replset (puede ya estar iniciado):", e.message);
  }

  await new Promise(r => setTimeout(r, 5000));

  await configClient.close();

  // Shard1 replicaset
  const shard1Client = new MongoClient("mongodb://localhost:27018");
  await shard1Client.connect();
  console.log("Conectado a shard1");

  const shard1Db = shard1Client.db("admin");

  try {
    const res = await shard1Db.command({
      replSetInitiate: {
        _id: "shard1ReplSet",
        members: [{ _id: 0, host: "shard1:27018" }]
      }
    });
    console.log("Shard1 replSetInitiate:", res);
  } catch (e) {
    console.error("Error al iniciar shard1 replset (puede ya estar iniciado):", e.message);
  }

  await new Promise(r => setTimeout(r, 5000));

  await shard1Client.close();

  // Shard2 replicaset
  const shard2Client = new MongoClient("mongodb://localhost:27017");
  await shard2Client.connect();
  console.log("Conectado a shard2");

  const shard2Db = shard2Client.db("admin");

  try {
    const res = await shard2Db.command({
      replSetInitiate: {
        _id: "shard2ReplSet",
        members: [{ _id: 0, host: "shard2:27017" }]
      }
    });
    console.log("Shard2 replSetInitiate:", res);
  } catch (e) {
    console.error("Error al iniciar shard2 replset (puede ya estar iniciado):", e.message);
  }

  await new Promise(r => setTimeout(r, 5000));

  await shard2Client.close();

  // Mongos: conectar y agregar shards
  const mongosClient = new MongoClient("mongodb://localhost:27020");
  await mongosClient.connect();
  console.log("Conectado a mongos");

  const adminDb = mongosClient.db("admin");

  try {
    let res = await adminDb.command({ addShard: "shard1ReplSet/shard1:27018" });
    console.log("Shard1 agregado:", res);

    res = await adminDb.command({ addShard: "shard2ReplSet/shard2:27017" });
    console.log("Shard2 agregado:", res);

    // Habilitar sharding en base y colección
    await adminDb.command({ enableSharding: "gameDB" });
    console.log("Sharding habilitado en gameDB");

    const gameDb = mongosClient.db("gameDB");
    // Crear colección players si no existe
    const collections = await gameDb.listCollections({ name: "players" }).toArray();
    if (collections.length === 0) {
      await gameDb.createCollection("players");
      console.log("Colección players creada");
    }

    // shardear collection players con shard key player_id
    res = await adminDb.command({
      shardCollection: "gameDB.players",
      key: { player_id: 1 }
    });
    console.log("Collection players shardeda:", res);
  } catch (e) {
    console.error("Error configurando mongos:", e.message);
  }

  await mongosClient.close();

  console.log("Configuración de cluster MongoDB sharded completada.");
}

main().catch(console.error);
