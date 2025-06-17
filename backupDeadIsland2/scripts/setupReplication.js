const mysql = require('mysql2/promise');
require('dotenv').config();

async function configureReplication() {
  const masterHost = 'mariadb-master';
  const slaveHosts = ['mariadb-slave1', 'mariadb-slave2'];

  const replUser = process.env.MYSQL_REPL_USER;
  const replPassword = process.env.MYSQL_REPL_PASSWORD;

  // Conexión al master con su contraseña específica
  const masterConn = await mysql.createConnection({
    host: masterHost,
    user: 'root',
    password: process.env.MARIADB_MASTER_ROOT_PASSWORD,
  });

  const [rows] = await masterConn.execute('SHOW MASTER STATUS');
  const logFile = rows[0].File;
  const logPos = rows[0].Position;

  for (const slaveHost of slaveHosts) {
    let slaveRootPassword;
    if (slaveHost === 'mariadb-slave1') {
      slaveRootPassword = process.env.MARIADB_SLAVE1_ROOT_PASSWORD;
    } else if (slaveHost === 'mariadb-slave2') {
      slaveRootPassword = process.env.MARIADB_SLAVE2_ROOT_PASSWORD;
    }

    const slaveConn = await mysql.createConnection({
      host: slaveHost,
      user: 'root',
      password: slaveRootPassword,
    });

    await slaveConn.execute('STOP SLAVE');
    await slaveConn.execute(`
      CHANGE MASTER TO
        MASTER_HOST='${masterHost}',
        MASTER_USER='${replUser}',
        MASTER_PASSWORD='${replPassword}',
        MASTER_LOG_FILE='${logFile}',
        MASTER_LOG_POS=${logPos},
        GET_MASTER_PUBLIC_KEY=1;
    `);
    await slaveConn.execute('START SLAVE');
    await slaveConn.end();
  }

  await masterConn.end();

  console.log('Replicación configurada con éxito.');
}

configureReplication().catch(console.error);