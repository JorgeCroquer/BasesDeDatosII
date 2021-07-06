CREATE OR REPLACE PROCEDURE registro_orden_covax(pais_id pais.id_pai%TYPE, fecha_actual DATE, porcentaje_pob NUMBER, tipo INTEGER) IS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    n_orden orden.id_ord%TYPE;
    v_nombre_pais pais.nombre_pai%TYPE;
    v_nombre_distribuidora distribuidora.nombre_dist%TYPE;
    cantidad_vac NUMBER;
    distribuidora_id distribuidora.id_dist%TYPE := get_covax_id();
BEGIN

    if (tipo = 1) THEN 
        INSERT INTO ORDEN VALUES (DEFAULT, pais_id, distribuidora_id, 0 ,'EN ESPERA', fecha_actual, fecha_actual,fecha_actual);      --Se registra la orden sin monto 
    else INSERT INTO ORDEN VALUES (DEFAULT, pais_id, distribuidora_id, 0 ,'EN TRANSITO', fecha_actual, fecha_actual,fecha_actual);       --Se registra la orden sin monto 
    END if;

    n_orden := get_n_orden(pais_id, distribuidora_id, fecha_actual);

    cantidad_vac := get_vacunas_orden(pais_id, porcentaje_pob);
    c_vacunas := get_vacunas_covax();
    FETCH c_vacunas INTO r_vacuna;
    WHILE c_vacunas%FOUND
        LOOP 
            if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
                INSERT INTO DISTRIBUCION VALUES (n_orden, distribuidora_id, cantidad_vac); --Se realiza el pedido de todas las vacunas COVAX no restringidas para el pais en partes iguales
                        
                UPDATE VACUNA_DISTRIBUIDORA 
                SET cantidad_vd = cantidad_vd - cantidad_vac                                 --Se restan las vacunas de covax
                WHERE (distribuidora_vd = distribuidora_id AND vacuna_vd = r_vacuna.id_vac);
            END if;
            FETCH c_vacunas INTO r_vacuna;
        END LOOP;

    CLOSE c_vacunas;

    c_vacunas := get_vacunas_covax();
        UPDATE ORDEN 
        SET monto_ord = get_monto_orden(n_orden,1)                                 --Se actualiza el monto de la orden
        WHERE (id_ord = n_orden);
        UPDATE ORDEN 
        SET f_entrega_ord = ultima_fecha_f4(c_vacunas,fecha_actual)+30+TRUNC(dbms_random.value(-2,2))                                 --Se actualiza el monto de la orden
        WHERE (id_ord = n_orden);
        registro_pago(n_orden, fecha_actual, get_monto_orden(n_orden,1));
    commit;

    SELECT nombre_pai INTO v_nombre_pais FROM pais
    WHERE id_pai = pais_id;
    SELECT nombre_dist INTO v_nombre_distribuidora FROM distribuidora
    WHERE id_dist = distribuidora_id;

    DBMS_OUTPUT.PUT_LINE( v_nombre_pais|| ' realizo una orden a ' || v_nombre_distribuidora || ' de ' || get_cantidad_vacunas(n_orden) || ' vacunas.');
END; 
/  

