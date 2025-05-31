
const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");
require("dotenv").config();

function restorePostgres() {
  const container = process.env.PG_CONTAINER;
  const user = process.env.PG_USER;
  const db = process.env.PG_DB;
  const folder = process.env.PG_BACKUP_FOLDER;

  const latestDump = fs.readdirSync(folder)
    .filter(name => name.endsWith(".dump"))
    .sort()
    .reverse()[0];

  if (!latestDump) {
    console.error("❌ No PostgreSQL .dump file found in", folder);
    return;
  }

  const dbToRestore = `hash_${db}`;
  const containerDumpPath = `/tmp/${latestDump}`;
  const localDumpPath = path.join(folder, latestDump);

  console.log("Copying backup to container: " + containerDumpPath);
  execSync(`docker cp "${localDumpPath}" ${container}:${containerDumpPath}`);

  console.log("Creating database: " + dbToRestore);
  execSync(`docker exec -u postgres ${container} createdb -U ${user} ${dbToRestore}`);

  console.log("Restoring database...");
  execSync(`docker exec -u postgres ${container} pg_restore -U ${user} -d ${dbToRestore} ${containerDumpPath}`, {
    stdio: "inherit",
    shell: "/bin/bash"
  });

  console.log("PostgreSQL restoration complete.");
}

try {
  restorePostgres();
} catch (err) {
  console.error("❌ Error during restore:", err.message);
}
