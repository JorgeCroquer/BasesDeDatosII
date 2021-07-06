create or replace NONEDITIONABLE PROCEDURE contagios(fecha_actual DATE) IS
    infectados_actuales NUMBER;
    nuevos_infectados NUMBER;
    nuevos_muertos NUMBER;
    nuevos_recuperados NUMBER;
    porcentaje_infectados NUMBER;
    multiplicador NUMBER := 1;
    CURSOR paises IS --Guarda cada registro de PAIS_GE
            SELECT pai.id_pai, pai.tasa_repro_pai, paige.cant_hab_pge, paige.grupo_etario_pge, ge.mortalidad 
            FROM PAIS pai JOIN PAIS_GE paige ON pai.id_pai = paige.pais_pge
                          JOIN GRUPO_ETARIO ge ON ge.id_ge = paige.grupo_etario_pge
            ORDER BY id_pai, grupo_etario_pge;

    mortales H_HABITANTES%ROWTYPE := NULL;   --Guarda el historico de hace 3 semanas para ver a cuantos hay que matar   
    mortalidad GRUPO_ETARIO.mortalidad%TYPE;  --Guarda la mortalidad del grupo etario que esta ejecutando
    nuevo_registro PAIS_GE%ROWTYPE; --guarda el nuevo registro del pais y grupo etario que se le acaban de agregar infectados y muertos
BEGIN 

    FOR pais IN paises
    LOOP
        --Primero, ve cuanto porcentaje de infectaod lleva el pais, para regular la tasa r
        SELECT SUM(pge.cant_hab_pge.cant_infectados)/SUM(pge.cant_hab_pge.cant_total)
        INTO porcentaje_infectados
        FROM PAIS_GE pge
        WHERE pais_pge = 1;

        CASE TRUE
            WHEN porcentaje_infectados >= 0.2 AND porcentaje_infectados < 0.4 THEN
                multiplicador := 0.8;
            WHEN porcentaje_infectados >= 0.4 AND porcentaje_infectados < 0.6 THEN
                multiplicador := 0.6;
            WHEN porcentaje_infectados >= 0.6 AND porcentaje_infectados < 0.8 THEN
                multiplicador := 0.4;
            WHEN porcentaje_infectados >= 0.8 AND porcentaje_infectados < 1 THEN
                multiplicador := 0.2;
            WHEN porcentaje_infectados = 1 THEN
                multiplicador := 0;
        END CASE;

        UPDATE PAIS
        SET TASA_REPRO_PAI = TASA_REPRO_PAI*multiplicador
        WHERE id_pai = pais.id_pai;

        DBMS_OUTPUT.PUT_LINE('pais -> ' || pais.id_pai);
        DBMS_OUTPUT.PUT_LINE('grupo etario -> ' || pais.grupo_etario_pge);

        infectados_actuales := pais.cant_hab_pge.cant_infectados
                                -(pais.cant_hab_pge.cant_recuperados+pais.cant_hab_pge.cant_fallecidos); 

        DBMS_OUTPUT.PUT_LINE('infectados actuales -> ' || infectados_actuales);
        DBMS_OUTPUT.PUT_LINE('tasa R -> ' || pais.tasa_repro_pai);
        nuevos_infectados := infectados_actuales*pais.tasa_repro_pai/3 + TRUNC(DBMS_RANDOM.VALUE(-2,2));

        DBMS_OUTPUT.PUT_LINE('nuevos infectados -> ' || nuevos_infectados);

        UPDATE PAIS_GE p SET p.cant_hab_pge.cant_infectados = p.cant_hab_pge.cant_infectados + ROUND(nuevos_infectados)
        WHERE p.grupo_etario_pge = pais.grupo_etario_pge AND pais.id_pai = p.pais_pge;

        BEGIN
            SELECT * INTO mortales
            FROM H_HABITANTES hh
            WHERE hh.pais_h =pais.id_pai
                AND hh.grupo_etario_h = pais.grupo_etario_pge
                AND hh.fecha_h = fecha_actual-21;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    mortales := NULL;
            END;


        IF (mortales.fecha_h IS NOT NULL) THEN 

            SELECT ge.mortalidad INTO mortalidad
            FROM GRUPO_ETARIO ge 
            WHERE ge.id_ge = pais.grupo_etario_pge;
                
           infectados_actuales := mortales.hab.cant_infectados-(mortales.hab.cant_recuperados+mortales.hab.cant_fallecidos);
        
        DBMS_OUTPUT.PUT_LINE('mortalidad -> ' || mortalidad);
            nuevos_muertos := ROUND(infectados_actuales*mortalidad);
            nuevos_recuperados := infectados_actuales-nuevos_muertos;
        DBMS_OUTPUT.PUT_LINE('nuevos muertos -> ' || nuevos_muertos);
            UPDATE PAIS_GE pge SET pge.cant_hab_pge.cant_fallecidos = pge.cant_hab_pge.cant_fallecidos + nuevos_muertos, pge.cant_hab_pge.cant_recuperados = nuevos_recuperados
            WHERE pge.grupo_etario_pge = pais.grupo_etario_pge AND pais.id_pai = pge.pais_pge;
        END IF;

        SELECT * INTO nuevo_registro
        FROM PAIS_GE pge
        WHERE pge.pais_pge = pais.id_pai AND pge.grupo_etario_pge = pais.grupo_etario_pge;
        INSERT INTO H_HABITANTES VALUES (fecha_actual,nuevo_registro.pais_pge,nuevo_registro.grupo_etario_pge, nuevo_registro.cant_hab_pge);


    END LOOP;
END;