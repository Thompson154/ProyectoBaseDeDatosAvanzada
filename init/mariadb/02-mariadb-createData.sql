-- /* 1. RARITIES */
INSERT INTO
    rarities (rarity_name, color_hex)
VALUES
    ('Common', '#BFBFBF'),
    ('Uncommon', '#1EFF00'),
    ('Rare', '#0070DD'),
    ('Superior', '#A335EE'),
    ('Legendary', '#FF8000');

-- /* 2. ABILITIES */
INSERT INTO
    abilities (ability_name, effect_desc)
VALUES
    ('Fast Runner', 'Moves quickly'),
    ('Acid Spit', 'Corrosive bile'),
    ('Scream Stun', 'Area stun'),
    ('Heavy Smash', 'Ground pound'),
    ('Regeneration', 'Heals limbs'),
    ('Limb Launcher', 'Bone projectiles'),
    ('Exploder', 'Self-destruct'),
    ('Fire Aura', 'Ignites area'),
    ('Electric Shock', 'Arcs of electricity'),
    ('Toxic Cloud', 'Poison gas');

-- /* 3. ZOMBIE TYPES */
INSERT INTO
    zombie_types (type_name, base_hp, base_damage, lore_text)
VALUES
    ('Walker', 100, 10, 'Shambling'),
    ('Runner', 80, 8, 'Sprinter'),
    ('Shambler', 60, 6, 'Rotten'),
    ('Crawler', 70, 7, 'Legless jumper'),
    ('Crusher', 300, 25, 'Tank'),
    ('Slobber', 220, 20, 'Bile spitter'),
    ('Screamer', 180, 0, 'Piercing scream'),
    ('Butcher', 250, 22, 'Blade arms'),
    ('Mutator', 280, 24, 'Bone spikes');

-- /* 4. ZOMBIE TYPE ↔ ABILITY  (sin NULL) */
INSERT INTO
    zombie_type_abilities (type_id, ability_id)
VALUES
    (2, 1), -- Runner → Fast Runner
    (4, 6), -- Crawler → Limb Launcher
    (5, 4), -- Crusher → Heavy Smash
    (6, 2),
    (6, 10), -- Slobber → Acid Spit + Toxic Cloud
    (7, 3), -- Screamer → Scream Stun
    (8, 5), -- Butcher → Regeneration
    (9, 6),
    (9, 8);

-- Mutator → Limb Launcher + Fire Aura
-- /* 5. SKILLS */
INSERT INTO
    skills (skill_name, description)
VALUES
    ('Block', 'Timed defense'),
    ('Dodge', 'Sidestep'),
    ('Drop Kick', 'Aerial kick'),
    ('Ground Slam', 'Jump smash'),
    ('Dash Strike', 'Forward lunge');

-- /* 6. MAPS */
INSERT INTO
    maps (map_name, max_players, has_night_cycle)
VALUES
    ('Bel-Air', 3, 1),
    ('Halperin Hotel', 3, 1),
    ('Beverly Hills', 3, 1),
    ('Monarch Studios', 3, 1),
    ('Brentwood Sewers', 3, 0),
    ('Venice Beach', 3, 1),
    ('Ocean Avenue', 3, 1),
    ('Hollywood Boulevard', 3, 1),
    ('The Metro', 3, 0),
    ('The Pier', 3, 1);

-- /* 7. MISSION TYPES */
INSERT INTO
    mission_types (type_name)
VALUES
    ('Story'),
    ('Side Quest'),
    ('Lost & Found'),
    ('Challenge');

-- /* 8. MISSIONS (10 principales) */
INSERT INTO
    missions (map_id, mission_name, target_json)
VALUES
    (
        1,
        'Flight of the Damned',
        JSON_OBJECT ('kills', 20)
    ),
    (
        1,
        'Desperately Seeking Emma',
        JSON_OBJECT ('escort', 1)
    ),
    (1, 'Bel-Air Brawl', JSON_OBJECT ('zombies', 50)),
    (2, 'Call the Cavalry', JSON_OBJECT ('signal', 1)),
    (
        2,
        'Room Service for Major Booker',
        JSON_OBJECT ('items', 5)
    ),
    (
        3,
        'The Chaperone',
        JSON_OBJECT ('find_survivor', 1)
    ),
    (
        4,
        'Michael Anders and the Holy Grail',
        JSON_OBJECT ('fetch', 3)
    ),
    (
        5,
        'Justifiable Zombicide',
        JSON_OBJECT ('slobbers', 2)
    ),
    (
        6,
        'Boardwalking Dead',
        JSON_OBJECT ('reach_pier', 1)
    ),
    (8, 'Hollywood Ending', JSON_OBJECT ('boss', 1));

-- /* 9. Story tag */
INSERT INTO
    missions_types_map (mission_id, type_id)
SELECT
    mission_id,
    1
FROM
    missions;

-- /* 10. ITEMS / WEAPONS */
INSERT INTO
    items (rarity_id, name, base_damage, max_durability)
VALUES
    (1, 'Baseball Bat', 40, 150),
    (2, 'Machete', 45, 120),
    (2, 'Hammer', 35, 180),
    (3, 'Katana', 55, 110),
    (3, 'Axe', 60, 100),
    (4, 'Cleaver', 50, 130),
    (4, 'Pistol', 35, 99999),
    (4, 'Shotgun', 90, 99999),
    (5, 'Assault Rifle', 70, 99999),
    (5, 'Legendary Golf Club', 65, 140);