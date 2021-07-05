CREATE OR REPLACE FUNCTION farmaceuticas(fecha_actual DATE) RETURN BOOLEAN AS
    
    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    covax BOOLEAN := covax_existe;
BEGIN
    cambio_estatus(fecha_actual);
    c_vacunas := get_vacunas;
    
    WHILE c_vacunas%FOUND
        LOOP 
            FETCH c_vacunas INTO r_vacuna;
            if ((r_vacuna.estatus_vac = 2) AND (r_vacuna.covax_vac = 'Y') AND (NOT(covax))) THEN
                creacion_covax;
                covax := TRUE;
                DBMS_OUTPUT.PUT_LINE('El ' || r_vacuna.fechas_vac.fecha_f2 || ' la vacuna ' || r_vacuna.nombre_vac || ' es la primera en entrar en fase II.');
                  
            elsif (r_vacuna.estatus_vac = 4) THEN
                DBMS_OUTPUT.PUT_LINE('El ' || r_vacuna.fechas_vac.fecha_f2 || ' la vacuna ' || r_vacuna.nombre_vac || ' entro en fase IV.');
            end if;
        END LOOP;
    CLOSE c_vacunas;  

    return fin_farmaceuticas;
END;
/