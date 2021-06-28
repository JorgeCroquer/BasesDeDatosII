CREATE OR REPLACE PROCEDURE SIMULACION IS


    --Definicion de variables
    terminado BOOLEAN := FALSE;
    covax_existe BOOLEAN := covax_existe;


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
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_pfizer := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_moderna := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_sinopharm := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_sinovac := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_cansino := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_aztrazeneca := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_JANDJ := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );
    fechas_janssen := F_FASES(
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1)),TO_CHAR(ADD_MONTHS(fecha_actual, 2))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4)),TO_CHAR(ADD_MONTHS(fecha_actual, 6))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8)),TO_CHAR(ADD_MONTHS(fecha_actual, 10))),
        F_FASES.generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12)),TO_CHAR(ADD_MONTHS(fecha_actual, 14)))
    );


    --Bucle principal
    WHILE NOT terminado
    LOOP
        -- ciclo de 12 semanas
        FOR i IN 1..12
        LOOP
        
            contagios(fecha_actual);
            
            
            --Sumamos 7 dias (1 semana) a la fecha actual
            fecha_actual := fecha_actual + 7;

            

        END LOOP;

        
        terminado := TRUE; --Esto es por ahora, hay que programar el criterio de salida
    END LOOP;

END;