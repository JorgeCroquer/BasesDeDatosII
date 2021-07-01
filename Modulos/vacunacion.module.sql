CREATE OR REPLACE PROCEDURE vacunacion(fecha_actual DATE) IS 
    dosis_aplicadas NUMBER --Guarda las dosis que se han ido aplicando para chequear con la capacidad
    nuevas_primeras_dosis NUMBER; --Guarda las primeras dosis que se aplicaron en la jornada
    nuevas_segundas_dosis NUMBER; --Guarda las segundas dosis que se aplicaron en la jornada
    CURSOR centros_vacunacion IS
        SELECT id_cen, 
               capacidad_cen, 
               pais_cv,ubicacion,
               cant_jeringas_sum,
               cant_par_guantes_sum, 
               cant_alcohol_sum, 
               cant_algodon_sum,
               pais_cv
        FROM CENTRO_VAC cv JOIN SUMINISTROS s ON s.centro_vac_sum = cv.id_cen
        WHERE s.fecha_sum = TO_DATE('30/06/2021','dd/mm/yyyy');
    
    CURSOR vacunas IS
        SELECT *
        FROM VACUNA;

    pendientes JORNADA_VAC%ROWTYPE; --Guarda el registro de hace 21 dias (3 semanas)
    
BEGIN

    FOR centro in centros_vacunacion
    LOOP
        
        --Primero hay que ver si hay dosis pendientes en cada jornada de cada vacuna y grupo
        FOR vac IN 1..8
        LOOP
            FOR grupo IN 1..4
            LOOP
            --Primero abre la jornada y se inserta el nuevo registro de suministros (sin cambios)
            INSERT INTO JORNADA_VAC(fecha_actual,0,0,centro.id_cen,vac,centro.pais_cv,grupo);
            INSERT INTO SUMINISTROS VALUES(centro.cant_jeringas_sum,
                                                    centro.cant_alcohol_sum,
                                                    centro.cant_algodon_sum
                                                    centro.cant_par_guantes_sum)

                BEGIN
                    --Revisa los registros de hace 3 semanas (fecha actual menos 21 dias)
                    SELECT * INTO pendientes
                    FROM JORNADA_VAC
                    WHERE centro_vac_jv = centro.id_cen 
                          AND fecha_jv = fecha_actual-21
                          AND vacuna_jv = vac
                          AND grupo_etario_jv = grupo; 

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN --Si no encuentra registros 
                            pendientes := NULL; --entonces no hay pendientes
                END;
                --Ve si encontró el registro
                IF (pendientes.fecha_jv IS NOT NULL) THEN --Pregunto por cualquier atributo del registro (que sea obligatorio)
                    --Chequeamos los suministros
                    IF (centro.cant_jeringas_sum > pendientes.cantidad_pri_jv
                        AND centro.cant_alcohol_sum > pendientes.cantidad_pri_jv
                        AND centro.cant_algodon_sum > pendientes.cantidad_pri_jv
                        AND centro.cant_par_guantes_sum > pendientes.cantidad_pri_jv/10)

                        --Suma las nuevas segundas dosis
                        nuevas_segundas_dosis := nuevas_segundas_dosis+pendientes.cantidad_pri_jv;

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
                              AND vacuna_jv = vac
                              AND grupo_etario_jv = grupo; 

                        --Restamos la vacuna del inventario
                END IF;
            END LOOP;
        END LOOP;

    END LOOP;


END;