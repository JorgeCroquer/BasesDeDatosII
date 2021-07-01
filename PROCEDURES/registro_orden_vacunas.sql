CREATE OR REPLACE PROCEDURE registro_orden_vacunas(pais_id pais.id_pai%TYPE, distribuidora_id distribuidora.id_dist%TYPE, fecha_actual DATE, porcentaje_pob NUMBER) IS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    cant_vac vacuna_distribuidora.cantidad_vd%TYPE;
    n_orden orden.id_ord%TYPE;
BEGIN

    INSERT INTO ORDEN VALUES (DEFAULT, pais_id, distribuidora_id, 0 ,'EN ESPERA', fecha_actual, fecha_actual + 150);

    n_orden := get_n_orden(pais_id, distribuidora_id, fecha_actual);

        if (distribuidora_id = get_covax_id) THEN

            c_vacunas := get_vacunas_covax;
            WHILE c_vacunas%FOUND
                LOOP 
                    FETCH c_vacunas INTO r_vacuna;
                    if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
                        INSERT INTO DISTRIBUCION VALUES (n_orden, distribuidora_id, get_poblacion(pais_id,'TOTAL')*(porcentaje_pob/100));  
                    END if;
                END LOOP;

            UPDATE ORDEN 
            SET monto_ord = get_monto_orden(TRUE);                                 --Se asigna el 30% de vacunas a COVAX.
            WHERE (id_ord = n_orden); 
        END if;

    


    

    
    SELECT cantidad_vd INTO cant_vac_covax FROM VACUNA_DISTRIBUIDORA
    WHERE (vacuna_vd = vacuna_id AND distribuidora_vd <> covax_id);

    UPDATE VACUNA_DISTRIBUIDORA 
    SET cantidad_vd = cant_vac_covax*0.3                                  --Se asigna el 30% de vacunas a COVAX.
    WHERE (vacuna_vd = vacuna_id AND distribuidora_vd = covax_id);      

    UPDATE VACUNA_DISTRIBUIDORA 
    SET cantidad_vd = cantidad_vd - cant_vac_covax*0.3                    --Se actualiza el numero de vacunas disponibles para distribucion del laboratorio respectivo.
    WHERE (vacuna_vd = vacuna_id AND distribuidora_vd <> covax_id);     

    commit;
    DBMS_OUTPUT.PUT_LINE('Se asignaron ' || cant_vac_covax*0.3 || ' vacunas ' || v_nombre_vac || ' al fondo COVAX.');
END;   
/