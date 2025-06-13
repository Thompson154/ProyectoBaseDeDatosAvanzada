-- Vista 3: Eventos Activos
CREATE OR REPLACE VIEW vista_eventos_activos AS
SELECT 
    e.id AS evento_id,
    e.nombre_evento,
    e.tipo_evento,
    e.fecha_inicio,
    e.fecha_fin,
    r.jugador_id,
    r.recompensa
FROM eventos_zombi e
LEFT JOIN recompensa_evento r ON e.id = r.evento_id
WHERE e.activo = TRUE;