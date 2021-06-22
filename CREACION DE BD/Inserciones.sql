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