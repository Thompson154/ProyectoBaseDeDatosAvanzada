CREATE INDEX idx_jugadores_estado ON jugadores(estado);
CREATE INDEX idx_misiones_tipo ON misiones(tipo);
CREATE INDEX idx_mapas_dificultad ON mapas(dificultad);
CREATE INDEX idx_items_tipo ON items(tipo);
CREATE INDEX idx_items_rareza ON items(rareza); 



-- PARA PROBAR EL INDEX CON EXPLAIN
-- EXPLAIN ANALYZE
-- SELECT estado, COUNT(*) AS total_jugadores
-- FROM jugadores
-- WHERE estado IN ('activo', 'inactivo')
-- GROUP BY estado
-- ORDER BY total_jugadores DESC;



-- EXPLAIN ANALYZE
-- SELECT m.id, m.titulo, m.nivel_recomendado, mp.nombre AS mapa
-- FROM misiones m
--          JOIN mapas mp ON m.mapa_id = mp.id
-- WHERE m.tipo = 'Principal'
-- ORDER BY m.nivel_recomendado DESC
-- LIMIT 50;




-- EXPLAIN ANALYZE
-- SELECT mp.dificultad, COUNT(m.id) AS total_misiones
-- FROM mapas mp
--          JOIN misiones m ON m.mapa_id = mp.id
-- GROUP BY mp.dificultad
-- ORDER BY total_misiones DESC;
