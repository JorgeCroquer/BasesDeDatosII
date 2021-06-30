CREATE OR REPLACE PROCEDURE RESTAURAR_SIM IS
    tabla VARCHAR2(12) := 'H_HABITANTES';

BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || tabla;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 220, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 1; 
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 53, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 2;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 300, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 3;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 5, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 4; 
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 2800, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 5;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 12, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 6;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 150, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 7;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 900, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 8;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 50, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 9;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 15, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 10;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 70, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 11;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 5, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 12;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 450, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 13;
    UPDATE PAIS_GE pg SET pg.cant_hab_pge.cant_infectados = 1, pg.cant_hab_pge.cant_recuperados = 0, pg.cant_hab_pge.cant_fallecidos = 0 WHERE pg.pais_pge = 18; 
    UPDATE EVENTOS_ALEATORIOS SET habilitado_eve = 'Y' WHERE tipo_eve = 'CUARENTENA';
    UPDATE PAIS SET tasa_repro_pai = 3 WHERE id_pai = 1;
    UPDATE PAIS SET tasa_repro_pai = 1.5 WHERE id_pai = 2;
    UPDATE PAIS SET tasa_repro_pai = 2 WHERE id_pai = 3;
    UPDATE PAIS SET tasa_repro_pai = 1.2 WHERE id_pai = 4;
    UPDATE PAIS SET tasa_repro_pai = 1.1 WHERE id_pai = 5;
    UPDATE PAIS SET tasa_repro_pai = 1.6 WHERE id_pai = 6;
    UPDATE PAIS SET tasa_repro_pai = 1.3 WHERE id_pai = 7;
    UPDATE PAIS SET tasa_repro_pai = 1 WHERE id_pai = 8;
    UPDATE PAIS SET tasa_repro_pai = 1.05 WHERE id_pai = 9;
    UPDATE PAIS SET tasa_repro_pai = 1.35 WHERE id_pai = 10;
    UPDATE PAIS SET tasa_repro_pai = 1.1 WHERE id_pai = 11;
    UPDATE PAIS SET tasa_repro_pai = 1.85 WHERE id_pai = 12;
    UPDATE PAIS SET tasa_repro_pai = 1.45 WHERE id_pai = 13;
    UPDATE PAIS SET tasa_repro_pai = 1.55 WHERE id_pai = 18;
END;