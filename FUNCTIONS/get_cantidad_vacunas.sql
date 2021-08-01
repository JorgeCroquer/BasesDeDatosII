create or replace NONEDITIONABLE FUNCTION get_cantidad_vacunas(n_orden orden.id_ord%TYPE) RETURN NUMBER AS

    cant_vacunas NUMBER;
BEGIN

        SELECT SUM(pedido.cantidad_dis) 
        INTO cant_vacunas 
        FROM DISTRIBUCION pedido
        WHERE n_orden_dis = n_orden;
        RETURN cant_vacunas;   --RETORNA EL TOTAL DE VACUNAS EN UNA ORDEN
END;
/
