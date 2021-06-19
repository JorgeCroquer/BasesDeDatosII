--CODIGO DE LA CREACION DEL TDA HABITANTES


CREATE OR REPLACE TYPE HABITANTES AS OBJECT(
    cant_total NUMBER,
    cant_infectados NUMBER,
    cant_recuperados NUMBER,
    cant_fallecidos NUMBER,
)