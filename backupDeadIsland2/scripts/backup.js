const cron = require("cron");
const { exec } = require("child_process");
require("dotenv").config();
const fs = require("fs");

// Validar que todas las variables necesarias estén presentes
function verificarVariables(entornosRequeridos) {
  const faltantes = entornosRequeridos.filter((envVar) => !process.env[envVar]);
  if (faltantes.length > 0) {
    console.error("❌ Faltan variables de entorno en el archivo .env:");
    faltantes.forEach((v) => console.error(`  - ${v}`));
    process.exit(1); // Termina la ejecución del script
  }
}

verificarVariables([
  "PG_CONTAINER", "PG_USER", "PG_DB", "PG_TEMP_FOLDER", "PG_BACKUP_FOLDER",
  "MARIADB_CONTAINER", "MARIADB_USER", "MARIADB_PASSWORD", "MARIADB_DB",
  "MARIADB_TEMP_FOLDER", "MARIADB_BACKUP_FOLDER",
  "MARIADB_MASTER_CONTAINER", "MARIADB_MASTER_USER", "MARIADB_MASTER_PASSWORD", "MARIADB_MASTER_DB", "MARIADB_MASTER_TEMP_FOLDER", "MARIADB_MASTER_BACKUP_FOLDER",
  "MARIADB_SLAVE1_CONTAINER", "MARIADB_SLAVE1_USER", "MARIADB_SLAVE1_PASSWORD", "MARIADB_SLAVE1_DB", "MARIADB_SLAVE1_TEMP_FOLDER", "MARIADB_SLAVE1_BACKUP_FOLDER",
  "MARIADB_SLAVE2_CONTAINER", "MARIADB_SLAVE2_USER", "MARIADB_SLAVE2_PASSWORD", "MARIADB_SLAVE2_DB", "MARIADB_SLAVE2_TEMP_FOLDER", "MARIADB_SLAVE2_BACKUP_FOLDER",
  "MONGO_CONTAINER", "MONGO_DB", "MONGO_TEMP_FOLDER", "MONGO_BACKUP_FOLDER",
  "REDIS_CONTAINER", "REDIS_TEMP_FOLDER", "REDIS_BACKUP_FOLDER"
]);

// Crear carpetas de backup si no existen
[
  process.env.PG_BACKUP_FOLDER,
  process.env.MARIADB_BACKUP_FOLDER,
  process.env.MARIADB_MASTER_BACKUP_FOLDER,
  process.env.MARIADB_SLAVE1_BACKUP_FOLDER,
  process.env.MARIADB_SLAVE2_BACKUP_FOLDER,
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

// MariaDB Master Backup
function backupMariaDBMaster() {
  const fileName = `backup_master_${fecha()}.sql`;
  const cmd = `docker exec ${process.env.MARIADB_MASTER_CONTAINER} sh -c "mysqldump -u${process.env.MARIADB_MASTER_USER} -p${process.env.MARIADB_MASTER_PASSWORD} ${process.env.MARIADB_MASTER_DB} > ${process.env.MARIADB_MASTER_TEMP_FOLDER}/${fileName}"`;
  const cpCmd = `docker cp ${process.env.MARIADB_MASTER_CONTAINER}:${process.env.MARIADB_MASTER_TEMP_FOLDER}/${fileName} ${process.env.MARIADB_MASTER_BACKUP_FOLDER}/${fileName}`;
  exec(cmd, (err) => {
    if (err) return console.error("MariaDB Master backup error:", err.message);
    exec(cpCmd, (err2) => {
      if (err2) return console.error("MariaDB Master copy error:", err2.message);
      console.log("MariaDB Master backup done:", fileName);
    });
  });
}

// MariaDB Slave1 Backup
function backupMariaDBSlave1() {
  const fileName = `backup_slave1_${fecha()}.sql`;
  const cmd = `docker exec ${process.env.MARIADB_SLAVE1_CONTAINER} sh -c "mysqldump -u${process.env.MARIADB_SLAVE1_USER} -p${process.env.MARIADB_SLAVE1_PASSWORD} ${process.env.MARIADB_SLAVE1_DB} > ${process.env.MARIADB_SLAVE1_TEMP_FOLDER}/${fileName}"`;
  const cpCmd = `docker cp ${process.env.MARIADB_SLAVE1_CONTAINER}:${process.env.MARIADB_SLAVE1_TEMP_FOLDER}/${fileName} ${process.env.MARIADB_SLAVE1_BACKUP_FOLDER}/${fileName}`;
  exec(cmd, (err) => {
    if (err) return console.error("MariaDB Slave1 backup error:", err.message);
    exec(cpCmd, (err2) => {
      if (err2) return console.error("MariaDB Slave1 copy error:", err2.message);
      console.log("MariaDB Slave1 backup done:", fileName);
    });
  });
}

// MariaDB Slave2 Backup
function backupMariaDBSlave2() {
  const fileName = `backup_slave2_${fecha()}.sql`;
  const cmd = `docker exec ${process.env.MARIADB_SLAVE2_CONTAINER} sh -c "mysqldump -u${process.env.MARIADB_SLAVE2_USER} -p${process.env.MARIADB_SLAVE2_PASSWORD} ${process.env.MARIADB_SLAVE2_DB} > ${process.env.MARIADB_SLAVE2_TEMP_FOLDER}/${fileName}"`;
  const cpCmd = `docker cp ${process.env.MARIADB_SLAVE2_CONTAINER}:${process.env.MARIADB_SLAVE2_TEMP_FOLDER}/${fileName} ${process.env.MARIADB_SLAVE2_BACKUP_FOLDER}/${fileName}`;
  exec(cmd, (err) => {
    if (err) return console.error("MariaDB Slave2 backup error:", err.message);
    exec(cpCmd, (err2) => {
      if (err2) return console.error("MariaDB Slave2 copy error:", err2.message);
      console.log("MariaDB Slave2 backup done:", fileName);
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

// Redis Backup falta q haga el snapshot ojito
function backupRedis() {
  const fileName = `dump_deadIsland2${fecha()}.rdb`;
  const cpCmd = `docker cp ${process.env.REDIS_CONTAINER}:${process.env.REDIS_TEMP_FOLDER}/dump.rdb ${process.env.REDIS_BACKUP_FOLDER}/${fileName}`;
  exec(cpCmd, (err) => {
    if (err) return console.error("Redis copy error:", err.message);
    console.log("Redis backup done:", fileName);
  });
}

const job = new cron.CronJob("*/1 * * * *", () => {
  console.log("Iniciando backups a las", new Date().toLocaleString());
  backupPostgres();
  backupMariaDB();
  backupMariaDBMaster();
  backupMariaDBSlave1();
  backupMariaDBSlave2();
  backupMongo();
  backupRedis();
});
job.start();

console.log("Backup cron job started. Every minute backups will run.");
