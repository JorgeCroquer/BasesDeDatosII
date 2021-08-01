create or replace NONEDITIONABLE FUNCTION farmaceuticas(fecha_actual DATE) RETURN BOOLEAN AS
    
    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    covax NUMBER := get_covax_id;
BEGIN
    cambio_estatus(fecha_actual);
    c_vacunas := get_vacunas;
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND
        LOOP 

            if ((r_vacuna.estatus_vac = 2) AND (r_vacuna.covax_vac = 'Y') AND (covax = 0)) THEN
                creacion_covax;
                covax := get_covax_id;
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El ' || r_vacuna.fechas_vac.fecha_f2 || ' la vacuna ' || r_vacuna.nombre_vac || ' es la primera en entrar en fase II.');

            elsif (r_vacuna.estatus_vac = 4 AND (rango_fecha(fecha_actual, r_vacuna.fechas_vac.fecha_f4))) THEN
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El ' || r_vacuna.fechas_vac.fecha_f4 || ' la vacuna ' || r_vacuna.nombre_vac || ' entro en fase IV.');
            end if;
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;
    CLOSE c_vacunas;  

    return fin_farmaceuticas;
END;
/