CREATE OR REPLACE FUNCTION get_vacunas_covax RETURN SYS_REFCURSOR AS

    c_vacunas SYS_REFCURSOR;
BEGIN
    OPEN c_vacunas FOR SELECT * FROM vacuna v
    WHERE v.covax_vac = 'Y';   
    RETURN c_vacunas;
END;
/