-- ACA CARGAR LOS TRIGGERS ---------------------------------------------------------------------

--Trigger para ver la durabilidad del arma 
CREATE OR REPLACE FUNCTION reducir_durabilidad()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.durabilidad_actual <= OLD.durabilidad_actual AND NEW.durabilidad_actual < 20 THEN
        RAISE NOTICE 'Advertencia: La durabilidad del ítem % para el jugador % está baja (%).', NEW.item_id, NEW.jugador_id, NEW.durabilidad_actual;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER trigger_reducir_durabilidad
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

-- Validar el nivel del enemigo
CREATE OR REPLACE FUNCTION validar_nivel_enemigo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nivel < 0 THEN
        RAISE EXCEPTION 'El nivel del enemigo no puede ser negativo';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_nivel_enemigo
BEFORE INSERT ON enemigos
FOR EACH ROW
EXECUTE FUNCTION validar_nivel_enemigo();

-- Trigger para registrar un nuevo tipo de jefe
CREATE TABLE log_jefes (
    id SERIAL PRIMARY KEY,
    jefe_id INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (jefe_id) REFERENCES jefe_zombi(id)
);


CREATE OR REPLACE FUNCTION log_nuevo_jefe()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_jefes (jefe_id)
    VALUES (NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_nuevo_jefe
AFTER INSERT ON jefe_zombi
FOR EACH ROW
EXECUTE FUNCTION log_nuevo_jefe();

--Trigger para actualizar la experiencia

CREATE OR REPLACE FUNCTION actualizar_experiencia()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'completada' AND OLD.estado != 'completada' THEN
        UPDATE jugadores
        SET experiencia = experiencia + 100
        WHERE id = NEW.jugador_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_experiencia
AFTER UPDATE ON jugador_mision
FOR EACH ROW
EXECUTE FUNCTION actualizar_experiencia();

