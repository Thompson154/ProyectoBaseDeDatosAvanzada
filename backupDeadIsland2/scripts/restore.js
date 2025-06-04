const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");
require("dotenv").config();

const isWindows = process.platform === "win32";
const shellOption = isWindows ? undefined : "/bin/bash";

const DB_SUFFIX = "8";

function restorePostgres() {
  const folder = process.env.PG_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".dump"))
    .sort()
    .reverse()[0];

  if (!latestFile) return console.error("❌ No PostgreSQL backup found.");

  const container = process.env.PG_CONTAINER;
  const user = process.env.PG_USER;
  const tempFolder = process.env.PG_TEMP_FOLDER;
  const baseName = process.env.PG_DB;
  const newDb = `${DB_SUFFIX}hash_${baseName}`;
  const localPath = path.join(folder, latestFile);
  const containerPath = path.posix.join(tempFolder, latestFile);

  console.log(`📤 Copiando backup a contenedor: ${containerPath}`);
  execSync(`docker cp "${localPath}" ${container}:${containerPath}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log(`📀 Creando base de datos ${newDb}`);
  execSync(`docker exec -u postgres ${container} createdb -U ${user} ${newDb}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log(`♻ Restaurando base de datos: ${newDb}`);
  execSync(`docker exec -u postgres ${container} pg_restore -U ${user} -d ${newDb} ${containerPath}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log("✅ PostgreSQL restaurado en:", newDb);
}

function restoreMariaDB() {
  const folder = process.env.MARIADB_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".sql"))
    .sort()
    .reverse()[0];

  if (!latestFile) return console.error("No MariaDB backup found.");

  const container = process.env.MARIADB_CONTAINER;
  const user = process.env.MARIADB_USER;
  const pass = process.env.MARIADB_PASSWORD;
  const baseName = process.env.MARIADB_DB;
  const newDb = `${DB_SUFFIX}hash_${baseName}`;
  const tempFolder = process.env.MARIADB_TEMP_FOLDER;
  const localPath = path.join(folder, latestFile);
  const containerPath = path.posix.join(tempFolder, latestFile);

  console.log(`📤 Copiando backup a contenedor: ${containerPath}`);
  execSync(`docker cp "${localPath}" ${container}:${containerPath}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log(`📀 Creando base de datos ${newDb}`);
  execSync(`docker exec ${container} mysql -uroot -p${pass} -e "CREATE DATABASE ${newDb}"`, {
    stdio: "inherit", shell: shellOption
  });

  console.log(`♻ Restaurando MariaDB en ${newDb}`);
  execSync(`docker exec ${container} sh -c "mysql -uroot -p${pass} ${newDb} < ${containerPath}"`, {
    stdio: "inherit", shell: shellOption
  });

  console.log("✅ MariaDB restaurado en:", newDb);
}

function restoreMongo() {
  const folder = process.env.MONGO_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".archive"))
    .sort()
    .reverse()[0];

  if (!latestFile) return console.error("No MongoDB backup found.");

  const container = process.env.MONGO_CONTAINER;
  const db = process.env.MONGO_DB;
  const newDb = `${DB_SUFFIX}hash_${db}`;
  const tempFolder = process.env.MONGO_TEMP_FOLDER;
  const localPath = path.join(folder, latestFile);
  const containerPath = path.posix.join(tempFolder, latestFile);

  console.log(`📤 Copiando backup a contenedor: ${containerPath}`);
  execSync(`docker cp "${localPath}" ${container}:${containerPath}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log(`♻ Restaurando MongoDB en ${newDb}`);
  execSync(`docker exec ${container} mongorestore --nsFrom='${db}.*' --nsTo='${newDb}.*' --archive=${containerPath}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log("✅ MongoDB restaurado en:", newDb);
}

function restoreRedis() {
  const folder = process.env.REDIS_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".rdb"))
    .sort()
    .reverse()[0];

  if (!latestFile) return console.error("No Redis backup found.");

  const container = process.env.REDIS_CONTAINER;
  const localPath = path.join(folder, latestFile);
  const containerPath = path.posix.join("/data", "dump.rdb");

  console.log(`📤 Copiando snapshot RDB a contenedor: ${containerPath}`);
  execSync(`docker cp "${localPath}" ${container}:${containerPath}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log("♻ Reiniciando Redis para aplicar RDB...");
  execSync(`docker restart ${container}`, {
    stdio: "inherit", shell: shellOption
  });

  console.log("✅ Redis restaurado correctamente.");
}

try {
  restorePostgres();
  restoreMariaDB();
  restoreMongo();
  restoreRedis();
} catch (err) {
  console.error("Error al restaurar:", err.message);
}
