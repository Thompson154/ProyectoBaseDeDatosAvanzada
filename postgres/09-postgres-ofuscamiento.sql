-- UPDATE jugadores
-- SET nombre = 'Jugador_' || id;

-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- UPDATE usuarios
-- SET 
--     correo = 'xxxxx_' || id || '@' || SPLIT_PART(correo, '@', 2), -- Agrega el id para unicidad
--     password = crypt(password, gen_salt('bf'));
    