create or replace NONEDITIONABLE FUNCTION get_restricciones_pais(pais_id pais.id_pai%TYPE) RETURN SYS_REFCURSOR AS

    c_restricciones SYS_REFCURSOR;
BEGIN
    OPEN c_restricciones FOR SELECT * FROM RESTRICCIONES
    WHERE pais_res = pais_id;             -- RETORNA TODAS LAS RESTRICCIONES PARA UN PAIS (SE DEBE VALIDAR ANTES SI EL PAIS TIENE RESTRICCIONES PARA EVITAR ERRORES)
    RETURN c_restricciones;
END;
/