create or replace NONEDITIONABLE FUNCTION get_distribucion_orden(n_orden orden.id_ord%TYPE) RETURN SYS_REFCURSOR AS

    c_distribucion SYS_REFCURSOR;

BEGIN
    OPEN c_distribucion FOR SELECT * FROM DISTRIBUCION
    WHERE n_orden_dis = n_orden;   
    RETURN c_distribucion;
END;
/