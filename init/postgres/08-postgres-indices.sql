CREATE INDEX idx_missions_state ON player_missions(state);
CREATE INDEX idx_player_stats_rank ON player_stats (level DESC, xp DESC);
CREATE INDEX idx_session_zombies_session ON session_zombies (session_id);