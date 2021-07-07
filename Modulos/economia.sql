--Retorna true si hay alguna vacuna aprobada
create or replace NONEDITIONABLE FUNCTION vacuna_aprobada RETURN BOOLEAN AS 
BEGIN 
    FOR v IN (SELECT fechas_vac FROM VACUNA)
    LOOP
        IF(v.fechas_vac.faseActual() = 'Fase 4') THEN
            RETURN (TRUE);
        END IF;    
    END LOOP;
    RETURN (FALSE);
END;

--Chequea si hay alguna orden pendiente por recibir y de haberlo retorna los datos de esa orden
CREATE OR REPLACE FUNCTION orden_pendiente(pais_p NUMBER, fecha_actual DATE) RETURN ORDEN%rowtype AS
BEGIN
    FOR o IN (SELECT * FROM ORDEN WHERE pais_ord = pais_p)
    LOOP
        IF(o.estatus_ord != 'ENTREGADA' AND o.estatus_ord != 'EN ESPERA') THEN
            RETURN o; 
        END IF;
    END LOOP;
    RETURN NULL;
END;

--Chequea si la meta de vacuncación ha sido superada, utiliza la funcion get poblacion desarrolada por jesus
CREATE OR REPLACE FUNCTION meta_superada( pais_p NUMBER) RETURN BOOLEAN AS
meta_vacunacion NUMBER;
porcentaje_vacunado NUMBER;
BEGIN
    SELECT meta_vac_pai
    INTO meta_vacunacion
    FROM pais
    WHERE id_pai = pais_p;

    SELECT (SUM(cantidad_pri_jv)/get_poblacion(pais_p,'TOTAL'))*100
    INTO porcentaje_vacunado
    FROM JORNADA_VAC j
    WHERE pais_jv = pais_p
    AND fecha_jv = (SELECT MAX(fecha_jv)
                    FROM JORNADA_VAC j2
                    WHERE j2.pais_jv = j.pais_jv
                    AND j2.grupo_etario_jv = j.pais_jv
                    AND j2.centro_vac_jv = j.centro_vac_jv
                    AND j2.vacuna_jv= j.vacuna_jv);

    IF(porcentaje_vacunado >= meta_vacunacion) THEN
        RETURN (TRUE);
    ELSE
        RETURN(FALSE);    
    END IF;
END;

--Chequea si el pais se esta quedando sin vacunas y necesita ordenar más
--Toma en cuenta que las vacunas tardan un mes en llegar, por eso la condicion es *4
CREATE OR REPLACE FUNCTION hora_de_ordenar( pais_p NUMBER) RETURN BOOLEAN AS
capacidad_total NUMBER;
total_vacunas_disponibles NUMBER;
BEGIN
    SELECT SUM(capacidad_cen)
    INTO capacidad_total
    FROM CENTRO_VAC
    WHERE pais_cv = pais_p;

    SELECT SUM(cantidad_pri_inv)
    INTO total_vacunas_disponibles
    FROM INVENTARIO_VAC
    JOIN CENTRO_VAC ON centro_vac_inv = id_cen
    WHERE pais_cv = pais_p;

    IF(capacidad_total*4 >= nvl(total_vacunas_disponibles,0)) THEN
        RETURN (TRUE);
    ELSE
        RETURN(FALSE);    
    END IF;
END;

--Distribuye las vacunas
CREATE OR REPLACE PROCEDURE distribuir_vacunas(orden_p ORDEN%rowtype, pais_p NUMBER) IS
cantidad_centros NUMBER;
cantidad_asignada NUMBER;
cantidad_sobrante NUMBER;
centro_premiado NUMBER;
existe_inventario NUMBER;
dosis_vacuna NUMBER;
BEGIN
    SELECT COUNT(id_cen) INTO cantidad_centros FROM CENTRO_VAC WHERE pais_cv = pais_p; --Guardamos la cantida de centros que hay en ese pais        
    For v in (SELECT * FROM DISTRIBUCION WHERE n_orden_dis = orden_p.id_ord) --Distribuimos las vacuna entre los centros de vacunacion de ese pais
    LOOP
        SELECT dosis_vac INTO dosis_vacuna FROM VACUNA WHERE id_vac = v.vacuna_dis;
        For c in (SELECT * FROM CENTRO_VAC WHERE pais_cv = pais_p) --Asignamos primero una cantidad igual a cada centro
        LOOP            
            cantidad_asignada := TRUNC((v.cantidad_dis/cantidad_centros));
            cantidad_sobrante:= MOD(v.cantidad_dis,cantidad_centros);
            BEGIN --ESTO ES COMO TRY
                SELECT cantidad_pri_inv INTO existe_inventario FROM INVENTARIO_VAC WHERE centro_vac_inv = c.id_cen AND vacuna_inv = v.vacuna_dis;
                EXCEPTION WHEN no_data_found THEN --ESTO ES EL CATCH
                BEGIN
                    existe_inventario:= NULL;
                END;
            END;
            IF(existe_inventario IS NULL) THEN
                IF( dosis_vacuna = 2) THEN
                    INSERT INTO INVENTARIO_VAC VALUES(c.id_cen,v.vacuna_dis, cantidad_asignada, cantidad_asignada);
                ELSE
                    INSERT INTO INVENTARIO_VAC VALUES(c.id_cen, v.vacuna_dis, cantidad_asignada, NULL);
                END IF;    
            ELSE
                IF(dosis_vacuna = 2) THEN 
                    UPDATE INVENTARIO_VAC 
                    SET cantidad_pri_inv = cantidad_pri_inv + cantidad_asignada, cantidad_seg_inv = cantidad_seg_inv + cantidad_asignada
                    WHERE centro_vac_inv = c.id_cen
                    AND vacuna_inv = v.vacuna_dis; 
                ELSE
                    UPDATE INVENTARIO_VAC 
                    SET cantidad_pri_inv = cantidad_pri_inv + cantidad_asignada
                    WHERE centro_vac_inv = c.id_cen
                    AND vacuna_inv = v.vacuna_dis; 
                END IF; 
            END IF;
        END LOOP;
        SELECT * INTO centro_premiado
        FROM (SELECT id_cen FROM CENTRO_VAC WHERE pais_cv = pais_p) WHERE rownum = 1; --Luego escogemos el primer centro del pais y le damos la cantida sobrante
        IF(dosis_vacuna = 2) THEN
            UPDATE INVENTARIO_VAC 
            SET cantidad_pri_inv = cantidad_pri_inv + cantidad_sobrante, cantidad_seg_inv = cantidad_seg_inv + cantidad_sobrante
            WHERE centro_vac_inv = centro_premiado
            AND vacuna_inv = v.vacuna_dis; 
        ELSE
            UPDATE INVENTARIO_VAC 
            SET cantidad_pri_inv = cantidad_pri_inv + cantidad_sobrante
            WHERE centro_vac_inv = centro_premiado
            AND vacuna_inv = v.vacuna_dis; 
        END IF;
    END LOOP;
END;

--Realiza una orden a un proveedor aleatorio
--Realiza una orden a un proveedor aleatorio
CREATE OR REPLACE PROCEDURE orden_a_proveedor(pais_p NUMBER,fecha_actual DATE) IS --PODRIA MODIFICARSE PARA QUE SEA EL MISMO QUE LE PIDE A COVAX
vacunas_a_ordenar NUMBER;
cantidad_de_proveedores NUMBER;
proveedor_escogido NUMBER;
vacuna_a_solicitar NUMBER;
precio_vacuna NUMBER;
monto_a_pagar NUMBER;
orden_realizada NUMBER;
monto_a_abonar NUMBER;
numero_random NUMBER;
poblacion NUMBER;
cantidad_de_vacunas NUMBER;
capacidad_total NUMBER;
seleccionada_vac NUMBER := 0;
estatus_vacuna NUMBER;
BEGIN
    SELECT count(id_dist) 
    INTO cantidad_de_proveedores
    FROM DISTRIBUIDORA 
    WHERE id_dist != 10; --Cuenta cuantos proveedores hay, Excepto covax que es el 10
 
    poblacion:=get_poblacion(pais_p,'TOTAL');
    vacunas_a_ordenar:= TRUNC(get_poblacion(pais_p,'TOTAL')/cantidad_de_proveedores); --Divide la población entre la cantidad de proveedores
    
    --Si la cantidad de vacunas a ordenar es menor que la cantidad de vacunas que se gastan en un mes(Lo que tardan en llegar las vacunas) 
    --en ese pais la cantidad de vacunas a ordenar se calcula en base a su capacidad total.
    SELECT SUM(capacidad_cen)
    INTO capacidad_total
    FROM CENTRO_VAC
    WHERE pais_cv = pais_p;

    IF(vacunas_a_ordenar < capacidad_total*4) THEN
        vacunas_a_ordenar:= capacidad_total*6;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Cantidad proveedores: '||cantidad_de_proveedores||'Poblacion: '||poblacion||' Vacunas a ordenar: '||vacunas_a_ordenar);

    SELECT count(id_vac) INTO cantidad_de_vacunas FROM VACUNA; --Cuenta las vacunas
    
    WHILE (seleccionada_vac = 0) --Seleccionamos una vacuna random que no esté restringida
    LOOP
        numero_random:= TRUNC(dbms_random.value(1,cantidad_de_vacunas));
        SELECT id_vac, estatus_vac
        INTO vacuna_a_solicitar, estatus_vacuna
        FROM (SELECT rownum r, id_vac, estatus_vac
            FROM VACUNA) 
        WHERE r = numero_random; --Escoge una vacuna random
        IF(esta_restringida(pais_p,vacuna_a_solicitar) = FALSE AND estatus_vacuna = 4) THEN
            seleccionada_vac := 1;
        END IF;    
    END LOOP;
    
    SELECT distribuidora_vd
    INTO proveedor_escogido
    FROM VACUNA_DISTRIBUIDORA
    WHERE vacuna_vd = vacuna_a_solicitar ;--Busca el proveedor correspondiente

    SELECT precio_vac
    INTO precio_vacuna
    FROM VACUNA
    WHERE id_vac = vacuna_a_solicitar; --Busca el precio de la vacuna
    
    monto_a_pagar:= vacunas_a_ordenar*precio_vacuna; --Se calcula el monto total a pagar
    
    --Se registra la orden
    INSERT INTO ORDEN VALUES(DEFAULT,pais_p,proveedor_escogido,monto_a_pagar,'EN TRANSITO',fecha_actual,fecha_actual + 30, fecha_actual+30+TRUNC(dbms_random.value(-2,2)))
    RETURNING id_ord INTO orden_realizada;
    DBMS_OUTPUT.PUT_LINE('SE REALIZÓ UNA ORDEN QUE LLEGA EL DIA '||(fecha_actual + 30) );
    --Se registran las vacunas en la orden
    INSERT INTO DISTRIBUCION VALUES(orden_realizada,vacuna_a_solicitar,vacunas_a_ordenar);
    --Se registra el pago de un porcentaje
    monto_a_abonar:= monto_a_pagar*TRUNC(dbms_random.value(0.30,0.70),2);
    INSERT INTO PAGO VALUES(DEFAULT,fecha_actual,monto_a_abonar,orden_realizada);
END;

CREATE OR REPLACE PROCEDURE modulo_economia(fecha_actual DATE) IS
cantidad_centros NUMBER;
orden_pen ORDEN%rowtype;
covax_p VARCHAR(1);
pago_pendiente NUMBER;
aprobado_covax BOOLEAN;
BEGIN
    IF (vacuna_aprobada() = TRUE) THEN
        FOR p IN (SELECT * FROM PAIS)
        LOOP
            DBMS_OUTPUT.PUT_LINE('El pais: '||p.nombre_pai||' hará lo siguiente:');
            orden_pen:= orden_pendiente(p.id_pai, fecha_actual);
            IF (orden_pen.id_ord IS NOT NULL) THEN --Chequeamos si hay orden pendiente
                IF(fecha_actual >= orden_pen.f_entrega_ord) THEN --Chequeamos si ya llegó la orden
                    UPDATE ORDEN SET estatus_ord = 'ENTREGADA' WHERE id_ord = orden_pen.id_ord; --Actualizamos la orden a entregada
                    distribuir_vacunas(orden_pen,p.id_pai); --distribuimos las vacunas entre los diferentes centros de vacunacion
                    DBMS_OUTPUT.PUT_LINE('Orden recibida.Distribuyendo vacunas...');
                    SELECT orden_pen.monto_ord - SUM(monto_pag) 
                    INTO pago_pendiente
                    FROM PAGO
                    WHERE n_orden_pag = orden_pen.id_ord;
                    IF(pago_pendiente > 0) THEN --Realizamos el pago pendiente de ser necesario 
                        INSERT INTO PAGO VALUES(DEFAULT,orden_pen.f_entrega_ord,pago_pendiente,orden_pen.id_ord);
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('Pago completado');
                END IF;
            ELSE 
                IF(meta_superada(p.id_pai) = FALSE) THEN --Se superó la meta de vacunación?
                    IF(hora_de_ordenar(p.id_pai) = TRUE) THEN -- Ya toca volver a pedir?
                        SELECT covax_pai INTO covax_p FROM pais WHERE id_pai = p.id_pai;
                        IF(covax_p = 'Y') THEN --pertenece a covax?
                            DBMS_OUTPUT.PUT_LINE('Realizando orden a covax');
                            aprobado_covax := solicitar_orden_covax(p.id_pai,fecha_actual);
                            IF(aprobado_covax = FALSE) THEN
                                DBMS_OUTPUT.PUT_LINE('Covax rechazó la orden, realizando orden a otro provedor');
                                orden_a_proveedor(p.id_pai,fecha_actual);--se pide a alguien mas
                            END IF;
                        ELSE
                            orden_a_proveedor(p.id_pai,fecha_actual);--se pide a alguien mas
                            DBMS_OUTPUT.PUT_LINE('Realizando orden a proveedor');
                        END IF;
                    END IF;
                END IF;
            END IF;
        END LOOP;
    END IF;
END;


CREATE OR REPLACE PROCEDURE pedir_insumos(centro_p NUMBER, fecha_actual DATE) IS
riqueza NUMBER;
suministros_c SUMINISTROS%rowtype;
centro CENTRO_VAC%rowtype;
BEGIN
    SELECT *
    INTO centro
    FROM CENTRO_VAC
    WHERE id_cen = centro_p;

    SELECT riqueza_pai
    INTO riqueza
    FROM PAIS
    WHERE id_pai = centro.pais_cv;

    SELECT *
    INTO suministros_c
    FROM SUMINISTROS
    WHERE fecha_sum = fecha_actual
    AND centro_vac_sum = centro.id_cen; 

    INSERT INTO SUMINISTROS VALUES(fecha_actual+1,
                                       centro.id_cen,
                                       suministros_c.cant_jeringas_sum + centro.capacidad_cen * riqueza,
                                       suministros_c.cant_alcohol_sum + centro.capacidad_cen * riqueza,
                                       suministros_c.cant_algodon_sum + centro.capacidad_cen * riqueza,
                                       suministros_c.cant_par_guantes_sum + TRUNC((centro.capacidad_cen * riqueza)/10) + 1);
    
    DBMS_OUTPUT.PUT_LINE('El centro de vacunación: '||centro.nombre_cen||' repuso sus suministros para las práximas '||riqueza||' semanas');                                   
END;