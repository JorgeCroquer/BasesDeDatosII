create or replace NONEDITIONABLE PROCEDURE asignacion_paises_covax AS

    c_paises SYS_REFCURSOR;
    r_pais pais%ROWTYPE;
BEGIN

    c_paises := get_paises;
    FETCH c_paises INTO r_pais;
    WHILE c_paises%FOUND
        LOOP 

            if ( dbms_random.value(0,100) < 80) THEN    -- con 80% de posibilidad los asigna a covax
                UPDATE PAIS 
                SET covax_pai = 'Y'                                
                WHERE (id_pai = r_pais.id_pai);
            END if;
            FETCH c_paises INTO r_pais;
        END LOOP;
    CLOSE c_paises;
    commit;
END;
/