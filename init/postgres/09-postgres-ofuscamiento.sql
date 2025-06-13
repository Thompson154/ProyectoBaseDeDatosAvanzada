/* 0. Asegúrate de tener la extensión para bcrypt */
CREATE EXTENSION IF NOT EXISTS pgcrypto;

UPDATE users
SET
    username = 'Player_' || user_id,
    email    = 'anon_'   || user_id || '@example.com',
    password = crypt(password, gen_salt('bf'));
