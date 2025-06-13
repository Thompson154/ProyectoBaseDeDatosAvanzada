-- Crear tabla eventos_zombi primero (no tiene dependencias)
CREATE TABLE eventos_zombi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_evento VARCHAR(100),
    tipo_evento VARCHAR(30),
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    activo BOOLEAN DEFAULT TRUE
);

-- Crear tabla partidas (depende de eventos_zombi)
CREATE TABLE partidas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT, -- Para unir con la tabla jugadores en PostgreSQL (en Big Data)
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    resultado VARCHAR(20),
    enemigos_derrotados INT,
    evento_id INT, -- Relación con eventos_zombi
    FOREIGN KEY (evento_id) REFERENCES eventos_zombi(id)
);

-- Crear tabla log_combate (depende de partidas)
CREATE TABLE log_combate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT, -- Para unir con la tabla jugadores en PostgreSQL (en Big Data)
    enemigo_id INT, -- Para unir con la tabla enemigos en PostgreSQL (en Big Data)
    accion VARCHAR(50),
    valor INT,
    momento DATETIME DEFAULT CURRENT_TIMESTAMP,
    partida_id INT,
    FOREIGN KEY (partida_id) REFERENCES partidas(id) -- Relación interna con partidas
);

-- Crear tabla drops (depende de eventos_zombi)
CREATE TABLE drops (
    enemigo_id INT, -- Para unir con la tabla enemigos en PostgreSQL (en Big Data)
    item_id INT, -- Para unir con la tabla items en PostgreSQL (en Big Data)
    probabilidad DECIMAL(5,2),
    evento_id INT, -- Relación con eventos_zombi para recompensas especiales
    PRIMARY KEY (enemigo_id, item_id),
    FOREIGN KEY (evento_id) REFERENCES eventos_zombi(id)
);

-- Crear tabla progreso_habilidad (depende de partidas)
CREATE TABLE progreso_habilidad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id INT, -- Para unir con la tabla jugadores en PostgreSQL (en Big Data)
    habilidad VARCHAR(50),
    nivel INT DEFAULT 1,
    experiencia INT DEFAULT 0,
    ultima_actualizacion DATETIME,
    partida_id INT, -- Relación con partidas para desbloqueo de habilidades
    FOREIGN KEY (partida_id) REFERENCES partidas(id)
);

-- Crear tabla recompensa_evento (depende de eventos_zombi)
CREATE TABLE recompensa_evento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT,
    jugador_id INT, -- Para unir con la tabla jugadores en PostgreSQL (en Big Data)
    recompensa TEXT,
    fecha_entrega DATETIME,
    FOREIGN KEY (evento_id) REFERENCES eventos_zombi(id) -- Relación interna con eventos_zombi
);