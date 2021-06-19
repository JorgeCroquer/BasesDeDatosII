
--OBJETO
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

--BODY
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