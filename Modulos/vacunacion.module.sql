create or replace NONEDITIONABLE PROCEDURE vacunacion(fecha_actual DATE) IS 
    dosis_aplicadas NUMBER; --Guarda las dosis que se han ido aplicando para chequear con la capacidad
    nuevas_primeras_dosis NUMBER := 0; --Guarda las primeras dosis que se aplicaron en la jornada
    nuevas_segundas_dosis NUMBER := 0; --Guarda las segundas dosis que se aplicaron en la jornada
    CURSOR centros_vacunacion IS
        SELECT cv.id_cen, 
               cv.capacidad_cen, 
               cv.pais_cv,
               cv.ubicacion,
               s.cant_jeringas_sum,
               s.cant_par_guantes_sum, 
               s.cant_alcohol_sum, 
               s.cant_algodon_sum
        FROM CENTRO_VAC cv JOIN SUMINISTROS s ON s.centro_vac_sum = cv.id_cen
        WHERE s.fecha_sum = TO_DATE('30/06/2021','dd/mm/yyyy');

    CURSOR inventarios(centro NUMBER) IS 
        SELECT * 
        FROM INVENTARIO_VAC
        WHERE centro_vac_inv = centro AND cantidad_pri_inv > 0 AND cantidad_seg_inv > 0;

    pendientes JORNADA_VAC%ROWTYPE; --Guarda el registro de hace 21 dias (3 semanas)
    

BEGIN

    FOR centro in centros_vacunacion
    LOOP
        DBMS_OUTPUT.PUT_LINE('centro -> ' || centro.id_cen);
        
        --Inserta un nuevo registro de suministros para la fecha actual
        INSERT INTO SUMINISTROS VALUES(fecha_actual,
                                       centro.id_cen,
                                       centro.cant_jeringas_sum,
                                       centro.cant_alcohol_sum,
                                       centro.cant_algodon_sum,
                                       centro.cant_par_guantes_sum);
        --Primero hay que ver si hay dosis pendientes en cada jornada de cada vacuna y grupo
        FOR inventario IN inventarios(centro.id_cen)
        LOOP
            DBMS_OUTPUT.PUT_LINE('vacuna -> ' || inventario.vacuna_inv);
            FOR grupo IN 1..4
            LOOP
                DBMS_OUTPUT.PUT_LINE('grupo -> ' || grupo);
                --Primero abre la jornada 
                INSERT INTO JORNADA_VAC VALUES (fecha_actual,0,0,centro.id_cen,inventario.vacuna_inv,centro.pais_cv,grupo);


                BEGIN
                    --Revisa los registros de hace 3 semanas (fecha actual menos 21 dias)
                    SELECT * INTO pendientes
                    FROM JORNADA_VAC jv
                    WHERE jv.centro_vac_jv = centro.id_cen 
                          AND jv.fecha_jv = fecha_actual-21
                          AND jv.vacuna_jv = inventario.vacuna_inv
                          AND jv.grupo_etario_jv = grupo; 

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN --Si no encuentra registros 
                            pendientes := NULL; --entonces no hay pendientes
                END;
                --Ve si encontró el registro
                IF (pendientes.fecha_jv IS NOT NULL) THEN --Pregunto por cualquier atributo del registro (que sea obligatorio)
                    --Chequea los suministros
                    IF (centro.cant_jeringas_sum > pendientes.cantidad_pri_jv
                        AND centro.cant_alcohol_sum > pendientes.cantidad_pri_jv
                        AND centro.cant_algodon_sum > pendientes.cantidad_pri_jv
                        AND centro.cant_par_guantes_sum > pendientes.cantidad_pri_jv/10) 
                    THEN
                        DBMS_OUTPUT.PUT_LINE('Si hay suministros' );

                        --Guarda el inventario del centro con la vacuna especifica
                        --SELECT * INTO inventario
                        --FROM INVENTARIO_VAC inv
                        --WHERE inv.centro_vac_inv = centro.id_cen AND inv.vacuna_inv = vac.vacuna_inv;

                        --Chequea la existencia de segundas dosis suficientes en el inventario
                        IF (inventario.cantidad_seg_inv > pendientes.cantidad_pri_jv) THEN 
                            DBMS_OUTPUT.PUT_LINE('Si hay inventario ');
                            --Suma las nuevas segundas dosis
                            DBMS_OUTPUT.PUT_LINE('pendientes -> ' ||pendientes.cantidad_pri_jv );
                            nuevas_segundas_dosis := nuevas_segundas_dosis+pendientes.cantidad_pri_jv;
                            DBMS_OUTPUT.PUT_LINE('Nuevas segundas dosis -> ' || nuevas_segundas_dosis);
                            --Actualiza los suministros
                            UPDATE SUMINISTROS
                            SET cant_jeringas_sum = cant_jeringas_sum - pendientes.cantidad_pri_jv,
                                cant_alcohol_sum = cant_alcohol_sum - pendientes.cantidad_pri_jv,
                                cant_algodon_sum = cant_algodon_sum - pendientes.cantidad_pri_jv,
                                cant_par_guantes_sum = cant_par_guantes_sum - CEIL(pendientes.cantidad_pri_jv/10) --CEIL redondea para arriba
                            WHERE centro_vac_sum = centro.id_cen 
                                AND fecha_sum = fecha_actual;


                            --Guarda las segundas dosis aplicadas en la jornada
                            UPDATE JORNADA_VAC
                            SET cantidad_seg_jv = pendientes.cantidad_pri_jv
                            WHERE fecha_jv = fecha_actual
                                AND centro_vac_jv = centro.id_cen
                                AND vacuna_jv = inventario.vacuna_inv
                                AND grupo_etario_jv = grupo; 

                            --Restamos la vacuna del inventario
                            UPDATE INVENTARIO_VAC 
                            SET cantidad_seg_inv = cantidad_seg_inv - pendientes.cantidad_pri_jv
                            WHERE centro_vac_inv = inventario.centro_vac_inv
                                  AND vacuna_inv = inventario.vacuna_inv;

                        END IF;
                    END IF;

                END IF;
            END LOOP;
        END LOOP;

    END LOOP;


END;