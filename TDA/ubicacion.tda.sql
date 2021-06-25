--OBJETO
CREATE OR REPLACE TYPE UBICACION AS OBJECT(
    latitud COORDENADA,
    longitud COORDENADA,
    direccion_textual varchar(200)
    MEMBER FUNCTION getLatitud RETURN COORDENADA,
    MEMBER FUNCTION getLongitud RETURN COORDENADA,
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2
);

--BODY
CREATE OR REPLACE TYPE BODY UBICACION AS
    MEMBER FUNCTION getLatitud RETURN COORDENADA IS
        BEGIN 
            RETURN Latitud;
        END;
    MEMBER FUNCTION getLongitud RETURN COORDENADA IS
        BEGIN 
            RETURN Longitud;
        END;
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2 IS
        BEGIN 
            RETURN '('||Latitud.printCoordenadas || '; ' || Longitud.printCoordenadas || ')';
        END;
END;


--EJEMPLOS DE PRUEBA
CREATE TABLE UBICACIONES(
    lugar UBICACION
);

INSERT INTO UBICACIONES VALUES (UBICACION(
    COORDENADA(COORDENADA.validarGrados(12),COORDENADA.validarMinutos_Segundos(50),COORDENADA.validarMinutos_Segundos(32),COORDENADA.validarDireccion('N','latitud')),
    COORDENADA(COORDENADA.validarGrados(40),COORDENADA.validarMinutos_Segundos(5),COORDENADA.validarMinutos_Segundos(0),COORDENADA.validarDireccion('W','longitud'))
));

SELECT u.lugar.printCoordenadas() FROM ubicaciones u;