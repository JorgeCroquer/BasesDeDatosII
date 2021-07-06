CREATE OR REPLACE PROCEDURE registro_pago (n_orden orden.id_ord%TYPE, fecha_actual DATE, monto orden.monto_ord%TYPE) AS
    
    total NUMBER := TRUNC((monto*(dbms_random.value(3,7))/10), 2);
BEGIN
    INSERT INTO PAGO VALUES (DEFAULT, fecha_actual, total , n_orden);
END;
/