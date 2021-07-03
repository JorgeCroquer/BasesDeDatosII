--Creamos el TDA para los datos basicos de las personas, y validad el formato de cédula
CREATE OR REPLACE TYPE DATOS_BA AS OBJECT(
    nombre varchar(25),
    apellido varchar(25),
    cedula varchar(25),

    STATIC FUNCTION validarCedula(cedula varchar) return varchar
);

CREATE OR REPLACE TYPE BODY DATOS_BA AS
    STATIC FUNCTION validarCedula(cedula varchar) return varchar IS
    BEGIN
        IF(cedula LIKE 'V-%') THEN
            RETURN cedula;
        ELSE
            RAISE_APPLICATION_ERROR(-20001,'Cedula Invalida');
        END IF;    
    END;
END;

--Creamos las tablas correspondientes

CREATE TABLE PAIS(
    id_pai INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL UNIQUE,
    nombre varchar(25) NOT NULL
);

CREATE TABLE VACUNA(
    id_vac INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL UNIQUE,
    nombre varchar(25) NOT NULL
);

CREATE TABLE PERSONA (
    id_per INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL UNIQUE,
    datos  DATOS_BA  NOT NULL,
    pri_dosis_per varchar(3) NOT NULL,
    seg_dosis_per varchar(3) NOT NULL,
    fk_pais_per INTEGER NOT NULL,
    fk_vacuna_per INTEGER NOT NULL,
    
    CONSTRAINT pri_dosis_per CHECK(pri_dosis_per IN ('YES','NO',NULL)),
    CONSTRAINT seg_dosis_per CHECK(seg_dosis_per IN ('YES','NO',NULL))
);

ALTER TABLE PERSONA ADD CONSTRAINT con_fk_pais FOREIGN KEY (fk_pais_per) REFERENCES PAIS(id_pai);
ALTER TABLE PERSONA ADD CONSTRAINT con_fk_vacuna FOREIGN KEY (fk_vacuna_per) REFERENCES VACUNA(id_vac);

--Creamos el procedimiento para contar la cantidad de personas que tienen solo la primera dosis e imprimir sus datos

CREATE OR REPLACE PROCEDURE primera_dosis(pais int) IS
Cantidad int := 0;
datos_basicos PERSONA%rowtype;
BEGIN
    --Primero mostramos el total de personas con la primera dósis
    SELECT COUNT(id_per) INTO Cantidad FROM PERSONA WHERE pri_dosis_per = 'YES' AND fk_pais_per = pais;
    DBMS_OUTPUT.PUT_LINE('La cantidad de personas con solo la primera dosis es: ' || Cantidad);
    --Ahora vamos a imprimir los datos de las personas con la primer dosis
    dbms_output.put_line('Nombre - Apellido - Cédula ');
    for r in (  SELECT *
                FROM PERSONA 
                WHERE pri_dosis_per = 'YES' AND seg_dosis_per = 'NO' )
    loop
        select *
        into datos_basicos
        From PERSONA P
        where id_per = r.id_per;
        dbms_output.put_line(datos_basicos.datos.nombre||' - '||datos_basicos.datos.apellido||' - '||datos_basicos.datos.cedula);
    end loop;    
END;

-- Insertamos datos de prueba

INSERT INTO PAIS VALUES (default, 'Venezuela');
INSERT INTO VACUNA VALUES(default, 'Sputnik');

INSERT INTO PERSONA VALUES(default,DATOS_BA('Pedro','Gomez',DATOS_BA.validarCedula('V-1234567')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Juan','Ramirez',DATOS_BA.validarCedula('V-1234568')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Carlos','Perez',DATOS_BA.validarCedula('V-1234568')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre4','Apellido4',DATOS_BA.validarCedula('V-1234510')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre5','Apellido5',DATOS_BA.validarCedula('V-1234511')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre6','Apellido6',DATOS_BA.validarCedula('V-1234512')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre7','Apellido7',DATOS_BA.validarCedula('V-1234513')),'YES','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre8','Apellido8',DATOS_BA.validarCedula('V-1234514')),'NO','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre9','Apellido9',DATOS_BA.validarCedula('V-1234515')),'NO','NO',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre10','Apellido10',DATOS_BA.validarCedula('V-1234516')),'YES','YES',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre11','Apellido11',DATOS_BA.validarCedula('V-1234517')),'YES','YES',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre12','Apellido12',DATOS_BA.validarCedula('V-1234518')),'YES','YES',1,1);
INSERT INTO PERSONA VALUES(default,DATOS_BA('Nombre13','Apellido13',DATOS_BA.validarCedula('V-1234519')),'YES','YES',1,1);

--Ejecutamos la función en el pais 1 (Venezuela)
execute primera_dosis(1);


