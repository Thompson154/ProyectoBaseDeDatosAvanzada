/* 1. Usuarios ---------------------------------------------------------- */
CREATE TABLE users (
    user_id    SERIAL PRIMARY KEY,
    email      VARCHAR(255) NOT NULL UNIQUE,
    username   VARCHAR(40)  NOT NULL UNIQUE,
    password   VARCHAR(60)  NOT NULL,          -- DEMO: texto plano
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

/* 2. Jugadores (1-a-1 con users) -------------------------------------- */
CREATE TABLE players (
    player_id  SERIAL PRIMARY KEY,
    user_id    INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

/* 3. Estadísticas rápidas -------------------------------------------- */
CREATE TABLE player_stats (
    player_id INTEGER PRIMARY KEY REFERENCES players(player_id) ON DELETE CASCADE,
    hp        INTEGER NOT NULL DEFAULT 100,
    stamina   INTEGER NOT NULL DEFAULT 100,
    level     INTEGER NOT NULL DEFAULT 1,
    xp        BIGINT  NOT NULL DEFAULT 0
);
CREATE INDEX idx_player_stats_rank ON player_stats (level DESC, xp DESC);

/* 4. Inventarios ------------------------------------------------------ */
CREATE TABLE inventories (
    inventory_id SERIAL PRIMARY KEY,
    player_id    INTEGER NOT NULL UNIQUE REFERENCES players(player_id) ON DELETE CASCADE,
    capacity     INTEGER NOT NULL DEFAULT 30
);

/* 5. Objetos dentro del inventario ----------------------------------- */
CREATE TABLE inventory_items (
    inventory_id INTEGER NOT NULL REFERENCES inventories(inventory_id) ON DELETE CASCADE,
    item_id      INTEGER NOT NULL,           -- catálogo en MariaDB
    quantity     INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (inventory_id, item_id)
);

/* 6. Habilidades desbloqueadas --------------------------------------- */
CREATE TABLE player_skills (
    player_id INTEGER NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    skill_id  INTEGER NOT NULL,              -- catálogo en MariaDB
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (player_id, skill_id)
);

/* 7. Sesiones de mapa ------------------------------------------------- */
CREATE TABLE map_sessions (
    session_id SERIAL PRIMARY KEY,
    map_id     INTEGER NOT NULL,             -- catálogo en MariaDB
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_night   BOOLEAN NOT NULL DEFAULT FALSE
);

/* 8. Jugadores dentro de la sesión ----------------------------------- */
CREATE TABLE map_players (
    session_id INTEGER NOT NULL REFERENCES map_sessions(session_id) ON DELETE CASCADE,
    player_id  INTEGER NOT NULL REFERENCES players(player_id)      ON DELETE CASCADE,
    joined_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    left_at    TIMESTAMPTZ,
    PRIMARY KEY (session_id, player_id)
);
CREATE INDEX idx_map_players_player ON map_players (player_id);

/* 9. Progreso de misiones -------------------------------------------- */
CREATE TABLE player_missions (
    player_id  INTEGER NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    mission_id INTEGER NOT NULL,             -- catálogo en MariaDB
    state      VARCHAR(20) NOT NULL DEFAULT 'active',
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ,
    PRIMARY KEY (player_id, mission_id)
);

/* 10. Zombis activos en cada sesión ---------------------------------- */
CREATE TABLE session_zombies (
    zombie_id  SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL REFERENCES map_sessions(session_id) ON DELETE CASCADE,
    type_id    INTEGER NOT NULL,             -- catálogo en MariaDB
    current_hp INTEGER NOT NULL,
    spawned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_enraged BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE INDEX idx_session_zombies_session ON session_zombies (session_id);
