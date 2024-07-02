CREATE OR REPLACE PROCEDURE "SP_CT_GENARCH_PGU_PRUEBA" ( p_periodo IN NUMBER )
IS

BEGIN

DECLARE
reg       NUMBER:=0;
--v_periodo NUMBER:=202303;
v_cont    NUMBER :=0;
v_cont2   NUMBER;
v_orden   NUMBER;
v_cod_error NUMBER;
v_msj_error VARCHAR2(1000);

TYPE genArch IS TABLE OF Varchar2(535) INDEX BY BINARY_INTEGER;
archivo_pgu genArch;


 /* CREAR CURSOR */
 CURSOR arch IS
            select PDP_PERIODO,
                   PDP_RUT_EMP,
                   PDP_DV_EMP,
                   PDP_RUT_BEN,
                   PDP_DV_BEN,
                   PDP_AP_PAT_BEN,
                   PDP_AP_MAT_BEN,
                   PDP_NOMB_BEN,
                   PDP_DOM_BEN,
                   PDP_COMUNA_BEN,
                   PDP_CIUDAD_BEN,
                   PDP_REGION_BEN,
                   PDP_TELEF1,
                   PDP_TELEF2,
                   PDP_EMAIL,
                   PDP_FEC_PAGO,
                   PDP_FRM_PAGO,
                   PDP_MOD_PAGO,
                   PDP_RUT_ENT_PAG,
                   PDP_DV_ENT_PAG,
                   PDP_COM_ENT_PAG,
                   PDP_REG_ENT_PAG,
                   PDP_CTA_BAN_BEN,
                   PDP_NRO_CTA_BEN,
                   PDP_COB_MANDATO,
                   PDP_RUT_MANDA,
                   PDP_DV_MANDA,
                   PDP_AP_PAT_MANDA,
                   PDP_AP_MAT_MANDA,
                   PDP_NOMBRE_MANDA,
                   PDP_DOMI_MANDA,
                   PDP_COMUNA_MANDA,
                   PDP_CIUDAD_MANDA,
                   PDP_REGION_MANDA,
                   PDP_COD_ENT_BANCA,
                   PDP_TIP_CTA_MANDA,
                   PDP_NRO_CTA_MANDA,
                   PDP_TOT_DESCTOS,
                   PDP_FECPAG_CONTRIB,
                   PDP_FECPROX_PAGO,
                   PDP_ENT_BANCA_BEN,
                   PDP_ESTADO_PAGO,
                   PDP_RUT_ENT_TRASPASO,
                   PDP_DV_ENT_TRASPASO

             from PENSIONES.pgu_datos_pago_periodo
             where pdp_periodo=p_periodo;

begin
  select nvl(Count(*),0)
  into reg
  from PENSIONES.pgu_datos_pago_periodo
  where pdp_periodo=p_periodo;
  if reg > 0 THEN

     FOR rec IN arch LOOP
         -- Genera archivo plano (txt) 
         v_cont := v_cont + 1;
         archivo_pgu(v_cont) := LPAD(NVL(rec.PDP_PERIODO, '0'),6, ' ')||         -- PERIODO
                                LPAD(NVL(rec.PDP_RUT_EMP, '0'),8,'0')||          -- RUT empresa
                                RPAD(NVL(rec.PDP_DV_EMP, ' '),1,' ')||           -- DV RUT empresa
                                LPAD(NVL(rec.PDP_RUT_BEN, '0'),8,'0')||          -- RUT benef
                                RPAD(NVL(rec.PDP_DV_BEN, ' '),1,' ')||           -- DV RUT benef
                                RPAD(NVL(rec.PDP_AP_PAT_BEN, ' '),20,' ')||      -- APELLIDO PAT benef
                                RPAD(NVL(rec.PDP_AP_MAT_BEN, ' '),20,' ')||      -- APELLIDO MAT benef
                                RPAD(NVL(rec.PDP_NOMB_BEN, ' '),30,' ')||        -- NOMBRE benef
                                RPAD(NVL(rec.PDP_DOM_BEN, ' '),45,' ')||         -- DIR benef
                                RPAD(NVL(rec.PDP_COMUNA_BEN,'0'),5,'0')||        -- COMUNA benef
                                RPAD(NVL(rec.PDP_CIUDAD_BEN,' 0 '),20,' ')||     -- CIUDAD benef
                                RPAD(NVL(rec.PDP_REGION_BEN,' 0 '),2,' ')||      -- REGION benef
                                RPAD(NVL(rec.PDP_TELEF1,' '),9,' ')||            -- TELEF FIJO benef
                                RPAD(NVL(rec.PDP_TELEF2,' '),9, ' ')||           -- TELEF MOVIL benef
                                RPAD(NVL(rec.PDP_EMAIL,' '),45,' ')||
                                RPAD(NVL(rec.PDP_FEC_PAGO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_FRM_PAGO,' '),2,' ')||
                                RPAD(NVL(rec.PDP_MOD_PAGO,' '),2,' ')||
                                RPAD(NVL(rec.PDP_RUT_ENT_PAG, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_ENT_PAG, ' '),1,' ')||
                                RPAD(NVL(rec.PDP_COM_ENT_PAG, ' '),5,' ')||
                                RPAD(NVL(rec.PDP_REG_ENT_PAG, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_CTA_BAN_BEN, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_NRO_CTA_BEN, '0'),18,'0')||
                                RPAD(NVL(rec.PDP_COB_MANDATO, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_RUT_MANDA, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_MANDA, ' '),1,' ')||
                                RPAD(NVL(rec.PDP_AP_PAT_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_AP_MAT_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_NOMBRE_MANDA, ' '),30,' ')||
                                RPAD(NVL(rec.PDP_DOMI_MANDA, ' '),45,' ')||
                                RPAD(NVL(rec.PDP_COMUNA_MANDA, '0'),5,'0')||
                                RPAD(NVL(rec.PDP_CIUDAD_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_REGION_MANDA, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_COD_ENT_BANCA, '0'),3,'0')||
                                RPAD(NVL(rec.PDP_TIP_CTA_MANDA, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_NRO_CTA_MANDA, '0'),18,'0')||
                                RPAD(NVL(rec.PDP_TOT_DESCTOS, '0'),8,'0 ')||
                                RPAD(NVL(rec.PDP_FECPAG_CONTRIB, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_FECPROX_PAGO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_ENT_BANCA_BEN, '0'),3,'0')||
                                RPAD(NVL(rec.PDP_ESTADO_PAGO, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_RUT_ENT_TRASPASO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_ENT_TRASPASO, ' '),1,' ');
         
                                --DBMS_OUTPUT.PUT_LINE(archivo_pgu(v_cont));
     END LOOP;
     
      -- Elimina lineas de temporal
      DELETE  CT_TMP_PGU;
      COMMIT;
      v_cont  := ( v_cont - 1 );
      v_orden := 1;

      -- Inserta lineas de registro 
      FOR v_cont2 IN 1..v_cont LOOP
          v_orden := v_orden+1;

          INSERT  INTO CT_TMP_PGU( DATOS_ARCHPGU, orden, periodo )
          VALUES  (archivo_pgu(v_cont2), v_orden, p_periodo);
          commit;
      END LOOP;
     
  else
    /* insert en la tabla PENSIONES.pgu_datos_pago_periodo */
    SP_CT_GENARCH_PGU_EXCEL(p_periodo,v_cod_error,v_msj_error);
    
    select nvl(Count(*),0)
    into reg
    from PENSIONES.pgu_datos_pago_periodo
    where pdp_periodo=p_periodo;
    if reg > 0 THEN

     FOR rec IN arch LOOP
         -- Genera archivo plano (txt) 
         v_cont := v_cont + 1;
         archivo_pgu(v_cont) := LPAD(NVL(rec.PDP_PERIODO, '0'),6, ' ')||         -- PERIODO
                                LPAD(NVL(rec.PDP_RUT_EMP, '0'),8,'0')||          -- RUT empresa
                                RPAD(NVL(rec.PDP_DV_EMP, ' '),1,' ')||           -- DV RUT empresa
                                LPAD(NVL(rec.PDP_RUT_BEN, '0'),8,'0')||          -- RUT benef
                                RPAD(NVL(rec.PDP_DV_BEN, ' '),1,' ')||           -- DV RUT benef
                                RPAD(NVL(rec.PDP_AP_PAT_BEN, ' '),20,' ')||      -- APELLIDO PAT benef
                                RPAD(NVL(rec.PDP_AP_MAT_BEN, ' '),20,' ')||      -- APELLIDO MAT benef
                                RPAD(NVL(rec.PDP_NOMB_BEN, ' '),30,' ')||        -- NOMBRE benef
                                RPAD(NVL(rec.PDP_DOM_BEN, ' '),45,' ')||         -- DIR benef
                                RPAD(NVL(rec.PDP_COMUNA_BEN,'0'),5,'0')||        -- COMUNA benef
                                RPAD(NVL(rec.PDP_CIUDAD_BEN,' 0 '),20,' ')||     -- CIUDAD benef
                                RPAD(NVL(rec.PDP_REGION_BEN,' 0 '),2,' ')||      -- REGION benef
                                RPAD(NVL(rec.PDP_TELEF1,' '),9,' ')||            -- TELEF FIJO benef
                                RPAD(NVL(rec.PDP_TELEF2,' '),9, ' ')||           -- TELEF MOVIL benef
                                RPAD(NVL(rec.PDP_EMAIL,' '),45,' ')||            -- EMAIL 
                                RPAD(NVL(rec.PDP_FEC_PAGO, '0'),8,'0')||         -- FECHA PAGO ULT PEN
                                RPAD(NVL(rec.PDP_FRM_PAGO,' '),2,' ')||          -- FORMA PAGO
                                RPAD(NVL(rec.PDP_MOD_PAGO,' '),2,' ')||          -- MODO PAGO
                                RPAD(NVL(rec.PDP_RUT_ENT_PAG, '0'),8,'0')||      -- RUT ENT Pagad
                                RPAD(NVL(rec.PDP_DV_ENT_PAG, ' '),1,' ')||       -- DV ENT Pagad
                                RPAD(NVL(rec.PDP_COM_ENT_PAG, ' '),5,' ')||      -- 
                                RPAD(NVL(rec.PDP_REG_ENT_PAG, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_CTA_BAN_BEN, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_NRO_CTA_BEN, '0'),18,'0')||
                                RPAD(NVL(rec.PDP_COB_MANDATO, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_RUT_MANDA, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_MANDA, ' '),1,' ')||
                                RPAD(NVL(rec.PDP_AP_PAT_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_AP_MAT_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_NOMBRE_MANDA, ' '),30,' ')||
                                RPAD(NVL(rec.PDP_DOMI_MANDA, ' '),45,' ')||
                                RPAD(NVL(rec.PDP_COMUNA_MANDA, '0'),5,'0')||
                                RPAD(NVL(rec.PDP_CIUDAD_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_REGION_MANDA, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_COD_ENT_BANCA, '0'),3,'0')||
                                RPAD(NVL(rec.PDP_TIP_CTA_MANDA, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_NRO_CTA_MANDA, '0'),18,'0')||
                                RPAD(NVL(rec.PDP_TOT_DESCTOS, '0'),8,'0 ')||
                                RPAD(NVL(rec.PDP_FECPAG_CONTRIB, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_FECPROX_PAGO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_ENT_BANCA_BEN, '0'),3,'0')||
                                RPAD(NVL(rec.PDP_ESTADO_PAGO, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_RUT_ENT_TRASPASO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_ENT_TRASPASO, ' '),1,' ');
         
                                --DBMS_OUTPUT.PUT_LINE(archivo_pgu(v_cont));
     END LOOP;
     
      -- Elimina lineas de temporal
      DELETE  CT_TMP_PGU;
      COMMIT;
      v_cont  := ( v_cont - 1 );
      v_orden := 1;

      -- Inserta lineas de registro 
      FOR v_cont2 IN 1..v_cont LOOP
          v_orden := v_orden+1;

          INSERT  INTO CT_TMP_PGU( DATOS_ARCHPGU, orden, periodo )
          VALUES  (archivo_pgu(v_cont2), v_orden, p_periodo);
          commit;
      END LOOP;
    end if;  
  end if;
end;

END;
/*select *
from PENSIONES.pgu_datos_pago_periodo
where pdp_periodo=202303;*/
/
