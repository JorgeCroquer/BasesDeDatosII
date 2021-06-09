CREATE OR REPLACE TYPE F_FASES AS OBJECT(
    fecha_aprobacion DATE,
    fecha_f1 DATE,
    fecha_f2 DATE,
    fecha_f3 DATE,
    fecha_f4 DATE,
    STATIC FUNCTION validarFecha(fecha VARCHAR2) RETURN DATE,
    STATIC FUNCTION generarFecha(fecha1 VARCHAR2, fecha2 VARCHAR2) RETURN DATE
    STATIC FUNCTION faseActual() RETURN VARCHAR2;
);

CREATE OR REPLACE TYPE BODY F_FASES AS
    STATIC FUNCTION validarFecha(fecha VARCHAR2) RETURN DATE IS
        
        BEGIN
            --Se compara con la fecha de inicio de la simulacion HAY QUE DEFINIR ESA FECHA
            IF (TO_DATE(fecha, 'dd/mm/yyyy') >= TO_DATE('08/03/2020', 'dd/mm/yyyy')) THEN 
                RETURN TO_DATE(fecha, 'dd/mm/yyyy');
            ELSE 
            --Si es antes del inicio de la simulacion, arrojamos un error por definir
                RAISE_APPLICATION_ERROR(-20002, 'La fecha es antes del inicio de la simulacion');
            END IF;
        END;
        
    STATIC FUNCTION generarFecha(fecha1 VARCHAR2,fecha2 VARCHAR2) RETURN DATE IS
        --Generador de fechas aleatorias
        BEGIN 
            --Explicacion a detalle en http://www.acehints.com/2012/05/generate-random-date-between-period.html
            RETURN TO_DATE(TRUNC(DBMS_RANDOM.VALUE(
                TO_CHAR(TO_DATE(fecha1,'dd/mm/yyyy'), 'J'),
                TO_CHAR(TO_DATE(fecha2,'dd/mm/yyyy'), 'J'))), 'J');   
        END;

    --Esta función retorna la fase actual en la que se encuentra la vacuna
    --Esta vendría siendo la última de la que se tenga registro de fecha
    STATIC FUNCTION faseActual() RETURN VARCHAR2 IS
        BEGIN
            IF (fecha_aprobacion IS NOT NULL) THEN
                RETURN 'N/A'
            ElSE IF(fecha_f4 IS NOT NULL) THEN
                RETURN 'Fase 4';
            ELSE IF (fecha_f3 IS NOT NULL) THEN
                RETURN 'Fase 3';
            ELSE IF (fecha_f2 IS NOT NULL) THEN
                RETURN 'Fase 2';
            ELSE IF (fecha_f1 IS NOT NULL) THEN
                RETURN 'Fase 1';
            ELSE
                RETURN 'No se ha creado la vacuna'
            END IF;
        END; 
END;