-- Active: 1699218924256@@127.0.0.1@3306@condu_expert
CREATE DATABASE IF NOT EXISTS condu_expert;

USE condu_expert;

CREATE TABLE
    academias (
        nit_academia VARCHAR(25) NOT NULL,
        nombre_academia VARCHAR(50) NOT NULL,
        direccion_academia VARCHAR(50) NOT NULL,
        telefono_academia VARCHAR(15) NOT NULL,
        correo_academia VARCHAR(70) NOT NULL,
        fecha_fundacion DATE NOT NULL,
        sitio_web VARCHAR(100),
        CONSTRAINT pk_academia PRIMARY KEY (nit_academia),
        CONSTRAINT uq_telefono_academia UNIQUE (telefono_academia),
        CONSTRAINT uq_correo_academia UNIQUE (correo_academia)
    );

CREATE TABLE
    instructores (
        cedula_instructor VARCHAR(15) NOT NULL,
        nit_academia VARCHAR(25) NOT NULL,
        nombre_instructor VARCHAR(50) NOT NULL,
        apellido_instructor VARCHAR(50) NOT NULL,
        email_instructor VARCHAR(70) NOT NULL,
        telefono_instructor VARCHAR(15) NOT NULL,
        vigencia_licencia DATE NOT NULL,
        categoria VARCHAR(20) NOT NULL,
        CONSTRAINT pk_instructor PRIMARY KEY (cedula_instructor),
        CONSTRAINT uq_telefono_instructor UNIQUE (telefono_instructor),
        CONSTRAINT uq_email_instructor UNIQUE (email_instructor),
        CONSTRAINT fk_nit_academia_instructor FOREIGN KEY (nit_academia) REFERENCES academias (nit_academia),
        CONSTRAINT ck_categoria CHECK (categoria IN ('AUTOMOVIL', 'MOTOCICLETA', 'CAMION'))
    );

CREATE TABLE
    disponibilidad_instructores (
        id_disp_instructor VARCHAR(15) NOT NULL,
        cedula_instructor VARCHAR(15) NOT NULL,
        fecha DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        CONSTRAINT pk_disp_instructor PRIMARY KEY (id_disp_instructor),
        CONSTRAINT fk_cedula_disp_instructor FOREIGN KEY (cedula_instructor) REFERENCES instructores (cedula_instructor)
    );

CREATE TABLE
    estudiantes (
        cedula_estudiante VARCHAR(15) NOT NULL,
        nombre_estudiante VARCHAR(50) NOT NULL,
        apellido_estudiante VARCHAR(50) NOT NULL,
        correo_estudiante VARCHAR(70) NOT NULL,
        fecha_nacimiento_estudiante DATE NOT NULL,
        telefono_estudiante VARCHAR(15) NOT NULL,
        CONSTRAINT pk_estudiante PRIMARY KEY (cedula_estudiante),
        CONSTRAINT uq_telefono_estudiante UNIQUE (telefono_estudiante),
        CONSTRAINT uq_correo_estudiante UNIQUE (correo_estudiante)
    );

CREATE TABLE
    vehiculos (
        placa_vehiculo VARCHAR(10) NOT NULL,
        tipo_vehiculo VARCHAR(30) NOT NULL,
        marca VARCHAR(30) NOT NULL,
        modelo VARCHAR(30) NOT NULL,
        vencimiento_soat DATE NOT NULL,
        CONSTRAINT pk_vehiculo PRIMARY KEY (placa_vehiculo),
        CONSTRAINT ck_tipo_vehiculo CHECK (tipo_vehiculo IN ('AUTOMOVIL', 'MOTOCICLETA', 'CAMION'))
    );

CREATE TABLE
    salones (
        id_salon VARCHAR(5) NOT NULL,
        ubicacion_salon VARCHAR(30) NOT NULL,
        capacidad_salon INT NOT NULL,
        CONSTRAINT pk_salon PRIMARY KEY (id_salon)
    );
    
CREATE TABLE
    cursos_teoricos (
        id_curso_teorico VARCHAR(15) NOT NULL,
        nit_academia VARCHAR(25) NOT NULL,
        modalidad VARCHAR(15) NOT NULL,
        categoria VARCHAR(20) NOT NULL,
        costo INT NOT NULL,
        CONSTRAINT pk_cursoteorico PRIMARY KEY (id_curso_teorico),
        CONSTRAINT fk_nit_academia_curso_teorico FOREIGN KEY (nit_academia) REFERENCES academias (nit_academia),
        CONSTRAINT ck_modalidad CHECK (modalidad IN ('PRESENCIAL', 'VIRTUAL')),
		CONSTRAINT ck_categoria_ct CHECK (categoria IN ('AUTOMOVIL', 'MOTOCICLETA', 'CAMION'))
    );

CREATE TABLE
    cursos_practicos (
        id_curso_practico VARCHAR(15) NOT NULL,
        nit_academia VARCHAR(25) NOT NULL,
        categoria VARCHAR(20) NOT NULL,
        costo INT NOT NULL,
        CONSTRAINT pk_cursopractico PRIMARY KEY (id_curso_practico),
        CONSTRAINT fk_nit_academia_curso_practico FOREIGN KEY (nit_academia) REFERENCES academias (nit_academia),
        CONSTRAINT ck_categoria_cp CHECK (categoria IN ('AUTOMOVIL', 'MOTOCICLETA', 'CAMION'))
    );

CREATE TABLE
    examenes (
        id_examen VARCHAR(15) NOT NULL,
        id_curso_teorico VARCHAR(20) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        fecha_examen DATE,
        hora_inicio TIME,
        hora_fin TIME,
        estado_examen VARCHAR(25) NOT NULL,
        total_preguntas INT NOT NULL,
        preguntas_acertadas INT,
        CONSTRAINT pk_examen PRIMARY KEY (id_examen),
        CONSTRAINT fk_id_curso_teorico_examen FOREIGN KEY (id_curso_teorico) REFERENCES cursos_teoricos (id_curso_teorico),
        CONSTRAINT fk_cedula_estudiante_examen FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante),
        CONSTRAINT ck_estado_examen CHECK (estado_examen IN ('APROBADO', 'REPROBADO', 'PENDIENTE'))
    );
    
CREATE TABLE
    temas_clase (
        nro_tema_clase VARCHAR(10) NOT NULL,
        titulo_tema VARCHAR(100) NOT NULL,
        descripcion_tema VARCHAR(250) NOT NULL,
        CONSTRAINT pk_temas_clase PRIMARY KEY (nro_tema_clase)
    );

CREATE TABLE
    temas_leccion (
        nro_tema_leccion VARCHAR(10) NOT NULL,
        titulo_tema VARCHAR(100) NOT NULL,
        descripcion_tema VARCHAR(250) NOT NULL,
        categoria_tema VARCHAR(30) NOT NULL,
        CONSTRAINT pk_temas_leccion PRIMARY KEY (nro_tema_leccion),
        CONSTRAINT ck_categoria_tema CHECK (categoria_tema IN ('AUTOMOVIL', 'MOTOCICLETA', 'CAMION'))
    );
    
CREATE TABLE
    clases (
        id_clase VARCHAR(15) NOT NULL,
        id_curso_teorico VARCHAR(20) NOT NULL,
        cedula_instructor VARCHAR(15) NOT NULL,
        id_salon VARCHAR(5),
        nro_tema_clase VARCHAR(10) NOT NULL,
        fecha_clase DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        CONSTRAINT pk_clase PRIMARY KEY (id_clase),
        CONSTRAINT fk_id_curso_teorico_clase FOREIGN KEY (id_curso_teorico) REFERENCES cursos_teoricos (id_curso_teorico),
        CONSTRAINT fk_cedula_instructor_clase FOREIGN KEY (cedula_instructor) REFERENCES instructores (cedula_instructor),
        CONSTRAINT fk_id_salon_clase FOREIGN KEY (id_salon) REFERENCES salones (id_salon),
        CONSTRAINT fk_nro_tema_clase_clase FOREIGN KEY (nro_tema_clase) REFERENCES temas_clase (nro_tema_clase)
    );

CREATE TABLE
    asistencia_clases (
        id_asistencia_clase VARCHAR(15) NOT NULL,
        id_clase VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        CONSTRAINT pk_asistencia_clase PRIMARY KEY (id_asistencia_clase),
        CONSTRAINT fk_id_clase_ac FOREIGN KEY (id_clase) REFERENCES clases (id_clase),
        CONSTRAINT fk_cedula_estudiante_ac FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante)
    );

CREATE TABLE
    lecciones (
        id_leccion VARCHAR(15) NOT NULL,
        id_curso_practico VARCHAR(20) NOT NULL,
        cedula_instructor VARCHAR(15) NOT NULL,
        placa_vehiculo VARCHAR(10) NOT NULL,
        nro_tema_leccion VARCHAR(10) NOT NULL,
        lugar_leccion VARCHAR(50) NOT NULL,
        fecha_leccion DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_finalizacion TIME NOT NULL,
        CONSTRAINT pk_leccion PRIMARY KEY (id_leccion),
        CONSTRAINT fk_id_curso_practico_leccion FOREIGN KEY (id_curso_practico) REFERENCES cursos_practicos (id_curso_practico),
        CONSTRAINT fk_cedula_instructor_leccion FOREIGN KEY (cedula_instructor) REFERENCES instructores (cedula_instructor),
        CONSTRAINT fk_placa_vehiculo_leccion FOREIGN KEY (placa_vehiculo) REFERENCES vehiculos (placa_vehiculo),
        CONSTRAINT fk_nro_tema_leccion_leccion FOREIGN KEY (nro_tema_leccion) REFERENCES temas_leccion (nro_tema_leccion)
    );

CREATE TABLE
    asistencia_lecciones (
        id_asistencia_leccion VARCHAR(15) NOT NULL,
        id_leccion VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        CONSTRAINT pk_asistencia_leccion PRIMARY KEY (id_asistencia_leccion),
        CONSTRAINT fk_id_leccion_al FOREIGN KEY (id_leccion) REFERENCES lecciones (id_leccion),
        CONSTRAINT fk_cedula_estudiante_al FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante)
    );

CREATE TABLE
    compras (
        id_compra VARCHAR(15) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        id_curso_teorico VARCHAR(15),
        id_curso_practico VARCHAR(15),
        fecha DATE NOT NULL,
        CONSTRAINT pk_compra PRIMARY KEY (id_compra),
        CONSTRAINT fk_curso_teorico_compra FOREIGN KEY (id_curso_teorico) REFERENCES cursos_teoricos(id_curso_teorico),
        CONSTRAINT fk_curso_practico_compra FOREIGN KEY (id_curso_practico) REFERENCES cursos_practicos(id_curso_practico)
    );

CREATE TABLE
    facturas (
        id_factura VARCHAR(15) NOT NULL,
        id_compra VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        total_a_pagar INT NOT NULL,
        estado_factura VARCHAR(25) NOT NULL,
        CONSTRAINT pk_factura PRIMARY KEY (id_factura),
        CONSTRAINT fk_id_compra_factura FOREIGN KEY (id_compra) REFERENCES compras (id_compra),
        CONSTRAINT fk_cedula_estudiante_factura FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante),
        CONSTRAINT ck_estado_factura CHECK (estado_factura IN ('PAGADA', 'PENDIENTE'))
    );

CREATE TABLE
    pagos (
        id_pago VARCHAR(15) NOT NULL,
        id_factura VARCHAR(10) NOT NULL,
        fecha_pago DATE NOT NULL,
        metodo_pago VARCHAR(25) NOT NULL,
        valor_pago INT NOT NULL,
        CONSTRAINT pk_pago PRIMARY KEY (id_pago),
        CONSTRAINT fk_id_factura_pago FOREIGN KEY (id_factura) REFERENCES facturas (id_factura),
        CONSTRAINT ck_metodo_pago CHECK (metodo_pago IN ('TARJETA', 'EFECTIVO'))
    );
    
CREATE TABLE
    comentarios_clase (
        id_comentario_clase VARCHAR(15) NOT NULL,
        id_asistencia_clase VARCHAR(15) NOT NULL,
        comentario VARCHAR(250) NOT NULL,
        calificacion INT NOT NULL,
        CONSTRAINT pk_comentario_clase PRIMARY KEY (id_comentario_clase),
        CONSTRAINT fk_asistencia_clase_comentario_clase FOREIGN KEY (id_asistencia_clase) REFERENCES asistencia_clases (id_asistencia_clase),
        CHECK (calificacion BETWEEN 1 AND 5)
    );
    
CREATE TABLE
    comentarios_leccion (
        id_comentario_leccion VARCHAR(15) NOT NULL,
        id_asistencia_leccion VARCHAR(15) NOT NULL,
        comentario VARCHAR(250) NOT NULL,
        calificacion INT NOT NULL,
        CONSTRAINT pk_comentario_leccion PRIMARY KEY (id_comentario_leccion),
        CONSTRAINT fk_asistencia_leccion_comentario_leccion FOREIGN KEY (id_asistencia_leccion) REFERENCES asistencia_lecciones (id_asistencia_leccion),
        CHECK (calificacion BETWEEN 1 AND 5)
    );
    
    
-- --------------- ACADEMIAS --------------------
INSERT INTO
    academias (nit_academia, nombre_academia, direccion_academia, telefono_academia, correo_academia, fecha_fundacion, sitio_web)
VALUES
    ('NIT001', 'ConduExpert', 'Calle 20#60-05', '312-435-6087', 'conduexpert@gmail.com', '2000-06-20', 'www.conduexpert.com'),
    ('NIT002', 'I Drive Academy', 'Avenida 15#45-30', '310-789-5023', 'info@idrive.com', '1995-11-12', 'www.idrive.com'),
    ('NIT003', 'Academia de Conducción Benitez', 'Calle 5#38-22', '305-432-7890', 'info@benitez.com', '2005-09-08', 'www.benitezacademy.com');

-- -------------- ESTUDIANTES -------------------
INSERT INTO
    estudiantes (cedula_estudiante, nombre_estudiante, apellido_estudiante, correo_estudiante, fecha_nacimiento_estudiante, telefono_estudiante)
VALUES
    ('E001', 'Julián Andrés', 'León Rivera', 'julian@gmail.com', '2003-12-13', '+57 3234568987'),
    ('E002', 'Laura Alejandra', 'Gómez Pérez', 'laura@gmail.com', '2002-08-21', '+57 3012345678'),
    ('E003', 'Carlos Enrique', 'Ramírez Rojas', 'carlos@yahoo.com', '2001-05-07', '+57 3157890123'),
    ('E004', 'María Fernanda', 'Hernández Soto', 'maria@hotmail.com', '2004-02-28', '+57 3106781234'),
    ('E005', 'Alejandro José', 'Martínez López', 'alejandro@gmail.com', '2003-09-15', '+57 3185678901'),
    ('E006', 'Paola Andrea', 'Castaño Gutiérrez', 'paola@yahoo.com', '2002-04-03', '+57 3247890123'),
    ('E007', 'Juan Manuel', 'Ortiz Vargas', 'juan@hotmail.com', '2001-11-17', '+57 3126789012'),
    ('E008', 'Camila Alejandra', 'López Castaño', 'camila@gmail.com', '2004-06-05', '+57 3055678901'),
    ('E009', 'Andrés Felipe', 'Sánchez Jiménez', 'andres@yahoo.com', '2003-01-22', '+57 3117890123'),
    ('E010', 'Sofía Carolina', 'García Ramírez', 'sofia@hotmail.com', '2002-07-08', '+57 3206789012'),
    ('E011', 'José Antonio', 'Herrera González', 'jose@gmail.com', '2001-04-14', '+57 3075678901'),
    ('E012', 'Ana María', 'Cruz Martínez', 'ana@yahoo.com', '2004-10-30', '+57 3147890123'),
    ('E013', 'David Alejandro', 'Vega Herrera', 'david@hotmail.com', '2003-06-18', '+57 3036789012'),
    ('E014', 'Valentina Isabel', 'Moreno Castro', 'valentina@gmail.com', '2002-12-04', '+57 3195678901'),
    ('E015', 'Felipe Andrés', 'Pérez Gómez', 'felipe@yahoo.com', '2001-08-12', '+57 3087890123'),
    ('E016', 'Luisa Fernanda', 'Rodríguez Díaz', 'luisa@gmail.com', '2004-03-29', '+57 3224567890'),
    ('E017', 'Santiago', 'Giraldo Molina', 'santiago@yahoo.com', '2001-09-19', '+57 3162345678'),
    ('E018', 'Daniela', 'Torres Cárdenas', 'daniela@hotmail.com', '2002-05-05', '+57 3204567891'),
    ('E019', 'Jorge Enrique', 'Ruiz Pardo', 'jorge@gmail.com', '2003-07-23', '+57 3216789012'),
    ('E020', 'Carolina', 'Díaz Salazar', 'carolina@yahoo.com', '2001-10-11', '+57 3238901234');
    
-- -------------- CURSOS PRACTICOS -------------------

INSERT INTO
    cursos_practicos (id_curso_practico, nit_academia, categoria, costo)
VALUES
    ('CPA0001', 'NIT001', 'AUTOMOVIL', 800000),
    ('CPM0001', 'NIT001', 'MOTOCICLETA', 500000),
    ('CPC0001', 'NIT001', 'CAMION', 1000000);
    
    
-- -------------- CURSOS TEORICOS -------------------

INSERT INTO
    cursos_teoricos (id_curso_teorico, nit_academia, modalidad, categoria, costo)
VALUES
    ('CTA0001', 'NIT001', 'PRESENCIAL', 'AUTOMOVIL', 700000),
    ('CTA0002', 'NIT001', 'VIRTUAL', 'AUTOMOVIL', 700000),
    ('CTM0001', 'NIT001', 'PRESENCIAL', 'MOTOCICLETA', 500000),
    ('CTM0002', 'NIT001', 'VIRTUAL', 'MOTOCICLETA', 500000),
    ('CTC0001', 'NIT001', 'PRESENCIAL', 'CAMION', 1000000),
    ('CTC0002', 'NIT001', 'VIRTUAL', 'CAMION', 1000000);
    
    
-- -------------- COMPRAS -------------------

INSERT INTO
    compras (id_compra, cedula_estudiante, id_curso_teorico, id_curso_practico, fecha)
VALUES
    ('C000001', 'E001', 'CTA0001', 'CPA0001', '2023-02-01'),
    ('C000002', 'E002', 'CTA0002', 'CPA0001', '2023-02-03'),
    ('C000003', 'E003', 'CTA0001', NULL, '2023-02-05'),
    ('C000004', 'E003', NULL, 'CPA0001', '2023-03-07'),
    ('C000005', 'E004', 'CTA0002', 'CPA0001', '2023-02-10'),
    ('C000006', 'E005', 'CTA0001', 'CPA0001', '2023-02-02'),
    ('C000007', 'E006', 'CTA0002', 'CPA0001', '2023-02-04'),
    ('C000008', 'E007', 'CTA0001', 'CPA0001', '2023-02-08'),
    
    ('C000009', 'E008', 'CTM0001', 'CPM0001', '2023-02-09'),
    ('C000010', 'E009', 'CTM0002', 'CPM0001', '2023-02-01'),
    ('C000011', 'E0010', 'CTM0001', 'CPM0001', '2023-02-03'),
    ('C000012', 'E0011', 'CTM0002', NULL, '2023-02-09'),
    ('C000013', 'E0011', NULL, 'CPM0001', '2023-03-01'),
    ('C000014', 'E0012', 'CTM0001', 'CPM0001', '2023-02-01'),
    ('C000015', 'E0013', 'CTM0001', 'CPM0001', '2023-02-01'),
    ('C000016', 'E0014', 'CTM0001', 'CPM0001', '2023-02-01'),
    
    ('C000017', 'E0015', 'CTC0001', NULL, '2023-02-01'),
    ('C000018', 'E0015', NULL, 'CPC0001', '2023-03-08'),
    ('C000019', 'E0016', 'CTC0001', 'CPC0001', '2023-02-03'),
    ('C000020', 'E0017', 'CTC0001', 'CPC0001', '2023-02-05'),
    ('C000021', 'E0018', 'CTC0001', 'CPC0001', '2023-02-06'),
    ('C000022', 'E0019', 'CTC0001', 'CPC0001', '2023-02-10'),
    ('C000023', 'E0020', 'CTC0002', 'CPC0001', '2023-02-10');
    
    
-- -------------- FACTURAS -------------------

INSERT INTO
    facturas (id_factura, id_compra, cedula_estudiante, total_a_pagar, estado_factura)
VALUES
    ('F000001', 'C000001', 'E001', 1500000, 'PAGADA'),
	('F000002', 'C000002', 'E002', 1500000, 'PAGADA'),
	('F000003', 'C000003', 'E003', 700000, 'PAGADA'),
	('F000004', 'C000004', 'E003', 800000, 'PAGADA'),
	('F000005', 'C000005', 'E004', 1500000, 'PAGADA'),
	('F000006', 'C000006', 'E005', 1500000, 'PAGADA'),
	('F000007', 'C000007', 'E006', 1500000, 'PAGADA'),
	('F000008', 'C000008', 'E007', 1500000, 'PAGADA'),
    
	('F000009', 'C000009', 'E008', 1000000, 'PAGADA'),
	('F000010', 'C000010', 'E009', 1000000, 'PENDIENTE'),
	('F000011', 'C000011', 'E010', 1000000, 'PAGADA'),
	('F000012', 'C000012', 'E011', 500000, 'PAGADA'),
	('F000013', 'C000013', 'E011', 500000, 'PAGADA'),
	('F000014', 'C000014', 'E012', 1000000, 'PAGADA'),
	('F000015', 'C000015', 'E013', 1000000, 'PAGADA'),
	('F000016', 'C000016', 'E014', 1000000, 'PENDIENTE'),
    
	('F000017', 'C000017', 'E015', 1000000, 'PAGADA'),
	('F000018', 'C000018', 'E015', 1000000, 'PAGADA'),
	('F000019', 'C000019', 'E016', 2000000, 'PAGADA'),
	('F000020', 'C000020', 'E017', 2000000, 'PAGADA'),
	('F000021', 'C000021', 'E018', 2000000, 'PAGADA'),
	('F000022', 'C000022', 'E019', 2000000, 'PENDIENTE'),
	('F000023', 'C000023', 'E020', 2000000, 'PAGADA');
    
-- -------------- PAGOS -------------------

INSERT INTO
    pagos (id_pago, id_factura, fecha_pago, metodo_pago, valor_pago)
VALUES
    ('P000001', 'F000001', '2023-02-01', 'EFECTIVO', 1500000),
    ('P000002', 'F000002', '2023-02-03', 'TARJETA', 500000),
    ('P000003', 'F000002', '2023-03-03', 'TARJETA', 500000),
    ('P000004', 'F000002', '2023-04-03', 'TARJETA', 500000),
    ('P000005', 'F000003', '2023-02-05', 'TARJETA', 700000),
    ('P000006', 'F000004', '2023-03-07', 'TARJETA', 800000),
    ('P000007', 'F000005', '2023-02-10', 'EFECTIVO', 1500000),
    ('P000008', 'F000006', '2023-02-02', 'EFECTIVO', 1500000),
    ('P000009', 'F000007', '2023-02-04', 'TARJETA', 1500000),
    ('P000010', 'F000008', '2023-02-08', 'TARJETA', 1000000),
    ('P000011', 'F000008', '2023-03-08', 'TARJETA', 500000),
    
    ('P000012', 'F000009', '2023-02-09', 'EFECTIVO', 500000),
    ('P000013', 'F000009', '2023-03-09', 'EFECTIVO', 500000),
    ('P000014', 'F000010', '2023-02-01', 'EFECTIVO', 200000),
    ('P000015', 'F000011', '2023-02-03', 'TARJETA', 1000000),
    ('P000016', 'F000012', '2023-02-09', 'TARJETA', 500000),
    ('P000017', 'F000013', '2023-03-01', 'TARJETA', 500000),
    ('P000018', 'F000014', '2023-02-01', 'TARJETA', 200000),
    ('P000019', 'F000014', '2023-03-01', 'TARJETA', 200000),
    ('P000020', 'F000014', '2023-04-01', 'TARJETA', 200000),
    ('P000021', 'F000014', '2023-05-01', 'TARJETA', 200000),
    ('P000022', 'F000014', '2023-06-01', 'TARJETA', 200000),
    ('P000023', 'F000015', '2023-02-01', 'EFECTIVO', 1000000),
    ('P000024', 'F000016', '2023-02-01', 'EFECTIVO', 500000),
    
    ('P000025', 'F000017', '2023-02-01', 'TARJETA', 500000),
    ('P000026', 'F000017', '2023-02-15', 'TARJETA', 500000),
    ('P000027', 'F000018', '2023-03-08', 'TARJETA', 1000000),
    ('P000028', 'F000019', '2023-02-03', 'TARJETA', 2000000),
    ('P000029', 'F000020', '2023-02-05', 'EFECTIVO', 2000000),
    ('P000030', 'F000021', '2023-02-06', 'EFECTIVO', 2000000),
    ('P000031', 'F000022', '2023-02-10', 'EFECTIVO', 1000000),
    ('P000032', 'F000023', '2023-02-10', 'TARJETA', 2000000);

-- -------------- EXAMENES ------------------

INSERT INTO
    examenes (id_examen, id_curso_teorico, cedula_estudiante, fecha_examen, hora_inicio, hora_fin, estado_examen, total_preguntas, preguntas_acertadas)
VALUES
    ('EX000001', 'CTA0001', 'E001', '2023-02-25', '06:00:00', '08:00:00', 'APROBADO', '40', '36'),
    ('EX000002', 'CTA0002', 'E002', '2023-02-25', '06:00:00', '08:00:00', 'APROBADO', '40', '37'),
    ('EX000003', 'CTA0001', 'E003', '2023-02-25', '06:00:00', '08:00:00', 'REPROBADO', '40', '30'),
    ('EX000004', 'CTA0001', 'E003', '2023-02-26', '06:00:00', '08:00:00', 'APROBADO', '40', '37'),
    ('EX000005', 'CTA0002', 'E004', '2023-02-25', '06:00:00', '08:00:00', 'APROBADO', '40', '40'),
    ('EX000006', 'CTA0001', 'E005', '2023-02-25', '06:00:00', '08:00:00', 'APROBADO', '40', '39'),
    ('EX000007', 'CTA0002', 'E006', '2023-02-25', '06:00:00', '08:00:00', 'APROBADO', '40', '39'),
    ('EX000008', 'CTA0001', 'E007', '2023-02-25', '06:00:00', '08:00:00', 'APROBADO', '40', '38'),
    
    ('EX000009', 'CTM0001', 'E008', '2023-02-25', '08:00:00', '10:00:00', 'APROBADO', '40', '38'),
    ('EX000010', 'CTM0002', 'E009', '2023-02-25', '08:00:00', '10:00:00', 'REPROBADO', '40', '15'),
    ('EX000011', 'CTM0002', 'E009', '2023-02-26', '08:00:00', '10:00:00', 'REPROBADO', '40', '22'),
    ('EX000012', 'CTM0002', 'E009', '2023-02-26', '16:00:00', '18:00:00', 'APROBADO', '40', '37'),
    ('EX000013', 'CTM0001', 'E010', '2023-02-25', '08:00:00', '10:00:00', 'APROBADO', '40', '39'),
    ('EX000014', 'CTM0002', 'E011', '2023-02-25', '08:00:00', '10:00:00', 'APROBADO', '40', '36'),
    ('EX000015', 'CTM0001', 'E012', '2023-02-25', '08:00:00', '10:00:00', 'REPROBADO', '40', '34'),
    ('EX000016', 'CTM0001', 'E012', '2023-02-26', '08:00:00', '10:00:00', 'REPROBADO', '40', '35'),
    ('EX000017', 'CTM0001', 'E012', '2023-02-26', '16:00:00', '18:00:00', 'REPROBADO', '40', '35'),
    ('EX000018', 'CTM0001', 'E012', '2023-02-26', '20:00:00', '22:00:00', 'APROBADO', '40', '37'),
    ('EX000019', 'CTM0001', 'E013', '2023-02-25', '08:00:00', '10:00:00', 'APROBADO', '40', '36'),
    ('EX000020', 'CTM0001', 'E014', '2023-02-25', '08:00:00', '10:00:00', 'APROBADO', '40', '38'),
    
    ('EX000021', 'CTC0001', 'E015', '2023-02-25', '10:00:00', '12:00:00', 'REPROBADO', '40', '31'),
    ('EX000022', 'CTC0001', 'E015', '2023-02-26', '18:00:00', '20:00:00', 'APROBADO', '40', '40'),
    ('EX000023', 'CTC0001', 'E016', '2023-02-25', '10:00:00', '12:00:00', 'APROBADO', '40', '36'),
    ('EX000024', 'CTC0001', 'E017', '2023-02-25', '10:00:00', '12:00:00', 'APROBADO', '40', '37'),
    ('EX000025', 'CTC0001', 'E018', '2023-02-25', '10:00:00', '12:00:00', 'APROBADO', '40', '40'),
    ('EX000026', 'CTC0001', 'E019', '2023-02-25', '10:00:00', '12:00:00', 'APROBADO', '40', '39'),
    ('EX000027', 'CTC0002', 'E020', '2023-02-25', '10:00:00', '12:00:00', 'APROBADO', '40', 40);

-- -------------- INSTRUCTORES ------------------

INSERT INTO 
    instructores (cedula_instructor, nit_academia, nombre_instructor, apellido_instructor, email_instructor, telefono_instructor, vigencia_licencia, categoria)
VALUES
    ('I001', 'NIT001', 'Miguel Ángel', 'Cardona', 'miguel@gmail.com', '+57 3112336510', '2029-01-30', 'AUTOMOVIL'),
    ('I002', 'NIT001', 'Ana María', 'Gómez', 'ana@gmail.com', '+57 3154487823', '2026-11-15', 'AUTOMOVIL'),
    ('I003', 'NIT001', 'Carlos Hernández', 'Pérez', 'carlos@hotmail.com', '+57 3105779345', '2030-05-22', 'AUTOMOVIL'),
    ('I004', 'NIT001', 'Laura Jiménez', 'Ramírez', 'laura@yahoo.com', '+57 3186691245', '2028-09-10', 'AUTOMOVIL'),
    ('I005', 'NIT001', 'Alejandro Rodríguez', 'Sánchez', 'alejandro@gmail.com', '+57 3147895612', '2027-03-07', 'AUTOMOVIL'),
    
    ('I006', 'NIT001', 'Sofía Martínez', 'López', 'sofia@gmail.com', '+57 3162347890', '2030-12-18', 'MOTOCICLETA'),
    ('I007', 'NIT001', 'Juan Carlos', 'García', 'juancarlos@gmail.com', '+57 3125678901', '2028-05-23', 'MOTOCICLETA'),
    ('I008', 'NIT001', 'María José', 'Herrera', 'mariajose@hotmail.com', '+57 3198765432', '2025-07-11', 'MOTOCICLETA'),
    ('I009', 'NIT001', 'José Luis', 'Díaz', 'joseluis@yahoo.com', '+57 3176543210', '2025-03-24', 'MOTOCICLETA'),
    ('I010', 'NIT001', 'Valentina', 'Torres', 'valentina@gmail.com', '+57 3138901234', '2028-12-25', 'MOTOCICLETA'),
    
    ('I011', 'NIT001', 'David', 'Moreno', 'david@gmail.com', '+57 3201122334', '2024-02-15', 'CAMION'),
    ('I012', 'NIT001', 'Luisa Fernanda', 'Vega', 'luisa@gmail.com', '+57 3214455667', '2028-10-09', 'CAMION'),
    ('I013', 'NIT001', 'Sergio', 'González', 'sergio@hotmail.com', '+57 3227788990', '2028-04-18', 'CAMION'),
    ('I014', 'NIT001', 'Camila', 'Gutiérrez', 'camila@yahoo.com', '+57 3231122334', '2027-08-22', 'CAMION'),
    ('I015', 'NIT001', 'Roberto', 'Castillo', 'roberto@gmail.com', '+57 3244455667', '2030-06-30', 'CAMION');
    
-- -------------- VEHICULOS -------------------
INSERT INTO
    vehiculos (placa_vehiculo, tipo_vehiculo, marca, modelo, vencimiento_soat)
VALUES
    ('ABC-123', 'AUTOMOVIL', 'Nissan GT-R R34', '2023', '2027-08-20'),
    ('DEF-234', 'AUTOMOVIL', 'Toyota Corolla', '2021', '2026-09-15'),
    ('GHI-567', 'AUTOMOVIL', 'Ford Mustang', '2022', '2026-10-20'),
    ('JKL-890', 'AUTOMOVIL', 'Honda Civic', '2020', '2026-07-11'),
    ('MNO-345', 'AUTOMOVIL', 'Chevrolet Camaro', '2022', '2026-12-05'),
    ('PQR-678', 'AUTOMOVIL', 'BMW Serie 3', '2023', '2027-06-18'),
    ('STU-901', 'AUTOMOVIL', 'Audi A4', '2021', '2026-11-23'),
    
    ('VWX-234', 'MOTOCICLETA', 'Yamaha YZF R1', '2023', '2027-03-19'),
	('XYZ-456', 'MOTOCICLETA', 'Pulsar NS 200', '2024', '2027-08-28'),
    ('YZA-567', 'MOTOCICLETA', 'Kawasaki Ninja 650', '2022', '2026-08-27'),
    ('BCD-890', 'MOTOCICLETA', 'Ducati Panigale V4', '2023', '2027-09-24'),
    ('EFG-123', 'MOTOCICLETA', 'Harley-Davidson Street 750', '2021', '2026-05-06'),
    ('HIJ-456', 'MOTOCICLETA', 'KTM 390 Duke', '2022', '2026-07-29'),
    ('KLM-789', 'MOTOCICLETA', 'Honda CB500F', '2020', '2026-04-17'),
    
    ('NOP-234', 'CAMION', 'Volvo FH', '2022', '2027-11-30'),
    ('QRS-567', 'CAMION', 'Scania R450', '2023', '2027-01-22'),
    ('TUV-890', 'CAMION', 'Mercedes-Benz Actros', '2021', '2026-02-13'),
    ('WXY-123', 'CAMION', 'MAN TGX', '2024', '2027-12-07'),
    ('ZAB-456', 'CAMION', 'DAF XF', '2020', '2026-03-05'),
    ('CDE-789', 'CAMION', 'Iveco Stralis', '2022', '2026-06-20'),
	('QRS-101', 'CAMION', 'NPS 4x4 Chevrolet', '2024', '2027-05-31');

-- -------------- SALONES -------------------
    
INSERT INTO
    salones (id_salon, ubicacion_salon, capacidad_salon)
VALUES
    ('S101', 'Piso 1', 35),
    ('S102', 'Piso 1', 30),
    ('S103', 'Piso 1', 40),
    ('S104', 'Piso 1', 25),
    ('S105', 'Piso 1', 35),

    ('S201', 'Piso 2', 35),
    ('S202', 'Piso 2', 30),
    ('S203', 'Piso 2', 35),
    ('S204', 'Piso 2', 30),
    ('S205', 'Piso 2', 30),

    ('S301', 'Piso 3', 40),
    ('S302', 'Piso 3', 40),
    ('S303', 'Piso 3', 45),
    ('S304', 'Piso 3', 40),
    ('S305', 'Piso 3', 30);
    
    
-- -------------- TEMAS CLASE -------------------

INSERT INTO temas_clase (nro_tema_clase, titulo_tema, descripcion_tema)
VALUES
    ('TC001', 'Reglas básicas de tránsito', 'Introducción a las normas y leyes de tránsito fundamentales.'),
    ('TC002', 'Señalización vial y su significado', 'Estudio detallado de las señales de tránsito y su importancia.'),
    ('TC003', 'Normas de prioridad en la vía', 'Cómo determinar el derecho de paso en diferentes situaciones de tránsito.'),
    ('TC004', 'Uso adecuado de carriles', 'Instrucciones sobre el uso correcto de los carriles en diversas condiciones.'),
    ('TC005', 'Técnicas de conducción defensiva', 'Enfoque en técnicas para prevenir accidentes y conducir de manera segura.'),
    ('TC006', 'Conducción en condiciones adversas', 'Manejo en condiciones de lluvia, niebla, nieve y otras situaciones climáticas adversas.'),
    ('TC007', 'Mantenimiento básico del vehículo', 'Conocimientos esenciales sobre el mantenimiento y cuidado del vehículo.'),
    ('TC008', 'Manejo ecoeficiente', 'Técnicas de conducción para maximizar la eficiencia del combustible y minimizar el impacto ambiental.'),
    ('TC009', 'Normativa sobre alcohol y conducción', 'Leyes y efectos del alcohol y otras sustancias en la capacidad de conducción.'),
    ('TC010', 'Primeros auxilios básicos', 'Conocimientos fundamentales de primeros auxilios en caso de accidentes de tráfico.'),
    ('TC011', 'Psicología del conductor', 'Entender el comportamiento del conductor y cómo afecta la seguridad vial.'),
    ('TC012', 'Seguridad de peatones y ciclistas', 'Normas y consideraciones para la protección de peatones y ciclistas.'),
    ('TC013', 'Uso de sistemas de seguridad vehicular', 'Funcionamiento y utilización correcta de cinturones de seguridad, airbags y otros sistemas.'),
    ('TC014', 'Estrategias para evitar distracciones al conducir', 'Consejos para mantener la concentración y evitar distracciones.'),
    ('TC015', 'Planificación de rutas y uso de GPS', 'Cómo planificar rutas eficientemente y el uso correcto de sistemas de navegación GPS.');
    
    
-- -------------- TEMAS LECCION -------------------

INSERT INTO temas_leccion (nro_tema_leccion, titulo_tema, descripcion_tema, categoria_tema)
VALUES
    ('TL-A001', 'Ajuste de espejos y asiento', 'Instrucciones sobre cómo ajustar los espejos y el asiento para una conducción segura.', 'AUTOMOVIL'),
    ('TL-A002', 'Uso de la caja de cambios', 'Práctica sobre el manejo de la caja de cambios en vehículos manuales y automáticos.', 'AUTOMOVIL'),
    ('TL-A003', 'Frenado y control de velocidad', 'Técnicas para frenar eficazmente y controlar la velocidad.', 'AUTOMOVIL'),
    ('TL-A004', 'Maniobras de estacionamiento', 'Práctica de diferentes técnicas de estacionamiento.', 'AUTOMOVIL'),
    ('TL-A005', 'Conducción en rotondas', 'Instrucciones para el manejo seguro en rotondas.', 'AUTOMOVIL'),
    ('TL-A006', 'Manejo en autopistas', 'Prácticas de conducción en autopistas, incluyendo el uso de carriles y la velocidad adecuada.', 'AUTOMOVIL'),
    ('TL-A007', 'Evitar puntos ciegos', 'Técnicas para identificar y evitar puntos ciegos.', 'AUTOMOVIL'),
    ('TL-A008', 'Uso de señales de giro', 'Práctica sobre el uso correcto de las señales de giro.', 'AUTOMOVIL'),
    ('TL-A009', 'Conducción defensiva', 'Enseñanza de técnicas de conducción defensiva.', 'AUTOMOVIL'),
    ('TL-A010', 'Reacción ante emergencias', 'Cómo reaccionar adecuadamente ante situaciones de emergencia en carretera.', 'AUTOMOVIL'),
    
    ('TL-M001', 'Control de la motocicleta a bajas velocidades', 'Técnicas para el manejo de la motocicleta a bajas velocidades.', 'MOTOCICLETA'),
    ('TL-M002', 'Maniobras de giro', 'Práctica de maniobras de giro seguras.', 'MOTOCICLETA'),
    ('TL-M003', 'Uso de frenos en motocicleta', 'Técnicas de frenado efectivo y seguro.', 'MOTOCICLETA'),
    ('TL-M004', 'Conducción en diferentes superficies', 'Adaptación a la conducción en superficies diversas como asfalto, grava, etc.', 'MOTOCICLETA'),
    ('TL-M005', 'Mantenimiento básico de la motocicleta', 'Enseñanza sobre el mantenimiento básico necesario.', 'MOTOCICLETA'),
    ('TL-M006', 'Uso de equipo de protección', 'Importancia y uso correcto del equipo de protección.', 'MOTOCICLETA'),
    ('TL-M007', 'Conducción en condiciones climáticas adversas', 'Prácticas de conducción segura bajo lluvia o viento.', 'MOTOCICLETA'),
    ('TL-M008', 'Conducción en grupo', 'Reglas y técnicas para la conducción en grupo.', 'MOTOCICLETA'),
    ('TL-M009', 'Técnicas de equilibrio', 'Prácticas para mejorar el equilibrio en la motocicleta.', 'MOTOCICLETA'),
    ('TL-M010', 'Señalización manual', 'Cómo y cuándo usar señalizaciones manuales.', 'MOTOCICLETA'),
    
    ('TL-C001', 'Maniobras de reversa con camión', 'Técnicas para realizar maniobras de reversa de forma segura.', 'CAMION'),
    ('TL-C002', 'Control de la carga', 'Métodos para asegurar y controlar la carga en el camión.', 'CAMION'),
    ('TL-C003', 'Uso del freno motor', 'Instrucciones sobre cómo y cuándo utilizar el freno motor.', 'CAMION'),
    ('TL-C004', 'Manejo en pendientes', 'Prácticas de conducción en pendientes ascendentes y descendentes.', 'CAMION'),
    ('TL-C005', 'Inspección preoperacional del camión', 'Cómo realizar una inspección preoperacional efectiva.', 'CAMION'),
    ('TL-C006', 'Conducción en espacios estrechos', 'Técnicas para maniobrar en espacios reducidos.', 'CAMION'),
    ('TL-C007', 'Uso de espejos en grandes dimensiones', 'Cómo utilizar los espejos correctamente en un vehículo de grandes dimensiones.', 'CAMION'),
    ('TL-C008', 'Acoplamiento y desacoplamiento de remolques', 'Procedimientos para acoplar y desacoplar remolques.', 'CAMION'),
    ('TL-C009', 'Conducción en condiciones adversas', 'Prácticas para conducir en condiciones de lluvia, nieve o niebla.', 'CAMION'),
    ('TL-C010', 'Regulaciones para transporte de carga', 'Instrucciones sobre las regulaciones legales en el transporte de carga.', 'CAMION');
    

-- -------------- CLASES -------------------

INSERT INTO
    clases (id_clase, id_curso_teorico, cedula_instructor, id_salon, nro_tema_clase, fecha_clase, hora_inicio, hora_fin)
VALUES
    -- lunes
    
    ('CL000001', 'CTA0001', 'I001', 'S101', 'TC001', '2023-02-20', '06:00:00', '08:00:00'),
    ('CL000002', 'CTA0002', 'I002', NULL, 'TC001', '2023-02-20', '14:00:00', '16:00:00'),
    ('CL000003', 'CTM0001', 'I006', 'S102', 'TC001', '2023-02-20', '06:00:00', '08:00:00'),
    ('CL000004', 'CTM0002', 'I007', NULL, 'TC001', '2023-02-20', '14:00:00', '16:00:00'),
    ('CL000005', 'CTC0001', 'I011', 'S103', 'TC001', '2023-02-20', '06:00:00', '08:00:00'),
    ('CL000006', 'CTC0002', 'I012', NULL, 'TC001', '2023-02-20', '14:00:00', '16:00:00'),
    
    ('CL000007', 'CTA0001', 'I003', 'S104', 'TC002', '2023-02-20', '08:00:00', '10:00:00'),
    ('CL000008', 'CTA0002', 'I004', NULL, 'TC002', '2023-02-20', '16:00:00', '18:00:00'),
    ('CL000009', 'CTM0001', 'I008', 'S105', 'TC002', '2023-02-20', '08:00:00', '10:00:00'),
    ('CL000010', 'CTM0002', 'I009', NULL, 'TC002', '2023-02-20', '16:00:00', '18:00:00'),
    ('CL000011', 'CTC0001', 'I013', 'S201', 'TC002', '2023-02-20', '08:00:00', '10:00:00'),
    ('CL000012', 'CTC0002', 'I014', NULL, 'TC002', '2023-02-20', '16:00:00', '18:00:00'),
    
    ('CL000013', 'CTA0001', 'I005', 'S202', 'TC003', '2023-02-20', '10:00:00', '12:00:00'),
    ('CL000014', 'CTA0002', 'I001', NULL, 'TC003', '2023-02-20', '18:00:00', '20:00:00'),
    ('CL000015', 'CTM0001', 'I010', 'S203', 'TC003', '2023-02-20', '10:00:00', '12:00:00'),
    ('CL000016', 'CTM0002', 'I006', NULL, 'TC003', '2023-02-20', '18:00:00', '20:00:00'),
    ('CL000017', 'CTC0001', 'I015', 'S204', 'TC003', '2023-02-20', '10:00:00', '12:00:00'),
    ('CL000018', 'CTC0002', 'I011', NULL, 'TC003', '2023-02-20', '18:00:00', '20:00:00'),
    
    -- martes
    
    ('CL000019', 'CTA0001', 'I001', 'S205', 'TC004', '2023-02-21', '06:00:00', '08:00:00'),
    ('CL000020', 'CTA0002', 'I002', NULL, 'TC004', '2023-02-21', '14:00:00', '16:00:00'),
    ('CL000021', 'CTM0001', 'I006', 'S301', 'TC004', '2023-02-21', '06:00:00', '08:00:00'),
    ('CL000022', 'CTM0002', 'I007', NULL, 'TC004', '2023-02-21', '14:00:00', '16:00:00'),
    ('CL000023', 'CTC0001', 'I011', 'S302', 'TC004', '2023-02-21', '06:00:00', '08:00:00'),
    ('CL000024', 'CTC0002', 'I012', NULL, 'TC004', '2023-02-21', '14:00:00', '16:00:00'),
    
    ('CL000025', 'CTA0001', 'I003', 'S303', 'TC005', '2023-02-21', '08:00:00', '10:00:00'),
    ('CL000026', 'CTA0002', 'I004', NULL, 'TC005', '2023-02-21', '16:00:00', '18:00:00'),
    ('CL000027', 'CTM0001', 'I008', 'S304', 'TC005', '2023-02-21', '08:00:00', '10:00:00'),
    ('CL000028', 'CTM0002', 'I009', NULL, 'TC005', '2023-02-21', '16:00:00', '18:00:00'),
    ('CL000029', 'CTC0001', 'I013', 'S305', 'TC005', '2023-02-21', '08:00:00', '10:00:00'),
    ('CL000030', 'CTC0002', 'I014', NULL, 'TC005', '2023-02-21', '16:00:00', '18:00:00'),
    
    ('CL000031', 'CTA0001', 'I005', 'S101', 'TC006', '2023-02-21', '10:00:00', '12:00:00'),
    ('CL000032', 'CTA0002', 'I002', NULL, 'TC006', '2023-02-21', '18:00:00', '20:00:00'),
    ('CL000033', 'CTM0001', 'I010', 'S102', 'TC006', '2023-02-21', '10:00:00', '12:00:00'),
    ('CL000034', 'CTM0002', 'I007', NULL, 'TC006', '2023-02-21', '18:00:00', '20:00:00'),
    ('CL000035', 'CTC0001', 'I015', 'S103', 'TC006', '2023-02-21', '10:00:00', '12:00:00'),
    ('CL000036', 'CTC0002', 'I012', NULL, 'TC006', '2023-02-21', '18:00:00', '20:00:00'),
    
    -- miercoles
    
    ('CL000037', 'CTA0001', 'I001', 'S104', 'TC007', '2023-02-22', '06:00:00', '08:00:00'),
    ('CL000038', 'CTA0002', 'I002', NULL, 'TC007', '2023-02-22', '14:00:00', '16:00:00'),
    ('CL000039', 'CTM0001', 'I006', 'S105', 'TC007', '2023-02-22', '06:00:00', '08:00:00'),
    ('CL000040', 'CTM0002', 'I007', NULL, 'TC007', '2023-02-22', '14:00:00', '16:00:00'),
    ('CL000041', 'CTC0001', 'I011', 'S201', 'TC007', '2023-02-22', '06:00:00', '08:00:00'),
    ('CL000042', 'CTC0002', 'I012', NULL, 'TC007', '2023-02-22', '14:00:00', '16:00:00'),
    
    ('CL000043', 'CTA0001', 'I003', 'S202', 'TC008', '2023-02-22', '08:00:00', '10:00:00'),
    ('CL000044', 'CTA0002', 'I004', NULL, 'TC008', '2023-02-22', '16:00:00', '18:00:00'),
    ('CL000045', 'CTM0001', 'I008', 'S203', 'TC008', '2023-02-22', '08:00:00', '10:00:00'),
    ('CL000046', 'CTM0002', 'I009', NULL, 'TC008', '2023-02-22', '16:00:00', '18:00:00'),
    ('CL000047', 'CTC0001', 'I013', 'S204', 'TC008', '2023-02-22', '08:00:00', '10:00:00'),
    ('CL000048', 'CTC0002', 'I014', NULL, 'TC008', '2023-02-22', '16:00:00', '18:00:00'),
    
    ('CL000049', 'CTA0001', 'I005', 'S205', 'TC009', '2023-02-22', '10:00:00', '12:00:00'),
    ('CL000050', 'CTA0002', 'I003', NULL, 'TC009', '2023-02-22', '18:00:00', '20:00:00'),
    ('CL000051', 'CTM0001', 'I010', 'S301', 'TC009', '2023-02-22', '10:00:00', '12:00:00'),
    ('CL000052', 'CTM0002', 'I008', NULL, 'TC009', '2023-02-22', '18:00:00', '20:00:00'),
    ('CL000053', 'CTC0001', 'I015', 'S302', 'TC009', '2023-02-22', '10:00:00', '12:00:00'),
    ('CL000054', 'CTC0002', 'I013', NULL, 'TC009', '2023-02-22', '18:00:00', '20:00:00'),
    
    -- jueves
    
    ('CL000055', 'CTA0001', 'I001', 'S303', 'TC010', '2023-02-23', '06:00:00', '08:00:00'),
    ('CL000056', 'CTA0002', 'I002', NULL, 'TC010', '2023-02-23', '14:00:00', '16:00:00'),
    ('CL000057', 'CTM0001', 'I006', 'S304', 'TC010', '2023-02-23', '06:00:00', '08:00:00'),
    ('CL000058', 'CTM0002', 'I007', NULL, 'TC010', '2023-02-23', '14:00:00', '16:00:00'),
    ('CL000059', 'CTC0001', 'I011', 'S305', 'TC010', '2023-02-23', '06:00:00', '08:00:00'),
    ('CL000060', 'CTC0002', 'I012', NULL, 'TC010', '2023-02-23', '14:00:00', '16:00:00'),
    
    ('CL000061', 'CTA0001', 'I003', 'S101', 'TC011', '2023-02-23', '08:00:00', '10:00:00'),
    ('CL000062', 'CTA0002', 'I004', NULL, 'TC011', '2023-02-23', '16:00:00', '18:00:00'),
    ('CL000063', 'CTM0001', 'I008', 'S102', 'TC011', '2023-02-23', '08:00:00', '10:00:00'),
    ('CL000064', 'CTM0002', 'I009', NULL, 'TC011', '2023-02-23', '16:00:00', '18:00:00'),
    ('CL000065', 'CTC0001', 'I013', 'S103', 'TC011', '2023-02-23', '08:00:00', '10:00:00'),
    ('CL000066', 'CTC0002', 'I014', NULL, 'TC011', '2023-02-23', '16:00:00', '18:00:00'),
    
    ('CL000067', 'CTA0001', 'I005', 'S104', 'TC012', '2023-02-23', '10:00:00', '12:00:00'),
    ('CL000068', 'CTA0002', 'I004', NULL, 'TC012', '2023-02-23', '18:00:00', '20:00:00'),
    ('CL000069', 'CTM0001', 'I010', 'S105', 'TC012', '2023-02-23', '10:00:00', '12:00:00'),
    ('CL000070', 'CTM0002', 'I009', NULL, 'TC012', '2023-02-23', '18:00:00', '20:00:00'),
    ('CL000071', 'CTC0001', 'I015', 'S201', 'TC012', '2023-02-23', '10:00:00', '12:00:00'),
    ('CL000072', 'CTC0002', 'I014', NULL, 'TC012', '2023-02-23', '18:00:00', '20:00:00'),
    
    -- viernes
    
    ('CL000073', 'CTA0001', 'I001', 'S202', 'TC013', '2023-02-24', '06:00:00', '08:00:00'),
    ('CL000074', 'CTA0002', 'I002', NULL, 'TC013', '2023-02-24', '14:00:00', '16:00:00'),
    ('CL000075', 'CTM0001', 'I006', 'S203', 'TC013', '2023-02-24', '06:00:00', '08:00:00'),
    ('CL000076', 'CTM0002', 'I007', NULL, 'TC013', '2023-02-24', '14:00:00', '16:00:00'),
    ('CL000077', 'CTC0001', 'I011', 'S204', 'TC013', '2023-02-24', '06:00:00', '08:00:00'),
    ('CL000078', 'CTC0002', 'I012', NULL, 'TC013', '2023-02-24', '14:00:00', '16:00:00'),
    
    ('CL000079', 'CTA0001', 'I003', 'S205', 'TC014', '2023-02-24', '08:00:00', '10:00:00'),
    ('CL000080', 'CTA0002', 'I004', NULL, 'TC014', '2023-02-24', '16:00:00', '18:00:00'),
    ('CL000081', 'CTM0001', 'I008', 'S301', 'TC014', '2023-02-24', '08:00:00', '10:00:00'),
    ('CL000082', 'CTM0002', 'I009', NULL, 'TC014', '2023-02-24', '16:00:00', '18:00:00'),
    ('CL000083', 'CTC0001', 'I013', 'S302', 'TC014', '2023-02-24', '08:00:00', '10:00:00'),
    ('CL000084', 'CTC0002', 'I014', NULL, 'TC014', '2023-02-24', '16:00:00', '18:00:00'),
    
    ('CL000085', 'CTA0001', 'I005', 'S303', 'TC015', '2023-02-24', '10:00:00', '12:00:00'),
    ('CL000086', 'CTA0002', 'I005', NULL, 'TC015', '2023-02-24', '18:00:00', '20:00:00'),
    ('CL000087', 'CTM0001', 'I010', 'S304', 'TC015', '2023-02-24', '10:00:00', '12:00:00'),
    ('CL000088', 'CTM0002', 'I010', NULL, 'TC015', '2023-02-24', '18:00:00', '20:00:00'),
    ('CL000089', 'CTC0001', 'I015', 'S305', 'TC015', '2023-02-24', '10:00:00', '12:00:00'),
    ('CL000090', 'CTC0002', 'I015', NULL, 'TC015', '2023-02-24', '18:00:00', '20:00:00');

-- -------------- LECCIONES -------------------

INSERT INTO
    lecciones (id_leccion, id_curso_practico, cedula_instructor, placa_vehiculo, nro_tema_leccion, lugar_leccion, fecha_leccion, hora_inicio, hora_finalizacion)
VALUES
    -- ///////////// AUTOMOVILES /////////////
    
	-- lunes
    
    ('LE000001', 'CPA0001', 'I001', 'ABC-123', 'TL-A001', 'Parqueadero - Mall Unicentro', '2023-02-27', '06:00:00', '08:00:00'),
    ('LE000002', 'CPA0001', 'I002', 'DEF-234', 'TL-A001', 'Cancha - Colegio San Luis', '2023-02-27', '08:00:00', '10:00:00'),
    ('LE000003', 'CPA0001', 'I003', 'GHI-567', 'TL-A001', 'Cancha - Colegio San Marcel', '2023-02-27', '10:00:00', '12:00:00'),
    ('LE000004', 'CPA0001', 'I004', 'JKL-890', 'TL-A001', 'Parqueadero - Jardin Plaza', '2023-02-27', '12:00:00', '14:00:00'),
    ('LE000005', 'CPA0001', 'I005', 'MNO-345', 'TL-A001', 'Parqueadero - Unicentro', '2023-02-27', '14:00:00', '16:00:00'),
    ('LE000006', 'CPA0001', 'I001', 'PQR-678', 'TL-A001', 'Cancha - colegio Los Nogales', '2023-02-27', '16:00:00', '18:00:00'),
    ('LE000007', 'CPA0001', 'I002', 'STU-901', 'TL-A001', 'Cancha - colegio San Jorge', '2023-02-27', '18:00:00', '20:00:00'),
    
	-- martes
    
    ('LE000008', 'CPA0001', 'I003', 'ABC-123', 'TL-A002', 'Parqueadero - Mall Unicentro', '2023-02-28', '06:00:00', '08:00:00'),
    ('LE000009', 'CPA0001', 'I004', 'DEF-234', 'TL-A002', 'Cancha - Colegio San Luis', '2023-02-28', '08:00:00', '10:00:00'),
    ('LE000010', 'CPA0001', 'I005', 'GHI-567', 'TL-A002', 'Cancha - Colegio San Marcel', '2023-02-28', '10:00:00', '12:00:00'),
    ('LE000011', 'CPA0001', 'I001', 'JKL-890', 'TL-A002', 'Parqueadero - Jardin Plaza', '2023-02-28', '12:00:00', '14:00:00'),
    ('LE000012', 'CPA0001', 'I002', 'MNO-345', 'TL-A002', 'Parqueadero - Unicentro', '2023-02-28', '14:00:00', '16:00:00'),
    ('LE000013', 'CPA0001', 'I003', 'PQR-678', 'TL-A002', 'Cancha - colegio Los Nogales', '2023-02-28', '16:00:00', '18:00:00'),
    ('LE000014', 'CPA0001', 'I004', 'STU-901', 'TL-A002', 'Cancha - colegio San Jorge', '2023-02-28', '18:00:00', '20:00:00'),
    
    -- miercoles
    
    ('LE000015', 'CPA0001', 'I005', 'ABC-123', 'TL-A003', 'Parqueadero - Mall Unicentro', '2023-03-01', '06:00:00', '08:00:00'),
    ('LE000016', 'CPA0001', 'I001', 'DEF-234', 'TL-A003', 'Cancha - Colegio San Luis', '2023-03-01', '08:00:00', '10:00:00'),
    ('LE000017', 'CPA0001', 'I002', 'GHI-567', 'TL-A003', 'Cancha - Colegio San Marcel', '2023-03-01', '10:00:00', '12:00:00'),
    ('LE000018', 'CPA0001', 'I003', 'JKL-890', 'TL-A003', 'Parqueadero - Jardin Plaza', '2023-03-01', '12:00:00', '14:00:00'),
    ('LE000019', 'CPA0001', 'I004', 'MNO-345', 'TL-A003', 'Parqueadero - Unicentro', '2023-03-01', '14:00:00', '16:00:00'),
    ('LE000020', 'CPA0001', 'I005', 'PQR-678', 'TL-A003', 'Cancha - colegio Los Nogales', '2023-03-01', '16:00:00', '18:00:00'),
    ('LE000021', 'CPA0001', 'I001', 'STU-901', 'TL-A003', 'Cancha - colegio San Jorge', '2023-03-01', '18:00:00', '20:00:00'),
    
    -- jueves
    ('LE000022', 'CPA0001', 'I002', 'ABC-123', 'TL-A004', 'Parqueadero - Mall Unicentro', '2023-03-02', '06:00:00', '08:00:00'),
    ('LE000023', 'CPA0001', 'I003', 'DEF-234', 'TL-A004', 'Cancha - Colegio San Luis', '2023-03-02', '08:00:00', '10:00:00'),
    ('LE000024', 'CPA0001', 'I004', 'GHI-567', 'TL-A004', 'Cancha - Colegio San Marcel', '2023-03-02', '10:00:00', '12:00:00'),
    ('LE000025', 'CPA0001', 'I005', 'JKL-890', 'TL-A004', 'Parqueadero - Jardin Plaza', '2023-03-02', '12:00:00', '14:00:00'),
    ('LE000026', 'CPA0001', 'I001', 'MNO-345', 'TL-A004', 'Parqueadero - Unicentro', '2023-03-02', '14:00:00', '16:00:00'),
    ('LE000027', 'CPA0001', 'I002', 'PQR-678', 'TL-A004', 'Cancha - colegio Los Nogales', '2023-03-02', '16:00:00', '18:00:00'),
    ('LE000028', 'CPA0001', 'I003', 'STU-901', 'TL-A004', 'Cancha - colegio San Jorge', '2023-03-02', '18:00:00', '20:00:00'),
    
        -- viernes
    ('LE000029', 'CPA0001', 'I004', 'ABC-123', 'TL-A005', 'Parqueadero - Mall Unicentro', '2023-03-03', '06:00:00', '08:00:00'),
    ('LE000030', 'CPA0001', 'I005', 'DEF-234', 'TL-A005', 'Cancha - Colegio San Luis', '2023-03-03', '08:00:00', '10:00:00'),
    ('LE000031', 'CPA0001', 'I001', 'GHI-567', 'TL-A005', 'Cancha - Colegio San Marcel', '2023-03-03', '10:00:00', '12:00:00'),
    ('LE000032', 'CPA0001', 'I002', 'JKL-890', 'TL-A005', 'Parqueadero - Jardin Plaza', '2023-03-03', '12:00:00', '14:00:00'),
    ('LE000033', 'CPA0001', 'I003', 'MNO-345', 'TL-A005', 'Parqueadero - Unicentro', '2023-03-03', '14:00:00', '16:00:00'),
    ('LE000034', 'CPA0001', 'I004', 'PQR-678', 'TL-A005', 'Cancha - colegio Los Nogales', '2023-03-03', '16:00:00', '18:00:00'),
    ('LE000035', 'CPA0001', 'I005', 'STU-901', 'TL-A005', 'Cancha - colegio San Jorge', '2023-03-03', '18:00:00', '20:00:00'),

    -- lunes
    ('LE000036', 'CPA0001', 'I001', 'ABC-123', 'TL-A006', 'Parqueadero - Mall Unicentro', '2023-03-06', '06:00:00', '08:00:00'),
    ('LE000037', 'CPA0001', 'I002', 'DEF-234', 'TL-A006', 'Cancha - Colegio San Luis', '2023-03-06', '08:00:00', '10:00:00'),
    ('LE000038', 'CPA0001', 'I003', 'GHI-567', 'TL-A006', 'Cancha - Colegio San Marcel', '2023-03-06', '10:00:00', '12:00:00'),
    ('LE000039', 'CPA0001', 'I004', 'JKL-890', 'TL-A006', 'Parqueadero - Jardin Plaza', '2023-03-06', '12:00:00', '14:00:00'),
    ('LE000040', 'CPA0001', 'I005', 'MNO-345', 'TL-A006', 'Parqueadero - Unicentro', '2023-03-06', '14:00:00', '16:00:00'),
    ('LE000041', 'CPA0001', 'I001', 'PQR-678', 'TL-A006', 'Cancha - colegio Los Nogales', '2023-03-06', '16:00:00', '18:00:00'),
    ('LE000042', 'CPA0001', 'I002', 'STU-901', 'TL-A006', 'Cancha - colegio San Jorge', '2023-03-06', '18:00:00', '20:00:00'),

    -- martes
    ('LE000043', 'CPA0001', 'I003', 'ABC-123', 'TL-A007', 'Parqueadero - Mall Unicentro', '2023-03-07', '06:00:00', '08:00:00'),
    ('LE000044', 'CPA0001', 'I004', 'DEF-234', 'TL-A007', 'Cancha - Colegio San Luis', '2023-03-07', '08:00:00', '10:00:00'),
    ('LE000045', 'CPA0001', 'I005', 'GHI-567', 'TL-A007', 'Cancha - Colegio San Marcel', '2023-03-07', '10:00:00', '12:00:00'),
    ('LE000046', 'CPA0001', 'I001', 'JKL-890', 'TL-A007', 'Parqueadero - Jardin Plaza', '2023-03-07', '12:00:00', '14:00:00'),
    ('LE000047', 'CPA0001', 'I002', 'MNO-345', 'TL-A007', 'Parqueadero - Unicentro', '2023-03-07', '14:00:00', '16:00:00'),
    ('LE000048', 'CPA0001', 'I003', 'PQR-678', 'TL-A007', 'Cancha - colegio Los Nogales', '2023-03-07', '16:00:00', '18:00:00'),
    ('LE000049', 'CPA0001', 'I004', 'STU-901', 'TL-A007', 'Cancha - colegio San Jorge', '2023-03-07', '18:00:00', '20:00:00'),
    
    -- miércoles
    ('LE000050', 'CPA0001', 'I005', 'ABC-123', 'TL-A008', 'Parqueadero - Mall Unicentro', '2023-03-08', '06:00:00', '08:00:00'),
    ('LE000051', 'CPA0001', 'I001', 'DEF-234', 'TL-A008', 'Cancha - Colegio San Luis', '2023-03-08', '08:00:00', '10:00:00'),
    ('LE000052', 'CPA0001', 'I002', 'GHI-567', 'TL-A008', 'Cancha - Colegio San Marcel', '2023-03-08', '10:00:00', '12:00:00'),
    ('LE000053', 'CPA0001', 'I003', 'JKL-890', 'TL-A008', 'Parqueadero - Jardin Plaza', '2023-03-08', '12:00:00', '14:00:00'),
    ('LE000054', 'CPA0001', 'I004', 'MNO-345', 'TL-A008', 'Parqueadero - Unicentro', '2023-03-08', '14:00:00', '16:00:00'),
    ('LE000055', 'CPA0001', 'I005', 'PQR-678', 'TL-A008', 'Cancha - colegio Los Nogales', '2023-03-08', '16:00:00', '18:00:00'),
    ('LE000056', 'CPA0001', 'I001', 'STU-901', 'TL-A008', 'Cancha - colegio San Jorge', '2023-03-08', '18:00:00', '20:00:00'),

    -- jueves
    ('LE000057', 'CPA0001', 'I002', 'ABC-123', 'TL-A009', 'Parqueadero - Mall Unicentro', '2023-03-09', '06:00:00', '08:00:00'),
    ('LE000058', 'CPA0001', 'I003', 'DEF-234', 'TL-A009', 'Cancha - Colegio San Luis', '2023-03-09', '08:00:00', '10:00:00'),
    ('LE000059', 'CPA0001', 'I004', 'GHI-567', 'TL-A009', 'Cancha - Colegio San Marcel', '2023-03-09', '10:00:00', '12:00:00'),
    ('LE000060', 'CPA0001', 'I005', 'JKL-890', 'TL-A009', 'Parqueadero - Jardin Plaza', '2023-03-09', '12:00:00', '14:00:00'),
    ('LE000061', 'CPA0001', 'I001', 'MNO-345', 'TL-A009', 'Parqueadero - Unicentro', '2023-03-09', '14:00:00', '16:00:00'),
    ('LE000062', 'CPA0001', 'I002', 'PQR-678', 'TL-A009', 'Cancha - colegio Los Nogales', '2023-03-09', '16:00:00', '18:00:00'),
    ('LE000063', 'CPA0001', 'I003', 'STU-901', 'TL-A009', 'Cancha - colegio San Jorge', '2023-03-09', '18:00:00', '20:00:00'),

    -- viernes
    ('LE000064', 'CPA0001', 'I004', 'ABC-123', 'TL-A010', 'Parqueadero - Mall Unicentro', '2023-03-10', '06:00:00', '08:00:00'),
    ('LE000065', 'CPA0001', 'I005', 'DEF-234', 'TL-A010', 'Cancha - Colegio San Luis', '2023-03-10', '08:00:00', '10:00:00'),
    ('LE000066', 'CPA0001', 'I001', 'GHI-567', 'TL-A010', 'Cancha - Colegio San Marcel', '2023-03-10', '10:00:00', '12:00:00'),
    ('LE000067', 'CPA0001', 'I002', 'JKL-890', 'TL-A010', 'Parqueadero - Jardin Plaza', '2023-03-10', '12:00:00', '14:00:00'),
    ('LE000068', 'CPA0001', 'I003', 'MNO-345', 'TL-A010', 'Parqueadero - Unicentro', '2023-03-10', '14:00:00', '16:00:00'),
    ('LE000069', 'CPA0001', 'I004', 'PQR-678', 'TL-A010', 'Cancha - colegio Los Nogales', '2023-03-10', '16:00:00', '18:00:00'),
    ('LE000070', 'CPA0001', 'I005', 'STU-901', 'TL-A010', 'Cancha - colegio San Jorge', '2023-03-10', '18:00:00', '20:00:00'),
    
    -- ///////////// MOTOCICLETAS /////////////

	-- lunes
    
    ('LE000071', 'CPM0001', 'I006', 'VWX-234', 'TL-M001', 'Cancha - colegio Los Nogales', '2023-02-27', '06:00:00', '08:00:00'),
    ('LE000072', 'CPM0001', 'I007', 'XYZ-456', 'TL-M001', 'Parqueadero - Mall Unicentro', '2023-02-27', '08:00:00', '10:00:00'),
    ('LE000073', 'CPM0001', 'I008', 'YZA-567', 'TL-M001', 'Parqueadero - Jardin Plaza', '2023-02-27', '10:00:00', '12:00:00'),
    ('LE000074', 'CPM0001', 'I009', 'BCD-890', 'TL-M001', 'Cancha - Colegio San Marcel', '2023-02-27', '12:00:00', '14:00:00'),
    ('LE000075', 'CPM0001', 'I010', 'EFG-123', 'TL-M001', 'Cancha - colegio Los Nogales', '2023-02-27', '14:00:00', '16:00:00'),
    ('LE000076', 'CPM0001', 'I006', 'HIJ-456', 'TL-M001', 'Cancha - colegio San Jorge', '2023-02-27', '16:00:00', '18:00:00'),
    ('LE000077', 'CPM0001', 'I007', 'KLM-789', 'TL-M001', 'Parqueadero - Unicentro', '2023-02-27', '18:00:00', '20:00:00'),
    
    -- martes
    
    ('LE000078', 'CPM0001', 'I008', 'VWX-234', 'TL-M002', 'Cancha - colegio Los Nogales', '2023-02-28', '06:00:00', '08:00:00'),
    ('LE000079', 'CPM0001', 'I009', 'XYZ-456', 'TL-M002', 'Parqueadero - Mall Unicentro', '2023-02-28', '08:00:00', '10:00:00'),
    ('LE000080', 'CPM0001', 'I010', 'YZA-567', 'TL-M002', 'Parqueadero - Jardin Plaza', '2023-02-28', '10:00:00', '12:00:00'),
    ('LE000081', 'CPM0001', 'I006', 'BCD-890', 'TL-M002', 'Cancha - Colegio San Marcel', '2023-02-28', '12:00:00', '14:00:00'),
    ('LE000082', 'CPM0001', 'I007', 'EFG-123', 'TL-M002', 'Cancha - colegio Los Nogales', '2023-02-28', '14:00:00', '16:00:00'),
    ('LE000083', 'CPM0001', 'I008', 'HIJ-456', 'TL-M002', 'Cancha - colegio San Jorge', '2023-02-28', '16:00:00', '18:00:00'),
    ('LE000084', 'CPM0001', 'I009', 'KLM-789', 'TL-M002', 'Parqueadero - Unicentro', '2023-02-28', '18:00:00', '20:00:00'),
    
    -- miercoles
    
    ('LE000085', 'CPM0001', 'I010', 'VWX-234', 'TL-M003', 'Cancha - colegio Los Nogales', '2023-03-01', '06:00:00', '08:00:00'),
    ('LE000086', 'CPM0001', 'I006', 'XYZ-456', 'TL-M003', 'Parqueadero - Mall Unicentro', '2023-03-01', '08:00:00', '10:00:00'),
    ('LE000087', 'CPM0001', 'I007', 'YZA-567', 'TL-M003', 'Parqueadero - Jardin Plaza', '2023-03-01', '10:00:00', '12:00:00'),
    ('LE000088', 'CPM0001', 'I008', 'BCD-890', 'TL-M003', 'Cancha - Colegio San Marcel', '2023-03-01', '12:00:00', '14:00:00'),
    ('LE000089', 'CPM0001', 'I009', 'EFG-123', 'TL-M003', 'Cancha - colegio Los Nogales', '2023-03-01', '14:00:00', '16:00:00'),
    ('LE000090', 'CPM0001', 'I010', 'HIJ-456', 'TL-M003', 'Cancha - colegio San Jorge', '2023-03-01', '16:00:00', '18:00:00'),
    ('LE000091', 'CPM0001', 'I006', 'KLM-789', 'TL-M003', 'Parqueadero - Unicentro', '2023-03-01', '18:00:00', '20:00:00'),
    
    -- jueves
    ('LE000092', 'CPM0001', 'I007', 'VWX-234', 'TL-M004', 'Cancha - colegio Los Nogales', '2023-03-02', '06:00:00', '08:00:00'),
    ('LE000093', 'CPM0001', 'I008', 'XYZ-456', 'TL-M004', 'Parqueadero - Mall Unicentro', '2023-03-02', '08:00:00', '10:00:00'),
    ('LE000094', 'CPM0001', 'I009', 'YZA-567', 'TL-M004', 'Parqueadero - Jardin Plaza', '2023-03-02', '10:00:00', '12:00:00'),
    ('LE000095', 'CPM0001', 'I010', 'BCD-890', 'TL-M004', 'Cancha - Colegio San Marcel', '2023-03-02', '12:00:00', '14:00:00'),
    ('LE000096', 'CPM0001', 'I006', 'EFG-123', 'TL-M004', 'Cancha - colegio Los Nogales', '2023-03-02', '14:00:00', '16:00:00'),
    ('LE000097', 'CPM0001', 'I007', 'HIJ-456', 'TL-M004', 'Cancha - colegio San Jorge', '2023-03-02', '16:00:00', '18:00:00'),
    ('LE000098', 'CPM0001', 'I008', 'KLM-789', 'TL-M004', 'Parqueadero - Unicentro', '2023-03-02', '18:00:00', '20:00:00'),

    -- viernes
    ('LE000099', 'CPM0001', 'I009', 'VWX-234', 'TL-M005', 'Cancha - colegio Los Nogales', '2023-03-03', '06:00:00', '08:00:00'),
    ('LE000100', 'CPM0001', 'I010', 'XYZ-456', 'TL-M005', 'Parqueadero - Mall Unicentro', '2023-03-03', '08:00:00', '10:00:00'),
    ('LE000101', 'CPM0001', 'I006', 'YZA-567', 'TL-M005', 'Parqueadero - Jardin Plaza', '2023-03-03', '10:00:00', '12:00:00'),
    ('LE000102', 'CPM0001', 'I007', 'BCD-890', 'TL-M005', 'Cancha - Colegio San Marcel', '2023-03-03', '12:00:00', '14:00:00'),
    ('LE000103', 'CPM0001', 'I008', 'EFG-123', 'TL-M005', 'Cancha - colegio Los Nogales', '2023-03-03', '14:00:00', '16:00:00'),
    ('LE000104', 'CPM0001', 'I009', 'HIJ-456', 'TL-M005', 'Cancha - colegio San Jorge', '2023-03-03', '16:00:00', '18:00:00'),
    ('LE000105', 'CPM0001', 'I010', 'KLM-789', 'TL-M005', 'Parqueadero - Unicentro', '2023-03-03', '18:00:00', '20:00:00'),

    -- lunes
    ('LE000106', 'CPM0001', 'I006', 'VWX-234', 'TL-M006', 'Cancha - colegio Los Nogales', '2023-03-06', '06:00:00', '08:00:00'),
    ('LE000107', 'CPM0001', 'I007', 'XYZ-456', 'TL-M006', 'Parqueadero - Mall Unicentro', '2023-03-06', '08:00:00', '10:00:00'),
    ('LE000108', 'CPM0001', 'I008', 'YZA-567', 'TL-M006', 'Parqueadero - Jardin Plaza', '2023-03-06', '10:00:00', '12:00:00'),
    ('LE000109', 'CPM0001', 'I009', 'BCD-890', 'TL-M006', 'Cancha - Colegio San Marcel', '2023-03-06', '12:00:00', '14:00:00'),
    ('LE000110', 'CPM0001', 'I010', 'EFG-123', 'TL-M006', 'Cancha - colegio Los Nogales', '2023-03-06', '14:00:00', '16:00:00'),
    ('LE000111', 'CPM0001', 'I006', 'HIJ-456', 'TL-M006', 'Cancha - colegio San Jorge', '2023-03-06', '16:00:00', '18:00:00'),
    ('LE000112', 'CPM0001', 'I007', 'KLM-789', 'TL-M006', 'Parqueadero - Unicentro', '2023-03-06', '18:00:00', '20:00:00'),
    
    -- martes
    ('LE000113', 'CPM0001', 'I008', 'VWX-234', 'TL-M007', 'Cancha - colegio Los Nogales', '2023-03-07', '06:00:00', '08:00:00'),
    ('LE000114', 'CPM0001', 'I009', 'XYZ-456', 'TL-M007', 'Parqueadero - Mall Unicentro', '2023-03-07', '08:00:00', '10:00:00'),
    ('LE000115', 'CPM0001', 'I010', 'YZA-567', 'TL-M007', 'Parqueadero - Jardin Plaza', '2023-03-07', '10:00:00', '12:00:00'),
    ('LE000116', 'CPM0001', 'I006', 'BCD-890', 'TL-M007', 'Cancha - Colegio San Marcel', '2023-03-07', '12:00:00', '14:00:00'),
    ('LE000117', 'CPM0001', 'I007', 'EFG-123', 'TL-M007', 'Cancha - colegio Los Nogales', '2023-03-07', '14:00:00', '16:00:00'),
    ('LE000118', 'CPM0001', 'I008', 'HIJ-456', 'TL-M007', 'Cancha - colegio San Jorge', '2023-03-07', '16:00:00', '18:00:00'),
    ('LE000119', 'CPM0001', 'I009', 'KLM-789', 'TL-M007', 'Parqueadero - Unicentro', '2023-03-07', '18:00:00', '20:00:00'),
    
    -- miércoles
    ('LE000120', 'CPM0001', 'I010', 'VWX-234', 'TL-M008', 'Cancha - colegio Los Nogales', '2023-03-08', '06:00:00', '08:00:00'),
    ('LE000121', 'CPM0001', 'I006', 'XYZ-456', 'TL-M008', 'Parqueadero - Mall Unicentro', '2023-03-08', '08:00:00', '10:00:00'),
    ('LE000122', 'CPM0001', 'I007', 'YZA-567', 'TL-M008', 'Parqueadero - Jardin Plaza', '2023-03-08', '10:00:00', '12:00:00'),
    ('LE000123', 'CPM0001', 'I008', 'BCD-890', 'TL-M008', 'Cancha - Colegio San Marcel', '2023-03-08', '12:00:00', '14:00:00'),
    ('LE000124', 'CPM0001', 'I009', 'EFG-123', 'TL-M008', 'Cancha - colegio Los Nogales', '2023-03-08', '14:00:00', '16:00:00'),
    ('LE000125', 'CPM0001', 'I010', 'HIJ-456', 'TL-M008', 'Cancha - colegio San Jorge', '2023-03-08', '16:00:00', '18:00:00'),
    ('LE000126', 'CPM0001', 'I006', 'KLM-789', 'TL-M008', 'Parqueadero - Unicentro', '2023-03-08', '18:00:00', '20:00:00'),

    -- jueves
    ('LE000127', 'CPM0001', 'I007', 'VWX-234', 'TL-M009', 'Cancha - colegio Los Nogales', '2023-03-09', '06:00:00', '08:00:00'),
    ('LE000128', 'CPM0001', 'I008', 'XYZ-456', 'TL-M009', 'Parqueadero - Mall Unicentro', '2023-03-09', '08:00:00', '10:00:00'),
    ('LE000129', 'CPM0001', 'I009', 'YZA-567', 'TL-M009', 'Parqueadero - Jardin Plaza', '2023-03-09', '10:00:00', '12:00:00'),
    ('LE000130', 'CPM0001', 'I010', 'BCD-890', 'TL-M009', 'Cancha - Colegio San Marcel', '2023-03-09', '12:00:00', '14:00:00'),
    ('LE000131', 'CPM0001', 'I006', 'EFG-123', 'TL-M009', 'Cancha - colegio Los Nogales', '2023-03-09', '14:00:00', '16:00:00'),
    ('LE000132', 'CPM0001', 'I007', 'HIJ-456', 'TL-M009', 'Cancha - colegio San Jorge', '2023-03-09', '16:00:00', '18:00:00'),
    ('LE000133', 'CPM0001', 'I008', 'KLM-789', 'TL-M009', 'Parqueadero - Unicentro', '2023-03-09', '18:00:00', '20:00:00'),

    -- viernes
    ('LE000134', 'CPM0001', 'I009', 'VWX-234', 'TL-M010', 'Cancha - colegio Los Nogales', '2023-03-10', '06:00:00', '08:00:00'),
    ('LE000135', 'CPM0001', 'I010', 'XYZ-456', 'TL-M010', 'Parqueadero - Mall Unicentro', '2023-03-10', '08:00:00', '10:00:00'),
    ('LE000136', 'CPM0001', 'I006', 'YZA-567', 'TL-M010', 'Parqueadero - Jardin Plaza', '2023-03-10', '10:00:00', '12:00:00'),
    ('LE000137', 'CPM0001', 'I007', 'BCD-890', 'TL-M010', 'Cancha - Colegio San Marcel', '2023-03-10', '12:00:00', '14:00:00'),
    ('LE000138', 'CPM0001', 'I008', 'EFG-123', 'TL-M010', 'Cancha - colegio Los Nogales', '2023-03-10', '14:00:00', '16:00:00'),
    ('LE000139', 'CPM0001', 'I009', 'HIJ-456', 'TL-M010', 'Cancha - colegio San Jorge', '2023-03-10', '16:00:00', '18:00:00'),
    ('LE000140', 'CPM0001', 'I010', 'KLM-789', 'TL-M010', 'Parqueadero - Unicentro', '2023-03-10', '18:00:00', '20:00:00'),
    
    -- ///////////// CAMIONES /////////////
    
    -- lunes
    
    ('LE000141', 'CPC0001', 'I011', 'NOP-234', 'TL-C001', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-02-27', '06:00:00', '08:00:00'),
    ('LE000142', 'CPC0001', 'I012', 'QRS-567', 'TL-C001', 'Instalaciones de Enseñanza TransporteXpress', '2023-02-27', '08:00:00', '10:00:00'),
    ('LE000143', 'CPC0001', 'I013', 'TUV-890', 'TL-C001', 'Pista de entrenamiento TruckPilot', '2023-02-27', '10:00:00', '12:00:00'),
    ('LE000144', 'CPC0001', 'I014', 'WXY-123', 'TL-C001', 'Centro Logístico CaminoReal', '2023-02-27', '12:00:00', '14:00:00'),
    ('LE000145', 'CPC0001', 'I015', 'ZAB-456', 'TL-C001', 'Terrenos de pruebas CargaMax', '2023-02-27', '14:00:00', '16:00:00'),
    ('LE000146', 'CPC0001', 'I011', 'CDE-789', 'TL-C001', 'Terrenos de pruebas Ruta 66', '2023-02-27', '16:00:00', '18:00:00'),
    
    -- martes
    
    ('LE000147', 'CPC0001', 'I012', 'QRS-101', 'TL-C002', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-02-28', '06:00:00', '08:00:00'),
    ('LE000148', 'CPC0001', 'I013', 'NOP-234', 'TL-C002', 'Instalaciones de Enseñanza TransporteXpress', '2023-02-28', '08:00:00', '10:00:00'),
    ('LE000149', 'CPC0001', 'I014', 'QRS-567', 'TL-C002', 'Pista de entrenamiento TruckPilot', '2023-02-28', '10:00:00', '12:00:00'),
    ('LE000150', 'CPC0001', 'I015', 'TUV-890', 'TL-C002', 'Centro Logístico CaminoReal', '2023-02-28', '12:00:00', '14:00:00'),
    ('LE000151', 'CPC0001', 'I011', 'WXY-123', 'TL-C002', 'Terrenos de pruebas CargaMax', '2023-02-28', '14:00:00', '16:00:00'),
    ('LE000152', 'CPC0001', 'I012', 'ZAB-456', 'TL-C002', 'Terrenos de pruebas Ruta 66', '2023-02-28', '16:00:00', '18:00:00'),
    
	-- miercoles
    
    ('LE000153', 'CPC0001', 'I013', 'CDE-789', 'TL-C003', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-01', '06:00:00', '08:00:00'),
    ('LE000154', 'CPC0001', 'I014', 'QRS-101', 'TL-C003', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-01', '08:00:00', '10:00:00'),
    ('LE000155', 'CPC0001', 'I015', 'NOP-234', 'TL-C003', 'Pista de entrenamiento TruckPilot', '2023-03-01', '10:00:00', '12:00:00'),
    ('LE000156', 'CPC0001', 'I011', 'QRS-567', 'TL-C003', 'Centro Logístico CaminoReal', '2023-03-01', '12:00:00', '14:00:00'),
    ('LE000157', 'CPC0001', 'I012', 'TUV-890', 'TL-C003', 'Terrenos de pruebas CargaMax', '2023-03-01', '14:00:00', '16:00:00'),
    ('LE000158', 'CPC0001', 'I013', 'WXY-123', 'TL-C003', 'Terrenos de pruebas Ruta 66', '2023-03-01', '16:00:00', '18:00:00'),
    
	-- jueves
    ('LE000159', 'CPC0001', 'I014', 'ZAB-456', 'TL-C004', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-02', '06:00:00', '08:00:00'),
    ('LE000160', 'CPC0001', 'I015', 'CDE-789', 'TL-C004', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-02', '08:00:00', '10:00:00'),
    ('LE000161', 'CPC0001', 'I011', 'QRS-101', 'TL-C004', 'Pista de entrenamiento TruckPilot', '2023-03-02', '10:00:00', '12:00:00'),
    ('LE000162', 'CPC0001', 'I012', 'NOP-234', 'TL-C004', 'Centro Logístico CaminoReal', '2023-03-02', '12:00:00', '14:00:00'),
    ('LE000163', 'CPC0001', 'I013', 'QRS-567', 'TL-C004', 'Terrenos de pruebas CargaMax', '2023-03-02', '14:00:00', '16:00:00'),
    ('LE000164', 'CPC0001', 'I014', 'TUV-890', 'TL-C004', 'Terrenos de pruebas Ruta 66', '2023-03-02', '16:00:00', '18:00:00'),
    
    -- viernes
    ('LE000165', 'CPC0001', 'I015', 'WXY-123', 'TL-C005', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-03', '06:00:00', '08:00:00'),
    ('LE000166', 'CPC0001', 'I011', 'ZAB-456', 'TL-C005', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-03', '08:00:00', '10:00:00'),
    ('LE000167', 'CPC0001', 'I012', 'CDE-789', 'TL-C005', 'Pista de entrenamiento TruckPilot', '2023-03-03', '10:00:00', '12:00:00'),
    ('LE000168', 'CPC0001', 'I013', 'QRS-101', 'TL-C005', 'Centro Logístico CaminoReal', '2023-03-03', '12:00:00', '14:00:00'),
    ('LE000169', 'CPC0001', 'I014', 'NOP-234', 'TL-C005', 'Terrenos de pruebas CargaMax', '2023-03-03', '14:00:00', '16:00:00'),
    ('LE000170', 'CPC0001', 'I015', 'QRS-567', 'TL-C005', 'Terrenos de pruebas Ruta 66', '2023-03-03', '16:00:00', '18:00:00'),

    -- lunes
    ('LE000171', 'CPC0001', 'I011', 'TUV-890', 'TL-C006', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-06', '06:00:00', '08:00:00'),
    ('LE000172', 'CPC0001', 'I012', 'WXY-123', 'TL-C006', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-06', '08:00:00', '10:00:00'),
    ('LE000173', 'CPC0001', 'I013', 'ZAB-456', 'TL-C006', 'Pista de entrenamiento TruckPilot', '2023-03-06', '10:00:00', '12:00:00'),
    ('LE000174', 'CPC0001', 'I014', 'CDE-789', 'TL-C006', 'Centro Logístico CaminoReal', '2023-03-06', '12:00:00', '14:00:00'),
    ('LE000175', 'CPC0001', 'I015', 'QRS-101', 'TL-C006', 'Terrenos de pruebas CargaMax', '2023-03-06', '14:00:00', '16:00:00'),
    ('LE000176', 'CPC0001', 'I011', 'NOP-234', 'TL-C006', 'Terrenos de pruebas Ruta 66', '2023-03-06', '16:00:00', '18:00:00'),

    -- martes
    ('LE000177', 'CPC0001', 'I012', 'QRS-567', 'TL-C007', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-07', '06:00:00', '08:00:00'),
    ('LE000178', 'CPC0001', 'I013', 'TUV-890', 'TL-C007', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-07', '08:00:00', '10:00:00'),
    ('LE000179', 'CPC0001', 'I014', 'WXY-123', 'TL-C007', 'Pista de entrenamiento TruckPilot', '2023-03-07', '10:00:00', '12:00:00'),
    ('LE000180', 'CPC0001', 'I015', 'ZAB-456', 'TL-C007', 'Centro Logístico CaminoReal', '2023-03-07', '12:00:00', '14:00:00'),
    ('LE000181', 'CPC0001', 'I011', 'CDE-789', 'TL-C007', 'Terrenos de pruebas CargaMax', '2023-03-07', '14:00:00', '16:00:00'),
    ('LE000182', 'CPC0001', 'I012', 'QRS-101', 'TL-C007', 'Terrenos de pruebas Ruta 66', '2023-03-07', '16:00:00', '18:00:00'),
    
	-- miércoles
    ('LE000183', 'CPC0001', 'I013', 'NOP-234', 'TL-C008', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-08', '06:00:00', '08:00:00'),
    ('LE000184', 'CPC0001', 'I014', 'QRS-567', 'TL-C008', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-08', '08:00:00', '10:00:00'),
    ('LE000185', 'CPC0001', 'I015', 'TUV-890', 'TL-C008', 'Pista de entrenamiento TruckPilot', '2023-03-08', '10:00:00', '12:00:00'),
    ('LE000186', 'CPC0001', 'I011', 'WXY-123', 'TL-C008', 'Centro Logístico CaminoReal', '2023-03-08', '12:00:00', '14:00:00'),
    ('LE000187', 'CPC0001', 'I012', 'ZAB-456', 'TL-C008', 'Terrenos de pruebas CargaMax', '2023-03-08', '14:00:00', '16:00:00'),
    ('LE000188', 'CPC0001', 'I013', 'CDE-789', 'TL-C008', 'Terrenos de pruebas Ruta 66', '2023-03-08', '16:00:00', '18:00:00'),

    -- jueves
    ('LE000189', 'CPC0001', 'I014', 'QRS-101', 'TL-C009', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-09', '06:00:00', '08:00:00'),
    ('LE000190', 'CPC0001', 'I015', 'NOP-234', 'TL-C009', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-09', '08:00:00', '10:00:00'),
    ('LE000191', 'CPC0001', 'I011', 'QRS-567', 'TL-C009', 'Pista de entrenamiento TruckPilot', '2023-03-09', '10:00:00', '12:00:00'),
    ('LE000192', 'CPC0001', 'I012', 'TUV-890', 'TL-C009', 'Centro Logístico CaminoReal', '2023-03-09', '12:00:00', '14:00:00'),
    ('LE000193', 'CPC0001', 'I013', 'WXY-123', 'TL-C009', 'Terrenos de pruebas CargaMax', '2023-03-09', '14:00:00', '16:00:00'),
    ('LE000194', 'CPC0001', 'I014', 'ZAB-456', 'TL-C009', 'Terrenos de pruebas Ruta 66', '2023-03-09', '16:00:00', '18:00:00'),

    -- viernes
    ('LE000195', 'CPC0001', 'I015', 'CDE-789', 'TL-C010', 'Complejo de Entrenamiento de Camiones DeltaLogix', '2023-03-10', '06:00:00', '08:00:00'),
    ('LE000196', 'CPC0001', 'I011', 'QRS-101', 'TL-C010', 'Instalaciones de Enseñanza TransporteXpress', '2023-03-10', '08:00:00', '10:00:00'),
    ('LE000197', 'CPC0001', 'I012', 'NOP-234', 'TL-C010', 'Pista de entrenamiento TruckPilot', '2023-03-10', '10:00:00', '12:00:00'),
    ('LE000198', 'CPC0001', 'I013', 'QRS-567', 'TL-C010', 'Centro Logístico CaminoReal', '2023-03-10', '12:00:00', '14:00:00'),
    ('LE000199', 'CPC0001', 'I014', 'TUV-890', 'TL-C010', 'Terrenos de pruebas CargaMax', '2023-03-10', '14:00:00', '16:00:00'),
    ('LE000200', 'CPC0001', 'I015', 'WXY-123', 'TL-C010', 'Terrenos de pruebas Ruta 66', '2023-03-10', '16:00:00', '18:00:00');
    

----------------- DISPONIBILIDAD INSTRUCTORES -------------------
    
INSERT INTO disponibilidad_instructores (id_disp_instructor, cedula_instructor, fecha, hora_inicio, hora_fin)
VALUES
    ('DI000001', 'I001', '2023-02-20', '06:00:00', '20:00:00'),
    ('DI000002', 'I001', '2023-02-21', '06:00:00', '08:00:00'),
    ('DI000003', 'I001', '2023-02-22', '06:00:00', '08:00:00'),
    ('DI000004', 'I001', '2023-02-23', '06:00:00', '08:00:00'),
    ('DI000005', 'I001', '2023-02-24', '06:00:00', '08:00:00'),
    ('DI000006', 'I001', '2023-02-27', '06:00:00', '18:00:00'),
    ('DI000007', 'I001', '2023-02-28', '12:00:00', '14:00:00'),
    ('DI000008', 'I001', '2023-03-01', '08:00:00', '20:00:00'),
    ('DI000009', 'I001', '2023-03-02', '14:00:00', '16:00:00'),
    ('DI000010', 'I001', '2023-03-03', '10:00:00', '12:00:00'),
    ('DI000011', 'I001', '2023-03-06', '06:00:00', '18:00:00'),
    ('DI000012', 'I001', '2023-03-07', '12:00:00', '14:00:00'),
    ('DI000013', 'I001', '2023-03-08', '08:00:00', '20:00:00'),
    ('DI000014', 'I001', '2023-03-09', '14:00:00', '16:00:00'),
    ('DI000015', 'I001', '2023-03-10', '10:00:00', '12:00:00'),
    ('DI000016', 'I002', '2023-02-20', '14:00:00', '20:00:00'),
    ('DI000017', 'I002', '2023-02-21', '14:00:00', '20:00:00'),
    ('DI000018', 'I002', '2023-02-22', '14:00:00', '16:00:00'),
    ('DI000019', 'I002', '2023-02-23', '14:00:00', '16:00:00'),
    ('DI000020', 'I002', '2023-02-24', '14:00:00', '16:00:00'),
    ('DI000021', 'I002', '2023-02-27', '08:00:00', '20:00:00'),
    ('DI000022', 'I002', '2023-02-28', '14:00:00', '16:00:00'),
    ('DI000023', 'I002', '2023-03-01', '10:00:00', '12:00:00'),
    ('DI000024', 'I002', '2023-03-02', '06:00:00', '18:00:00'),
    ('DI000025', 'I002', '2023-03-03', '12:00:00', '14:00:00'),
    ('DI000026', 'I002', '2023-03-06', '08:00:00', '20:00:00'),
    ('DI000027', 'I002', '2023-03-07', '14:00:00', '16:00:00'),
    ('DI000028', 'I002', '2023-03-08', '10:00:00', '12:00:00'),
    ('DI000029', 'I002', '2023-03-09', '06:00:00', '18:00:00'),
    ('DI000030', 'I002', '2023-03-10', '12:00:00', '14:00:00'),
    ('DI000031', 'I003', '2023-02-27', '10:00:00', '12:00:00'),
    ('DI000032', 'I003', '2023-02-28', '06:00:00', '18:00:00'),
    ('DI000033', 'I003', '2023-03-01', '12:00:00', '14:00:00'),
    ('DI000034', 'I003', '2023-03-02', '08:00:00', '20:00:00'),
    ('DI000035', 'I003', '2023-03-03', '14:00:00', '16:00:00'),
    ('DI000036', 'I003', '2023-03-06', '10:00:00', '12:00:00'),
    ('DI000037', 'I003', '2023-03-07', '06:00:00', '18:00:00'),
    ('DI000038', 'I003', '2023-03-08', '12:00:00', '14:00:00'),
    ('DI000039', 'I003', '2023-03-09', '08:00:00', '20:00:00'),
    ('DI000040', 'I003', '2023-03-10', '14:00:00', '16:00:00'),
    ('DI000041', 'I004', '2023-02-27', '12:00:00', '14:00:00'),
    ('DI000042', 'I004', '2023-02-28', '08:00:00', '20:00:00'),
    ('DI000043', 'I004', '2023-03-01', '14:00:00', '16:00:00'),
    ('DI000044', 'I004', '2023-03-02', '10:00:00', '12:00:00'),
    ('DI000045', 'I004', '2023-03-03', '06:00:00', '18:00:00'),
    ('DI000046', 'I004', '2023-03-06', '12:00:00', '14:00:00'),
    ('DI000047', 'I004', '2023-03-07', '08:00:00', '20:00:00'),
    ('DI000048', 'I004', '2023-03-08', '14:00:00', '16:00:00'),
    ('DI000049', 'I004', '2023-03-09', '10:00:00', '12:00:00'),
    ('DI000050', 'I004', '2023-03-10', '06:00:00', '18:00:00'),
    ('DI000051', 'I005', '2023-02-27', '14:00:00', '16:00:00'),
    ('DI000052', 'I005', '2023-02-28', '10:00:00', '12:00:00'),
    ('DI000053', 'I005', '2023-03-01', '06:00:00', '20:00:00'),
    ('DI000054', 'I005', '2023-03-02', '12:00:00', '14:00:00'),
    ('DI000055', 'I005', '2023-03-03', '08:00:00', '20:00:00'),
    ('DI000056', 'I005', '2023-03-06', '14:00:00', '16:00:00'),
    ('DI000057', 'I005', '2023-03-07', '10:00:00', '12:00:00'),
    ('DI000058', 'I005', '2023-03-08', '06:00:00', '20:00:00'),
    ('DI000059', 'I005', '2023-03-09', '12:00:00', '14:00:00'),
    ('DI000060', 'I005', '2023-03-10', '08:00:00', '20:00:00'),
    ('DI000061', 'I006', '2023-02-27', '06:00:00', '18:00:00'),
    ('DI000062', 'I006', '2023-02-28', '12:00:00', '14:00:00'),
    ('DI000063', 'I006', '2023-03-01', '08:00:00', '20:00:00'),
    ('DI000064', 'I006', '2023-03-02', '14:00:00', '16:00:00'),
    ('DI000065', 'I006', '2023-03-03', '10:00:00', '12:00:00'),
    ('DI000066', 'I006', '2023-03-06', '06:00:00', '20:00:00'),
    ('DI000067', 'I006', '2023-03-07', '12:00:00', '14:00:00'),
    ('DI000068', 'I006', '2023-03-08', '08:00:00', '20:00:00'),
    ('DI000069', 'I006', '2023-03-09', '14:00:00', '16:00:00'),
    ('DI000070', 'I006', '2023-03-10', '10:00:00', '12:00:00'),
    ('DI000071', 'I007', '2023-02-27', '08:00:00', '20:00:00'),
    ('DI000072', 'I007', '2023-02-28', '14:00:00', '16:00:00'),
    ('DI000073', 'I007', '2023-03-01', '10:00:00', '12:00:00'),
    ('DI000074', 'I007', '2023-03-02', '06:00:00', '20:00:00'),
    ('DI000075', 'I007', '2023-03-03', '12:00:00', '14:00:00'),
    ('DI000076', 'I007', '2023-03-06', '08:00:00', '20:00:00'),
    ('DI000077', 'I007', '2023-03-07', '14:00:00', '16:00:00'),
    ('DI000078', 'I007', '2023-03-08', '10:00:00', '12:00:00'),
    ('DI000079', 'I007', '2023-03-09', '06:00:00', '20:00:00'),
    ('DI000080', 'I007', '2023-03-10', '12:00:00', '14:00:00'),
    ('DI000081', 'I008', '2023-02-27', '10:00:00', '12:00:00'),
    ('DI000082', 'I008', '2023-02-28', '06:00:00', '20:00:00'),
    ('DI000083', 'I008', '2023-03-01', '12:00:00', '14:00:00'),
    ('DI000084', 'I008', '2023-03-02', '08:00:00', '20:00:00'),
    ('DI000085', 'I008', '2023-03-03', '14:00:00', '16:00:00'),
    ('DI000086', 'I008', '2023-03-06', '10:00:00', '12:00:00'),
    ('DI000087', 'I008', '2023-03-07', '06:00:00', '20:00:00'),
    ('DI000088', 'I008', '2023-03-08', '12:00:00', '14:00:00'),
    ('DI000089', 'I008', '2023-03-09', '08:00:00', '20:00:00'),
    ('DI000090', 'I008', '2023-03-10', '14:00:00', '16:00:00'),
    ('DI000091', 'I009', '2023-02-27', '12:00:00', '14:00:00'),
    ('DI000092', 'I009', '2023-02-28', '08:00:00', '20:00:00'),
    ('DI000093', 'I009', '2023-03-01', '14:00:00', '16:00:00'),
    ('DI000094', 'I009', '2023-03-02', '10:00:00', '12:00:00'),
    ('DI000095', 'I009', '2023-03-03', '06:00:00', '20:00:00'),
    ('DI000096', 'I009', '2023-03-06', '12:00:00', '14:00:00'),
    ('DI000097', 'I009', '2023-03-07', '08:00:00', '20:00:00'),
    ('DI000098', 'I009', '2023-03-08', '14:00:00', '16:00:00'),
    ('DI000099', 'I009', '2023-03-09', '10:00:00', '12:00:00'),
    ('DI000100', 'I009', '2023-03-10', '06:00:00', '20:00:00'),
    ('DI000101', 'I010', '2023-02-27', '14:00:00', '16:00:00'),
    ('DI000102', 'I010', '2023-02-28', '10:00:00', '12:00:00'),
    ('DI000103', 'I010', '2023-03-01', '06:00:00', '20:00:00'),
    ('DI000104', 'I010', '2023-03-02', '12:00:00', '14:00:00'),
    ('DI000105', 'I010', '2023-03-03', '08:00:00', '20:00:00'),
    ('DI000106', 'I010', '2023-03-06', '14:00:00', '16:00:00'),
    ('DI000107', 'I010', '2023-03-07', '10:00:00', '12:00:00'),
    ('DI000108', 'I010', '2023-03-08', '06:00:00', '20:00:00'),
    ('DI000109', 'I010', '2023-03-09', '12:00:00', '14:00:00'),
    ('DI000110', 'I010', '2023-03-10', '08:00:00', '20:00:00'),
    ('DI000111', 'I011', '2023-02-27', '06:00:00', '18:00:00'),
    ('DI000112', 'I011', '2023-02-28', '14:00:00', '16:00:00'),
    ('DI000113', 'I011', '2023-03-01', '12:00:00', '14:00:00'),
    ('DI000114', 'I011', '2023-03-02', '10:00:00', '20:00:00'),
    ('DI000115', 'I011', '2023-03-03', '08:00:00', '10:00:00'),
    ('DI000116', 'I011', '2023-03-06', '06:00:00', '20:00:00'),
    ('DI000117', 'I011', '2023-03-07', '14:00:00', '16:00:00'),
    ('DI000118', 'I011', '2023-03-08', '12:00:00', '14:00:00'),
    ('DI000119', 'I011', '2023-03-09', '10:00:00', '12:00:00'),
    ('DI000120', 'I011', '2023-03-10', '08:00:00', '10:00:00'),
    ('DI000121', 'I012', '2023-02-27', '08:00:00', '10:00:00'),
    ('DI000122', 'I012', '2023-02-28', '06:00:00', '20:00:00'),
    ('DI000123', 'I012', '2023-03-01', '14:00:00', '16:00:00'),
    ('DI000124', 'I012', '2023-03-02', '12:00:00', '14:00:00'),
    ('DI000125', 'I012', '2023-03-03', '10:00:00', '12:00:00'),
    ('DI000126', 'I012', '2023-03-06', '08:00:00', '20:00:00'),
    ('DI000127', 'I012', '2023-03-07', '06:00:00', '20:00:00'),
    ('DI000128', 'I012', '2023-03-08', '14:00:00', '16:00:00'),
    ('DI000129', 'I012', '2023-03-09', '12:00:00', '14:00:00'),
    ('DI000130', 'I012', '2023-03-10', '10:00:00', '12:00:00'),
    ('DI000131', 'I013', '2023-02-27', '10:00:00', '12:00:00'),
    ('DI000132', 'I013', '2023-02-28', '08:00:00', '20:00:00'),
    ('DI000133', 'I013', '2023-03-01', '06:00:00', '20:00:00'),
    ('DI000134', 'I013', '2023-03-02', '14:00:00', '16:00:00'),
    ('DI000135', 'I013', '2023-03-03', '12:00:00', '14:00:00'),
    ('DI000136', 'I013', '2023-03-06', '10:00:00', '12:00:00'),
    ('DI000137', 'I013', '2023-03-07', '08:00:00', '20:00:00'),
    ('DI000138', 'I013', '2023-03-08', '06:00:00', '20:00:00'),
    ('DI000139', 'I013', '2023-03-09', '14:00:00', '16:00:00'),
    ('DI000140', 'I013', '2023-03-10', '12:00:00', '14:00:00'),
    ('DI000141', 'I014', '2023-02-27', '12:00:00', '14:00:00'),
    ('DI000142', 'I014', '2023-02-28', '10:00:00', '20:00:00'),
    ('DI000143', 'I014', '2023-03-01', '08:00:00', '10:00:00'),
    ('DI000144', 'I014', '2023-03-02', '06:00:00', '20:00:00'),
    ('DI000145', 'I014', '2023-03-03', '14:00:00', '16:00:00'),
    ('DI000146', 'I014', '2023-03-06', '12:00:00', '14:00:00'),
    ('DI000147', 'I014', '2023-03-07', '10:00:00', '12:00:00'),
    ('DI000148', 'I014', '2023-03-08', '08:00:00', '20:00:00'),
    ('DI000149', 'I014', '2023-03-09', '06:00:00', '20:00:00'),
    ('DI000150', 'I014', '2023-03-10', '14:00:00', '16:00:00'),
    ('DI000151', 'I015', '2023-02-27', '14:00:00', '16:00:00'),
    ('DI000152', 'I015', '2023-02-28', '12:00:00', '14:00:00'),
    ('DI000153', 'I015', '2023-03-01', '10:00:00', '20:00:00'),
    ('DI000154', 'I015', '2023-03-02', '08:00:00', '10:00:00'),
    ('DI000155', 'I015', '2023-03-03', '06:00:00', '20:00:00'),
    ('DI000156', 'I015', '2023-03-06', '14:00:00', '16:00:00'),
    ('DI000157', 'I015', '2023-03-07', '12:00:00', '14:00:00'),
    ('DI000158', 'I015', '2023-03-08', '10:00:00', '12:00:00'),
    ('DI000159', 'I015', '2023-03-09', '08:00:00', '10:00:00'),
    ('DI000160', 'I015', '2023-03-10', '06:00:00', '20:00:00');
    

-- -------------- ASISTENCIA CLASES -------------------
    
INSERT INTO asistencia_clases (id_asistencia_clase, id_clase, cedula_estudiante)
VALUES
	-- clases presenciales AUTOMOVIL

    ('AC000001', 'CL000001', 'E001'),
    ('AC000002', 'CL000001', 'E003'),
    ('AC000003', 'CL000001', 'E005'),
    ('AC000004', 'CL000001', 'E007'),
    
    ('AC000005', 'CL000007', 'E001'),
    ('AC000006', 'CL000007', 'E003'),
    ('AC000007', 'CL000007', 'E005'),
    ('AC000008', 'CL000007', 'E007'),
    
    ('AC000009', 'CL000013', 'E001'),
    ('AC000010', 'CL000013', 'E003'),
    ('AC000011', 'CL000013', 'E005'),
    ('AC000012', 'CL000013', 'E007'),
    
    ('AC000013', 'CL000019', 'E001'),
    ('AC000014', 'CL000019', 'E003'),
    ('AC000015', 'CL000019', 'E005'),
    ('AC000016', 'CL000019', 'E007'),
    
    ('AC000017', 'CL000025', 'E001'),
    ('AC000018', 'CL000025', 'E003'),
    ('AC000019', 'CL000025', 'E005'),
    ('AC000020', 'CL000025', 'E007'),

    ('AC000021', 'CL000031', 'E001'),
    ('AC000022', 'CL000031', 'E003'),
    ('AC000023', 'CL000031', 'E005'),
    ('AC000024', 'CL000031', 'E007'),

    ('AC000025', 'CL000037', 'E001'),
    ('AC000026', 'CL000037', 'E003'),
    ('AC000027', 'CL000037', 'E005'),
    ('AC000028', 'CL000037', 'E007'),

    ('AC000029', 'CL000043', 'E001'),
    ('AC000030', 'CL000043', 'E003'),
    ('AC000031', 'CL000043', 'E005'),
    ('AC000032', 'CL000043', 'E007'),

    ('AC000033', 'CL000049', 'E001'),
    ('AC000034', 'CL000049', 'E003'),
    ('AC000035', 'CL000049', 'E005'),
    ('AC000036', 'CL000049', 'E007'),

    ('AC000037', 'CL000055', 'E001'),
    ('AC000038', 'CL000055', 'E003'),
    ('AC000039', 'CL000055', 'E005'),
    ('AC000040', 'CL000055', 'E007'),

    ('AC000041', 'CL000061', 'E001'),
    ('AC000042', 'CL000061', 'E003'),
    ('AC000043', 'CL000061', 'E005'),
    ('AC000044', 'CL000061', 'E007'),

    ('AC000045', 'CL000067', 'E001'),
    ('AC000046', 'CL000067', 'E003'),
    ('AC000047', 'CL000067', 'E005'),
    ('AC000048', 'CL000067', 'E007'),

    ('AC000049', 'CL000073', 'E001'),
    ('AC000050', 'CL000073', 'E003'),
    ('AC000051', 'CL000073', 'E005'),
    ('AC000052', 'CL000073', 'E007'),

    ('AC000053', 'CL000079', 'E001'),
    ('AC000054', 'CL000079', 'E003'),
    ('AC000055', 'CL000079', 'E005'),
    ('AC000056', 'CL000079', 'E007'),

    ('AC000057', 'CL000085', 'E001'),
    ('AC000058', 'CL000085', 'E003'),
    ('AC000059', 'CL000085', 'E005'),
    ('AC000060', 'CL000085', 'E007'),
    
-- clases virtuales AUTOMOVIL

	('AC000061', 'CL000002', 'E002'),
    ('AC000062', 'CL000002', 'E004'),
    ('AC000063', 'CL000002', 'E006'),
    
    ('AC000064', 'CL000008', 'E002'),
    ('AC000065', 'CL000008', 'E004'),
    ('AC000066', 'CL000008', 'E006'),
    
    ('AC000067', 'CL000014', 'E002'),
    ('AC000068', 'CL000014', 'E004'),
    ('AC000069', 'CL000014', 'E006'),
    
    ('AC000070', 'CL000020', 'E002'),
    ('AC000071', 'CL000020', 'E004'),
    ('AC000072', 'CL000020', 'E006'),

    ('AC000073', 'CL000026', 'E002'),
    ('AC000074', 'CL000026', 'E004'),
    ('AC000075', 'CL000026', 'E006'),

    ('AC000076', 'CL000032', 'E002'),
    ('AC000077', 'CL000032', 'E004'),
    ('AC000078', 'CL000032', 'E006'),

    ('AC000079', 'CL000038', 'E002'),
    ('AC000080', 'CL000038', 'E004'),
    ('AC000081', 'CL000038', 'E006'),

    ('AC000082', 'CL000044', 'E002'),
    ('AC000083', 'CL000044', 'E004'),
    ('AC000084', 'CL000044', 'E006'),

    ('AC000085', 'CL000050', 'E002'),
    ('AC000086', 'CL000050', 'E004'),
    ('AC000087', 'CL000050', 'E006'),

    ('AC000088', 'CL000056', 'E002'),
    ('AC000089', 'CL000056', 'E004'),
    ('AC000090', 'CL000056', 'E006'),

    ('AC000091', 'CL000062', 'E002'),
    ('AC000092', 'CL000062', 'E004'),
    ('AC000093', 'CL000062', 'E006'),

    ('AC000094', 'CL000068', 'E002'),
    ('AC000095', 'CL000068', 'E004'),
    ('AC000096', 'CL000068', 'E006'),

    ('AC000097', 'CL000074', 'E002'),
    ('AC000098', 'CL000074', 'E004'),
    ('AC000099', 'CL000074', 'E006'),

    ('AC000100', 'CL000080', 'E002'),
    ('AC000101', 'CL000080', 'E004'),
    ('AC000102', 'CL000080', 'E006'),

    ('AC000103', 'CL000086', 'E002'),
    ('AC000104', 'CL000086', 'E004'),
    ('AC000105', 'CL000086', 'E006'),
    
    -- clases presenciales MOTOCICLETA
    
    ('AC000106', 'CL000003', 'E008'),
    ('AC000107', 'CL000003', 'E010'),
    ('AC000108', 'CL000003', 'E012'),
    ('AC000109', 'CL000003', 'E013'),
    ('AC000110', 'CL000003', 'E014'),
    
    ('AC000111', 'CL000009', 'E008'),
    ('AC000112', 'CL000009', 'E010'),
    ('AC000113', 'CL000009', 'E012'),
    ('AC000114', 'CL000009', 'E013'),
    ('AC000115', 'CL000009', 'E014'),
    
    ('AC000116', 'CL000015', 'E008'),
    ('AC000117', 'CL000015', 'E010'),
    ('AC000118', 'CL000015', 'E012'),
    ('AC000119', 'CL000015', 'E013'),
    ('AC000120', 'CL000015', 'E014'),

    ('AC000121', 'CL000021', 'E008'),
    ('AC000122', 'CL000021', 'E010'),
    ('AC000123', 'CL000021', 'E012'),
    ('AC000124', 'CL000021', 'E013'),
    ('AC000125', 'CL000021', 'E014'),

    ('AC000126', 'CL000027', 'E008'),
    ('AC000127', 'CL000027', 'E010'),
    ('AC000128', 'CL000027', 'E012'),
    ('AC000129', 'CL000027', 'E013'),
    ('AC000130', 'CL000027', 'E014'),

    ('AC000131', 'CL000033', 'E008'),
    ('AC000132', 'CL000033', 'E010'),
    ('AC000133', 'CL000033', 'E012'),
    ('AC000134', 'CL000033', 'E013'),
    ('AC000135', 'CL000033', 'E014'),

    ('AC000136', 'CL000039', 'E008'),
    ('AC000137', 'CL000039', 'E010'),
    ('AC000138', 'CL000039', 'E012'),
    ('AC000139', 'CL000039', 'E013'),
    ('AC000140', 'CL000039', 'E014'),

    ('AC000141', 'CL000045', 'E008'),
    ('AC000142', 'CL000045', 'E010'),
    ('AC000143', 'CL000045', 'E012'),
    ('AC000144', 'CL000045', 'E013'),
    ('AC000145', 'CL000045', 'E014'),

    ('AC000146', 'CL000051', 'E008'),
    ('AC000147', 'CL000051', 'E010'),
    ('AC000148', 'CL000051', 'E012'),
    ('AC000149', 'CL000051', 'E013'),
    ('AC000150', 'CL000051', 'E014'),

    ('AC000151', 'CL000057', 'E008'),
    ('AC000152', 'CL000057', 'E010'),
    ('AC000153', 'CL000057', 'E012'),
    ('AC000154', 'CL000057', 'E013'),
    ('AC000155', 'CL000057', 'E014'),

    ('AC000156', 'CL000063', 'E008'),
    ('AC000157', 'CL000063', 'E010'),
    ('AC000158', 'CL000063', 'E012'),
    ('AC000159', 'CL000063', 'E013'),
    ('AC000160', 'CL000063', 'E014'),

    ('AC000161', 'CL000069', 'E008'),
    ('AC000162', 'CL000069', 'E010'),
    ('AC000163', 'CL000069', 'E012'),
    ('AC000164', 'CL000069', 'E013'),
    ('AC000165', 'CL000069', 'E014'),

    ('AC000166', 'CL000075', 'E008'),
    ('AC000167', 'CL000075', 'E010'),
    ('AC000168', 'CL000075', 'E012'),
    ('AC000169', 'CL000075', 'E013'),
    ('AC000170', 'CL000075', 'E014'),

    ('AC000171', 'CL000081', 'E008'),
    ('AC000172', 'CL000081', 'E010'),
    ('AC000173', 'CL000081', 'E012'),
    ('AC000174', 'CL000081', 'E013'),
    ('AC000175', 'CL000081', 'E014'),

    ('AC000176', 'CL000087', 'E008'),
    ('AC000177', 'CL000087', 'E010'),
    ('AC000178', 'CL000087', 'E012'),
    ('AC000179', 'CL000087', 'E013'),
    ('AC000180', 'CL000087', 'E014'),
    
    -- clases virtuales MOTOCICLETA
    
    ('AC000181', 'CL000004', 'E009'),
    ('AC000182', 'CL000004', 'E011'),
    
    ('AC000183', 'CL000010', 'E009'),
    ('AC000184', 'CL000010', 'E011'),
    
    ('AC000185', 'CL000016', 'E009'),
    ('AC000186', 'CL000016', 'E011'),

    ('AC000187', 'CL000022', 'E009'),
    ('AC000188', 'CL000022', 'E011'),

    ('AC000189', 'CL000028', 'E009'),
    ('AC000190', 'CL000028', 'E011'),

    ('AC000191', 'CL000034', 'E009'),
    ('AC000192', 'CL000034', 'E011'),

    ('AC000193', 'CL000040', 'E009'),
    ('AC000194', 'CL000040', 'E011'),

    ('AC000195', 'CL000046', 'E009'),
    ('AC000196', 'CL000046', 'E011'),

    ('AC000197', 'CL000052', 'E009'),
    ('AC000198', 'CL000052', 'E011'),

    ('AC000199', 'CL000058', 'E009'),
    ('AC000200', 'CL000058', 'E011'),

    ('AC000201', 'CL000064', 'E009'),
    ('AC000202', 'CL000064', 'E011'),

    ('AC000203', 'CL000070', 'E009'),
    ('AC000204', 'CL000070', 'E011'),

    ('AC000205', 'CL000076', 'E009'),
    ('AC000206', 'CL000076', 'E011'),

    ('AC000207', 'CL000082', 'E009'),
    ('AC000208', 'CL000082', 'E011'),

    ('AC000209', 'CL000088', 'E009'),
    ('AC000210', 'CL000088', 'E011'),
    
    -- clases presenciales CAMION

	('AC000211', 'CL000005', 'E015'),
    ('AC000212', 'CL000005', 'E016'),
    ('AC000213', 'CL000005', 'E017'),
    ('AC000214', 'CL000005', 'E018'),
    ('AC000215', 'CL000005', 'E019'),
    
    ('AC000216', 'CL000011', 'E015'),
    ('AC000217', 'CL000011', 'E016'),
    ('AC000218', 'CL000011', 'E017'),
    ('AC000219', 'CL000011', 'E018'),
    ('AC000220', 'CL000011', 'E019'),
    
    ('AC000221', 'CL000017', 'E015'),
    ('AC000222', 'CL000017', 'E016'),
    ('AC000223', 'CL000017', 'E017'),
    ('AC000224', 'CL000017', 'E018'),
    ('AC000225', 'CL000017', 'E019'),

    ('AC000226', 'CL000023', 'E015'),
    ('AC000227', 'CL000023', 'E016'),
    ('AC000228', 'CL000023', 'E017'),
    ('AC000229', 'CL000023', 'E018'),
    ('AC000230', 'CL000023', 'E019'),

    ('AC000231', 'CL000029', 'E015'),
    ('AC000232', 'CL000029', 'E016'),
    ('AC000233', 'CL000029', 'E017'),
    ('AC000234', 'CL000029', 'E018'),
    ('AC000235', 'CL000029', 'E019'),

    ('AC000236', 'CL000035', 'E015'),
    ('AC000237', 'CL000035', 'E016'),
    ('AC000238', 'CL000035', 'E017'),
    ('AC000239', 'CL000035', 'E018'),
    ('AC000240', 'CL000035', 'E019'),

    ('AC000241', 'CL000041', 'E015'),
    ('AC000242', 'CL000041', 'E016'),
    ('AC000243', 'CL000041', 'E017'),
    ('AC000244', 'CL000041', 'E018'),
    ('AC000245', 'CL000041', 'E019'),

    ('AC000246', 'CL000047', 'E015'),
    ('AC000247', 'CL000047', 'E016'),
    ('AC000248', 'CL000047', 'E017'),
    ('AC000249', 'CL000047', 'E018'),
    ('AC000250', 'CL000047', 'E019'),

    ('AC000251', 'CL000053', 'E015'),
    ('AC000252', 'CL000053', 'E016'),
    ('AC000253', 'CL000053', 'E017'),
    ('AC000254', 'CL000053', 'E018'),
    ('AC000255', 'CL000053', 'E019'),

    ('AC000256', 'CL000059', 'E015'),
    ('AC000257', 'CL000059', 'E016'),
    ('AC000258', 'CL000059', 'E017'),
    ('AC000259', 'CL000059', 'E018'),
    ('AC000260', 'CL000059', 'E019'),

    ('AC000261', 'CL000065', 'E015'),
    ('AC000262', 'CL000065', 'E016'),
    ('AC000263', 'CL000065', 'E017'),
    ('AC000264', 'CL000065', 'E018'),
    ('AC000265', 'CL000065', 'E019'),

    ('AC000266', 'CL000071', 'E015'),
    ('AC000267', 'CL000071', 'E016'),
    ('AC000268', 'CL000071', 'E017'),
    ('AC000269', 'CL000071', 'E018'),
    ('AC000270', 'CL000071', 'E019'),

    ('AC000271', 'CL000077', 'E015'),
    ('AC000272', 'CL000077', 'E016'),
    ('AC000273', 'CL000077', 'E017'),
    ('AC000274', 'CL000077', 'E018'),
    ('AC000275', 'CL000077', 'E019'),

    ('AC000276', 'CL000083', 'E015'),
    ('AC000277', 'CL000083', 'E016'),
    ('AC000278', 'CL000083', 'E017'),
    ('AC000279', 'CL000083', 'E018'),
    ('AC000280', 'CL000083', 'E019'),

    ('AC000281', 'CL000089', 'E015'),
    ('AC000282', 'CL000089', 'E016'),
    ('AC000283', 'CL000089', 'E017'),
    ('AC000284', 'CL000089', 'E018'),
    ('AC000285', 'CL000089', 'E019'),
    
    -- clases virtuales CAMION
    
    ('AC000286', 'CL000006', 'E020'),
    
    ('AC000287', 'CL000012', 'E020'),
    
    ('AC000288', 'CL000018', 'E020'),
    
    ('AC000289', 'CL000024', 'E020'),

    ('AC000290', 'CL000030', 'E020'),

    ('AC000291', 'CL000036', 'E020'),

    ('AC000292', 'CL000042', 'E020'),

    ('AC000293', 'CL000048', 'E020'),

    ('AC000294', 'CL000054', 'E020'),

    ('AC000295', 'CL000060', 'E020'),

    ('AC000296', 'CL000066', 'E020'),

    ('AC000297', 'CL000072', 'E020'),

    ('AC000298', 'CL000078', 'E020'),

    ('AC000299', 'CL000084', 'E020'),

    ('AC000300', 'CL000090', 'E020');
    
-- -------------- ASISTENCIA LECCIONES -------------------
    
INSERT INTO asistencia_lecciones (id_asistencia_leccion, id_leccion, cedula_estudiante)
VALUES
	-- asistencias a lecciones de AUTOMOVIL

    ('AL000001', 'LE000001', 'E001'),
    ('AL000002', 'LE000002', 'E002'),
    ('AL000003', 'LE000003', 'E003'),
    ('AL000004', 'LE000004', 'E004'),
    ('AL000005', 'LE000005', 'E005'),
    ('AL000006', 'LE000006', 'E006'),
    ('AL000007', 'LE000007', 'E007'),
    
    ('AL000008', 'LE000008', 'E001'),
    ('AL000009', 'LE000009', 'E002'),
    ('AL000010', 'LE000010', 'E003'),
    ('AL000011', 'LE000011', 'E004'),
    ('AL000012', 'LE000012', 'E005'),
    ('AL000013', 'LE000013', 'E006'),
    ('AL000014', 'LE000014', 'E007'),
    
    ('AL000015', 'LE000015', 'E001'),
    ('AL000016', 'LE000016', 'E002'),
    ('AL000017', 'LE000017', 'E003'),
    ('AL000018', 'LE000018', 'E004'),
    ('AL000019', 'LE000019', 'E005'),
    ('AL000020', 'LE000020', 'E006'),
    ('AL000021', 'LE000021', 'E007'),
    
    ('AL000022', 'LE000022', 'E001'),
    ('AL000023', 'LE000023', 'E002'),
    ('AL000024', 'LE000024', 'E003'),
    ('AL000025', 'LE000025', 'E004'),
    ('AL000026', 'LE000026', 'E005'),
    ('AL000027', 'LE000027', 'E006'),
    ('AL000028', 'LE000028', 'E007'),

    ('AL000029', 'LE000029', 'E001'),
    ('AL000030', 'LE000030', 'E002'),
    ('AL000031', 'LE000031', 'E003'),
    ('AL000032', 'LE000032', 'E004'),
    ('AL000033', 'LE000033', 'E005'),
    ('AL000034', 'LE000034', 'E006'),
    ('AL000035', 'LE000035', 'E007'),
    
    ('AL000036', 'LE000036', 'E001'),
    ('AL000037', 'LE000037', 'E002'),
    ('AL000038', 'LE000038', 'E003'),
    ('AL000039', 'LE000039', 'E004'),
    ('AL000040', 'LE000040', 'E005'),
    ('AL000041', 'LE000041', 'E006'),
    ('AL000042', 'LE000042', 'E007'),

    ('AL000043', 'LE000043', 'E001'),
    ('AL000044', 'LE000044', 'E002'),
    ('AL000045', 'LE000045', 'E003'),
    ('AL000046', 'LE000046', 'E004'),
    ('AL000047', 'LE000047', 'E005'),
    ('AL000048', 'LE000048', 'E006'),
    ('AL000049', 'LE000049', 'E007'),

    ('AL000050', 'LE000050', 'E001'),
    ('AL000051', 'LE000051', 'E002'),
    ('AL000052', 'LE000052', 'E003'),
    ('AL000053', 'LE000053', 'E004'),
    ('AL000054', 'LE000054', 'E005'),
    ('AL000055', 'LE000055', 'E006'),
    ('AL000056', 'LE000056', 'E007'),

    ('AL000057', 'LE000057', 'E001'),
    ('AL000058', 'LE000058', 'E002'),
    ('AL000059', 'LE000059', 'E003'),
    ('AL000060', 'LE000060', 'E004'),
    ('AL000061', 'LE000061', 'E005'),
    ('AL000062', 'LE000062', 'E006'),
    ('AL000063', 'LE000063', 'E007'),

    ('AL000064', 'LE000064', 'E001'),
    ('AL000065', 'LE000065', 'E002'),
    ('AL000066', 'LE000066', 'E003'),
    ('AL000067', 'LE000067', 'E004'),
    ('AL000068', 'LE000068', 'E005'),
    ('AL000069', 'LE000069', 'E006'),
    ('AL000070', 'LE000070', 'E007'),
    
    -- asistencias a lecciones de MOTOCICLETA

	('AL000071', 'LE000071', 'E008'),
    ('AL000072', 'LE000072', 'E009'),
    ('AL000073', 'LE000073', 'E010'),
    ('AL000074', 'LE000074', 'E011'),
    ('AL000075', 'LE000075', 'E012'),
    ('AL000076', 'LE000076', 'E013'),
    ('AL000077', 'LE000077', 'E014'),
    
    ('AL000078', 'LE000078', 'E008'),
    ('AL000079', 'LE000079', 'E009'),
    ('AL000080', 'LE000080', 'E010'),
    ('AL000081', 'LE000081', 'E011'),
    ('AL000082', 'LE000082', 'E012'),
    ('AL000083', 'LE000083', 'E013'),
    ('AL000084', 'LE000084', 'E014'),
    
    ('AL000085', 'LE000085', 'E008'),
    ('AL000086', 'LE000086', 'E009'),
    ('AL000087', 'LE000087', 'E010'),
    ('AL000088', 'LE000088', 'E011'),
    ('AL000089', 'LE000089', 'E012'),
    ('AL000090', 'LE000090', 'E013'),
    ('AL000091', 'LE000091', 'E014'),
    
    ('AL000092', 'LE000092', 'E008'),
    ('AL000093', 'LE000093', 'E009'),
    ('AL000094', 'LE000094', 'E010'),
    ('AL000095', 'LE000095', 'E011'),
    ('AL000096', 'LE000096', 'E012'),
    ('AL000097', 'LE000097', 'E013'),
    ('AL000098', 'LE000098', 'E014'),
    
    ('AL000099', 'LE000099', 'E008'),
    ('AL000100', 'LE000100', 'E009'),
    ('AL000101', 'LE000101', 'E010'),
    ('AL000102', 'LE000102', 'E011'),
    ('AL000103', 'LE000103', 'E012'),
    ('AL000104', 'LE000104', 'E013'),
    ('AL000105', 'LE000105', 'E014'),
    
    ('AL000106', 'LE000106', 'E008'),
    ('AL000107', 'LE000107', 'E009'),
    ('AL000108', 'LE000108', 'E010'),
    ('AL000109', 'LE000109', 'E011'),
    ('AL000110', 'LE000110', 'E012'),
    ('AL000111', 'LE000111', 'E013'),
    ('AL000112', 'LE000112', 'E014'),
    
    ('AL000113', 'LE000113', 'E008'),
    ('AL000114', 'LE000114', 'E009'),
    ('AL000115', 'LE000115', 'E010'),
    ('AL000116', 'LE000116', 'E011'),
    ('AL000117', 'LE000117', 'E012'),
    ('AL000118', 'LE000118', 'E013'),
    ('AL000119', 'LE000119', 'E014'),
    
    ('AL000120', 'LE000120', 'E008'),
    ('AL000121', 'LE000121', 'E009'),
    ('AL000122', 'LE000122', 'E010'),
    ('AL000123', 'LE000123', 'E011'),
    ('AL000124', 'LE000124', 'E012'),
    ('AL000125', 'LE000125', 'E013'),
    ('AL000126', 'LE000126', 'E014'),
    
    ('AL000127', 'LE000127', 'E008'),
    ('AL000128', 'LE000128', 'E009'),
    ('AL000129', 'LE000129', 'E010'),
    ('AL000130', 'LE000130', 'E011'),
    ('AL000131', 'LE000131', 'E012'),
    ('AL000132', 'LE000132', 'E013'),
    ('AL000133', 'LE000133', 'E014'),
    
    ('AL000134', 'LE000134', 'E008'),
    ('AL000135', 'LE000135', 'E009'),
    ('AL000136', 'LE000136', 'E010'),
    ('AL000137', 'LE000137', 'E011'),
    ('AL000138', 'LE000138', 'E012'),
    ('AL000139', 'LE000139', 'E013'),
    ('AL000140', 'LE000140', 'E014'),
    
    -- asistencias a lecciones de CAMION
    
    ('AL000141', 'LE000141', 'E015'),
    ('AL000142', 'LE000142', 'E016'),
    ('AL000143', 'LE000143', 'E017'),
    ('AL000144', 'LE000144', 'E018'),
    ('AL000145', 'LE000145', 'E019'),
    ('AL000146', 'LE000146', 'E020'),
    
    ('AL000147', 'LE000147', 'E015'),
    ('AL000148', 'LE000148', 'E016'),
    ('AL000149', 'LE000149', 'E017'),
    ('AL000150', 'LE000150', 'E018'),
    ('AL000151', 'LE000151', 'E019'),
    ('AL000152', 'LE000152', 'E020'),
    
    ('AL000153', 'LE000153', 'E015'),
    ('AL000154', 'LE000154', 'E016'),
    ('AL000155', 'LE000155', 'E017'),
    ('AL000156', 'LE000156', 'E018'),
    ('AL000157', 'LE000157', 'E019'),
    ('AL000158', 'LE000158', 'E020'),

    ('AL000159', 'LE000159', 'E015'),
    ('AL000160', 'LE000160', 'E016'),
    ('AL000161', 'LE000161', 'E017'),
    ('AL000162', 'LE000162', 'E018'),
    ('AL000163', 'LE000163', 'E019'),
    ('AL000164', 'LE000164', 'E020'),

    ('AL000165', 'LE000165', 'E015'),
    ('AL000166', 'LE000166', 'E016'),
    ('AL000167', 'LE000167', 'E017'),
    ('AL000168', 'LE000168', 'E018'),
    ('AL000169', 'LE000169', 'E019'),
    ('AL000170', 'LE000170', 'E020'),

    ('AL000171', 'LE000171', 'E015'),
    ('AL000172', 'LE000172', 'E016'),
    ('AL000173', 'LE000173', 'E017'),
    ('AL000174', 'LE000174', 'E018'),
    ('AL000175', 'LE000175', 'E019'),
    ('AL000176', 'LE000176', 'E020'),

    ('AL000177', 'LE000177', 'E015'),
    ('AL000178', 'LE000178', 'E016'),
    ('AL000179', 'LE000179', 'E017'),
    ('AL000180', 'LE000180', 'E018'),
    ('AL000181', 'LE000181', 'E019'),
    ('AL000182', 'LE000182', 'E020'),
    
    ('AL000183', 'LE000183', 'E015'),
    ('AL000184', 'LE000184', 'E016'),
    ('AL000185', 'LE000185', 'E017'),
    ('AL000186', 'LE000186', 'E018'),
    ('AL000187', 'LE000187', 'E019'),
    ('AL000188', 'LE000188', 'E020'),

    ('AL000189', 'LE000189', 'E015'),
    ('AL000190', 'LE000190', 'E016'),
    ('AL000191', 'LE000191', 'E017'),
    ('AL000192', 'LE000192', 'E018'),
    ('AL000193', 'LE000193', 'E019'),
    ('AL000194', 'LE000194', 'E020'),

    ('AL000195', 'LE000195', 'E015'),
    ('AL000196', 'LE000196', 'E016'),
    ('AL000197', 'LE000197', 'E017'),
    ('AL000198', 'LE000198', 'E018'),
    ('AL000199', 'LE000199', 'E019'),
    ('AL000200', 'LE000200', 'E020');
    
-- -------------- COMENTARIOS CLASE -------------------
    
INSERT INTO comentarios_clase (id_comentario_clase, id_asistencia_clase, comentario, calificacion)
VALUES
    ('COC000001', 'AC000001', 'Excellent explanation of traffic signs.', 1),
    ('COC000002', 'AC000002', 'The class was a bit boring, but informative.', 2),
    ('COC000003', 'AC000003', 'Great detail in parking rules.', 5),
    ('COC000004', 'AC000004', 'More information on emergency situations was needed.', 3),
    ('COC000005', 'AC000005', 'Very good class, clear and concise.', 5),
    ('COC000006', 'AC000006', 'The instructor explained the safety rules very well.', 4),
    ('COC000007', 'AC000007', 'The class was longer than necessary.', 2),
    ('COC000008', 'AC000008', 'Practical examples would be useful.', 5),
    ('COC000009', 'AC000009', 'The night driving part was very useful.', 3),
    ('COC000010', 'AC000010', 'Needs to improve the quality of teaching materials.', 1),
    ('COC000011', 'AC000011', 'Perfect introduction to traffic laws.', 3),
    ('COC000012', 'AC000012', 'There could be more interaction in the class.', 2),
    ('COC000013', 'AC000013', 'Valuable information about vehicle maintenance.', 1),
    ('COC000014', 'AC000014', 'The teacher was very patient and clear.', 1),
    ('COC000015', 'AC000015', 'More real examples in the explanations are needed.', 2);
    
-- -------------- COMENTARIOS LECCION -------------------

INSERT INTO comentarios_leccion (id_comentario_leccion, id_asistencia_leccion, comentario, calificacion)
VALUES
    ('COL000001', 'AL000001', 'Incredible practical experience, learned a lot.', 4),
    ('COL000002', 'AL000002', 'The instructor was very clear with the instructions.', 3),
    ('COL000003', 'AL000003', 'I felt safe throughout the lesson.', 2),
    ('COL000004', 'AL000004', 'The parking practice was very useful.', 3),
    ('COL000005', 'AL000005', 'We need more time on the road.', 1),
    ('COL000006', 'AL000006', 'Excellent handling of real traffic situations.', 5),
    ('COL000007', 'AL000007', 'The rain simulation was very realistic.', 1),
    ('COL000008', 'AL000008', 'I would like more practice in night conditions.', 4),
    ('COL000009', 'AL000009', 'The vehicle used was in perfect condition.', 4),
    ('COL000010', 'AL000010', 'The lesson was a bit fast for beginners.', 1),
    ('COL000011', 'AL000011', 'Great practice with different types of roads.', 5),
    ('COL000012', 'AL000012', 'The instructor gave excellent safety tips.', 4),
    ('COL000013', 'AL000013', 'The lesson was fun and educational.', 1),
    ('COL000014', 'AL000014', 'It would be useful to have more maneuverability exercises.', 3),
    ('COL000015', 'AL000015', 'Lacked examples of highway driving.', 2);

-- CONSULTAS

-- ¿A qué clases ha asistido los estudiantes, con cuales instructores, que salón, qué temas de clase y qué fecha y hora?

SELECT clases.cedula_instructor, clases.id_clase, clases.id_salon, clases.nro_tema_clase, asistencia_clases.cedula_estudiante, clases.fecha_clase, clases.hora_inicio, clases.hora_fin
FROM clases
JOIN asistencia_clases ON clases.id_clase = asistencia_clases.id_clase;

-- ¿A qué clases ha asistido los estudiantes, con cuales instructores, que salón, qué temas de clase y qué fecha y hora? CON NOMBRES

SELECT instructores.nombre_instructor, clases.id_clase, clases.id_salon, temas_clase.titulo_tema, estudiantes.nombre_estudiante, clases.fecha_clase, clases.hora_inicio, clases.hora_fin
FROM clases
JOIN asistencia_clases ON clases.id_clase = asistencia_clases.id_clase
JOIN estudiantes ON asistencia_clases.cedula_estudiante = estudiantes.cedula_estudiante
JOIN instructores ON clases.cedula_instructor = instructores.cedula_instructor
JOIN temas_clase ON clases.nro_tema_clase = temas_clase.nro_tema_clase;

-- ¿Cual es el instructor que mas lecciones ha impartido?

SELECT *
FROM (SELECT cedula_instructor, COUNT(id_leccion) AS CantidadLecciones
	  FROM lecciones
	  GROUP BY cedula_instructor) AS subconsulta1
WHERE CantidadLecciones = (SELECT MAX(CantidadLecciones)
						   FROM (SELECT cedula_instructor, COUNT(id_leccion) AS CantidadLecciones
						   FROM lecciones
						   GROUP BY cedula_instructor) AS subconsulta2);

-- estudiante que mas ha reprobado su examen teorico

SELECT cedula_estudiante, COUNT(estado_examen) AS VecesReprobado
FROM examenes
GROUP BY cedula_estudiante
HAVING VecesReprobado >= ALL(SELECT COUNT(estado_examen) AS VecesReprobado
							 FROM examenes
							 GROUP BY cedula_estudiante);
  	
-- Consulta final, ¿Cuál es el vehiculo mas utilizado por el estudiante que mas ha reprobado su examen teorico?

SELECT *
FROM (SELECT asistencia_lecciones.cedula_estudiante, lecciones.placa_vehiculo, COUNT(lecciones.placa_vehiculo) AS VecesUtilizado
	  FROM lecciones
	  JOIN asistencia_lecciones ON lecciones.id_leccion = asistencia_lecciones.id_leccion
	  WHERE asistencia_lecciones.cedula_estudiante = (SELECT cedula_estudiante
													  FROM (SELECT cedula_estudiante, COUNT(estado_examen) AS VecesReprobado
														    FROM examenes
														    GROUP BY cedula_estudiante
														    HAVING VecesReprobado >= ALL(SELECT COUNT(estado_examen) AS VecesReprobado
																					     FROM examenes
																					     GROUP BY cedula_estudiante)) AS subconsulta1)
	  GROUP BY asistencia_lecciones.cedula_estudiante, lecciones.placa_vehiculo) AS subconsulta2
WHERE VecesUtilizado = (SELECT MAX(VecesUtilizado)
						FROM (SELECT asistencia_lecciones.cedula_estudiante, lecciones.placa_vehiculo, COUNT(lecciones.placa_vehiculo) AS VecesUtilizado
							  FROM lecciones
							  JOIN asistencia_lecciones ON lecciones.id_leccion = asistencia_lecciones.id_leccion
							  WHERE asistencia_lecciones.cedula_estudiante = (SELECT cedula_estudiante
																			  FROM (SELECT cedula_estudiante, COUNT(estado_examen) AS VecesReprobado
																				    FROM examenes
																				    GROUP BY cedula_estudiante
																				    HAVING VecesReprobado >= ALL(SELECT COUNT(estado_examen) AS VecesReprobado
																											     FROM examenes
																											     GROUP BY cedula_estudiante)) AS subconsulta1)
							  GROUP BY asistencia_lecciones.cedula_estudiante, lecciones.placa_vehiculo) AS subconsulta3);

    

    