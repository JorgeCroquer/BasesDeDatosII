create or replace NONEDITIONABLE FUNCTION all_vacunas_f2 RETURN BOOLEAN AS 

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    cont integer := 0;

BEGIN 

    c_vacunas := get_vacunas_covax;
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND
        LOOP 
                if (r_vacuna.estatus_vac < 2) THEN     --SI CONSIGUE VACUNAS EN FASE I SUMA 1
                    cont := cont + 1;
                END if;
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;

    CLOSE c_vacunas;
    if (cont = 0) THEN              --CONT SERA 0 CUANDO TODAS LAS VACUNAS ESTEN EN FASE 2 O MAYOR
        return (TRUE);              --INDICARA EL LLAMADO AL PROCEDIMIENTO asignacion_vacunas_covax en cambio_estatus
    END if;
    return (FALSE);

END;
/