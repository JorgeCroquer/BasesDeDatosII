--ALGUNAS INSERCIONES DESORDENADAS

INSERT INTO EFECTO_SECUNDARIO VALUES (DEFAULT,'fiebre','Temperatura corporal mayor a 38 grados',0.3);
INSERT INTO VAC_EFEC VALUES (1,1);
INSERT INTO ESTATUS VALUES(DEFAULT,'aprobada', 'aprobada por la OMS');
INSERT INTO VACUNA VALUES (DEFAULT,'sputnik V',1,91.6,2,'Y',-8,'no romper',10000000);
INSERT INTO PAIS VALUES (DEFAULT,'Venezuela');
INSERT INTO CENTRO_VAC VALUES (DEFAULT,'CDI Piedra Azul',100,1);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'niños', 0,18,0.01);
INSERT INTO PAIS_GE VALUES (1,1);
INSERT INTO JORNADA_VAC VALUES (CURRENT_DATE,100,100,1,1,1,1); --TIENE TRIGGER

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

--VACUNAS
--INSERT INTO VACUNA VALUES(id_vac,nombre_vac,estatus_vac, efectividad_vac,dosis_vac,covax_vac,temperatura_vac, instrucciones_vac, suministro_vac,fechas_vac, F_FASES)

INSERT INTO VACUNA VALUES (DEFAULT,'sputnik V',0,91.6,2,'N',-18,'usar despues de las 2 horas de descongelación',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'pfizer',0,95,2,'Y',-4,'no agitar',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'moderna',0,93,2,'Y',-20,'No volver a congelar despues de descongelada',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'aztrazeneca',0,92,2,'Y',2,'no conservar en congelador',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'janssen',0,96,1,'Y',-15,'no exponer a la luz directa del sol',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'sinopharm',0,93,2,'Y',4,'no conservar en congelador',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'coronavac',0,97,2,'Y',4,'no exponer a la luz directa del sol',10000000,f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'cansino',0,95,1,'Y',3,'no agitar',10000000,f_fases(NULL,NULL,NULL,NULL));

--Grupo etario
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Niños', 0, 14, 0.001);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Jovenes', 15, 26, 0.02);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Adultos', 27, 60, 0.08);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Ancianos', 61, NULL, 0.20);


--PAIS (FALTAN)

INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Alemania','EUR', 90, 'Y', 3, 5); 
EXECUTE guarda_banderas('alemania.png',1);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Arabia Saudita','ASI', 80, 'Y', 1.5, 5);
EXECUTE guarda_banderas('arabiasaudita.png',2);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Argentina','AME', 80, 'Y', 2, 2);
EXECUTE guarda_banderas('argentina.png',3);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Australia','OCE', 85, 'Y', 1.2, 5);
EXECUTE guarda_banderas('australia.png',4);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Brasil','AME', 85, 'Y', 1.1, 3);
EXECUTE guarda_banderas('brasil.png',5);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Camerun','AFR', 70, 'Y', 1.6, 2);
EXECUTE guarda_banderas('camerun.png',6);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Canadá','AME', 85, 'Y', 1.3, 5);
EXECUTE guarda_banderas('canada.png',7);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'China','ASI', 90, 'Y', 1, 5);
EXECUTE guarda_banderas('china.png',8);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Corea del Sur','ASI', 95, 'Y', 1.05, 5);
EXECUTE guarda_banderas('surcorea.png',9);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Cuba','AME', 70, 'Y', 1.35, 1);
EXECUTE guarda_banderas('cuba.png',10);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Egipto','AFR', 75, 'Y', 1.1, 3);
EXECUTE guarda_banderas('egipto.png',11);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'El Salvador','AME', 80, 'Y', 1.85, 2);
EXECUTE guarda_banderas('salvador.png',12);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'España','EUR', 85, 'Y', 1.24, 4);
EXECUTE guarda_banderas('españa.png',13);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Estados Unidos','AME', 90, 'Y', 3.2, 5);
EXECUTE guarda_banderas('eeuu.png',14);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Francia','EUR', 85, 'Y', 2.5, 5);
EXECUTE guarda_banderas('francia.png',15);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Haití','AME', 70, 'Y', 1.5, 1);
EXECUTE guarda_banderas('haiti.png',16);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'India','ASI', 90, 'Y', 2.4, 5);
EXECUTE guarda_banderas('india.png',17);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Islandia','EUR', 95, 'Y', 1.55, 5);
EXECUTE guarda_banderas('islandia.png',18);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Italia','EUR', 90, 'Y', 1.15, 4);
EXECUTE guarda_banderas('italia.png',19);
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Venezuela','AME', 70, 'Y', 2.2, 1);
EXECUTE guarda_banderas('venezuela.png', 20);

--Estos no tienen población, se supone que no los vamos a usar pero los dejo por si acaso
INSERT INTO PAIS VALUES (DEFAULT, DEFAULT, 'Israel','EUR', 90, 'Y', 3, 5);
EXECUTE guarda_banderas('israel.png',19);
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

--PAIS_ge
INSERT INTO PAIS_GE VALUES (HABITANTES(8400000,220,0,0),1,1); -- Alemania niños
INSERT INTO PAIS_GE VALUES (HABITANTES(7900000,220,0,0),2,1); -- Alemania jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(37800000,220,0,0),3,1); -- Alemania adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(23900000,220,0,0),4,1); -- Alemania ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(10000000,53,0,0),1,2); -- Arabia saudita  niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5100000,53,0,0),2,2); -- Arabia saudita jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(17500000,53,0,0),3,2); -- Arabia saudita adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(1700000,53,0,0),4,2); -- Arabia saudita ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(11000000,300,0,0),1,3); -- Argentina niños
INSERT INTO PAIS_GE VALUES (HABITANTES(6800000,300,0,0),2,3); -- Argentina jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(17600000,300,0,0),3,3); -- Argentina adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(9300000,300,0,0),4,3); -- Argentina ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(4100000,5,0,0),1,4); -- Australia niños
INSERT INTO PAIS_GE VALUES (HABITANTES(2900000,5,0,0),2,4); -- Australia jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(10900000,5,0,0),3,4); -- Australia adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(5000000,5,0,0),4,4); -- Australia ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(45000000,2800,0,0),1,5); -- Brasil niños
INSERT INTO PAIS_GE VALUES (HABITANTES(33000000,2800,0,0),2,5); -- Brasil jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(100700000,2800,0,0),3,5); -- Brasil adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(27900000,2800,0,0),4,5); -- Brasil ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(10700000,12,0,0),1,6); -- Camerun niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5000000,12,0,0),2,6); -- Camerun jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(8400000,12,0,0),3,6); -- Camerun adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(1200000,12,0,0),4,6); -- Camerun ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(5400000,150,0,0),1,7); -- Canadá niños
INSERT INTO PAIS_GE VALUES (HABITANTES(4100000,150,0,0),2,7); -- Canadá jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(16200000,150,0,0),3,7); -- Canadá adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(9300000,150,0,0),4,7); -- Canadá ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(238000000,900,0,0),1,8); -- China niños
INSERT INTO PAIS_GE VALUES (HABITANTES(170500000,900,0,0),2,8); -- China jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(741000000,900,0,0),3,8); -- China adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(232000000,900,0,0),4,8); -- China ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(6600000,50,0,0),1,9); -- Corea del sur niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5100000,50,0,0),2,9); -- Corea del sur jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(26900000,50,0,0),3,9); -- Corea del sur adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(11300000,50,0,0),4,9); -- Corea del sur ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(1800000,15,0,0),1,10); -- Cuba niños
INSERT INTO PAIS_GE VALUES (HABITANTES(1200000,15,0,0),2,10); -- Cuba jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,15,0,0),3,10); -- Cuba adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(2300000,15,0,0),4,10); -- Cuba ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(33000000,70,0,0),1,11); -- Egipto niños
INSERT INTO PAIS_GE VALUES (HABITANTES(18500000,70,0,0),2,11); -- Egipto jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(40400000,70,0,0),3,11); -- Egipto adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(7000000,70,0,0),4,11); -- Egipto ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(1500000,5,0,0),1,12); -- El salvador niños
INSERT INTO PAIS_GE VALUES (HABITANTES(1200000,5,0,0),2,12); -- El salvador jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(2600000,5,0,0),3,12); -- El salvador adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(700000,5,0,0),4,12); -- El salvador ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(7400000,450,0,0),1,13); -- España niños
INSERT INTO PAIS_GE VALUES (HABITANTES(4700000,450,0,0),2,13); -- España jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(24700000,450,0,0),3,13); -- España adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(12000000,450,0,0),4,13); -- España ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(61300000,575,0,0),1,14); -- EEUU niños
INSERT INTO PAIS_GE VALUES (HABITANTES(43100000,575,0,0),2,14); -- EEUU jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(129300000,575,0,0),3,14); -- EEUU adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(95400000,575,0,0),4,14); -- EEUU ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(12300000,700,0,0),1,15); -- Francia niños
INSERT INTO PAIS_GE VALUES (HABITANTES(7800000,700,0,0),2,15); -- Francia jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(29200000,700,0,0),3,15); -- Francia adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(17700000,700,0,0),4,15); -- Francia ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(2400000,3,0,0),1,16); -- Haití niños
INSERT INTO PAIS_GE VALUES (HABITANTES(2200000,3,0,0),2,16); -- Haití jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(4200000,3,0,0),3,16); -- Haití adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(300000,3,0,0),4,16); -- Haití ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(349000000,3000,0,0),1,17); -- India niños
INSERT INTO PAIS_GE VALUES (HABITANTES(230000000,3000,0,0),2,17); -- India jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(584000000,3000,0,0),3,17); -- India adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(131800000,3000,0,0),4,17); -- India ancianos

-- Dato curioso la poblacion total de islandia es 343 518
--Islandía es un pais pequeño ubicado al notre, entre inglaterra y groenlandia
INSERT INTO PAIS_GE VALUES (HABITANTES(70000,1,0,0),1,18); -- Islandia niños
INSERT INTO PAIS_GE VALUES (HABITANTES(45400,1,0,0),2,18); -- Islandia jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(156800,1,0,0),3,18); -- Islandia adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(71000,1,0,0),4,18); -- Islandia ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(8400000,1150,0,0),1,19); -- Italia niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5800000,1150,0,0),2,19); -- Italia jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(30000000,1150,0,0),3,19); -- Italia adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(16000000,1150,0,0),4,19); -- Italia ancianos

INSERT INTO PAIS_GE VALUES (HABITANTES(8500000,35,0,0),1,20); --Venezuela niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,35,0,0),2,20); --Venezuela jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(13000000,35,0,0),3,20); --Venezuela adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,35,0,0),4,20); --Venezuela ancianos

--Eventos aleatorios
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,1);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,2);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,3);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,4);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,5);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,6);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,7);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,8);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,9);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,10);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,11);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,12);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,13);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,14);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,15);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,16);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,17);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,18);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,19);
INSERT INTO eventos_aleatorios VALUES (DEFAULT, 'Cuarentena', 'CUARENTENA', 'Las personas del pais deben aislarse socialmente',NULL,50,'Y',NULL,NULL,NULL,20);

--Centros de Vacunación
-- INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Nombre',capacidad,id pais, UBICACION(UBICACION.validarLatitud(),UBICACION.validarLongitud(),'direcciontextual'))

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Rathaus Schöneberg',700000,1, UBICACION(UBICACION.validarLatitud(52.487588879706664),UBICACION.validarLongitud(13.343324661821699),'Alemania, Berlín, Avenida Martin-Luther junto al parque Rudolph Wilde')); --Alemania
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Olympiapark',700000,1, UBICACION(UBICACION.validarLatitud(48.19270005279563),UBICACION.validarLongitud(11.545147464409),'Alemania, Múnich, Autopista Georg-BReuchle-Ring al noreste del cementerio Westfriedhof'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Planten un Blomen',700000,1, UBICACION(UBICACION.validarLatitud(53.56088212133053),UBICACION.validarLongitud(9.982175996473462),'Alemania, Hamburgo, Autopista Edmund Siemers Alee frente a la universidad de hamburgo'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Westfalenpark Eingang Blütengärten',700000,1, UBICACION(UBICACION.validarLatitud(51.49395284476907),UBICACION.validarLongitud(7.471306596725039),'Alemania, Dortmund,Avenida Ander Buschmühle'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Al Hayat National Hospital',70000,2, UBICACION(UBICACION.validarLatitud(24.69707260809365),UBICACION.validarLongitud(46.771836790091825),'Arabia Saudita, Riad, Avenida Umar Ibn Abdul Aziz al lado del Banco Nacional Arabe')); --Arabia Saudita
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Al Malha Masjid',70000,2, UBICACION(UBICACION.validarLatitud(24.45972998214987),UBICACION.validarLongitud(39.60431411866359),'Arabia saudita, Medina, Avenida مطبخ الزاهدية'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Al shu AIB',70000,2,UBICACION(UBICACION.validarLatitud(29.985905101348436),UBICACION.validarLongitud(40.21944089706485),'Arabia saudita, Hamburgo, Avenida منتزه النخيل'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro CEMIC',700000,1, UBICACION(UBICACION.validarLatitud(-34.624058764800594),UBICACION.validarLongitud(-58.450884830299636),'Argentina, Buenos Aires, Caballito, Av. Rivadavia 6044 (C.A.B.A.)')); --Argentina
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro Villa Devoto',700000,1, UBICACION(UBICACION.validarLatitud(-34.60025851472542),UBICACION.validarLongitud(-58.50349540747846),'Argentina, Buenos Aires, Emilio Lamarca 3388 esquina Francisco Beiró (C.A.B.A.)'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro Pilar',700000,1, UBICACION(UBICACION.validarLatitud(-33.29148464683466),UBICACION.validarLongitud(-66.3291365234207),'Argentina, Buenos Aires, Av. Juan D. Perón 1500 (Hospital Austral)'));






