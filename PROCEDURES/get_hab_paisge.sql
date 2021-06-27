CREATE OR REPLACE FUNCTION get_hab_paisge(id_pais NUMBER) RETURN CURSOR IS

     DECLARE 
        CURSOR HAB_PAISGE IS
        SELECT * FROM PAIS_GE
        WHERE pais = id_pais;
        
BEGIN
    RETURN HAB_PAISGE;
END;
