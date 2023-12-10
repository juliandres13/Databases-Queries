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
        CONSTRAINT ck_categoria CHECK (
            categoria = 'MOTOCICLETA'
            OR categoria = 'AUTOMOVIL'
        )
    );

CREATE TABLE
    disponibilidad_instructores (
        id VARCHAR(10) NOT NULL,
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
        soat VARCHAR(50) NOT NULL,
        CONSTRAINT pk_vehiculo PRIMARY KEY (placa_vehiculo),
        CONSTRAINT ck_tipo_vehiculo CHECK (
            tipo_vehiculo = 'MOTOCICLETA'
            OR tipo_vehiculo = 'AUTOMOVIL'
        )
    );

CREATE TABLE
    salones (
        id_salon VARCHAR(5) NOT NULL,
        ubicacion_salon VARCHAR(30) NOT NULL,
        capacidad_salon INT (3) NOT NULL,
        CONSTRAINT pk_salon PRIMARY KEY (id_salon)
    );

CREATE TABLE
    cursos_teoricos (
        id_curso_teorico VARCHAR(20) NOT NULL,
        nit_academia VARCHAR(25) NOT NULL,
        costo INT (8) NOT NULL,
        CONSTRAINT pk_cursoteorico PRIMARY KEY (id_curso_teorico),
        CONSTRAINT fk_nit_academia_curso_teorico FOREIGN KEY (nit_academia) REFERENCES academias (nit_academia)
    );

CREATE TABLE
    cursos_practicos (
        id_curso_practico VARCHAR(20) NOT NULL,
        nit_academia VARCHAR(25) NOT NULL,
        costo INT (8) NOT NULL,
        CONSTRAINT pk_cursopractico PRIMARY KEY (id_curso_practico),
        CONSTRAINT fk_nit_academia_curso_practico FOREIGN KEY (nit_academia) REFERENCES academias (nit_academia)
    );

CREATE TABLE
    examenes (
        id_examen VARCHAR(10) NOT NULL,
        id_curso_teorico VARCHAR(20) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        fecha_examen DATE NOT NULL,
        hora_examen TIME NOT NULL,
        estado_examen VARCHAR(15) NOT NULL,
        nota_examen DECIMAL(2, 1) NOT NULL,
        total_preguntas INT (3) NOT NULL,
        preguntas_acertadas INT (3) NOT NULL,
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
    clases (
        id_clase VARCHAR(10) NOT NULL,
        id_curso_teorico VARCHAR(20) NOT NULL,
        cedula_instructor VARCHAR(15) NOT NULL,
        id_salon VARCHAR(5) NOT NULL,
        nro_tema INT (3) NOT NULL,
        descripcion_tema VARCHAR(100) NOT NULL,
        fecha_clase DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        CONSTRAINT pk_clase PRIMARY KEY (id_clase),
        CONSTRAINT fk_id_curso_teorico_clase FOREIGN KEY (id_curso_teorico) REFERENCES cursos_teoricos (id_curso_teorico),
        CONSTRAINT fk_cedula_instructor_clase FOREIGN KEY (cedula_instructor) REFERENCES instructores (cedula_instructor),
        CONSTRAINT fk_id_salon_clase FOREIGN KEY (id_salon) REFERENCES salones (id_salon)
    );

CREATE TABLE
    asistencia_clases (
        id_asistencia_clase VARCHAR(10) NOT NULL,
        id_clase VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        fecha DATE NOT NULL,
        CONSTRAINT pk_asistencia_clase PRIMARY KEY (id_asistencia_clase),
        CONSTRAINT fk_id_clase_ac FOREIGN KEY (id_clase) REFERENCES clases (id_clase),
        CONSTRAINT fk_cedula_estudiante_ac FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante)
    );

CREATE TABLE
    lecciones (
        id_leccion VARCHAR(10) NOT NULL,
        id_curso_practico VARCHAR(20) NOT NULL,
        cedula_instructor VARCHAR(15) NOT NULL,
        placa_vehiculo VARCHAR(10) NOT NULL,
        nro_leccion INT (3) NOT NULL,
        descripcion_leccion VARCHAR(100) NOT NULL,
        lugar_leccion VARCHAR(50) NOT NULL,
        fecha_leccion DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_finalizacion TIME NOT NULL,
        CONSTRAINT pk_leccion PRIMARY KEY (id_leccion),
        CONSTRAINT fk_id_curso_practico_leccion FOREIGN KEY (id_curso_practico) REFERENCES cursos_practicos (id_curso_practico),
        CONSTRAINT fk_cedula_instructor_leccion FOREIGN KEY (cedula_instructor) REFERENCES instructores (cedula_instructor),
        CONSTRAINT fk_placa_vehiculo_leccion FOREIGN KEY (placa_vehiculo) REFERENCES vehiculos (placa_vehiculo)
    );

CREATE TABLE
    asistencia_lecciones (
        id_asistencia_leccion VARCHAR(10) NOT NULL,
        id_leccion VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        fecha DATE NOT NULL,
        CONSTRAINT pk_asistencia_leccion PRIMARY KEY (id_asistencia_leccion),
        CONSTRAINT fk_id_leccion_al FOREIGN KEY (id_leccion) REFERENCES lecciones (id_leccion),
        CONSTRAINT fk_cedula_estudiante_al FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante)
    );

CREATE TABLE
    compras (
        id_compra VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        nro_compra_curso VARCHAR(10) NOT NULL,
        fecha DATE NOT NULL,
        estado_compra VARCHAR(25) NOT NULL,
        CONSTRAINT pk_compra PRIMARY KEY (id_compra),
        CONSTRAINT fk_cedula_estudiante_compra FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante),
        CONSTRAINT ck_estado_compra CHECK (
            estado_compra = 'LIQUIDADA'
            OR estado_compra = ''
        )
    );

CREATE TABLE
    facturas (
        id_factura VARCHAR(10) NOT NULL,
        id_compra VARCHAR(10) NOT NULL,
        cedula_estudiante VARCHAR(15) NOT NULL,
        total_a_pagar INT (8) NOT NULL,
        CONSTRAINT pk_factura PRIMARY KEY (id_factura),
        CONSTRAINT fk_id_compra_factura FOREIGN KEY (id_compra) REFERENCES compras (id_compra),
        CONSTRAINT fk_cedula_estudiante_factura FOREIGN KEY (cedula_estudiante) REFERENCES estudiantes (cedula_estudiante)
    );

CREATE TABLE
    pagos (
        id_pago VARCHAR(10) NOT NULL,
        id_factura VARCHAR(10) NOT NULL,
        fecha_pago DATE NOT NULL,
        metodo_pago VARCHAR(25) NOT NULL,
        valor_pago INT (8) NOT NULL,
        CONSTRAINT pk_pago PRIMARY KEY (id_pago),
        CONSTRAINT fk_id_factura_pago FOREIGN KEY (id_factura) REFERENCES facturas (id_factura),
        CONSTRAINT ck_metodo_pago CHECK (
            metodo_pago = 'TARJETA'
            OR metodo_pago = 'EFECTIVO'
        )
    );

----------------- ACADEMIAS --------------------
INSERT INTO
    academias (nit_academia, nombre_academia, direccion_academia, telefono_academia, correo_academia, fecha_fundacion, sitio_web)
VALUES
    ('NIT001', 'ConduExpert', 'Calle 20#60-05', '312-435-6087', 'conduexpert@gmail.com', '2000-06-20', 'www.conduexpert.com');

---------------- ESTUDIANTES -------------------
INSERT INTO
    estudiantes (cedula_estudiante, nombre_estudiante, apellido_estudiante, correo_estudiante, fecha_nacimiento_estudiante, telefono_estudiante)
VALUES
    ('E001', 'Julián Andrés', 'León Rivera', 'julian@gmail.com', '2003-12-13', '323-456-8987');

---------------- INSTRUCTORES ------------------
INSERT INTO 
    instructores (cedula_instructor, nit_academia, nombre_instructor, apellido_instructor, email_instructor, telefono_instructor, vigencia_licencia, categoria)
VALUES
    ('I001', 'NIT001', 'Miguel Ángel', 'Cardona', 'miguel@gmail.com', '311-233-6510', '2024-01-30', 'MOTOCICLETA');

---------------- VEHICULOS -------------------
INSERT INTO
    vehiculos (placa_vehiculo, tipo_vehiculo, marca, modelo, soat)
VALUES
    ('ABC-123', 'MOTOCICLETA', 'Pulsar', '2023', 'abc6754');

---------------- SALONES -------------------
INSERT INTO
    salones (id_salon, ubicacion_salon, capacidad_salon)
VALUES
    ('C206', 'Edificio Central', 35),
    ('D216', 'Parque', 30),
    ('U125', 'Bicentenario', 40),
    ('U225', 'Bicentenario', 45);
