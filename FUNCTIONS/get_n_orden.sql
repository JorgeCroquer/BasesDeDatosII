CREATE OR REPLACE FUNCTION get_n_orden(pais_id pais.id_pai%TYPE, distribuidora_id distribuidora.id_dist%TYPE, fecha_actual DATE) RETURN orden.id_ord%TYPE AS

    n_orden orden.id_ord%TYPE;
BEGIN
    SELECT id_ord INTO n_orden FROM ORDEN 
    WHERE (pais_ord = pais_id AND distribuidora_ord = distribuidora_id AND f_realizacion_ord = fecha_actual);
    RETURN n_orden;
END;