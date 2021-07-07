CREATE OR REPLACE PROCEDURE disparador_eventos(fecha_actual DATE) IS
    
    CURSOR eventos IS
        SELECT * FROM EVENTOS_ALEATORIOS;

    numero NUMBER; --Guarda el valor para evaluar la probabilidad

    pais_aleatorio pais.id_pai%TYPE;
BEGIN

    FOR evento IN eventos
    LOOP

        IF (evento.habilitado_eve = 'Y') THEN

            IF (evento.fecha_ocurrencia_eve IS NOT NULL) THEN 
            
                IF(evento.fecha_ocurrencia_eve NOT BETWEEN fecha_actual AND fecha_actual+6) THEN
                
                    CONTINUE; --Salta al siguiente evento
                
                END IF;
            
            ELSE 
                numero := TRUNC(DBMS_RANDOM.VALUE(1,100));
                
                IF (numero <= evento.probabilidad_eve) THEN
                    

                    IF (evento.tipo_eve = 'CAMBIO_FECHA') THEN

                        --Modifica la fecha de la vacuna 
                        DBMS_OUTPUT.PUT_LINE('');
                        EXIT;
                        
                    ELSIF (evento.tipo_eve = 'CUARENTENA') THEN
                        
                        UPDATE PAIS p SET tasa_repro_pai = 0.9 + TRUNC(DBMS_RANDOM.VALUE(-0.07,0.07),2)
                        WHERE p.id_pai = evento.pais_eve;
                        

                    ELSE

                        IF (evento.pais_eve IS NULL) THEN 

                            --Escoge un pais al azar
                            SELECT id_pai INTO pais_aleatorio
                            FROM pais
                            ORDER BY DBMS_RANDOM.RANDOM
                            FETCH FIRST 1 ROWS ONLY;

                        END IF;   

                        --Aplica el efecto segun el pais.
                        DBMS_OUTPUT.PUT_LINE('');
                        EXIT;
                    END IF;
                        --Se inhabilita el evento
                        UPDATE EVENTOS_ALEATORIOS eve SET eve.habilitado_eve = 'N'
                        WHERE eve.id_eve = evento.id_eve;
                        
                        


                ELSE CONTINUE; --Salta al siguiente evento  
                END IF;
                

            END IF;

            

            

        END IF;


    END LOOP;


END;