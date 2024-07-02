CREATE OR REPLACE PROCEDURE "SP_CT_GENARCH_DATOS_PGU" ( p_periodo IN NUMBER,
                                               p_cod_error     out number,
                                               p_msj_error     out varchar2 )
IS
/*************************************************************************
Sistema           : PENSIONES
Subsistema        : Liquidación de Pensiones - PGU
Objetivo          : Genera Archivo Plano / EXCEL  PGU
************************************************************************/
         v_pol                    NUMBER(7);
        v_cau                    number(9);
        v_ben                    number(9);
        v_recep                  number(9);
        v_prd                    number(3);
        v_grp_pag                NUMBER(3);
        ll_periodo                number(06);
        ll_cont                   number;
        v_cob                     number(3);
        ll_frm_pago               number;
        ll_mto_pre_liq            number(8);
        ll_i                      number(8);
        ll_nro_cta_bco            varchar2(25);
        ll_id_dom                 number;
        ll_bco                    number;
        vs_ap_mat_ben             varchar2(22);

        v_periodo      VARCHAR2(6);
        v_rut_emp      VARCHAR2(8);
        v_dv_emp       VARCHAR2(1);
        v_rut_ben      VARCHAR2(8);
        v_dv_ben       VARCHAR2(1);
        v_ap_pat_ben   VARCHAR2(20);
        v_ap_mat_ben   VARCHAR2(20);
        v_nomb_ben     VARCHAR2(30);
        v_dom_ben      VARCHAR2(45);
        v_comuna_ben   VARCHAR2(5);
        v_ciudad_ben   VARCHAR2(20);
        v_region_ben   VARCHAR2(2);
        v_telef1       VARCHAR2(9);
        v_telef2       VARCHAR2(9);
        v_email        VARCHAR2(45);
        v_fec_pago     VARCHAR2(8);
        v_frm_pago     VARCHAR2(2);
        v_mod_pago     VARCHAR2(2);
        v_rut_ent_pag  VARCHAR2(8);
        v_dv_ent_pag   VARCHAR2(1);
        v_com_ent_pag   VARCHAR2(5);
        v_reg_ent_pag   VARCHAR2(2);
        v_cta_ban_ben   VARCHAR2(2);
        v_nro_cta_ben   VARCHAR2(18);
        v_cob_mandato   VARCHAR2(2);
        v_rut_manda     VARCHAR2(8);
        v_dv_manda      VARCHAR2(1);
        v_ap_pat_manda  VARCHAR2(20);
        v_ap_mat_manda  VARCHAR2(20);
        v_nombre_manda  VARCHAR2(30);
        v_domi_manda     VARCHAR2(45);
        v_comuna_manda  VARCHAR2(5);
        v_ciudad_manda  VARCHAR2(20);
        v_region_manda  VARCHAR2(2);
        v_cod_ent_banca VARCHAR2(3);
        v_tip_cta_manda VARCHAR2(2);
        v_nto_cta_manda VARCHAR2(18);
        v_fec_ult_pag  VARCHAR2(8);
        v_prox_fec_pago VARCHAR2(8);
        v_tot_desctos  VARCHAR2(8);
        v_ent_bca_ben  varchar2(3);

        v_rut_ent_traspaso varchar2(08) := '00000000';
        v_dv_ent_traspaso varchar2(01) := ' ';


  --  run_id number;  /*  Variable para implementacion dbms_profiler*/

   CURSOR obt_ct_liqrv IS
           SELECT distinct
             lq.lqr_per,
             lq.lqr_pol,
             lq.lqr_grp,
             lq.lqr_prd,
             lq.lqr_cau,
             lq.lqr_cob,
             to_char(to_number(ltrim(nvl(replace(translate(lq.LQR_CTA_BCO, 'EK.-', ' '),' ',''),'0')))) LQR_CTA_BCO,
             lq.LQR_FRM_PAGO,
             lq.lqr_id_dom,
             d1.dsg_ben,
             lqr_id_recep ,
             to_char(lqr_fec_pago, 'yyyymmdd') fecpag_contrib,
             case pol_atrb19
                  when 1 then to_char(plq_fec_pago05, 'yyyymmdd')
                  when 2 then to_char(plq_fec_pago06, 'yyyymmdd')
                  when 3 then to_char(plq_fec_pago07, 'yyyymmdd')
                  when 8 then to_char(plq_fec_pago09, 'yyyymmdd') end fecprox_pago,
             case when lq.lqr_bco = 33 or lq.lqr_bco = 29  then 1
                  when lq.lqr_bco = 35 or lq.lqr_bco = 8 or lq.lqr_bco = 10 or lq.lqr_bco = 43 then 37
                  when lq.lqr_bco = 733 or lq.lqr_bco = 27 then 39
                  when lq.lqr_bco = 504 or lq.lqr_bco = 507  then 14
                  else lq.lqr_bco  end bco,
             (select nvl(sum(pgu_pre_mto_des_ips),0)
             from pensiones.pgu_preliq_ips
              where pgu_pre_per  = lq.lqr_per
                    and pgu_pre_lin = lq.lqr_lin
                    and pgu_pre_doc = lq.lqr_doc
                    and pgu_pre_prod = lq.lqr_prd
                    and pgu_pre_pol = lq.lqr_pol
                    and pgu_pre_cau = lq.lqr_cau
                    and pgu_pre_ben = d1.dsg_ben )
                      mto_pre
      from pensiones.polizas,
           pensiones.liqrv lq,
           pensiones.dsgdetrv d1,
           pensiones.prmliqrv
      where pol_linea = 3
            and pol_linea = lqr_lin
            and pol_producto = lqr_prd
            and pol_documento = lqr_doc
            and pol_poliza = lqr_pol
            and pol_contratante = lqr_cau
            and lq.lqr_per = ll_periodo
            and lq.lqr_per  = d1.dsg_per
            and lq.lqr_lin = d1.dsg_lin
            and lq.lqr_prd = d1.dsg_prd
            and lq.lqr_doc = d1.dsg_doc
            and lq.lqr_pol = d1.dsg_pol
            and lq.lqr_cau = d1.dsg_cau
            and lq.lqr_grp = d1.dsg_grp
            and d1.dsg_tipo in (97,98)
            and lq.lqr_per = plq_per
            and (select  count(*)
                from pensiones.transferencias_aps
                where tfc_per_pe = d1.dsg_per
                      and tfc_cau_no_env_trans = 12
                      and tfc_lin_nn = d1.dsg_lin
                      and tfc_pol_nn = d1.dsg_pol
                      and tfc_ben_nn = d1.dsg_ben
                      and tfc_tip_benef = 8
                      and tfc_per_pago  = d1.dsg_per
                      --12/2022 and tfc_tip_pago = 1
                      ) > 0  ;
/*27-12-2022
   CURSOR obt_ct_mte IS
        select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               tfc_ben_nn,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans in (2,6)
               and tfc_tip_benef = 8
               and tfc_lin_nn = bnf_linea
               and tfc_pol_nn = bnf_poliza
               and tfc_ben_nn = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_beneficiario = grp_id_grupo
               and bnf_grp_pag = grp_grupo
               and bnf_cobertura = 1
        union
        select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               tfc_ben_nn,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans in (2,6)
               and tfc_tip_benef = 8
               and tfc_lin_nn = bnf_linea
               and tfc_pol_nn = bnf_poliza
               and tfc_ben_nn = bnf_causante
               and bnf_causante = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_cobertura <> 1
               and grp_grupo = 0;
               */

   CURSOR obt_ct_mte IS
        select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               tfc_ben_nn ben_id,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans in (2,6)
               and tfc_tip_benef = 8
               and tfc_pol_nn <> 0
               and tfc_lin_nn = bnf_linea
               and tfc_pol_nn = bnf_poliza
               and tfc_ben_nn = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_beneficiario = grp_id_grupo
               and bnf_grp_pag = grp_grupo
               and bnf_cobertura = 1
        union
        select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               tfc_ben_nn ben_id,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans in (2,6)
               and tfc_tip_benef = 8
               and tfc_pol_nn <> 0
               and tfc_lin_nn = bnf_linea
               and tfc_pol_nn = bnf_poliza
               and tfc_ben_nn = bnf_causante
               and bnf_causante = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_cobertura <> 1
               and grp_grupo = 0
        union
        select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               cap_ben_id ben_id, --tfc_ben_nn,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago,
              pensiones.persnat,
              pensiones.cartera_aps
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans in (2,6)
               and tfc_tip_benef = 8
               and tfc_pol_nn = 0
               and tfc_rut_nn = nat_numrut
               and nat_id = cap_ben_id
               and cap_tip_bnf_re = 8
               and tfc_lin_nn = bnf_linea
--               and tfc_pol_nn = bnf_poliza
--               and tfc_ben_nn = bnf_beneficiario
               and cap_pol_id = bnf_poliza
               and cap_ben_id = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_beneficiario = grp_id_grupo
               and bnf_grp_pag = grp_grupo
               and bnf_cobertura = 1
        union
        select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               cap_ben_id ben_id, --tfc_ben_nn,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago,
              pensiones.persnat,
              pensiones.cartera_aps
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans in (2,6)
               and tfc_tip_benef = 8
               and tfc_pol_nn = 0
               and tfc_rut_nn = nat_numrut
               and nat_id = cap_ben_id
               and cap_tip_bnf_re = 8
               and tfc_lin_nn = bnf_linea
--               and tfc_pol_nn = bnf_poliza
--               and tfc_ben_nn = bnf_causante
               and cap_pol_id = bnf_poliza
               and cap_ben_id = bnf_beneficiario

               and bnf_causante = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_cobertura <> 1
               and grp_grupo = 0;

--cau_no_env_trans = 5 incorporado 12/2022
   CURSOR obt_ct_sus IS
           SELECT distinct
             lq.lqr_per,
             lq.lqr_pol,
             lq.lqr_grp,
             lq.lqr_prd,
             lq.lqr_cau,
             lq.lqr_cob,
             to_char(to_number(ltrim(nvl(replace(translate(lq.LQR_CTA_BCO, 'EK.-', ' '),' ',''),'0')))) LQR_CTA_BCO,
             lq.LQR_FRM_PAGO,
             lq.lqr_id_dom,
             d1.dsg_ben,
             lqr_id_recep ,
             to_char(lqr_fec_pago, 'yyyymmdd') fecpag_contrib,
             case pol_atrb19
                  when 1 then to_char(plq_fec_pago05, 'yyyymmdd')
                  when 2 then to_char(plq_fec_pago06, 'yyyymmdd')
                  when 3 then to_char(plq_fec_pago07, 'yyyymmdd')
                  when 8 then to_char(plq_fec_pago09, 'yyyymmdd') end fecprox_pago,
             case when lq.lqr_bco = 33 or lq.lqr_bco = 29  then 1
                  when lq.lqr_bco = 35 or lq.lqr_bco = 8 or lq.lqr_bco = 10 or lq.lqr_bco = 43 then 37
                  when lq.lqr_bco = 733 or lq.lqr_bco = 27 then 39
                  when lq.lqr_bco = 504 or lq.lqr_bco = 507  then 14
                  else lq.lqr_bco  end bco,
             (select nvl(sum(pgu_pre_mto_des_ips),0)
             from pensiones.pgu_preliq_ips
              where pgu_pre_per  = lq.lqr_per
                    and pgu_pre_lin = lq.lqr_lin
                    and pgu_pre_doc = lq.lqr_doc
                    and pgu_pre_prod = lq.lqr_prd
                    and pgu_pre_pol = lq.lqr_pol
                    and pgu_pre_cau = lq.lqr_cau
                    and pgu_pre_ben = d1.dsg_ben )
                      mto_pre
      from pensiones.polizas,
           pensiones.liqrv lq,
           pensiones.dsgdetrv d1,
           pensiones.prmliqrv,
           pensiones.cartera_aps
      where pol_linea = 3
        and pol_linea = lqr_lin
        and pol_producto = lqr_prd
        and pol_documento = lqr_doc
        and pol_poliza = lqr_pol
        and pol_contratante = lqr_cau
        and lq.lqr_per = ll_periodo
        and lq.lqr_per = d1.dsg_per
        and lq.lqr_lin = d1.dsg_lin
        and lq.lqr_prd = d1.dsg_prd
        and lq.lqr_doc = d1.dsg_doc
        and lq.lqr_pol = d1.dsg_pol
        and lq.lqr_cau = d1.dsg_cau
        and lq.lqr_grp = d1.dsg_grp
        -- and d1.dsg_tipo in (97,98)
        and lq.lqr_per = plq_per
        and lq.lqr_pol = cap_pol_id
        and d1.dsg_ben = cap_ben_id
        and (select  count(*)
             from pensiones.transferencias_aps, pensiones.persnat
             where tfc_per_pe          = d1.dsg_per
              and tfc_cau_no_env_trans = 5
              and tfc_tip_benef        = 8
              and tfc_rut_nn           = nat_numrut
              and nat_id               = d1.dsg_ben
              and d1.dsg_tipo          = 1
              ) > 0  ;

/*abril/2023
   CURSOR obt_ct_sus IS
         select distinct
               bnf_poliza ,
               bnf_grp_pag ,
               bnf_producto ,
               bnf_causante ,
               bnf_cobertura ,
               cap_ben_id,--tfc_ben_nn,
               grp_id_dom
         from pensiones.transferencias_aps,
              pensiones.beneficios,
              pensiones.grupopago,
              pensiones.persnat,
              pensiones.cartera_aps
         where tfc_per_pe = ll_periodo
               and tfc_cau_no_env_trans = 5
               and tfc_tip_benef = 8
               and tfc_lin_nn = bnf_linea
               and tfc_rut_nn = nat_numrut
               and nat_id = cap_ben_id
               and cap_est_ta = 'SUS'
               and cap_tip_bnf_re = 8
               and cap_pol_id = bnf_poliza
               and cap_ben_id = bnf_beneficiario
               and bnf_linea = grp_linea
               and bnf_producto = grp_producto
               and bnf_documento = grp_documento
               and bnf_poliza = grp_poliza
               and bnf_causante = grp_asegurado
               and bnf_cobertura <> 1
               and grp_grupo = 0;
*/               

BEGIN
/* Ejecucion de profiler para verificacion  de  comportamiento */
 --  run_id := dbms_profiler.start_profiler(  'Informe PGU ' || to_char(sysdate,'DD-MM-YYYY HH24:MI:SS'));
/*  Dbms_profiler */

      ll_periodo := p_periodo;
      p_cod_error  := 0;
      p_msj_error  := 0;
      ll_i          := 0;

      begin
        delete PENSIONES.PGU_DATOS_PAGO_PERIODO
        where pdp_periodo = ll_periodo;
      exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' Borrando pgu_datos_pago_periodo  : ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
      end;
      commit;

      begin
          /*rut entidad pension en regimen*/
           select lpad(nvl(cia_rut_cia_id,0),8,'0'),
                  upper(rpad(nvl( cia_dv_cia ,' '),1))
           into   v_rut_emp,v_dv_emp
           from pensiones.compania
           where cia_vigencia = 'S';
       exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' Buscando compania  : ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
        end;

       select to_char(lpad(nvl(ll_periodo ,0),6,'0'))
       into v_periodo
       from dual;

   /*    insert into pensiones.tmp_proceso_log( tpl_accion,   tpl_fecha_log  )
        values('comienza carga', sysdate);
        commit;*/

       FOR c_obt_ct_mte IN obt_ct_mte LOOP
           v_pol  := c_obt_ct_mte.bnf_poliza ;
           v_grp_pag :=  c_obt_ct_mte.bnf_grp_pag;
           v_cau :=c_obt_ct_mte.bnf_causante;
           v_prd := c_obt_ct_mte.bnf_producto;
           v_ben := c_obt_ct_mte.ben_id;--c_obt_ct_mte.tfc_ben_nn;
           v_cob := c_obt_ct_mte.bnf_cobertura;
           ll_id_dom := c_obt_ct_mte.grp_id_dom;

           select to_char(lpad(nvl(pb.nat_numrut ,0),8,'0')) ,
              upper(rpad(nvl( pb.nat_dv,' '),1)) ,
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_pat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_mat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_nombre, ' ' )),30)),
              pb.nat_ap_mat
          into v_rut_ben, v_dv_ben, v_ap_pat_ben, v_ap_mat_ben, v_nomb_ben,
              vs_ap_mat_ben
           from pensiones.persnat pb
           where pb.nat_id = v_ben;

           if v_ap_mat_ben is null or v_ap_mat_ben = '' or  vs_ap_mat_ben like  '%.%' then
              v_ap_mat_ben := '                    ';
           end if ;

           select upper(rpad(F_LIMPIA_CARACTER(nvl(db.dom_direccion, ' ')),45)) ,
              case when ll_frm_pago = 19 then '00000'
                   else lpad(nvl(db.dom_cod_com_ta ,0),5,'0')  end  ,
              upper(rpad(F_LIMPIA_CARACTER(db.dom_ciudad),20)),
              case when ll_frm_pago = 19 then '00'
                   else
                      case when length(nvl(db.dom_cod_com_ta,0)) = 4 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,1),0),2,'0')
                           when length(nvl(db.dom_cod_com_ta,0)) = 5 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,2),0),2,'0')
                           else '00' end   end ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_1),9) ,0),9,'0')) ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_2),9) ,0),9,'0')) ,

              case when db.dom_e_mai_cr LIKE '%@%' then
                   upper(rpad(REPLACE(REPLACE(REPLACE(REPLACE(translate(ltrim(rtrim(db.dom_e_mai_cr)), 'ÁÉÍÓÚáéíóúÑñ°#', 'AEIOUaeiouNn N'),CHR(27),' '), CHR(0),NULL), CHR(9),NULL), CHR(13),NULL),45))
              else  '                                             ' end

            into v_dom_ben, v_comuna_ben, v_ciudad_ben, v_region_ben, v_telef1, v_telef2, v_email
            from pensiones.domicilios  db
            where dom_id_dom = ll_id_dom;

          if v_dom_ben is null or v_dom_ben = '' then
             v_dom_ben := '                                             ' ;
          end if;

          if v_ciudad_ben is null or v_ciudad_ben = '' then
             v_ciudad_ben := '                    ';
          end if ;

          if v_telef1 = '999999999' or v_telef1 = 'NO TIENE' then
            v_telef1 := '000000000';
          end if;

          if v_telef2 = '999999999' or v_telef2 = 'NO TIENE' then
            v_telef2 := '000000000';
          end if;

          if v_email is  null or v_email  = 'NO TIENE' then
             v_email := '                                             ';
          end if;

          v_fec_ult_pag := '00000000' ;
          v_fec_pago := '00000000' ;
          v_prox_fec_pago := '00000000' ;
          v_frm_pago :='00';
          v_mod_pago :='00';
          v_rut_manda := '00000000';
          v_dv_manda  :=' ';
          v_rut_ent_pag :='00000000';
          v_dv_ent_pag := ' ';
          v_com_ent_pag:='00000';
          v_reg_ent_pag:='00';
          v_cta_ban_ben:='00';
          v_nro_cta_ben  := '000000000000000000';
          v_nto_cta_manda:= '000000000000000000';
          v_cob_mandato :='02';
          v_ap_pat_manda := '                    ' ;
          v_ap_mat_manda := '                    ' ;
          v_nombre_manda := '                              ' ;
          v_domi_manda := '                                             ' ;
          v_comuna_manda := '00000' ;
          v_ciudad_manda := '                    ';
          v_region_manda := '00' ;
          v_cod_ent_banca := '000';
          v_ent_bca_ben:= '000';
          v_tip_cta_manda :='00';
          v_tot_desctos:= '00000000';

           Begin
             insert into PENSIONES.pgu_datos_pago_periodo
              (pdp_periodo,pdp_poliza, pdp_grp_pago, pdp_rut_emp, pdp_dv_emp, pdp_rut_ben, pdp_dv_ben, pdp_ap_pat_ben, pdp_ap_mat_ben, pdp_nomb_ben,
              pdp_dom_ben, pdp_comuna_ben, pdp_ciudad_ben, pdp_region_ben, pdp_telef1, pdp_telef2, pdp_email, pdp_frm_pago, pdp_mod_pago,
              pdp_rut_ent_pag, pdp_dv_ent_pag, pdp_com_ent_pag, pdp_reg_ent_pag, pdp_cta_ban_ben, pdp_nro_cta_ben, pdp_cob_mandato, pdp_rut_manda,
              pdp_dv_manda, pdp_ap_pat_manda, pdp_ap_mat_manda, pdp_nombre_manda, pdp_domi_manda, pdp_comuna_manda, pdp_ciudad_manda, pdp_region_manda,
              pdp_cod_ent_banca, pdp_tip_cta_manda, pdp_nro_cta_manda, pdp_tot_desctos, pdp_fecpag_contrib, pdp_fecprox_pago,
              pdp_ent_banca_ben, pdp_prd,pdp_cau, pdp_cob,pdp_lqr_frm_pago, pdp_ben, pdp_fec_pago, pdp_estado_pago,
              pdp_rut_ent_traspaso, pdp_dv_ent_traspaso)
              values( v_periodo,v_pol,v_grp_pag, v_rut_emp,v_dv_emp ,v_rut_ben,v_dv_ben,v_ap_pat_ben,v_ap_mat_ben,v_nomb_ben ,
              v_dom_ben ,v_comuna_ben ,v_ciudad_ben,v_region_ben,v_telef1,v_telef2 ,v_email  ,v_frm_pago ,v_mod_pago  ,
              v_rut_ent_pag,v_dv_ent_pag  ,v_com_ent_pag  ,v_reg_ent_pag ,v_cta_ban_ben ,v_nro_cta_ben ,v_cob_mandato ,v_rut_manda,
              v_dv_manda,v_ap_pat_manda ,v_ap_mat_manda ,v_nombre_manda ,v_domi_manda  ,v_comuna_manda ,v_ciudad_manda ,v_region_manda ,
              v_cod_ent_banca,v_tip_cta_manda,v_nto_cta_manda ,v_tot_desctos ,v_fec_pago, v_prox_fec_pago ,
              v_ent_bca_ben,v_prd,v_cau,v_cob, ll_frm_pago, v_ben, v_fec_ult_pag, '02',
              v_rut_ent_traspaso, v_dv_ent_traspaso);

            exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' insertando pgu_datos_pago_periodo mte: ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
            end;
      END LOOP;
      commit;


/*abril/2023
       FOR c_obt_ct_sus IN obt_ct_sus LOOP
           v_pol  := c_obt_ct_sus.bnf_poliza ;
           v_grp_pag :=  c_obt_ct_sus.bnf_grp_pag;
           v_cau :=c_obt_ct_sus.bnf_causante;
           v_prd := c_obt_ct_sus.bnf_producto;
--           v_ben := c_obt_ct_sus.tfc_ben_nn;
           v_ben := c_obt_ct_sus.cap_ben_id;
           v_cob := c_obt_ct_sus.bnf_cobertura;
           ll_id_dom := c_obt_ct_sus.grp_id_dom;

           select to_char(lpad(nvl(pb.nat_numrut ,0),8,'0')) ,
              upper(rpad(nvl( pb.nat_dv,' '),1)) ,
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_pat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_mat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_nombre, ' ' )),30)),
              pb.nat_ap_mat
          into v_rut_ben, v_dv_ben, v_ap_pat_ben, v_ap_mat_ben, v_nomb_ben,
              vs_ap_mat_ben
           from pensiones.persnat pb
           where pb.nat_id = v_ben;

           if v_ap_mat_ben is null or v_ap_mat_ben = '' or  vs_ap_mat_ben like  '%.%' then
              v_ap_mat_ben := '                    ';
           end if ;

           select upper(rpad(F_LIMPIA_CARACTER(nvl(db.dom_direccion, ' ')),45)) ,
              case when ll_frm_pago = 19 then '00000'
                   else lpad(nvl(db.dom_cod_com_ta ,0),5,'0')  end  ,
              upper(rpad(F_LIMPIA_CARACTER(db.dom_ciudad),20)),
              case when ll_frm_pago = 19 then '00'
                   else
                      case when length(nvl(db.dom_cod_com_ta,0)) = 4 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,1),0),2,'0')
                           when length(nvl(db.dom_cod_com_ta,0)) = 5 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,2),0),2,'0')
                           else '00' end   end ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_1),9) ,0),9,'0')) ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_2),9) ,0),9,'0')) ,

              case when db.dom_e_mai_cr LIKE '%@%' then
                   upper(rpad(REPLACE(REPLACE(REPLACE(REPLACE(translate(ltrim(rtrim(db.dom_e_mai_cr)), 'ÁÉÍÓÚáéíóúÑñ°#', 'AEIOUaeiouNn N'),CHR(27),' '), CHR(0),NULL), CHR(9),NULL), CHR(13),NULL),45))
              else  '                                             ' end

            into v_dom_ben, v_comuna_ben, v_ciudad_ben, v_region_ben, v_telef1, v_telef2, v_email
            from pensiones.domicilios  db
            where dom_id_dom = ll_id_dom;

          if v_dom_ben is null or v_dom_ben = '' then
             v_dom_ben := '                                             ' ;
          end if;

          if v_ciudad_ben is null or v_ciudad_ben = '' then
             v_ciudad_ben := '                    ';
          end if ;

          if v_telef1 = '999999999' or v_telef1 = 'NO TIENE' then
            v_telef1 := '000000000';
          end if;

          if v_telef2 = '999999999' or v_telef2 = 'NO TIENE' then
            v_telef2 := '000000000';
          end if;

          if v_email is  null or v_email  = 'NO TIENE' then
             v_email := '                                             ';
          end if;

          v_fec_ult_pag := '00000000' ;
          v_fec_pago := '00000000' ;
          v_prox_fec_pago := '00000000' ;
          v_frm_pago :='00';
          v_mod_pago :='00';
          v_rut_manda := '00000000';
          v_dv_manda  :=' ';
          v_rut_ent_pag :='00000000';
          v_dv_ent_pag := ' ';
          v_com_ent_pag:='00000';
          v_reg_ent_pag:='00';
          v_cta_ban_ben:='00';
          v_nro_cta_ben  := '000000000000000000';
          v_nto_cta_manda:= '000000000000000000';
          v_cob_mandato :='02';
          v_ap_pat_manda := '                    ' ;
          v_ap_mat_manda := '                    ' ;
          v_nombre_manda := '                              ' ;
          v_domi_manda := '                                             ' ;
          v_comuna_manda := '00000' ;
          v_ciudad_manda := '                    ';
          v_region_manda := '00' ;
          v_cod_ent_banca := '000';
          v_ent_bca_ben:= '000';
          v_tip_cta_manda :='00';
          v_tot_desctos:= '00000000';

           Begin
             insert into PENSIONES.pgu_datos_pago_periodo
              (pdp_periodo,pdp_poliza, pdp_grp_pago, pdp_rut_emp, pdp_dv_emp, pdp_rut_ben, pdp_dv_ben, pdp_ap_pat_ben, pdp_ap_mat_ben, pdp_nomb_ben,
              pdp_dom_ben, pdp_comuna_ben, pdp_ciudad_ben, pdp_region_ben, pdp_telef1, pdp_telef2, pdp_email, pdp_frm_pago, pdp_mod_pago,
              pdp_rut_ent_pag, pdp_dv_ent_pag, pdp_com_ent_pag, pdp_reg_ent_pag, pdp_cta_ban_ben, pdp_nro_cta_ben, pdp_cob_mandato, pdp_rut_manda,
              pdp_dv_manda, pdp_ap_pat_manda, pdp_ap_mat_manda, pdp_nombre_manda, pdp_domi_manda, pdp_comuna_manda, pdp_ciudad_manda, pdp_region_manda,
              pdp_cod_ent_banca, pdp_tip_cta_manda, pdp_nro_cta_manda, pdp_tot_desctos, pdp_fecpag_contrib, pdp_fecprox_pago,
              pdp_ent_banca_ben, pdp_prd,pdp_cau, pdp_cob,pdp_lqr_frm_pago, pdp_ben, pdp_fec_pago, pdp_estado_pago,
              pdp_rut_ent_traspaso, pdp_dv_ent_traspaso)
              values( v_periodo,v_pol,v_grp_pag, v_rut_emp,v_dv_emp ,v_rut_ben,v_dv_ben,v_ap_pat_ben,v_ap_mat_ben,v_nomb_ben ,
              v_dom_ben ,v_comuna_ben ,v_ciudad_ben,v_region_ben,v_telef1,v_telef2 ,v_email  ,v_frm_pago ,v_mod_pago  ,
              v_rut_ent_pag,v_dv_ent_pag  ,v_com_ent_pag  ,v_reg_ent_pag ,v_cta_ban_ben ,v_nro_cta_ben ,v_cob_mandato ,v_rut_manda,
              v_dv_manda,v_ap_pat_manda ,v_ap_mat_manda ,v_nombre_manda ,v_domi_manda  ,v_comuna_manda ,v_ciudad_manda ,v_region_manda ,
              v_cod_ent_banca,v_tip_cta_manda,v_nto_cta_manda ,v_tot_desctos ,v_fec_pago, v_prox_fec_pago ,
              v_ent_bca_ben,v_prd,v_cau,v_cob, ll_frm_pago, v_ben, v_fec_ult_pag, '03',
              v_rut_ent_traspaso, v_dv_ent_traspaso);

            exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' insertando pgu_datos_pago_periodo sus: ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
            end;
      END LOOP;
      commit;
*/
--tls

       FOR c_obt_ct_sus IN obt_ct_sus LOOP
           v_pol  := c_obt_ct_sus.lqr_pol ;
           v_grp_pag :=  c_obt_ct_sus.lqr_grp;
           v_cau :=c_obt_ct_sus.lqr_cau;
           v_prd := c_obt_ct_sus.lqr_prd;
           v_ben := c_obt_ct_sus.dsg_ben;
           v_recep := c_obt_ct_sus.lqr_id_recep;
           v_cob := c_obt_ct_sus.lqr_cob;
           ll_frm_pago := c_obt_ct_sus.lqr_frm_pago;
           ll_id_dom := c_obt_ct_sus.lqr_id_dom;
           ll_mto_pre_liq := c_obt_ct_sus.mto_pre;
           v_fec_pago  := c_obt_ct_sus.fecpag_contrib;
           v_prox_fec_pago := c_obt_ct_sus.fecprox_pago;
           ll_nro_cta_bco  := c_obt_ct_sus.LQR_CTA_BCO;
           ll_bco   := c_obt_ct_sus.bco;

           select to_char(lpad(nvl(pb.nat_numrut ,0),8,'0')) ,
              upper(rpad(nvl( pb.nat_dv,' '),1)) ,
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_pat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_mat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_nombre, ' ' )),30)),
              pb.nat_ap_mat
          into v_rut_ben, v_dv_ben, v_ap_pat_ben, v_ap_mat_ben, v_nomb_ben,
              vs_ap_mat_ben
           from pensiones.persnat pb
           where pb.nat_id = v_ben;

           if v_ap_mat_ben is null or v_ap_mat_ben = '' or  vs_ap_mat_ben = '.' then
              v_ap_mat_ben := '                    ';
           end if ;

           select to_char(lpad(nvl(pr.nat_numrut ,0),8,'0')  ) ,
              rpad(nvl( pr.nat_dv,' '),1),
              upper(rpad(F_LIMPIA_CARACTER(pr.nat_ap_pat),20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pr.nat_ap_mat, ' ' )),20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pr.nat_nombre, ' ')),30))
              into v_rut_manda, v_dv_manda,v_ap_pat_manda,v_ap_mat_manda, v_nombre_manda
           from pensiones.persnat pr
           where pr.nat_id = v_recep;

           if v_ap_mat_manda is null or v_ap_mat_manda = '' or v_ap_mat_manda = '.'then
              v_ap_mat_manda := '                    ';
           end if ;

           select upper(rpad(F_LIMPIA_CARACTER(nvl(db.dom_direccion, ' ')),45)) ,
              case when ll_frm_pago = 19 then '00000'
                   else
              lpad(nvl(db.dom_cod_com_ta ,0),5,'0')  end  ,
              upper(rpad(F_LIMPIA_CARACTER(db.dom_ciudad),20)),
              case when ll_frm_pago = 19 then '00'
                   else
                      case when length(nvl(db.dom_cod_com_ta,0)) = 4 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,1),0),2,'0')
                           when length(nvl(db.dom_cod_com_ta,0)) = 5 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,2),0),2,'0')
                           else '00' end   end ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_1),9) ,0),9,'0')) ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_2),9) ,0),9,'0')) ,
             case when db.dom_e_mai_cr LIKE '%@%' then
                    upper(rpad(REPLACE(REPLACE(REPLACE(REPLACE(translate(ltrim(rtrim(db.dom_e_mai_cr)), 'ÁÉÍÓÚáéíóúÑñ°#', 'AEIOUaeiouNn N'),CHR(27),' '), CHR(0),NULL), CHR(9),NULL), CHR(13),NULL),45))
                  else  '                                             ' end
            into v_dom_ben, v_comuna_ben, v_ciudad_ben, v_region_ben, v_telef1, v_telef2, v_email
            from pensiones.domicilios  db
            where dom_id_dom = ll_id_dom;

          if v_dom_ben is null or v_dom_ben = '' then
             v_dom_ben := '                                             ' ;
          end if;

          if v_ciudad_ben is null or v_ciudad_ben = '' then
             v_ciudad_ben := '                    ';
          end if ;

          if v_telef1 = '999999999' or v_telef1 = 'NO TIENE' then
            v_telef1 := '000000000';
          end if;

          if v_telef2 = '999999999' or v_telef2 = 'NO TIENE' then
            v_telef2 := '000000000';
          end if;

          if v_email is  null or v_email  = 'NO TIENE' then
             v_email := '                                             ';
          end if;

          v_fec_ult_pag := '00000000' ;

          if ll_frm_pago = 9 or ll_frm_pago = 13 or ll_frm_pago = 2 or ll_frm_pago = 15 or
             ll_frm_pago = 10 or ll_frm_pago = 20 then
             v_frm_pago :='01';
          else
             v_frm_pago := '02';
          end if;

          if ll_frm_pago =10 or  ll_frm_pago = 15 or ll_frm_pago = 20  then
             v_mod_pago:= '01';
          elsif ll_frm_pago = 12 or ll_frm_pago = 16 or ll_frm_pago = 3 or ll_frm_pago = 4 or
             ll_frm_pago = 5 or ll_frm_pago =  7 or ll_frm_pago = 6 or ll_frm_pago = 8 or
             ll_frm_pago =  11 or ll_frm_pago =  18 or  ll_frm_pago = 19  then
             v_mod_pago:='02';
          elsif ll_frm_pago = 12 or ll_frm_pago = 16 then
             v_mod_pago:='04';
          else
             v_mod_pago :='00';
          end if;

         if ll_frm_pago = 15 or ll_frm_pago = 10 then
             v_rut_ent_pag := '78053790' ;
             v_dv_ent_pag:= '6';
             v_com_ent_pag := v_comuna_ben;
             v_reg_ent_pag := v_region_ben;

           elsif ll_frm_pago = 1 or ll_frm_pago = 14 or ll_frm_pago = 17 or ll_frm_pago = 19 or
                 ll_frm_pago = 2 then
                 v_rut_ent_pag :='00000000';
                 v_dv_ent_pag := ' ';
                 v_com_ent_pag:='00000';
                 v_reg_ent_pag:='00';
           else
             select lpad(nvl(tbc_rut,0),8,'0')
             into v_rut_ent_pag
             from pensiones.rut_banco
             where tbc_cod_bco = c_obt_ct_sus.bco;

             select upper(rpad(nvl( tbc_dv  ,' '),1))
             into v_dv_ent_pag
             from pensiones.rut_banco
             where tbc_cod_bco = c_obt_ct_sus.bco;

             v_com_ent_pag :='13101';
             v_reg_ent_pag:= '13';
           end if;

           if v_rut_ben = v_rut_manda then
             if ll_frm_pago = 15 or ll_frm_pago = 10 or ll_frm_pago = 20 then
                v_cta_ban_ben:='00';
             elsif (c_obt_ct_sus.bco = 12 and lpad(ll_nro_cta_bco,8,'0') = to_char(v_rut_ben))  then
                v_cta_ban_ben:='08' ;
             elsif  c_obt_ct_sus.bco = 12 and  ll_frm_pago = 12 then
                v_cta_ban_ben:='04';
             elsif ll_frm_pago = 3 or ll_frm_pago = 4 then
                v_cta_ban_ben:='01' ;
             elsif ll_frm_pago = 5  or ll_frm_pago = 6  then
                v_cta_ban_ben:='02' ;
             elsif ll_frm_pago = 11 or ll_frm_pago = 14 or
                ll_frm_pago = 16 or ll_frm_pago = 18 or ll_frm_pago = 12 then
                v_cta_ban_ben:='04';
             else
                v_cta_ban_ben:='00';
             end if;

             if ll_frm_pago = 20 then
               v_nro_cta_ben := '000000000000000000';
             else
                 select lpad(ll_nro_cta_bco, 18,'0')
                 into v_nro_cta_ben
                 from dual;
              end if;

              v_cob_mandato :='02';
              v_ap_pat_manda := '                    ' ;
              v_ap_mat_manda := '                    ' ;
              v_nombre_manda := '                              ' ;
              v_domi_manda := '                                             ' ;
              v_comuna_manda := '00000' ;
              v_ciudad_manda := '                    ';
              v_region_manda := '00' ;
            else
              v_cta_ban_ben:='00';
              v_nro_cta_ben := '000000000000000000' ;
              v_cob_mandato := '01';
              select count(*) into ll_cont
              from pensiones.domicilios drm, pensiones.grupopago
              where drm.dom_persona = v_recep
                    and drm.dom_id_dom = grp_id_dom
                    and drm.dom_persona = grp_id_recep
                    and upper(drm.dom_direccion) not in ('SIN INFO', 'SIN INFORMACION', 'NO CONOCIDA') ;

              if ll_cont > 0 then
                 select upper(rpad(F_LIMPIA_CARACTER(nvl(drm.dom_direccion, ' ')),45)),
                      lpad(nvl(drm.dom_cod_com_ta ,0),5,'0'),
                      upper(rpad(F_LIMPIA_CARACTER(nvl(drm.dom_ciudad, ' ' )),20)),
                      case  when length(drm.dom_cod_com_ta) = 4 then
                                 lpad(nvl(substr(nvl(drm.dom_cod_com_ta, 0),1,1),0),2,'0')
                            when length(drm.dom_cod_com_ta) = 5 then
                                 lpad(nvl(substr(nvl(drm.dom_cod_com_ta,0),1,2),0),2,'0')
                            else '00'  end
                  into v_domi_manda, v_comuna_manda, v_ciudad_manda, v_region_manda
                  from pensiones.domicilios drm, pensiones.grupopago
                  where drm.dom_persona = v_recep
                        and drm.dom_id_dom = grp_id_dom
                        and drm.dom_persona = grp_id_recep
                        and upper(drm.dom_direccion) not in ('SIN INFO', 'SIN INFORMACION', 'NO CONOCIDA')
                        and rownum = 1 ;

                  if v_ciudad_manda is null or v_ciudad_manda = '' then
                     v_ciudad_manda := '                    ';
                  end if ;

                  if v_comuna_manda = '00000' then
                     v_comuna_manda := v_comuna_ben ;
                     v_region_manda := v_region_ben ;
                  end if ;

                else
                   v_domi_manda :=  '                                             ';
                   v_comuna_manda := v_comuna_ben ;
                   v_ciudad_manda := '                    ';
                   v_region_manda := v_region_ben ;
                end if;
             end if;

             if  v_rut_ben <> v_rut_manda then
                 select to_char(lpad(nvl(c_obt_ct_sus.bco ,0),3,'0')  )
                  into v_cod_ent_banca
                  from dual;

                if ll_frm_pago = 15 or ll_frm_pago = 10 or ll_frm_pago = 20 then
                    v_tip_cta_manda := '00';
                    v_cod_ent_banca := '000';
                elsif (c_obt_ct_sus.bco = 12 and lpad(ll_nro_cta_bco,8,'0') = to_char(v_rut_manda))  then
                    v_tip_cta_manda := '05';
                elsif  c_obt_ct_sus.bco = 12 and  ll_frm_pago = 12 then
                    v_cta_ban_ben:='04';
                elsif ll_frm_pago = 3 or ll_frm_pago = 4 then
                    v_tip_cta_manda := '01';
                elsif ll_frm_pago = 5  or ll_frm_pago = 6  then
                    v_tip_cta_manda := '02';
                elsif ll_frm_pago = 11 or ll_frm_pago = 14 or
                     ll_frm_pago = 16 or ll_frm_pago = 18 or ll_frm_pago = 12  then
                    v_tip_cta_manda := '04';
                else
                   v_tip_cta_manda:='00' ;
                end if;

               select lpad(ll_nro_cta_bco, 18,'0')
               into v_nto_cta_manda
                  from dual;
            else
                v_tip_cta_manda :='00';
                v_cod_ent_banca :='000' ;
                v_nto_cta_manda := '000000000000000000' ;
            end if;

           if ll_frm_pago = 9 or ll_frm_pago = 13 or ll_frm_pago = 2 or ll_frm_pago = 15 or
              ll_frm_pago = 10 or ll_frm_pago = 20 then
              v_ent_bca_ben := '000';
           else
             select to_char(lpad(nvl(c_obt_ct_sus.bco ,0),3,'0'))
             into v_ent_bca_ben
             from dual;
           end if;

           select to_char(lpad(nvl(ll_mto_pre_liq ,0),8,'0'))
           into v_tot_desctos
           from dual;

           if  v_rut_ben = v_rut_manda  then
               v_rut_manda := '00000000';
               v_dv_manda :=' ' ;
           end if;

           Begin
             insert into PENSIONES.pgu_datos_pago_periodo
              (pdp_periodo,pdp_poliza, pdp_grp_pago, pdp_rut_emp, pdp_dv_emp, pdp_rut_ben, pdp_dv_ben, pdp_ap_pat_ben, pdp_ap_mat_ben, pdp_nomb_ben,
              pdp_dom_ben, pdp_comuna_ben, pdp_ciudad_ben, pdp_region_ben, pdp_telef1, pdp_telef2, pdp_email, pdp_frm_pago, pdp_mod_pago,
              pdp_rut_ent_pag, pdp_dv_ent_pag, pdp_com_ent_pag, pdp_reg_ent_pag, pdp_cta_ban_ben, pdp_nro_cta_ben, pdp_cob_mandato, pdp_rut_manda,
              pdp_dv_manda, pdp_ap_pat_manda, pdp_ap_mat_manda, pdp_nombre_manda, pdp_domi_manda, pdp_comuna_manda, pdp_ciudad_manda, pdp_region_manda,
              pdp_cod_ent_banca, pdp_tip_cta_manda, pdp_nro_cta_manda, pdp_tot_desctos, pdp_fecpag_contrib, pdp_fecprox_pago,
              pdp_ent_banca_ben, pdp_prd,pdp_cau, pdp_cob,pdp_lqr_frm_pago, pdp_ben, pdp_fec_pago, pdp_estado_pago,
              pdp_rut_ent_traspaso, pdp_dv_ent_traspaso)
              values( v_periodo,v_pol,v_grp_pag, v_rut_emp,v_dv_emp ,v_rut_ben,v_dv_ben,v_ap_pat_ben,v_ap_mat_ben,v_nomb_ben ,
              v_dom_ben ,v_comuna_ben ,v_ciudad_ben,v_region_ben,v_telef1,v_telef2 ,v_email  ,v_frm_pago ,v_mod_pago  ,
              v_rut_ent_pag,v_dv_ent_pag  ,v_com_ent_pag  ,v_reg_ent_pag ,v_cta_ban_ben ,v_nro_cta_ben ,v_cob_mandato ,v_rut_manda,
              v_dv_manda,v_ap_pat_manda ,v_ap_mat_manda ,v_nombre_manda ,v_domi_manda  ,v_comuna_manda ,v_ciudad_manda ,v_region_manda ,
              v_cod_ent_banca,v_tip_cta_manda,v_nto_cta_manda ,v_tot_desctos ,v_fec_pago, v_prox_fec_pago ,
              v_ent_bca_ben,v_prd,v_cau,v_cob, ll_frm_pago, v_ben, v_fec_ult_pag, '03',
              v_rut_ent_traspaso, v_dv_ent_traspaso);
            exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' insertando pgu_datos_pago_periodo : ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
            end;

          ll_i :=  ll_i + 1;
          if ll_i >= 2000 then
             commit;
             ll_i:=0;
          end if;

      END LOOP;


       FOR c_obt_ct_liqrv IN obt_ct_liqrv LOOP
           v_pol  := c_obt_ct_liqrv.lqr_pol ;
           v_grp_pag :=  c_obt_ct_liqrv.lqr_grp;
           v_cau :=c_obt_ct_liqrv.lqr_cau;
           v_prd := c_obt_ct_liqrv.lqr_prd;
           v_ben := c_obt_ct_liqrv.dsg_ben;
           v_recep := c_obt_ct_liqrv.lqr_id_recep;
           v_cob := c_obt_ct_liqrv.lqr_cob;
           ll_frm_pago := c_obt_ct_liqrv.lqr_frm_pago;
           ll_id_dom := c_obt_ct_liqrv.lqr_id_dom;
           ll_mto_pre_liq := c_obt_ct_liqrv.mto_pre;
           v_fec_pago  := c_obt_ct_liqrv.fecpag_contrib;
           v_prox_fec_pago := c_obt_ct_liqrv.fecprox_pago;
           ll_nro_cta_bco  := c_obt_ct_liqrv.LQR_CTA_BCO;
           ll_bco   := c_obt_ct_liqrv.bco;

           select to_char(lpad(nvl(pb.nat_numrut ,0),8,'0')) ,
              upper(rpad(nvl( pb.nat_dv,' '),1)) ,
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_pat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_ap_mat,' ')) ,20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pb.nat_nombre, ' ' )),30)),
              pb.nat_ap_mat
          into v_rut_ben, v_dv_ben, v_ap_pat_ben, v_ap_mat_ben, v_nomb_ben,
              vs_ap_mat_ben
           from pensiones.persnat pb
           where pb.nat_id = v_ben;

           if v_ap_mat_ben is null or v_ap_mat_ben = '' or  vs_ap_mat_ben = '.' then
              v_ap_mat_ben := '                    ';
           end if ;

           select to_char(lpad(nvl(pr.nat_numrut ,0),8,'0')  ) ,
              rpad(nvl( pr.nat_dv,' '),1),
              upper(rpad(F_LIMPIA_CARACTER(pr.nat_ap_pat),20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pr.nat_ap_mat, ' ' )),20)),
              upper(rpad(F_LIMPIA_CARACTER(nvl(pr.nat_nombre, ' ')),30))
              into v_rut_manda, v_dv_manda,v_ap_pat_manda,v_ap_mat_manda, v_nombre_manda
           from pensiones.persnat pr
           where pr.nat_id = v_recep;

           if v_ap_mat_manda is null or v_ap_mat_manda = '' or v_ap_mat_manda = '.'then
              v_ap_mat_manda := '                    ';
           end if ;

           select upper(rpad(F_LIMPIA_CARACTER(nvl(db.dom_direccion, ' ')),45)) ,
              case when ll_frm_pago = 19 then '00000'
                   else
              lpad(nvl(db.dom_cod_com_ta ,0),5,'0')  end  ,
              upper(rpad(F_LIMPIA_CARACTER(db.dom_ciudad),20)),
              case when ll_frm_pago = 19 then '00'
                   else
                      case when length(nvl(db.dom_cod_com_ta,0)) = 4 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,1),0),2,'0')
                           when length(nvl(db.dom_cod_com_ta,0)) = 5 then
                                lpad(nvl(substr(nvl(db.dom_cod_com_ta,0),1,2),0),2,'0')
                           else '00' end   end ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_1),9) ,0),9,'0')) ,
             to_char(lpad(nvl(F_IS_NUMBERO(f_limpia_string_2(db.dom_telef_2),9) ,0),9,'0')) ,
             case when db.dom_e_mai_cr LIKE '%@%' then
                    upper(rpad(REPLACE(REPLACE(REPLACE(REPLACE(translate(ltrim(rtrim(db.dom_e_mai_cr)), 'ÁÉÍÓÚáéíóúÑñ°#', 'AEIOUaeiouNn N'),CHR(27),' '), CHR(0),NULL), CHR(9),NULL), CHR(13),NULL),45))
                  else  '                                             ' end
            into v_dom_ben, v_comuna_ben, v_ciudad_ben, v_region_ben, v_telef1, v_telef2, v_email
            from pensiones.domicilios  db
            where dom_id_dom = ll_id_dom;

          if v_dom_ben is null or v_dom_ben = '' then
             v_dom_ben := '                                             ' ;
          end if;

          if v_ciudad_ben is null or v_ciudad_ben = '' then
             v_ciudad_ben := '                    ';
          end if ;

          if v_telef1 = '999999999' or v_telef1 = 'NO TIENE' then
            v_telef1 := '000000000';
          end if;

          if v_telef2 = '999999999' or v_telef2 = 'NO TIENE' then
            v_telef2 := '000000000';
          end if;

          if v_email is  null or v_email  = 'NO TIENE' then
             v_email := '                                             ';
          end if;

          v_fec_ult_pag := '00000000' ;

          if ll_frm_pago = 9 or ll_frm_pago = 13 or ll_frm_pago = 2 or ll_frm_pago = 15 or
             ll_frm_pago = 10 or ll_frm_pago = 20 then
             v_frm_pago :='01';
          else
             v_frm_pago := '02';
          end if;

          if ll_frm_pago =10 or  ll_frm_pago = 15 or ll_frm_pago = 20  then
             v_mod_pago:= '01';
          elsif ll_frm_pago = 12 or ll_frm_pago = 16 or ll_frm_pago = 3 or ll_frm_pago = 4 or
             ll_frm_pago = 5 or ll_frm_pago =  7 or ll_frm_pago = 6 or ll_frm_pago = 8 or
             ll_frm_pago =  11 or ll_frm_pago =  18 or  ll_frm_pago = 19  then
             v_mod_pago:='02';
          elsif ll_frm_pago = 12 or ll_frm_pago = 16 then
             v_mod_pago:='04';
          else
             v_mod_pago :='00';
          end if;

         if ll_frm_pago = 15 or ll_frm_pago = 10 then
             v_rut_ent_pag := '78053790' ;
             v_dv_ent_pag:= '6';
             v_com_ent_pag := v_comuna_ben;
             v_reg_ent_pag := v_region_ben;

           elsif ll_frm_pago = 1 or ll_frm_pago = 14 or ll_frm_pago = 17 or ll_frm_pago = 19 or
                 ll_frm_pago = 2 then
                 v_rut_ent_pag :='00000000';
                 v_dv_ent_pag := ' ';
                 v_com_ent_pag:='00000';
                 v_reg_ent_pag:='00';
           else
             select lpad(nvl(tbc_rut,0),8,'0')
             into v_rut_ent_pag
             from pensiones.rut_banco
             where tbc_cod_bco = c_obt_ct_liqrv.bco;

             select upper(rpad(nvl( tbc_dv  ,' '),1))
             into v_dv_ent_pag
             from pensiones.rut_banco
             where tbc_cod_bco = c_obt_ct_liqrv.bco;

             v_com_ent_pag :='13101';
             v_reg_ent_pag:= '13';
           end if;

           if v_rut_ben = v_rut_manda then
             if ll_frm_pago = 15 or ll_frm_pago = 10 or ll_frm_pago = 20 then
                v_cta_ban_ben:='00';
             elsif (c_obt_ct_liqrv.bco = 12 and lpad(ll_nro_cta_bco,8,'0') = to_char(v_rut_ben))  then
                v_cta_ban_ben:='08' ;
             elsif  c_obt_ct_liqrv.bco = 12 and  ll_frm_pago = 12 then
                v_cta_ban_ben:='04';
             elsif ll_frm_pago = 3 or ll_frm_pago = 4 then
                v_cta_ban_ben:='01' ;
             elsif ll_frm_pago = 5  or ll_frm_pago = 6  then
                v_cta_ban_ben:='02' ;
             elsif ll_frm_pago = 11 or ll_frm_pago = 14 or
                ll_frm_pago = 16 or ll_frm_pago = 18 or ll_frm_pago = 12 then
                v_cta_ban_ben:='04';
             else
                v_cta_ban_ben:='00';
             end if;

             if ll_frm_pago = 20 then
               v_nro_cta_ben := '000000000000000000';
             else
                 select lpad(ll_nro_cta_bco, 18,'0')
                 into v_nro_cta_ben
                 from dual;
              end if;

              v_cob_mandato :='02';
              v_ap_pat_manda := '                    ' ;
              v_ap_mat_manda := '                    ' ;
              v_nombre_manda := '                              ' ;
              v_domi_manda := '                                             ' ;
              v_comuna_manda := '00000' ;
              v_ciudad_manda := '                    ';
              v_region_manda := '00' ;
            else
              v_cta_ban_ben:='00';
              v_nro_cta_ben := '000000000000000000' ;
              v_cob_mandato := '01';
              select count(*) into ll_cont
              from pensiones.domicilios drm, pensiones.grupopago
              where drm.dom_persona = v_recep
                    and drm.dom_id_dom = grp_id_dom
                    and drm.dom_persona = grp_id_recep
                    and upper(drm.dom_direccion) not in ('SIN INFO', 'SIN INFORMACION', 'NO CONOCIDA') ;

              if ll_cont > 0 then
                 select upper(rpad(F_LIMPIA_CARACTER(nvl(drm.dom_direccion, ' ')),45)),
                      lpad(nvl(drm.dom_cod_com_ta ,0),5,'0'),
                      upper(rpad(F_LIMPIA_CARACTER(nvl(drm.dom_ciudad, ' ' )),20)),
                      case  when length(drm.dom_cod_com_ta) = 4 then
                                 lpad(nvl(substr(nvl(drm.dom_cod_com_ta, 0),1,1),0),2,'0')
                            when length(drm.dom_cod_com_ta) = 5 then
                                 lpad(nvl(substr(nvl(drm.dom_cod_com_ta,0),1,2),0),2,'0')
                            else '00'  end
                  into v_domi_manda, v_comuna_manda, v_ciudad_manda, v_region_manda
                  from pensiones.domicilios drm, pensiones.grupopago
                  where drm.dom_persona = v_recep
                        and drm.dom_id_dom = grp_id_dom
                        and drm.dom_persona = grp_id_recep
                        and upper(drm.dom_direccion) not in ('SIN INFO', 'SIN INFORMACION', 'NO CONOCIDA')
                        and rownum = 1 ;

                  if v_ciudad_manda is null or v_ciudad_manda = '' then
                     v_ciudad_manda := '                    ';
                  end if ;

                  if v_comuna_manda = '00000' then
                     v_comuna_manda := v_comuna_ben ;
                     v_region_manda := v_region_ben ;
                  end if ;

                else
                   v_domi_manda :=  '                                             ';
                   v_comuna_manda := v_comuna_ben ;
                   v_ciudad_manda := '                    ';
                   v_region_manda := v_region_ben ;
                end if;
             end if;

             if  v_rut_ben <> v_rut_manda then
                 select to_char(lpad(nvl(c_obt_ct_liqrv.bco ,0),3,'0')  )
                  into v_cod_ent_banca
                  from dual;

                if ll_frm_pago = 15 or ll_frm_pago = 10 or ll_frm_pago = 20 then
                    v_tip_cta_manda := '00';
                    v_cod_ent_banca := '000';
                elsif (c_obt_ct_liqrv.bco = 12 and lpad(ll_nro_cta_bco,8,'0') = to_char(v_rut_manda))  then
                    v_tip_cta_manda := '05';
                elsif  c_obt_ct_liqrv.bco = 12 and  ll_frm_pago = 12 then
                    v_cta_ban_ben:='04';
                elsif ll_frm_pago = 3 or ll_frm_pago = 4 then
                    v_tip_cta_manda := '01';
                elsif ll_frm_pago = 5  or ll_frm_pago = 6  then
                    v_tip_cta_manda := '02';
                elsif ll_frm_pago = 11 or ll_frm_pago = 14 or
                     ll_frm_pago = 16 or ll_frm_pago = 18 or ll_frm_pago = 12  then
                    v_tip_cta_manda := '04';
                else
                   v_tip_cta_manda:='00' ;
                end if;

               select lpad(ll_nro_cta_bco, 18,'0')
               into v_nto_cta_manda
                  from dual;
            else
                v_tip_cta_manda :='00';
                v_cod_ent_banca :='000' ;
                v_nto_cta_manda := '000000000000000000' ;
            end if;

           if ll_frm_pago = 9 or ll_frm_pago = 13 or ll_frm_pago = 2 or ll_frm_pago = 15 or
              ll_frm_pago = 10 or ll_frm_pago = 20 then
              v_ent_bca_ben := '000';
           else
             select to_char(lpad(nvl(c_obt_ct_liqrv.bco ,0),3,'0'))
             into v_ent_bca_ben
             from dual;
           end if;

           select to_char(lpad(nvl(ll_mto_pre_liq ,0),8,'0'))
           into v_tot_desctos
           from dual;

           if  v_rut_ben = v_rut_manda  then
               v_rut_manda := '00000000';
               v_dv_manda :=' ' ;
           end if;

           Begin
             insert into PENSIONES.pgu_datos_pago_periodo
              (pdp_periodo,pdp_poliza, pdp_grp_pago, pdp_rut_emp, pdp_dv_emp, pdp_rut_ben, pdp_dv_ben, pdp_ap_pat_ben, pdp_ap_mat_ben, pdp_nomb_ben,
              pdp_dom_ben, pdp_comuna_ben, pdp_ciudad_ben, pdp_region_ben, pdp_telef1, pdp_telef2, pdp_email, pdp_frm_pago, pdp_mod_pago,
              pdp_rut_ent_pag, pdp_dv_ent_pag, pdp_com_ent_pag, pdp_reg_ent_pag, pdp_cta_ban_ben, pdp_nro_cta_ben, pdp_cob_mandato, pdp_rut_manda,
              pdp_dv_manda, pdp_ap_pat_manda, pdp_ap_mat_manda, pdp_nombre_manda, pdp_domi_manda, pdp_comuna_manda, pdp_ciudad_manda, pdp_region_manda,
              pdp_cod_ent_banca, pdp_tip_cta_manda, pdp_nro_cta_manda, pdp_tot_desctos, pdp_fecpag_contrib, pdp_fecprox_pago,
              pdp_ent_banca_ben, pdp_prd,pdp_cau, pdp_cob,pdp_lqr_frm_pago, pdp_ben, pdp_fec_pago, pdp_estado_pago,
              pdp_rut_ent_traspaso, pdp_dv_ent_traspaso)
              values( v_periodo,v_pol,v_grp_pag, v_rut_emp,v_dv_emp ,v_rut_ben,v_dv_ben,v_ap_pat_ben,v_ap_mat_ben,v_nomb_ben ,
              v_dom_ben ,v_comuna_ben ,v_ciudad_ben,v_region_ben,v_telef1,v_telef2 ,v_email  ,v_frm_pago ,v_mod_pago  ,
              v_rut_ent_pag,v_dv_ent_pag  ,v_com_ent_pag  ,v_reg_ent_pag ,v_cta_ban_ben ,v_nro_cta_ben ,v_cob_mandato ,v_rut_manda,
              v_dv_manda,v_ap_pat_manda ,v_ap_mat_manda ,v_nombre_manda ,v_domi_manda  ,v_comuna_manda ,v_ciudad_manda ,v_region_manda ,
              v_cod_ent_banca,v_tip_cta_manda,v_nto_cta_manda ,v_tot_desctos ,v_fec_pago, v_prox_fec_pago ,
              v_ent_bca_ben,v_prd,v_cau,v_cob, ll_frm_pago, v_ben, v_fec_ult_pag, '01',
              v_rut_ent_traspaso, v_dv_ent_traspaso);
            exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' insertando pgu_datos_pago_periodo : ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
            end;

          ll_i :=  ll_i + 1;
          if ll_i >= 2000 then
             commit;
             ll_i:=0;
          end if;

      END LOOP;
      commit;

  /*    insert into pensiones.tmp_proceso_log( tpl_accion,   tpl_fecha_log  )
        values('termina carga', sysdate);
        commit;

             insert into pensiones.tmp_proceso_log( tpl_accion,   tpl_fecha_log  )
        values('comienza update masivo', sysdate);
        commit;*/


       Begin
        insert into pensiones.PGU_TEMP_MAX_PERIODO
            (pgt_lqr_prd, pgt_lqr_pol, pgt_lqr_cau, pgt_lqr_grp, pgt_lqr_cob, pgt_lqr_fec_pago)
        (select lq.lqr_prd, lq.lqr_pol, lq.lqr_cau, lq.lqr_grp, lq.lqr_cob,
                 max(lq.lqr_fec_pago)  fec_pago
         from pensiones.liqrv lq
         where  lq.lqr_lin = 3
                and lq.lqr_doc = 2
                and lq.lqr_per  <> ll_periodo
         Group by lq.lqr_prd,
                  lq.lqr_doc,
                  lq.lqr_pol,
                  lq.lqr_cau,
                  lq.lqr_cob,
                  lq.lqr_grp);
        exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' insertando PGU_TEMP_MAX_PERIODO : ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
        end;


        Begin
            update pgu_datos_pago_periodo
                 set pdp_fec_pago  = nvl((select to_char(pgt_lqr_fec_pago, 'yyyymmdd')
                                from pensiones.PGU_TEMP_MAX_PERIODO lq
                                where  lq.pgt_lqr_prd  = pdp_prd
                                   and lq.pgt_lqr_pol  = pdp_poliza
                                   and lq.pgt_lqr_cau  = pdp_cau
                                   and lq.pgt_lqr_cob  = pdp_cob
                                   and lq.pgt_lqr_grp  = pdp_grp_pago),'00000000')
          where pdp_periodo = ll_periodo;


        exception
              WHEN OTHERS THEN
                p_cod_error := 1;
                p_msj_error := ' modificando  pgu_datos_pago_periodo : ' || SQLCODE ||
                               ' -ERROR- ' || SQLERRM;
                return;
        end;
        commit;


      /*  insert into pensiones.tmp_proceso_log( tpl_accion,   tpl_fecha_log  )
        values('termina update masivo', sysdate);
        commit;*/
       /* Ejecucion de profiler para verificacion  de  comportamiento */
  -- dbms_profiler.flush_data;
 -- dbms_profiler.stop_profiler;
/*  Dbms_profiler */

END;

 
 
/
