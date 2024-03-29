create or replace NONEDITIONABLE FUNCTION ultima_fecha_f4(c_vacunas SYS_REFCURSOR, fecha_actual DATE) RETURN DATE AS 

    r_vacuna vacuna%ROWTYPE;
    ultima_fecha DATE := fecha_actual;

BEGIN 
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND 
        LOOP 
                if (r_vacuna.fechas_vac.fecha_f4 > ultima_fecha) THEN     --MIENTRAS CONSIGA UNA FECHA MAS LEJANA, ESTA PASA A SER LA ULTIMA FECHA
                    ultima_fecha := r_vacuna.fechas_vac.fecha_f4;
                END if;
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;

    CLOSE c_vacunas;
    RETURN ultima_fecha;

END;
/