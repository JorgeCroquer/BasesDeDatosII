CREATE OR REPLACE PROCEDURE contagios IS

    CURSOR paises IS
        SELECT * 
        FROM PAISES;

BEGIN 

    FOR pais IN paises
    LOOP

        

    END LOOP;
END;   