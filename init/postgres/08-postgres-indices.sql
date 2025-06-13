CREATE INDEX idx_combat_player_time ON combat_logs(player_id,event_time DESC);
CREATE INDEX idx_kill_player ON kill_logs(player_id);
CREATE INDEX idx_missions_state ON player_missions(state);
CREATE INDEX idx_zombie_type ON session_zombies(type_id);
CREATE INDEX idx_inventory_item ON inventory_items(item_id);
CREATE INDEX idx_logs_target ON combat_logs(target_type,target_id);
CREATE INDEX idx_players_level ON player_stats(level DESC);
