-- Reporte1

-- Hay que agregarle un metodo al TDA F_fases para que imprima la fase actual 
--de la vacuna según las fechas que tenga registradas

-- SELECT NVL(SomeNullableField, 'If null, this value') FROM SomeTable
-- Cuando se ingrese el nombre se debe ingresar como %nombre%

CREATE OR REPLACE PROCEDURE reporte_1(rep_cursor OUT sys_refcursor, nombre_vacuna_p varchar, fecha_aprobacion_p date) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT aprobf_vac.fecha_F1 ,aprobf_vac.fecha_aprobacion ,
    nombre_vac , nombre_est , aprobf_vac.faseActual() ,
    efectividad_vac , covax_vac 
    FROM vacuna
    JOIN estatus ON pk_estatus_vac = id_est
    WHERE nombre_vac  LIKE  NVL(nombre_vacuna_p, nombre_vac);
    AND aprobf_vac.fecha_aprobacion >= NVL(fecha_aprobacion, aprobf_vac.fecha_aprobacion); 
END;

-- Reporte2

CREATE OR REPLACE PROCEDURE reporte_2(rep_cursor OUT sys_refcursor, nombre_pais_p varchar, fecha_inicio date, fecha_fin date, vacuna_p) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai, nombre_pai, SUM(p.cant_hab.cant_total), covax_pai
   FROM pais
   JOIN pais_ge ON fk_pais_ge = id_pai
   JOIN inventario_vacunas on fk_centro_inv = id_cen
   JOIN vacuna on fk_vacuna_inv = id_vac
   WHERE nombre_pai like NVL(nombre_pais_p, nombre_pai)
   AND nombre_vac = NVL(vacuna_p, nombre_vac)
   GROUP BY 1,2,4;
END;

-- Reporte2 - subreporte 1
-- El tema de las fechas seria algo como "entre estas dos fechas venezuela adquirió esta cantidad de vacunas"
CREATE OR REPLACE PROCEDURE reporte_2_subreporte_1(rep_cursor OUT sys_refcursor, fecha_inicio date, fecha_fin date, pais_p number) IS
BEGIN
   --nombre de la vacuna, cantidad total de vacunas de ese tipo, (cantidad de este tipo/cantidad total )*100
   OPEN repo_cursor
   FOR SELECT nombre_vac, sum(cantidad_dis), (sum(cantidad_dis)/(SELECT sum(cantidad_dis)
                                                                  FROM orden 
                                                                  JOIN distribucion ON n_orden_dis = id_ord
                                                                  JOIN pais ON pais_ord = id_pai
                                                                  WHERE id_pai = pais_p
                                                                  AND f_realizacion_ord >= NVL(fecha_inicio, f_realizacion_ord)
                                                                  AND f_entrega_ord <= NVL(fecha_fin, fecha_entrega_ord))*100)
   FROM orden 
   JOIN distribucion ON n_orden_dis = id_ord
   JOIN vacuna ON vacuna_dis = id_vac
   JOIN pais ON pais_ord = id_pai
   WHERE id_pai = pais_p
   AND f_realizacion_ord >= NVL(fecha_inicio, f_realizacion_ord)
   AND f_entrega_ord <= NVL(fecha_fin, fecha_entrega_ord)
   GROUP BY 1;
END;

--Reporte 4

CREATE OR REPLACE PROCEDURE reporte_4(rep_cursor OUT sys_refcursor, nombre_pais_p varchar, porcentage_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai, p.nombre_pai
   FROM pais
   WHERE nombre_pai LIKE NVL(nombre_pais_p, nombre_pai);
END;

--Reporte 4 subreporte 1

CREATE OR REPLACE PROCEDURE reporte_4_subreporte_1(rep_cursor OUT sys_refcursor, nombre_pais_p varchar, porcentage_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai, p.nombre_pai
   FROM pais
   WHERE nombre_pai LIKE NVL(nombre_pais_p, nombre_pai);
END;