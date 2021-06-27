CREATE OR REPLACE PROCEDURE farmaceuticas(fecha_actual DATE) IS
    
    
    DECLARE
        VACUNAS CURSOR;
        REGISTRO_VAC VACUNA%ROWTYPE;
BEGIN
    VACUNAS := get_vacunas;
    OPEN VACUNAS;
    FETCH VACUNAS INTO REGISTRO_VAC;
    WHILE VACUNAS%FOUND
        LOOP 
            if (rango_fecha(fecha_actual, REGISTRO_VAC.fechas_vac.fecha_f4)) THEN
                DBMS_OUTPUT.PUT_LINE('La vacuna' || REGISTRO_VAC.nombre_vac || 'ha entrado en fase 4.');
                -- if (es la primera) then
               --     EXECUTE creacion_covax;
               -- end if;
                EXECUTE asignacion_vacunas(REGISTRO_VAC.id_vac);    --asiga 30% a COVAX y el 70% restante se lo queda el laboratorio creador.
                
            end if;
        END LOOP;
    CLOSE VACUNAS;  
END;