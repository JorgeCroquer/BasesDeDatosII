--Esto es para las banderas
--Creo que solo se necesita para guardar por primera vez una bandera
--No va a funcionar en sus PC por la ruta del directorio

CREATE OR REPLACE DIRECTORY banderas 
AS 'D:\Documentos\UCAB\Semestre Abr-Ago 2020-2021\Sistemas de Bases de Datos II\Proyecto\Proyecto Source\Banderas';


--Esto hay que hacerlo desde otro usuario. Yo me conecté con el usuario SYSTEM
--A system hay que cambiarle la contraseña por default
--ver https://www.thegeekdiary.com/how-to-change-sys-and-system-passwords-in-oracle-database/
GRANT READ, WRITE ON DIRECTORY banderas TO jorge;