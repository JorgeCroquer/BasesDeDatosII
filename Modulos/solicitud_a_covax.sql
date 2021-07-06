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
    RETURN porcentaje_equivalente;
END;

CREATE OR REPLACE PROCEDURE modulo_economia(fecha_actual DATE) IS
cantidad_centros NUMBER;
orden_pen ORDEN%rowtype;
covax_p VARCHAR(1);
pago_pendiente NUMBER;
aprobado_covax BOOLEAN;
BEGIN
    IF (vacuna_aprobada() = TRUE) THEN
        FOR p IN (SELECT * FROM PAIS)
        LOOP
            orden_pen:= orden_pendiente(p.id_pai, fecha_actual);
            IF (orden_pen.id_ord IS NOT NULL) THEN --Chequeamos si hay orden pendiente
                IF(fecha_actual >= orden_pen.f_entrega_ord) THEN --Chequeamos si ya llegó la orden
                    UPDATE ORDEN SET estatus_ord = 'ENTREGADA' WHERE id_ord = orden_pen.id_ord; --Actualizamos la orden a entregada
                    distribuir_vacunas(orden_pen,p.id_pai); --distribuimos las vacunas entre los diferentes centros de vacunacion
                    DBMS_OUTPUT.PUT_LINE('Orden recibida.Distribuyendo vacunas...');
                    SELECT orden_pen.monto_ord - SUM(monto_pag) 
                    INTO pago_pendiente
                    FROM PAGO
                    WHERE n_orden_pag = orden_pen.id_ord;
                    IF(pago_pendiente > 0) THEN --Realizamos el pago pendiente de ser necesario 
                        INSERT INTO PAGO VALUES(DEFAULT,orden_pen.f_entrega_ord,pago_pendiente,orden_pen.id_ord);
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('Pago completado');
                END IF;
            ELSE 
                IF(meta_superada(p.id_pai) = FALSE) THEN --Se superó la meta de vacunación?
                    IF(hora_de_ordenar(p.id_pai) = TRUE) THEN -- Ya toca volver a pedir?
                        SELECT covax_pai INTO covax_p FROM pais WHERE id_pai = p.id_pai;
                        IF(covax_p = 'Y') THEN --pertenece a covax?
                            DBMS_OUTPUT.PUT_LINE('Realizando orden a covax');
                            aprobado_covax := solicitar_orden_covax(p.id_pai,fecha_actual);
                            IF(aprobado_covax = FALSE) THEN
                                DBMS_OUTPUT.PUT_LINE('Covax rechazó la orden, realizando orden a otro provedor');
                                orden_a_proveedor(p.id_pai,fecha_actual);--se pide a alguien mas
                            END IF;
                        ELSE
                            orden_a_proveedor(p.id_pai,fecha_actual);--se pide a alguien mas
                            DBMS_OUTPUT.PUT_LINE('Realizando orden a proveedor');
                        END IF;
                    END IF;
                END IF;
            END IF;
        END LOOP;
    END IF;
END;



--Entonces lo que jesus hizo es que cuando registra las primeras ordenes las pone con el estatus "en espera"
-- lo que yo tengo que hacer es que cuando recibo un pais que le falta su 20% y tiene una orden en espera
--es cambiarle el estatus en entransito para que luego el la espere como orden pendiente y registrar el pago

--Tengo que arreglar el tema de las vacunas restringidas y agregarlo a mi codigo