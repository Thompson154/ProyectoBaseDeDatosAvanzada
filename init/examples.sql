--Pruebas para que correr 

--Funciones (Postgres)

-- Añadir la experiencia al Jugador
-- SELECT * FROM fn_add_xp(5, 2000);

-- Hacer daño al jugador
-- select fn_damage_player(1, 50);



------------------------------------------------------------------------------------------------------

--Stored Procedures (Postgres)

-- Llamar al procedimiento para atacar a un zombie
-- CALL sp_attack_zombie(5, 10, 25, 3);

-- LLamar al procedimiento para curar al jugador
-- call sp_heal_player(1, 50);

-- Llamar al procedimiento para añadir un item a su invetario
-- call sp_add_item(1, 1, 2);

-- LLamar al procedimiento para empezar una mision
-- call sp_start_mission(1, 2);

-- Llamar al procedimiento para completar una mision
-- call sp_complete_mission(1,2);

-------------------------------------------------------------------------------------------------------

--Triggers (Postgres)

--Trigger para Reducir Durabilidad
--UPDATE inventario
--SET durabilidad_actual = 15
--WHERE jugador_id = 1 AND item_id = 15;

-- Trigger para validar mapa
--INSERT INTO mapas (nombre, zona, dificultad)
--VALUES ('', 'Playa', 'Fácil');

--Trigger para actualizar mapas
--UPDATE mapas
--SET dificultad = 'Dificil'
--WHERE nombre = 'Beverly Hills Mall';

--Trigger para validar el nivel del enemigo
--INSERT INTO enemigos (nombre, tipo, nivel, vida, es_jefe, mapa_id)
--VALUES ('Zombi_Test', 'Caminante', -1, 100, FALSE, 1);

--Trigger para registar cuando se añade un nuevo jefe
--INSERT INTO jefe_zombi (enemigo_id, nombre_alias, habilidad_especial, recompensa_unica)
--VALUES (1, 'Crusher_1', 'Explosión ácida', 'Katana Dragon Rojo');
--SELECT * FROM log_jefes;

-- Trigger para actualizar la experiencia
-- UPDATE jugador_mision
-- SET estado = 'completada', fecha_fin = CURRENT_TIMESTAMP
-- WHERE jugador_id = 1271 AND mision_id = 6;
-- SELECT id, experiencia FROM jugadores WHERE id = 1271;


--- El trigger de abajo ay que probar si funciona.....  
-- -- Probar el trigger reduciendo la durabilidad de un ítem a 0
-- UPDATE inventario
-- SET durabilidad_actual = 0
-- WHERE jugador_id = 1 AND item_id = 1;

-- -- Verificar que el ítem fue eliminado del inventario
-- SELECT * FROM inventario
-- WHERE jugador_id = 1 AND item_id = 1;

-------------------------------------------------------------------------------------------------------

--Funciones (MariaDB)

--Cuanto da de experiencia un Zombie
--SELECT fn_zombie_xp(5) AS xp;

-- Calcular cuanta experiencia te la mision
--SELECT fn_calculate_mission_reward(1) AS mission_reward;

-- Ver la rareza de un item
--SELECT fn_rarity_color(1) AS color;

-- Ver la decripcion de una habilidad
--SELECT fn_skill_desc(3) AS skill_description; 


-------------------------------------------------------------------------------------------------------

--Stored Procedures (MariaDB)

-- Añadir un arma a items
-- CALL sp_add_weapon('Steel Sword', 3, 70, 90);

-- Asignar Habilidades a los Zombies
-- CALL sp_assign_ability(1, 9);

-- Crear una mission
-- CALL sp_create_mission(3, 'Rescue Mission', JSON_OBJECT('survivors', 3));

-- Ver Estadiscas de un arma
-- CALL sp_weapon_stats(2);


-------------------------------------------------------------------------------------------------------

--Triggers (MariaDB)

-- Llamar al procedimiento para otorgar recompensas eventos
-- CALL otorgar_recompensas_eventos(1, 10);

