-- Crear usuario para replicación
CREATE USER repl WITH PASSWORD 'repl123' REPLICATION;

-- Crear usuarios para los slaves
CREATE USER slave1user WITH PASSWORD 'slave1';
CREATE USER slave2user WITH PASSWORD 'slave2';

-- Otorgar permisos de solo lectura a los usuarios de los slaves
GRANT CONNECT ON DATABASE videojuego TO slave1user, slave2user;
GRANT USAGE ON SCHEMA public TO slave1user, slave2user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO slave1user, slave2user;

-- Crear slots de replicación para los slaves
SELECT pg_create_physical_replication_slot('slot_slave1');
SELECT pg_create_physical_replication_slot('slot_slave2');