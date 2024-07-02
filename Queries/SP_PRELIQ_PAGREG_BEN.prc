CREATE OR REPLACE PROCEDURE pensiones."SP_PRELIQ_PAGREG_BEN" (
                                                      p_periodo_new IN NUMBER,
                                                      v_tabla OUT SYS_REFCURSOR)
IS

BEGIN
     OPEN v_tabla FOR
          SELECT lqr_pol POLIZA,
            lqr_grp GRUPO,
            c.nat_nomb NomCau,
            c.nat_numrut RutCau,
            c.nat_dv DVCau,
            r.nat_nomb NombRecep,
            r.nat_numrut RutReecp,
            r.nat_dv DVRecep,
            ben.nat_nomb Nomb_benef,
            ben.nat_numrut Rut_benef,
            ben.nat_dv DV_benef,

             (select cob_descripcion
                 from pensiones.siniestros ss, pensiones.cobertura
                where ss.sin_linea = asaf_linea
                  and ss.sin_producto = asaf_producto
                  and ss.sin_documento = asaf_documento
                  and ss.sin_poliza = asaf_poliza
                  and ss.sin_id = asaf_asegurado
                  and ss.sin_tipo = cob_codigo
                  and ss.sin_tipo = (select max(s1.sin_tipo)
                                    from pensiones.siniestros s1
                                   where s1.sin_linea = ss.sin_linea
                                     and s1.sin_producto = ss.sin_producto
                                     and s1.sin_documento = ss.sin_documento
                                     and s1.sin_poliza = ss.sin_poliza
                                     and s1.sin_id = ss.sin_id)) CAUSALIDAD_INICIAL,

                 c.cob_descripcion CAUSALIDAD_ACTUAL,
            (select cod_ext
            from pensiones.beneficiarios, pensiones.codigos
            where ben_linea = b.dsg_lin
            and ben_producto = b.dsg_prd
            and ben_documento =  b.dsg_doc
            and ben_poliza = b.dsg_pol
            and ben_causante =  b.dsg_cau
            and ben_beneficiario= b.dsg_ben
            and ben_relacion = cod_int_num
            and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacion,

            decode(lqr_cob, 1, asaf_monto_ref_muerte , asaf_monto_ref_inval ) pns_ref,

             case when to_char(asaf_fec_garant, 'yyyymm') >= lqr_per  then
                  asaf_fec_garant
                      else
                  null
                      end  fec_garant,
            decode(lqr_cob, 1, 'SO', 2, 'IN', 8, 'VE') || '-' || decode(lqr_prd, 603, 'RVI', 604, 'RVD', 606, 'RVA', 607, 'RAD') tippen,

            b.dsg_mto_uf pbase_UF,

            round(b.dsg_mto_pes) pbase_$,

            (select SUM(nvl(h0.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h0,pensiones.habdes hd1
              Where h0.dsg_lin = b.dsg_lin
              And h0.dsg_per = b.dsg_per
              And h0.dsg_pol = b.dsg_pol
              And h0.dsg_ben = b.dsg_ben
              And h0.dsg_tipo = 13
              And hd1.hd_corr = h0.dsg_corr_hd
              And hd1.hd_per = h0.dsg_per
              And hd1.hd_tip = 70)  BONO_POSTLABORAL,

              (select SUM(nvl(h1.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h1
            where h1.dsg_per = b.dsg_per
            and h1.dsg_lin = b.dsg_lin
            and h1.dsg_prd = b.dsg_prd
            and h1.dsg_doc = b.dsg_doc
            and h1.dsg_pol = b.dsg_pol
            and h1.dsg_cau = b.dsg_cau
            and h1.dsg_ben= b.dsg_ben
            and h1.Dsg_TIPo in (46, 47)) APS,

             (select SUM(nvl(h1.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h1
            where h1.dsg_per = b.dsg_per
            and h1.dsg_lin = b.dsg_lin
            and h1.dsg_prd = b.dsg_prd
            and h1.dsg_doc = b.dsg_doc
            and h1.dsg_pol = b.dsg_pol
            and h1.dsg_cau = b.dsg_cau
            and h1.dsg_ben= b.dsg_ben
            and h1.Dsg_TIPo in (97,98)) PGU,

             (select SUM(nvl(h11.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h11
            where h11.dsg_per = b.dsg_per
            and h11.dsg_lin = b.dsg_lin
            and h11.dsg_prd = b.dsg_prd
            and h11.dsg_doc = b.dsg_doc
            and h11.dsg_pol = b.dsg_pol
            and h11.dsg_cau = b.dsg_cau
            and h11.dsg_ben= b.dsg_ben
            and h11.Dsg_TIPo in (107,108)) Bono_compensatorio,

              (select SUM(nvl(h2.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h2
            where h2.dsg_per = b.dsg_per
            and h2.dsg_lin = b.dsg_lin
            and h2.dsg_prd = b.dsg_prd
            and h2.dsg_doc = b.dsg_doc
            and h2.dsg_pol = b.dsg_pol
            and h2.dsg_cau = b.dsg_cau
            and h2.dsg_ben= b.dsg_ben
            and h2.Dsg_TIPo in (61, 62, 63))  Bono_Agui_APS,

              (select SUM(nvl(h3.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h3
            where h3.dsg_per = b.dsg_per
            and h3.dsg_lin = b.dsg_lin
            and h3.dsg_prd = b.dsg_prd
            and h3.dsg_doc = b.dsg_doc
            and h3.dsg_pol = b.dsg_pol
            and h3.dsg_cau = b.dsg_cau
            and h3.dsg_ben= b.dsg_ben
            and h3.Dsg_TIPo in (19,20)) GE,

              (select SUM(nvl(h4.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h4
            where h4.dsg_per = b.dsg_per
            and h4.dsg_lin = b.dsg_lin
            and h4.dsg_prd = b.dsg_prd
            and h4.dsg_doc = b.dsg_doc
            and h4.dsg_pol = b.dsg_pol
            and h4.dsg_cau = b.dsg_cau
            and h4.dsg_ben= b.dsg_ben
            and h4.Dsg_TIPo in (8,9,18)) AF,

            (select SUM(nvl(h5.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h5,pensiones.habdes hd2
              Where h5.dsg_lin = b.dsg_lin
              And h5.dsg_per = b.dsg_per
              And h5.dsg_pol = b.dsg_pol
              And h5.dsg_ben = b.dsg_ben
              And h5.dsg_tipo = 13
              And hd2.hd_corr = h5.dsg_corr_hd
              And hd2.hd_per = h5.dsg_per
              And hd2.hd_tip = 92)  retro_PNC,

            (select SUM(nvl(h5.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h5,pensiones.habdes hd2
              Where h5.dsg_lin = b.dsg_lin
              And h5.dsg_per = b.dsg_per
              And h5.dsg_pol = b.dsg_pol
              And h5.dsg_ben = b.dsg_ben
              And h5.dsg_tipo = 13
              And hd2.hd_corr = h5.dsg_corr_hd
              And hd2.hd_per = h5.dsg_per
              And hd2.hd_tip = 96)  bono_clase_media,


            ((select nvl(SUM(nvl(h6.DSG_MTO_PES,0)),0)
            from pensiones.dsgdetrv h6
            where h6.dsg_per = b.dsg_per
            and h6.dsg_lin = b.dsg_lin
            and h6.dsg_prd = b.dsg_prd
            and h6.dsg_doc = b.dsg_doc
            and h6.dsg_pol = b.dsg_pol
            and h6.dsg_cau = b.dsg_cau
            and h6.dsg_ben= b.dsg_ben
            and h6.Dsg_TIPo not in (1,2,46, 47,8,9,18,19,20,11,13,61,62,63,97,98,107,108)
            and h6.dsg_d_h = 'H') +
              (select nvl(SUM(nvl(h7.DSG_MTO_PES,0)),0)
            from pensiones.dsgdetrv h7,pensiones.habdes hd3
            where h7.dsg_per = b.dsg_per
            and h7.dsg_lin = b.dsg_lin
            and h7.dsg_prd = b.dsg_prd
            and h7.dsg_doc = b.dsg_doc
            and h7.dsg_pol = b.dsg_pol
            and h7.dsg_cau = b.dsg_cau
            and h7.dsg_ben= b.dsg_ben
            and h7.Dsg_TIPo =13
            and h7.dsg_d_h = 'H'
            and hd3.hd_corr=h7.dsg_corr_hd
            and hd3.hd_per=h7.dsg_per
            and hd3.hd_tip  not in ( 70,92,96)) +
             (select nvl(SUM(nvl(h8.DSG_MTO_PES,0)),0)
            from pensiones.dsgdetrv h8,pensiones.habdes hd4
            where h8.dsg_per = b.dsg_per
            and h8.dsg_lin = b.dsg_lin
            and h8.dsg_prd = b.dsg_prd
            and h8.dsg_doc = b.dsg_doc
            and h8.dsg_pol = b.dsg_pol
            and h8.dsg_cau = b.dsg_cau
            and h8.dsg_ben= b.dsg_ben
            and h8.Dsg_TIPo =11
            and h8.dsg_d_h = 'H'
            and hd4.hd_corr=h8.dsg_corr_hd
            and hd4.hd_per=h8.dsg_per
            and hd4.hd_tip = 12)) OTROS_HAB,

            (select SUM(nvl(h9.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h9
            where h9.dsg_per = b.dsg_per
            and h9.dsg_lin = b.dsg_lin
            and h9.dsg_prd = b.dsg_prd
            and h9.dsg_doc = b.dsg_doc
            and h9.dsg_pol = b.dsg_pol
            and h9.dsg_cau = b.dsg_cau
            and h9.dsg_ben= b.dsg_ben
            and h9.dsg_d_h = 'H') TOT_HAB,

              (select SUM(nvl(hh1.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh1
            where hh1.dsg_per = b.dsg_per
            and hh1.dsg_lin = b.dsg_lin
            and hh1.dsg_prd = b.dsg_prd
            and hh1.dsg_doc = b.dsg_doc
            and hh1.dsg_pol = b.dsg_pol
            and hh1.dsg_cau = b.dsg_cau
            and hh1.dsg_ben= b.dsg_ben
            and hh1.Dsg_TIPo in (6, 43,44)) DSC_SALUD,

              (select SUM(nvl(hh2.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh2
            where hh2.dsg_per = b.dsg_per
            and hh2.dsg_lin = b.dsg_lin
            and hh2.dsg_prd = b.dsg_prd
            and hh2.dsg_doc = b.dsg_doc
            and hh2.dsg_pol = b.dsg_pol
            and hh2.dsg_cau = b.dsg_cau
            and hh2.dsg_ben= b.dsg_ben
            and hh2.Dsg_TIPo in (22)) DSC_GE,

              (select SUM(nvl(hh3.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh3
            where hh3.dsg_per = b.dsg_per
            and hh3.dsg_lin = b.dsg_lin
            and hh3.dsg_prd = b.dsg_prd
            and hh3.dsg_doc = b.dsg_doc
            and hh3.dsg_pol = b.dsg_pol
            and hh3.dsg_cau = b.dsg_cau
            and hh3.dsg_ben= b.dsg_ben
            and hh3.dsg_TIPo in (15,16)) DSC_AF,

              (select SUM(nvl(hh4.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh4
            where hh4.dsg_per = b.dsg_per
            and hh4.dsg_lin = b.dsg_lin
            and hh4.dsg_prd = b.dsg_prd
            and hh4.dsg_doc = b.dsg_doc
            and hh4.dsg_pol = b.dsg_pol
            and hh4.dsg_cau = b.dsg_cau
            and hh4.dsg_ben= b.dsg_ben
            and hh4.Dsg_TIPo in (5,37)) IMPTO,

              (select SUM(nvl(hh5.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh5
            where hh5.dsg_per = b.dsg_per
            and hh5.dsg_lin = b.dsg_lin
            and hh5.dsg_prd = b.dsg_prd
            and hh5.dsg_doc = b.dsg_doc
            and hh5.dsg_pol = b.dsg_pol
            and hh5.dsg_cau = b.dsg_cau
            and hh5.dsg_ben= b.dsg_ben
            and hh5.dsg_TIPo in (48)) DSC_APS,

              (select SUM(nvl(hh5.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh5
            where hh5.dsg_per = b.dsg_per
            and hh5.dsg_lin = b.dsg_lin
            and hh5.dsg_prd = b.dsg_prd
            and hh5.dsg_doc = b.dsg_doc
            and hh5.dsg_pol = b.dsg_pol
            and hh5.dsg_cau = b.dsg_cau
            and hh5.dsg_ben= b.dsg_ben
            and hh5.dsg_TIPo in (99)) DSC_PGU,

            (select SUM(nvl(hh6.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh6,pensiones.habdes hd5
            where hh6.dsg_per = b.dsg_per
            and hh6.dsg_lin = b.dsg_lin
            and hh6.dsg_prd = b.dsg_prd
            and hh6.dsg_doc = b.dsg_doc
            and hh6.dsg_pol = b.dsg_pol
            and hh6.dsg_cau = b.dsg_cau
            and hh6.dsg_ben= b.dsg_ben
            and hd5.hd_corr=hh6.dsg_corr_hd
            and hd5.hd_per=hh6.dsg_per
            And hd5.hd_tip = 56) credito_ing,

                (select SUM(nvl(hh7.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh7
            where hh7.dsg_per = b.dsg_per
            and hh7.dsg_lin = b.dsg_lin
            and hh7.dsg_prd = b.dsg_prd
            and hh7.dsg_doc = b.dsg_doc
            and hh7.dsg_pol = b.dsg_pol
            and hh7.dsg_cau = b.dsg_cau
            and hh7.dsg_ben= b.dsg_ben
            and hh7.Dsg_TIPO in (23,24,25,26)) CCAF,

              (select SUM(nvl(hh8.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh8
            where hh8.dsg_per = b.dsg_per
            and hh8.dsg_lin = b.dsg_lin
            and hh8.dsg_prd = b.dsg_prd
            and hh8.dsg_doc = b.dsg_doc
            and hh8.dsg_pol = b.dsg_pol
            and hh8.dsg_cau = b.dsg_cau
            and hh8.dsg_ben= b.dsg_ben
            and hh8.Dsg_TIPo in (7,17)) RET_JUD,

              (select SUM(nvl(hh9.DSG_MTO_PES,0))
            from pensiones.dsgdetrv hh9
            where hh9.dsg_per = b.dsg_per
            and hh9.dsg_lin = b.dsg_lin
            and hh9.dsg_prd = b.dsg_prd
            and hh9.dsg_doc = b.dsg_doc
            and hh9.dsg_pol = b.dsg_pol
            and hh9.dsg_cau = b.dsg_cau
            and hh9.dsg_ben= b.dsg_ben
            and hh9.Dsg_TIPo in (60)) Seguro_Pensionado,

            (nvl((select SUM(nvl(h10.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h10
            where h10.dsg_per = b.dsg_per
            and h10.dsg_lin = b.dsg_lin
            and h10.dsg_prd = b.dsg_prd
            and h10.dsg_doc = b.dsg_doc
            and h10.dsg_pol = b.dsg_pol
            and h10.dsg_cau = b.dsg_cau
            and h10.dsg_ben= b.dsg_ben
            and h10.Dsg_TIPo not in (6,43,44,22,15,16,5,37,48,23,24,25,26,7,17,12,14,60,99)
            and h10.dsg_d_h = 'D') ,0)
             +
                   nvl((SELECT SUM(d11.DSG_MTO_PES)
                      from pensiones.dsgdetrv d11, pensiones.habdes h17
                     Where d11.dsg_lin = b.dsg_lin
                       And d11.dsg_per =  b.dsg_per
                       and d11.dsg_prd =  b.dsg_prd
                       and d11.dsg_doc = b.dsg_doc
                       And d11.dsg_pol =b.dsg_pol
                       and d11.dsg_cau = b.dsg_cau
                       And d11.dsg_grp = b.dsg_grp
                       And d11.dsg_tipo = 14
                       And h17.hd_corr = d11.dsg_corr_hd
                       And h17.hd_per = d11.dsg_per
                       And h17.hd_tip in (1,68,93,94,78,99)),0) ) OTROS_DSC,

            (select SUM(nvl(h11.DSG_MTO_PES,0))
            from pensiones.dsgdetrv h11
            where h11.dsg_per = b.dsg_per
            and h11.dsg_lin = b.dsg_lin
            and h11.dsg_prd = b.dsg_prd
            and h11.dsg_doc = b.dsg_doc
            and h11.dsg_pol = b.dsg_pol
            and h11.dsg_cau = b.dsg_cau
            and h11.dsg_ben= b.dsg_ben
            and h11.dsg_d_h = 'D') TOT_DSC,

            decode(lqr_cob,1,
            (select sum(nvl(lqb_liq,0)) from pensiones.liqbenrv
            where lqb_per=b.dsg_per
                  and lqb_lin = lqr_lin
                  and lqb_prd = lqr_prd
                  and lqb_doc = lqr_doc
                  and lqb_pol = lqr_pol
                  and lqb_cau = lqr_cau
                  and lqb_grp = lqr_grp
                  and lqb_cob =  lqr_cob),lqr_lq) mto_liquido,

            to_char(LQR_FEC_PAGO, 'dd/mm/yyyy') F_PAGO,

            ((select nvl(SUM(h12.DSG_MTO_PES),0)
            from pensiones.dsgdetrv h12
            where h12.dsg_per = b.dsg_per
            and h12.dsg_lin = b.dsg_lin
            and h12.dsg_prd = b.dsg_prd
            and h12.dsg_doc = b.dsg_doc
            and h12.dsg_pol = b.dsg_pol
            and h12.dsg_cau = b.dsg_cau
            and h12.dsg_ben= b.dsg_ben
            and h12.Dsg_TIPo in (1,2,19,49)) -
            (select nvl(SUM(h13.DSG_MTO_PES),0)
            from pensiones.dsgdetrv h13
            where h13.dsg_per = b.dsg_per
            and h13.dsg_lin = b.dsg_lin
            and h13.dsg_prd = b.dsg_prd
            and h13.dsg_doc = b.dsg_doc
            and h13.dsg_pol = b.dsg_pol
            and h13.dsg_cau = b.dsg_cau
            and h13.dsg_ben= b.dsg_ben
            and h13.Dsg_TIPo in (5,6) ))  Pb_ge_aps_imp_7pc,

            f.FRP_DES_DS Forma_Pago,
            k.cod_ext banco,
            nvl(LQR_SUC_BCO, '') sucursal,
            nvl(LQR_CTA_BCO, '') cta_bco,

               case when lqr_bco <> 0
                    then  (select p.cod_ext
                           from  pensiones.codigos p
                           where p.cod_template(+) = 'MEDIO_PAGO_BCOCHILE'
                                 and p.cod_int_num(+)  = f_busca_medio_pago(lqr_frm_pago, lqr_bco))
                  else ' '  end MEDIO_PAGO_BCOCHILE ,


                  case pol_atrb19
                     when 1 then plq_fec_pago01
                     when 2 then plq_fec_pago02
                     when 3 then plq_fec_pago03
                     when 8 then plq_fec_pago08
                   end FECHA_PAGO_CONTRATO,

               (select SUM(nvl(h1.DSG_MTO_PES,0))
                  from pensiones.dsgdetrv h1
                  where h1.dsg_per = b.dsg_per
                  and h1.dsg_lin = b.dsg_lin
                  and h1.dsg_prd = b.dsg_prd
                  and h1.dsg_doc = b.dsg_doc
                  and h1.dsg_pol = b.dsg_pol
                  and h1.dsg_cau = b.dsg_cau
                  and h1.dsg_ben= b.dsg_ben
                  and h1.Dsg_TIPo in (49)) bonif_salud_mes,

             (select SUM(nvl(h1.DSG_MTO_PES,0))
                from pensiones.dsgdetrv h1
                where h1.dsg_per = b.dsg_per
                and h1.dsg_lin = b.dsg_lin
                and h1.dsg_prd = b.dsg_prd
                and h1.dsg_doc = b.dsg_doc
                and h1.dsg_pol = b.dsg_pol
                and h1.dsg_cau = b.dsg_cau
                and h1.dsg_ben= b.dsg_ben
                and h1.Dsg_TIPo in (97)) PGU_MES,

            (select sum(PGU_PRE_MTO_DES_IPS)
             from pensiones.pgu_preliq_ips
            where pgu_pre_per =  b.dsg_per
                  and pgu_pre_lin = b.dsg_lin
                  and pgu_pre_doc =  b.dsg_doc
                  and pgu_pre_prod = b.dsg_prd
                  and pgu_pre_pol = b.dsg_pol
                  and pgu_pre_cau = b.dsg_cau
                  and pgu_pre_ben = b.dsg_ben ) tot_proporc

                  ,DECODE(NVL(POL_PORC_RE,0), 0,'NO', 'SI')     ES_ESCALONADA
                  ,NVL(POL_PORC_RE,0)                           PORC_PEN_ESCALONADA
                  ,DECODE(NVL(POL_PORC_RE,0), 0,NULL, TO_CHAR(pkg_renta_escalonada.f_calc_fin_renta(POL_FEC_INICIO, POL_MESES_RE),'DD/MM/YYYY')) FEC_TERM_ESCALONADA
            from pensiones.liqrv
                   inner join(pensiones.dsgdetrv b
                              inner join pensiones.persnat ben
                                      on ben.nat_id = b.dsg_ben)
                           on b.dsg_lin  = lqr_lin
                          and b.dsg_per  = lqr_per
                          and b.dsg_prd = lqr_prd
                          and b.dsg_doc = lqr_doc
                          and b.dsg_pol  = lqr_pol
                          and b.dsg_cau = lqr_cau
                          and b.dsg_grp  = lqr_grp
                          and b.dsg_tipo = 1
                   inner join pensiones.persnat c
                           on c.nat_id = lqr_cau
                   inner join pensiones.persnat r
                           on r.nat_id = lqr_id_recep
                   inner join pensiones.forma_pago f
                           on f.frp_cod_id = lqr_frm_pago
                   inner join pensiones.codigos k
                           on k.cod_template = 'TB01-BANCOS'
                          and k.cod_int_num  = lqr_bco

                   inner join pensiones.polizas
                           on pol_linea     = lqr_lin
                          and pol_producto  = lqr_prd
                          and pol_documento = lqr_doc
                          and pol_poliza    = lqr_pol
                          and pol_contratante = lqr_cau
                   inner join pensiones.prmliqrv
                           on plq_per = lqr_per
                   inner join pensiones.asegafp
                     on asaf_linea = lqr_lin
                  and asaf_producto = lqr_prd
                  and asaf_documento = lqr_doc
                  and asaf_poliza = lqr_pol
                  and asaf_asegurado = lqr_cau
                  inner join pensiones.cobertura c
                     on  lqr_cob  = c.cob_codigo
             where lqr_per = p_periodo_new
               and lqr_lin = 3
                order by 1, 2;

END SP_PRELIQ_PAGREG_BEN;
/
