-- ACA CARGAR LOS TRIGGERS ---------------------------------------------------------------------

-- Función para reducir durabilidad
CREATE OR REPLACE FUNCTION reducir_durabilidad() -- Probar que funcione
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.durabilidad_actual IS NOT NULL AND NEW.durabilidad_actual < OLD.durabilidad_actual THEN
    RAISE NOTICE 'Durabilidad reducida en jugador %, item %', NEW.jugador_id, NEW.item_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que ejecuta la función
CREATE TRIGGER trigger_usar_item
BEFORE UPDATE ON inventario
FOR EACH ROW
EXECUTE FUNCTION reducir_durabilidad();


-- Validacion si el nombre de algun mapa no este vacio
CREATE OR REPLACE FUNCTION validar_nombre_mapa() RETURNS TRIGGER AS $$
BEGIN
    IF TRIM(NEW.nombre) = '' THEN
        RAISE EXCEPTION 'El nombre del mapa no puede estar vacío';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_mapa_insert
BEFORE INSERT ON mapas
FOR EACH ROW
EXECUTE FUNCTION validar_nombre_mapa();

-- Dejar mensaje cuando se actualice un mapa
CREATE OR REPLACE FUNCTION log_actualizacion_mapa() RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Mapa % actualizado a dificultad %', OLD.nombre, NEW.dificultad;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_mapa_update
AFTER UPDATE ON mapas
FOR EACH ROW
EXECUTE FUNCTION log_actualizacion_mapa();

-- Tabla del trigger 4
CREATE TABLE log_jugador_mision (
    id SERIAL PRIMARY KEY,
    jugador_id INT NOT NULL,
    mision_id INT NOT NULL,
    accion VARCHAR(20) NOT NULL CHECK (accion IN ('INSERT', 'UPDATE')),
    estado_anterior VARCHAR(20),
    estado_nuevo VARCHAR(20),
    fecha_inicio_anterior TIMESTAMP,
    fecha_inicio_nueva TIMESTAMP,
    fecha_fin_anterior TIMESTAMP,
    fecha_fin_nueva TIMESTAMP,
    fecha_registro TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (jugador_id) REFERENCES jugadores(id),
    FOREIGN KEY (mision_id) REFERENCES misiones(id)
);


-- trigger 4 
CREATE OR REPLACE FUNCTION fn_jugador_mision_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado NOT IN ('en progreso', 'completada', 'fallida') THEN
        RAISE EXCEPTION 'Estado inválido en jugador_mision. Debe ser: en progreso, completada o fallida.';
    END IF;

    INSERT INTO log_jugador_mision (
        jugador_id, 
        mision_id, 
        accion, 
        estado_anterior, 
        estado_nuevo, 
        fecha_inicio_anterior, 
        fecha_inicio_nueva, 
        fecha_fin_anterior, 
        fecha_fin_nueva
    )
    VALUES (
        OLD.jugador_id,
        OLD.mision_id,
        'UPDATE',
        OLD.estado,
        NEW.estado,
        OLD.fecha_inicio,
        NEW.fecha_inicio,
        OLD.fecha_fin,
        NEW.fecha_fin
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create or replace trigger trg_fn_jugador_mision_changes
after update on jugador_mision
for each row
execute function fn_jugador_mision_changes();