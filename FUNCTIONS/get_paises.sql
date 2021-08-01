create or replace NONEDITIONABLE FUNCTION get_paises RETURN SYS_REFCURSOR AS

    c_paises SYS_REFCURSOR;
BEGIN
    OPEN c_paises FOR SELECT * FROM PAIS;   
    RETURN c_paises;
END;
/