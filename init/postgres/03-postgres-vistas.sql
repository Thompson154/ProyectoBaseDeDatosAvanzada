-- VISTAS --------------------------------------------------------------------------------
CREATE VIEW vista_misiones_completadas AS
SELECT j.nombre AS jugador, m.titulo AS mision, jm.fecha_fin
FROM jugador_mision jm
JOIN jugadores j ON jm.jugador_id = j.id
JOIN misiones m ON jm.mision_id = m.id
WHERE jm.estado = 'completada';

-- Vista 2: Inventario actual por jugador
CREATE VIEW vista_inventario_resumen AS
SELECT j.nombre AS jugador, i.nombre AS item, inv.cantidad, inv.durabilidad_actual
FROM inventario inv
JOIN jugadores j ON inv.jugador_id = j.id
JOIN items i ON inv.item_id = i.id;

-- Vista 3: Estadisticas de un jugador
CREATE VIEW vw_player_session_stats AS
SELECT
    jugador_id,
    get_player_session_count(jugador_id) AS total_sessions,
    get_player_victories(jugador_id) AS total_victories,
    ROUND(get_player_victories(jugador_id) / get_player_session_count(jugador_id) * 100, 2) AS win_rate,
    SUM(enemigos_derrotados) AS total_enemies_defeated
FROM partidas
GROUP BY jugador_id
HAVING get_player_session_count(jugador_id) > 0;