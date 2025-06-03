----- ofuscamiento 

-- UPDATE jugadores
-- SET nombre = 'Jugador_' || id;

-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- UPDATE usuarios
-- SET 
--     correo = 'xxxxx@' || SPLIT_PART(correo, '@', 2), -- solo dominio
--     password = crypt(password, gen_salt('bf'));      -- hasheando
