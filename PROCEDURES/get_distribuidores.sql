CREATE OR REPLACE FUNCTION get_distribuidores(vacuna_id vacuna.id_vac%type) RETURN SYS_REFCURSOR AS

    c_dist_vacuna SYS_REFCURSOR;
BEGIN
    OPEN c_dist_vacuna FOR SELECT * FROM VACUNA_DISTRIBUIDORA
    WHERE vacuna_vd = vacuna_id;                --COGE LOS REGISTROS DE TODAS LAS DISTRIBUIDORAS CON SU CANTIDAD DE VACUNAS
    RETURN c_dist_vacuna;
END;
/