-- Crear usuario para replicación
CREATE USER IF NOT EXISTS 'replicador'@'%' IDENTIFIED BY 'miClaveSegura';
GRANT REPLICATION SLAVE ON *.* TO 'replicador'@'%';
FLUSH PRIVILEGES;

-- Asegurarse de que binlog esté activo
SHOW MASTER STATUS;