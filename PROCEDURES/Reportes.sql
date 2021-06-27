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
   FOR SELECT bandera_pai, nombre_pai, SUM(p.cantidad_hab_paisge.cant_total), covax_pai
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

--Reporte 3
--Informacion sobre ordenes a covax
--Si un pais tiene varias ordenes a covax saldrán varias filas de ese pais, relacionada a cada orden
--Si hay varios pagos relacionados a la orden se totalizan los valores y en fecha aparece la fecha del último pago
--Covax es el distribuidor 1;
--Hay que agregar en el reporteador que en este caso todos los paises van a poder disponer de 50% de vacunas

CREATE OR REPLACE PROCEDURE reporte_3(rep_cursor OUT sys_refcursor, pais_p varchar, estatus_p varchar) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT bandera_pai, nombre_pai, estatus_ord, f_estimada_ord, max(fecha_pag), sum(monto_pag) as Monto_pagado, (sum(monto_pag)/monto_ord)*100 as porcentaje_pagado, (monto_ord - sum(monto_pag)) as monto_restante, (100 - (sum(monto_pag)/monto_ord)*100) as porcentaje_restante 
    FROM pais
    JOIN orden ON pais_ord = id_pai
    JOIN pago ON n_orden_pag = id_ord
    WHERE covax_pai = 'y'; --El pais debe pertenecer a covax
    WHERE distribuidora_ord =  1; --La distribuidora de la orden debe ser covax
    AND nombre_pai LIKE NVL(pais_p, nombre_pai)
    AND estatus_ord LIKE NVL(estatus_p, estatus_ord)
    GROUP BY 1,2,3,4;
END;

--Reporte 3 - subreporte 1
CREATE OR REPLACE PROCEDURE reporte_3_subreporte_1(rep_cursor OUT sys_refcursor, orden_p number) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT nombre_vac, (cantidad_dis/(SELECT SUM(cantidad_dis)
                                          FROM distribucion
                                          WHERE n_orden_dis = o.id_ord;   
                                          )
    )*100 as porcentaje_incluido
    FROM orden o
    JOIN distribucion on n_orden_dis =  o.id_ord  
    JOIN vacuna on vacuna_dis = id_vac
    WHERE o.id_ord = orden_p; --Que esté relacionado con la orden de la que se llama
END;

--Reporte 3 - subreporte 2
CREATE OR REPLACE PROCEDURE reporte_3_subreporte_2(rep_cursor OUT sys_refcursor, pais_p number) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT tipo_res, nombre_vac, nvl(descripcion_res,'')
    FROM resticciones
    JOIN vacuna on vacuna_res = id_vac
    WHERE pais_res = pais_p -- Que esté relacionada con el pais del que se llama
END;

--Reporte 4
--Aquí se va a parametrizar por los porcentajes de los grupos etarios
-- id's Ancianos = 1, adultos = 2, jovenes =3, niños = 4
CREATE OR REPLACE PROCEDURE reporte_4(rep_cursor OUT sys_refcursor, 
nombre_pais_p varchar, 
ancianos_p number,
adultos_p number,
jovenes_p number,
niños_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai, nombre_pai 
   FROM pais_ge pg
   JOIN grupo_etario ON pg.grupo_etario = id_ge
   JOIN pais ON pg.pais = id_pai
   WHERE nombre_pai LIKE nvl(nombre_pais_p, nombre_pai)
   AND id_ge = 1 AND nvl(ancianos_p, 0 )<= ((cantidad_hab_paisge.cant_total/(SELECT SUM(cantidad_hab_paisge.cant_total)
                                       FROM pais_ge
                                       WHERE pais = pg.pais))*100)
   OR id_ge = 2 AND nvl(adultos_p, 0 )<= ((cantidad_hab_paisge.cant_total/(SELECT SUM(cantidad_hab_paisge.cant_total)
                                       FROM pais_ge
                                       WHERE pais = pg.pais))*100)
   OR id_ge = 3 AND nvl(jovenes_p, 0 )<=  ((cantidad_hab_paisge.cant_total/(SELECT SUM(cantidad_hab_paisge.cant_total)
                                       FROM pais_ge
                                       WHERE pais = pg.pais))*100)
   OR id_ge = 4 AND nvl(niños_p, 0 )<=  ((cantidad_hab_paisge.cant_total/(SELECT SUM(cantidad_hab_paisge.cant_total)
                                       FROM pais_ge
                                       WHERE pais = pg.pais))*100)                                         
END;

--Reporte 4 - subreporte 1
CREATE OR REPLACE PROCEDURE reporte_4_subreporte_1(rep_cursor OUT sys_refcursor, pais_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT  cantidad_hab_paisge.cant_total, nombre_ge, edad_inferior_ge,edad_superior_ge
   FROM pais_ge pg
   JOIN grupo_etario ge ON pg.grupo_etario = id_ge
   WHERE pg.pais = pais_p
END;

--Reporte 4 - subreporte 2

CREATE OR REPLACE PROCEDURE reporte_4_subreporte_2(rep_cursor OUT sys_refcursor, pais_p number ) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT  ((cantidad_hab_paisge.cant_total/(SELECT SUM(cantidad_hab_paisge.cant_total)
                                       FROM pais_ge
                                       WHERE pais = pg.pais))*100), 
   nombre_ge, edad_inferior_ge,edad_superior_ge
   FROM pais_ge pg
   JOIN grupo_etario ON pg.grupo_etario = id_ge
   WHERE pais_p = pg.pais;
END;

--Reporte 5 

CREATE OR REPLACE PROCEDURE reporte_5(rep_cursor OUT sys_refcursor, pais_p varchar, vacunados_p number, vacuna_p varchar ) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT  bandera_pai, nombre_pai, nombre_vac, SUM(cantidad_hab_paisge.cantidad_total) as cantidad_total, SUM(cantidad_pri_jv) as cantidad_vacunados, TRUNC(SUM(cantidad_hab_paisge.cantidad_total)/SUM(cantidad_pri_jv))*100,2) as porcentaje_vacunado
   FROM pais
   JOIN pais_ge ON pais = id_pai
   JOIN jornada_vac ON grupo_etario_jv = grupo_etario_jv AND pais_jv = pais
   JOIN vacuna ON vacuna_jv = id_vac
   WHERE nombre_pai LIKE NVL(pais_p, nombre_pai)
   AND nombre_vac LIKE NVL(vacuna_p, nombre_vac)
   GROUP BY 1,2,3
   HAVING 6 >= NVL(vacunados_p,0);
END;

--Reporte 6 

CREATE OR REPLACE PROCEDURE reporte_6(rep_cursor OUT sys_refcursor, pais_p varchar, vacunados_p number, fecha_inicio date, fecha_fin date ) IS
BEGIN
   OPEN rep_cursor
   -- ((vacunados en la fecha fin - vacunados en la fecha inicio) / cantidad de habitantes)*100
   FOR SELECT  bandera_pai, nombre_pai,NVL(fecha_inicio,MIN(fecha_jv)), NVL(fecha_fin,MAX(fecha_jv)), 
   ((SUM(cantidad_pri_jv) - (SELECT SUM(cantidad_pri_jv)
                              FROM pais
                              JOIN pais_ge ON pais = id_pai
                              JOIN jornada_vac ON grupo_etario_jv = grupo_etario_jv AND pais_jv = pais
                              WHERE id_pai = p.id_pai
                              AND fecha_jv = NVL(fecha_inicio,MIN(fecha_jv));
                              )) /(SELECT SUM(cantidad_hab_paisge.cant_total)
                                 FROM pais_ge
                                 WHERE pais = p.id_pai))*100 as porcentaje_vacunado
   FROM pais p
   JOIN pais_ge ON pais = id_pai
   JOIN jornada_vac ON grupo_etario_jv = grupo_etario_jv AND pais_jv = pais
   WHERE fecha_jv = NVL(fecha_fin,MAX(fecha_jv));
   WHERE nombre_pai LIKE NVL(pais_p, nombre_pai)
   GROUP BY 1,2;
   HAVING 3 >= NVL(vacunados_p,0);
END;

--Reporte 7

CREATE OR REPLACE PROCEDURE reporte_7(rep_cursor OUT sys_refcursor, pais_p varchar) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai, nombre_pai, nombre_cen, ubicacion_cen.ubicacion_textual, --ubicacion_cen.showMap()
   FROM pais
   JOIN centros_vac ON id_pai = pais_cv
   WHERE nombre_pai LIKE NVL(pais_p, nombre_pai);
END;

--Reporte 7 - subreporte 1
CREATE OR REPLACE PROCEDURE reporte_7_subreporte_1(rep_cursor OUT sys_refcursor, pais_p number, centro_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT nombre_ge, edad_inferior_ge, edad_superior_ge, SUM(cantidad_pri_jv)
   FROM pais
   JOIN centros_vac ON id_pai = pais_cv
   JOIN pais_ge ge ON ge.pais = id_pai
   JOIN jornada_vacunas ON grupo_etario_jv = ge.grupo_etario AND pais_jv = ge.pais
   JOIN grupo_etario ON ge.grupo_etario = id_ge
   WHERE id_pai = pais_p
   AND id_cen = centro_p
   GROUP BY 1,2,3
   HAVING fecha_jv = MAX(fecha_jv);
END;

--Reporte 7 - subreporte 2
CREATE OR REPLACE PROCEDURE reporte_7_subreporte_2(rep_cursor OUT sys_refcursor, pais_p number, centro_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT nombre_ge, edad_inferior_ge, edad_superior_ge, (SUM(cantidad_pri_jv)/ge.cantidad_hab_paisge.cant_total)*100 as porcentaje_vacunado
   FROM pais
   JOIN centros_vac ON id_pai = pais_cv
   JOIN pais_ge ge ON ge.pais = id_pai
   JOIN jornada_vacunas ON grupo_etario_jv = ge.grupo_etario AND pais_jv = ge.pais
   JOIN grupo_etario ON ge.grupo_etario = id_ge
   WHERE id_pai = pais_p
   AND id_cen = centro_p
   GROUP BY 1,2,3
   HAVING fecha_jv = MAX(fecha_jv);
END;