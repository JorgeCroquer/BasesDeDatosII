CREATE OR REPLACE FUNCTION rango_fecha(fecha_actual DATE, fecha_comp DATE) RETURN bool  IS

    SET fecha_fin DATE =  fecha_actual + 6;
    
BEGIN
    if (fecha_comp >= fecha_actual AND fecha_comp <= fecha_fin) THEN
        return (TRUE);
    else 
        return (FALSE);
    END if;
END;