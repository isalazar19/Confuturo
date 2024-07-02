CREATE OR REPLACE FUNCTION "F_BUSCA_BEN_REL_ASEG"
                          (pe_ben_beneficiario IN BENEFICIARIOS.ben_beneficiario%TYPE,
                           pe_ben_relacion     IN BENEFICIARIOS.ben_relacion%TYPE)
RETURN NUMBER
IS
  w_rel_aseg NUMBER := 0;
  w_sexo     VARCHAR2(1);

BEGIN
  DBMS_APPLICATION_INFO.SET_MODULE(module_name => 'f_busca_ben_rel',action_name => ' ');
  DBMS_APPLICATION_INFO.SET_ACTION(action_name => ' ');
   w_rel_aseg := 0;
   --
   SELECT nat_sexo
   INTO   w_sexo
   FROM   PENSIONES.PERSNAT
   WHERE  nat_id = pe_ben_beneficiario;
   --
   IF SQLCODE = 0 THEN
      w_rel_aseg := pe_ben_relacion;
      IF pe_ben_relacion = 1 OR pe_ben_relacion = 2 THEN
         w_rel_aseg := pe_ben_relacion;
      ELSE
         IF pe_ben_relacion = 0 THEN
            w_rel_aseg := 34;
         ELSE
            IF pe_ben_relacion = 3 THEN
               IF w_sexo = 'M' THEN
                  w_rel_aseg := 4;
               ELSE
                  IF w_sexo = 'F' THEN
                     w_rel_aseg := 5;
                  ELSE
                     w_rel_aseg := 4;
                  END IF;
               END IF;
            ELSE
               IF pe_ben_relacion = 4 THEN
                  w_rel_aseg := 3;
               ELSE
                  IF pe_ben_relacion = 5 THEN
                     IF w_sexo = 'M' THEN
                        w_rel_aseg := 35;
                     ELSE
                        IF w_sexo = 'F' THEN
                           w_rel_aseg := 36;
                        ELSE
                           w_rel_aseg := 35;
                        END IF;
                     END IF;
                  ELSE
                     IF pe_ben_relacion = 6 THEN
                        IF  w_sexo = 'F' THEN
                        w_rel_aseg := 40;
                        ELSE
                        w_rel_aseg := 42;
                        END IF;
                     END IF;
                     IF pe_ben_relacion = 7 THEN --CC 05/01/2024
                        w_rel_aseg := 44;
                     END IF;
                     IF pe_ben_relacion = 8 then
                       w_rel_aseg :=43;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
    DBMS_APPLICATION_INFO.SET_ACTION('');
    DBMS_APPLICATION_INFO.SET_MODULE('','');
   --
   RETURN w_rel_aseg;
   --
END f_busca_ben_rel_aseg;
/
