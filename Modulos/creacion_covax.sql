CREATE OR REPLACE PROCEDURE creacion_covax IS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    covax_id distribuidora.id_dist%TYPE;
BEGIN

    asignacion_paises_covax;
    
    INSERT INTO DISTRIBUIDORA VALUES (DEFAULT, 'COVAX');    --INSERT DE COVAX EN LA TABLA DISTRIBUIDORA
    SELECT id_dist INTO covax_id FROM DISTRIBUIDORA 
    WHERE nombre_dist = 'COVAX';

    c_vacunas := get_vacunas_covax;
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND
        LOOP 
            
            INSERT INTO VACUNA_DISTRIBUIDORA VALUES (r_vacuna.id_vac, covax_id, 0);      --ASIGNACION DE CADA VACUNA A COVAX CON CANTIDAD 0 (EN OTRO PROCEDURE SE ASIGNARA EL 30% DE CADA VACUNA EN EL MOMENTO QUE LLEGUE A FASE 4) 
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;
    CLOSE c_vacunas;  
    DBMS_OUTPUT.PUT_LINE('Se conformo la alianza COVAX.');

END;
/