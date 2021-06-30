CREATE OR REPLACE PROCEDURE registro_orden_vacunas(pais_id pais.id_pai%TYPE, distribuidora_id distribuidora.id_dist%TYPE) IS

    c_vacunas SYS_REFCURSOR;
    c_restricciones SYS_REFCURSOR;
    cant_vac vacuna_distribuidora.cantidad_vd%TYPE;
    
BEGIN


    INSERT INTO ORDEN VALUES (DEFAULT, pais_id, distribuidora_id, INSERTAR MONTO , 'EN ESPERA', fecha_actual, fecha_estimada);

    
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