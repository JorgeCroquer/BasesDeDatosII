create or replace NONEDITIONABLE FUNCTION get_vacunas RETURN SYS_REFCURSOR AS

    c_vacunas SYS_REFCURSOR;
BEGIN
    OPEN c_vacunas FOR SELECT * FROM vacuna;   
    RETURN c_vacunas;
END;
/