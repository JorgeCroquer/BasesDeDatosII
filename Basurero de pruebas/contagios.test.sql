exec Restaurar_Sim;
commit;
exec simulacion;
SELECT p.nombre_pai AS pais, SUM(pge.cant_hab_pge.cant_infectados) AS infectados, SUM(pge.cant_hab_pge.cant_recuperados) AS recuperados, SUM(pge.cant_hab_pge.cant_fallecidos) AS fallecidos 
FROM PAIS_GE pge JOIN PAIS p ON pge.pais_pge = p.id_pai
GROUP BY p.nombre_pai;