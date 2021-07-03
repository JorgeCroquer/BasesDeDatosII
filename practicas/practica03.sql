CREATE OR REPLACE TRIGGER trg_effectos_sec 
AFTER INSERT ON jornada_vacunacion
DECLARE
/*Armamos un cursor donde se van a obtener los efectos 
relacionados con la vacuna previamente insertada*/
CURSOR efectos IS
SELECT *  
FROM efecto_secundario
WHERE id_efe IN (SELECT fk_id_efect_ve
                    FROM vac_efec
                    WHERE fk_id_vac_ve = :new.fk_vac_jv);

efectos_vacuna efecto_secundario%rowtype
BEGIN
    OPEN efectos;
    FETCH efectos INTO efecto_secundario
    WHILE efectos%FOUND
    LOOP
        /*Obtenemos la probabilidad del efecto secundario dato y lo registramos de ser necesario*/
        IF ( activar(efecto_secundario.probabilidad_efe)) THEN
            /*valores(id efecto secundario, id jornada de vacunación (3), cantidad presentada)*/
            INSERT INTO jv_efec VALUES(efecto_secundario.if_efe,:new.id_vac,:new_fecha_jv,new:id_cen, ((:new.cantidad_pri_jv+:new.cantidad_seg_jv)*efecto_secundario.probabilidad_efe)+ random((:new.cantidad_pri_jv+:new.cantidad_seg_jv)*0.5, -(:new.cantidad_pri_jv+:new.cantidad_seg_jv)*0.5));
        END IF;
        FETCH efectos INTO efecto_secundario;
    END LOOP;    
END;
