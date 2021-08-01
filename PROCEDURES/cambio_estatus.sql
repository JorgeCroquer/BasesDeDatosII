create or replace NONEDITIONABLE PROCEDURE cambio_estatus(fecha_actual DATE) AS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;

BEGIN 
    c_vacunas := get_vacunas;
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND 
        LOOP 

            if (r_vacuna.estatus_vac = 0 ) THEN
                if (rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f1)) THEN
                    UPDATE VACUNA 
                    SET estatus_vac = 1                                  
                    WHERE id_vac = r_vacuna.id_vac;
                END if;
            elsif (r_vacuna.estatus_vac = 1 ) THEN
                if (rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f2)) THEN
                    UPDATE VACUNA 
                    SET estatus_vac = 2                                  
                    WHERE id_vac = r_vacuna.id_vac;
                    commit;
                    if (all_vacunas_f2) THEN
                        asignacion_vacunas_covax;
                        primeras_ordenes_covax(fecha_actual);
                    END if;
                END if;
            elsif (r_vacuna.estatus_vac = 2 ) THEN
                if (rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f3)) THEN
                    UPDATE VACUNA 
                    SET estatus_vac = 3                                  
                    WHERE id_vac = r_vacuna.id_vac;
                END if;
            elsif (r_vacuna.estatus_vac = 3 ) THEN
                if (rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f4)) THEN
                    UPDATE VACUNA 
                    SET estatus_vac = 4                                  
                    WHERE id_vac = r_vacuna.id_vac;
                END if;
            END if;
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;
        commit;
    CLOSE c_vacunas;
END;
/