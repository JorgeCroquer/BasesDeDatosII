CREATE OR REPLACE PROCEDURE asignacion_paises_covax AS

    c_paises SYS_REFCURSOR;
    r_pais pais%ROWTYPE;
BEGIN

    c_paises := get_paises;

        LOOP 
            FETCH c_paises INTO r_pais;
            if ( dbms_random.value(0,100) > 80) THEN    -- Con 20% de pisibilidad asigna que no es de covax a ese pais (aprox 4 de 20)
                UPDATE PAIS 
                SET covax_pai = 'N'                                
                WHERE (id_pai = r_pais.id_pai);
            END if;
            EXIT WHEN c_paises%NOTFOUND;
        END LOOP;
    CLOSE c_paises;
    commit;
END;
/