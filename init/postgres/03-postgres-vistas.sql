/* Ranking top-10 */
CREATE VIEW v_top_players AS
SELECT u.username, ps.level, ps.xp
FROM   player_stats ps
JOIN   players      p  USING(player_id)
JOIN   users        u  ON u.user_id = p.user_id
ORDER  BY level DESC, xp DESC
LIMIT 10;

