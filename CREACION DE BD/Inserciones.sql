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


--ESTATUS
INSERT INTO ESTATUS VALUES(0,'FASE 0', 'La vacuna se encuentra en I+D');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE I', 'Se prueban nuevos medicamentos en grupos pequeños de personas, para evaluar rangos de dosis seguras e identificar efectos secundarios');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE II', 'Se amplía el grupo de personas en las que se prueba, para seguir identificando efectos adversos');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE III', 'Se extienden a poblaciones más grandes y en diferentes regiones y países');
INSERT INTO ESTATUS VALUES(DEFAULT,'FASE IV', 'Se crece la población en la que se hace la prueba y se mantiene por un periodo de tiempo más largo');


--Grupo etario
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'niños',0, 13,0.001);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'jovenes',14, 26,0.02);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Adultos',27, 55,0.08);
INSERT INTO GRUPO_ETARIO VALUES (DEFAULT, 'Ancianos',56,NULL,0.20);


--Pais (FALTAN)
INSERT INTO pais VALUES (DEFAULT, DEFAULT, 'Venezuela', 70, 'Y', 3, 1);
EXECUTE guarda_banderas('venezuela.png', 1);
INSERT INTO pais VALUES (DEFAULT, DEFAULT, 'Argentina', 85, 'Y', 2.8, 2);
EXECUTE guarda_banderas('argentina.png',2);
INSERT INTO pais VALUES (DEFAULT, DEFAULT, 'Estados Unidos', 70, 'Y', 2.3, 5);
EXECUTE guarda_banderas('eeuu.png',3);


--pais_ge
INSERT INTO PAIS_GE VALUES (HABITANTES(8500000,0,0,0),1,1); --Venezuela niños
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,0,0,0),2,1); --Venezuela jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(13000000,0,0,0),3,1); --Venezuela adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(5200000,0,0,0),4,1); --Venezuela ancianos
INSERT INTO PAIS_GE VALUES (HABITANTES(11000000,0,0,0),1,2); -- Argentina niños
INSERT INTO PAIS_GE VALUES (HABITANTES(6800000,0,0,0),2,2); -- Argentina jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(17600000,0,0,0),3,2); -- Argentina adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(9300000,0,0,0),4,2); -- Argentina ancianos
INSERT INTO PAIS_GE VALUES (HABITANTES(61300000,0,0,0),1,3); -- EEUU niños
INSERT INTO PAIS_GE VALUES (HABITANTES(43100000,0,0,0),2,3); -- EEUU jovenes
INSERT INTO PAIS_GE VALUES (HABITANTES(129300000,0,0,0),3,3); -- EEUU adultos
INSERT INTO PAIS_GE VALUES (HABITANTES(95400000,0,0,0),4,3); -- EEUU ancionos