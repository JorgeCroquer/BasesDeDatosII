CREATE OR REPLACE FUNCTION esta_restringida(pais_id pais.id_pai%TYPE, vacuna_id vacuna.id_vac%TYPE) RETURN BOOLEAN AS

    restriccion restriccion.tipo_res%TYPE;
BEGIN
    SELECT tipo_res INTO restriccion FROM RESTRICCIONES 
    WHERE pais_res = pais_id AND vacuna_res = vacuna_id;
    EXCEPTION 
    
    WHEN NO_DATA_FOUND THEN 
        BEGIN 
            RETURN (FALSE); 
        END;
    
    
    if (restriccion = 'R') THEN
        RETURN (TRUE);
    else RETURN (FALSE);
    END if;
END;
/