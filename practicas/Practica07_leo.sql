--Creacion de db link hacia la pc de jorge croquer
--Jorge tiene utiliza un ddns para su ip pública
CREATE PUBLIC DATABASE LINK "JORGE"
CONNECT TO "JORGE" IDENTIFIED BY "221099"
USING '(DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = croquer.ddns.net)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orcl)
    )
  )';

--Creacion de db link hacia la pc de iliana
--Utilizamos directamente su ip pública
CREATE PUBLIC DATABASE LINK "ILIANA"
CONNECT TO "ILIANA" IDENTIFIED BY "123"
USING '(DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 201.211.161.169)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XE)
    )
  )';

--Creamos la tabla que forma parte de la segmentacion horizontal    
CREATE TABLE ESTUDIANTE(
    cedula number,
    nombre varchar(200)
);

INSERT INTO ESTUDIANTE VALUES(27806456,'Jose Contreras');
INSERT INTO ESTUDIANTE VALUES(27086047,'Jorge Croquer');
INSERT INTO ESTUDIANTE VALUES(27107153,'Jesus Soares');

--Comprobamos que las tablas de los equipos remotos tengan datos y esten activas
SELECT * FROM ESTUDIANTE_EQUIPO@ILIANA; 
SELECT * FROM ESTUDIANTE@JORGE;

--Seleccionamos todos los datos de la segmentacion horizontal y vertical
SELECT el.*, ei.* 
FROM ESTUDIANTE el
INNER JOIN ESTUDIANTE_EQUIPO@ILIANA ei ON el.cedula = ei.cedula
UNION ALL
SELECT ej.*, ei.* 
FROM ESTUDIANTE@JORGE ej
INNER JOIN ESTUDIANTE_EQUIPO@ILIANA ei ON ej.cedula = ei.cedula;

--Modificamos un poco el query para no repetir columnas
SELECT el.cedula, el.nombre, ei.equipo 
FROM ESTUDIANTE el
INNER JOIN ESTUDIANTE_EQUIPO@ILIANA ei ON el.cedula = ei.cedula
UNION ALL
SELECT ej.cedula, ej.nombre, ei.equipo 
FROM ESTUDIANTE@JORGE ej
INNER JOIN ESTUDIANTE_EQUIPO@ILIANA ei ON ej.cedula = ei.cedula;