create or replace NONEDITIONABLE PROCEDURE SIMULACION IS


    --Definicion de variables
    terminado BOOLEAN := FALSE;
    b_farmaceuticas BOOLEAN := TRUE;

    --Definimos una fecha aleatoria entre el 6 y 12 de marzo para el inicio de la simulacion
    fecha_actual DATE := TO_DATE(TRUNC(DBMS_RANDOM.VALUE(
                            TO_CHAR(TO_DATE('06/03/2020','dd/mm/yyyy'), 'J'),
                            TO_CHAR(TO_DATE('12/03/2020','dd/mm/yyyy'), 'J'))), 'J');

    fechas_sputnik F_FASES;
    fechas_pfizer F_FASES;
    fechas_moderna F_FASES;
    fechas_sinopharm F_FASES;
    fechas_sinovac F_FASES;
    fechas_cansino F_FASES;
    fechas_aztrazeneca F_FASES;
    fechas_JANDJ F_FASES;
    fechas_janssen F_FASES;





    --Procedures locales

BEGIN
    DBMS_OUTPUT.PUT_LINE('SIMULACION COVID-19');

    --Inicio

    --asignacion de fechas para vacunas
    fechas_sputnik := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
   
    fechas_pfizer := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_moderna := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_sinopharm := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_sinovac := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_cansino := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_aztrazeneca := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_JANDJ := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    fechas_janssen := F_FASES(
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))))),
        TO_DATE(TO_CHAR(F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))))
    );
    UPDATE VACUNA
    SET fechas_vac = fechas_pfizer                             
    WHERE (id_vac = '1');
    UPDATE VACUNA
    SET fechas_vac = fechas_janssen                             
    WHERE (id_vac = '2');
    UPDATE VACUNA
    SET fechas_vac = fechas_JANDJ                             
    WHERE (id_vac = '3');
    UPDATE VACUNA
    SET fechas_vac = fechas_aztrazeneca                             
    WHERE (id_vac = '4');
    UPDATE VACUNA
    SET fechas_vac = fechas_moderna                              
    WHERE (id_vac = '5');
    UPDATE VACUNA
    SET fechas_vac = fechas_sinovac                             
    WHERE (id_vac = '6');
    UPDATE VACUNA
    SET fechas_vac = fechas_sputnik                               
    WHERE (id_vac = '7');
    UPDATE VACUNA
    SET fechas_vac = fechas_sinopharm                             
    WHERE (id_vac = '8');
    UPDATE VACUNA
    SET fechas_vac = fechas_cansino                             
    WHERE (id_vac = '9');

    commit;
    --Bucle principal
    WHILE NOT terminado
    LOOP
        -- ciclo de 12 semanas
        FOR i IN 1..72
        LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('Semana '|| i || ' Lunes '|| fecha_actual);
            DBMS_OUTPUT.PUT_LINE('');
            contagios(fecha_actual);
            disparador_eventos(fecha_actual);
            if (b_farmaceuticas) THEN
                b_farmaceuticas := farmaceuticas(fecha_actual);
            END if;
            

            --Sumamos 7 dias (1 semana) a la fecha actual
            fecha_actual := fecha_actual + 7;



        END LOOP;

        terminado := TRUE; --Esto es por ahora, hay que programar el criterio de salida
    END LOOP;

END;