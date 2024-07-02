CREATE OR REPLACE PROCEDURE pensiones."SP_PRELIQ_PAGREG" (
                                                      p_periodo_new IN NUMBER,
                                                      v_tabla OUT SYS_REFCURSOR)
IS

BEGIN
     OPEN v_tabla FOR
          SELECT lqr_pol POLIZA,
                 lqr_grp GRUPO,

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
                    from pensiones.beneficiarios,
                         pensiones.codigos,
                         pensiones.grupopago
                   where grp_linea = l.lqr_lin
                     and grp_producto = l.lqr_prd
                     and grp_documento = l.lqr_doc
                     and grp_poliza = l.lqr_pol
                     and grp_asegurado = l.lqr_cau
                     and grp_grupo = l.lqr_grp
                     and grp_linea = ben_linea
                     and grp_producto= ben_producto
                     and grp_documento = ben_documento
                     and grp_poliza = ben_poliza
                     and grp_asegurado = ben_Causante
                     and grp_id_grupo = ben_beneficiario
                     and ben_relacion = cod_int_num
                     and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacion,

                 decode(lqr_cob, 1, asaf_monto_ref_muerte, asaf_monto_ref_inval) pns_ref,
                   case when to_char(asaf_fec_garant, 'yyyymm') >= lqr_per  then
                asaf_fec_garant
                    else
                null
                    end  fec_garant,

                 c.nat_nomb NomCau,
                 c.nat_numrut RutCau,
                 c.nat_dv DVCau,
                 r.nat_nomb NombRecep,
                 r.nat_numrut RutReecp,
                 r.nat_dv DVRecep,
                 decode(lqr_cob, 1, 'SO', 2, 'IN', 8, 'VE') || '-' ||
                 decode(lqr_prd, 603, 'RVI', 604, 'RVD', 606, 'RVA', 607, 'RAD') tippen,

                 (select SUM(h.DLR_MTO_UF)
                    from pensiones.detliqrv h
                   where h.dlr_per = l.lqr_per
                     and h.dlr_lin = l.lqr_lin
                     and h.dlr_prd = l.lqr_prd
                     and h.dlr_doc = l.lqr_doc
                     and h.dlr_pol = l.lqr_pol
                     and h.dlr_cau = l.lqr_cau
                     and h.dlr_grp = l.lqr_grp
                     and h.dlr_cob = l.Lqr_Cob
                     and h.DLR_TIP in (1, 2)) pbase_UF,

                 (select SUM(h1.DLR_MTO_PES)
                    from pensiones.detliqrv h1
                   where h1.dlr_per = l.lqr_per
                     and h1.dlr_lin = l.lqr_lin
                     and h1.dlr_prd = l.lqr_prd
                     and h1.dlr_doc = l.lqr_doc
                     and h1.dlr_pol = l.lqr_pol
                     and h1.dlr_cau = l.lqr_cau
                     and h1.dlr_grp = l.lqr_grp
                     and h1.dlr_cob = l.Lqr_Cob
                     and h1.DLR_TIP in (1, 2)) pbase_PES,

                 (select SUM(d1.DSG_MTO_PES)
                    from pensiones.dsgdetrv d1 , pensiones.habdes h2
                   Where d1.dsg_lin = l.lqr_lin
                     And d1.dsg_per = l.lqr_per
                     and d1.dsg_prd = l.lqr_prd
                     and d1.dsg_doc = l.lqr_doc
                     And d1.dsg_pol = l.lqr_pol
                     and d1.dsg_cau = l.lqr_cau
                     And d1.dsg_grp = l.lqr_grp
                     And d1.dsg_tipo = 13
                     And h2.hd_corr = d1.dsg_corr_hd
                    And h2.hd_per = d1.dsg_per
                     And h2.hd_tip = 70) BONO_POSTLABORAL,
             (select SUM(d1.DSG_MTO_PES)
                    from pensiones.dsgdetrv d1 , pensiones.habdes h2
                   Where d1.dsg_lin = l.lqr_lin
                     And d1.dsg_per = l.lqr_per
                     and d1.dsg_prd = l.lqr_prd
                     and d1.dsg_doc = l.lqr_doc
                     And d1.dsg_pol = l.lqr_pol
                     and d1.dsg_cau = l.lqr_cau
                     And d1.dsg_grp = l.lqr_grp
                     And d1.dsg_tipo = 13
                     And h2.hd_corr = d1.dsg_corr_hd
                    And h2.hd_per = d1.dsg_per
                     And h2.hd_tip = 96) bono_clase_media,


                 (select SUM(h3.DLR_MTO_PES)
                    from pensiones.detliqrv h3
                   where h3.dlr_per = l.lqr_per
                     and h3.dlr_lin = l.lqr_lin
                     and h3.dlr_prd = l.lqr_prd
                     and h3.dlr_doc = l.lqr_doc
                     and h3.dlr_pol = l.lqr_pol
                     and h3.dlr_cau = l.lqr_cau
                     and h3.dlr_grp = l.lqr_grp
                     and h3.dlr_cob = l.Lqr_Cob
                     and h3.DLR_TIP in (46, 47)
                     and h3.dlr_d_h = 'H') APS,

              (select SUM(h3.DLR_MTO_PES)
                    from pensiones.detliqrv h3
                   where h3.dlr_per = l.lqr_per
                     and h3.dlr_lin = l.lqr_lin
                     and h3.dlr_prd = l.lqr_prd
                     and h3.dlr_doc = l.lqr_doc
                     and h3.dlr_pol = l.lqr_pol
                     and h3.dlr_cau = l.lqr_cau
                     and h3.dlr_grp = l.lqr_grp
                     and h3.dlr_cob = l.Lqr_Cob
                     and h3.DLR_TIP in (97,98)
                     and h3.dlr_d_h = 'H') PGU,
          (select SUM(hh3.DLR_MTO_PES)
                    from pensiones.detliqrv hh3
                   where hh3.dlr_per = l.lqr_per
                     and hh3.dlr_lin = l.lqr_lin
                     and hh3.dlr_prd = l.lqr_prd
                     and hh3.dlr_doc = l.lqr_doc
                     and hh3.dlr_pol = l.lqr_pol
                     and hh3.dlr_cau = l.lqr_cau
                     and hh3.dlr_grp = l.lqr_grp
                     and hh3.dlr_cob = l.Lqr_Cob
                     and hh3.DLR_TIP  in(107,108)
                     and hh3.dlr_d_h = 'H') Bono_Compensatorio,

                 (select SUM(h4.DLR_MTO_PES)
                    from pensiones.detliqrv h4
                   where h4.dlr_per = l.lqr_per
                     and h4.dlr_lin = l.lqr_lin
                     and h4.dlr_prd = l.lqr_prd
                     and h4.dlr_doc = l.lqr_doc
                     and h4.dlr_pol = l.lqr_pol
                     and h4.dlr_cau = l.lqr_cau
                     and h4.dlr_grp = l.lqr_grp
                     and h4.dlr_cob = l.Lqr_Cob
                     and h4.DLR_TIP in (61, 62, 63)) Bono_Agui_APS,

                 (select SUM(h5.DLR_MTO_PES)
                    from pensiones.detliqrv h5
                   where h5.dlr_per = l.lqr_per
                     and h5.dlr_lin = l.lqr_lin
                     and h5.dlr_prd = l.lqr_prd
                     and h5.dlr_doc = l.lqr_doc
                     and h5.dlr_pol = l.lqr_pol
                     and h5.dlr_cau = l.lqr_cau
                     and h5.dlr_grp = l.lqr_grp
                     and h5.dlr_cob = l.Lqr_Cob
                     and h5.DLR_TIP in (19, 20)) GE,

                 (select SUM(h6.DLR_MTO_PES)
                    from pensiones.detliqrv h6
                   where h6.dlr_per = l.lqr_per
                     and h6.dlr_lin = l.lqr_lin
                     and h6.dlr_prd = l.lqr_prd
                     and h6.dlr_doc = l.lqr_doc
                     and h6.dlr_pol = l.lqr_pol
                     and h6.dlr_cau = l.lqr_cau
                     and h6.dlr_grp = l.lqr_grp
                     and h6.dlr_cob = l.Lqr_Cob
                     and h6.DLR_TIP in (8, 9, 18)) AF,

                 (select SUM(d2.DSG_MTO_PES)
                    from pensiones.dsgdetrv d2, pensiones.habdes h7
                   Where d2.dsg_lin = l.lqr_lin
                     And d2.dsg_per = l.lqr_per
                     and d2.dsg_prd = l.lqr_prd
                     and d2.dsg_doc = l.lqr_doc
                     And d2.dsg_pol = l.lqr_pol
                     and d2.dsg_cau = l.lqr_cau
                     And d2.dsg_grp = l.lqr_grp
                     And d2.dsg_tipo = 13
                     And h7.hd_corr = d2.dsg_corr_hd
                     And h7.hd_per = d2.dsg_per
                     And h7.hd_tip = 92) retro_PNC,




                 ((select nvl(SUM(h8.DLR_MTO_PES), 0)
                     from pensiones.detliqrv h8
                    where h8.dlr_per = l.lqr_per
                      and h8.dlr_lin = l.lqr_lin
                      and h8.dlr_prd = l.lqr_prd
                      and h8.dlr_doc = l.lqr_doc
                      and h8.dlr_pol = l.lqr_pol
                      and h8.dlr_cau = l.lqr_cau
                      and h8.dlr_grp = l.lqr_grp
                      and h8.dlr_cob = l.Lqr_Cob
                      and h8.DLR_TIP not in
                          (1, 2, 46, 47, 8, 9, 18, 19, 20, 13, 61, 62, 63, 97,98,107,108)
                      and h8.dlr_d_h = 'H') +
                 (select nvl(SUM(nvl(d9.DSG_MTO_PES, 0)), 0)
                     from pensiones.dsgdetrv d9, pensiones.habdes h9
                    where d9.dsg_per = l.lqr_per
                      and d9.dsg_lin = l.lqr_lin
                      and d9.dsg_prd = l.lqr_prd
                      and d9.dsg_doc = l.lqr_doc
                      and d9.dsg_pol = l.lqr_pol
                      and d9.dsg_cau = l.lqr_cau
                      and d9.dsg_grp = l.lqr_grp
                      and d9.Dsg_TIPo = 13
                      and d9.dsg_d_h = 'H'
                      and h9.hd_corr = d9.dsg_corr_hd
                      and h9.hd_per = d9.dsg_per
                      and h9.hd_tip not in (70, 92,96))) +
                 (select nvl(SUM(nvl(d10.DSG_MTO_PES, 0)), 0)
                    from pensiones.dsgdetrv d10, pensiones.habdes h10
                   where d10.dsg_per = l.lqr_per
                     and d10.dsg_lin = l.lqr_lin
                     and d10.dsg_prd = l.lqr_prd
                     and d10.dsg_doc = l.lqr_doc
                     and d10.dsg_pol = l.lqr_pol
                     and d10.dsg_cau = l.lqr_cau
                     and d10.dsg_grp = l.lqr_grp
                     and d10.Dsg_TIPo = 11
                     and d10.dsg_d_h = 'H'
                     and h10.hd_corr = d10.dsg_corr_hd
                     and h10.hd_per = d10.dsg_per
                     and h10.hd_tip = 12) OTROS_HAB,

                 (select SUM(h11.DLR_MTO_PES)
                    from pensiones.detliqrv h11
                   where h11.dlr_per = l.lqr_per
                     and h11.dlr_lin = l.lqr_lin
                     and h11.dlr_prd = l.lqr_prd
                     and h11.dlr_doc = l.lqr_doc
                     and h11.dlr_pol = l.lqr_pol
                     and h11.dlr_cau = l.lqr_cau
                     and h11.dlr_grp = l.lqr_grp
                     and h11.dlr_cob = l.Lqr_Cob
                     and h11.dlr_d_h = 'H') TOT_HAB,

                 (select SUM(h12.DLR_MTO_PES)
                    from pensiones.detliqrv h12
                   where h12.dlr_per = l.lqr_per
                     and h12.dlr_lin = l.lqr_lin
                     and h12.dlr_prd = l.lqr_prd
                     and h12.dlr_doc = l.lqr_doc
                     and h12.dlr_pol = l.lqr_pol
                     and h12.dlr_cau = l.lqr_cau
                     and h12.dlr_grp = l.lqr_grp
                     and h12.dlr_cob = l.Lqr_Cob
                     and h12.DLR_TIP in (6, 43, 44)) DSC_SALUD,

                 (select SUM(h13.DLR_MTO_PES)
                    from pensiones.detliqrv h13
                   where h13.dlr_per = l.lqr_per
                     and h13.dlr_lin = l.lqr_lin
                     and h13.dlr_prd = l.lqr_prd
                     and h13.dlr_doc = l.lqr_doc
                     and h13.dlr_pol = l.lqr_pol
                     and h13.dlr_cau = l.lqr_cau
                     and h13.dlr_grp = l.lqr_grp
                     and h13.dlr_cob = l.Lqr_Cob
                     and h13.DLR_TIP in (22)) DSC_GE,
                 (select SUM(h14.DLR_MTO_PES)
                    from pensiones.detliqrv h14
                   where h14.dlr_per = l.lqr_per
                     and h14.dlr_lin = l.lqr_lin
                     and h14.dlr_prd = l.lqr_prd
                     and h14.dlr_doc = l.lqr_doc
                     and h14.dlr_pol = l.lqr_pol
                     and h14.dlr_cau = l.lqr_cau
                     and h14.dlr_grp = l.lqr_grp
                     and h14.dlr_cob = l.Lqr_Cob
                     and h14.DLR_TIP in (15, 16)) DSC_AF,
                 (select SUM(h15.DLR_MTO_PES)
                    from pensiones.detliqrv h15
                   where h15.dlr_per = l.lqr_per
                     and h15.dlr_lin = l.lqr_lin
                     and h15.dlr_prd = l.lqr_prd
                     and h15.dlr_doc = l.lqr_doc
                     and h15.dlr_pol = l.lqr_pol
                     and h15.dlr_cau = l.lqr_cau
                     and h15.dlr_grp = l.lqr_grp
                     and h15.dlr_cob = l.Lqr_Cob
                     and h15.DLR_TIP in (5, 37)) IMPTO,

                 (select SUM(h16.DLR_MTO_PES)
                    from pensiones.detliqrv h16
                   where h16.dlr_per = l.lqr_per
                     and h16.dlr_lin = l.lqr_lin
                     and h16.dlr_prd = l.lqr_prd
                     and h16.dlr_doc = l.lqr_doc
                     and h16.dlr_pol = l.lqr_pol
                     and h16.dlr_cau = l.lqr_cau
                     and h16.dlr_grp = l.lqr_grp
                     and h16.dlr_cob = l.Lqr_Cob
                     and h16.DLR_TIP in (48)) DSC_APS,

             (select SUM(h16.DLR_MTO_PES)
                    from pensiones.detliqrv h16
                   where h16.dlr_per = l.lqr_per
                     and h16.dlr_lin = l.lqr_lin
                     and h16.dlr_prd = l.lqr_prd
                     and h16.dlr_doc = l.lqr_doc
                     and h16.dlr_pol = l.lqr_pol
                     and h16.dlr_cau = l.lqr_cau
                     and h16.dlr_grp = l.lqr_grp
                     and h16.dlr_cob = l.Lqr_Cob
                     and h16.DLR_TIP in (99)) DSC_PGU,



                 (SELECT SUM(d11.DSG_MTO_PES)
                    from pensiones.dsgdetrv d11, pensiones.habdes h17
                   Where d11.dsg_lin = l.lqr_lin
                     And d11.dsg_per = L.lqr_per
                     and d11.dsg_prd = l.lqr_prd
                     and d11.dsg_doc = l.lqr_doc
                     And d11.dsg_pol = l.lqr_pol
                     and d11.dsg_cau = l.lqr_cau
                     And d11.dsg_grp = l.lqr_grp
                     And d11.dsg_tipo = 14
                     And h17.hd_corr = d11.dsg_corr_hd
                     And h17.hd_per = d11.dsg_per
                     And h17.hd_tip = 56) credito_ing,

                 (select SUM(h18.DLR_MTO_PES)
                    from pensiones.detliqrv h18
                   where h18.dlr_per = l.lqr_per
                     and h18.dlr_lin = l.lqr_lin
                     and h18.dlr_prd = l.lqr_prd
                     and h18.dlr_doc = l.lqr_doc
                     and h18.dlr_pol = l.lqr_pol
                     and h18.dlr_cau = l.lqr_cau
                     and h18.dlr_grp = l.lqr_grp
                     and h18.dlr_cob = l.Lqr_Cob
                     and h18.DLR_TIP in (23, 24, 25, 26)) CCAF,

                 (select SUM(h19.DLR_MTO_PES)
                    from pensiones.detliqrv h19
                   where h19.dlr_per = l.lqr_per
                     and h19.dlr_lin = l.lqr_lin
                     and h19.dlr_prd = l.lqr_prd
                     and h19.dlr_doc = l.lqr_doc
                     and h19.dlr_pol = l.lqr_pol
                     and h19.dlr_cau = l.lqr_cau
                     and h19.dlr_grp = l.lqr_grp
                     and h19.dlr_cob = l.Lqr_Cob
                     and h19.DLR_TIP in (7, 17)) RET_JUD,

                 (select SUM(h20.DLR_MTO_PES)
                    from pensiones.detliqrv h20
                   where h20.dlr_per = l.lqr_per
                     and h20.dlr_lin = l.lqr_lin
                     and h20.dlr_prd = l.lqr_prd
                     and h20.dlr_doc = l.lqr_doc
                     and h20.dlr_pol = l.lqr_pol
                     and h20.dlr_cau = l.lqr_cau
                     and h20.dlr_grp = l.lqr_grp
                     and h20.dlr_cob = l.Lqr_Cob
                     and h20.DLR_TIP in (60)) Seguro_Pensionado,

                 (nvl((select SUM(h21.DLR_MTO_PES)
                    from pensiones.detliqrv h21
                   where h21.dlr_per = l.lqr_per
                     and h21.dlr_lin = l.lqr_lin
                     and h21.dlr_prd = l.lqr_prd
                     and h21.dlr_doc = l.lqr_doc
                     and h21.dlr_pol = l.lqr_pol
                     and h21.dlr_cau = l.lqr_cau
                     and h21.dlr_grp = l.lqr_grp
                     and h21.dlr_cob = l.Lqr_Cob
                     and h21.DLR_TIP not in (6,
                                           43,
                                           44,
                                           22,
                                           15,
                                           16,
                                           5,
                                           37,
                                           48,
                                           23,
                                           24,
                                           25,
                                           26,
                                           7,
                                           17,
                                           14,
                                           60,
                         99)
                     and h21.dlr_d_h = 'D'),0)
          +
                 nvl((SELECT SUM(d11.DSG_MTO_PES)
                    from pensiones.dsgdetrv d11, pensiones.habdes h17
                   Where d11.dsg_lin = l.lqr_lin
                     And d11.dsg_per = L.lqr_per
                     and d11.dsg_prd = l.lqr_prd
                     and d11.dsg_doc = l.lqr_doc
                     And d11.dsg_pol = l.lqr_pol
                     and d11.dsg_cau = l.lqr_cau
                     And d11.dsg_grp = l.lqr_grp
                     And d11.dsg_tipo = 14
                     And h17.hd_corr = d11.dsg_corr_hd
                     And h17.hd_per = d11.dsg_per
                     And h17.hd_tip in (1,68,93,94,78,99)),0) )

          OTROS_DSC,

                 (select SUM(h22.DLR_MTO_PES)
                    from pensiones.detliqrv h22
                   where h22.dlr_per = l.lqr_per
                     and h22.dlr_lin = l.lqr_lin
                     and h22.dlr_prd = l.lqr_prd
                     and h22.dlr_doc = l.lqr_doc
                     and h22.dlr_pol = l.lqr_pol
                     and h22.dlr_cau = l.lqr_cau
                     and h22.dlr_grp = l.lqr_grp
                     and h22.dlr_cob = l.Lqr_Cob
                     and h22.dlr_d_h = 'D') TOT_DSC,
                 LQR_LQ LIQ_PAG,
                 to_char(LQR_FEC_PAGO, 'dd/mm/yyyy') F_PAGO,

                 (select SUM(h23.DLR_MTO_PES)
                    from pensiones.detliqrv h23
                   where h23.dlr_per = l.lqr_per
                     and h23.dlr_lin = l.lqr_lin
                     and h23.dlr_prd = l.lqr_prd
                     and h23.dlr_doc = l.lqr_doc
                     and h23.dlr_pol = l.lqr_pol
                     and h23.dlr_cau = l.lqr_cau
                     and h23.dlr_grp = l.lqr_grp
                     and h23.dlr_cob = l.Lqr_Cob
                     and h23.DLR_TIP in (1, 2, 19, 49)) -
                 (select SUM(h24.DLR_MTO_PES)
                    from pensiones.detliqrv h24
                   where h24.dlr_per = l.lqr_per
                     and h24.dlr_lin = l.lqr_lin
                     and h24.dlr_prd = l.lqr_prd
                     and h24.dlr_doc = l.lqr_doc
                     and h24.dlr_pol = l.lqr_pol
                     and h24.dlr_cau = l.lqr_cau
                     and h24.dlr_grp = l.lqr_grp
                     and h24.dlr_cob = l.Lqr_Cob
                     and h24.DLR_TIP in (5, 6)) Pm_ge_aps_imp_7,
                 f.FRP_DES_DS Forma_Pago,
                 l.lqr_frm_pago,
                 k.cod_ext banco,
                 nvl(l.LQR_SUC_BCO, '') suc_bco,
                 l.LQR_CTA_BCO

                  , case when l.lqr_bco <> 0
                  then  (select p.cod_ext
                         from  pensiones.codigos p
                         where p.cod_template(+) = 'MEDIO_PAGO_BCOCHILE'
                               and p.cod_int_num(+)  = f_busca_medio_pago(l.lqr_frm_pago, l.lqr_bco))
                else ' '  end MEDIO_PAGO_BCOCHILE
                ,case pol_atrb19
                   when 1 then plq_fec_pago01
                   when 2 then plq_fec_pago02
                   when 3 then plq_fec_pago03
                   when 8 then plq_fec_pago08
                 end FECHA_PAGO_CONTRATO,

             (select SUM(h16.DLR_MTO_PES)
                    from pensiones.detliqrv h16
                   where h16.dlr_per = l.lqr_per
                     and h16.dlr_lin = l.lqr_lin
                     and h16.dlr_prd = l.lqr_prd
                     and h16.dlr_doc = l.lqr_doc
                     and h16.dlr_pol = l.lqr_pol
                     and h16.dlr_cau = l.lqr_cau
                     and h16.dlr_grp = l.lqr_grp
                     and h16.dlr_cob = l.Lqr_Cob
                     and h16.DLR_TIP = 49)  bonif_salud_mes ,
              (select SUM(h3.DLR_MTO_PES)
                    from pensiones.detliqrv h3
                   where h3.dlr_per = l.lqr_per
                     and h3.dlr_lin = l.lqr_lin
                     and h3.dlr_prd = l.lqr_prd
                     and h3.dlr_doc = l.lqr_doc
                     and h3.dlr_pol = l.lqr_pol
                     and h3.dlr_cau = l.lqr_cau
                     and h3.dlr_grp = l.lqr_grp
                     and h3.dlr_cob = l.Lqr_Cob
                     and h3.DLR_TIP in (97)
                     and h3.dlr_d_h = 'H') PGU_MES
                ,DECODE(NVL(POL_PORC_RE,0), 0,'NO', 'SI')     ES_ESCALONADA
                ,NVL(POL_PORC_RE,0)                           PORC_PEN_ESCALONADA
                ,DECODE(NVL(POL_PORC_RE,0), 0,NULL, TO_CHAR(pkg_renta_escalonada.f_calc_fin_renta(POL_FEC_INICIO, POL_MESES_RE),'DD/MM/YYYY')) FEC_TERM_ESCALONADA
          from pensiones.liqrv l
                 inner join pensiones.persnat c
                         on c.nat_id = l.lqr_cau
                 inner join pensiones.persnat r
                         on r.nat_id = l.lqr_id_recep
                 inner join pensiones.forma_pago f
                         on f.frp_cod_id = l.lqr_frm_pago
                        and f.frp_lin_id = l.lqr_lin
                 inner join pensiones.codigos k
                         on k.cod_template = 'TB01-BANCOS'
                   and k.cod_int_num  = l.lqr_bco
                       inner join pensiones.polizas
                         on pol_linea     = l.lqr_lin
                        and pol_producto  = l.lqr_prd
                        and pol_documento = l.lqr_doc
                        and pol_poliza    = l.lqr_pol
                and pol_contratante = l.lqr_cau
                 inner join pensiones.prmliqrv
                         on plq_per = l.lqr_per
                 inner join pensiones.cobertura c
                        on  lqr_cob = c.cob_codigo
                  inner join  pensiones.asegafp
                        on  asaf_linea = l.lqr_lin
                  and asaf_producto = l.lqr_prd
                  and asaf_documento = l.lqr_doc
                  and asaf_poliza = l.lqr_pol
                  and asaf_asegurado = l.lqr_cau
          where l.lqr_per      = p_periodo_new
             and l.lqr_lin      = 3
          order by 1 asc;

END SP_PRELIQ_PAGREG;
/
