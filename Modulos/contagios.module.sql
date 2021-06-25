create or replace NONEDITIONABLE PROCEDURE contagios(fecha_actual DATE) IS
    infectados_actuales NUMBER;
    nuevos_infectados NUMBER;
    nuevos_muertos NUMBER;

    CURSOR paises IS --Guarda cada registro de PAIS_GE
            SELECT pai.id_pai, pai.tasa_repro_pai, paige.cant_hab_paisge, paige.grupo_etario, ge.mortalidad 
            FROM PAIS pai JOIN PAIS_GE paige ON pai.id_pai = paige.pais
                          JOIN GRUPO_ETARIO ge ON ge.id_ge = paige.grupo_etario
            ORDER BY id_pai, grupo_etario;

    mortales H_HABITANTES%ROWTYPE := NULL;   --Guarda el historico de hace 3 semanas para ver a cuantos hay que matar   
    mortalidad GRUPO_ETARIO.mortalidad%TYPE;  --Guarda la mortalidad del grupo etario que esta ejecutando
    nuevo_registro PAIS_GE%ROWTYPE; --guarda el nuevo registro del pais y grupo etario que se le acaban de agregar infectados y muertos
BEGIN 

    FOR pais IN paises
    LOOP


        infectados_actuales := pais.cant_hab_paisge.cant_infectados
                                -(pais.cant_hab_paisge.cant_recuperados+pais.cant_hab_paisge.cant_fallecidos); 


        nuevos_infectados := infectados_actuales*pais.tasa_repro_pai;



        UPDATE PAIS_GE p SET p.cant_hab_paisge.cant_infectados = p.cant_hab_paisge.cant_infectados + TRUNC(nuevos_infectados)
        WHERE p.grupo_etario = pais.grupo_etario AND pais.id_pai = p.pais;

        BEGIN
            SELECT * INTO mortales
            FROM H_HABITANTES hh
            WHERE hh.pais_h =pais.id_pai
                AND hh.grupo_etario_h = pais.grupo_etario
                AND hh.fecha_h = fecha_actual-21;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    mortales := NULL;
            END;


        IF (mortales.fecha_h IS NOT NULL) THEN 

            SELECT ge.mortalidad INTO mortalidad
            FROM GRUPO_ETARIO ge 
            WHERE ge.id_ge = pais.grupo_etario;


            nuevos_muertos := infectados_actuales*mortalidad;

            UPDATE PAIS_GE pge SET pge.cant_hab_paisge.cant_fallecidos = pge.cant_hab_paisge.cant_fallecidos + TRUNC(nuevos_muertos)
            WHERE pge.grupo_etario = pais.grupo_etario AND pais.id_pai = pge.pais;
        END IF;

        SELECT * INTO nuevo_registro
        FROM PAIS_GE pge
        WHERE pge.pais = pais.id_pai AND pge.grupo_etario = pais.grupo_etario;
        INSERT INTO H_HABITANTES VALUES (fecha_actual,nuevo_registro.pais,nuevo_registro.grupo_etario, nuevo_registro.cant_hab_paisge);


    END LOOP;
END;