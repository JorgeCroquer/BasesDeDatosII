CREATE OR REPLACE FUNCTION get_covax_id RETURN distribuidora.id_dist%TYPE AS

    covax_id distribuidora.id_dist%TYPE;
BEGIN
    BEGIN
    SELECT id_dist INTO covax_id FROM DISTRIBUIDORA 
    WHERE (nombre_dist = 'COVAX');
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    RETURN (0);
    end;
    RETURN covax_id;
END;
/