CREATE OR REPLACE FUNCTION get_vacunas_orden(pais_id pais.id_pai%TYPE, porcentaje_pob NUMBER, covax BOOLEAN) RETURN NUMBER AS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    poblacion NUMBER;
    cont INTEGER := 1;
BEGIN
    if (covax) THEN
        c_vacunas := get_vacunas_covax;
        WHILE c_vacunas%FOUND
        LOOP 
            FETCH c_vacunas INTO r_vacuna;
            if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
                cont := cont + 1;
            END if;
        END LOOP;
    CLOSE c_vacunas;
    END if;

    
    poblacion := get_poblacion(pais_id, 'TOTAL');
    poblacion := poblacion*(porcentaje_pob/100);
    RETURN poblacion/cont;
END;

--Leo:

CREATE OR REPLACE FUNCTION get_vacunas_orden(pais_id pais.id_pai%TYPE, porcentaje_pob NUMBER, covax NUMBER) RETURN NUMBER AS

    c_vacunas SYS_REFCURSOR;
    r_vacuna vacuna%ROWTYPE;
    poblacion NUMBER;
    cont INTEGER := 1;
BEGIN
    if (covax = 1) THEN
        c_vacunas := get_vacunas_covax;
        WHILE c_vacunas%FOUND
        LOOP 
            FETCH c_vacunas INTO r_vacuna;
            if NOT(esta_restringida(pais_id, r_vacuna.id_vac)) THEN
                cont := cont + 1;
            END if;
        END LOOP;
    CLOSE c_vacunas;
    END if;

    
    poblacion := get_poblacion(pais_id, 'TOTAL');
    poblacion := poblacion*(porcentaje_pob/100);
    RETURN poblacion/cont;
END;