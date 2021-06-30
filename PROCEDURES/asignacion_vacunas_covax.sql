CREATE OR REPLACE PROCEDURE asignacion_vacunas_covax(vacuna_id VACUNA.id_vac%TYPE) IS

    covax_id distribuidora.id_dist%TYPE;
    cant_vac_covax vacuna_distribuidora.cantidad_vd%TYPE;
    v_nombre_vac vacuna.nombre_vac%TYPE;
BEGIN

    SELECT id_dist INTO covax_id FROM DISTRIBUIDORA 
    WHERE (nombre_dist = 'COVAX');
    
    SELECT cantidad_vd INTO cant_vac_covax FROM VACUNA_DISTRIBUIDORA
    WHERE (vacuna_vd = vacuna_id AND distribuidora_vd <> covax_id);
    
    SELECT nombre_vac INTO v_nombre_vac FROM VACUNA 
    WHERE id_vac = vacuna_id;

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