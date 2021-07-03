CREATE OR REPLACE TYPE COORDENADA AS OBJECT(
    grados INT,
    minutos INT,
    segundos INT,
    direccion CHAR,
    MEMBER FUNCTION getGrados RETURN INT,
    MEMBER FUNCTION getMinutos RETURN INT,
    MEMBER FUNCTION getSegundos RETURN INT,
    MEMBER FUNCTION getDireccion RETURN CHAR,
    STATIC FUNCTION validarGrados(grados INT) RETURN INT,
    STATIC FUNCTION validarMinutos_Segundos(tiempo INT) RETURN INT,
    STATIC FUNCTION validarDireccion(direccion CHAR, medida VARCHAR2) RETURN CHAR,
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2
);


CREATE OR REPLACE TYPE BODY COORDENADA AS
    MEMBER FUNCTION getGrados RETURN INT IS
        BEGIN 
            RETURN grados;
        END;
    MEMBER FUNCTION getMinutos RETURN INT IS
        BEGIN 
            RETURN minutos;
        END;    
    MEMBER FUNCTION getSegundos RETURN INT IS
        BEGIN 
            RETURN segundos;
        END;
    MEMBER FUNCTION getDireccion RETURN CHAR IS
        BEGIN 
            RETURN direccion;
        END;
    STATIC FUNCTION validarGrados(grados INT) RETURN INT IS
        BEGIN 
            IF (grados >= 0 AND grados <= 180) THEN
                RETURN grados;
            ELSE 
                RAISE_APPLICATION_ERROR(-20001, 'grados invalidos');
            END IF;
        END;
    STATIC FUNCTION validarMinutos_Segundos(tiempo INT) RETURN INT IS
        BEGIN 
            IF (tiempo >= 0 AND tiempo < 60) THEN
                RETURN tiempo;
            ELSE 
                RAISE_APPLICATION_ERROR(-20002, 'minutos o segundos invalidos');
            END IF;
        END;  
    STATIC FUNCTION validarDireccion(direccion CHAR, medida VARCHAR2) RETURN CHAR IS
        BEGIN
            IF (medida = 'latitud') THEN 
                IF (direccion IN ('N','S')) THEN
                  RETURN direccion;
                ELSE 
                    RAISE_APPLICATION_ERROR(-20003, 'direccion de latitud invalida');
                END IF;
            ELSE IF (medida = 'longitud') THEN
                IF (direccion IN ('E','W')) THEN
                  RETURN direccion;
                ELSE 
                    RAISE_APPLICATION_ERROR(-20004, 'direccion de longitud invalida');
                END IF;
            ELSE 
                RAISE_APPLICATION_ERROR(-20005, 'direccion invalida');
            END IF;
            END IF;
        END;
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2 IS
        BEGIN 
            RETURN TO_CHAR(grados)|| '° ' || TO_CHAR(minutos)|| ''' '|| TO_CHAR(segundos)|| '" '|| TO_CHAR(direccion);
        END;
END;
            


CREATE OR REPLACE TYPE UBICACION AS OBJECT(
    latitud COORDENADA,
    longitud COORDENADA,
    MEMBER FUNCTION getLatitud RETURN COORDENADA,
    MEMBER FUNCTION getLongitud RETURN COORDENADA,
    MEMBER FUNCTION printCoordenadas RETURN VARCHAR2
);

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


CREATE TABLE UBICACIONES(
    lugar UBICACION
);

INSERT INTO UBICACIONES VALUES (UBICACION(
    COORDENADA(COORDENADA.validarGrados(12),COORDENADA.validarMinutos_Segundos(50),COORDENADA.validarMinutos_Segundos(32),COORDENADA.validarDireccion('N','latitud')),
    COORDENADA(COORDENADA.validarGrados(40),COORDENADA.validarMinutos_Segundos(5),COORDENADA.validarMinutos_Segundos(0),COORDENADA.validarDireccion('W','longitud'))
));

SELECT u.lugar.printCoordenadas() FROM ubicaciones u;

