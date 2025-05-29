
-- MariaDB - Dead Island 2 - Tablas transaccionales (sin referencias a tablas externas)

CREATE TABLE partidas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    resultado VARCHAR(20),
    enemigos_derrotados INT
    -- FOREIGN KEY eliminado: jugadores está en PostgreSQL
);

CREATE TABLE log_combate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT,
    enemigo_id INT,
    accion VARCHAR(50),
    valor INT,
    momento DATETIME DEFAULT CURRENT_TIMESTAMP
    -- FOREIGN KEY eliminado: jugadores y enemigos están en PostgreSQL
);

CREATE TABLE eventos_zombi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_evento VARCHAR(100),
    tipo_evento VARCHAR(30),
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE drops (
    enemigo_id INT,
    item_id INT,
    probabilidad DECIMAL(5,2),
    PRIMARY KEY (enemigo_id, item_id)
    -- FOREIGN KEY eliminado: enemigos e items están en PostgreSQL
);

CREATE TABLE progreso_habilidad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT,
    habilidad VARCHAR(50),
    nivel INT DEFAULT 1,
    experiencia INT DEFAULT 0,
    ultima_actualizacion DATETIME
    -- FOREIGN KEY eliminado: jugadores está en PostgreSQL
);

CREATE TABLE recompensa_evento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT,
    jugador_id INT,
    recompensa TEXT,
    fecha_entrega DATETIME,
    FOREIGN KEY (evento_id) REFERENCES eventos_zombi(id)
    -- jugador_id sin FK: jugadores está en PostgreSQL
);
