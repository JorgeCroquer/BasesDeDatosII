create or replace NONEDITIONABLE FUNCTION solicitar_orden_covax(pais_p NUMBER, fecha_actual DATE) RETURN BOOLEAN AS
orden_a_aprobar ORDEN%rowtype;
pago_restante NUMBER;
porcentaje_restante_p NUMBER;
BEGIN
    porcentaje_restante_p:= porcentaje_restante(pais_p);
    IF(todos_20() = TRUE)THEN --CUANTO LE FALTA PARA LLEGAR A LA META, ¿A LA META O DE SU POBLACIÓN?
        IF(porcentaje_restante_p <= 30) THEN
            --Envía con lo que falta
            DBMS_OUTPUT.PUT_LINE('Realizando orden a covax');
            registro_orden_covax(pais_p,fecha_actual,porcentaje_restante_p,2);
            RETURN(TRUE);
        ELSE
            --Envia con 30
            DBMS_OUTPUT.PUT_LINE('Realizando orden a covax');
            registro_orden_covax(pais_p,fecha_actual,30,2);
            RETURN(TRUE);
        END IF;
    ELSE
        IF(porcentaje_restante_p > 80) THEN
            DBMS_OUTPUT.PUT_LINE('PAIS_P '||pais_p);
            SELECT *
            INTO orden_a_aprobar
            FROM orden
            WHERE pais_ord = pais_p 
            AND distribuidora_ord = get_covax_id
            AND estatus_ord = 'EN ESPERA'; --Obtenemos la orden en espera, solo debería haber 1

            UPDATE ORDEN 
            SET estatus_ord = 'EN TRANSITO' 
            WHERE id_ord = orden_a_aprobar.id_ord; --Ponemos en transito la orden de ese pais a covax (10)

            SELECT orden_a_aprobar.monto_ord - SUM(monto_pag) 
            INTO pago_restante
            FROM PAGO
            WHERE n_orden_pag = orden_a_aprobar.id_ord;
            IF(pago_restante> 0) THEN --Realizamos el pago pendiente de ser necesario 
                INSERT INTO PAGO VALUES(DEFAULT,orden_a_aprobar.f_entrega_ord,pago_restante,orden_a_aprobar.id_ord);
            END IF;
            DBMS_OUTPUT.PUT_LINE('Pago completado');
            RETURN (TRUE);
        ELSE
            RETURN (FALSE);
        END IF;
    END IF;
END;
/


--Entonces lo que jesus hizo es que cuando registra las primeras ordenes las pone con el estatus "en espera"
-- lo que yo tengo que hacer es que cuando recibo un pais que le falta su 20% y tiene una orden en espera
--es cambiarle el estatus en entransito para que luego el la espere como orden pendiente y registrar el pago

--Tengo que arreglar el tema de las vacunas restringidas y agregarlo a mi codigo