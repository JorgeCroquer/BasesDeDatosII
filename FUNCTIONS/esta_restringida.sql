create or replace NONEDITIONABLE FUNCTION esta_restringida(pais_id pais.id_pai%TYPE, vacuna_id vacuna.id_vac%TYPE) RETURN BOOLEAN AS
    restriccion restricciones.tipo_res%TYPE;
BEGIN
    SELECT tipo_res INTO restriccion FROM RESTRICCIONES 
    WHERE pais_res = pais_id AND vacuna_res = vacuna_id;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN RETURN (FALSE); 

    IF (restriccion = 'R') THEN
        RETURN (TRUE);
    else RETURN (FALSE);
    END if;
END;
/