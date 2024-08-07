CREATE OR REPLACE PROCEDURE pensiones."SP_CT_FECHAS_PAGO" (
                                        p_periodo_new IN INTEGER,
                                        p_fecha IN VARCHAR2,
                                        v_tabla OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN v_tabla FOR
    select campo
    from
    (select 1 num, rpad('1' ||lpad(TO_CHAR(CIA_RUT_CIA_ID), 9,0 )||
            CIA_DV_CIA||'0010409732'||to_char(sysdate, 'ddmmyyyy')||
            to_char(sysdate, 'hhmmss')|| to_char(PLQ_FEC_PAGO01, 'ddmmyyyy') ||
            '0000000000'||
            (select lpad(sum( ben ), 6,0)|| lpad(sum(nvl(monto,0)), 15,0) from
                    (select lpad(count(distinct dsg_ben ), 6,0) ben,
                            lpad(sum(nvl(lqr_lq,0)), 15,0) monto
                     from pensiones.dsgdetrv d,
                          pensiones.cartera_aps R,
                          pensiones.persnat P,
                          pensiones.liqrv g,
                          pensiones.domicilios c
                     where dsg_per= p_periodo_new
                           and dsg_tipo in ( 97,98)
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
                           and dsg_lin = cap_lin_id
                           and dsg_pol = cap_pol_id
                           and dsg_ben = cap_ben_id
                           and cap_tip_bnf_re = 8
                           and lqr_frm_pago = 20
                           and lqr_bco = 12
                          and lqr_fec_pago = to_date(to_char(trunc(to_date(p_fecha,'dd-MM-yyyy')), 'dd-MM-yyyy'), 'dd-MM-yyyy')

                    group by p.nat_numrut,p.nat_dv, p.nat_nombre,p.nat_ap_pat,p.nat_ap_mat,
                         lqr_frm_pago,lqr_bco , lqr_cta_bco ,  c.dom_e_mai_cr))
                         , 161, ' ' ) campo
    from PENSIONES.COMPANIA, pensiones.prmliqrv
    where CIA_VIGENCIA = 'S'
    and plq_per =  p_periodo_new
    union
    select  2 num,rPad('2' || LPad(replace(replace(p.nat_numrut,'-', ''), '.', ''), 9, 0)||
            p.nat_dv ||RPAD(p.nat_nombre,30, ' ') ||
            RPAD(p.nat_ap_pat,15, ' ') || RPAD(nvl(p.nat_ap_mat,' '),15, ' ') ||
           '29'
                                                   ||LPAD(nvl(lqr_bco, 0), 3, 0)||
            lpad(nvl(replace(replace(lqr_cta_bco,'-', ''), '.', ''),0),17,0)||
                                    lpad(nvl(sum(lqr_lq) ,0),13,0) ||
            RPAD(nvl(c.dom_e_mai_cr,' '), 40), 366, ' ' )||
            rpad('Periodo',27) ||
            LPAD(nvl(substr(lqr_per,5,2)||substr(lqr_per,1,4), ''), 8, ' ') ||
            'N' ||
            rpad('Poliza',27) ||
            LPAD(nvl(lqr_pol, ''), 8, ' ') ||
            'N' ||
            rpad('Pension mas PGU',27) ||
            (select lpad(SUM(nvl(DSG_MTO_PES,0)), 8, ' ')
               from pensiones.dsgdetrv
              where dsg_per = p_periodo_new
                and  lqr_lin = dsg_lin
                and  lqr_prd = dsg_prd
                and  lqr_doc = dsg_doc
                and  lqr_pol = dsg_pol
                and  lqr_cau = dsg_cau
                and  dsg_ben = cap_ben_id
                and  dsg_tipo in (1,97))   ||
            'N' ||
            rpad('Total Haberes',27) ||
            lpad(SUM(nvl(lqr_tot_hab,0)), 8, ' ') ||
            'N' ||
            rpad('Total Desctos',27) ||
            lpad(SUM(nvl(lqr_tot_dsc,0)) , 8, ' ') ||
            'N' ||
            rpad('Liquido IPS mas Confuturo',27) ||
            lpad(nvl(sum(lqr_lq),0) + (select  nvl(SUM(DSG_MTO_PES),0)
               from pensiones.dsgdetrv
               where dsg_per  =p_periodo_new
                and  lqr_lin  = dsg_lin
                and  lqr_prd  = dsg_prd
                and  lqr_doc  = dsg_doc
                and  lqr_pol  = dsg_pol
                and  lqr_cau  = dsg_cau
                and  dsg_tipo = 99
                ), 8, ' ') ||
            'N' ||
            rpad('Pago PGU IPS',27) ||
            (select lpad(SUM(nvl(DSG_MTO_PES,0)), 8, ' ')
               from pensiones.dsgdetrv
               where dsg_per =p_periodo_new
                and  lqr_lin = dsg_lin
                and  lqr_prd = dsg_prd
                and  lqr_doc = dsg_doc
                and  lqr_pol = dsg_pol
                and  lqr_cau = dsg_cau
                and  dsg_ben = cap_ben_id
                and  dsg_tipo in (99))   ||
            'N    ' campo
    from    pensiones.cartera_aps R,
            pensiones.persnat P,
            pensiones.LIQRV g,
            pensiones.domicilios c
    where lqr_per      = p_periodo_new
     and lqr_id_recep       = nat_id
     and lqr_lin       = 3
     and lqr_id_dom    = dom_id_dom
     and lqr_lin       = cap_lin_id
     and lqr_pol       = cap_pol_id
     and cap_tip_bnf_re = 8
     and lqr_frm_pago  = 20
     and lqr_bco       =  12
     and lqr_fec_pago  = to_date(to_char(trunc(to_date(p_fecha,'dd-MM-yyyy')), 'dd-MM-yyyy'), 'dd-MM-yyyy')
    group by p.nat_numrut,p.nat_dv, p.nat_nombre, p.nat_ap_pat, p.nat_ap_mat, lqr_frm_pago ,lqr_bco, lqr_cta_bco , c.dom_e_mai_cr
            ,lqr_lin, lqr_prd, lqr_doc, lqr_pol, lqr_cau, cap_ben_id, lqr_per)
    order by campo;

END SP_CT_FECHAS_PAGO;
/
