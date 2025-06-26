DELIMITER //

-- Crear tabla player_inventory con particionamiento por HASH en player_id
CREATE TABLE player_inventory (
    player_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    durability INT NOT NULL,
    PRIMARY KEY (player_id, item_id)
) ENGINE=InnoDB
PARTITION BY HASH (player_id) PARTITIONS 4//

DELIMITER ;