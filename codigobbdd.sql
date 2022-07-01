DROP TABLE afiliados CASCADE CONSTRAINTS;

DROP TABLE beneficios CASCADE CONSTRAINTS;

DROP TABLE cargas CASCADE CONSTRAINTS;

DROP TABLE cheques CASCADE CONSTRAINTS;

DROP TABLE comunas CASCADE CONSTRAINTS;

DROP TABLE descto_deporte CASCADE CONSTRAINTS;

DROP TABLE descto_transporte CASCADE CONSTRAINTS;

DROP TABLE marcas CASCADE CONSTRAINTS;

DROP TABLE membresias CASCADE CONSTRAINTS;

DROP TABLE modelos CASCADE CONSTRAINTS;

DROP TABLE pagos_afiliacion CASCADE CONSTRAINTS;

DROP TABLE provincias CASCADE CONSTRAINTS;

DROP TABLE regiones CASCADE CONSTRAINTS;

DROP TABLE seguro_auto CASCADE CONSTRAINTS;

DROP TABLE solicitudes_inscripcion CASCADE CONSTRAINTS;

DROP TABLE telefonos CASCADE CONSTRAINTS;

DROP TABLE tipo_pago CASCADE CONSTRAINTS;

DROP TABLE tipo_vehiculo CASCADE CONSTRAINTS;

DROP TABLE vehiculos CASCADE CONSTRAINTS;

CREATE TABLE afiliados (
    num_carnet_socio     NVARCHAR2(255) NOT NULL,
    primer_nombre        VARCHAR2(4000) NOT NULL,
    segundo_nombre       VARCHAR2(4000),
    primer_apellido      VARCHAR2(4000) NOT NULL,
    segundo_apellido     VARCHAR2(4000) NOT NULL,
    fecha_nacimiento     DATE NOT NULL,
    direccion            NVARCHAR2(255) NOT NULL,
    genero               CHAR(1) NOT NULL,
    es_chileno           CHAR(1) NOT NULL,
    nacionalidad         VARCHAR2(255 CHAR) NOT NULL,
    rut                  NVARCHAR2(255),
    num_pasaporte        NVARCHAR2(255),
    es_discapacitado     CHAR(1) NOT NULL,
    tipo_discapacidad    VARCHAR2(4000),
    pretencion_sueldo    INTEGER NOT NULL,
    correo_electronico   NVARCHAR2(255) NOT NULL,
    curriculum_vitae     BLOB NOT NULL,
    id_comuna            NVARCHAR2(255) NOT NULL,
    id_provincia         NVARCHAR2(255) NOT NULL,
    id_region            NVARCHAR2(255) NOT NULL
);

--genero 1-> mujer ; 0-> hombre
--es_chileno 1->chileno ; 0->extranjero
--es_discapacitado 1->es discapacitado ; 0-> no lo es

ALTER TABLE afiliados ADD CONSTRAINT afiliados_pk PRIMARY KEY ( num_carnet_socio );

CREATE TABLE beneficios (
    id_beneficio              NVARCHAR2(255) NOT NULL,
    tipo_beneficio            VARCHAR2(4000) NOT NULL,
    membresias_id_membresia   NVARCHAR2(255) NOT NULL
);

ALTER TABLE beneficios ADD CONSTRAINT beneficios_pk PRIMARY KEY ( id_beneficio,
                                                                  membresias_id_membresia );

CREATE TABLE cargas (
    id_carga                     NVARCHAR2(255) NOT NULL,
    rut                          NVARCHAR2(255),
    num_pasaporte                NVARCHAR2(255),
    primer_nombre                VARCHAR2(4000) NOT NULL,
    segundo_nombre               VARCHAR2(4000),
    primer_apellido              VARCHAR2(4000) NOT NULL,
    segundo_apellido             VARCHAR2(4000) NOT NULL,
    fecha_nacimiento             DATE NOT NULL,
    parentesco                   CHAR(1) NOT NULL,
    tipo_pareja                  INTEGER,
    afiliados_num_carnet_socio   NVARCHAR2(255) NOT NULL
);

--parentesco 1->hijo/a ; 0->pareja
--tipo_pareja 1.Casado(a) ; 2.Conviviente civil ; 3.Viudo(a) ; Separado(a) judicialmente ->No aplica ; Divorciado(a) -> No aplica ; Soltero(a) ->No aplica

ALTER TABLE cargas ADD CONSTRAINT cargas_pk PRIMARY KEY ( id_carga,
                                                          afiliados_num_carnet_socio );

CREATE TABLE cheques (
    num_cheque                                                            NVARCHAR2(255) NOT NULL,
    banco_emision                                                         VARCHAR2(4000) NOT NULL,
    tipo_pago_id_tipo_pago                                                NVARCHAR2(255) NOT NULL, 
    tipo_pago_pagos_afiliacion_id_pago                                    NVARCHAR2(255) NOT NULL, 
    tipo_pago_pagos_afiliacion_solicitudes_inscripcion_id_solicitud       NVARCHAR2(255) NOT NULL, 
    tipo_pago_pagos_afiliacion_solicitudes_inscripcion_num_carnet_socio   NVARCHAR2(255) NOT NULL
);

ALTER TABLE cheques
    ADD CONSTRAINT cheques_pk PRIMARY KEY ( num_cheque,
                                            tipo_pago_id_tipo_pago,
                                            tipo_pago_pagos_afiliacion_id_pago,
                                            tipo_pago_pagos_afiliacion_solicitudes_inscripcion_id_solicitud,
                                            tipo_pago_pagos_afiliacion_solicitudes_inscripcion_num_carnet_socio );

CREATE TABLE comunas (
    id_comuna                       NVARCHAR2(255) NOT NULL,
    nombre_comuna                   VARCHAR2(4000) NOT NULL,
    provincias_id_provincia         NVARCHAR2(255) NOT NULL,
    provincias_regiones_id_region   NVARCHAR2(255) NOT NULL
);

ALTER TABLE comunas
    ADD CONSTRAINT comunas_pk PRIMARY KEY ( id_comuna,
                                            provincias_id_provincia,
                                            provincias_regiones_id_region );

CREATE TABLE descto_deporte (
    id_deporte                           NVARCHAR2(255) NOT NULL,
    cant_max_uso                         INTEGER NOT NULL,
    porcentaje_descto                    FLOAT(2) NOT NULL,
    beneficios_id_beneficio              NVARCHAR2(255) NOT NULL, 
    beneficios_membresias_id_membresia   NVARCHAR2(255) NOT NULL
);

ALTER TABLE descto_deporte
    ADD CONSTRAINT descto_deporte_pk PRIMARY KEY ( beneficios_id_beneficio,
                                                   beneficios_membresias_id_membresia,
                                                   id_deporte );

CREATE TABLE descto_transporte (
    id_transporte                        NVARCHAR2(255) NOT NULL,
    tipo_transporte                      VARCHAR2(4000) NOT NULL,
    porcentaje_descto                    FLOAT(2) NOT NULL,
    beneficios_id_beneficio              NVARCHAR2(255) NOT NULL, 
    beneficios_membresias_id_membresia   NVARCHAR2(255) NOT NULL
);

ALTER TABLE descto_transporte ADD CONSTRAINT descto_transporte_pk PRIMARY KEY ( id_transporte );

CREATE TABLE marcas (
    id_marca       NVARCHAR2(255) NOT NULL,
    nombre_marca   VARCHAR2(4000) NOT NULL
);

ALTER TABLE marcas ADD CONSTRAINT marcas_pk PRIMARY KEY ( id_marca );

CREATE TABLE membresias (
    id_membresia                 NVARCHAR2(255) NOT NULL,
    estado_membresia             CHAR(1) NOT NULL,
    afiliados_num_carnet_socio   NVARCHAR2(255) NOT NULL
);

--estado_membresia 1->habilitado ; 0->deshabilitado

CREATE UNIQUE INDEX membresias__idx ON
    membresias (
        afiliados_num_carnet_socio
    ASC );

ALTER TABLE membresias ADD CONSTRAINT membresias_pk PRIMARY KEY ( id_membresia );

CREATE TABLE modelos (
    id_modelo                        NVARCHAR2(255) NOT NULL,
    nombre_modelo                    VARCHAR2(4000) NOT NULL,
    tipo_vehiculo_id_tipo_vehiculo   NVARCHAR2(255) NOT NULL,
    marcas_id_marca                  NVARCHAR2(255) NOT NULL
);

ALTER TABLE modelos
    ADD CONSTRAINT modelos_pk PRIMARY KEY ( id_modelo,
                                            tipo_vehiculo_id_tipo_vehiculo,
                                            marcas_id_marca );

CREATE TABLE pagos_afiliacion (
    id_pago                                              NVARCHAR2(255) NOT NULL,
    fecha_pago_afiliacion                                DATE NOT NULL,
    monto_pago_afiliacion                                INTEGER NOT NULL, 
    solicitudes_inscripcion_id_solicitud                 NVARCHAR2(255) NOT NULL, 
    solicitudes_inscripcion_afiliados_num_carnet_socio   NVARCHAR2(255) NOT NULL,
    fecha_pago_membresia                                 DATE NOT NULL,
    monto_pago_membresia                                 INTEGER NOT NULL
);

ALTER TABLE pagos_afiliacion
    ADD CONSTRAINT pagos_afiliacion_pk PRIMARY KEY ( id_pago,
                                                     solicitudes_inscripcion_id_solicitud,
                                                     solicitudes_inscripcion_afiliados_num_carnet_socio );

CREATE TABLE provincias (
    id_provincia         NVARCHAR2(255) NOT NULL,
    nombre_provincia     VARCHAR2(4000) NOT NULL,
    regiones_id_region   NVARCHAR2(255) NOT NULL
);

ALTER TABLE provincias ADD CONSTRAINT provincias_pk PRIMARY KEY ( id_provincia,
                                                                  regiones_id_region );

CREATE TABLE regiones (
    id_region       NVARCHAR2(255) NOT NULL,
    nombre_region   VARCHAR2(4000) NOT NULL
);

ALTER TABLE regiones ADD CONSTRAINT regiones_pk PRIMARY KEY ( id_region );

CREATE TABLE seguro_auto (
    id_seguro_auto                       NVARCHAR2(255) NOT NULL,
    prima_calculada                      INTEGER NOT NULL,
    porcentaje_descto                    FLOAT(2) NOT NULL,
    beneficios_id_beneficio              NVARCHAR2(255) NOT NULL, 
    beneficios_membresias_id_membresia   NVARCHAR2(255) NOT NULL
);

ALTER TABLE seguro_auto ADD CONSTRAINT seguro_auto_pk PRIMARY KEY ( id_seguro_auto );

CREATE TABLE solicitudes_inscripcion (
    id_solicitud                 NVARCHAR2(255) NOT NULL,
    fecha_solicitud              DATE NOT NULL,
    afiliados_num_carnet_socio   NVARCHAR2(255) NOT NULL
);

ALTER TABLE solicitudes_inscripcion ADD CONSTRAINT solicitudes_inscripcion_pk PRIMARY KEY ( id_solicitud,
                                                                                            afiliados_num_carnet_socio );

CREATE TABLE telefonos (
    id_telefono                  NVARCHAR2(255) NOT NULL,
    num_telefono                 INTEGER NOT NULL,
    tipo_num_telefono            VARCHAR2(4000) NOT NULL,
    afiliados_num_carnet_socio   NVARCHAR2(255) NOT NULL
);

ALTER TABLE telefonos ADD CONSTRAINT telefonos_pk PRIMARY KEY ( id_telefono,
                                                                afiliados_num_carnet_socio );

CREATE TABLE tipo_pago (
    id_tipo_pago                                                          NVARCHAR2(255) NOT NULL,
    tipo                                                                  VARCHAR2(4000) NOT NULL,
    pagos_afiliacion_id_pago                                              NVARCHAR2(255) NOT NULL, 
    pagos_afiliacion_solicitudes_inscripcion_id_solicitud                 NVARCHAR2(255) NOT NULL, 
    pagos_afiliacion_solicitudes_inscripcion_afiliados_num_carnet_socio   NVARCHAR2(255) NOT NULL
);

ALTER TABLE tipo_pago
    ADD CONSTRAINT tipo_pago_pk PRIMARY KEY ( id_tipo_pago,
                                              pagos_afiliacion_id_pago,
                                              pagos_afiliacion_solicitudes_inscripcion_id_solicitud,
                                              pagos_afiliacion_solicitudes_inscripcion_afiliados_num_carnet_socio );

CREATE TABLE tipo_vehiculo (
    id_tipo_vehiculo   NVARCHAR2(255) NOT NULL,
    tipo_vehiculo      VARCHAR2(4000) NOT NULL
);

ALTER TABLE tipo_vehiculo ADD CONSTRAINT tipo_vehiculo_pk PRIMARY KEY ( id_tipo_vehiculo );

CREATE TABLE vehiculos (
    id_vehiculo                      NVARCHAR2(255) NOT NULL,
    patente_vehiculo                 NVARCHAR2(255) NOT NULL,
    color_vehiculo                   VARCHAR2(4000) NOT NULL,
    num_chasis                       NVARCHAR2(255) NOT NULL,
    num_motor                        NVARCHAR2(255) NOT NULL,
    afiliados_num_carnet_socio       NVARCHAR2(255) NOT NULL,
    tipo_vehiculo_id_tipo_vehiculo   NVARCHAR2(255) NOT NULL
);

ALTER TABLE vehiculos
    ADD CONSTRAINT vehiculos_pk PRIMARY KEY ( id_vehiculo,
                                              afiliados_num_carnet_socio,
                                              tipo_vehiculo_id_tipo_vehiculo );

ALTER TABLE afiliados
    ADD CONSTRAINT afiliados_comunas_fk FOREIGN KEY ( id_comuna,
                                                      id_provincia,
                                                      id_region )
        REFERENCES comunas ( id_comuna,
                             provincias_id_provincia,
                             provincias_regiones_id_region );

ALTER TABLE beneficios
    ADD CONSTRAINT beneficios_membresias_fk FOREIGN KEY ( membresias_id_membresia )
        REFERENCES membresias ( id_membresia );

ALTER TABLE cargas
    ADD CONSTRAINT cargas_afiliados_fk FOREIGN KEY ( afiliados_num_carnet_socio )
        REFERENCES afiliados ( num_carnet_socio );

ALTER TABLE cheques
    ADD CONSTRAINT cheques_tipo_pago_fk FOREIGN KEY ( tipo_pago_id_tipo_pago,
                                                      tipo_pago_pagos_afiliacion_id_pago,
                                                      tipo_pago_pagos_afiliacion_solicitudes_inscripcion_id_solicitud,
                                                      tipo_pago_pagos_afiliacion_solicitudes_inscripcion_num_carnet_socio )
        REFERENCES tipo_pago ( id_tipo_pago,
                               pagos_afiliacion_id_pago,
                               pagos_afiliacion_solicitudes_inscripcion_id_solicitud,
                               pagos_afiliacion_solicitudes_inscripcion_afiliados_num_carnet_socio );

ALTER TABLE comunas
    ADD CONSTRAINT comunas_provincias_fk FOREIGN KEY ( provincias_id_provincia,
                                                       provincias_regiones_id_region )
        REFERENCES provincias ( id_provincia,
                                regiones_id_region );

ALTER TABLE descto_deporte
    ADD CONSTRAINT descto_deporte_beneficios_fk FOREIGN KEY ( beneficios_id_beneficio,
                                                              beneficios_membresias_id_membresia )
        REFERENCES beneficios ( id_beneficio,
                                membresias_id_membresia );
 
ALTER TABLE descto_transporte
    ADD CONSTRAINT descto_transporte_beneficios_fk FOREIGN KEY ( beneficios_id_beneficio,
                                                                 beneficios_membresias_id_membresia )
        REFERENCES beneficios ( id_beneficio,
                                membresias_id_membresia );

ALTER TABLE membresias
    ADD CONSTRAINT membresias_afiliados_fk FOREIGN KEY ( afiliados_num_carnet_socio )
        REFERENCES afiliados ( num_carnet_socio );

ALTER TABLE modelos
    ADD CONSTRAINT modelos_marcas_fk FOREIGN KEY ( marcas_id_marca )
        REFERENCES marcas ( id_marca );

ALTER TABLE modelos
    ADD CONSTRAINT modelos_tipo_vehiculo_fk FOREIGN KEY ( tipo_vehiculo_id_tipo_vehiculo )
        REFERENCES tipo_vehiculo ( id_tipo_vehiculo );
 
ALTER TABLE pagos_afiliacion
    ADD CONSTRAINT pagos_afiliacion_solicitudes_inscripcion_fk FOREIGN KEY ( solicitudes_inscripcion_id_solicitud,
                                                                             solicitudes_inscripcion_afiliados_num_carnet_socio )
        REFERENCES solicitudes_inscripcion ( id_solicitud,
                                             afiliados_num_carnet_socio );

ALTER TABLE provincias
    ADD CONSTRAINT provincias_regiones_fk FOREIGN KEY ( regiones_id_region )
        REFERENCES regiones ( id_region );

ALTER TABLE seguro_auto
    ADD CONSTRAINT seguro_auto_beneficios_fk FOREIGN KEY ( beneficios_id_beneficio,
                                                           beneficios_membresias_id_membresia )
        REFERENCES beneficios ( id_beneficio,
                                membresias_id_membresia );

ALTER TABLE solicitudes_inscripcion
    ADD CONSTRAINT solicitudes_inscripcion_afiliados_fk FOREIGN KEY ( afiliados_num_carnet_socio )
        REFERENCES afiliados ( num_carnet_socio );

ALTER TABLE telefonos
    ADD CONSTRAINT telefonos_afiliados_fk FOREIGN KEY ( afiliados_num_carnet_socio )
        REFERENCES afiliados ( num_carnet_socio );

ALTER TABLE tipo_pago
    ADD CONSTRAINT tipo_pago_pagos_afiliacion_fk FOREIGN KEY ( pagos_afiliacion_id_pago,
                                                               pagos_afiliacion_solicitudes_inscripcion_id_solicitud,
                                                               pagos_afiliacion_solicitudes_inscripcion_afiliados_num_carnet_socio
                                                               )
        REFERENCES pagos_afiliacion ( id_pago,
                                      solicitudes_inscripcion_id_solicitud,
                                      solicitudes_inscripcion_afiliados_num_carnet_socio );

ALTER TABLE vehiculos
    ADD CONSTRAINT vehiculos_afiliados_fk FOREIGN KEY ( afiliados_num_carnet_socio )
        REFERENCES afiliados ( num_carnet_socio );

ALTER TABLE vehiculos
    ADD CONSTRAINT vehiculos_tipo_vehiculo_fk FOREIGN KEY ( tipo_vehiculo_id_tipo_vehiculo )
        REFERENCES tipo_vehiculo ( id_tipo_vehiculo );
--INSERT DE DATOS

INSERT INTO regiones VALUES ('1','Metropolitana');
INSERT INTO regiones VALUES ('2','Valparaiso');
INSERT INTO regiones VALUES ('3','Coquimbo');

INSERT INTO provincias VALUES ('1','Santiago','1');
INSERT INTO provincias VALUES ('2','Chacabuco','1');
INSERT INTO provincias VALUES ('3','Maipo','1');
INSERT INTO provincias VALUES ('4','Los Andes','2');
INSERT INTO provincias VALUES ('5','Valparaiso','2');
INSERT INTO provincias VALUES ('6','Isla de Pascua','2');
INSERT INTO provincias VALUES ('7','Elqui','3');
INSERT INTO provincias VALUES ('8','Limari','3');
INSERT INTO provincias VALUES ('9','Choapa','3');

INSERT INTO comunas VALUES ('1','Santiago','1','1');
INSERT INTO comunas VALUES ('2','Colina','2','1');
INSERT INTO comunas VALUES ('3','Paine','3','1');
INSERT INTO comunas VALUES ('4','Los Andes','4','2');
INSERT INTO comunas VALUES ('5','Concon','5','2');
INSERT INTO comunas VALUES ('6','Isla de pascua','6','2');
INSERT INTO comunas VALUES ('7','La Serena','7','3');
INSERT INTO comunas VALUES ('1','Ovalle','8','3');
INSERT INTO comunas VALUES ('1','Illapel','9','3');

INSERT INTO telefonos VALUES ('1',92203285,'Celular','196253655');
INSERT INTO telefonos VALUES ('2',82703583,'Celular','176653455');
INSERT INTO telefonos VALUES ('3',82113458,'Celular','206893612');
INSERT INTO telefonos VALUES ('4',226016499,'Fijo','196253655');

INSERT INTO cargas VALUES ('1','21569852k','','Juan','Alberto','Cruz','Suazo','2021/05/23',1,'','176653455');
INSERT INTO cargas VALUES ('2','245656520','','Francisca','Javiera','Cruz','Suazo','2021/05/23',1,'','176653455');
INSERT INTO cargas VALUES ('2','199638524','','Maria','Magdalena','Fuenzalida','Herrera','2020/02/15',0,2,'196253655');