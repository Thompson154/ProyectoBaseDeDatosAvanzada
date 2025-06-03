-- Tabla misiones particionada
CREATE TABLE misiones_part (
    id SERIAL,
    titulo VARCHAR(100),
    descripcion TEXT,
    tipo VARCHAR(30),
    nivel_recomendado INT,
    recompensa TEXT,
    mapa_id INT
) PARTITION BY LIST (tipo);

-- Particiones
CREATE TABLE misiones_principales PARTITION OF misiones_part FOR VALUES IN ('principal');
CREATE TABLE misiones_secundarias PARTITION OF misiones_part FOR VALUES IN ('secundaria');
CREATE TABLE misiones_evento PARTITION OF misiones_part FOR VALUES IN ('evento');