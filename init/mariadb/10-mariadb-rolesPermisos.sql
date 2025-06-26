CREATE USER admin IDENTIFIED BY 'admin123';
CREATE USER gm IDENTIFIED BY 'gm123';
CREATE USER player IDENTIFIED BY 'player123';
CREATE USER reporter IDENTIFIED BY 'report123';

CREATE ROLE 'role_admin';
CREATE ROLE 'role_gm';
CREATE ROLE 'role_player';
CREATE ROLE 'role_reporter';

GRANT 'role_admin' TO 'admin'@'%';
GRANT 'role_gm' TO 'gm'@'%';
GRANT 'role_player' TO 'player'@'%';
GRANT 'role_reporter' TO 'reporter'@'%';

SET DEFAULT ROLE 'role_admin' FOR 'admin'@'%';
SET DEFAULT ROLE 'role_gm' FOR 'gm'@'%';
SET DEFAULT ROLE 'role_player' FOR 'player'@'%';
SET DEFAULT ROLE 'role_reporter' FOR 'reporter'@'%';

GRANT ALL PRIVILEGES ON videojuego.* TO 'role_admin';

GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.items TO 'role_gm';
GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.skills TO 'role_gm';
GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.maps TO 'role_gm';
GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.missions TO 'role_gm';
GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.zombie_types TO 'role_gm';
GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.abilities TO 'role_gm';
GRANT SELECT, INSERT, UPDATE, DELETE ON videojuego.missions_types_map TO 'role_gm';

GRANT SELECT ON videojuego.items TO 'role_player';
GRANT SELECT ON videojuego.skills TO 'role_player';
GRANT SELECT ON videojuego.maps TO 'role_player';
GRANT SELECT ON videojuego.missions TO 'role_player';

GRANT SELECT ON videojuego.* TO 'role_reporter';


/*
REVOKE ALL PRIVILEGES ON videojuego.* FROM 'admin'@'%';
REVOKE ALL PRIVILEGES ON videojuego.* FROM 'gm'@'%';
REVOKE ALL PRIVILEGES ON videojuego.* FROM 'player'@'%';
REVOKE ALL PRIVILEGES ON videojuego.* FROM 'reporter'@'%';
*/