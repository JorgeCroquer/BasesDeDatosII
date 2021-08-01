create or replace NONEDITIONABLE FUNCTION get_poblacion_e(pais_id pais.id_pai%TYPE, grupo_e NUMBER) RETURN NUMBER AS
    poblacion NUMBER;
BEGIN
        SELECT pge.cant_hab_pge.cant_total INTO poblacion FROM PAIS_GE pge
        WHERE pais_pge = pais_id
        AND grupo_etario_pge = grupo_e;
        RETURN poblacion;   --RETORNA EL TOTAL DE LA POBLACION DE UN PAIS SEGUN EL GRUPO ETARIO INGRESADO
END;