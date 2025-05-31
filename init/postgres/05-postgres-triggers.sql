-- ACA CARGAR LOS TRIGGERS ---------------------------------------------------------------------

-- -- Función para reducir durabilidad
-- CREATE OR REPLACE FUNCTION reducir_durabilidad()
-- RETURNS TRIGGER AS $$
-- BEGIN
--   IF NEW.durabilidad_actual IS NOT NULL AND NEW.durabilidad_actual < OLD.durabilidad_actual THEN
--     RAISE NOTICE 'Durabilidad reducida en jugador %, item %', NEW.jugador_id, NEW.item_id;
--   END IF;
--   RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- -- Trigger que ejecuta la función
-- CREATE TRIGGER trigger_usar_item
-- BEFORE UPDATE ON inventario
-- FOR EACH ROW
-- EXECUTE FUNCTION reducir_durabilidad();