CREATE OR REPLACE PROCEDURE eventos_aleatorios IS
    
    CURSOR eventos IS
        SELECT * FROM EVENTOS_ALEATORIOS;


BEGIN

    FOR evento IN eventos
    LOOP

        IF (evento.habilitado = 'Y') THEN

            IF (evento.fecha IS NOT NULL) THEN 
            
                IF(evento.fecha NOT BETWEEN fecha_actual AND fecha_actual+6) THEN
                
                    CONTINUE; --Salta al siguiente evento
                
                END IF;
            
            ELSE 
                --Lo activa basado en probabilidad

                IF (activado) THEN


                    IF (evento.efecto_eve = 'CAMBIO_FECHA') THEN

                        --MODIFICA LA FECHA SEGUN EFECTO
                        
                    ELSE

                        IF (evento.pais IS NULL) THEN 

                            --Escoge un pais al azar

                        END IF;   

                        --Aplica el efecto segun el pais.

                    END IF;

                    --Se inhabilita el evento
                    END LOOP;


                ELSE CONTINUE; --Salta al siguiente evento   
                END IF;
                

            END IF;

            

            

        END IF;


    END LOOP;


END;