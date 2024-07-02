CREATE OR REPLACE PROCEDURE "SP_PRELIQ_GENARCH_BCOCHILE"
IS

/*************************************************************************
Sistema           : PENSIONES
Subsistema        : PreLiquidación de Pensiones - Archivo formato Contingencia
Objetivo          : Genera Archivo Banco Chile
Fecha de Creacion : 27/11/2020
Comando Prueba    :
=====================================================================
Modificaciones    :
=====================================================================
Fecha      Programador     Motivo
-----      -----------     ------------------------------------------
************************************************************************/
BEGIN



   DECLARE
        v_rut_emp                VARCHAR2(8);
        v_dv_emp                 VARCHAR2(1);
        v_nom_cia                VARCHAR2(37);
        v_banco                  NUMBER;
        v_med_pago               NUMBER;
        v_lcc_cod                LOCALCNV.LCC_COD%TYPE;
        v_num_cta                CT_LIQRV.LQR_CTA_BCO%TYPE;
        v_plano_bco_chile_01     VARCHAR2(400);
        v_acum_pago              NUMBER;
        v_cont                   NUMBER;
        v_cont2                  NUMBER;
        v_orden                  NUMBER;
        v_periodo_ant            NUMBER := 0;
        v_periodo_new            NUMBER := 0;
        v_idt_fecha_pago         DATE;
			  v_idt_fecha_gen_desde    DATE;
			  v_idt_fecha_gen_hasta    DATE;

        TYPE TMP IS TABLE OF Varchar2(400) INDEX BY BINARY_INTEGER;
        a_plano_bco_chile_02 TMP;

        CURSOR obt_ct_liqrv IS
                SELECT   lq.LQR_BCO,
                         lq.LQR_CTA_BCO,
                         lq.LQR_FRM_PAGO,
                         lq.LQR_LOC_CNV,
                         pn.NAT_NUMRUT,
                         pn.NAT_DV,
                         pn.NAT_AP_PAT,
                         pn.NAT_AP_MAT,
                         pn.NAT_NOMBRE,
                         dm.DOM_DIRECCION,
                         dm.DOM_COMUNA,
                         dm.DOM_CIUDAD,
                         lq.LQR_LQ,
                         lq.lqr_pol,
                         lq.lqr_grp
                FROM     pensiones.LIQRV lq,
                         pensiones.PERSNAT pn,
                         pensiones.DOMICILIOS dm
                WHERE    lq.LQR_PER      = v_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                --ORDER    BY lq.LQR_POL;
                minus
                --REBAJA HIJOS 18 y 24 AÑOS CON CERTIFICADO DE ESTUDIOS VENCIDO
                SELECT   lq.LQR_BCO,
                         lq.LQR_CTA_BCO,
                         lq.LQR_FRM_PAGO,
                         lq.LQR_LOC_CNV,
                         pn.NAT_NUMRUT,
                         pn.NAT_DV,
                         pn.NAT_AP_PAT,
                         pn.NAT_AP_MAT,
                         pn.NAT_NOMBRE,
                         dm.DOM_DIRECCION,
                         dm.DOM_COMUNA,
                         dm.DOM_CIUDAD,
                         lq.LQR_LQ,
                         lq.lqr_pol,
                         lq.lqr_grp
                FROM     pensiones.LIQRV lq,
                         pensiones.PERSNAT pn,
                         pensiones.DOMICILIOS dm,
                         PENSIONES.BENEFICIARIOS ben,
                         PENSIONES.PERSNAT natben
                WHERE    lq.LQR_PER      = v_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and lq.lqr_cob = 1
                and lq.lqr_rep = ben.ben_beneficiario
                and lq.lqr_pol = ben.ben_poliza
                AND ben.BEN_BENEFICIARIO = natben.NAT_ID AND ben.BEN_INVALIDO = 2
                AND ((sysdate-natben.nat_fec_nacim)/ 365) BETWEEN 18 AND 24
                AND ((select to_number(to_char(max(maximoper.ces_fec_hasta),'yyyymm'))
                      from pensiones.certest maximoper
                      where maximoper.ces_poliza=lq.lqr_pol
                      and maximoper.ces_beneficiario = lq.lqr_rep)
                     <v_periodo_new)
                minus
                --REBAJAR POLIZAS CUYO PG TERMINA CONTADOS
                 SELECT  lq.LQR_BCO,
                         lq.LQR_CTA_BCO,
                         lq.LQR_FRM_PAGO,
                         lq.LQR_LOC_CNV,
                         pn.NAT_NUMRUT,
                         pn.NAT_DV,
                         pn.NAT_AP_PAT,
                         pn.NAT_AP_MAT,
                         pn.NAT_NOMBRE,
                         dm.DOM_DIRECCION,
                         dm.DOM_COMUNA,
                         dm.DOM_CIUDAD,
                         lq.LQR_LQ,
                         lq.lqr_pol,
                         lq.lqr_grp
                FROM     pensiones.LIQRV lq,
                         pensiones.PERSNAT pn,
                         pensiones.DOMICILIOS dm,
                         pensiones.POLIZAS pol
                WHERE    lq.LQR_PER      = v_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      pol.pol_linea = 3
                and      pol.pol_documento = 2
                and      pol.pol_poliza = lq.lqr_pol
                and      pol.pol_atrb01 = 7
                minus
                --REBAJAR POLIZAS CUYO PG TERMINA mensual (previo a sol_pago)
                 SELECT  lq.LQR_BCO,
                         lq.LQR_CTA_BCO,
                         lq.LQR_FRM_PAGO,
                         lq.LQR_LOC_CNV,
                         pn.NAT_NUMRUT,
                         pn.NAT_DV,
                         pn.NAT_AP_PAT,
                         pn.NAT_AP_MAT,
                         pn.NAT_NOMBRE,
                         dm.DOM_DIRECCION,
                         dm.DOM_COMUNA,
                         dm.DOM_CIUDAD,
                         lq.LQR_LQ,
                         lq.lqr_pol,
                         lq.lqr_grp
                FROM     pensiones.LIQRV lq,
                         pensiones.PERSNAT pn,
                         pensiones.DOMICILIOS dm,
                         pensiones.POLIZAS pol
                WHERE    lq.LQR_PER      = v_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      pol.pol_linea = 3
                and      pol.pol_documento = 2
                and      pol.pol_poliza = lq.lqr_pol
                and      pol.pol_atrb01 <> 7
                and      pol.pol_atrb03 = 4
                and      lq.lqr_per > (select to_number(to_char(asaf_fec_garant - 1,'yyyymm'))
                                        from pensiones.asegafp
                                        where asaf_poliza = pol.pol_poliza)

                minus
                --REBAJAR POLIZAS CUYO PG TERMINA mensual (tabla sol_pago)
                 SELECT  lq.LQR_BCO,
                         lq.LQR_CTA_BCO,
                         lq.LQR_FRM_PAGO,
                         lq.LQR_LOC_CNV,
                         pn.NAT_NUMRUT,
                         pn.NAT_DV,
                         pn.NAT_AP_PAT,
                         pn.NAT_AP_MAT,
                         pn.NAT_NOMBRE,
                         dm.DOM_DIRECCION,
                         dm.DOM_COMUNA,
                         dm.DOM_CIUDAD,
                         lq.LQR_LQ,
                         lq.lqr_pol,
                         lq.lqr_grp
                FROM     pensiones.LIQRV lq,
                         pensiones.PERSNAT pn,
                         pensiones.DOMICILIOS dm,
                         pensiones.SOL_PAGO spg
                WHERE    lq.LQR_PER      = v_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      spg.spg_poliza = lq.lqr_pol
                and      spg.spg_rst = 2
                and      spg.spg_tipo_pago = 2
                and      lq.lqr_per > (select to_number(to_char(asaf_fec_garant - 1,'yyyymm'))
                                        from pensiones.asegafp
                                        where asaf_poliza = lq.lqr_pol)
                minus
                --REBAJAR CASOS CON DEPOSITO EN EXTRANJERO
                SELECT   lq.LQR_BCO,
                         lq.LQR_CTA_BCO,
                         lq.LQR_FRM_PAGO,
                         lq.LQR_LOC_CNV,
                         pn.NAT_NUMRUT,
                         pn.NAT_DV,
                         pn.NAT_AP_PAT,
                         pn.NAT_AP_MAT,
                         pn.NAT_NOMBRE,
                         dm.DOM_DIRECCION,
                         dm.DOM_COMUNA,
                         dm.DOM_CIUDAD,
                         lq.LQR_LQ,
                         lq.lqr_pol,
                         lq.lqr_grp
                FROM     pensiones.LIQRV lq,
                         pensiones.PERSNAT pn,
                         pensiones.DOMICILIOS dm
                WHERE    lq.LQR_PER      = v_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      lq.lqr_frm_pago = 19
                ORDER BY 5 asc, 14 asc;

    BEGIN

       SELECT	To_Number(To_char(prm_fec_hasta,'yyyymm')),
			        To_Number(To_char(add_months(prm_fec_hasta,0),'yyyymm')),
			        To_Date('18'||'/'||To_char(add_months(prm_fec_hasta,1),'mm')||'/'||To_char(add_months(prm_fec_hasta,1),'yyyy'), 'dd/mm/yyyy'),
			        To_Date('01'||'/'||To_char(add_months(prm_fec_hasta,1),'mm')||'/'||To_char(add_months(prm_fec_hasta,1),'yyyy'), 'dd/mm/yyyy'),
        	    To_Date(To_char(Last_Day(add_months(prm_fec_hasta,1)), 'dd')||'/'||To_char(add_months(prm_fec_hasta,1),'mm')||'/'||To_char(add_months(prm_fec_hasta,1),'yyyy'), 'dd/mm/yyyy')
       INTO		v_periodo_ant,
			        v_periodo_new,
			        v_idt_fecha_pago,
			        v_idt_fecha_gen_desde,
			        v_idt_fecha_gen_hasta
       FROM   PENSIONES.PARAMET_FECHAS
       WHERE   	prm_tipo_tabla = 'RVLIQ';

       -- Obtiene datos de empresa
       /*
       SELECT SubStr(COD_EXT, 51, 8),
              SubStr(COD_EXT, 59, 1),
              SubStr(COD_EXT, 14, 37)
       INTO   v_rut_emp,
              v_dv_emp,
              v_nom_cia
       FROM   CODIGOS
       WHERE  COD_TEMPLATE = 'EMPRESA-NUEVA';*/
       select to_char(cia_rut_cia_id),
              cia_dv_cia,
              cia_nomb_cia_comp
       into   v_rut_emp,
              v_dv_emp,
              v_nom_cia
       from   pensiones.compania;

       v_banco := 0;
       v_cont  := 1;
       --p_log   := 0;
       /* isalazarc - INI 20-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
      RF03 – ACTUALIZACIÓN DE CONTINGENCIA */
       v_acum_pago := 0;
      /* isalazarc - FIN 20-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/

       -- Genera archivo banco chile nomina de pagos beneficioario tipo registro 02
       FOR c_obt_ct_liqrv IN obt_ct_liqrv LOOP

           IF c_obt_ct_liqrv.LQR_BCO = 33 OR c_obt_ct_liqrv.LQR_BCO = 29 THEN
              v_banco := 1;
           ELSIF c_obt_ct_liqrv.LQR_BCO = 35 OR c_obt_ct_liqrv.LQR_BCO = 8 OR
                 c_obt_ct_liqrv.LQR_BCO = 10 OR c_obt_ct_liqrv.LQR_BCO = 43 THEN
                 v_banco := 37;
           ELSIF c_obt_ct_liqrv.LQR_BCO = 733 THEN
                 v_banco := 27;
           ELSE
                 v_banco := c_obt_ct_liqrv.LQR_BCO;
           END IF;

           IF  c_obt_ct_liqrv.LQR_FRM_PAGO = 9 THEN

               v_med_pago := 2;

               BEGIN
                   SELECT Nvl(LCC_COD, 0)
                   INTO   v_lcc_cod
                   FROM   pensiones.LOCALCNV
                   WHERE  LCC_CORR = c_obt_ct_liqrv.LQR_LOC_CNV;
                   EXCEPTION WHEN NO_DATA_FOUND THEN
                             v_lcc_cod := NULL;
               END;

           ELSE

               IF c_obt_ct_liqrv.LQR_FRM_PAGO = 13 THEN

                  v_med_pago := 10;

               ELSE

                  IF ( c_obt_ct_liqrv.LQR_FRM_PAGO = 3 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 4)
                     AND ( v_banco = 1 OR v_banco = 29) THEN
                     v_med_pago := 1;
                  ELSE
                     IF c_obt_ct_liqrv.LQR_FRM_PAGO = 2 THEN
                        v_med_pago := 3;
                     ELSE
                        IF (c_obt_ct_liqrv.LQR_FRM_PAGO = 5 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 7)
                           AND (v_banco = 1 OR v_banco = 29) THEN
                           v_med_pago := 6;
                        ELSE
                           IF (c_obt_ct_liqrv.LQR_FRM_PAGO = 3 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 4)
                              AND v_banco <> 1 THEN
                              v_med_pago := 7;
                           ELSE
                              IF (c_obt_ct_liqrv.LQR_FRM_PAGO = 5 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 6 OR
                                  c_obt_ct_liqrv.LQR_FRM_PAGO = 7 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 8) AND
                                  v_banco <> 1 THEN
                                  v_med_pago := 8;
                              ELSE
                                  IF (c_obt_ct_liqrv.LQR_FRM_PAGO = 11 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 18) THEN
                                     v_med_pago := 11;
                                  ELSE
                                     IF c_obt_ct_liqrv.LQR_FRM_PAGO = 13 THEN
                                        v_med_pago := 10;
                                     ELSE
                                        IF c_obt_ct_liqrv.LQR_FRM_PAGO = 15 THEN
                                           v_med_pago := 12;
                                        ELSE
                                           IF (c_obt_ct_liqrv.LQR_FRM_PAGO = 12 OR c_obt_ct_liqrv.LQR_FRM_PAGO = 16) THEN
                                              v_med_pago := 7;
                                           END IF;
                                        END IF;
                                     END IF;
                                  END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
           END IF;

           IF v_med_pago = 1 OR v_med_pago = 6 OR v_med_pago = 7 OR v_med_pago = 8 THEN
              IF v_banco = 1 THEN
                 v_num_cta := c_obt_ct_liqrv.LQR_CTA_BCO;
              ELSE
                 v_num_cta := c_obt_ct_liqrv.LQR_CTA_BCO;
              END IF;
           END IF;

          -- Genera archivo plano (txt) banco chile nomina de pagos beneficioario tipo registro 02
           a_plano_bco_chile_02(v_cont) := '02'||                                                 -- Tipo de registro
                                           Lpad(Nvl(v_rut_emp, '0'),9,'0')||                      -- RUT empresa
                                           Rpad(Nvl(v_dv_emp, ' '),1,' ')||                       -- DV RUT empresa
                                           '004'||                                                -- Código convenio
                                           Rpad(' ',2,' ')||                                      -- Llenar con espacios
                                           /* isalazarc - INI 15-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
                                           RF03 – ACTUALIZACIÓN DE CONTINGENCIA */
                                           --'00001'||                                              -- Número de nómina
                                           '0'||
                                           Rpad(Nvl(SubStr(To_Char(v_periodo_new),3,2), ' '),2,' ')||
                                           Rpad(Nvl(SubStr(To_Char(v_periodo_new),5,2), ' '),2,' ')||
                                           /* isalazarc - FIN 15-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/                                           Lpad(Nvl(To_Char(v_med_pago),'0'),2,'0')||             -- Medio de pago
                                           Lpad(Nvl(c_obt_ct_liqrv.NAT_NUMRUT, '0'),9,'0')||      -- RUT empresa
                                           Rpad(Nvl(c_obt_ct_liqrv.NAT_DV, ' '),1,' ')||          -- DV RUT empresa
                                           Rpad(Nvl(c_obt_ct_liqrv.NAT_AP_PAT|| ' ' ||            -- Nombre Beneficiario
                                           c_obt_ct_liqrv.NAT_AP_MAT|| ' ' ||
                                           c_obt_ct_liqrv.NAT_NOMBRE,' '),60,' ')||
                                           '0'||                                                  -- Tipo de direccion
                                           Rpad(Nvl(c_obt_ct_liqrv.DOM_DIRECCION, ' '),35,' ')||  -- Dirección beneficiario
                                           Rpad(Nvl(c_obt_ct_liqrv.DOM_COMUNA, ' '),15,' ')||     -- Comuna beneficiario
                                           Rpad(Nvl(c_obt_ct_liqrv.DOM_CIUDAD, ' '),15,' ')||     -- Ciudad beneficiario
                                           Rpad(' ',7,' ')||                                      -- Llenar con espacios
                                           CASE v_med_pago WHEN 2 THEN 'BC' WHEN 3 THEN 'BC'
                                                ELSE Lpad(' ',2,' ') END ||                       -- Cód. Act. Económica
                                           Lpad(Nvl(v_banco, '0'),3,'0')||                        -- Cód. Banco
                                           Rpad(Nvl(v_num_cta, ' '),22,' ')||                     -- Número Cuenta
                                           CASE c_obt_ct_liqrv.LQR_FRM_PAGO WHEN 9 THEN Lpad(Nvl(v_lcc_cod, '0'),3,'0')
                                                ELSE Lpad(' ',3,' ') END||                       -- Oficina destino
                                           Lpad(Nvl(c_obt_ct_liqrv.LQR_LQ, '0'),13,'0')||         -- Monto pago
                                           Rpad(Nvl('Anticipo Pago de Pensión por Preliquidacion', ' '),117,' ')|| -- Descripción pago
                                           Rpad(Nvl(To_Char(0),'0'),4,'0')||                      -- Número mensaje
                                           'N'||                                                  -- Vale vista acumilado
                                           Rpad(Nvl(To_Char(0),'0'),3,'0')||                      -- Tipo documento
                                           Rpad(Nvl(To_Char(0),'0'),10,'0')||                     -- N° documento
                                           '+'||                                                  -- Signo
                                           Rpad(Nvl(To_Char(0),'0'),6,'0')||                      -- Correlativo impresión vale vista
                                           'S'||                                                  -- Vale vista virtual
                                           Rpad(' ',45,' ');                                      -- Llenar con espacios

               v_acum_pago := v_acum_pago + Nvl(c_obt_ct_liqrv.LQR_LQ,0);

               v_cont := v_cont + 1;

       END LOOP;

       -- genera archivo banco chile nomina de pagos registro tipo 01 con acumulado de pago
       v_plano_bco_chile_01 := '01'||                                        -- Tipo de registro
                               Rpad(Nvl(v_rut_emp, ' '),9,' ')||             -- RUT empresa
                               Rpad(Nvl(v_dv_emp, ' '),1,' ')||              -- DV RUT empresa
                               '004'||                                       -- Código convenio
                               /* isalazarc - INI 15-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
                               RF03 – ACTUALIZACIÓN DE CONTINGENCIA */
                               --'00001'||                                     -- Número de nómina
                               '0'||
                               Rpad(Nvl(SubStr(To_Char(v_periodo_new),3,2), ' '),2,' ')||
                               Rpad(Nvl(SubStr(To_Char(v_periodo_new),5,2), ' '),2,' ')||
                               /* isalazarc - FIN 15-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/
                               
                               /* isalazarc - INI 15-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
                               RF03 – ACTUALIZACIÓN DE CONTINGENCIA */
                               --Rpad('LIQ. CONTINGENCIA '||                   -- Nombre de nómina
                               Rpad('PAGO PEN PRE-LIQUIDACION',25,' ')||
                               --Rpad(Nvl(SubStr(To_Char(p_periodo_new),5,2), ' '),2,' ')||
                               --'-'||
                               --Rpad(Nvl(SubStr(To_Char(p_periodo_new),1,4), ' '),4,' ')
                               --,25,' ')||
                               /* isalazarc - FIN 15-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/
                               '01'||                                        -- Código moneda
                               Lpad(Nvl(To_Char(v_idt_fecha_pago,'YYYY')||   -- Fecha del pago
                               To_Char(v_idt_fecha_pago,'MM')||
                               To_Char(v_idt_fecha_pago,'DD'),' '),8,' ')||
                               Lpad(Nvl(To_Char(v_acum_pago),'0'),13,'0')||  -- Monto total del pago
                               Lpad(' ',3,' ')||                             -- Llenar con espacios
                               'N'||                                         -- Tipo de endoso del vale vista
                               Lpad(' ',324,' ')||                           -- Llenar con espacios
                               '0401';                                       -- Tipo de pago
      -- Elimina lineas de temporal
      DELETE  pensiones.preliq_tmp;
      COMMIT;

      -- Inserta lineas de registro tipo 01 empresa - 400 caracteres
      --JUAN PABLO SOLICITA NO TENER ENCABEZADO YA QUE RUT INDICA LA EMPRESA DEL ARCHIVO
      --INSERT  INTO pensiones.preliq_tmp( DATOS_ARCHBCOCHILE, orden )
      --VALUES  (v_plano_bco_chile_01,1);
      /* isalazarc - INI 20-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
           RF03 – ACTUALIZACIÓN DE CONTINGENCIA */
      INSERT  INTO pensiones.preliq_tmp( DATOS_ARCHBCOCHILE, orden )
      VALUES  (v_plano_bco_chile_01,1);
      commit;
      /* isalazarc - FIN 20-05-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/
      
      v_cont  := ( v_cont - 1 );
      v_orden := 1;

      -- Inserta lineas de registro tipo 02 beneficiario - 400 caracteres
      FOR v_cont2 IN 1..v_cont LOOP
          v_orden := v_orden+1;

          INSERT  INTO pensiones.preliq_tmp( DATOS_ARCHBCOCHILE, orden )
          VALUES  (a_plano_bco_chile_02(v_cont2), v_orden);
          commit;
      END LOOP;        

        COMMIT;
        RETURN;

    END;
commit;
END;
 
 
/
