-- Tabla misiones particionada
CREATE TABLE mapas_particionada(
    id SERIAL,
    nombre VARCHAR(50) NOT NULL,
    zona VARCHAR(50),
    dificultad VARCHAR(20) NOT NULL,
    PRIMARY KEY (id, dificultad)
) PARTITION BY LIST (dificultad);

-- Particiones
CREATE TABLE mapas_dificiles PARTITION OF mapas_particionada FOR VALUES IN ('Difícil');
CREATE TABLE mapas_normal PARTITION OF mapas_particionada FOR VALUES IN ('Normal');
CREATE TABLE mapas_facil PARTITION OF mapas_particionada FOR VALUES IN ('Fácil');

INSERT INTO mapas_particionada(id, nombre, zona, dificultad)
SELECT id, nombre, zona, dificultad FROM mapas;

