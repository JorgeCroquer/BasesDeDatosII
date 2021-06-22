CREATE OR REPLACE PROCEDURE SIMULACION IS
    
    --Definimos una fecha aleatoria entre el 6 y 12 de marzo para el inicio de la simulacion
    fecha_actual DATE := TO_DATE(TRUNC(DBMS_RANDOM.VALUE(
                            TO_CHAR(TO_DATE('06/03/2020','dd/mm/yyyy'), 'J'),
                            TO_CHAR(TO_DATE('12/03/2020','dd/mm/yyyy'), 'J'))), 'J');

    fechas_sputnik F_FASES;
BEGIN
    DBMS_OUTPUT.PUT_LINE('SIMULACION COVID-19');
    
    --Inicio

    --asignacion de fechas para vacunas
    fechas_sputnik := F_FASES(
        fecha_actual,
        generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 1),TO_CHAR(ADD_MONTHS(fecha_actual, 2)),
        generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 4),TO_CHAR(ADD_MONTHS(fecha_actual, 6)),
        generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 8),TO_CHAR(ADD_MONTHS(fecha_actual, 10)),
        generarFecha(TO_CHAR(ADD_MONTHS(fecha_actual, 12),TO_CHAR(ADD_MONTHS(fecha_actual, 14))
    )
END;