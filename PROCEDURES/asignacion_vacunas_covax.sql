CREATE OR REPLACE PROCEDURE asignacion_vacunas_covax IS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    covax_id distribuidora.id_dist%TYPE;
    cant_vac_covax vacuna_distribuidora.cantidad_vd%TYPE;
BEGIN

    covax_id := get_covax_id;

    c_vacunas := get_vacunas_covax;
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND
        LOOP 
            

            SELECT cantidad_vd INTO cant_vac_covax FROM VACUNA_DISTRIBUIDORA
            WHERE (vacuna_vd = r_vacuna.id_vac AND distribuidora_vd <> covax_id);

            UPDATE VACUNA_DISTRIBUIDORA 
            SET cantidad_vd = cantidad_vd + cant_vac_covax*0.4                                  --Se asigna el 40% de vacunas a COVAX.
            WHERE (vacuna_vd = r_vacuna.id_vac AND distribuidora_vd = covax_id);      

            UPDATE VACUNA_DISTRIBUIDORA 
            SET cantidad_vd = cantidad_vd - cant_vac_covax*0.4                    --Se actualiza el numero de vacunas disponibles para distribucion del laboratorio respectivo.
            WHERE (vacuna_vd = r_vacuna.id_vac AND distribuidora_vd <> covax_id);     
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('Se asignaron ' || cant_vac_covax*0.4 || ' vacunas ' || r_vacuna.nombre_vac || ' al fondo COVAX.');
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;
    CLOSE c_vacunas;
    commit;
END;   
/