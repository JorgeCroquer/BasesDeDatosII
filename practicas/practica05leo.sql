CREATE TABLE dosis_utilizadas(
    id_uti INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    dosis_utilizadas NUMBER,
    fecha timestamp
);

CREATE TABLE hist_inventario(
    id_inv INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    dosis_ingresadas NUMBER,
    fecha timestamp
);

CREATE TABLE dosis_disponibles(
    id_dis INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    dosis_disponibles NUMBER,
    fecha timestamp
);

CREATE OR REPLACE TRIGGER calcular_disponibles
AFTER INSERT ON dosis_utilizadas
FOR EACH ROW
DECLARE
ultimo_inv hist_inventario%rowtype;
ultima_dis dosis_disponibles%rowtype;
data_found_dis integer := 0; --Bandera para saber si se encontró registro en disponibilidad
data_found_inv integer := 0; --Bandera para saber si se encontró registro en inventario
BEGIN
    --Buscamos el último suministro a inventario
    SELECT *
    INTO ultimo_inv 
    FROM hist_inventario
    WHERE id_inv = (SELECT MAX(id_inv) FROM hist_inventario);
    data_found_inv := 1;
    --Buscamos la ultima disponibilidad registrada
    SELECT *
    INTO ultima_dis
    FROM dosis_disponibles
    WHERE id_dis = (SELECT MAX(id_dis) FROM  dosis_disponibles);
    data_found_dis :=1;
    
    --Chequeamos que se pueda aplicar esa cantidad segun la disponibilidad
    IF(ultima_dis.dosis_disponibles-:new.dosis_utilizadas < 0) THEN
        RAISE_APPLICATION_ERROR(-20202,'No hay suficientes vacunas para aplicar esta cantidad');
    END IF;    
    --Si se recibe un nuevo registro de inventario entre el ultimo registro de 
    --disponibilidad y el registro actual se debe sumar esa cantidad de vacunas a la disponibilidad
    IF (data_found_dis = 1 AND ultimo_inv.fecha >= ultima_dis.fecha) THEN
        dbms_output.put_line('Sumado inventario a disponibildad');
        ultima_dis.dosis_disponibles := ultima_dis.dosis_disponibles + ultimo_inv.dosis_ingresadas;
    END IF;
    
    dbms_output.put_line('Ultima dosis disponible: '|| ultima_dis.dosis_disponibles || ' - Dosis utilizadas: ' || :new.dosis_utilizadas);
    INSERT INTO dosis_disponibles
    VALUES(default,(ultima_dis.dosis_disponibles-:new.dosis_utilizadas),:new.fecha);
    
    EXCEPTION
    WHEN no_data_found THEN 
    BEGIN
        dbms_output.put_line('NO DATA FOUND '|| data_found_dis || ' - ' || data_found_inv);
        IF (data_found_inv = 0)THEN
            --Si no hay inventario lanzamos excepción porque es inocherente vacunas si no habian vacunas en inventario
            RAISE_APPLICATION_ERROR(-20201,'Advertencia: Registro de vacunas utilzadas sin previo registro de inventario recibido');
        ELSE
            --Si no hay una disponibilidad significa que es igual al ultimo suministro de inventario
            dbms_output.put_line('Como no hay ultimo registro disponible...');
            ultima_dis.dosis_disponibles := ultimo_inv.dosis_ingresadas;
            data_found_dis := 0;
        END IF;   
        dbms_output.put_line('Ultima dosis disponible: '|| ultima_dis.dosis_disponibles || ' - Dosis utilizadas: ' || :new.dosis_utilizadas);
        INSERT INTO dosis_disponibles
        VALUES(default,(ultima_dis.dosis_disponibles-:new.dosis_utilizadas),:new.fecha);
    END; 
END;

INSERT INTO hist_inventario VALUES(default,2000,'04-06-2021');

INSERT INTO dosis_utilizadas VALUES(default,100,'05-06-2021');
INSERT INTO dosis_utilizadas VALUES(default,200,'06-06-2021');
INSERT INTO dosis_utilizadas VALUES(default,300,'07-06-2021');

--El campo fecha es timestamp ya que la diferencia de tiempo entre los registros ayuda a que se cumpla la logica del programa correctamente
--Cuando se registra un inventario y se registran dosis utilizadas en la misma fecha a la misma hora ocurre un error, pero con el timestamp
--en un ambiente humano es muy dificil que eso ocurra, obviamente a la hora de ser llevado a producción ese error debe validarse
--pero para efectos de esta practica me parece una solucón bastante buena.
INSERT INTO hist_inventario VALUES(default,2000,'08-06-2021 12:00:00');

INSERT INTO dosis_utilizadas VALUES(default,300,'08-06-2021 12:00:01');
INSERT INTO dosis_utilizadas VALUES(default,100,'09-06-2021');
INSERT INTO dosis_utilizadas VALUES(default,400,'10-06-2021');
INSERT INTO dosis_utilizadas VALUES(default,200,'11-06-2021');

--Intendando ingresar mas vacunas de las disponibles
INSERT INTO dosis_utilizadas VALUES(default,20000,'11-06-2021');

SELECT du.fecha,du.dosis_utilizadas,dd.dosis_disponibles
FROM dosis_utilizadas du 
JOIN dosis_disponibles dd on du.fecha = dd.fecha;
