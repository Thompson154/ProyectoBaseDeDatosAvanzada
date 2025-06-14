
-- PostgreSQL - Dead Island 2 - Tablas estructurales con relaciones integradas



CREATE TABLE jugadores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nivel INT DEFAULT 1,
    clase VARCHAR(30),
    experiencia INT DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Lo de abajo se borra si no funciona la prueba
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    jugador_id INT UNIQUE REFERENCES jugadores(id) ON DELETE CASCADE,
    username VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    password TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
----Lo de arriba es prueba si no funciona se borra


CREATE TABLE mapas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    zona VARCHAR(50),
    dificultad VARCHAR(20)
);

CREATE TABLE enemigos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(30),
    nivel INT,
    vida INT,
    es_jefe BOOLEAN DEFAULT FALSE,
    mapa_id INT REFERENCES mapas(id)
);

CREATE TABLE jefe_zombi (
    id SERIAL PRIMARY KEY,
    enemigo_id INT REFERENCES enemigos(id),
    nombre_alias VARCHAR(50),
    habilidad_especial TEXT,
    recompensa_unica TEXT
);

CREATE TABLE misiones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    descripcion TEXT,
    tipo VARCHAR(30),
    nivel_recomendado INT,
    recompensa TEXT,
    mapa_id INT REFERENCES mapas(id)
);

-- Es como un logs de las misiones que hizo el jugador, TABLA LOG
CREATE TABLE jugador_mision (
    jugador_id INT REFERENCES jugadores(id),
    mision_id INT REFERENCES misiones(id),
    estado VARCHAR(20),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    PRIMARY KEY (jugador_id, mision_id)
);

CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(30),
    rareza VARCHAR(20),
    durabilidad_max INT
);

CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    jugador_id INT REFERENCES jugadores(id),
    item_id INT REFERENCES items(id),
    cantidad INT DEFAULT 1,
    durabilidad_actual INT
);