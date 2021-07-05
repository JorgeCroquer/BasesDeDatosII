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
        WHERE s.fecha_sum = fecha_actual-7;

    CURSOR inventarios(centro NUMBER) IS 
        SELECT * 
        FROM INVENTARIO_VAC
        WHERE centro_vac_inv = centro AND cantidad_pri_inv > 0 AND cantidad_seg_inv > 0;

    CURSOR porcentajes_vacuna(centro NUMBER) IS
        SELECT vacuna_inv, TRUNC(cantidad_pri_inv/(SELECT SUM(cantidad_pri_inv)
                                                    FROM INVENTARIO_VAC
                                                    WHERE centro_vac_inv = centro),3) AS porcentaje
        FROM INVENTARIO_VAC
        WHERE centro_vac_inv = centro;


    pendientes JORNADA_VAC%ROWTYPE; --Guarda el registro de hace 21 dias (3 semanas)


    porcentaje_vacunados NUMBER; --Guarda el procentaje de vacunados con 1era dosis de un grupo etario
                                 --con respecto a un pais

    pri_dosis_disponibles NUMBER; --Guarda las primeras dosis disponibles de una vacuna en un centro
    
    existencia NUMBER;
    
    segundas_dosis NUMBER;

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
                    
        --Primero hay que crear todas las jornadas
        FOR vac IN 1..8 
        LOOP
            FOR grupo IN 1..4
            LOOP
                --Inserto una jornada por cada centro, cada vacuna y cada grupo etario
                INSERT INTO JORNADA_VAC VALUES (fecha_actual,0,0,centro.id_cen,vac,centro.pais_cv,grupo);
            END LOOP;
        END LOOP;

        --Primero hay que ver si hay dosis pendientes en cada jornada de cada vacuna y grupo
        FOR inventario IN inventarios(centro.id_cen)
        LOOP
            DBMS_OUTPUT.PUT_LINE('vacuna -> ' || inventario.vacuna_inv);
            FOR grupo IN 1..4
            LOOP
                DBMS_OUTPUT.PUT_LINE('grupo -> ' || grupo);
                --Primero abre la jornada 
                


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

            --guarda la cantidad de primera dosis que tiene el centro
            
        END LOOP;

        --Sigue con las primeras dosis


        --Esta query devuelve la cantidad de nuevas primeras dosis a poner
        --dependiendo de las segundas dosis que ya puso, de la capacidad del centro
        --y del inventario del  centro
        
        SELECT SUM(cantidad_pri_inv) INTO existencia  
        FROM INVENTARIO_VAC
        WHERE centro_vac_inv = centro.id_cen;
        SELECT SUM(cantidad_seg_jv) INTO segundas_dosis
        FROM JORNADA_VAC
        WHERE centro_vac_jv = centro.id_cen AND fecha_jv = fecha_actual;
        SELECT CASE
                    WHEN existencia < cv.capacidad_cen - segundas_dosis  THEN existencia
                    ELSE cv.capacidad_cen - segundas_dosis
                END primeras_dosis  
        INTO nuevas_primeras_dosis --Guardamos aqui   
        FROM centro_vac cv 
        WHERE cv.id_cen = centro.id_cen;
        
        
        --Pregunta si hay insumos, elige lo que haya menos de los insumos (incluido las nuevas primeras dosis)
        SELECT LEAST(cant_jeringas_sum,cant_alcohol_sum,cant_algodon_sum,cant_par_guantes_sum*10,nuevas_primeras_dosis)
        INTO nuevas_primeras_dosis
        FROM SUMINISTROS
        WHERE centro_vac_sum = 1 AND fecha_sum = TO_DATE('21/07/2021','dd/mm/yyyy');
        DBMS_OUTPUT.PUT_LINE('nuevas primeras dosis -> ' || nuevas_primeras_dosis);
        
        
        --Guarda el porcentaje de ancianos vacunados
        SELECT (SELECT  SUM(jv.cantidad_pri_jv)
                FROM JORNADA_VAC jv 
                WHERE grupo_etario_jv = 4 AND pais_jv = centro.pais_cv)/pge.cant_hab_pge.cant_total AS porcentaje
        INTO porcentaje_vacunados
        FROM PAIS_GE pge
        WHERE pge.grupo_etario_pge = 4 AND pge.pais_pge =centro.pais_cv;

        --El 40% de los ancianos ya esta vacunado?
        IF (porcentaje_vacunados > 40) THEN

            --Guarda el porcentaje de adultos vacunados
            SELECT (SELECT  SUM(jv.cantidad_pri_jv)
                    FROM JORNADA_VAC jv 
                    WHERE grupo_etario_jv = 3 AND pais_jv = centro.pais_cv)/pge.cant_hab_pge.cant_total AS porcentaje
            INTO porcentaje_vacunados
            FROM PAIS_GE pge
            WHERE pge.grupo_etario_pge = 3 AND pge.pais_pge = centro.pais_cv;


            IF (porcentaje_vacunados > 40) THEN 

                --Guarda el porcentaje de jovenes vacunados
                SELECT (SELECT  SUM(jv.cantidad_pri_jv)
                        FROM JORNADA_VAC jv 
                        WHERE grupo_etario_jv = 2 AND pais_jv = centro.pais_cv)/pge.cant_hab_pge.cant_total AS porcentaje
                INTO porcentaje_vacunados
                FROM PAIS_GE pge
                WHERE pge.grupo_etario_pge = 2 AND pge.pais_pge = centro.pais_cv;

                IF (porcentaje_vacunados > 40) THEN
                    --Hay mas de 40% de jovenes vacunados. A cada grupo le toca 25%
                    FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
                    LOOP
                        --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                        -- se pusieron, pero multiplicada por la porcion de cada vacuna

                        --25 a cada grupo
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = nuevas_primeras_dosis*porc_vac.porcentaje*0.25
                        WHERE fecha_jv = fecha_actual 
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;

                        --Resta la vacuna 
                        UPDATE INVENTARIO_VAC
                        SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                        WHERE centro_vac_inv = centro.id_cen
                            AND vacuna_inv = porc_vac.vacuna_inv;
                                                        
                    END LOOP;
                ELSE
                    
                    --Hay menos de 40% de adultos vacunados. Toca el 34% a ancianos, 33% a adultos
                    -- y 33% jovenes
                    FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
                    LOOP
                        --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                        -- se pusieron, pero multiplicada por la porcion de cada vacuna

                        --33% a jovenes y adultos
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = nuevas_primeras_dosis*porc_vac.porcentaje*0.33
                        WHERE fecha_jv = fecha_actual 
                            AND (grupo_etario_jv = 3 OR grupo_etario_jv = 2)--Jovenes y adultos
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;

                        --34% para los ancianos
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = nuevas_primeras_dosis*porc_vac.porcentaje*0.34
                        WHERE fecha_jv = fecha_actual 
                            AND (grupo_etario_jv = 4)--Ancianos
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;

                        --Resta la vacuna 
                        UPDATE INVENTARIO_VAC
                        SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                        WHERE centro_vac_inv = centro.id_cen
                            AND vacuna_inv = porc_vac.vacuna_inv;
                    END LOOP;

                END IF;

            ELSE

                --Hay menos de 40% de adultos vacunados. Toca el 50% a ancianos y 50% a adultos
                FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
                LOOP
                    --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                    -- se pusieron, pero multiplicada por la porcion de cada vacuna
                    UPDATE JORNADA_VAC
                    SET cantidad_pri_jv = (centro.capacidad_cen - nuevas_segundas_dosis)*porc_vac.porcentaje*0.5
                    WHERE fecha_jv = fecha_actual 
                        AND (grupo_etario_jv = 4 OR grupo_etario_jv = 3)
                        AND vacuna_jv = porc_vac.vacuna_inv
                        AND pais_jv = centro.pais_cv
                        AND centro_vac_jv = centro.id_cen;

                    --Resta la vacuna 
                    UPDATE INVENTARIO_VAC
                    SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                    WHERE centro_vac_inv = centro.id_cen
                        AND vacuna_inv = porc_vac.vacuna_inv;
                    
                END LOOP;

            END IF;

        ELSE

        --Hay menos de 40% de ancianos vacunados. Toca el 100% a ancianos
            FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
            LOOP
                --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                -- se pusieron, pero multiplicada por la porcion de cada vacuna
                UPDATE JORNADA_VAC
                SET cantidad_pri_jv = nuevas_primeras_dosis*porc_vac.porcentaje
                WHERE fecha_jv = fecha_actual 
                    AND grupo_etario_jv = 4
                    AND vacuna_jv = porc_vac.vacuna_inv
                    AND pais_jv = centro.pais_cv
                    AND centro_vac_jv = centro.id_cen;
                
               --Resta la vacuna 
                UPDATE INVENTARIO_VAC
                SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                WHERE centro_vac_inv = centro.id_cen
                    AND vacuna_inv = porc_vac.vacuna_inv;
                
            END LOOP;
     
        END IF;
        --Solo falta restar los insumos
        UPDATE SUMINISTROS
        SET cant_jeringas_sum = cant_jeringas_sum - nuevas_primeras_dosis,
            cant_alcohol_sum = cant_alcohol_sum - nuevas_primeras_dosis,
            cant_algodon_sum = cant_algodon_sum - nuevas_primeras_dosis,
            cant_par_guantes_sum = cant_par_guantes_sum - CEIL(nuevas_primeras_dosis/10) --CEIL redondea para arriba
        WHERE centro_vac_sum = centro.id_cen 
            AND fecha_sum = fecha_actual;

        
    END LOOP;


END;

