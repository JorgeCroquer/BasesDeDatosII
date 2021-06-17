CREATE TABLE DOSIS(
    fecha date,
    dosis_aplicadas PLS_INTEGER,
    dosis_disponibles PLS_INTEGER
)


CREATE OR REPLACE PROCEDURE conteo_dosis IS
DECLARE

    CURSOR dosis_cursor IS
        SELECT * 
        FROM DOSIS
        ORDER BY fecha;
    
    disponibilidad PLS_INTEGER := 4000;

BEGIN

    FOR registro IN dosis_cursor LOOP 

        UPDATE TABLE dosis SET dosis_disponibles = disponibilidad - dosis_aplicadas
        WHERE fecha = registro.fecha;

        disponibilidad = disponibildad - registro.dosis_aplicadas


    END LOOP;

END;

INSERT INTO DOSIS VALUES (TO_DATE('01/06/2021','dd/mm/yyyy'), 2000,NULL);
INSERT INTO DOSIS VALUES (TO_DATE('02/06/2021','dd/mm/yyyy'), 100,NULL);
INSERT INTO DOSIS VALUES (TO_DATE('03/06/2021','dd/mm/yyyy'), 200,NULL);
INSERT INTO DOSIS VALUES (TO_DATE('04/06/2021','dd/mm/yyyy'), 300,NULL);
INSERT INTO DOSIS VALUES (TO_DATE('05/06/2021','dd/mm/yyyy'), 500,NULL);



EXECUTE conteo_dosis;