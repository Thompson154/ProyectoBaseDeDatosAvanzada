
const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");
require("dotenv").config();

function restorePostgres() {
  const folder = process.env.PG_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".dump"))
    .sort()
    .reverse()[0];

  if (!latestFile) {
    console.error("❌ No PostgreSQL backup found.");
    return;
  }

  const container = process.env.PG_CONTAINER;
  const user = process.env.PG_USER;
  const tempFolder = process.env.PG_TEMP_FOLDER;
  const db = process.env.PG_DB;
  const newDb = "hash_" + db;
  const localPath = path.join(folder, latestFile);
  const containerPath = path.posix.join(tempFolder, latestFile);

  console.log(`Copiando backup a contenedor: ${containerPath}`);
  execSync(`docker cp "${localPath}" ${container}:${containerPath}`);

  console.log(`Creando base de datos ${newDb}`);
  execSync(`docker exec -u postgres ${container} createdb -U ${user} ${newDb}`);

  console.log(`Restaurando base de datos desde: ${latestFile}`);
  execSync(`docker exec -u postgres ${container} pg_restore -U ${user} -d ${newDb} ${containerPath}`, {
    stdio: "inherit",
    shell: "/bin/bash"
  });

  console.log("✅ PostgreSQL restaurado con éxito en", newDb);
}

function restoreMariaDB() {
  const folder = process.env.MARIADB_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".sql"))
    .sort()
    .reverse()[0];

  if (!latestFile) {
    console.error("No MariaDB backup found.");
    return;
  }

  const container = process.env.MARIADB_CONTAINER;
  const user = process.env.MARIADB_USER;
  const pass = process.env.MARIADB_PASSWORD;
  const db = process.env.MARIADB_DB;
  const tempFolder = process.env.MARIADB_TEMP_FOLDER;
  const localPath = path.join(folder, latestFile);
  const containerPath = path.posix.join(tempFolder, latestFile);

  console.log(`Copiando backup a contenedor: ${containerPath}`);
  execSync(`docker cp "${localPath}" ${container}:${containerPath}`);

  console.log(`Restaurando MariaDB desde: ${latestFile}`);
  execSync(`docker exec ${container} sh -c "mysql -u${user} -p${pass} ${db} < ${containerPath}"`, {
    stdio: "inherit",
    shell: "/bin/bash"
  });

  console.log("MariaDB restaurado con éxito en", db);
}

try {
  restorePostgres();
  restoreMariaDB();
} catch (err) {
  console.error("❌ Error al restaurar:", err.message);
}
