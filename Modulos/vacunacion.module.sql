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
        WHERE s.fecha_sum = (SELECT MAX(fecha_sum)
                             FROM SUMINISTROS sub_s
                             WHERE sub_s.centro_vac_sum = cv.id_cen);

    CURSOR inventarios(centro NUMBER) IS 
        SELECT * 
        FROM INVENTARIO_VAC
        WHERE centro_vac_inv = centro AND (cantidad_pri_inv > 0 OR cantidad_seg_inv > 0);

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

    existencia NUMBER; --cantidad de primeras dosis en inventario

    segundas_dosis NUMBER; --cantidad de segundas dosis ya aplicadas

    check_insumos NUMBER; 

    por_vacunar_ancianos NUMBER;

    por_vacunar_adultos NUMBER;

    por_vacunar_jovenes NUMBER;

    por_vacunar_niños NUMBER;

    sobrante NUMBER; --exceso de vacunas cuando un grupo ya esta 100% vacunado

    aux NUMBER;

    --PRUEBAS
    cant_jeringas_sum NUMBER;
    cant_alcohol_sum NUMBER;
    cant_algodon_sum NUMBER;
    cant_par_guantes_sum NUMBER;

BEGIN

    --DBMS_OUTPUT.PUT_LINE('entre en vacunacion');

    FOR centro in centros_vacunacion
    LOOP
        --DBMS_OUTPUT.PUT_LINE('centro -> ' || centro.id_cen);

        --Inserta un nuevo registro de suministros para la fecha actual
        INSERT INTO SUMINISTROS VALUES(fecha_actual,
                                       centro.id_cen,
                                       centro.cant_jeringas_sum,
                                       centro.cant_par_guantes_sum,
                                       centro.cant_alcohol_sum,
                                       centro.cant_algodon_sum
                                       );

        --Primero hay que crear todas las jornadas
        FOR vac IN 1..9 
        LOOP
            FOR grupo IN 1..4
            LOOP
                --Inserto una jornada por cada centro, cada vacuna y cada grupo etario
                INSERT INTO JORNADA_VAC VALUES (fecha_actual,0,centro.id_cen,vac,centro.pais_cv,grupo,0);
            END LOOP;
        END LOOP;

        SELECT COUNT(*) 
        INTO aux
        FROM INVENTARIO_VAC
        WHERE centro_vac_inv = centro.id_cen AND (cantidad_pri_inv > 0 OR cantidad_seg_inv > 0);
        

        IF (aux = 0) THEN 
            CONTINUE;

        END IF;

        --Primero hay que ver si hay dosis pendientes en cada jornada de cada vacuna y grupo
        FOR inventario IN inventarios(centro.id_cen)
        LOOP
            --DBMS_OUTPUT.PUT_LINE('vacuna -> ' || inventario.vacuna_inv);
            FOR grupo IN 1..4
            LOOP
                --DBMS_OUTPUT.PUT_LINE('grupo -> ' || grupo);
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
                        --DBMS_OUTPUT.PUT_LINE('Si hay suministros' );



                        --Chequea la existencia de segundas dosis suficientes en el inventario
                        IF (inventario.cantidad_seg_inv > pendientes.cantidad_pri_jv) THEN 
                            --DBMS_OUTPUT.PUT_LINE('Si hay inventario ');
                            --Suma las nuevas segundas dosis
                            --DBMS_OUTPUT.PUT_LINE('pendientes -> ' ||pendientes.cantidad_pri_jv );
                            nuevas_segundas_dosis := nuevas_segundas_dosis+pendientes.cantidad_pri_jv;
                            --DBMS_OUTPUT.PUT_LINE('Nuevas segundas dosis -> ' || nuevas_segundas_dosis);
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
                commit;
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
        --DBMS_OUTPUT.PUT_LINE('existencia -> ' || existencia);
        SELECT SUM(cantidad_seg_jv) INTO segundas_dosis
        FROM JORNADA_VAC
        WHERE centro_vac_jv = centro.id_cen AND fecha_jv = fecha_actual;
        --DBMS_OUTPUT.PUT_LINE('segundas_dosis_aplicadas -> ' || segundas_dosis);
        SELECT CASE
                    WHEN existencia < cv.capacidad_cen - segundas_dosis  THEN existencia
                    ELSE cv.capacidad_cen - segundas_dosis
                END primeras_dosis  
        INTO nuevas_primeras_dosis --Guardamos aqui   
        FROM centro_vac cv 
        WHERE cv.id_cen = centro.id_cen;

        check_insumos := nuevas_primeras_dosis;
        --DBMS_OUTPUT.PUT_LINE('check_insumo -> ' || check_insumos);
        
        --Pregunta si hay insumos, elige lo que haya menos de los insumos (incluido las nuevas primeras dosis)
        SELECT LEAST(cant_jeringas_sum,cant_alcohol_sum,cant_algodon_sum,cant_par_guantes_sum*10,nuevas_primeras_dosis)
        INTO nuevas_primeras_dosis
        FROM SUMINISTROS
        WHERE centro_vac_sum = centro.id_cen AND fecha_sum = fecha_actual;



        --Chequea si habia falta de insumos para pedir mas
        IF (nuevas_primeras_dosis < check_insumos) THEN

            pedir_insumos(centro.id_cen,fecha_actual);

        END IF;
        --Nunca se deben poner mas de la mitad de la capacidad en primeras 
        --Por eso, si las nuevas primeras dosis son mas que la mitad de la capacidad del centro...
        IF (nuevas_primeras_dosis > centro.capacidad_cen*0.5) THEN
            --Capa a la mitad del centro las primeras dosis aplicables
            nuevas_primeras_dosis := centro.capacidad_cen*0.5;
        END IF;


        IF (nuevas_primeras_dosis < 1) THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('ALERTA nuevas primeras dosis -> ' || nuevas_primeras_dosis);
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('DALE PAL SIGUIENTE MI LOCO');
            exit;
        END IF;


        --Guarda el porcentaje de ancianos vacunados
        SELECT (SELECT  SUM(jv.cantidad_pri_jv)
                FROM JORNADA_VAC jv 
                WHERE grupo_etario_jv = 4 AND pais_jv = centro.pais_cv)/pge.cant_hab_pge.cant_total AS porcentaje
        INTO porcentaje_vacunados
        FROM PAIS_GE pge
        WHERE pge.grupo_etario_pge = 4 AND pge.pais_pge =centro.pais_cv;

        --DBMS_OUTPUT.PUT_LINE('porcentaje ancianos vacunados -> ' || porcentaje_vacunados);

        --El 40% de los ancianos ya esta vacunado?
        IF (porcentaje_vacunados > 0.40) THEN
            --DBMS_OUTPUT.PUT_LINE('Mas de 40% de ancianos vacunados');
            --Guarda el porcentaje de adultos vacunados
            SELECT (SELECT  SUM(jv.cantidad_pri_jv)
                    FROM JORNADA_VAC jv 
                    WHERE grupo_etario_jv = 3 AND pais_jv = centro.pais_cv)/pge.cant_hab_pge.cant_total AS porcentaje
            INTO porcentaje_vacunados
            FROM PAIS_GE pge
            WHERE pge.grupo_etario_pge = 3 AND pge.pais_pge = centro.pais_cv;
            --DBMS_OUTPUT.PUT_LINE('porcentaje adultos vacunados -> ' || porcentaje_vacunados);

            IF (porcentaje_vacunados > 0.40) THEN 
                --DBMS_OUTPUT.PUT_LINE('Mas de 40% de adultos vacunados');
                --Guarda el porcentaje de jovenes vacunados
                SELECT (SELECT  SUM(jv.cantidad_pri_jv)
                        FROM JORNADA_VAC jv 
                        WHERE grupo_etario_jv = 2 AND pais_jv = centro.pais_cv)/pge.cant_hab_pge.cant_total AS porcentaje
                INTO porcentaje_vacunados
                FROM PAIS_GE pge
                WHERE pge.grupo_etario_pge = 2 AND pge.pais_pge = centro.pais_cv;
                --DBMS_OUTPUT.PUT_LINE('porcentaje jovenes vacunados -> ' || porcentaje_vacunados);
                IF (porcentaje_vacunados > 0.40) THEN
                    --DBMS_OUTPUT.PUT_LINE('Mas de 40% de jovenes vacunados');
                    --Hay mas de 40% de jovenes vacunados. A cada grupo le toca 25%

                    --Hay que verificar que no se vaya a pasar de vacunados

                     --Cuantos ancianos quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                    FROM JORNADA_VAC 
                                                    WHERE grupo_etario_jv = 4 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_ancianos
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 4 AND pais_pge= centro.pais_cv;

                    --Cuantos adultos quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                        FROM JORNADA_VAC 
                                                        WHERE grupo_etario_jv = 3 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_adultos
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 3 AND pais_pge= centro.pais_cv;

                    --Cuantos jovenes quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                        FROM JORNADA_VAC 
                                                        WHERE grupo_etario_jv = 2 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_jovenes
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 2 AND pais_pge= centro.pais_cv;

                    --Cuantos niños quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                        FROM JORNADA_VAC 
                                                        WHERE grupo_etario_jv = 1 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_niños
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 1 AND pais_pge= centro.pais_cv;

                    --limpia sobrante
                    sobrante := 0;


                    --Si faltan mas ancianos que los disponibles del centro(x0.25)
                    IF (por_vacunar_ancianos > nuevas_primeras_dosis*0.25) THEN
                        por_vacunar_ancianos := nuevas_primeras_dosis*0.25+sobrante;--Solo vacuna hasta el tope
                    ELSE
                    --Si no, asignale el sobrante de vacunas a los adultos
                        sobrante := nuevas_primeras_dosis*0.25-por_vacunar_ancianos;
                        por_vacunar_adultos := por_vacunar_adultos + sobrante;
                    END IF;

                    --Si faltan menos adultos que los disponibles del centro(x0.25)
                    IF (por_vacunar_adultos < nuevas_primeras_dosis*0.25) THEN
                       --Entonces, asigna a los jovenes el sobrante de vacunas
                        sobrante := nuevas_primeras_dosis*0.25 - por_vacunar_adultos;
                        por_vacunar_jovenes := por_vacunar_jovenes + sobrante;
                    ELSE
                        --Sino, solo vacuna hasta el tope de disponibilidad
                        por_vacunar_adultos := nuevas_primeras_dosis*0.25+sobrante;
                    END IF;

                    --Si faltan menos jovenes que los disponibles del centro(x0.25)
                    IF (por_vacunar_jovenes < nuevas_primeras_dosis*0.25) THEN 
                        --Entonces, asigna a los niños el sobrante de vacunas
                        sobrante := nuevas_primeras_dosis*0.25 - por_vacunar_jovenes;
                        por_vacunar_niños := nuevas_primeras_dosis*0.25 - por_vacunar_niños;
                    ELSE
                        --Sino, solo vacuna hasta el tope de disponibilidad
                        por_vacunar_jovenes := nuevas_primeras_dosis*0.25+sobrante;
                    END IF;

                    --Si faltan mas niños que los disponibles del centro(x0.25)
                    IF (por_vacunar_niños > nuevas_primeras_dosis*0.25) THEN
                        --Entonces solo vacuna hasta el tope de disponibilidad
                        por_vacunar_niños := nuevas_primeras_dosis*0.25+sobrante;
                    END IF; --Sino, vacuna a los que falten


                    FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
                    LOOP

                        --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                        -- se pusieron, pero multiplicada por la porcion de cada vacuna

                        --25% para los ancianos
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_ancianos*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND (grupo_etario_jv = 4)--Ancianos
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('ancianos vacunados -> ' || TRUNC(por_vacunar_ancianos*porc_vac.porcentaje));

                        --25% a adultos
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_adultos*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND grupo_etario_jv = 3 --adultos
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('adultos vacunados -> ' ||TRUNC(por_vacunar_adultos *porc_vac.porcentaje));

                        --25% a jovenes
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_jovenes*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND grupo_etario_jv = 2 --jovenes
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('jovenes vacunados -> ' ||TRUNC(por_vacunar_adultos *porc_vac.porcentaje));

                        --25% nenes
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_jovenes*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND grupo_etario_jv = 1 --nenes
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('niños vacunados -> ' ||TRUNC(por_vacunar_adultos *porc_vac.porcentaje));

                        


                        --Resta la vacuna 
                        UPDATE INVENTARIO_VAC
                        SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                        WHERE centro_vac_inv = centro.id_cen
                            AND vacuna_inv = porc_vac.vacuna_inv;
                        --DBMS_OUTPUT.PUT_LINE('vacunados -> ' || nuevas_primeras_dosis*porc_vac.porcentaje);
                    END LOOP;
                ELSE
                    --Hay menos de 40% de adultos vacunados. Toca el 34% a ancianos, 33% a adultos
                    -- y 33% jovenes


                    --limpia sobrante
                    sobrante := 0;

                   --Cuantos ancianos quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                        FROM JORNADA_VAC 
                                                        WHERE grupo_etario_jv = 4 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_ancianos
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 4 AND pais_pge= centro.pais_cv;

                    --Cuantos adultos quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                        FROM JORNADA_VAC 
                                                        WHERE grupo_etario_jv = 3 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_adultos
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 3 AND pais_pge= centro.pais_cv;

                    --Cuantos jovenes quedan por vacunar
                    SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                        FROM JORNADA_VAC 
                                                        WHERE grupo_etario_jv = 2 AND pais_jv= centro.pais_cv)
                    INTO por_vacunar_jovenes
                    FROM PAIS_GE pge
                    WHERE grupo_etario_pge = 2 AND pais_pge= centro.pais_cv;

                    --los ancianos por vacunar son mas que la disponibilidad del centro(x0.34)?
                    IF (por_vacunar_ancianos > nuevas_primeras_dosis*0.34) THEN
                        por_vacunar_ancianos := nuevas_primeras_dosis*0.34;--Entonces solo vacuna hasta el tope
                    ELSE      
                        --Sino, asigna el sobrante a los adultos                                            
                        sobrante := nuevas_primeras_dosis*0.34-por_vacunar_ancianos;
                        por_vacunar_adultos := por_vacunar_adultos + sobrante;
                    END IF;    

                    --Los adultos por vacunar mas el sobrante de ancianos es mayor que la 
                    --disponibilidad del centro(x0.33)?
                    IF (por_vacunar_adultos > nuevas_primeras_dosis*0.33) THEN  
                        por_vacunar_adultos := nuevas_primeras_dosis*0.33+sobrante;--Entonces solo vacuna hasta el tope 
                    ELSE
                        --Asigna el sobrante de vacunas a los jovenes
                        sobrante := nuevas_primeras_dosis*0.33 - por_vacunar_adultos;
                        por_vacunar_jovenes := por_vacunar_jovenes+sobrante;
                    END IF;
                    
                    FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
                    LOOP
                        --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                        -- se pusieron, pero multiplicada por la porcion de cada vacuna

                        --33% a adultos
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_adultos*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND grupo_etario_jv = 3 --adultos
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('adultos vacunados -> ' ||TRUNC(por_vacunar_adultos *porc_vac.porcentaje));

                        --33% a jovenes
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_jovenes*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND grupo_etario_jv = 2 --jovenes
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('jovenes vacunados -> ' ||TRUNC(por_vacunar_jovenes *porc_vac.porcentaje));

                        --34% para los ancianos
                        UPDATE JORNADA_VAC
                        SET cantidad_pri_jv = TRUNC(por_vacunar_ancianos*porc_vac.porcentaje)
                        WHERE fecha_jv = fecha_actual 
                            AND (grupo_etario_jv = 4)--Ancianos
                            AND vacuna_jv = porc_vac.vacuna_inv
                            AND pais_jv = centro.pais_cv
                            AND centro_vac_jv = centro.id_cen;
                        --DBMS_OUTPUT.PUT_LINE('ancianos vacunados -> ' || TRUNC(por_vacunar_ancianos*porc_vac.porcentaje));
                        --Resta la vacuna 
                        UPDATE INVENTARIO_VAC
                        SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                        WHERE centro_vac_inv = centro.id_cen
                            AND vacuna_inv = porc_vac.vacuna_inv;
                    END LOOP;

                END IF;

            ELSE
                --Hay menos de 40% de adultos vacunados. Toca el 50% a ancianos y 50% a adultos

                --limpia sobrante
                sobrante := 0;

                --Cuantos ancianos quedan por vacunar
                SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                    FROM JORNADA_VAC 
                                                    WHERE grupo_etario_jv = 4 AND pais_jv= centro.pais_cv)
                INTO por_vacunar_ancianos
                FROM PAIS_GE pge
                WHERE grupo_etario_pge = 4 AND pais_pge= centro.pais_cv;

                --Cuantos adultos quedan por vacunar
                SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                    FROM JORNADA_VAC 
                                                    WHERE grupo_etario_jv = 3 AND pais_jv= centro.pais_cv)
                INTO por_vacunar_adultos
                FROM PAIS_GE pge
                WHERE grupo_etario_pge = 3 AND pais_pge= centro.pais_cv;

                --los ancianos por vacunar son mas que la disponibilidad del centro (x0.5)?
                IF (por_vacunar_ancianos > nuevas_primeras_dosis*0.5) THEN
                    por_vacunar_ancianos := nuevas_primeras_dosis*0.5;--Entonces solo vacuna hasta el tope
                ELSE       
                    --Sino, asigna el sobrante de vacunas a los adultos                                       
                    sobrante := nuevas_primeras_dosis*0.5-por_vacunar_ancianos;
                    por_vacunar_adultos := por_vacunar_adultos+sobrante;
                END IF;    

                IF (por_vacunar_adultos > nuevas_primeras_dosis*0.5) THEN
                    por_vacunar_adultos := nuevas_primeras_dosis*0.5+sobrante;
                END IF;

                
                FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
                LOOP
                    --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                    -- se pusieron, pero multiplicada por la porcion de cada vacuna

                    
                    UPDATE JORNADA_VAC
                    SET cantidad_pri_jv = TRUNC(por_vacunar_ancianos*porc_vac.porcentaje)
                    WHERE fecha_jv = fecha_actual 
                        AND grupo_etario_jv = 4
                        AND vacuna_jv = porc_vac.vacuna_inv
                        AND pais_jv = centro.pais_cv
                        AND centro_vac_jv = centro.id_cen;
                    --DBMS_OUTPUT.PUT_LINE('ancianos vacunados -> ' || TRUNC(por_vacunar_ancianos*porc_vac.porcentaje));

                    UPDATE JORNADA_VAC
                    SET cantidad_pri_jv = TRUNC(por_vacunar_adultos*porc_vac.porcentaje)
                    WHERE fecha_jv = fecha_actual 
                        AND grupo_etario_jv = 3
                        AND vacuna_jv = porc_vac.vacuna_inv
                        AND pais_jv = centro.pais_cv
                        AND centro_vac_jv = centro.id_cen;
                    --DBMS_OUTPUT.PUT_LINE('adultos vacunados -> ' || TRUNC(por_vacunar_adultos*porc_vac.porcentaje));
                    --Resta la vacuna 
                    UPDATE INVENTARIO_VAC
                    SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                    WHERE centro_vac_inv = centro.id_cen
                        AND vacuna_inv = porc_vac.vacuna_inv;

                END LOOP;

            END IF;

        ELSE

        --Hay menos de 40% de ancianos vacunados. Toca el 100% a ancianos

        --DBMS_OUTPUT.PUT_LINE('Menos de 40% de ancianos vacunados');
            FOR porc_vac IN porcentajes_vacuna(centro.id_cen)
            LOOP

                --Cuantos ancianos quedan por vacunar
                SELECT pge.cant_hab_pge.cant_total-(SELECT SUM(cantidad_pri_jv) 
                                                    FROM JORNADA_VAC 
                                                    WHERE grupo_etario_jv = 4 AND pais_jv= centro.pais_cv)
                INTO por_vacunar_ancianos
                FROM PAIS_GE pge
                WHERE grupo_etario_pge = 4 AND pais_pge= centro.pais_cv;

                --los ancianos por vacunar son mas que la disponibilidad del centro?
                IF (por_vacunar_ancianos > nuevas_primeras_dosis) THEN
                    por_vacunar_ancianos := nuevas_primeras_dosis;-- Entonces solo vacuna hasta el tope
                END IF;                                           -- de disponibilidad

                --En cada loop, vacuna a la capacidad menos las segundas dosis que ya 
                -- se pusieron, pero multiplicada por la porcion de cada vacuna
                UPDATE JORNADA_VAC
                SET cantidad_pri_jv = TRUNC(por_vacunar_ancianos*porc_vac.porcentaje)
                WHERE fecha_jv = fecha_actual 
                    AND grupo_etario_jv = 4
                    AND vacuna_jv = porc_vac.vacuna_inv
                    AND pais_jv = centro.pais_cv
                    AND centro_vac_jv = centro.id_cen;

                --DBMS_OUTPUT.PUT_LINE('ancianos vacunados -> ' || TRUNC(por_vacunar_ancianos*porc_vac.porcentaje));

               --Resta la vacuna 
                UPDATE INVENTARIO_VAC
                SET cantidad_pri_inv = cantidad_pri_inv - nuevas_primeras_dosis*porc_vac.porcentaje
                WHERE centro_vac_inv = centro.id_cen
                    AND vacuna_inv = porc_vac.vacuna_inv;

            END LOOP;

        END IF;
        --Solo falta restar los insumos

        --DBMS_OUTPUT.PUT_LINE('resto insumos');
        UPDATE SUMINISTROS
        SET cant_jeringas_sum = cant_jeringas_sum - nuevas_primeras_dosis,
            cant_alcohol_sum = cant_alcohol_sum - nuevas_primeras_dosis,
            cant_algodon_sum = cant_algodon_sum - nuevas_primeras_dosis,
            cant_par_guantes_sum = cant_par_guantes_sum - CEIL(nuevas_primeras_dosis/10) --CEIL redondea para arriba
        WHERE centro_vac_sum = centro.id_cen 
            AND fecha_sum = fecha_actual;


    END LOOP;


END;