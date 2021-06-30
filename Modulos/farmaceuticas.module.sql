CREATE OR REPLACE PROCEDURE farmaceuticas(fecha_actual DATE) IS
    
    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    covax BOOLEAN := covax_existe;
BEGIN
    
    c_vacunas := get_vacunas;
    
    
    WHILE c_vacunas%FOUND
        LOOP 
            FETCH c_vacunas INTO r_vacuna;
            if ((rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f2)) AND (r_vacuna.covax_vac = 'Y') AND (NOT(covax))) THEN
                creacion_covax;
                covax := TRUE;
                DBMS_OUTPUT.PUT_LINE('El ' || r_vacuna.fechas_vac.fecha_f2 || ' la vacuna ' || r_vacuna.nombre_vac || ' es la primera en entrar en fase II.');
                  
            else if (rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f4)) THEN
                    if (r_vacuna.covax_vac = 'Y') THEN
                        asignacion_vacunas_covax(r_vacuna.id_vac);    --asigna 30% a COVAX y el 70% restante se lo queda el laboratorio creador. 
                    end if;
                    DBMS_OUTPUT.PUT_LINE('El ' || r_vacuna.fechas_vac.fecha_f2 || ' la vacuna ' || r_vacuna.nombre_vac || ' entro en fase IV.');
                end if;
            end if;
        END LOOP;
    CLOSE c_vacunas;  
END;
/