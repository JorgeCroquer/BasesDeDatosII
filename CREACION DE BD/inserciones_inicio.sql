--VACUNAS
INSERT INTO VACUNA VALUES (DEFAULT,'Pfizer',1,91.6,2,'Y',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Janssen',1,91.6,0,'Y',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'J&J',1,91.6,1,'Y',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'AstraZeneca',1,91.6,0,'N',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Moderna',1,91.6,2,'Y',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Sinovac',1,91.6,0,'Y',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Sputnik V',1,91.6,2,'N',-8,'no romper',10000000,f_fases(NULL,NULL,NULL,NULL));

--ESTATUS
INSERT INTO ESTATUS VALUES(0,'FASE 0', 'La vacuna se encuentra en I+D');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE I', 'Se prueban nuevos medicamentos en grupos pequeños de personas, para evaluar rangos de dosis seguras e identificar efectos secundarios');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE II', 'Se amplía el grupo de personas en las que se prueba, para seguir identificando efectos adversos');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE III', 'Se extienden a poblaciones más grandes y en diferentes regiones y países');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE IV', 'Se crece la población en la que se hace la prueba y se mantiene por un periodo de tiempo más largo');


--Grupo etario
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Niños', 0, 14, 0.001);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Jovenes', 15, 26, 0.02);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Adultos', 27, 60, 0.08);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Ancianos', 61, NULL, 0.20);


--PAIS (FALTAN)

INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Alemania','EUR', 90, 'Y', 1.47, 5);
EXECUTE guarda_banderas('alemania.png',1);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Arabia Saudita','ASI', 80, 'Y', 2.43, 5);
EXECUTE guarda_banderas('arabiasaudita.png',2);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Argentina','AME', 80, 'Y', 2.21, 2);
EXECUTE guarda_banderas('argentina.png',3);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Australia','OCE', 85, 'Y', 1.72, 5);
EXECUTE guarda_banderas('australia.png',4);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Brasil','AME', 85, 'Y', 1.68, 3);
EXECUTE guarda_banderas('brasil.png',5);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Camerun','AFR', 70, 'Y', 4.32, 2);
EXECUTE guarda_banderas('camerun.png',6);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Canadá','AME', 85, 'Y', 1.48, 5);
EXECUTE guarda_banderas('canada.png',7);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'China','ASI', 90, 'Y', 1.36, 5);
EXECUTE guarda_banderas('china.png',8);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Corea del Sur','ASI', 95, 'Y', 0.95, 5);
EXECUTE guarda_banderas('surcorea.png',9);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Cuba','AME', 70, 'Y', 1.57, 1);
EXECUTE guarda_banderas('cuba.png',10);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Egipto','AFR', 75, 'Y', 3.07, 3);
EXECUTE guarda_banderas('egipto.png',11);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'El Salvador','AME', 80, 'Y', 1.77, 2);
EXECUTE guarda_banderas('salvador.png',12);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'España','EUR', 85, 'Y', 1.24, 4);
EXECUTE guarda_banderas('españa.png',13);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Estados Unidos','AME', 90, 'Y', 1.71, 5);
EXECUTE guarda_banderas('eeuu.png',14);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Francia','EUR', 85, 'Y', 1.84, 5);
EXECUTE guarda_banderas('francia.png',15);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Haití','AME', 70, 'Y', 2.46, 1);
EXECUTE guarda_banderas('haiti.png',16);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'India','ASI', 90, 'Y', 2.08, 5);
EXECUTE guarda_banderas('india.png',17);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Islandia','EUR', 95, 'Y', 1.79, 5);
EXECUTE guarda_banderas('islandia.png',18);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Israel','EUR', 90, 'Y', 3, 5);
EXECUTE guarda_banderas('israel.png',19);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Italia','EUR', 90, 'Y', 1.23, 4);
EXECUTE guarda_banderas('italia.png',20);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Japon','ASI', 95, 'Y', 1.39, 5);
EXECUTE guarda_banderas('japon.png',21);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Mexico','AME', 80, 'Y', 2.04, 3);
EXECUTE guarda_banderas('mexico.png',22);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Nigeria','AFR', 70, 'Y', 5.11, 2);
EXECUTE guarda_banderas('nigeria.png',23);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Nueva Zelanda','OCE', 90, 'Y', 1.67, 5);
EXECUTE guarda_banderas('nuevazelanda.png',24);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Portugal','EUR', 85, 'Y', 1.17, 4);
EXECUTE guarda_banderas('portugal.png',25);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Reino Unido','EUR', 95, 'Y', 1.65, 5);
EXECUTE guarda_banderas('reinounido.png',26);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Rusia','EUR', 90, 'Y', 1.48, 5);
EXECUTE guarda_banderas('rusia.png',27);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Sudáfrica','AFR', 80, 'Y', 2.3, 3);
EXECUTE guarda_banderas('sudafrica.png',28);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Suecia','EUR', 95, 'Y', 1.64, 5);
EXECUTE guarda_banderas('suecia.png',29);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Venezuela','AME', 70, 'Y', 2.2, 1);
EXECUTE guarda_banderas('venezuela.png', 30);



--PAIS_ge

INSERT INTO PAIS_GE VALUES (HABITANTES(11000000,0,0,0),1,3); -- Argentina niños
INSERT INTO PAIS_GE VALUES (HABITANTES(6800000,0,0,0),2,3); -- Argentina jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(17600000,0,0,0),3,3); -- Argentina adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(9300000,0,0,0),4,3); -- Argentina ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(61300000,0,0,0),1,14); -- EEUU niños
INSERT INTO PAIS_GE VALUES (HABITANTES(43100000,0,0,0),2,14); -- EEUU jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(129300000,0,0,0),3,14); -- EEUU adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(95400000,0,0,0),4,14); -- EEUU ancionos

INSERT INTO PAIS_GE VALUES (HABITANTES(8500000,0,0,0),1,30); --Venezuela niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,0,0,0),2,30); --Venezuela jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(13000000,0,0,0),3,30); --Venezuela adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,0,0,0),4,30); --Venezuela ancianos



--Eventos aleatorios
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,1);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,2);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,3);