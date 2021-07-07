-- Reporte1

-- Hay que agregarle un metodo al TDA F_fases para que imprima la fase actual 
--de la vacuna según las fechas que tenga registradas

-- SELECT nvl(SomeNullableField, 'If null, this value') FROM SomeTable
-- Cuando se ingrese el nombre se debe ingresar como %nombre%

create or replace NONEDITIONABLE PROCEDURE reporte_1(rep_cursor OUT sys_refcursor, nombre_vacuna_p varchar, fecha_aprobacion_p date) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT v.fechas_vac.fecha_f1 , v.fechas_vac.fecha_f4 ,
    v.nombre_vac , nombre_est , v.fechas_vac.faseActual() ,
    v.efectividad_vac , v.covax_vac 
    FROM vacuna v
    JOIN estatus ON estatus_vac = id_est
    WHERE nombre_vac  LIKE  nvl(nombre_vacuna_p, nombre_vac)
    AND nvl(v.fechas_vac.fecha_f4,TO_DATE('01-01-2000','dd/mm/yyyy')) >= nvl(fecha_aprobacion_p, nvl(v.fechas_vac.fecha_f4,TO_DATE('01-01-2000','dd/mm/yyyy'))); 
    --NVL dentro de NVL porque el registro puede ser nulo tambien y en ese caso se cambia por una fecha cualquiera
END;

-- Reporte2

create or replace NONEDITIONABLE PROCEDURE reporte_2(rep_cursor OUT sys_refcursor, nombre_pais_p varchar, fecha_inicio date, fecha_fin date, vacuna_p varchar) IS
BEGIN
   If(vacuna_p IS NULL) THEN
      OPEN rep_cursor
      FOR SELECT id_pai,bandera_pai, nombre_pai, get_poblacion(id_pai,'TOTAL'), covax_pai
      FROM pais p
      WHERE nombre_pai like nvl(nombre_pais_p, nombre_pai);
   ELSE
      OPEN rep_cursor
      FOR SELECT id_pai,bandera_pai, nombre_pai, get_poblacion(id_pai,'TOTAL'), covax_pai
      FROM pais p
      WHERE nombre_pai like nvl(nombre_pais_p, nombre_pai)
      AND vacuna_p IN (SELECT distinct(nombre_vac)
                        FROM pais
                        JOIN orden ON pais_ord = id_pai
                        JOIN distribucion ON n_orden_dis = id_ord
                        JOIN vacuna ON vacuna_dis = id_vac
                        WHERE id_pai = p.id_pai
                        );
   END IF;
END;
-- Reporte2 - subreporte 1
-- El tema de las fechas seria algo como "entre estas dos fechas venezuela adquirió esta cantidad de vacunas"
create or replace NONEDITIONABLE PROCEDURE reporte_2_subreporte_1(rep_cursor OUT sys_refcursor, fecha_inicio date, fecha_fin date, pais_p number) IS
BEGIN
   --nombre de la vacuna, cantidad total de vacunas de ese tipo, (cantidad de este tipo/cantidad total )*100
   OPEN rep_cursor
   FOR SELECT nombre_vac, sum(cantidad_dis), (sum(cantidad_dis)/(SELECT sum(cantidad_dis)
                                                                  FROM orden 
                                                                  JOIN distribucion ON n_orden_dis = id_ord
                                                                  JOIN pais ON pais_ord = id_pai
                                                                  WHERE id_pai = pais_p
                                                                  AND f_realizacion_ord >= nvl(fecha_inicio, f_realizacion_ord)
                                                                  AND f_entrega_ord <= nvl(fecha_fin, f_entrega_ord))*100)
   FROM orden 
   JOIN distribucion ON n_orden_dis = id_ord
   JOIN vacuna ON vacuna_dis = id_vac
   JOIN pais ON pais_ord = id_pai
   WHERE id_pai = pais_p
   AND f_realizacion_ord >= nvl(fecha_inicio, f_realizacion_ord)
   AND f_entrega_ord <= nvl(fecha_fin, f_entrega_ord)
   GROUP BY nombre_vac;
END;

--Reporte 3
--Informacion sobre ordenes a covax
--Si un pais tiene varias ordenes a covax saldrán varias filas de ese pais, relacionada a cada orden
--Si hay varios pagos relacionados a la orden se totalizan los valores y en fecha aparece la fecha del último pago
--Covax es el distribuidor 1;
--Hay que agregar en el reporteador que en este caso todos los paises van a poder disponer de 50% de vacunas

create or replace NONEDITIONABLE PROCEDURE reporte_3(rep_cursor OUT sys_refcursor, pais_p varchar, estatus_p varchar) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT p2.bandera_pai, r.id_pai, id_ord, r.nombre_pai, estatus_ord, TO_CHAR(f_estimada_ord,'dd/mm/yy'), TO_CHAR(fecha_pago,'dd/mm/yy'), Monto_pagado, porcentaje_pagado, monto_restante, porcentaje_restante 
    FROM (SELECT p1.id_pai, id_ord, p1.nombre_pai, estatus_ord, f_estimada_ord, max(fecha_pag) as fecha_pago, sum(monto_pag) as Monto_pagado, (sum(monto_pag)/monto_ord)*100 as porcentaje_pagado, (monto_ord - sum(monto_pag)) as monto_restante, (100 - (sum(monto_pag)/monto_ord)*100) as porcentaje_restante 
            FROM pais p1
            JOIN orden ON pais_ord = p1.id_pai
            JOIN pago ON n_orden_pag = id_ord
            WHERE covax_pai = 'Y' --El pais debe pertenecer a covax
            AND distribuidora_ord =  10 --La distribuidora de la orden debe ser covax
            AND nombre_pai LIKE nvl(pais_p, nombre_pai)
            AND estatus_ord LIKE nvl(estatus_p, estatus_ord)
            GROUP BY p1.id_pai, id_ord, p1.nombre_pai,estatus_ord,f_estimada_ord, monto_ord) r
    JOIN pais p2 ON p2.id_pai = r.id_pai;
END;

--Reporte 3 - subreporte 1
create or replace NONEDITIONABLE PROCEDURE reporte_3_subreporte_1(rep_cursor OUT sys_refcursor, orden_p number) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT nombre_vac, (cantidad_dis/(SELECT SUM(cantidad_dis)
                                          FROM distribucion
                                          WHERE n_orden_dis = o.id_ord   
                                          )
    )*100 as porcentaje_incluido
    FROM orden o
    JOIN distribucion on n_orden_dis =  o.id_ord  
    JOIN vacuna on vacuna_dis = id_vac
    WHERE o.id_ord = orden_p; --Que esté relacionado con la orden de la que se llama
END;

--Reporte 3 - subreporte 2
create or replace NONEDITIONABLE PROCEDURE reporte_3_subreporte_2(rep_cursor OUT sys_refcursor, pais_p number) IS
BEGIN
    OPEN rep_cursor
    FOR SELECT tipo_res, nombre_vac, nvl(descripcion_res,'')
    FROM restricciones
    JOIN vacuna on vacuna_res = id_vac
    WHERE pais_res = pais_p; -- Que esté relacionada con el pais del que se llama
END;

--Reporte 4
--Aquí se va a parametrizar por los porcentajes de los grupos etarios
-- id's Ancianos = 4, adultos = 3, jovenes =2, niños = 1
create or replace NONEDITIONABLE PROCEDURE reporte_4(rep_cursor OUT sys_refcursor, 
nombre_pais_p varchar, 
ancianos_p number,
adultos_p number,
jovenes_p number,
niños_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai,id_pai, nombre_pai 
   FROM pais 
   WHERE nombre_pai LIKE nvl(nombre_pais_p, nombre_pai)
   AND nvl(ancianos_p, 0 )<= ((get_poblacion_e(id_pai,4)/get_poblacion(id_pai,'TOTAL'))*100)
   AND nvl(adultos_p, 0 ) <= ((get_poblacion_e(id_pai,3)/get_poblacion(id_pai,'TOTAL'))*100)
   AND nvl(jovenes_p, 0 )<=  ((get_poblacion_e(id_pai,2)/get_poblacion(id_pai,'TOTAL'))*100)
   AND nvl(niños_p, 0 ) <=  ((get_poblacion_e(id_pai,1)/get_poblacion(id_pai,'TOTAL'))*100);
END;

--Reporte 4 - subreporte 1
create or replace NONEDITIONABLE PROCEDURE reporte_4_subreporte_1(rep_cursor OUT sys_refcursor, pais_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT  ge.cant_hab_pge.cant_total, nombre_ge, edad_inferior, edad_superior
   FROM pais_ge ge 
   JOIN grupo_etario ON grupo_etario_pge = id_ge
   WHERE pais_pge = pais_p;
END;

--Reporte 4 - subreporte 2

create or replace NONEDITIONABLE PROCEDURE reporte_4_subreporte_2(rep_cursor OUT sys_refcursor, pais_p number ) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT  TRUNC((get_poblacion_e(pais_p,id_ge)/get_poblacion(pais_p,'TOTAL'))*100,2) as porcentaje_incluido, 
   nombre_ge, edad_inferior,edad_superior
   FROM pais_ge ge
   JOIN grupo_etario ON grupo_etario_pge = id_ge
   WHERE pais_p = pais_pge;
END;

--Reporte 5 

create or replace NONEDITIONABLE PROCEDURE reporte_5(rep_cursor OUT sys_refcursor, pais_p varchar, vacunados_p number, vacuna_p varchar ) IS
BEGIN
   OPEN rep_cursor
   FOR 
   SELECT p2.bandera_pai, r.nombre_pai, nombre_vac, cant_habitantes, cantidad_vacunados, porcentaje_vacunado
   FROM ( SELECT p1.id_pai, p1.nombre_pai, nombre_vac, get_poblacion(id_pai,'TOTAL') as cant_habitantes, SUM(cantidad_pri_jv) as cantidad_vacunados, 
   TRUNC((SUM(cantidad_pri_jv)/get_poblacion(id_pai,'TOTAL'))*100,2) as porcentaje_vacunado
   FROM pais p1
   JOIN pais_ge ge ON pais_pge = id_pai
   JOIN jornada_vac ON grupo_etario_jv = grupo_etario_pge AND pais_jv = pais_pge
   JOIN vacuna ON vacuna_jv = id_vac
   WHERE nombre_pai LIKE nvl(pais_p, nombre_pai)
   AND nombre_vac LIKE nvl(vacuna_p, nombre_vac)
   GROUP BY nombre_pai, nombre_vac, id_pai
   HAVING TRUNC((SUM(cantidad_pri_jv)/get_poblacion(id_pai,'TOTAL'))*100,2) >= nvl(vacunados_p,0)
   AND SUM(cantidad_pri_jv) > 0
   ORDER BY nombre_pai) r
   JOIN PAIS p2 ON p2.id_pai = r.id_pai;

END;

--Reporte 6 
create or replace NONEDITIONABLE PROCEDURE reporte_6(rep_cursor OUT sys_refcursor, pais_p varchar, vacunados_p number, fecha_inicio date, fecha_fin date ) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT p2.bandera_pai, r.nombre_pai, TO_CHAR(fecha_i,'dd/mm/yy'), TO_CHAR(fecha_f,'dd/mm/yy'), porcentaje_vacunado
   FROM (SELECT p.nombre_pai, p.id_pai, nvl(fecha_inicio,MIN(fecha_jv)) fecha_i, nvl(fecha_fin,MAX(fecha_jv)) fecha_f,
   TRUNC((SUM(cantidad_pri_jv)/get_poblacion(id_pai,'TOTAL'))*100,2) as porcentaje_vacunado
   FROM pais p
   JOIN pais_ge ge ON pais_pge = id_pai
   JOIN jornada_vac ON grupo_etario_jv = grupo_etario_pge AND pais_jv = pais_pge
   WHERE nombre_pai LIKE nvl(pais_p, nombre_pai)
   AND fecha_jv BETWEEN nvl(fecha_inicio, (SELECT MIN(fecha_jv) FROM JORNADA_VAC WHERE pais_jv = p.id_pai)) 
   AND nvl(fecha_fin,(SELECT MAX(fecha_jv) FROM JORNADA_VAC WHERE pais_jv = p.id_pai))
   GROUP BY nombre_pai,id_pai
   HAVING TRUNC((SUM(cantidad_pri_jv)/get_poblacion(id_pai,'TOTAL'))*100,2) >= nvl(vacunados_p,0)
   ORDER BY nombre_pai) r
   JOIN PAIS p2 ON p2.id_pai = r.id_pai;
END;

--Reporte 7

create or replace NONEDITIONABLE PROCEDURE reporte_7(rep_cursor OUT sys_refcursor, pais_p varchar) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT bandera_pai, nombre_pai, nombre_cen, c.ubicacion.direccion_textual, c.ubicacion.getLatitud(),c.ubicacion.getLongitud() 
   FROM pais
   JOIN centro_vac c ON id_pai = pais_cv
   WHERE nombre_pai LIKE nvl(pais_p, nombre_pai);
END;

--Reporte 7 - subreporte 1
create or replace NONEDITIONABLE PROCEDURE reporte_7_subreporte_1(rep_cursor OUT sys_refcursor, pais_p number, centro_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT nombre_ge, edad_inferior, edad_superior, SUM(cantidad_pri_jv)
   FROM pais
   JOIN centro_vac ON id_pai = pais_cv
   JOIN pais_ge ON pais_pge = id_pai
   JOIN jornada_vac jv1 ON grupo_etario_jv = grupo_etario_pge AND pais_jv = pais_pge
   JOIN grupo_etario ON grupo_etario_pge = id_ge
   WHERE id_pai = pais_p
   AND id_cen = centro_p
   AND fecha_jv  = (SELECT MAX(fecha_jv)
                    FROM jornada_vac jv2
                    WHERE jv2.pais_jv = jv1.pais_jv
                    AND jv2.grupo_etario_jv = jv1.grupo_etario_jv
                    AND jv2.centro_vac_jv = jv1.centro_vac_jv
                    AND jv2.vacuna_jv = jv1.vacuna_jv)
  GROUP BY  nombre_ge, edad_inferior, edad_superior;                
END;

--Reporte 7 - subreporte 2
CREATE OR REPLACE PROCEDURE reporte_7_subreporte_2(rep_cursor OUT sys_refcursor, pais_p number, centro_p number) IS
BEGIN
   OPEN rep_cursor
   FOR SELECT nombre_ge, edad_inferior, edad_superior, (SUM(cantidad_pri_jv)/ge.cant_hab_pge.cant_total)*100 as porcentaje_vacunado
   FROM pais
   JOIN centro_vac ON id_pai = pais_cv
   JOIN pais_ge ge ON pais_pge = id_pai
   JOIN jornada_vac ON grupo_etario_jv = grupo_etario_pge AND pais_jv = pais_pge
   JOIN grupo_etario ON grupo_etario_pge = id_ge
   WHERE id_pai = pais_p
   AND id_cen = centro_p
   GROUP BY 1,2,3
   HAVING fecha_jv = MAX(fecha_jv);
END;