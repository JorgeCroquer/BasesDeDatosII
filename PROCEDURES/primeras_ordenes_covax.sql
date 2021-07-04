CREATE OR REPLACE PROCEDURE primeras_ordenes_covax(fecha_actual DATE) AS

    c_paises SYS_REFCURSOR;
    r_pais pais%ROWTYPE;
BEGIN
    c_paises := get_paises;
    
    WHILE c_paises%FOUND
        LOOP 
            FETCH c_paises INTO r_pais;
            if (r_pais.covax_pai = 'Y') THEN
                registro_orden_covax(r_pais.id_pai, fecha_actual, 20, 1);
            END if;
        END LOOP;
    CLOSE c_paises;
END;
/