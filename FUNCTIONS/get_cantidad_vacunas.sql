CREATE OR REPLACE FUNCTION get_cantidad_vacunas(pais_id pais.id_pai%TYPE, n_orden orden.id_ord%TYPE) RETURN NUMBER AS

    cant_vacunas NUMBER;
BEGIN
    
        SELECT SUM(pedido.cantidad_dis) INTO cant_vacunas FROM DISTRIBUCION pedido
        WHERE distribucion. = pais_id;
        RETURN cant_vacunas;   --RETORNA EL TOTAL DE VACUNAS EN UNA ORDEN

    
END;
/
