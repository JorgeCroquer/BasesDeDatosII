create or replace NONEDITIONABLE FUNCTION get_poblacion(pais_id pais.id_pai%TYPE, type varchar2) RETURN NUMBER AS

    poblacion NUMBER;
BEGIN
    if (type = 'TOTAL') THEN

        SELECT SUM(pge.cant_hab_pge.cant_total) INTO poblacion FROM PAIS_GE pge
        WHERE pais_pge = pais_id;
        RETURN poblacion;   --RETORNA EL TOTAL DE LA POBLACION DE UN PAIS

    elsif (type = 'INFECTADOS') THEN

        SELECT SUM(pge.cant_hab_pge.cant_infectados) INTO poblacion FROM PAIS_GE pge
        WHERE pais_pge = pais_id;
        RETURN poblacion;   --RETORNA EL TOTAL DE INFECTADOS DE UN PAIS

    elsif (type = 'RECUPERADOS') THEN

        SELECT SUM(pge.cant_hab_pge.cant_recuperados) INTO poblacion FROM PAIS_GE pge
        WHERE pais_pge = pais_id;
        RETURN poblacion;     --RETORNA EL TOTAL DE RECUPERADOS DE UN PAIS

    elsif (type = 'FALLECIDOS') THEN

        SELECT SUM(pge.cant_hab_pge.cant_fallecidos) INTO poblacion FROM PAIS_GE pge
        WHERE pais_pge = pais_id;
        RETURN poblacion;    --RETORNA EL TOTAL DE FALLECIDOS DE UN PAIS

    END if;

END;
/