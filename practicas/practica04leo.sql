SET SERVEROUTPUT ON;

CREATE TABLE log_create(
    id_log INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    usuario varchar(50),
    fecha_creacion timestamp,
    tabla varchar(50)
);

CREATE OR REPLACE TRIGGER registrar_create 
AFTER CREATE ON SCHEMA
BEGIN
    IF(ORA_DICT_OBJ_TYPE = 'TABLE') THEN
        INSERT INTO log_create
        VALUES(default,USER,SYSDATE,ORA_DICT_OBJ_NAME);
    END IF;
END;

CREATE TABLE prueba(
    id_prueba number
);

CREATE TABLE prueba2(
    id_prueba number
);

CREATE TABLE prueba3(
    id_prueba number
);

SELECT * FROM log_create;