CREATE OR REPLACE FUNCTION get_paises RETURN SYS_REFCURSOR AS

    c_paises SYS_REFCURSOR;
BEGIN
    OPEN c_paises FOR SELECT * FROM PAIS p
    WHERE p.covax_pai = 'Y';   
    RETURN c_paises;
END;
/