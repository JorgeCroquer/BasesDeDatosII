CREATE OR REPLACE FUNCTION rango_fecha(fecha_actual DATE, fecha_comp DATE) RETURN BOOLEAN  IS

    fecha_fin DATE :=  fecha_actual + 6;    --SUMA 6 PARA CUBIR EL RANGO DE LUNES A DOMINGO
    
BEGIN
    if (fecha_comp >= fecha_actual AND fecha_comp <= fecha_fin) THEN
        return (TRUE);
    else 
        return (FALSE);
    end if;
END;
/