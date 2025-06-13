/* Ranking top-10 */
CREATE VIEW v_top_players AS
SELECT u.username, ps.level, ps.xp
FROM   player_stats ps
JOIN   players      p  USING(player_id)
JOIN   users        u  ON u.user_id = p.user_id
ORDER  BY level DESC, xp DESC
LIMIT 10;

/* Kills por tipo de zombi */
CREATE VIEW v_kills_by_type AS
SELECT zombie_type, COUNT(*) kills
FROM   kill_logs
GROUP  BY zombie_type;

/* Usuarios con e-mail oculto */
CREATE VIEW v_users_masked AS
SELECT user_id, fn_mask_email(email) AS email_masked, username, created_at
FROM   users;
