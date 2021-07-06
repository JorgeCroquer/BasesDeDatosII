CREATE OR REPLACE FUNCTION get_vacunas_orden(pais_id pais.id_pai%TYPE, porcentaje_pob NUMBER) RETURN NUMBER AS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    poblacion NUMBER;
    cont INTEGER := 1;
BEGIN
    c_vacunas := get_vacunas_covax;
            
    LOOP            --COMO LA SOLICITUD DE COVAX ES DE TODAS LAS VACUNAS NO RESTRINGIDAS PARA EL PAIS Y SE HACE PARA UN % DE POBLACION DETERMINADO, ENTONCES,
        FETCH c_vacunas INTO r_vacuna;
        if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
            cont := cont + 1;                   --SE CUENTA LA CANTIDAD DE VACUNAS NO RESTRINGIDAS PARA EL PAIS
        END if;
        EXIT WHEN c_vacunas%NOTFOUND;
    END LOOP;
    CLOSE c_vacunas;

    poblacion := get_poblacion(pais_id, 'TOTAL');
    poblacion := poblacion*(porcentaje_pob/100);    --SE CALCULA LA CANTIDAD DE VACUNAS NECESARIAS PARA EL % DE POBLACION DE LA ORDEN
    RETURN poblacion/cont;          --RETORNA LA CANTIDAD DE VACUNAS QUE SE ENVIARAN POR VACUNA (ESA CANTIDAD ES LA MISMA PARA TODAS LAS VACUNAS) 
END;
/