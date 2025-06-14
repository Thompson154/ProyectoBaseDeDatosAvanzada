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

