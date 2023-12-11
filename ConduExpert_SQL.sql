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
        id VARCHAR(15) NOT NULL,
        cedula_instructor VARCHAR(15) NOT NULL,
        fecha DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        disponible BOOLEAN NOT NULL,
        CONSTRAINT pk_disp_instructor PRIMARY KEY (id),
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
        fecha_examen DATE NOT NULL,
        hora_examen TIME NOT NULL,
        estado_examen VARCHAR(15) NOT NULL,
        nota_examen DECIMAL(2, 1) NOT NULL,
        total_preguntas INT NOT NULL,
        preguntas_acertadas INT NOT NULL,
        CONSTRAINT pk_examen PRIMARY KEY (id_examen),
        CONSTRAINT fk_id_curso_teorico_examen FOREIGN KEY (id_curso_teorico) REFERENCES cursos_teoricos (id_curso_teorico),
        CONSTRAINT fk_cedula_estudiante_examen FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante),
        CONSTRAINT ck_estado_examen CHECK (
            estado_examen = 'APROBADO'
            OR estado_examen = 'PENDIENTE'
            OR estado_examen = 'REPROBADO'
        )
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
        id_salon VARCHAR(5) NOT NULL,
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
        fecha DATE NOT NULL,
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
        fecha DATE NOT NULL,
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
        CONSTRAINT ck_metodo_pago CHECK (
            metodo_pago = 'TARJETA'
            OR metodo_pago = 'EFECTIVO'
        )
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
    ('F000001', 'C000001', 'E001', 1500000, ''),
	('F000002', 'C000002', 'E002', 1500000, ''),
	('F000003', 'C000003', 'E003', 700000, ''),
	('F000004', 'C000004', 'E003', 800000, ''),
	('F000005', 'C000005', 'E004', 1500000, ''),
	('F000006', 'C000006', 'E005', 1500000, ''),
	('F000007', 'C000007', 'E006', 1500000, ''),
	('F000008', 'C000008', 'E007', 1500000, ''),
    
	('F000009', 'C000009', 'E008', 1000000, ''),
	('F000010', 'C000010', 'E009', 1000000, ''),
	('F000011', 'C000011', 'E010', 1000000, ''),
	('F000012', 'C000012', 'E011', 500000, ''),
	('F000013', 'C000013', 'E011', 500000, ''),
	('F000014', 'C000014', 'E012', 1000000, ''),
	('F000015', 'C000015', 'E013', 1000000, ''),
	('F000016', 'C000016', 'E014', 1000000, ''),
    
	('F000017', 'C000017', 'E015', 1000000, ''),
	('F000018', 'C000018', 'E015', 1000000, ''),
	('F000019', 'C000019', 'E016', 2000000, ''),
	('F000020', 'C000020', 'E017', 2000000, ''),
	('F000021', 'C000021', 'E018', 2000000, ''),
	('F000022', 'C000022', 'E019', 2000000, ''),
	('F000023', 'C000023', 'E020', 2000000, '');



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
    ('S106', 'Piso 1', 30),
    ('S107', 'Piso 1', 45),
    ('S108', 'Piso 1', 30),
    ('S201', 'Piso 2', 35),
    ('S202', 'Piso 2', 30),
    ('S203', 'Piso 2', 35),
    ('S204', 'Piso 2', 30),
    ('S205', 'Piso 2', 30),
    ('S206', 'Piso 2', 35),
    ('S207', 'Piso 2', 30),
    ('S301', 'Piso 3', 40),
    ('S302', 'Piso 3', 40),
    ('S303', 'Piso 3', 45),
    ('S304', 'Piso 3', 40),
    ('S305', 'Piso 3', 30),
    ('S306', 'Piso 3', 45),
    ('S307', 'Piso 3', 35),
    ('S401', 'Piso 4', 35),
    ('S402', 'Piso 4', 45),
    ('S403', 'Piso 4', 40),
    ('S404', 'Piso 4', 25),
    ('S405', 'Piso 4', 40),
    ('S406', 'Piso 4', 35);
    
    
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
    
    

