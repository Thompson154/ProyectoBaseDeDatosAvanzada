--Pruebas para que correr 

--Funciones (Postgres)

--Obtener Dificultad Mapa
--select obtener_dificultad_mapa(4);

-- Probar es_mapa_dificil
--SELECT es_mapa_dificil(2) AS es_dificil;
--SELECT es_mapa_dificil(1) AS no_dificil;

-- Probar sugerir_misiones
-- SELECT * FROM sugerir_misiones(1);

-- Contar numero de jugadores activos
-- select contar_jugadores_activos();

-- Obtener recompensa de misiones
-- SELECT obtener_recompensa_mision(4);

------------------------------------------------------------------------------------------------------

--Stored Procedures (Postgres)

-- Llamar al procedimiento para agregar un mapa
-- CALL agregar_mapa('Bosque Oscuro', 'Zona Norte', 'Medio');

-- LLamar al procedimiento para actualizar la dificultad del mapa
-- CALL actualizar_dificultad_mapa(1, 'Dificil');

-- Llamar al procedimiento para actualizar _estado_mision
-- CALL actualizar_estado_mision(1271, 1, 'fallida');

-- LLamar al procedimiento para generar enemigos en cierto mapa
-- call generar_enemigo_mapa (1);

-- Llamar al procedimiento para agregar item al inventario
-- call agregar_item_inventario(1, 5);

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

-------------------------------------------------------------------------------------------------------

--Funciones (MariaDB)



-------------------------------------------------------------------------------------------------------

--Stored Procedures (MariaDB)




-------------------------------------------------------------------------------------------------------

--Triggers (MariaDB)

-- Llamar al procedimiento para otorgar recompensas eventos
-- CALL otorgar_recompensas_eventos(1, 10);

