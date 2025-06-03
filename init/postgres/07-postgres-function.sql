-- Colocar todas las FUNCIONES

-- Funcion para obtener la dificultad del mapa
CREATE OR REPLACE FUNCTION obtener_dificultad_mapa(p_id INT) RETURNS VARCHAR(20) AS $$
BEGIN
    RETURN (SELECT dificultad FROM mapas WHERE id = p_id);
END;
$$ LANGUAGE plpgsql;

-- Funcion para ver si si un mapa es dificil
CREATE OR REPLACE FUNCTION es_mapa_dificil(p_id INT) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (SELECT dificultad = 'Difícil' FROM mapas WHERE id = p_id);
END;
$$ LANGUAGE plpgsql;


