CREATE OR REPLACE PROCEDURE primeras_ordenes_covax(fecha_actual DATE) AS

    c_paises SYS_REFCURSOR;
    r_pais pais%ROWTYPE;
BEGIN
    c_paises := get_paises;
    FETCH c_paises INTO r_pais;
    WHILE c_paises%FOUND
        LOOP 
            
            if (r_pais.covax_pai = 'Y') THEN
                registro_orden_covax(r_pais.id_pai, fecha_actual, 20, 1);
            END if;
           FETCH c_paises INTO r_pais;
        END LOOP;
    CLOSE c_paises;
END;
/