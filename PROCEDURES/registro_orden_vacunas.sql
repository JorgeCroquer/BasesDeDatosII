CREATE OR REPLACE PROCEDURE registro_orden_vacunas(pais_id pais.id_pai%TYPE, distribuidora_id distribuidora.id_dist%TYPE, fecha_actual DATE, porcentaje_pob NUMBER) IS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    n_orden orden.id_ord%TYPE;
BEGIN

    INSERT INTO ORDEN VALUES (DEFAULT, pais_id, distribuidora_id, 0 ,'EN ESPERA', fecha_actual, fecha_actual + 150);    --Se registra la orden sin monto 

    n_orden := get_n_orden(pais_id, distribuidora_id, fecha_actual);

        if (distribuidora_id = get_covax_id) THEN

            c_vacunas := get_vacunas_covax;
            WHILE c_vacunas%FOUND
                LOOP 
                    FETCH c_vacunas INTO r_vacuna;
                    if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
                        INSERT INTO DISTRIBUCION VALUES (n_orden, distribuidora_id, get_vacunas_orden(pais_id, porcentaje_pob, TRUE));  --Se realiza el pedido de todas las vacunas COVAX no restringidas para el pais en partes iguales
                    END if;
                END LOOP;

            UPDATE ORDEN 
            SET monto_ord = get_monto_orden(n_orden, TRUE);                                 --Se actualiza el monto de la orden
            WHERE (id_ord = n_orden); 

        else c_vacunas := get_vacunas;
            WHILE c_vacunas%FOUND
                LOOP 
                    FETCH c_vacunas INTO r_vacuna;
                    if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
                        INSERT INTO DISTRIBUCION VALUES (n_orden, distribuidora_id, get_vacunas_orden(pais_id, porcentaje_pob, FALSE));  --Se realiza el pedido de todas las vacunas COVAX no restringidas para el pais en partes iguales
                    END if;
                END LOOP;

            UPDATE ORDEN 
            SET monto_ord = get_monto_orden(n_orden, FALSE);                                 --Se actualiza el monto de la orden
            WHERE (id_ord = n_orden);
        END if;
    

    commit;
    DBMS_OUTPUT.PUT_LINE( PAIS' realizo una orden a ' || DISTRIBUIDORA || ' de ' || get_cantidad_vacunas(pais_id, n_orden) || ' vacunas.');
END;   
/