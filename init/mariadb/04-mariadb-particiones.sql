/* Cambios a catálogos */
CREATE TABLE item_change_log (
  change_id  BIGINT AUTO_INCREMENT PRIMARY KEY,
  item_id    INT,
  old_damage INT,
  new_damage INT,
  changed_at DATETIME DEFAULT NOW()
) ENGINE=InnoDB;

/* Hash-partition de misiones por map_id */
ALTER TABLE missions
PARTITION BY HASH(map_id) PARTITIONS 8;
