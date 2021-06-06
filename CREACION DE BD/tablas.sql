CREATE TABLE PAIS(  --FALTA DETALLE
    id_pai PLS_INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY ,
    nombre varchar(25) NOT NULL
);

CREATE TABLE GRUPO_ETARIO(
    id_ge PLS_INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre_ge VARCHAR2(50) NOT NULL,
    edad_inferior PLS_INTEGER NOT NULL,
    edad_superior PLS_INTEGER,
    mortalidad NUMBER NOT NULL
);

CREATE TABLE PAIS_GE( --FALTA EL TDA HABITANTES
    grupo_etario PLS_INTEGER,
    pais PLS_INTEGER,
    CONSTRAINT fk_ge
        FOREIGN KEY (grupo_etario)
        REFERENCES GRUPO_ETARIO(id_ge),
    CONSTRAINT fk_pais_pge
        FOREIGN KEY (pais)
        REFERENCES PAIS(id_pai),
    CONSTRAINT pk_pais_ge
        PRIMARY KEY (grupo_etario, pais)
);

CREATE TABLE ESTATUS(
    id_est PLS_INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre_est VARCHAR2(15) NOT NULL,
    descripcion_est VARCHAR(250)
);

CREATE TABLE VACUNA( --FALTA EL TDA F_FASES
    id_vac PLS_INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre_vac VARCHAR2(15) NOT NULL,
    estatus_vac PLS_INTEGER NOT NULL,
    efectividad_vac NUMBER,
    dosis_vac PLS_INTEGER NOT NULL,
    covax_vac CHAR NOT NULL,
    temperatura_vac NUMBER NOT NULL,
    instrucciones_vac VARCHAR2(250) NOT NULL,
    suministro_vac PLS_INTEGER NOT NULL,
    CONSTRAINT fk_estatus
        FOREIGN KEY (estatus_vac)
        REFERENCES ESTATUS(id_est),
    CONSTRAINT bool_covax
        CHECK (covax_vac IN ('Y', 'N'))

);

CREATE TABLE CENTRO_VAC(--FALTA EL TDA UBICACION
    id_cen PLS_INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre_cen VARCHAR2(50) NOT NULL,
    capacidad_cen PLS_INTEGER NOT NULL,
    pais_cv PLS_INTEGER NOT NULL,
    CONSTRAINT fk_pais_cv
        FOREIGN KEY (pais_cv)
        REFERENCES PAIS(id_pai)
);

CREATE TABLE JORNADA_VAC(
    fecha_jv DATE NOT NULL,
    cantidad_pri_jv PLS_INTEGER NOT NULL,
    cantidad_seg_jv PLS_INTEGER,
    centro_vac_jv PLS_INTEGER NOT NULL,
    vacuna_jv PLS_INTEGER NOT NULL,
    pais_jv PLS_INTEGER NOT NULL,
    grupo_etario_jv PLS_INTEGER NOT NULL,
    CONSTRAINT fk_centro_vac_jv
        FOREIGN KEY (centro_vac_jv)
        REFERENCES CENTRO_VAC(id_cen),
    CONSTRAINT fk_vac_jv
        FOREIGN KEY (vacuna_jv)
        REFERENCES VACUNA(id_vac),
    CONSTRAINT fk_pais_ge_jv
        FOREIGN KEY (grupo_etario_jv,pais_jv)
        REFERENCES PAIS_GE(grupo_etario, pais),
    CONSTRAINT pk_jv
        PRIMARY KEY (fecha_jv,pais_jv,grupo_etario_jv,centro_vac_jv,vacuna_jv)
);

CREATE TABLE EFECTO_SECUNDARIO(
    id_efe PLS_INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre_efe VARCHAR2(20) NOT NULL,
    descripcion_efe VARCHAR2(250),
    probabilidad_efe NUMBER
);

CREATE TABLE JV_EFEC(
    cantidad_efsec_jv PLS_INTEGER NOT NULL,
    vacuna_jve PLS_INTEGER NOT NULL,
    centro_vac_jve PLS_INTEGER NOT NULL,
    fecha_jve DATE NOT NULL,
    pais_jve PLS_INTEGER NOT NULL,
    grupo_etario_jve PLS_INTEGER NOT NULL,
    efecto_secundario_jve PLS_INTEGER NOT NULL,
    CONSTRAINT fk_jornada_jve
        FOREIGN KEY (fecha_jve,pais_jve,grupo_etario_jve,centro_vac_jve,vacuna_jve)
        REFERENCES  JORNADA_VAC(fecha_jv,pais_jv,grupo_etario_jv,centro_vac_jv,vacuna_jv),
    CONSTRAINT fk_efecto_jve
        FOREIGN KEY (efecto_secundario_jve)
        REFERENCES EFECTO_SECUNDARIO(id_efe)
);

CREATE TABLE VAC_EFEC(
    efecto_secundario_ve PLS_INTEGER NOT NULL,
    vacuna_ve PLS_INTEGER NOT NULL,
    CONSTRAINT fk_efecto_ve
        FOREIGN KEY (efecto_secundario_ve)
        REFERENCES EFECTO_SECUNDARIO(id_efe),
    CONSTRAINT fk_vacuna_ve
        FOREIGN KEY (vacuna_ve)
        REFERENCES VACUNA(id_vac)
);

