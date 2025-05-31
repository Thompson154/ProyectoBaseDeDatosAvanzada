
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

  if (!latestFile) return console.error("No PostgreSQL backup found.");

  const fullPath = path.join(folder, latestFile);
  console.log(`Restoring PostgreSQL from ${fullPath}...`);

  execSync(
    `docker exec -i ${process.env.PG_CONTAINER} pg_restore -U ${process.env.PG_USER} -d ${process.env.PG_DB} -c < ${fullPath}`,
    { stdio: "inherit", shell: "/bin/bash" }
  );
}

function restoreMariaDB() {
  const folder = process.env.MARIADB_BACKUP_FOLDER;
  const latestFile = fs.readdirSync(folder)
    .filter(name => name.endsWith(".sql"))
    .sort()
    .reverse()[0];

  if (!latestFile) return console.error("No MariaDB backup found.");

  const fullPath = path.join(folder, latestFile);
  console.log(`Restoring MariaDB from ${fullPath}...`);

  execSync(
    `docker exec -i ${process.env.MARIADB_CONTAINER} mysql -u${process.env.MARIADB_USER} -p${process.env.MARIADB_PASSWORD} ${process.env.MARIADB_DB} < ${fullPath}`,
    { stdio: "inherit", shell: "/bin/bash" }
  );
}

try {
  restorePostgres();
  restoreMariaDB();
  console.log("Restauración completada para PostgreSQL y MariaDB.");
} catch (err) {
  console.error("Error al restaurar:", err.message);
}
