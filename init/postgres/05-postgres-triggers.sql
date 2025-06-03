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