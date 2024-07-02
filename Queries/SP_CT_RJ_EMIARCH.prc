CREATE OR REPLACE PROCEDURE pensiones."SP_CT_RJ_EMIARCH" (
                                                      p_periodo_new CT_LIQRV.LQR_PER%TYPE,
                                                      v_tabla OUT SYS_REFCURSOR)
IS

BEGIN
     OPEN v_tabla FOR
          select campo
          from
          (select 1 num, rpad('1' ||lpad(TO_CHAR(CIA_RUT_CIA_ID), 9,0 )||
                  CIA_DV_CIA||'0010406604'||to_char(sysdate, 'ddmmyyyy')||
                  to_char(sysdate, 'hhmmss')|| to_char(add_months(PLQ_FEC_PAGO01,1), 'ddmmyyyy') ||
                  '0000000000'||
                  (select lpad(sum( ben ), 6,0)|| lpad(sum(nvl(monto,0)), 15,0) from
                          (select lpad(count(distinct dsg_ben ), 6,0) ben,
                                  lpad(sum(nvl(dsg_mto_pes,0)), 15,0) monto
                           from pensiones.ct_dsgdetrv d,pensiones.retjud R, pensiones.persnat P,
                                pensiones.ct_liqrv g, pensiones.domicilios c
                           where dsg_per= p_periodo_new
                                 and dsg_tipo in (7,17)
                                 and dsg_ben = nat_id
                                 and dsg_lin = 3
                                 and dsg_grp = lqr_grp
                                 and lqr_lin = dsg_lin
                                 and lqr_prd = dsg_prd
                                 and lqr_doc = dsg_doc
                                 and lqr_pol = dsg_pol
                                 and lqr_cau = dsg_cau
                                 and lqr_per = dsg_per
                                 and lqr_id_dom = dom_id_dom
                                 and dsg_lin = rj_lin
                                 and dsg_prd = rj_prd
                                 and dsg_pol = rj_pol
                                 and dsg_cau = rj_cau
                                 and dsg_ben = rj_ben
                                 and rj_frm_pag_nn in (6,7)
                                 and dsg_corr_hd = rj_corr
                                 and rj_vig = 1
                          and RJ_BCO_NN = '012'
                          group by p.nat_numrut,p.nat_dv, p.nat_nombre,p.nat_ap_pat,p.nat_ap_mat,
                               rj_frm_pag_nn,rj_bco_nn, rj_cta_cr,  c.dom_e_mai_cr))
                               , 74, ' ' ) campo
          from PENSIONES.COMPANIA, pensiones.prmliqrv
          where CIA_VIGENCIA = 'S'
          and plq_per = to_number(to_char(add_months(to_date(to_char(p_periodo_new)||'01','yyyymmdd'),-1),'yyyymm'))
          union
          select  2 num,rPad('2' || LPad(replace(replace(p.nat_numrut,'-', ''), '.', ''), 9, 0)||
                  p.nat_dv ||RPAD(p.nat_nombre,30, ' ') ||
                  RPAD(p.nat_ap_pat,15, ' ') || RPAD(nvl(p.nat_ap_mat,' '),15, ' ') ||
                  lpad(nvl(decode(rj_frm_pag_nn, 6,1,2),0),2,0)
                ||LPAD(nvl(rj_bco_nn, 0), 3, 0)||
                  lpad(nvl(replace(replace(rj_cta_cr,'-', ''), '.', ''),0),17,0)||
                 lpad(nvl(sum(d.dsg_mto_pes) ,0),13,0) ||
                  RPAD(nvl(c.dom_e_mai_cr,' '), 40)||
                  '0'
                  , 622, ' ' ) campo
          from pensiones.ct_dsgdetrv d,
               pensiones.retjud R,
              pensiones.persnat P,
              pensiones.ct_LIQRV g,
              pensiones.domicilios c
           where dsg_per= p_periodo_new
                 and dsg_tipo in (7,17)
                 and rj_id_ben_rj = nat_id
                 and dsg_lin = 3
                 and dsg_grp = lqr_grp
                 and lqr_lin = dsg_lin
                 and lqr_prd = dsg_prd
                 and lqr_doc = dsg_doc
                 and lqr_pol = dsg_pol
                 and lqr_cau = dsg_cau
                 and lqr_per = dsg_per
                 and lqr_id_dom = dom_id_dom
                 and dsg_lin = rj_lin
                 and dsg_prd = rj_prd
                 and dsg_pol = rj_pol
                 and dsg_cau = rj_cau
                 and dsg_ben = rj_ben
                 and rj_frm_pag_nn in (6,7)
                 and dsg_corr_hd= rj_corr
                 and rj_vig = 1
                 and RJ_BCO_NN = '012'
            group by p.nat_numrut,p.nat_dv, p.nat_nombre,p.nat_ap_pat,p.nat_ap_mat, rj_frm_pag_nn,rj_bco_nn, rj_cta_cr, c.dom_e_mai_cr
           )
          order by campo;

END SP_CT_RJ_EMIARCH;
/
