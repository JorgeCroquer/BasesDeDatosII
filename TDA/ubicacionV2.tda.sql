--OBJETO
CREATE OR REPLACE TYPE UBICACION AS OBJECT(
    latitud FLOAT,
    longitud FLOAT,
    direccion_textual varchar(200),
    MEMBER FUNCTION getLatitud RETURN FLOAT,
    MEMBER FUNCTION getLongitud RETURN FLOAT,
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2,
    STATIC FUNCTION validarLatitud(latitud FLOAT) RETURN FLOAT,
    STATIC FUNCTION validarLongitud(longitud FLOAT) RETURN FLOAT
);

--BODY
CREATE OR REPLACE TYPE BODY UBICACION AS
    MEMBER FUNCTION getLatitud RETURN FLOAT IS
        BEGIN 
            RETURN Latitud;
        END;
    MEMBER FUNCTION getLongitud RETURN FLOAT IS
        BEGIN 
            RETURN Longitud;
        END;
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2 IS
        BEGIN 
            RETURN '('||latitud|| '; ' ||longitud|| ')';
        END;
    STATIC FUNCTION validarLatitud(latitud FLOAT) RETURN FLOAT IS
        BEGIN 
            IF (latitud >= -90 AND latitud <= 90) THEN
                RETURN latitud;
            ELSE 
                RAISE_APPLICATION_ERROR(-20001, 'Latitud inválida');
            END IF;
        END;    
    STATIC FUNCTION validarLongitud(longitud FLOAT) RETURN FLOAT IS
        BEGIN 
            IF (longitud >= -180 AND longitud <= 180) THEN
                RETURN longitud;
            ELSE 
                RAISE_APPLICATION_ERROR(-20002, 'Longitud inválida');
            END IF;
        END; 
END;

--EJEMPLOS DE PRUEBA
CREATE TABLE UBICACIONES(
    lugar UBICACION
);

INSERT INTO UBICACIONES VALUES (UBICACION(UBICACION.validarLatitud(30.200),UBICACION.validarLongitud(33.33333),'En el patio al lado de mi casa jaja'));
INSERT INTO UBICACIONES VALUES (UBICACION(UBICACION.validarLatitud(-100.2223),UBICACION.validarLongitud(33.333333),'En el patio al lado de mi casa jaja'));
INSERT INTO UBICACIONES VALUES (UBICACION(UBICACION.validarLatitud(80.9334),UBICACION.validarLongitud(400.22),'En el patio al lado de mi casa jaja'));
INSERT INTO UBICACIONES VALUES (UBICACION(UBICACION.validarLatitud(10.46441),UBICACION.validarLongitud(-66.97596),'la ucab jajaja'));
INSERT INTO UBICACIONES VALUES (UBICACION(UBICACION.validarLatitud(10.48323),UBICACION.validarLongitud(-66.86294),'los perros de Joao'));

DELETE FROM UBICACIONES;

SELECT u.lugar.latitud, u.lugar.longitud, u.lugar.direccion_textual FROM ubicaciones u;