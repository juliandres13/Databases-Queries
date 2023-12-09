CREATE DATABASE IF NOT EXISTS conduexpert;
USE conduexpert;

INSERT INTO `conduexpert`.`academia` (`nit_academia`, `nombre_academia`, `direccion_academia`, `telefono_academia`, `correo_academia`, `fecha_fundacion`, `sitio_web`) 
VALUES ('NIT000000001', 'Conduexpert', 'Cra 20F#46-12', '3134266589', 'academia@conduexpert.com', '2004-06-23', 'conduexpert.com');

CREATE TABLE academia(
nit_academia VARCHAR(25) NOT NULL,
nombre_academia VARCHAR(20) NOT NULL,
direccion_academia VARCHAR(20) NOT NULL,
telefono_academia VARCHAR(15) NOT NULL,
correo_academia VARCHAR(70) NOT NULL,
fecha_fundacion DATE NOT NULL,
sitio_web VARCHAR(100),
CONSTRAINT pk_academia PRIMARY KEY(nit_academia),
CONSTRAINT uq_telefono_academia UNIQUE(telefono_academia),
CONSTRAINT uq_correo_academia UNIQUE(correo_academia)
);

CREATE TABLE cursoteorico(
id_curso_teorico VARCHAR(20) NOT NULL,
nit_academia VARCHAR(25) NOT NULL,
costo INT NOT NULL,
CONSTRAINT pk_cursoteorico PRIMARY KEY(id_curso_teorico),
CONSTRAINT fk_cursoteorico_academia FOREIGN KEY(nit_academia) REFERENCES academia(nit_academia)
);

CREATE TABLE cursopractico(
id_curso_practico VARCHAR(20) NOT NULL,
nit_academia VARCHAR(25) NOT NULL,
costo INT NOT NULL,
CONSTRAINT pk_cursopractico PRIMARY KEY(id_curso_practico),
CONSTRAINT fk_cursopractico_academia FOREIGN KEY(nit_academia) REFERENCES academia(nit_academia)
);




