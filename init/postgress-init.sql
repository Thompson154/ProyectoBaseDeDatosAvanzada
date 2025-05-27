init_sql = """
-- Crear tabla de jugadores
CREATE TABLE jugadores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nivel INTEGER DEFAULT 1,
    clase VARCHAR(30),
    experiencia INTEGER DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de mapas
CREATE TABLE mapas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    dificultad VARCHAR(20),
    descripcion TEXT
);

-- Crear tabla de enemigos
CREATE TABLE enemigos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(30),
    nivel INTEGER,
    vida INTEGER,
    ubicacion_inicial VARCHAR(100),
    es_jefe BOOLEAN DEFAULT FALSE,
    mapa_id INTEGER REFERENCES mapas(id)
);

-- Crear tabla de misiones
CREATE TABLE misiones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    descripcion TEXT,
    tipo VARCHAR(30),
    nivel_recomendado INTEGER,
    recompensa VARCHAR(100),
    es_repetible BOOLEAN DEFAULT FALSE,
    mapa_id INTEGER REFERENCES mapas(id)
);

-- Relación muchos a muchos: jugador ↔ misión
CREATE TABLE jugador_mision (
    jugador_id INTEGER REFERENCES jugadores(id),
    mision_id INTEGER REFERENCES misiones(id),
    estado VARCHAR(20),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    PRIMARY KEY (jugador_id, mision_id)
);

-- Crear tabla de ítems
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(30),
    rareza VARCHAR(20),
    descripcion TEXT
);

-- Relación muchos a muchos: enemigo ↔ ítem (drop)
CREATE TABLE enemigo_item_drop (
    enemigo_id INTEGER REFERENCES enemigos(id),
    item_id INTEGER REFERENCES items(id),
    probabilidad_drop DECIMAL(5,2) CHECK (probabilidad_drop BETWEEN 0 AND 100),
    PRIMARY KEY (enemigo_id, item_id)
);

-- Relación muchos a muchos: jugador ↔ ítem (inventario)
CREATE TABLE jugador_item (
    jugador_id INTEGER REFERENCES jugadores(id),
    item_id INTEGER REFERENCES items(id),
    cantidad INTEGER DEFAULT 1,
    durabilidad_actual INTEGER,
    PRIMARY KEY (jugador_id, item_id)
);
"""


init_sql_path = "/mnt/data/postgres-init.sql"
with open(init_sql_path, "w") as sql_file:
    sql_file.write(init_sql)

init_sql_path



init_sql = """
-- Crear tabla de jugadores
CREATE TABLE jugadores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nivel INTEGER DEFAULT 1,
    clase VARCHAR(30),
    experiencia INTEGER DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de mapas
CREATE TABLE mapas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    dificultad VARCHAR(20),
    descripcion TEXT
);

-- Crear tabla de enemigos
CREATE TABLE enemigos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(30),
    nivel INTEGER,
    vida INTEGER,
    ubicacion_inicial VARCHAR(100),
    es_jefe BOOLEAN DEFAULT FALSE,
    mapa_id INTEGER REFERENCES mapas(id)
);

-- Crear tabla de misiones
CREATE TABLE misiones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    descripcion TEXT,
    tipo VARCHAR(30),
    nivel_recomendado INTEGER,
    recompensa VARCHAR(100),
    es_repetible BOOLEAN DEFAULT FALSE,
    mapa_id INTEGER REFERENCES mapas(id)
);

-- Relación muchos a muchos: jugador ↔ misión
CREATE TABLE jugador_mision (
    jugador_id INTEGER REFERENCES jugadores(id),
    mision_id INTEGER REFERENCES misiones(id),
    estado VARCHAR(20),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    PRIMARY KEY (jugador_id, mision_id)
);

-- Crear tabla de ítems
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(30),
    rareza VARCHAR(20),
    descripcion TEXT
);

-- Relación muchos a muchos: enemigo ↔ ítem (drop)
CREATE TABLE enemigo_item_drop (
    enemigo_id INTEGER REFERENCES enemigos(id),
    item_id INTEGER REFERENCES items(id),
    probabilidad_drop DECIMAL(5,2) CHECK (probabilidad_drop BETWEEN 0 AND 100),
    PRIMARY KEY (enemigo_id, item_id)
);

-- Relación muchos a muchos: jugador ↔ ítem (inventario)
CREATE TABLE jugador_item (
    jugador_id INTEGER REFERENCES jugadores(id),
    item_id INTEGER REFERENCES items(id),
    cantidad INTEGER DEFAULT 1,
    durabilidad_actual INTEGER,
    PRIMARY KEY (jugador_id, item_id)
);
"""


init_sql_path = "/mnt/data/postgres-init.sql"
with open(init_sql_path, "w") as f:
    f.write(init_sql)

init_sql_path
