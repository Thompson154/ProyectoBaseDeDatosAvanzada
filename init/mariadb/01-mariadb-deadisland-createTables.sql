-- Usa la BD que prefieras
-- CREATE DATABASE IF NOT EXISTS game_meta CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE game_meta;

-- 1. Raridades --------------------------------------------------------------
CREATE TABLE rarities (
    rarity_id   INT AUTO_INCREMENT PRIMARY KEY,
    rarity_name VARCHAR(30) NOT NULL,
    color_hex   CHAR(7)     NOT NULL
) ENGINE=InnoDB;

-- 2. Ítems ------------------------------------------------------------------
CREATE TABLE items (
    item_id        INT AUTO_INCREMENT PRIMARY KEY,
    rarity_id      INT NOT NULL,
    name           VARCHAR(60) NOT NULL,
    base_damage    INT NOT NULL,
    max_durability INT NOT NULL,
    FOREIGN KEY (rarity_id) REFERENCES rarities(rarity_id)
) ENGINE=InnoDB;

-- 3. Habilidades ------------------------------------------------------------
CREATE TABLE skills (
    skill_id    INT AUTO_INCREMENT PRIMARY KEY,
    skill_name  VARCHAR(60) NOT NULL,
    description TEXT
) ENGINE=InnoDB;

-- 4. Mapas ------------------------------------------------------------------
CREATE TABLE maps (
    map_id          INT AUTO_INCREMENT PRIMARY KEY,
    map_name        VARCHAR(60) NOT NULL,
    max_players     INT NOT NULL DEFAULT 3,
    has_night_cycle TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- 5. Tipos de misión --------------------------------------------------------
CREATE TABLE mission_types (
    type_id   INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

-- 6. Misiones ---------------------------------------------------------------
CREATE TABLE missions (
    mission_id   INT AUTO_INCREMENT PRIMARY KEY,
    map_id       INT  NOT NULL,
    mission_name VARCHAR(80) NOT NULL,
    target_json  JSON,
    FOREIGN KEY (map_id) REFERENCES maps(map_id)
) ENGINE=InnoDB;

-- 7. Relación misión ↔ tipo (N:M) ------------------------------------------
CREATE TABLE missions_types_map (
    mission_id INT NOT NULL,
    type_id    INT NOT NULL,
    PRIMARY KEY (mission_id, type_id),
    FOREIGN KEY (mission_id) REFERENCES missions(mission_id)       ON DELETE CASCADE,
    FOREIGN KEY (type_id)    REFERENCES mission_types(type_id)     ON DELETE CASCADE
) ENGINE=InnoDB;

/* ---------- ZOMBIES & HABILITIES: catálogos ---------- */

/* 8. Habilidades (“abilities”) ------------------------- */
CREATE TABLE abilities (
    ability_id   INT AUTO_INCREMENT PRIMARY KEY,
    ability_name VARCHAR(60) NOT NULL,
    effect_desc  TEXT
) ENGINE=InnoDB;

/* 9. Tipos de zombi (“zombie_types”) ------------------- */
CREATE TABLE zombie_types (
    type_id      INT AUTO_INCREMENT PRIMARY KEY,
    type_name    VARCHAR(60) NOT NULL,
    base_hp      INT NOT NULL,
    base_damage  INT NOT NULL,
    lore_text    TEXT
) ENGINE=InnoDB;

/* 10. Relación N:M tipo-zombi ↔ habilidad ------------- */
CREATE TABLE zombie_type_abilities (
    type_id    INT NOT NULL,
    ability_id INT NOT NULL,
    PRIMARY KEY (type_id, ability_id),
    FOREIGN KEY (type_id)    REFERENCES zombie_types(type_id) ON DELETE CASCADE,
    FOREIGN KEY (ability_id) REFERENCES abilities(ability_id) ON DELETE CASCADE
) ENGINE=InnoDB;
