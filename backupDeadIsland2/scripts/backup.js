const cron = require("cron");
const { exec } = require("child_process");
require("dotenv").config();
const fs = require("fs");

// Crea carpetas de backup si no hay
[
  process.env.PG_BACKUP_FOLDER,
  process.env.MARIADB_BACKUP_FOLDER,
  process.env.MONGO_BACKUP_FOLDER,
  process.env.REDIS_BACKUP_FOLDER,
].forEach(
  (dir) => dir && !fs.existsSync(dir) && fs.mkdirSync(dir, { recursive: true })
);

const fecha = () => new Date().toISOString().replace(/[:T]/g, "_").slice(0, 16);

// PostgreSQL Backup
function backupPostgres() {
  const fileName = `backup_deadIsland2${fecha()}.dump`;
  const cmd = `docker exec -u postgres ${process.env.PG_CONTAINER} \
pg_dump -U ${process.env.PG_USER} -F c -d ${process.env.PG_DB} -f ${process.env.PG_TEMP_FOLDER}/${fileName}`;

  const cpCmd = `docker cp ${process.env.PG_CONTAINER}:${process.env.PG_TEMP_FOLDER}/${fileName} ${process.env.PG_BACKUP_FOLDER}/${fileName}`;
  exec(cmd, (err) => {
    if (err) return console.error("PG backup error:", err.message);
    exec(cpCmd, (err2) => {
      if (err2) return console.error("PG copy error:", err2.message);
      console.log("PostgreSQL backup done:", fileName);
    });
  });
}

// MariaDB Backup
function backupMariaDB() {
  const fileName = `backup_deadIsland2${fecha()}.sql`;
  const cmd = `docker exec ${process.env.MARIADB_CONTAINER} sh -c "mysqldump -u${process.env.MARIADB_USER} -p${process.env.MARIADB_PASSWORD} ${process.env.MARIADB_DB} > ${process.env.MARIADB_TEMP_FOLDER}/${fileName}"`;
  const cpCmd = `docker cp ${process.env.MARIADB_CONTAINER}:${process.env.MARIADB_TEMP_FOLDER}/${fileName} ${process.env.MARIADB_BACKUP_FOLDER}/${fileName}`;
  exec(cmd, (err) => {
    if (err) return console.error("MariaDB backup error:", err.message);
    exec(cpCmd, (err2) => {
      if (err2) return console.error("MariaDB copy error:", err2.message);
      console.log("MariaDB backup done:", fileName);
    });
  });
}

// MongoDB Backup
function backupMongo() {
  const fileName = `backup_deadIsland2${fecha()}.archive`;
  const cmd = `docker exec ${process.env.MONGO_CONTAINER} mongodump --db ${process.env.MONGO_DB} --archive=${process.env.MONGO_TEMP_FOLDER}/${fileName}`;
  const cpCmd = `docker cp ${process.env.MONGO_CONTAINER}:${process.env.MONGO_TEMP_FOLDER}/${fileName} ${process.env.MONGO_BACKUP_FOLDER}/${fileName}`;
  exec(cmd, (err) => {
    if (err) return console.error("MongoDB backup error:", err.message);
    exec(cpCmd, (err2) => {
      if (err2) return console.error("MongoDB copy error:", err2.message);
      console.log("MongoDB backup done:", fileName);
    });
  });
}

// Redis Backup (RDB snapshot, requiere que Redis esté configurado para generar dump.rdb)
function backupRedis() {
  const fileName = `dump_deadIsland2${fecha()}.rdb`;
  const cpCmd = `docker cp ${process.env.REDIS_CONTAINER}:${process.env.REDIS_TEMP_FOLDER}/dump.rdb ${process.env.REDIS_BACKUP_FOLDER}/${fileName}`;
  exec(cpCmd, (err) => {
    if (err) return console.error("Redis copy error:", err.message);
    console.log("Redis backup done:", fileName);
  });
}

// Cron job: ejecuta cada minuto (modifica como quieras)
const job = new cron.CronJob("*/1 * * * *", () => {
  console.log("Iniciando backups a las", new Date().toLocaleString());
  backupPostgres();
  backupMariaDB();
  backupMongo();
  backupRedis();
});
job.start();

console.log("Backup cron job started. Every minute backups will run.");
