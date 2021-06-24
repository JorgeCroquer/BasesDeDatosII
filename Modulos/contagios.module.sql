CREATE OR REPLACE PROCEDURE contagios IS

    CURSOR paises IS
        SELECT * 
        FROM PAISES pai JOIN PAIS_GE paige ON pai.id_pai = paige.pais
                        JOIN GRUPO_ETARIO ge ON ge.id_ge = paige.grupo_etario;

BEGIN 

    FOR pais IN paises
    LOOP

        

    END LOOP;
END;   