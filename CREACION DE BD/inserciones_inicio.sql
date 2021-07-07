--ALGUNAS INSERCIONES DESORDENADAS

INSERT INTO EFECTO_SECUNDARIO VALUES (DEFAULT,'fiebre','Temperatura corporal mayor a 38 grados',0.3);
INSERT INTO VAC_EFEC VALUES (1,1);
INSERT INTO PAIS VALUES (DEFAULT,'Venezuela');
INSERT INTO CENTRO_VAC VALUES (DEFAULT,'CDI Piedra Azul',100,1);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'niños', 0,18,0.01);
INSERT INTO PAIS_GE VALUES (1,1);
INSERT INTO JORNADA_VAC VALUES (CURRENT_DATE,100,100,1,1,1,1); --TIENE TRIGGER

--ESTATUS
INSERT INTO ESTATUS VALUES(0,'FASE 0', 'La vacuna se encuentra en I+D');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE I', 'Se prueban nuevos medicamentos en grupos pequeños de personas, para evaluar rangos de dosis seguras e identificar efectos secundarios');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE II', 'Se amplía el grupo de personas en las que se prueba, para seguir identificando efectos adversos');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE III', 'Se extienden a poblaciones más grandes y en diferentes regiones y países');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE IV', 'Se crece la población en la que se hace la prueba y se mantiene por un periodo de tiempo más largo');

--VACUNAS
INSERT INTO VACUNA VALUES (DEFAULT,'Comirnaty',0,95,16*2,2,'Y',-4,'No agitar.',f_fases(NULL,NULL,NULL,NULL)); --La Pfizer
INSERT INTO VACUNA VALUES (DEFAULT,'Janssen',0,96,9,1,'Y',-15,'No exponer a la luz directa del sol.',f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Johnson and Johnson',0,91.6,9,1,'Y',-8,'No debe almacenarse congelada.',f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'AstraZeneca',0,92,3*2,2,'Y',-8,'No conservar en congelador.',f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Moderna',0,91.6,21*2,2,'Y',-20,'No volver a congelar despues de descongelada.',f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'CoronaVac',0,91.6,25*2,2,'Y',-8,'No exponer a la luz directa del sol.',f_fases(NULL,NULL,NULL,NULL)); --Sinovac
INSERT INTO VACUNA VALUES (DEFAULT,'Sputnik V',0,91.6,9*2,2,'N',-18,'Usar despues de las 2 horas de descongelación.',f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Sinopharm',0,93,30*2,2,'Y',4,'No debe almacenarse congelada.',f_fases(NULL,NULL,NULL,NULL));
INSERT INTO VACUNA VALUES (DEFAULT,'Convidicea',0,95,4,1,'N',3,'No agitar.',f_fases(NULL,NULL,NULL,NULL)); --Cansinp

--DISTRIBUIDORA
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Pfizer-BioNTech');
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Janssen Pharmaceutica'); -- DATO CURIOSO: es una compañía farmacéutica belga filial de la corporación norteamericana Johnson & Johnson
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Johnson and Johnson'); 
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'AstraZeneca');
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Moderna, Inc.');
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Sinovac Biotech');
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Centro Nacional de Investigación de Epidemiología y Microbiología Gamaleya'); --Rusia
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'Corporación Grupo Farmacéutico Nacional Chino');     --Sinopharm
INSERT INTO DISTRIBUIDORA VALUES(DEFAULT,'CanSino Biologics'); 

--VACUNA_DISTRIBUIDORA
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(1,1, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(2,2, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(3,3, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(4,4, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(5,5, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(6,6, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(7,7, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(8,8, 100000000);
INSERT INTO VACUNA_DISTRIBUIDORA VALUES(9,9, 100000000);

--Grupo etario
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Niños', 0, 0.001,14 );
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Jovenes', 15, 0.02,26 );
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Adultos', 27, 0.08,60 );
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Ancianos', 61, 0.20,NULL );

--PAIS 

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

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Al Hayat National Hospital',100000,2, UBICACION(UBICACION.validarLatitud(24.69707260809365),UBICACION.validarLongitud(46.771836790091825),'Arabia Saudita, Riad, Avenida Umar Ibn Abdul Aziz al lado del Banco Nacional Arabe')); --Arabia Saudita
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Al Malha Masjid',100000,2, UBICACION(UBICACION.validarLatitud(24.45972998214987),UBICACION.validarLongitud(39.60431411866359),'Arabia saudita, Medina, Avenida مطبخ الزاهدية'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Al shu AIB',100000,2,UBICACION(UBICACION.validarLatitud(29.985905101348436),UBICACION.validarLongitud(40.21944089706485),'Arabia saudita, Hamburgo, Avenida منتزه النخيل'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro CEMIC',100000,3, UBICACION(UBICACION.validarLatitud(-34.624058764800594),UBICACION.validarLongitud(-58.450884830299636),'Argentina, Buenos Aires, Caballito, Av. Rivadavia 6044 (C.A.B.A.)')); --Argentina
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro Villa Devoto',100000,3, UBICACION(UBICACION.validarLatitud(-34.60025851472542),UBICACION.validarLongitud(-58.50349540747846),'Argentina, Buenos Aires, Emilio Lamarca 3388 esquina Francisco Beiró (C.A.B.A.)'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro Pilar',100000,3, UBICACION(UBICACION.validarLatitud(-33.29148464683466),UBICACION.validarLongitud(-66.3291365234207),'Argentina, Buenos Aires, Av. Juan D. Perón 1500 (Hospital Austral)'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Westmead Hospital',100000,4, UBICACION(UBICACION.validarLatitud(-33.800974999861936),UBICACION.validarLongitud(150.98914146491472),'Australia, Sídney, Av. Darcy frente a la escuela primaria Madre Teresa')); --Australia
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Calvary Public Hospital Bruce',100000,4, UBICACION(UBICACION.validarLatitud(-35.252867201703914),UBICACION.validarLongitud(149.08778306272563),'Australia, Canberra, Aranda,Av Haydon '));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Box Hill Hospital',100000,4,UBICACION(UBICACION.validarLatitud(-37.81334796038165),UBICACION.validarLongitud(145.11850262937645),'Australia, Melbourne, Box hill north, calle arnold junto a Box Hill gardens'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Metropolitano da Lapa',1750000,5, UBICACION(UBICACION.validarLatitud(-23.52881531213897),UBICACION.validarLongitud(-46.69747353152585),'Brasil, São Paulo, Lapa, Av R.Aurélia frente a la direccion Regional de Educación')); --Brasil
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro Medico Julio Adnet',1750000,5, UBICACION(UBICACION.validarLatitud(-15.807738789310502),UBICACION.validarLongitud(-47.90940285022161),'Brasil, Brasilia, Asa sul, Via W5 Sul'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Sofia Feldman',1750000,5,UBICACION(UBICACION.validarLatitud(-19.911723965958657),UBICACION.validarLongitud(-43.960767388720825),'Brasil, Belo Horizonte, São Francisco das Chagas, Av Padre Esutáquio'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Pró-Vida',1750000,5,UBICACION(UBICACION.validarLatitud(-33.800974999861936),UBICACION.validarLongitud(150.98914146491472),'Brasil, Montes Claros, Vila greice, Av Nossa Sra. de Fátima')); 
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital São Rafael',1750000,5, UBICACION(UBICACION.validarLatitud(-12.925375297889433),UBICACION.validarLongitud(-38.430109240624915),'Brasil, Salvador de Bahía, Av São Rafael frente al Jardín botánico de Salvador'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital District D`efoulan',100000,6, UBICACION(UBICACION.validarLatitud(3.834729907968988),UBICACION.validarLongitud(11.506102680664924),'Camerún, Yaundé, OBOBOGO 1438')); --Camerún
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Douala General Hospital',100000,6, UBICACION(UBICACION.validarLatitud(4.064851444686604),UBICACION.validarLongitud(9.758862172655899),'Camerún, Duala, Diagonal al Collège Malangue'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Adamaoua Regional Hospital',100000,6,UBICACION(UBICACION.validarLatitud(7.315972759777115),UBICACION.validarLongitud(13.584392303709702),'Camerún, Ngaoundere, Adamawa'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Toronto General Hospital',100000,7, UBICACION(UBICACION.validarLatitud(43.65980335691164),UBICACION.validarLongitud(-79.3884489421143),'Canadá, Toronto, Avenida universidad frente a Queen`s park')); --Canadá
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'The Ottawa Hospital',100000,7, UBICACION(UBICACION.validarLatitud(45.40314431262979),UBICACION.validarLongitud(-75.6490958370367),'Canadá, Ottawa, Autopista Smyth frente al Faircrest Heights Park'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Vancouver General Hospital',100000,7,UBICACION(UBICACION.validarLatitud(49.262690181925045),UBICACION.validarLongitud(-123.12189638715428),'Canadá, Vancouver, Fairview avenida 12 a dos cuadras del ayuntamiento'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Taoyuan Park',3500000,8, UBICACION(UBICACION.validarLatitud(39.82761719880017),UBICACION.validarLongitud(116.38483107065849),'China, Pekin, Gaozhuangzi, Autopista Huaifang')); --China
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Yongshiying Country Park',3500000,8, UBICACION(UBICACION.validarLatitud(40.038527776582306),UBICACION.validarLongitud(116.44107163564657),'China, Pekin, Qingheyinggcun,Autopista Beiyuan'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Shanghai Binhai Guyuan',3500000,8,UBICACION(UBICACION.validarLatitud(30.857170014651206),UBICACION.validarLongitud(121.7154639954433),'China, Shangai, Qingjian, Avenida Guyuan'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Qingdao Chengyang People`s Hospital',3500000,8,UBICACION(UBICACION.validarLatitud(36.30142841490647),UBICACION.validarLongitud(120.40165900005142),'China, Quigndao, Autopista Changcheng a una cuadra del Masters Golf Club'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Qingdao Municipal Chengyang District People`s Hospital',3500000,8, UBICACION(UBICACION.validarLatitud(36.276052950260805),UBICACION.validarLongitud(120.2402302620307),'China, Quigndao, Chengyang, Autopista 309'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Fuhua Amusement Park',3500000,8,UBICACION(UBICACION.validarLatitud(36.716518077517705),UBICACION.validarLongitud(119.1597640508861),'197 Dongfeng E St, Kuiwen District, Weifang, Shandong, China'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Yuhe Park ',3500000,8,UBICACION(UBICACION.validarLatitud(36.72525545563819),UBICACION.validarLongitud(119.13239478870553),'Beigong E St, Kuiwen District, Weifang, Shandong, China'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'일리아스 주얼리',700000,9, UBICACION(UBICACION.validarLatitud(37.57185030873048),UBICACION.validarLongitud(126.99861176284166),'Corea del Sur, Seoul, Jongno-gu, Inui-dong, 48 2 효성주얼리시티 지하 2층 24호')); --Corea del Sur
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Severance Hospital',700000,9, UBICACION(UBICACION.validarLatitud(37.56253695893253),UBICACION.validarLongitud(126.94086919994999),'50-1 Yonsei-ro, Sinchon-dong, Seodaemun-gu, Seoul, Corea del Sur'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'을재대학교의과대학 교수협의회',700000,9,UBICACION(UBICACION.validarLatitud(36.355663089881844),UBICACION.validarLongitud(127.38188069992682),'95 Dunsanseo-ro, Dunsan-dong, Seo-gu, Daejeon, Corea del Sur'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Cheongju Medical Center',700000,9,UBICACION(UBICACION.validarLatitud(36.64024534026787),UBICACION.validarLongitud(127.47312614903416),'48 Heungdeok-ro, Sajik-dong, 서원구 Cheongju-si, Chungcheongbuk-do, Corea del Sur')); 

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Salvador Allende',25000,10, UBICACION(UBICACION.validarLatitud(23.114294883693898),UBICACION.validarLongitud(-82.37909585303233),'Autopista Calzada del Cerro, La Habana, Cuba')); --Cuba
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Nacional',25000,10, UBICACION(UBICACION.validarLatitud(23.065034376599073),UBICACION.validarLongitud(-82.39378094864789),'Avenida San Francisco, La Habana, Cuba'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Materno De Camaguey',25000,10,UBICACION(UBICACION.validarLatitud(21.389172317143565),UBICACION.validarLongitud(-77.93939620314755),'Carretera central Oestre,Camagüey,Cuba'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'The Good Shepherd Hospital',700000,11, UBICACION(UBICACION.validarLatitud(30.077698435125217),UBICACION.validarLongitud(31.245511471586983),'121 Shoubra، Street، Gesr Shubra, Shubra, Cairo Governorate 11672, Egipto')); -- Egipto
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Children’s Cancer Hospital Egypt',700000,11, UBICACION(UBICACION.validarLatitud(30.02406589907231),UBICACION.validarLongitud(31.237633390509817),'Zeinhom, El-Sayeda Zainab, Gobernación de El Cairo, Egipto'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'The Eye Hospital',700000,11,UBICACION(UBICACION.validarLatitud(31.198431030983844),UBICACION.validarLongitud(29.917105883144288),'243 Ahmed Ismail, Bab Sharqi WA Wabour Al Meyah, Qism Bab Sharqi, Alexandria Governorate, Egipto'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Talkha Central Hospital',700000,11,UBICACION(UBICACION.validarLatitud(31.050153577273168),UBICACION.validarLongitud(31.3721358770355),'طلخا، Mansoura, Dakahlia Governorate, Egipto')); 

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Militar Central',80000,12, UBICACION(UBICACION.validarLatitud(13.72079178269028),UBICACION.validarLongitud(-89.2162585265391),'Avenida Bernal, San Salvador, El Salvador')); --El salvador
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital General del ISSS',80000,12, UBICACION(UBICACION.validarLatitud(13.703664108040932),UBICACION.validarLongitud(-89.2031612993457),'Alameda Juan Pablo II y, 25 Av Norte, San Salvador, El Salvador'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital General Universitario Gregorio Marañón',700000,13, UBICACION(UBICACION.validarLatitud(40.42008384932357),UBICACION.validarLongitud(-3.6714130645234446),'Calle del Dr. Esquerdo, 46, 28007 Madrid, España')); --España
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Clínic de Barcelona',700000,13, UBICACION(UBICACION.validarLatitud(41.39027999982525),UBICACION.validarLongitud(2.152032851544197),'C. de Villarroel, 170, 08036 Barcelona, España'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Clínico Universitario de Valencia',700000,13,UBICACION(UBICACION.validarLatitud(39.47926391967858),UBICACION.validarLongitud(-0.3622055056854497),'Av. de Blasco Ibáñez, 17, 46010 València, Valencia, España'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital General Universitario Morales Meseguer',700000,13,UBICACION(UBICACION.validarLatitud(37.99497951533407),UBICACION.validarLongitud(-1.129535213274778),'Av Marqués de los Vélez, s/n, 30008 Murcia, España'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'George Washington University Hospital',2450000,14, UBICACION(UBICACION.validarLatitud(38.901812758765885),UBICACION.validarLongitud(-77.05072671242297),'900 23rd St NW, Washington, DC 20037, Estados Unidos')); --Estados Unidos
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Kings County Hospital Center',2450000,14, UBICACION(UBICACION.validarLatitud(40.65749040815204),UBICACION.validarLongitud(-73.94300401301932),'451 Clarkson Ave, Brooklyn, NY 11207, Estados Unidos'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'New England Baptist Hospital',2450000,14,UBICACION(UBICACION.validarLatitud(42.33149172955849),UBICACION.validarLongitud(-71.10670745553361),'125 Parker Hill Ave, Boston, MA 02120, Estados Unidos'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'PIH Health Good Samaritan Hospital',2450000,14,UBICACION(UBICACION.validarLatitud(34.05487944263586),UBICACION.validarLongitud(-118.26498583002194),'1225 Wilshire Blvd, Los Angeles, CA 90017, Estados Unidos'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'UCSF Benioff Children`s Hospital - San Francisco',2450000,14, UBICACION(UBICACION.validarLatitud(37.76511315505192),UBICACION.validarLongitud(-122.39030729304734),'1975 4th St, San Francisco, CA 94158, Estados Unidos'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Virginia Mason Hospital and Seattle Medical Center',2450000,14,UBICACION(UBICACION.validarLatitud(36.716518077517705),UBICACION.validarLongitud(119.1597640508861),'1100 9th Ave, Seattle, WA 98101, Estados Unidos'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital de la Pitié-Salpêtrière',700000,15, UBICACION(UBICACION.validarLatitud(48.840365879026955),UBICACION.validarLongitud(2.3631656167761763),'47-83 Boulevard de l`Hôpital, 75013 Paris, Francia')); --Francia
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centre hospitalier Gérard Marchant',700000,15, UBICACION(UBICACION.validarLatitud(43.56056497142068),UBICACION.validarLongitud(1.423813102448802),'134 Route d`Espagne, 31100 Toulouse, Francia'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Center Regional De Marseille',700000,15, UBICACION(UBICACION.validarLatitud(43.29122459769177),UBICACION.validarLongitud(5.393817722526927),'80 Rue Brochier, 13005 Marseille, Francia'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hôpital Pierre Wertheimer',700000,15, UBICACION(UBICACION.validarLatitud(45.749850144095205),UBICACION.validarLongitud(4.8978236776349915),'59 Boulevard Pinel, 69500 Bron, Francia'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hôpital Universitaire La paix',70000,16, UBICACION(UBICACION.validarLatitud(18.55689579122387),UBICACION.validarLongitud(-72.29804277424239),'21b Delmas 33, Port-au-Prince, Haití')); --Haití
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Hospital Notre Dame',70000,16, UBICACION(UBICACION.validarLatitud(18.227799846643133),UBICACION.validarLongitud(-73.754117489097),'32 Route Nationale 2, Arrondissement des Cayes, Haití'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Army Hospital Research And Referral',3500000,17,UBICACION(UBICACION.validarLatitud(28.587310335053044),UBICACION.validarLongitud(77.15801238968842),'Near, Military Hospital Road, Subroto Park, Dhaula Kuan, New Delhi, Delhi 110010, India')); --India
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'AIIMS Hospital',3500000,17,UBICACION(UBICACION.validarLatitud(28.567411569600164),UBICACION.validarLongitud(77.21105575468566),'Ansari Nagar East, Gautam Nagar, Ansari Nagar East, New Delhi, Delhi 110029, India'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Kingsway Hospitals',3500000,17,UBICACION(UBICACION.validarLatitud(21.15598822268801),UBICACION.validarLongitud(79.08497035483104),'Kingsway Near Kasturchand Park, Nagpur, Maharashtra 440001, India'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'PSG Hospitals',3500000,17,UBICACION(UBICACION.validarLatitud(11.02021669414624),UBICACION.validarLongitud(77.00689674812683),'Avinashi Rd, Peelamedu, Coimbatore, Tamil Nadu 641004, India'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Vadamalayan Hospitals',3500000,17, UBICACION(UBICACION.validarLatitud(9.950441704373088),UBICACION.validarLongitud(78.12813650675393),'Chockikulam, 15/1, Vallabh Bhai Rd, Madurai, Tamil Nadu 625002, India'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Aster CMI Hospital',3500000,17,UBICACION(UBICACION.validarLatitud(13.062255252117735),UBICACION.validarLongitud(77.5918865187721),'#43/2, New Airport Road, NH-7, Outer Ring Rd, Sahakar Nagar, Bengaluru, Karnataka 560092, India'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'MIOT International',3500000,17,UBICACION(UBICACION.validarLatitud(13.03163125827468),UBICACION.validarLongitud(80.18706321521917),'4/112, Mount Poonamallee Rd, Sathya Nagar, Manapakkam, Chennai, Tamil Nadu 600089, India'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Landspítali Grensás',35000,18,UBICACION(UBICACION.validarLatitud(64.12617645648984),UBICACION.validarLongitud(-21.88133238337394),'Skálagerði 11, Reykjavík, Islandia')); --Islandia

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Ospedale Generale M.G. Vannini Figlie di San Camillo',700000,19,UBICACION(UBICACION.validarLatitud(41.88088080686826),UBICACION.validarLongitud(12.54285692958975),'Via di Acqua Bullicante, 4, 00177 Roma RM, Italia')); --Italia
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Centro Trasfusionale Ospedaliero - Primo Policlinico di Napoli',700000,19, UBICACION(UBICACION.validarLatitud(40.851131376879366),UBICACION.validarLongitud(14.253355264587015),'Via del Sole, 10, 80138 Napoli NA, Italia'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Policlinico of Milan',700000,19, UBICACION(UBICACION.validarLatitud(45.45962456163846),UBICACION.validarLongitud(9.194949120260109),'Via Francesco Sforza, 35, 20122 Milano MI, Italia'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Ospedale Universitario di Careggi Pronto Soccorso',700000,19, UBICACION(UBICACION.validarLatitud(43.806396008119115),UBICACION.validarLongitud(11.248766183717517),'Viale Gaetano Pieraccini, 50139 Firenze FI, Italia'));

INSERT INTO CENTRO_VAC VALUES(DEFAULT,'IPSFA Los Próceres',100000,20, UBICACION(UBICACION.validarLatitud(10.472838636319286),UBICACION.validarLongitud(-66.89428693533952),'Paseo de Los Próceres, parroquia, Caracas 1010, Distrito Capital')); --venezuela
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Bomberos de Caracas, Estación El Cafetal',100000,20, UBICACION(UBICACION.validarLatitud(10.457963658060933),UBICACION.validarLongitud(-66.82732410732179),'Avenida principal de la Guairita, Miranda, Venezuela'));
INSERT INTO CENTRO_VAC VALUES(DEFAULT,'Ciudad Deportiva Antonio José Sucre',100000,20,UBICACION(UBICACION.validarLatitud(8.606194247726267),UBICACION.validarLongitud(-70.23930586877559),'Avenida Adonai Parra Frente al colegio Andrés Eloy Blanco, Barinas, Venezuela'));


--Suministros iniciales

--Alemania
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),1,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),2,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),3,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),4,7000000,700000,7000000,7000000);

--Arabia Saudita
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),5,1000000,100000,1000000,1000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),6,1000000,100000,1000000,1000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),7,1000000,100000,1000000,1000000);


--Argentina
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),8,500000,50000,500000,500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),9,500000,50000,500000,500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),10,500000,50000,500000,500000);

--Australia
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),11,1000000,100000,1000000,1000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),12,1000000,100000,1000000,1000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),13,1000000,100000,1000000,1000000);

--Brasil
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),14,12250000,1225000,12250000,12250000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),15,12250000,1225000,12250000,12250000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),16,12250000,1225000,12250000,12250000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),17,12250000,1225000,12250000,12250000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),18,12250000,1225000,12250000,12250000);

--Camerun
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),19,500000,50000,500000,500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),20,500000,50000,500000,500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),21,500000,50000,500000,500000);

--Canada
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),22,1000000,100000,1000000,1000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),23,1000000,100000,1000000,1000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),24,1000000,100000,1000000,1000000);

--China
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),25,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),26,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),27,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),28,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),29,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),30,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),31,30000000,3000000,30000000,30000000);

--Corea del Sur
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),32,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),33,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),34,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),35,7000000,700000,7000000,7000000);

--Cuba
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),36,75000,7500,75000,75000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),37,75000,7500,75000,75000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),38,75000,7500,75000,75000);

--Egipto
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),39,4500000,450000,4500000,4500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),40,4500000,450000,4500000,4500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),41,4500000,450000,4500000,4500000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),42,4500000,450000,4500000,4500000);

--El Salvador
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),43,400000,40000,400000,400000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),44,400000,40000,400000,400000);

--España
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),45,5600000,560000,5600000,5600000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),46,5600000,560000,5600000,5600000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),47,5600000,560000,5600000,5600000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),48,5600000,560000,5600000,5600000);

--EEUU
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),49,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),50,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),51,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),52,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),53,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),54,30000000,3000000,30000000,30000000);

--Francia
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),55,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),56,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),57,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),58,7000000,700000,7000000,7000000);

--Haiti
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),59,300000,30000,300000,300000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),60,300000,30000,300000,300000);

--India
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),61,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),62,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),63,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),64,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),65,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),66,30000000,3000000,30000000,30000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),67,30000000,3000000,30000000,30000000);

--Islandia
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),68,400000,40000,400000,400000);

--Italia
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),69,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),70,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),71,7000000,700000,7000000,7000000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),72,7000000,700000,7000000,7000000);

--Venezuela
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),73,300000,30000,300000,300000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),74,300000,30000,300000,300000);
INSERT INTO SUMINISTROS VALUES(TO_DATE('05/03/2020','dd/mm/yyyy'),75,300000,30000,300000,300000);



