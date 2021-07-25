ALTER SESSION SET "_ORACLE_SCRIPT"= TRUE;
--Por razones que desconozco para poder ejecutar los comandos de crear rol primero hay que hacer este

CREATE ROLE encargado_centros;
CREATE ROLE encargado_nacional;
CREATE ROLE encargado_vacunas;
CREATE ROLE Cliente;

GRANT CREATE SESSION TO public;
GRANT SELECT, INSERT, UPDATE, DELETE ON inventario_vac TO encargado_centros;
GRANT SELECT, INSERT, UPDATE, DELETE ON jornada_vac TO encargado_centros;
GRANT SELECT, INSERT, UPDATE, DELETE ON inventario_vac TO encargado_centros;
GRANT SELECT, INSERT, UPDATE, DELETE ON jv_efec TO encargado_centros;
GRANT SELECT, INSERT, UPDATE, DELETE ON suministros TO encargado_centros;
GRANT SELECT ON pais TO encargado_centros;
GRANT SELECT ON centro_vac TO encargado_centros;
GRANT SELECT ON vacuna TO encargado_centros;
GRANT SELECT ON efecto_secundario TO encargado_centros;
GRANT SELECT ON vac_efec TO encargado_centros;

GRANT SELECT, INSERT, UPDATE, DELETE ON pais TO encargado_nacional;
GRANT SELECT, INSERT, UPDATE, DELETE ON centro_vac TO encargado_nacional;
GRANT SELECT ON inventario_vac TO encargado_nacional;
GRANT SELECT ON jornada_vac TO encargado_nacional;
GRANT SELECT ON jv_efec TO encargado_nacional;
GRANT SELECT ON suministros TO encargado_nacional;

GRANT SELECT, INSERT, UPDATE, DELETE ON vacuna TO encargado_vacunas;
GRANT SELECT, INSERT, UPDATE, DELETE ON efecto_secundario TO encargado_vacunas;
GRANT SELECT, INSERT, UPDATE, DELETE ON vac_efec TO encargado_vacunas;

GRANT SELECT ON pais TO Cliente;
GRANT SELECT ON centro_vac TO Cliente;
GRANT SELECT ON inventario_vac TO Cliente;
GRANT SELECT ON jornada_vac TO Cliente;
GRANT SELECT ON jv_efec TO Cliente;
GRANT SELECT ON suministros TO Cliente;
GRANT SELECT ON vacuna TO Cliente;
GRANT SELECT ON efecto_secundario TO Cliente;
GRANT SELECT ON vac_efec TO Cliente;

GRANT EXECUTE ON JORGE.UBICACION TO encargado_centros;
GRANT EXECUTE ON JORGE.F_FASES TO encargado_centros;
GRANT EXECUTE ON JORGE.UBICACION TO encargado_nacional;
GRANT EXECUTE ON JORGE.F_FASES TO encargado_nacional;
GRANT EXECUTE ON JORGE.UBICACION TO encargado_vacunas;
GRANT EXECUTE ON JORGE.F_FASES TO encargado_vacunas;
GRANT EXECUTE ON JORGE.UBICACION TO cliente;
GRANT EXECUTE ON JORGE.F_FASES TO cliente;

CREATE USER Encargado_centros_1 IDENTIFIED BY BASES;
CREATE USER Encargado_nacional_1 IDENTIFIED BY BASES;
CREATE USER Encargado_vacunas_1 IDENTIFIED BY BASES;
CREATE USER Cliente_1 IDENTIFIED BY BASES;

GRANT Encargado_centros TO Encargado_centros_1;
GRANT encargado_nacional TO Encargado_nacional_1;
GRANT Encargado_vacunas TO Encargado_vacunas_1;
GRANT Cliente TO Cliente_1;

--Prueba
--Nos logueamos con cliente
SELECT * FROM LEO.PAIS; --Se puede 
UPDATE LEO.PAIS SET nombre_pai = 'Alemono' WHERE id_pai = 1; --Error de privilegios insuficientes