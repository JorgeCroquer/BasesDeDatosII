create or replace NONEDITIONABLE TRIGGER trg_effectos_sec 
AFTER INSERT ON jornada_vac
FOR EACH ROW
DECLARE
aleatorio NUMBER := 0;
nuevos_efectos NUMBER := 0;
/*Armamos un cursor donde se van a obtener los efectos 
relacionados con la vacuna previamente insertada*/
CURSOR efectos IS
SELECT *  
FROM efecto_secundario
WHERE id_efe IN (SELECT efecto_secundario_ve
                    FROM vac_efec
                    WHERE vacuna_ve = :new.vacuna_jv);

efectos_vacuna efecto_secundario%rowtype;
BEGIN

    OPEN efectos;
    FETCH efectos INTO efectos_vacuna;
    WHILE efectos%FOUND
    LOOP
        IF (efectos_vacuna.id_efe != 4) THEN
            aleatorio := ((:new.cantidad_pri_jv+:new.cantidad_seg_jv)*TRUNC(dbms_random.value(-0.03,0.03),2));
        nuevos_efectos := (((:new.cantidad_pri_jv+:new.cantidad_seg_jv)*efectos_vacuna.probabilidad_efe)+ aleatorio);

        --valores(id efecto secundario, id jornada de vacunación (5), cantidad presentada)
        INSERT INTO jv_efec VALUES(
            ((:new.cantidad_pri_jv+:new.cantidad_seg_jv)*efectos_vacuna.probabilidad_efe)+ aleatorio,
            :new.vacuna_jv,
            :new.centro_vac_jv,
            :new.fecha_jv,
            :new.pais_jv,
            :new.grupo_etario_jv,
            efectos_vacuna.id_efe
        );
        FETCH efectos INTO efectos_vacuna;
    END LOOP;
END;