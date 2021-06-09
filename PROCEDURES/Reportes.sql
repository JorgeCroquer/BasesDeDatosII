-- Reporte1

-- Hay que agregarle un metodo al TDA F_fases para que imprima la fase actual 
--de la vacuna según las fechas que tenga registradas

CREATE OR REPLACE PROCEDURE reporte_1(nombre_vacuna varchar, fecha_aprobacion date) IS
BEGIN
    IF(nombre_vacuna IS NOT NULL AND fecha_aprobacion IS NOT NULL) THEN
        SELECT aprobf_vac.fecha_F1 as 'Fecha de Creación',aprobf_vac.fecha_aprobacion as 'Fecha de aprobación',
        nombre_vac as 'Nombre de la vacuna', nombre_est as 'Estatus de la vacuna', aprobf_vac.faseActual() as 'Fase de vacuna',
        efectividad_vac '% de efectividad', covax_vac '¿Se distribuye por mecanismo COVAX?'
        FROM vacuna
        JOIN estatus ON pk_estatus_vac = id_est
        WHERE nombre_vac  LIKE  '%'|| nombre_vacuna ||'%' 
        AND aprobf_vac.fecha_aprobacion >= fecha_aprobacion; 
    ELSE IF (nombre_vacuna IS NOT NULL AND fecha_aprobacion IS NULL) THEN
        SELECT aprobf_vac.fecha_F1 as 'Fecha de Creación',aprobf_vac.fecha_aprobacion as 'Fecha de aprobación',
        nombre_vac as 'Nombre de la vacuna', nombre_est as 'Estatus de la vacuna', aprobf_vac.faseActual() as 'Fase de vacuna',
        efectividad_vac '% de efectividad', covax_vac '¿Se distribuye por mecanismo COVAX?'
        FROM vacuna
        JOIN estatus ON pk_estatus_vac = id_est
        WHERE nombre_vac LIKE '%'|| nombre_vacuna ||'%';
    ELSE IF (nombre_vacuna IS NULL AND fecha_aprobacion IS NOT NULL) THEN
        SELECT aprobf_vac.fecha_F1 as 'Fecha de Creación',aprobf_vac.fecha_aprobacion as 'Fecha de aprobación',
        nombre_vac as 'Nombre de la vacuna', nombre_est as 'Estatus de la vacuna', aprobf_vac.faseActual() as 'Fase de vacuna',
        efectividad_vac '% de efectividad', covax_vac '¿Se distribuye por mecanismo COVAX?'
        FROM vacuna
        JOIN estatus ON pk_estatus_vac = id_est
        WHERE aprobf_vac.fecha_aprobacion >= fecha_aprobacion; 
    ELSE IF (nombre_vacuna IS NULL AND fecha_aprobacion IS NOT NULL) THEN
        raise_application_error(-20001,'Debe haber al menos un parametro que no sea nulo');
    END IF;   
END;