CREATE OR REPLACE PROCEDURE guarda_banderas(nombre_img VARCHAR2, pais NUMBER) IS
    v_temp BLOB; --guarda temporalemte la imagen
    v_bfile BFILE; --busca la imagen en el directorio
BEGIN


    v_bfile := BFILENAME('BANDERAS', nombre_img);
    DBMS_LOB.OPEN(v_bfile,DBMS_LOB.LOB_READONLY);
    dbms_lob.createtemporary(v_temp, true);
    DBMS_LOB.LOADFROMFILE(v_temp,v_bfile, DBMS_LOB.GETLENGTH(v_bfile));
    DBMS_LOB.CLOSE(v_bfile);

    UPDATE pais SET bandera_pai = v_temp WHERE id_pai = pais;
END;
