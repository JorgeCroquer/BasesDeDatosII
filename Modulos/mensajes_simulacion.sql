CREATE OR REPLACE PROCEDURE reporte_semanal_mundial IS
infectados_t NUMBER;
fallecidos_t NUMBER;
recuperados_t NUMBER;
ordenes_t NUMBER;
vacunas_t NUMBER;
BEGIN

    --Buscamos i,f,r
    BEGIN
        SELECT SUM(pg.cant_hab_pge.cant_infectados), SUM(pg.cant_hab_pge.cant_fallecidos), SUM(pg.cant_hab_pge.cant_recuperados)
        INTO infectados_t, fallecidos_t, recuperados_t
        FROM PAIS_GE pg;
        EXCEPTION WHEN no_data_found THEN
        BEGIN
            infectados_t:=0; fallecidos_t:=0; recuperados_t:=0;
        END;
    END;
    --Buscamos ordenes
    BEGIN
        SELECT count(id_ord)
        INTO ordenes_t
        FROM ORDEN;
        EXCEPTION WHEN no_data_found THEN
        BEGIN
            ordenes_t:=0; 
        END;
    END;    
    --Buscamos vacunas aplicadas, el ultimo registro de cada caso
    BEGIN
        SELECT SUM(cantidad_pri_jv)
        INTO vacunas_t
        FROM JORNADA_VAC j1
        WHERE fecha_jv = (SELECT MAX(fecha_jv) 
                            FROM JORNADA_VAC j2 
                            WHERE j2.pais_jv = j1.pais_jv 
                            AND j2.grupo_etario_jv = j1.pais_jv
                            AND j2.centro_vac_jv = j1.centro_vac_jv
                            AND j2.vacuna_jv = j1.vacuna_jv);
        EXCEPTION WHEN no_data_found THEN
        BEGIN
            vacunas_t:=0; 
        END;                    
    END;
    DBMS_OUTPUT.PUT_LINE('');                    
    DBMS_OUTPUT.PUT_LINE('--------------------------Reporte semamnal mundial');
    DBMS_OUTPUT.PUT_LINE('Hasta ahora se han registrado:');
    DBMS_OUTPUT.PUT_LINE('Infectados: '||infectados_t||' Fallecidos: '||fallecidos_t||' Recuperados '||recuperados_t);
    DBMS_OUTPUT.PUT_LINE('Ordenes de vacunas: '||ordenes_t||' Vacunas aplicadas: '||vacunas_t);       
END;