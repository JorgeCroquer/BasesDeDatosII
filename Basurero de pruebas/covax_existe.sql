CREATE OR REPLACE FUNCTION covax_existe RETURN BOOLEAN IS 

    covax_id DISTRIBUIDORA.id_dist%TYPE;
BEGIN
    covax_id := get_covax_id;
    if (covax_id = 0) THEN
        RETURN (FALSE);
    END if;
    RETURN (TRUE);
END;
/