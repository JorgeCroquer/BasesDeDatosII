CREATE OR REPLACE PROCEDURE asignacion_vacunas_covax(id_vacuna NUMBER) IS

    DECLARE
        id_covax DISTRIBUIDORA.id_dist%TYPE;
        SELECT id_dist INTO id_covax FROM DISTRIBUIDORA 
        WHERE nombre_dist = 'COVAX';
        cant_vac_covax VACUNA_DISTRIBUIDORA.cantidad_vd%TYPE;
        SELECT cantidad_vd INTO cant_vac_covax FROM VACUNA_DISTRIBUIDORA
        WHERE (vacuna_vd = id_vacuna AND distribuidora_vd <> id_covax);

BEGIN
    UPDATE VACUNA_DISTRIBUIDORA 
    SET cantidad_vd = cant_vac_covax*0.3                                  --Se asigna el 30% de vacunas a COVAX.
    WHERE (vacuna_vd = id_vacuna AND distribuidora_vd = id_covax);      

    UPDATE VACUNA_DISTRIBUIDORA 
    SET cantidad_vd = cantidad_vd - cant_vac_covax*0.3                    --Se actualiza el numero de vacunas disponibles para distribucion del laboratorio respectivo.
    WHERE (vacuna_vd = id_vacuna AND distribuidora_vd <> id_covax);     

    commit;
    DBMS_OUTPUT.PUT_LINE('Se asignaron ' || cant_vac_covax*0.3 || ' vacunas ' || SELECT nombre_vac FROM VACUNA WHERE id_vac = id_vacuna || ' al fondo COVAX.');
END;    