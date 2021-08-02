--Reporte 8
CREATE OR REPLACE PROCEDURE reporte_8(rep_cursor OUT sys_refcursor, pais_p varchar, vacuna_p varchar) IS
BEGIN
   OPEN rep_cursor
   FOR 
   SELECT p.bandera_pai, r.nombre_pai, r.nombre_vac , r.porcentaje_vacunado, r.procentaje_efsec_detectado
   FROM(
      SELECT id_pai, nombre_pai, nombre_vac,TRUNC((SUM(cantidad_seg_jv)/get_poblacion(id_pai,'TOTAL'))*100,2) as porcentaje_vacunado,
      CASE 
         WHEN SUM(cantidad_seg_jv) != 0 THEN TRUNC((SUM(cantidad_efsec_jv)/SUM(cantidad_seg_jv))*100,2) 
         ELSE 0
      END as procentaje_efsec_detectado
      FROM pais
      JOIN jornada_vac ON pais_jv = id_pai
      JOIN vacuna ON vacuna_jv = id_vac
      JOIN jv_efec ON vacuna_jve = id_vac
      WHERE nombre_pai LIKE nvl(pais_p, nombre_pai)
      AND nombre_vac LIKE nvl(vacuna_p,nombre_vac)
      GROUP BY nombre_pai, nombre_vac, id_pai) r
   JOIN pais p ON p.id_pai = r.id_pai 
   ORDER BY p.id_pai;
END;

--Reporte 8 subreporte 1
CREATE OR REPLACE PROCEDURE reporte_8_subreporte_1(rep_cursor OUT sys_refcursor, pais_p number, vacuna_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT DISTINCT pais_jve, vacuna_jve, nombre_efe
      FROM jv_efec 
      JOIN efecto_secundario ON id_efe = efecto_secundario_jve
      WHERE pais_jve = pais_p
      AND vacuna_jve = vacuna_p;
END;

