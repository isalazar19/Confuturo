CREATE OR REPLACE PROCEDURE pensiones."SP_CT_CASOS_REBAJADOS" (
                                                      p_periodo_new CT_LIQRV.LQR_PER%TYPE,
                                                      v_tabla OUT SYS_REFCURSOR)
IS

BEGIN
     OPEN v_tabla FOR 
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
                         lq.lqr_grp,
                         'Hijo entre 18 y 24 años sin certificado de estudios' as glosa
                FROM     CT_LIQRV lq,
                         PERSNAT pn,
                         DOMICILIOS dm,
                         PENSIONES.BENEFICIARIOS ben,
                         PENSIONES.PERSNAT natben
                WHERE    lq.LQR_PER      = p_periodo_new
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
                     < p_periodo_new)
                union
                --REBAJAR POLIZAS CUYO PG TERMINA
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
                         lq.lqr_grp,
                         'Poliza con termino de PG' as glosa
                FROM     CT_LIQRV lq,
                         PERSNAT pn,
                         DOMICILIOS dm,
                         POLIZAS pol
                WHERE    lq.LQR_PER      = p_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      pol.pol_linea = 3
                and      pol.pol_documento = 2
                and      pol.pol_poliza = lq.lqr_pol
                and      pol.pol_atrb01 = 7
          union
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
                         lq.lqr_grp,
             'Poliza con termino de PG mensual' as glosa
                FROM     CT_LIQRV lq,
                         PERSNAT pn,
                         DOMICILIOS dm,
                         POLIZAS pol
                WHERE    lq.LQR_PER      = p_periodo_new
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

                union
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
                         lq.lqr_grp,
                         'Poliza con termino de PG mensual' as glosa
                FROM     CT_LIQRV lq,
                         PERSNAT pn,
                         DOMICILIOS dm,
                         SOL_PAGO spg
                WHERE    lq.LQR_PER      = p_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      spg.spg_poliza = lq.lqr_pol
                and      spg.spg_rst = 2
                and      spg.spg_tipo_pago = 2
                and      lq.lqr_per > (select to_number(to_char(asaf_fec_garant - 1,'yyyymm'))
                                        from pensiones.asegafp
                                        where asaf_poliza = lq.lqr_pol)
                union
          --REBAJAR DEPOSITOS EN EXTRANJERO
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
                         lq.lqr_grp,
              'Poliza con deposito en extranjero' as glosa
                FROM     CT_LIQRV lq,
                         PERSNAT pn,
                         DOMICILIOS dm
                WHERE    lq.LQR_PER      = p_periodo_new
                AND      lq.LQR_FRM_PAGO NOT In(1, 10, 14)
                AND      lq.LQR_ID_RECEP = pn.NAT_ID
                AND      lq.LQR_ID_DOM   = dm.DOM_ID_DOM
                and      lq.lqr_frm_pago = 19
                ORDER BY 5 asc, 14 asc;

END SP_CT_CASOS_REBAJADOS;
/
