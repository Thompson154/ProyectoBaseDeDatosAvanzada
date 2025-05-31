INSERT INTO items (nombre, tipo, rareza, durabilidad_max) VALUES
('Brass Knuckles', 'arma cuerpo a cuerpo', 'común', 100),
('Fire Axe', 'arma cuerpo a cuerpo', 'raro', 120),
('Baseball Bat', 'arma cuerpo a cuerpo', 'poco común', 95),
('Claymore', 'arma cuerpo a cuerpo', 'legendario', 150),
('Military Knife', 'arma cuerpo a cuerpo', 'común', 85),
('Katana', 'arma cuerpo a cuerpo', 'legendario', 145),
('Meat Mallet', 'arma contundente', 'común', 92),
('Mace', 'arma contundente', 'raro', 112),
('Shovel', 'arma improvisada', 'poco común', 88),
('Electrocutor Sword', 'arma modificada', 'legendario', 160),
('Zombie Claw', 'arma especial', 'único', 200),
('Brass Knuckles', 'arma cuerpo a cuerpo', 'raro', 105),
('Fire Axe', 'arma cuerpo a cuerpo', 'legendario', 130),
('Baseball Bat', 'arma cuerpo a cuerpo', 'común', 90),
('Claymore', 'arma cuerpo a cuerpo', 'épico', 155),
('Military Knife', 'arma cuerpo a cuerpo', 'raro', 95),
('Katana v2', 'arma cuerpo a cuerpo', 'único', 148),
('Meat Mallet', 'arma contundente', 'poco común', 98),
('Mace', 'arma contundente', 'épico', 118),
('Shovel', 'arma improvisada', 'común', 82),
('Electrocutor Sword', 'arma modificada', 'épico', 165),
('Zombie Claw', 'arma especial', 'único', 210),
('Brass Knuckles', 'arma cuerpo a cuerpo', 'épico', 110),
('Fire Axe', 'arma cuerpo a cuerpo', 'poco común', 125),
('Baseball Bat', 'arma cuerpo a cuerpo', 'raro', 92),
('Claymore', 'arma cuerpo a cuerpo', 'único', 160),
('Military Knife', 'arma cuerpo a cuerpo', 'épico', 90),
('Katana', 'arma cuerpo a cuerpo', 'épico', 150),
('Meat Mallet', 'arma contundente', 'raro', 100),
('Mace', 'arma contundente', 'legendario', 115),
('Shovel', 'arma improvisada', 'raro', 86),
('Electrocutor Sword', 'arma modificada', 'único', 170),
('Zombie Claw', 'arma especial', 'épico', 220);

-- Generar 1000 Jugadores
INSERT INTO jugadores (nombre, clase, experiencia, nivel, estado)
SELECT
    'Player_' || generate_series(1, 1000) AS nombre,
    CASE (generate_series % 3)
        WHEN 0 THEN 'Guerrero'
        WHEN 1 THEN 'Cazador'
        ELSE 'Médico'
    END AS clase,
    FLOOR(RANDOM() * 10000)::INT AS experiencia,
    FLOOR(RANDOM() * 10 + 1)::INT AS nivel,
    CASE WHEN RANDOM() < 0.9 THEN 'activo' ELSE 'inactivo' END AS estado
FROM generate_series(1, 1000);


--Generar los mapas
INSERT INTO mapas (nombre, zona, dificultad) VALUES
  ('Beverly Hills Mall', 'Ciudad', 'Difícil'),
  ('Muelle de Ocean Avenue', 'Playa', 'Normal'),
  ('Sewers de Downtown LA', 'Zona Industrial', 'Difícil'),
  ('Parque Griffith', 'Selva', 'Normal'),
  ('Mansión de Monarch Studios', 'Suburbio', 'Fácil'),
  ('Cementerio de Hollywood', 'Ciudad', 'Normal'),
  ('Canales de Venice', 'Playa', 'Fácil'),
  ('Estadio de LA', 'Zona Industrial', 'Difícil'),
  ('Barrio de Silver Lake', 'Suburbio', 'Normal'),
  ('Puerto de Long Beach', 'Zona Industrial', 'Fácil');


--Generar Enemigos
INSERT INTO enemigos(nombre, tipo, nivel, vida, es_jefe, mapa_id)
SELECT
    'Zombi_' || generate_series(1, 500) AS nombre,
    CASE (generate_series % 7)
        WHEN 0 THEN 'Caminante'
        WHEN 1 THEN 'Corredor'
        WHEN 2 THEN 'Mutante'
        WHEN 3 THEN 'Caminante Fuego'
        WHEN 4 THEN 'Chillona Electrica'
        WHEN 5 THEN 'Carnicero'
        WHEN 6 THEN 'Ahogado con Parasitos'
        ELSE 'Jefe'
    END AS tipo,
    FLOOR(RANDOM() * 10 + 1)::INT AS nivel,
    FLOOR(RANDOM() * 500 + 100)::INT AS vida,
    CASE WHEN generate_series % 50 = 0 THEN TRUE ELSE FALSE END AS es_jefe,
    FLOOR(RANDOM() * 50 + 1)::INT AS mapa_id
FROM generate_series(1, 500);

-- Agregando datos de items a jugadores en la tabla de inventario
CREATE OR REPLACE PROCEDURE asignar_items_a_jugadores()
LANGUAGE plpgsql
AS $$
DECLARE
  i INT := 1;
  jugador_id INT;
  item_id INT;
BEGIN
  FOR jugador_id IN 1..3 LOOP
    FOR i IN 1..30 LOOP
      item_id := FLOOR(1 + random() * 11); -- IDs del 1 al 11
      BEGIN
        INSERT INTO inventario (jugador_id, item_id, cantidad, durabilidad_actual)
        VALUES (jugador_id, item_id, 1, 100);
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Error al insertar item %, jugador %', item_id, jugador_id;
        ROLLBACK;
        RETURN;
      END;
    END LOOP;
  END LOOP;
END;
$$;

-- Ejecutar procedimiento
CALL asignar_items_a_jugadores();
