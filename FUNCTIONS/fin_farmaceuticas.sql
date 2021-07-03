CREATE OR REPLACE FUNCTION fin_farmaceuticas RETURN BOOLEAN AS 

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    cont integer := 0;

BEGIN 

    c_vacunas := get_vacunas;

    WHILE c_vacunas%FOUND
        LOOP 
            FETCH c_vacunas INTO r_vacuna;
                if (r_vacuna.estatus_vac <> 4) THEN     --SI CONSIGUE VACUNAS QUE AUN NO HAN LLEGADO A FASE IV SUMA 1
                    cont := cont + 1;
                END if;
        END LOOP;

    if (cont = 0) THEN              --CONT SERA 0 CUANDO TODAS LAS VACUNAS ESTEN EN FASE IV
        return (FALSE);             --LO QUE INDICA EL FIN DEL MODULO DE FARMACEUTICAS
    END if;
    return (TRUE);

END;
/