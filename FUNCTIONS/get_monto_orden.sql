CREATE OR REPLACE FUNCTION get_monto_orden(n_orden orden.id_ord%TYPE, covax NUMBER) RETURN NUMBER AS

    c_distribucion SYS_REFCURSOR;
    r_distribucion distribucion%ROWTYPE;
    precio vacuna.precio_vac%TYPE;
    monto_total NUMBER := 0;
BEGIN

    c_distribucion := get_distribucion_orden(n_orden);

        LOOP 
            FETCH c_distribucion INTO r_distribucion;

            SELECT precio_vac INTO precio FROM VACUNA 
            WHERE  id_vac = r_distribucion.vacuna_dis;
            monto_total := monto_total + (precio*r_distribucion.cantidad_dis);
            EXIT WHEN c_distribucion%NOTFOUND;
        END LOOP;

    CLOSE c_distribucion;
    if (covax = 1) THEN             --SI LA ORDEN ES DE COVAX ENTONCES SUBSIDIA EL 50% DEL MONTO DE LA ORDEN
        RETURN monto_total/2;
    END if;

    RETURN monto_total;
END;
/

