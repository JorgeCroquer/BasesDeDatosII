CREATE OR REPLACE FUNCTION todos_20 RETURN BOOLEAN AS
porcentaje_equivalente NUMBER;
BEGIN
    FOR p IN(SELECT id_pai, SUM(cantidad_dis) as cantidad_vac
            FROM PAIS
            JOIN ORDEN ON pais_ord = id_pai
            JOIN DISTRIBUCION ON n_orden_dis = id_ord
            GROUP BY id_pai)
    LOOP
        porcentaje_equivalente := TRUNC(p.cantidad_vac/get_poblacion(p.id_pai,'TOTAL')*100,2);
        IF(porcentaje_equivalente < 20)THEN
            RETURN (FALSE);
        END IF;
    END LOOP;
    RETURN (TRUE);
END;

--Calcula el porcentaje de la población al que aun no se le ha asegurado una vacuna
CREATE OR REPLACE FUNCTION porcentaje_restante(pais_p NUMBER) RETURN NUMBER AS --Podría sustituir a "meta superada" en el moódulo de economía
porcentaje_equivalente NUMBER;
cantidad_vac NUMBER;
BEGIN
    SELECT SUM(cantidad_dis)
    INTO cantidad_vac
    FROM PAIS
    JOIN ORDEN ON pais_ord = id_pai
    JOIN DISTRIBUCION ON n_orden_dis = id_ord
    WHERE id_pai = pais_p;
    porcentaje_equivalente := TRUNC((100-(cantidad_vac/get_poblacion(pais_p,'TOTAL')*100)),2);

    porcentaje_equivalente := TRUNC((100 - ((division)*100)), 2)
    RETURN porcentaje_equivalente;
END;

create or replace NONEDITIONABLE FUNCTION solicitar_orden_covax(pais_p NUMBER, fecha_actual DATE) RETURN BOOLEAN AS
orden_a_aprobar ORDEN%rowtype;
pago_restante NUMBER;
porcentaje_restante_p NUMBER;
BEGIN
    porcentaje_restante_p:= porcentaje_restante(pais_p);
    IF(todos_20() = TRUE)THEN --CUANTO LE FALTA PARA LLEGAR A LA META, ¿A LA META O DE SU POBLACIÓN?
        IF(porcentaje_restante_p <= 30) THEN
            --Envía con lo que falta
            registro_orden_covax(pais_p,fecha_actual,porcentaje_restante_p,2);
            RETURN(TRUE);
        ELSE
            --Envia con 30
            registro_orden_covax(pais_p,fecha_actual,30,2);
            RETURN(TRUE);
        END IF;
    ELSE
        IF(porcentaje_restante_p >= 80) THEN
            SELECT *
            INTO orden_a_aprobar
            FROM orden
            WHERE pais_ord = pais_p 
            AND distribuidora_ord = 10 
            AND estatus_ord = 'EN ESPERA'; --Obtenemos la orden en espera, solo debería haber 1

            UPDATE ORDEN SET estatus_ord = 'EN TRANSITO' WHERE id_ord = orden_a_aprobar.estatus_ord ; --Ponemos en transito la orden de ese pais a covax (10)

            SELECT orden_a_aprobar.monto_ord - SUM(monto_pag) 
            INTO pago_restante
            FROM PAGO
            WHERE n_orden_pag = orden_a_aprobar.id_ord;
            IF(pago_restante> 0) THEN --Realizamos el pago pendiente de ser necesario 
                INSERT INTO PAGO VALUES(DEFAULT,orden_a_aprobar.f_entrega_ord,pago_restante,orden_a_aprobar.id_ord);
            END IF;
            DBMS_OUTPUT.PUT_LINE('Pago completado');
            
        ELSE
            RETURN (FALSE);
        END IF;
    END IF;
END;



--Entonces lo que jesus hizo es que cuando registra las primeras ordenes las pone con el estatus "en espera"
-- lo que yo tengo que hacer es que cuando recibo un pais que le falta su 20% y tiene una orden en espera
--es cambiarle el estatus en entransito para que luego el la espere como orden pendiente y registrar el pago

--Tengo que arreglar el tema de las vacunas restringidas y agregarlo a mi codigo