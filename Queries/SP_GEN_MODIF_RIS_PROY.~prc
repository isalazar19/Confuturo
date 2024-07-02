CREATE OR REPLACE PROCEDURE RENTARSV."SP_GEN_MODIF_RIS_PROY" (v_periodo_id IN  NUMBER
                                               ,v_cia        IN  NUMBER
                                               ,v_poliza     IN  NUMBER DEFAULT NULL) AS
  /*
  Descripcion     :   Generacion de modificaciones en tablas ris para envio a la SVS
  Tablas          :
  Autor           :   FOS
  Fecha           :   02/04/2024
  Modificaciones  :
  Observaciones   :
  Ejecucion       :
  */
  ls_temp1                  number(2);
  v_pol_poliza              rentarsv.polizas.pol_poliza%type;
  v_pol_linea               rentarsv.polizas.pol_linea%type;
  v_pol_documento           rentarsv.polizas.pol_documento%type;
  v_pol_producto            rentarsv.polizas.pol_producto%type;
  v_pol_contratante         rentarsv.polizas.pol_contratante%type;
  v_pol_fec_inicio          rentarsv.polizas.pol_fec_inicio%type;
  v_pol_porc_re             rentarsv.polizas.pol_porc_re%type;
  v_pol_meses_re            rentarsv.polizas.pol_meses_re%type;
  v_pol_tipo_re             rentarsv.polizas.pol_tipo_re%type;
  v_porc_re                 rentarsv.svs_poliza.svsp_porc_re%type;
  v_meses_re                rentarsv.svs_poliza.svsp_meses_re%type;
  e_error                   exception;
  v_vejez                   number(1);
  v_muerte                  number(1);
  v_inval                   number(1);
  v_nro_personas            number;
  v_asaf_afp                rentarsv.asegafp.asaf_afp%type;
  v_bono_rec                rentarsv.asegafp.asaf_bono_rec%type;
  v_cmp_bono_uf             rentarsv.asegafp.asaf_cmp_bono_uf%type;
  v_cta_indiv               rentarsv.asegafp.asaf_cta_indiv%type;
  v_fec_garant              rentarsv.asegafp.asaf_fec_garant%type;
  v_fec_vig_inic            rentarsv.asegafp.asaf_fec_vig_inic%type;
  v_fec_liq_muerte          rentarsv.asegafp.asaf_fec_liq_muerte%type;
  v_fec_liq_muerte_real     rentarsv.asegafp.asaf_fec_liq_muerte%type;
  v_monto_ref_inval         rentarsv.asegafp.asaf_monto_ref_inval%type;
  v_monto_ref_muerte        rentarsv.asegafp.asaf_monto_ref_muerte%type;
  v_ctaahorr_uf             rentarsv.asegafp.asaf_ctaahorr_uf%type;
  v_depconv_uf              rentarsv.asegafp.asaf_depconv_uf%type;
  v_bonexo_uf               rentarsv.asegafp.asaf_bonexo_uf%type;
  v_prima                   rentarsv.svs_poliza.svsp_prima_unica_nn%type;
  v_renta_mensual           rentarsv.svs_poliza.svsp_renta_mensual_nn%type;
  v_tipo_renta              rentarsv.svs_poliza.svsp_tipo_renta_nn%type;
  v_modalidad               rentarsv.svs_poliza.svsp_modalidad_renta_nn%type;
  v_ts_tce                  rentarsv.svs_poliza.svsp_tasa_cto_emision_nn%type;
  v_ts_tva                  rentarsv.svs_poliza.svsp_tasa_venta_nn%type;
  v_nat_numrut              rentarsv.persnat.nat_numrut%type;
  v_nat_dv                  rentarsv.persnat.nat_dv%type;
  v_nat_ap_pat              rentarsv.persnat.nat_ap_pat%type;
  v_nat_ap_mat              rentarsv.persnat.nat_ap_mat%type;
  v_nat_fec_nacim           rentarsv.persnat.nat_fec_nacim%type;
  v_nat_fec_muerte          rentarsv.persnat.nat_fec_muerte%type;
  v_nat_fec_inval           rentarsv.persnat.nat_fec_inval%type;
  v_nat_nomb                rentarsv.persnat.nat_nomb%type;
  v_nat_nombre              rentarsv.persnat.nat_nombre%type;
  v_nat_sexo                rentarsv.persnat.nat_sexo%type;
  v_grp_fam_ben             rentarsv.beneficios.bnf_grupo%type;
  v_count_cony              number;
  v_count_mhn               number;
  v_count_h_act             number;
  v_count_h_inv             number;
  v_hay_benef_legales       varchar2(2);
  v_cant_cony               number := 0;
  v_cant_convi              number := 0;
  v_cant_mhn                number := 0;
  v_tot_h_act               number := 0;
  v_causante_fallecido      varchar2(2);
  v_cant_h_act_fall_cau     number := 0;
  v_cant_hr_al_fall_cau     number := 0;
  i                         number;
  v_grupo_conyuge           rentarsv.beneficios.bnf_grupo%type;
  v_asg_gar_fallecido       varchar2(2);
  v_hijos_inicio_poliza     varchar2(2);
  pg_sob                    varchar2(2);
  pg_vi                     varchar2(2);
  v_porc_asg_gar            number := 0;
  v_ase_invalido            number;
  v_tipo_pension            rentarsv.svs_poliza.svsp_tipo_pension_ta%type;
  v_vigencia_pension        rentarsv.svs_poliza.svsp_vigencia_pension_ta%type;
  v_tipo_beneficiario       rentarsv.svs_beneficiario.svsb_tipo_beneficiario_ta%type;
  v_porc_pension            rentarsv.svs_beneficiario.svsb_porcentaje_pension_nn%type;
  v_requisito_pension       rentarsv.svs_beneficiario.svsb_requisito_pension_ta%type;
  v_derecho                 rentarsv.svs_beneficiario.svsb_derecho_pension_ta%type;
  v_pension_ben             rentarsv.svs_beneficiario.svsb_pension_persona_nn%type;
  v_rel_h_m                 rentarsv.svs_beneficiario.svsb_relacion_hijo_madre_nn%type;
  v_fec_nac_h_m             rentarsv.svs_beneficiario.svsb_fecha_nac_hijo_menor_fc%type;
  v_der_acrecer             rentarsv.svs_beneficiario.svsb_derecho_acrecer_re%type;
  v_mto_pag_est_1           rentarsv.svs_beneficiario.svsb_monto_pago_bene_estatal_1%type := 0;
  v_tipo_pag_est_1          rentarsv.svs_beneficiario.svsb_tipo_pago_bene_estatal_1%type := 0;
  v_mto_pag_est_2           rentarsv.svs_beneficiario.svsb_monto_pago_bene_estatal_1%type := 0;
  v_tipo_pag_est_2          rentarsv.svs_beneficiario.svsb_tipo_pago_bene_estatal_1%type := 0;
  v_mto_pag_est_3           rentarsv.svs_beneficiario.svsb_monto_pago_bene_estatal_1%type := 0;
  v_tipo_pag_est_3          rentarsv.svs_beneficiario.svsb_tipo_pago_bene_estatal_1%type := 0;
  v_pg_sobr                 number;
  v_vig                     number;
  v_count_temp              number;
  v_count_temp_cert         number;
  vl_cont_reg               number := 0;
  v_per                     number;
  v_mto_pag_est             number(15, 5);
  v_tipo_pag_est            number(3);
  v_suma_porc_ben_vig       rentarsv.svs_beneficiario.svsb_porcentaje_pension_nn%type;
  v_periodo_ult_dia         date;
  l_count_leg_vig           number := 0;
  l_id_grp                  number;
  l_error                   varchar2(500);
  v_ben_vigentes            number;
  v_tip_vejez               varchar2(2);
  v_conyuge_fecha_muerte    date;
  v_count_conyuge_muerto    number;
  v_count_conyuge_total     number;
  v_mhn_fecha_muerte        date;
  v_count_mhn_muerto        number;
  v_count_mhn_total         number;
  v_count_pag_est           number;
  v_situacion_inval         varchar2(1);
  v_count_benefi_0          number;
  v_grupo_temp              number;
  v_count_hijos             number;
  v_count_grupo_temp        number;
  v_total_benef_vig         number;
  v_cant_beneficio          number;
  v_end_poliza              number;
  v_end_fec_vig             date;
  v_end_prima_ant           number;
  v_count_endoso            number;
  v_count_siniestros        number;
  v_ind_crsv_nn             number;
  v_edad                    number;
  vl_ben_invalido           rentarsv.beneficiarios.ben_invalido%type;
  v_svsp_fec_recal_act      rentarsv.svs_poliza.svsp_fec_recal_act%type;
  v_svsp_fec_recal_ant      rentarsv.svs_poliza.svsp_fec_recal_ant%type;
  v_svsp_ren_ant_recal_act  rentarsv.svs_poliza.svsp_ren_ant_recal_act%type;
  v_svsp_ren_ant_recal_ant  rentarsv.svs_poliza.svsp_ren_ant_recal_ant%type;

  type vr_grupo_familiar is varray(16) of number;

  v_mto_bhnv                number(6, 4);
  v_mto_bhnv_1              number(6, 4);
  v_mto_bhnv_2              number(6, 4);
  v_mto_bhnv_3              number(6, 4);

  wp_grp_fam                vr_grupo_familiar;
  wp_hay_cony               vr_grupo_familiar;
  wp_hay_convi              vr_grupo_familiar;
  wp_hay_mhn                vr_grupo_familiar;
  wp_cant_h_act             vr_grupo_familiar;
  wp_cant_h_inv             vr_grupo_familiar;

  v_pol_atrb12              rentarsv.polizas.pol_atrb12%type;
  v_por_adi_nn              rentarsv.beneficiarios.ben_por_adi_nn%type;
  v_num_reaseg              svs_reaseguros.svsr_numero_reaseguro_nn%type;
  v_comp_reaseg             svs_reaseguros.svsr_compania_reaseguro_1_ta%type;
  v_ope_reaseg              varchar2(1);
  v_modo_reaseg             varchar2(1);
  v_porc_retenido           number(5);
  v_fec_ini_reaseg          date;
  v_fec_ter_reaseg          date;
  v_tasa_cto_equiv          svs_reaseguros.svsr_tasa_cto_equiv_ret_1_nn%type;
  v_fec_sus_reaseg          date;
  v_comp_reaseg2            svs_reaseguros.svsr_compania_reaseguro_1_ta%type;
  v_ope_reaseg2             varchar2(1);
  v_modo_reaseg2            varchar2(1);
  v_proc_retenido2          number(5);
  v_fec_ini_reaseg2         date;
  v_fec_ter_reaseg2         date;
  v_tasa_cto_equiv2         svs_reaseguros.svsr_tasa_cto_equiv_ret_1_nn%type;
  v_fec_sus_reaseg2         date;
  v_pol_atrb10              rentarsv.polizas.pol_atrb10%type;
  v_pol_mod_pension         varchar2(1);
  v_pol_tipo_operacion_rv   rentarsv.svs_poliza.svsp_tipo_operacion_rv%type;
  v_poliza_con_anticipo_rv  rentarsv.svs_poliza.svsp_poliza_con_anticipo_rv%type;
  v_porc_anticipo_rv        rentarsv.adelanto10.porcentaje_adelanto%type;
  v_porc_adelanto           rentarsv.adelanto10.porcentaje_adelanto%type;
  v_porc_pns_post_antic     rentarsv.svs_beneficiario.svsb_porcentaje_pension_nn%type;
  v_fec_anticipo_rv         rentarsv.adelanto10.fecha_pago%type;
  v_tipo_beneficiario_aux   rentarsv.adelanto10.tipo_beneficiario%type;
  v_a10_poliza              rentarsv.adelanto10.poliza%type;
  v_a10_tipo_pension_vejez  rentarsv.adelanto10.tipo_pension%type;
  v_a10_cant_vejez          number(5);
  v_a10_tipo_pension_inval  rentarsv.adelanto10.tipo_pension%type;
  v_a10_cant_inval          number(5);
  v_a10_tipo_pension_sobrev rentarsv.adelanto10.tipo_pension%type;
  v_a10_cant_sobrev         number(5);
  v_tot_tipo_pension        number(5);
  v_tiene_derecho_a_pago    rentarsv.beneficios.bnf_estado%type;
  v_count_pag_base_uf_1     NUMBER(15,5);
  v_count_pag_base_uf_2     NUMBER(15,5);
  v_count_pag_base_uf_3     NUMBER(15,5);
  v_count_pag_base_aux      NUMBER(15,5);
  v_grp_fam_ben_cony_mhn_cc rentarsv.beneficios.bnf_grupo%type;
  v_cant_hij_mismo_grp_fam  rentarsv.beneficios.bnf_grupo%type;
  v_sin_min_producto        rentarsv.siniestros.sin_producto%type;
  v_sin_min_siniestro       rentarsv.siniestros.sin_tipo%type;
  v_pol_mod_pension_post    varchar2(1);
  v_tipo_renta_post         rentarsv.svs_poliza.svsp_tipo_renta_nn%type;
  v_per_ant                 number;
  v_tuvo_garantia_estatal   number;
  v_per_pol_fec_inicio      number;
  v_per_trimestre           number;
  v_cod_error               NUMBER;
  v_msj_error               VARCHAR2(2000);

  cursor c_poliza is
  select pol_poliza
        ,pol_linea
        ,pol_documento
        ,pol_producto
        ,pol_contratante
        ,pol_fec_inicio
        ,pol_atrb01
        ,pol_atrb03
        ,pol_atrb12
        ,pol_atrb10
        ,pol_porc_re
        ,pol_meses_re
        ,pol_tipo_re
        ,pol_tipo_operacion_rv
    from rentarsv.polizas
   where(v_poliza     is null
      or pol_poliza    = v_poliza)
     and pol_linea     = 3
     and pol_documento = 2
     and pol_estado    = 3
     order by pol_poliza asc;

  cursor c_siniestros is
  select sin_documento
        ,sin_linea
        ,sin_poliza
        ,sin_producto
        ,sin_siniestro
        ,sin_tipo
    from rentarsv.siniestros s1
   where s1.sin_poliza    = v_pol_poliza
     and s1.sin_id        = v_pol_contratante
     and s1.sin_linea     = v_pol_linea
     and s1.sin_documento = v_pol_documento
     and s1.sin_producto  = v_pol_producto;

  cursor c_beneficiarios is
  select ben_beneficiario
        ,ben_relacion
        ,ben_est_civil
        ,ben_ord_svs_nn
        ,ben_invalido
        ,ben_tab_mort_nn
        ,ben_poliza
        ,ben_documento
        ,ben_linea
        ,ben_producto
        ,ben_causante
        ,decode(nat_numrut, 1, 0, nat_numrut) nat_numrut
        ,decode(nat_numrut, 1, '0', nat_dv) nat_dv
        ,translate(nvl(nat_ap_pat,' '),'aeiouu?().''"AEIOUAEIOUU?aeiouAEIOU', 'aeiouun     AEIOUAEIOUUNaeiouAEIOU') nat_ap_pat
        ,translate(nvl(nat_ap_mat,' '),'aeiouu?().''"AEIOUAEIOUU?aeiouAEIOU', 'aeiouun     AEIOUAEIOUUNaeiouAEIOU') nat_ap_mat
        ,translate(nvl(nat_nombre,' '),'aeiouu?().''"AEIOUAEIOUU?aeiouAEIOU', 'aeiouun     AEIOUAEIOUUNaeiouAEIOU') nat_nombre
        ,translate(nvl(nat_nomb,' '),'aeiouu?().''"AEIOUAEIOUU?aeiouAEIOU', 'aeiouun     AEIOUAEIOUUNaeiouAEIOU') nat_nomb
        ,nat_sexo
        ,nat_fec_nacim
        ,nat_fec_muerte
        ,nat_fec_inval
        ,nat_est_civil
        ,ben_ind_der_re
        ,ben_por_adi_nn
        ,ben_atrib_cc
    from rentarsv.beneficiarios
        ,rentarsv.persnat
   where ben_poliza                 = v_pol_poliza
     and ben_linea                  = v_pol_linea
     and ben_documento              = v_pol_documento
     and ben_producto               = v_pol_producto
     and ben_causante               = v_pol_contratante
     and nvl(ben_contingente, '0') <> '1'
     and nvl(ben_ord_svs_nn, 0)     > 0
     and nat_id                     = ben_beneficiario;

  cursor c_beneficiarios_2 is
  select svsb_periodo_id
        ,svsb_poliza_id
        ,svsb_numero_de_orden_id
        ,svsb_porcentaje_pension_nn
        ,nvl(svsb_porc_anticipo_rv, 0) svsb_porc_anticipo_rv
    from rentarsv.svs_beneficiario
   where svsb_periodo_id          = v_periodo_id
     and svsb_poliza_id           = v_pol_poliza
     and svsb_derecho_pension_ta <> 10;

  cursor c_hay_beneficio is
  select bnf_grupo
        ,count(1) count_hay_beneficio
    from rentarsv.beneficiarios
        ,rentarsv.persnat
        ,rentarsv.beneficios
   where ben_poliza       = v_pol_poliza
     and ben_linea        = v_pol_linea
     and ben_documento    = v_pol_documento
     and ben_producto     = v_pol_producto
     and ben_causante     = v_pol_contratante
     and ben_ind_der_re  <> 1
     and bnf_poliza       = ben_poliza
     and bnf_linea        = ben_linea
     and bnf_documento    = ben_documento
     and bnf_producto     = ben_producto
     and bnf_causante     = ben_causante
     and bnf_beneficiario = ben_beneficiario
     and bnf_estado       = 0
     and nat_id           = ben_beneficiario
     and nat_fec_muerte  is null
   group by bnf_grupo;

  cursor c_hay_conyuge is
  select bnf_grupo
        ,count(1) count_hay_conyuge
    from rentarsv.beneficiarios
        ,rentarsv.persnat
        ,rentarsv.beneficios
   where ben_poliza       = v_pol_poliza
     and ben_linea        = v_pol_linea
     and ben_documento    = v_pol_documento
     and ben_producto     = v_pol_producto
     and ben_causante     = v_pol_contratante
     and ben_relacion     = 4
     and ben_ind_der_re  <> 1
     and bnf_poliza       = ben_poliza
     and bnf_linea        = ben_linea
     and bnf_documento    = ben_documento
     and bnf_producto     = ben_producto
     and bnf_causante     = ben_causante
     and bnf_beneficiario = ben_beneficiario
     and bnf_estado       = 0
     and nat_id           = ben_beneficiario
     and nat_fec_muerte  is null
   group by bnf_grupo;

  cursor c_hay_conviviente is
  select bnf_grupo
        ,count(1) count_hay_conviviente
    from rentarsv.beneficiarios
        ,rentarsv.persnat
        ,rentarsv.beneficios
   where ben_poliza       = v_pol_poliza
     and ben_linea        = v_pol_linea
     and ben_documento    = v_pol_documento
     and ben_producto     = v_pol_producto
     and ben_causante     = v_pol_contratante
     and ben_relacion     = 7
     and ben_ind_der_re  <> 1
     and bnf_poliza       = ben_poliza
     and bnf_linea        = ben_linea
     and bnf_documento    = ben_documento
     and bnf_producto     = ben_producto
     and bnf_causante     = ben_causante
     and bnf_beneficiario = ben_beneficiario
     and bnf_estado       = 0
     and nat_id           = ben_beneficiario
     and nat_fec_muerte  is null
   group by bnf_grupo;

  cursor c_hay_mhn is
  select bnf_grupo
        ,count(1) count_hay_mhn
    from rentarsv.beneficiarios
        ,rentarsv.persnat
        ,rentarsv.beneficios
   where ben_poliza       = v_pol_poliza
     and ben_linea        = v_pol_linea
     and ben_documento    = v_pol_documento
     and ben_producto     = v_pol_producto
     and ben_causante     = v_pol_contratante
     and ben_relacion     = 6
     and ben_ind_der_re  <> 1
     and bnf_poliza       = ben_poliza
     and bnf_linea        = ben_linea
     and bnf_documento    = ben_documento
     and bnf_producto     = ben_producto
     and bnf_causante     = ben_causante
     and bnf_beneficiario = ben_beneficiario
     and bnf_estado       = 0
     and nat_id           = ben_beneficiario
     and nat_fec_muerte  is null
   group by bnf_grupo;

  cursor c_hay_hcd is
  select bnf_grupo
        ,count(1) count_hay_hcd
    from rentarsv.beneficiarios
        ,rentarsv.persnat
        ,rentarsv.beneficios
   where ben_poliza       = v_pol_poliza
     and ben_linea        = v_pol_linea
     and ben_documento    = v_pol_documento
     and ben_producto     = v_pol_producto
     and ben_causante     = v_pol_contratante
     and ben_relacion    in (3, 5)
     and ben_ind_der_re  <> 1
     and bnf_poliza       = ben_poliza
     and bnf_linea        = ben_linea
     and bnf_documento    = ben_documento
     and bnf_producto     = ben_producto
     and bnf_causante     = ben_causante
     and bnf_beneficiario = ben_beneficiario
     and bnf_estado       = 0
     and nat_id           = ben_beneficiario
     and ben_causante     = bnf_causante
     and nat_fec_muerte  is null
     and((nat_fec_inval  is not null
     and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
      or((nat_fec_inval  is not null
     and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
      or(trunc((months_between(v_periodo_ult_dia, nat_fec_nacim) / 12), 1) < 24
     and ben_est_civil = 3)))
   group by bnf_poliza
           ,bnf_grupo;

  cursor c_hay_hi is
  select bnf_grupo
        ,count(1) count_hay_hi
    from rentarsv.beneficiarios
        ,rentarsv.persnat
        ,rentarsv.beneficios
   where ben_poliza       = v_pol_poliza
     and ben_linea        = v_pol_linea
     and ben_documento    = v_pol_documento
     and ben_producto     = v_pol_producto
     and ben_causante     = v_pol_contratante
     and ben_relacion    in (3, 5)
     and ben_ind_der_re  <> 1
     and bnf_poliza       = ben_poliza
     and bnf_linea        = ben_linea
     and bnf_documento    = ben_documento
     and bnf_producto     = ben_producto
     and bnf_causante     = ben_causante
     and bnf_beneficiario = ben_beneficiario
     and bnf_estado       = 0
     and nat_id           = ben_beneficiario
     and nat_fec_muerte  is null
     and(nat_fec_inval   is not null
     and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
   group by bnf_poliza, bnf_grupo;

  cursor c_asg_garant_fall is
  select ben_relacion
        ,nvl(nat_fec_muerte, null) nat_fec_muerte
        ,ben_beneficiario
    from rentarsv.beneficiarios
        ,rentarsv.persnat
   where ben_poliza    = v_pol_poliza
     and ben_linea     = v_pol_linea
     and ben_documento = v_pol_documento
     and ben_producto  = v_pol_producto
     and ben_causante  = v_pol_contratante
     and ben_asg_gar   = 1
     and nat_id        = ben_beneficiario;

  cursor c_endosos is
  select end_poliza
        ,end_fec_vig
        ,end_prima_ant
        ,end_nro_modif
    from rentarsv.endosos_bnl
   where end_poliza     = v_pol_poliza
     and end_prima_ant <> end_prima_nue
     --and(end_nro_endoso > 1
     and(end_tip_end > 1 or (end_nro_endoso > 1 and end_tip_end = 1))
   union all
  /* Caso especial por adelanto 10% de vejez o invalidez donde no hay variacion de pension registrada */
  select end_poliza
        ,end_fec_vig
        ,end_prima_ant
        ,end_nro_modif
    from pensiones.modificaciones
         inner join pensiones.endosos
                 on end_linea     = mod_linea
                and end_producto  = mod_producto
                and end_documento = mod_documento
                and end_poliza    = mod_poliza
                and end_nro_modif = mod_correl
                and end_prima_ant = end_prima_nue
   where mod_poliza       = v_pol_poliza
     and mod_tipo_modif   = 907
   order by end_fec_vig   desc
           ,end_nro_modif asc;

  begin
  --------------PROCESO--------------

    /* Eliminar los registros para reprocesar */
    v_cod_error := 0;

    v_periodo_ult_dia := trunc(last_day(to_date(to_char(v_periodo_id) || '01', 'yyyymmdd')));

    commit;

    /* CICLO CURSOR POLIZAS */
    v_count_cony  := 0;
    v_count_mhn   := 0;
    v_count_h_act := 0;
    v_count_h_inv := 0;
    v_cant_cony   := 0;
    v_cant_convi  := 0;
    v_cant_mhn    := 0;
    v_tot_h_act   := 0;

    for p in c_poliza loop
      v_pol_poliza             := P.pol_poliza;
      v_pol_linea              := P.pol_linea;
      v_pol_documento          := P.pol_documento;
      v_pol_producto           := P.pol_producto;
      v_pol_contratante        := P.pol_contratante;
      v_pol_fec_inicio         := P.pol_fec_inicio;
      v_poliza_con_anticipo_rv := null;

      /* Por Renta Escalonada */
      v_porc_re             := 100;
      v_meses_re            := 0;
      v_pol_porc_re         := P.pol_porc_re;
      v_pol_meses_re        := P.pol_meses_re;
      v_pol_tipo_re         := P.pol_tipo_re;
      v_porc_adelanto       := 0;
      v_porc_anticipo_rv    := null;
      v_porc_pns_post_antic := 0;
      v_fec_anticipo_rv     := null;

      if v_pol_porc_re > 0 then
         v_meses_re := v_pol_meses_re;

       if v_pol_tipo_re = 'A' then
            v_porc_re := 100 - v_pol_porc_re;
         else
            v_porc_re := 100 + v_pol_porc_re;
         end if;
      end if;

      v_vejez      := 0;
      v_muerte     := 0;
      v_inval      := 0;
      v_pol_atrb12 := P.pol_atrb12;
      v_pol_atrb10 := P.pol_atrb10;

      v_pol_tipo_operacion_rv := P.pol_tipo_operacion_rv;

      /* Determinar Montos Traspasados AFP. */
      begin
        select to_number(cod_int_char)
              ,asaf_bono_rec
              ,asaf_cmp_bono_uf
              ,asaf_cta_indiv
              ,asaf_fec_garant
              ,asaf_fec_vig_inic
              ,asaf_fec_liq_muerte
              ,add_months(asaf_fec_liq_muerte, -1)
              ,asaf_monto_ref_inval
              ,asaf_monto_ref_muerte
              ,asaf_ctaahorr_uf
              ,asaf_depconv_uf
              ,asaf_bonexo_uf
              ,nvl(trunc(asaf_bono_rec + asaf_cta_indiv + asaf_cmp_bono_uf + asaf_ctaahorr_uf + asaf_depconv_uf + asaf_bonexo_uf, 2), 0)
          into v_asaf_afp
              ,v_bono_rec
              ,v_cmp_bono_uf
              ,v_cta_indiv
              ,v_fec_garant
              ,v_fec_vig_inic
              ,v_fec_liq_muerte
              ,v_fec_liq_muerte_real
              ,v_monto_ref_inval
              ,v_monto_ref_muerte
              ,v_ctaahorr_uf
              ,v_depconv_uf
              ,v_bonexo_uf
              ,v_prima
          from rentarsv.asegafp
              ,rentarsv.codigos
         where asaf_poliza    = v_pol_poliza
           and asaf_linea     = v_pol_linea
           and asaf_documento = v_pol_documento
           and asaf_producto  = v_pol_producto
           and asaf_asegurado = v_pol_contratante
           and cod_template   = 'SVS-CODIGO-AFP'
           and cod_int_num    = asaf_afp;
      exception
        when no_data_found then
          l_error := 'Error, no se pudo determinar Montos Traspasados AFP., ' || sqlerrm;

          goto siguiente_poliza;
      end;

      /* Determina Tipo de Pension desde la tabla siniestros. */
      for s in c_siniestros loop
        if s.sin_tipo = 8 then
          v_vejez := 1;
        elsif s.sin_tipo = 1 then
          v_muerte := 1;
        elsif s.sin_tipo = 2 then
          v_inval := 1;
        end if;
      end loop;

      if v_muerte = 1 then
          v_renta_mensual := nvl(v_monto_ref_muerte, 0);
      else
          v_renta_mensual := nvl(v_monto_ref_inval, 0);
      end if;

      if p.pol_atrb03 = 5 then
        v_renta_mensual    := 0;
        v_vigencia_pension := 9;
      end if;

      select decode(nat_numrut, 1, 0, nat_numrut)
            ,decode(nat_numrut, 1, '0', nat_dv)
            ,initcap(translate(nvl(nat_ap_pat,' '),'aeiouu?().''"AEIOUAEIOUU?', 'aeiouun     AEIOUAEIOUUN'))
            ,initcap(translate(nvl(nat_ap_mat,' '),'aeiouu?().''"AEIOUAEIOUU?', 'aeiouun     AEIOUAEIOUUN'))
            ,nvl(nat_fec_inval, null)
            ,nvl(nat_fec_muerte, null)
            ,nvl(nat_fec_nacim, null)
            ,nat_sexo
            ,initcap(translate(nvl(nat_nomb,' '),'aeiouu?().''"AEIOUAEIOUU?', 'aeiouun     AEIOUAEIOUUN'))
            ,initcap(translate(nvl(nat_nombre,' '),'aeiouu?().''"AEIOUAEIOUU?', 'aeiouun     AEIOUAEIOUUN'))
        into v_nat_numrut
            ,v_nat_dv
            ,v_nat_ap_pat
            ,v_nat_ap_mat
            ,v_nat_fec_inval
            ,v_nat_fec_muerte
            ,v_nat_fec_nacim
            ,v_nat_sexo
            ,v_nat_nomb
            ,v_nat_nombre
        from rentarsv.persnat
       where nat_id = v_pol_contratante;

      if (v_vejez = 0) and (v_inval = 0) and (v_muerte = 1) and (v_pol_poliza <> 12355) then /* Posible error de ingreso de datos ya que esta poliza tiene al causante en la tabla beneficiarios */
        if v_nat_fec_muerte is null then
          begin
            select add_months(asaf_fec_liq_muerte, -1)
              into v_nat_fec_muerte
              from rentarsv.asegafp
             where asaf_linea     = p.pol_linea
               and asaf_producto  = p.pol_producto
               and asaf_documento = p.pol_documento
               and asaf_asegurado = p.pol_contratante
               and asaf_poliza    = p.pol_poliza
               and rownum         = 1;
          exception
            when no_data_found then
              v_nat_fec_muerte := null;
          end;
        end if;
      end if;

      v_ase_invalido := 0;

    if v_inval = 1 then
        select ben_invalido
          into v_ase_invalido
          from rentarsv.beneficiarios
         where ben_poliza       = v_pol_poliza
           and ben_linea        = v_pol_linea
           and ben_documento    = v_pol_documento
           and ben_producto     = v_pol_producto
           and ben_beneficiario = v_pol_contratante
           and ben_relacion     = 0;
      end if;

      if v_nat_fec_muerte is not null then
        v_muerte := 1;
      end if;

      if v_pol_atrb10 = 2 then /* Confuturo */
        if v_pol_producto in (606, 607) then
          v_tip_vejez := 'VA';
        else
          v_tip_vejez := 'VN';
        end if;

        if v_vejez = 1 then
            if v_muerte = 0 then
                if v_tip_vejez = 'VN' then
                v_tipo_pension := 04;
                else
                v_tipo_pension := 05;
                end if;
            else
                if v_tip_vejez = 'VN' then
                v_tipo_pension := 09;
                else
                v_tipo_pension := 10;
                end if;
            end if;
        end if;
      else /* Corpseguros */
        if v_pol_producto in (606, 607) then
          v_tip_vejez := 'VA';
        else
          v_tip_vejez := 'VN';
        end if;

        /* Corregir producto segun edad del asegurado */
        select trunc(months_between(p.pol_fec_inicio, v_nat_fec_nacim ) / 12, 1)
          into v_edad
          from dual;

        if v_tip_vejez = 'VA' then
          if v_nat_sexo = 'M' and v_edad > 65 then
            v_tip_vejez := 'VN';
          else
            if v_nat_sexo = 'F' and v_edad > 60 then
              v_tip_vejez := 'VN';
            end if;
          end if;
        end if;

        if v_tip_vejez = 'VN' then
          if v_nat_sexo = 'M' and v_edad < 65 then
            v_tip_vejez := 'VA';
          else
            if v_nat_sexo = 'F' and v_edad < 60 then
              v_tip_vejez := 'VA';
            end if;
          end if;
        end if;

        if v_vejez = 1 then
          if v_muerte = 0 then
            if v_tip_vejez = 'VN' then
              v_tipo_pension := 04;
            else
              v_tipo_pension := 05;
            end if;
          else
            if v_tip_vejez = 'VN' then
              v_tipo_pension := 09;
            else
              v_tipo_pension := 10;
            end if;
          end if;
        end if;
      end if;

      /* Buscar en beneficiario con poliza y producto linea etc etc y causante (ben_relacion 0)--> BEN_INVALIDO */
      begin
        select ben_invalido
          into vl_ben_invalido
          from rentarsv.beneficiarios
         where ben_poliza             = v_pol_poliza
           and ben_linea              = v_pol_linea
           and ben_documento          = v_pol_documento
           and ben_producto           = v_pol_producto
           and ben_causante           = v_pol_contratante
           and nvl(ben_ord_svs_nn, 0) > 0
           and ben_relacion           = 0;
      exception
        when no_data_found then
          vl_ben_invalido := 0;
      end;

      if v_inval = 1 then
        if vl_ben_invalido = 1 then
          if v_muerte = 0 then
            v_tipo_pension := 06;
          else
            v_tipo_pension := 11;
          end if;
        elsif vl_ben_invalido = 3 then
          if v_muerte = 0 then
            v_tipo_pension := 07;
          else
            v_tipo_pension := 12;
          end if;
        end if;
      end if;

      if (v_muerte = 1) and (v_vejez = 0) and (v_inval = 0) then
        v_tipo_pension := 08;
      end if;

      /* Determina Vigencia Pension */
      v_vigencia_pension := 6;

      if p.pol_atrb01 in (7, 8) then
        v_vigencia_pension := 9;
      else
        if v_fec_vig_inic > p.pol_fec_inicio then
          if v_fec_vig_inic > v_periodo_ult_dia then
            v_vigencia_pension := 8;
          end if;
        end if;

        if (v_fec_garant > v_periodo_ult_dia) and (p.pol_atrb03 = 4) then
          v_vigencia_pension := 7;
        end if;
      end if;

      /* inicio tempo */
      select sum((select count(1)
        from rentarsv.beneficiarios
            ,rentarsv.persnat
            ,rentarsv.beneficios
       where ben_poliza       = v_pol_poliza
         and ben_linea        = v_pol_linea
         and ben_documento    = v_pol_documento
         and ben_producto     = v_pol_producto
         and ben_causante     = v_pol_contratante
         and ben_relacion    in (4, 7)
         and ben_ind_der_re  <> 1
         and bnf_poliza       = ben_poliza
         and bnf_linea        = ben_linea
         and bnf_documento    = ben_documento
         and bnf_producto     = ben_producto
         and bnf_causante     = ben_causante
         and bnf_beneficiario = ben_beneficiario
         and bnf_estado       = 0
         and nat_id           = ben_beneficiario
         and nat_fec_muerte  is null) +
                 (select count(1)
                    from rentarsv.beneficiarios
                        ,rentarsv.persnat
                        ,rentarsv.beneficios
                   where ben_poliza       = v_pol_poliza
                     and ben_linea        = v_pol_linea
                     and ben_documento    = v_pol_documento
                     and ben_producto     = v_pol_producto
                     and ben_causante     = v_pol_contratante
                     and ben_relacion     = 6
                     and ben_ind_der_re  <> 1
                     and bnf_poliza       = ben_poliza
                     and bnf_linea        = ben_linea
                     and bnf_documento    = ben_documento
                     and bnf_producto     = ben_producto
                     and bnf_causante     = ben_causante
                     and bnf_beneficiario = ben_beneficiario
                     and bnf_estado       = 0
                     and nat_id           = ben_beneficiario
                     and nat_fec_muerte  is null) +
                 (select count(1) count_hay_hcd
                    from rentarsv.beneficiarios
                        ,rentarsv.persnat
                        ,rentarsv.beneficios
                   where ben_poliza       = v_pol_poliza
                     and ben_linea        = v_pol_linea
                     and ben_documento    = v_pol_documento
                     and ben_producto     = v_pol_producto
                     and ben_causante     = v_pol_contratante
                     and ben_relacion    in (3, 5)
                     and ben_ind_der_re  <> 1
                     and bnf_poliza       = ben_poliza
                     and bnf_linea        = ben_linea
                     and bnf_documento    = ben_documento
                     and bnf_producto     = ben_producto
                     and bnf_causante     = ben_causante
                     and bnf_beneficiario = ben_beneficiario
                     and bnf_estado       = 0
                     and nat_id           = ben_beneficiario
                     and ben_causante     = bnf_causante
                     and nat_fec_muerte  is null
                     and((nat_fec_inval  is not null
                     and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
                      or(trunc((months_between(v_periodo_ult_dia, nat_fec_nacim) / 12), 1) < 24
                     and ben_est_civil    = 3))) +
                 (select count(1) count_hay_hi
                    from rentarsv.beneficiarios
                        ,rentarsv.persnat
                        ,rentarsv.beneficios
                   where ben_poliza       = v_pol_poliza
                     and ben_linea        = v_pol_linea
                     and ben_documento    = v_pol_documento
                     and ben_producto     = v_pol_producto
                     and ben_causante     = v_pol_contratante
                     and ben_ind_der_re  <> 1
                     and ben_relacion    in (3, 5)
                     and bnf_poliza       = ben_poliza
                     and bnf_linea        = ben_linea
                     and bnf_documento    = ben_documento
                     and bnf_producto     = ben_producto
                     and bnf_causante     = ben_causante
                     and bnf_beneficiario = ben_beneficiario
                     and bnf_estado       = 0
                     and nat_id           = ben_beneficiario
                     and nat_fec_muerte  is null
                     and(nat_fec_inval  is not null
                     and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)) +
                 (select count(1) count_hay_causante
                    from rentarsv.beneficiarios
                        ,rentarsv.persnat
                        ,rentarsv.beneficios
                   where ben_poliza       = v_pol_poliza
                     and ben_linea        = v_pol_linea
                     and ben_documento    = v_pol_documento
                     and ben_producto     = v_pol_producto
                     and ben_causante     = v_pol_contratante
                     and ben_relacion    in (0, 1, 2)
                     and ben_ind_der_re  <> 1
                     and bnf_poliza       = ben_poliza
                     and bnf_linea        = ben_linea
                     and bnf_documento    = ben_documento
                     and bnf_producto     = ben_producto
                     and bnf_causante     = ben_causante
                     and bnf_beneficiario = ben_beneficiario
                     and bnf_estado       = 0
                     and nat_id           = ben_beneficiario
                     and nat_fec_muerte  is null))
        into v_ben_vigentes
        from dual;

      if v_ben_vigentes = 0 and (v_fec_garant is null or v_fec_garant < v_periodo_ult_dia) then
        v_vigencia_pension := 9;
      end if;

      if v_ben_vigentes = 0 and (v_fec_garant > v_periodo_ult_dia) and p.pol_atrb01 = 4 then
        v_vigencia_pension := 7;
      end if;

      select count(1)
        into v_nro_personas
        from rentarsv.beneficiarios
       where ben_poliza    = v_pol_poliza
         and ben_linea     = v_pol_linea
         and ben_documento = v_pol_documento
         and ben_producto  = v_pol_producto
         and ben_causante  = v_pol_contratante
         and nvl(ben_contingente, '0') <> '1'
         and nvl(ben_ord_svs_nn, 0)     > 0;

      /* Determina Tipo de Renta. */
      v_tipo_renta := 1000;

      begin
        select pol_mod_pension
          into v_pol_mod_pension
          from pensiones.polizas
         where pol_poliza    = v_pol_poliza
           and pol_linea     = v_pol_linea
           and pol_producto  = v_pol_producto
           and pol_documento = v_pol_documento;
      exception
        when no_data_found then
          if v_pol_producto in (603, 606) then
            v_pol_mod_pension := 'I';
          else
            v_pol_mod_pension := 'D';
          end if;
      end;

      if v_pol_atrb10 = 2 then /* Confuturo */
        if v_pol_mod_pension = 'I' then
          v_tipo_renta := 1000;
        elsif v_pol_mod_pension = 'D' then
          /* Diferida. */
          v_tipo_renta := '2' || lpad(nvl(round(abs(months_between(P.pol_fec_inicio, v_fec_vig_inic)), 0), '0'), 3, '0');
        elsif  v_pol_mod_pension = 'P' then
          v_tipo_renta := 3000;
        end if;
      else
        if v_pol_producto in (603, 606) then
          v_tipo_renta := 1000;
        elsif v_pol_producto in (604, 607) then
          /* Diferida. */
          v_tipo_renta := '2' || lpad(nvl(round(abs(months_between(p.pol_fec_inicio, v_fec_vig_inic)), 0), '0'), 3, '0');
        end if;
      end if;

      /* Determina modalidad */
      if v_fec_garant is null then
        if v_pol_atrb12 = 1 then
          v_modalidad := 4000;
        else
          v_modalidad := 1000;
        end if;
      else
        if v_pol_atrb12 = 1 then
          v_modalidad := 4 || lpad(round(months_between(v_fec_garant, trunc(v_fec_vig_inic, 'mm')),  0),  3,  '0');
        else
          v_modalidad := 3 || lpad(round(months_between(v_fec_garant, trunc(v_fec_vig_inic, 'mm')), 0), 3, '0');
        end if;
      end if;

      /* Modalidad para Renta Escalonada */
      if v_pol_porc_re is not null then
        if v_pol_porc_re > 0 then
          if v_fec_garant is null then
            if v_pol_tipo_re = 'D' then
               v_modalidad := 2000;
            end if;
          else
            if v_pol_tipo_re = 'D' then
              v_modalidad := 2 ||
              lpad(round(months_between(v_fec_garant, trunc(v_fec_vig_inic, 'mm')),  0),  3,  '0');
            end if;
          end if;
        end if;
      end if;

      v_a10_cant_vejez  := 0;
      v_a10_cant_inval  := 0;
      v_a10_cant_sobrev :=0;

      begin
        /* cuenta tipo vejez */
        select poliza
              ,tipo_pension
              ,count(*)
          into v_a10_poliza
              ,v_a10_tipo_pension_vejez
              ,v_a10_cant_vejez
          from(select poliza
                     ,tipo_pension
                 from rentarsv.adelanto10
                where poliza                    = v_pol_poliza
                  and upper(trim(tipo_pension)) = 'VEJEZ'
                group by poliza
                        ,tipo_pension)
         group by poliza
                 ,tipo_pension;
      exception
        when no_data_found then
          v_a10_poliza             := null;
          v_a10_tipo_pension_vejez := null;
          v_a10_cant_vejez         := 0;
        when others then
          l_error := 'Error, al obtener cantidad tipo vejez en rentarsv.ADELANTO10, ' || sqlerrm;

          goto siguiente_poliza;
      end;

      begin
        /* cuenta tipo invalidez */
        select poliza
              ,tipo_pension
              ,count(*)
          into v_a10_poliza
              ,v_a10_tipo_pension_inval
              ,v_a10_cant_inval
          from(select poliza
                     ,tipo_pension
                 from rentarsv.adelanto10
                where poliza                    = v_pol_poliza
                  and upper(trim(tipo_pension)) = 'INVALIDEZ'
                group by poliza, tipo_pension)
         group by poliza
                 ,tipo_pension;
      exception
        when no_data_found then
          v_a10_poliza             := null;
          v_a10_tipo_pension_inval := null;
          v_a10_cant_inval         := 0;

        when others then
          l_error := 'Error, al obtener cantidad tipo invalidez en rentarsv.ADELANTO10, ' || sqlerrm;

          goto siguiente_poliza;
      end;

      begin
        /* cuenta tipo sobrevivencia */
        select poliza
              ,tipo_pension
              ,count(*)
          into v_a10_poliza
              ,v_a10_tipo_pension_sobrev
              ,v_a10_cant_sobrev
          from(select poliza
                     ,tipo_pension
                 from rentarsv.adelanto10
                where poliza                    = v_pol_poliza
                  and upper(trim(tipo_pension)) = 'SOBREVIVENCIA'
                group by poliza
                        ,tipo_pension)
         group by poliza
                 ,tipo_pension;
      exception
        when no_data_found then
          v_a10_poliza              := null;
          v_a10_tipo_pension_sobrev := null;
          v_a10_cant_sobrev         := 0;
        when others then
          l_error := 'Error, al obtener cantidad tipo sobrevivencia en rentarsv.ADELANTO10, ' || sqlerrm;

          goto siguiente_poliza;
      end;

      v_tot_tipo_pension := v_a10_cant_vejez + v_a10_cant_inval + v_a10_cant_sobrev;

      begin
        select ts_tce_nn
              ,ts_tva_nn
          into v_ts_tce
              ,v_ts_tva
          from rentarsv.tasas_rsv
         where ts_pol_id      = v_pol_poliza
           and ts_ori_pension = 'PRE'
           and ts_cia_id      = v_cia;
      exception
        when no_data_found then
          v_ts_tce := 0;
          v_ts_tva := 0;
        when others then
          l_error := 'Error, al obtener Tasa de Costo Equivalente y Tasa de Venta, ' || sqlerrm;

          goto siguiente_poliza;
      end;

      /* Reaseguro */
      v_num_reaseg := 0;

      begin
        select reas.svsr_numero_reaseguro_nn
              ,reas.svsr_compania_reaseguro_1_ta
              ,reas.svsr_operacion_reaseguro_1_ta
              ,reas.svsr_modo_reaseguro_1_re
              ,to_number(reas.svsr_porcentaje_retenido_1_nn)
              ,reas.svsr_fecha_inicio_1_fc
              ,reas.svsr_fecha_termino_1_fc
              ,reas.svsr_tasa_cto_equiv_ret_1_nn
              ,reas.svsr_fecha_reas_1_fc
              ,reas.svsr_compania_reaseguro_2_ta
              ,reas.svsr_operacion_reaseguro_2_ta
              ,reas.svsr_modo_reaseguro_2_re
              ,to_number(reas.svsr_porcentaje_retenido_2_nn)
              ,reas.svsr_fecha_inicio_2_fc
              ,reas.svsr_fecha_termino_2_fc
              ,reas.svsr_tasa_cto_equiv_ret_2_nn
              ,reas.svsr_fecha_reas_2_fc
          into V_num_reaseg
              ,v_comp_reaseg
              ,v_ope_reaseg
              ,v_modo_reaseg
              ,v_porc_retenido
              ,v_fec_ini_reaseg
              ,v_fec_ter_reaseg
              ,v_tasa_cto_equiv
              ,v_fec_sus_reaseg
              ,v_comp_reaseg2
              ,v_ope_reaseg2
              ,v_modo_reaseg2
              ,v_proc_retenido2
              ,v_fec_ini_reaseg2
              ,v_fec_ter_reaseg2
              ,v_tasa_cto_equiv2
              ,v_fec_sus_reaseg2
          from svs_reaseguros reas
         where reas.svsr_poliza_id = v_pol_poliza;
      exception
        when no_data_found then
          select count(r.svsr_numero_reaseguro_nn)
            into v_num_reaseg
            from rentarsv.svs_reaseguros r
           where r.svsr_poliza_id = v_pol_poliza;

          v_comp_reaseg     := 0;
          v_ope_reaseg      := ' ';
          v_modo_reaseg     := ' ';
          v_porc_retenido   := 0;
          v_fec_ini_reaseg  := null;
          v_fec_ter_reaseg  := null;
          v_tasa_cto_equiv  := 0;
          v_fec_sus_reaseg  := null;
          v_comp_reaseg2    := 0;
          v_ope_reaseg2     := ' ';
          v_modo_reaseg2    := ' ';
          v_proc_retenido2  := 0;
          v_fec_ini_reaseg2 := null;
          v_fec_ter_reaseg2 := null;
          v_tasa_cto_equiv2 := 0;
          v_fec_sus_reaseg2 := null;
      end;

      wp_grp_fam    := vr_grupo_familiar(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      wp_hay_cony   := vr_grupo_familiar(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      wp_hay_convi  := vr_grupo_familiar(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      wp_hay_mhn    := vr_grupo_familiar(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      wp_cant_h_act := vr_grupo_familiar(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      wp_cant_h_inv := vr_grupo_familiar(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

      v_cant_cony      := 0;
      v_cant_convi     := 0;
      v_cant_mhn       := 0;
      v_cant_beneficio := 0;
      v_tot_h_act      := 0;
      l_id_grp         := 0;

      for h_benef in c_hay_beneficio loop
        l_id_grp             := h_benef.bnf_grupo + 1;
        wp_grp_fam(l_id_grp) := h_benef.bnf_grupo;
        v_cant_beneficio     := v_cant_beneficio + h_benef.count_hay_beneficio;
      end loop;

      l_id_grp := 0;

      for h_cony in c_hay_conyuge loop
        l_id_grp              := h_cony.bnf_grupo + 1;
        wp_hay_cony(l_id_grp) := h_cony.count_hay_conyuge;
        v_cant_cony           := v_cant_cony + h_cony.count_hay_conyuge;
      end loop;

      l_id_grp := 0;

      for h_convi in c_hay_conviviente loop
        l_id_grp               := h_convi.bnf_grupo + 1;
        wp_hay_convi(l_id_grp) := h_convi.count_hay_conviviente;
        v_cant_convi           := v_cant_convi + h_convi.count_hay_conviviente;
      end loop;

      l_id_grp := 0;

      for h_mhn in c_hay_mhn loop
        l_id_grp             := h_mhn.bnf_grupo + 1;
        wp_hay_mhn(l_id_grp) := h_mhn.count_hay_mhn;
        v_cant_mhn           := v_cant_mhn + h_mhn.count_hay_mhn;
      end loop;

      l_id_grp := 0;

      for h_hcd in c_hay_hcd loop
        l_id_grp                := h_hcd.bnf_grupo + 1;
        wp_cant_h_act(l_id_grp) := h_hcd.count_hay_hcd;
        v_tot_h_act             := v_tot_h_act + h_hcd.count_hay_hcd;
      end loop;

      l_id_grp := 0;

      for h_hi in c_hay_hi loop
        l_id_grp := h_hi.bnf_grupo + 1;
        wp_cant_h_inv(l_id_grp) := h_hi.count_hay_hi;
      end loop;

      if v_nat_fec_muerte is null then
        v_causante_fallecido := 'NO';
      else
        v_causante_fallecido := 'SI';
      end if;

      if (v_cant_cony = 0) then
        v_cant_h_act_fall_cau := 0;

        for i in wp_grp_fam.first .. wp_grp_fam.last loop
          ls_temp1 := wp_grp_fam(i);

          if (wp_grp_fam(i) > 0) and (wp_grp_fam(i) <> nvl(v_grupo_conyuge, 0)) then
            /* revisar si existe relacion 6 por grupo tabla beneficio ,
             * viva o muerta pero su muerte posterior a la fecha de muerte del causante
             * estado =0
             */
            if (v_causante_fallecido = 'SI') then
              select count(*)
                into v_count_mhn
                from rentarsv.beneficiarios
                    ,rentarsv.persnat
                    ,rentarsv.beneficios
               where nat_id = ben_beneficiario
                 and ben_linea = v_pol_linea
                 and ben_producto = v_pol_producto
                 and ben_documento = v_pol_documento
                 and ben_poliza = v_pol_poliza
                 and ben_causante = v_pol_contratante
                 and bnf_poliza = ben_poliza
                 and bnf_linea = ben_linea
                 and bnf_documento = ben_documento
                 and bnf_producto = ben_producto
                 and bnf_causante = ben_causante
                 and bnf_beneficiario = ben_beneficiario
                 and bnf_grupo = wp_grp_fam(i)
                 and bnf_estado = 0
                 and ben_relacion = 6
                 and(nat_fec_muerte is null
                  or(nat_fec_muerte is not null
                 and nat_fec_muerte > v_nat_fec_muerte));

              if v_count_mhn = 0 then
                select count(1)
                  into v_cant_hr_al_fall_cau
                  from rentarsv.beneficiarios
                      ,rentarsv.persnat
                      ,rentarsv.beneficios
                 where ben_poliza       = v_pol_poliza
                   and ben_linea        = v_pol_linea
                   and ben_documento    = v_pol_documento
                   and ben_producto     = v_pol_producto
                   and ben_causante     = v_pol_contratante
                   and bnf_linea        = ben_linea
                   and bnf_poliza       = ben_poliza
                   and bnf_beneficiario = ben_beneficiario
                   and bnf_grupo        = wp_grp_fam(i)
                   and bnf_estado       = 0
                   and ben_relacion    in (3, 5)
                   and nat_id           = ben_beneficiario
                   and(nat_fec_muerte  is null
                    or(nat_fec_muerte  is not null
                   and nat_fec_muerte   > v_nat_fec_muerte))
                   and((nat_fec_inval  is not null
                   and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
                    or(trunc((months_between(v_nat_fec_muerte, nat_fec_nacim) / 12), 1) < 24 and ben_est_civil = 3)
                    or(trunc((months_between(v_nat_fec_muerte, nat_fec_nacim) / 12), 1) < 24 and ben_est_civil = 1
                   and nvl(ben_fec_est_civil, '31-DEC-9999') > v_nat_fec_muerte));

                v_cant_h_act_fall_cau := v_cant_h_act_fall_cau + v_cant_hr_al_fall_cau;
              end if;
            else
              select count(*)
                into v_count_mhn
                from rentarsv.beneficiarios
                    ,rentarsv.persnat
                    ,rentarsv.beneficios
               where nat_id           = ben_beneficiario
                 and ben_linea        = v_pol_linea
                 and ben_producto     = v_pol_producto
                 and ben_documento    = v_pol_documento
                 and ben_poliza       = v_pol_poliza
                 and ben_causante     = v_pol_contratante
                 and bnf_poliza       = ben_poliza
                 and bnf_linea        = ben_linea
                 and bnf_documento    = ben_documento
                 and bnf_producto     = ben_producto
                 and bnf_causante     = ben_causante
                 and bnf_beneficiario = ben_beneficiario
                 and bnf_grupo        = wp_grp_fam(i)
                 and bnf_estado       = 0
                 and ben_relacion     = 6
                 and ben_ind_der_re  <> 1
                 and nat_fec_muerte  is null;

              if v_count_mhn = 0 then
                select count(1)
                  into v_cant_hr_al_fall_cau
                  from rentarsv.beneficiarios
                      ,rentarsv.persnat
                      ,rentarsv.beneficios
                 where ben_poliza = v_pol_poliza
                   and ben_linea = v_pol_linea
                   and ben_documento = v_pol_documento
                   and ben_producto = v_pol_producto
                   and ben_causante = v_pol_contratante
                   and bnf_linea = ben_linea
                   and bnf_poliza = ben_poliza
                   and bnf_beneficiario = ben_beneficiario
                   and bnf_grupo = wp_grp_fam(i)
                   and bnf_estado = 0
                   and ben_relacion in (3, 5)
                   and ben_ind_der_re <> 1
                   and nat_id = ben_beneficiario
                   and nat_fec_muerte is null
                   and((nat_fec_inval is not null
                   and trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
                    or(trunc((months_between(v_periodo_ult_dia, nat_fec_nacim) / 12), 1) < 24 and ben_est_civil = 3));

                v_cant_h_act_fall_cau := v_cant_h_act_fall_cau + v_cant_hr_al_fall_cau;
              end if;
            end if;
          end if;
        end loop;
      end if;

      /* Asegurado garantizado fallecido */
      if v_fec_garant > v_periodo_ult_dia then
        for c_agf in c_asg_garant_fall loop
          begin
            select count(*)
              into v_count_grupo_temp
              from rentarsv.beneficios
             where bnf_poliza       = v_pol_poliza
               and bnf_linea        = v_pol_linea
               and bnf_documento    = v_pol_documento
               and bnf_producto     = v_pol_producto
               and bnf_causante     = v_pol_contratante
               and bnf_beneficiario = c_agf.ben_beneficiario
               and bnf_estado       = 0
             group by bnf_grupo;
          exception
            when no_data_found then
              v_count_grupo_temp := 0;
          end;

          if v_count_grupo_temp > 0 then
            select bnf_grupo
              into v_grupo_temp
              from rentarsv.beneficios
             where bnf_poliza       = v_pol_poliza
               and bnf_linea        = v_pol_linea
               and bnf_documento    = v_pol_documento
               and bnf_producto     = v_pol_producto
               and bnf_causante     = v_pol_contratante
               and bnf_beneficiario = c_agf.ben_beneficiario
               and bnf_estado       = 0
             group by bnf_grupo;

            select count(*)
              into v_count_hijos
              from rentarsv.beneficiarios
                  ,rentarsv.beneficios
             where ben_poliza       = v_pol_poliza
               and ben_linea        = v_pol_linea
               and ben_documento    = v_pol_documento
               and ben_producto     = v_pol_producto
               and ben_causante     = v_pol_contratante
               and ben_relacion    in (3, 5)
               and ben_ind_der_re  <> 1
               and bnf_poliza       = ben_poliza
               and bnf_linea        = ben_linea
               and bnf_documento    = ben_documento
               and bnf_producto     = ben_producto
               and bnf_causante     = ben_causante
               and bnf_beneficiario = ben_beneficiario
               and bnf_estado       = 0
               and bnf_grupo        = v_grupo_temp;

            if v_count_hijos > 0 then
              v_hijos_inicio_poliza := 'SI';
            else
              v_hijos_inicio_poliza := 'NO';
            end if;
          end if;

          if c_agf.nat_fec_muerte is null then
            v_asg_gar_fallecido := 'NO';
          else
            v_asg_gar_fallecido := 'SI';
          end if;

          if c_agf.ben_relacion = 4 then
            if v_hijos_inicio_poliza = 'SI' then
              v_porc_asg_gar := 50;
            elsif v_hijos_inicio_poliza = 'NO' then
              v_porc_asg_gar := 60;
            end if;
          end if;

          if c_agf.ben_relacion = 6 then
            if v_hijos_inicio_poliza = 'SI' then
              v_porc_asg_gar := 30;
            elsif v_hijos_inicio_poliza = 'NO' then
              v_porc_asg_gar := 36;
            end if;
          end if;
        end loop;
      end if;

      /***************************************************
      PARA INSERTAR CAUSANTE DE POLIZA SOBREVIVENCIA PURA
      ***************************************************/
      if (v_vejez = 0) and (v_inval = 0) and (v_muerte = 1) and (v_pol_poliza <> 12355) then /* posible error de ingreso de datos ya que esta poliza tiene al causante en la tabla beneficiarios */
        if v_nat_fec_muerte is null then
          begin
            select add_months(asaf_fec_liq_muerte, -1)
              into v_nat_fec_muerte
              from rentarsv.asegafp
             where asaf_linea     = p.pol_linea
               and asaf_producto  = p.pol_producto
               and asaf_documento = p.pol_documento
               and asaf_asegurado = p.pol_contratante
               and asaf_poliza    = p.pol_poliza
               and rownum         = 1;
          exception
            when no_data_found then
              v_nat_fec_muerte := null;
          end;
        end if;

      end if;

      /**************************************************
      **INSERTAR CAUSANTE DE POLIZA SOBREVIVENCIA PURA**
      **************************************************/
      v_derecho :=NULL;
      /* CICLO CURSOR BENEFICIARIOS DE LA POLIZA */
      for b in c_beneficiarios loop
        v_tipo_beneficiario     := null;
        v_tipo_beneficiario_aux := null;
        v_rel_h_m               := null;
        v_fec_nac_h_m           := null;
        v_requisito_pension     := 1;
        v_por_adi_nn            := b.ben_por_adi_nn;
        v_porc_anticipo_rv      := null;
        v_fec_anticipo_rv       := null;
        v_porc_adelanto         := 0;
        v_porc_anticipo_rv      := null;

        begin
          select tipo_beneficiario
                ,sum(porcentaje_adelanto)
                ,max(fecha_pago)
            into v_tipo_beneficiario_aux
                ,v_porc_anticipo_rv
                ,v_fec_anticipo_rv
            from rentarsv.adelanto10
                ,rentarsv.persnat p
           where poliza           = v_pol_poliza
             and p.nat_id         = b.ben_beneficiario
             and rut_beneficiario = p.nat_numrut
           group by tipo_beneficiario;
        exception
          when no_data_found then
            v_porc_anticipo_rv := null;
            v_fec_anticipo_rv  := null;
          when others then
            l_error := 'Error, al obtener porcentaje y fecha de pago en anticipo rentarsv.ADELANTO10, ' || sqlerrm;

            goto siguiente_poliza;
        end;

        /* En caso que se haya pedido adelanto como designado, no se debe asignar los valores al tipo legal */
        if (trim(upper(v_tipo_beneficiario_aux)) = trim(upper('Designado')) and b.ben_relacion <> 9) or
           /* En caso que se haya pedido adelanto como beneficiario legal, no se debe asignar los valores al tipo designado */
           (trim(upper(v_tipo_beneficiario_aux)) = trim(upper('Beneficiario')) and b.ben_relacion = 9) then
          v_porc_anticipo_rv := null;
          v_fec_anticipo_rv := null;
        end if;

        /* Obtener grupo familiar del beneficiario leido */
        begin
          select bnf_grupo
            into v_grp_fam_ben
            from rentarsv.beneficios
           where bnf_poliza       = b.ben_poliza
             and bnf_beneficiario = b.ben_beneficiario
             and bnf_linea        = b.ben_linea
             and bnf_documento    = b.ben_documento
             and bnf_producto     = b.ben_producto
             and bnf_causante     = b.ben_causante
             and bnf_estado       = 0
          union
          select bnf_grupo
            from rentarsv.beneficios
           where bnf_poliza       = b.ben_poliza
             and bnf_beneficiario = b.ben_beneficiario
             and bnf_linea        = b.ben_linea
             and bnf_documento    = b.ben_documento
             and bnf_producto     = b.ben_producto
             and bnf_causante     = b.ben_causante
             and b.ben_relacion   = 8
             and rownum           = 1;
        exception
          when no_data_found then
          v_grp_fam_ben := 0;
        end;

        l_id_grp := v_grp_fam_ben + 1;

        /* Determinar relacion Hijo Madre */
        if b.ben_relacion in (3, 5) then
          begin
            select nvl(ben_ord_svs_nn, 0)
              into v_rel_h_m
              from rentarsv.beneficiarios
                  ,rentarsv.beneficios
             where ben_poliza                 = v_pol_poliza
               and ben_linea                  = v_pol_linea
               and ben_documento              = v_pol_documento
               and ben_producto               = v_pol_producto
               and ben_causante               = v_pol_contratante
               and ben_relacion              in (4, 6, 7)
               and bnf_poliza                 = ben_poliza
               and bnf_linea                  = ben_linea
               and bnf_documento              = ben_documento
               and bnf_producto               = ben_producto
               and bnf_causante               = ben_causante
               and bnf_beneficiario           = ben_beneficiario
               and bnf_grupo                  = v_grp_fam_ben
               and bnf_estado                 = 0
               and nvl(ben_contingente, '0') <> '1'
               and ben_ind_der_re            <> 1
            union
            select nvl(ben_ord_svs_nn, 0)
              from rentarsv.beneficiarios
                  ,rentarsv.beneficios
             where ben_poliza                 = v_pol_poliza
               and ben_linea                  = v_pol_linea
               and ben_documento              = v_pol_documento
               and ben_producto               = v_pol_producto
               and ben_causante               = v_pol_contratante
               and ben_relacion               = 8
               and bnf_poliza                 = ben_poliza
               and bnf_linea                  = ben_linea
               and bnf_documento              = ben_documento
               and bnf_producto               = ben_producto
               and bnf_causante               = ben_causante
               and bnf_beneficiario           = ben_beneficiario
               and bnf_grupo                  = v_grp_fam_ben
               and nvl(ben_contingente, '0') <> '1'
               and ben_ind_der_re            <> 1
               and rownum                     = 1
            union
            select nvl(ben_ord_svs_nn, 0)
              from rentarsv.beneficiarios
                  ,rentarsv.beneficios
             where ben_poliza                 = v_pol_poliza
               and ben_linea                  = v_pol_linea
               and ben_documento              = v_pol_documento
               and ben_producto               = v_pol_producto
               and ben_causante               = v_pol_contratante
               and ben_relacion              in (6)
               and bnf_poliza                 = ben_poliza
               and bnf_linea                  = ben_linea
               and bnf_documento              = ben_documento
               and bnf_producto               = ben_producto
               and bnf_causante               = ben_causante
               and bnf_beneficiario           = ben_beneficiario
               and bnf_grupo                  = v_grp_fam_ben
               and bnf_estado                 = 1
               and nvl(ben_contingente, '0') <> '1'
               and ben_ind_der_re            <> 1
               and bnf_cobertura             in (select min(sin_tipo)
                                                   from rentarsv.siniestros
                                                  where sin_linea     = ben_linea
                                                    and sin_documento = ben_documento
                                                    and sin_poliza    = ben_poliza);
          exception
            when no_data_found then
              v_rel_h_m := 0;
            when others then
              l_error := 'Error, al obtener el Nro de orden Beneficiario - (SVS), Poliza: ' || v_pol_poliza || ' Grupo Familiar ' || v_grp_fam_ben || ' - ' || sqlerrm;

              goto siguiente_poliza;
          end;
        else
          /* cualquier otro beneficiario */
          v_rel_h_m := b.ben_ord_svs_nn;
        end if;

        select count(*)
          into v_count_conyuge_muerto
          from rentarsv.beneficiarios
              ,rentarsv.persnat
         where nat_id          = ben_beneficiario
           and ben_linea       = b.ben_linea
           and ben_producto    = b.ben_producto
           and ben_documento   = b.ben_documento
           and ben_poliza      = b.ben_poliza
           and ben_causante    = b.ben_causante
           and nat_fec_muerte is not null
           and ben_ind_der_re <> 1
           and ben_relacion    = 4;

        select count(*)
          into v_count_conyuge_total
          from rentarsv.beneficiarios
         where ben_linea       = b.ben_linea
           and ben_producto    = b.ben_producto
           and ben_documento   = b.ben_documento
           and ben_poliza      = b.ben_poliza
           and ben_causante    = b.ben_causante
           and ben_ind_der_re <> 1
           and ben_relacion    = 4;

        if v_count_conyuge_muerto > 0 then
          select max(nat_fec_muerte)
            into v_conyuge_fecha_muerte
            from rentarsv.beneficiarios
                ,rentarsv.persnat
           where nat_id          = ben_beneficiario
             and ben_linea       = b.ben_linea
             and ben_producto    = b.ben_producto
             and ben_documento   = b.ben_documento
             and ben_poliza      = b.ben_poliza
             and ben_causante    = b.ben_causante
             and nat_fec_muerte is not null
             and ben_relacion    = 4
             and ben_ind_der_re <> 1
             and rownum          = 1
           order by nat_fec_muerte desc;
        else
          v_conyuge_fecha_muerte := null;
        end if;

        select count(*)
          into v_count_mhn_muerto
          from rentarsv.beneficiarios
              ,rentarsv.persnat
              ,rentarsv.beneficios
         where nat_id           = ben_beneficiario
           and ben_linea        = b.ben_linea
           and ben_producto     = b.ben_producto
           and ben_documento    = b.ben_documento
           and ben_poliza       = b.ben_poliza
           and ben_causante     = b.ben_causante
           and nat_fec_muerte  is not null
           and bnf_poliza       = ben_poliza
           and bnf_linea        = ben_linea
           and bnf_documento    = ben_documento
           and bnf_producto     = ben_producto
           and bnf_causante     = ben_causante
           and bnf_beneficiario = ben_beneficiario
           and bnf_grupo        = v_grp_fam_ben
           and bnf_estado       = 0
           and ben_ind_der_re  <> 1
           and ben_relacion     = 6;

        select count(*)
          into v_count_mhn_total
          from rentarsv.beneficiarios
              ,rentarsv.beneficios
         where ben_linea        = b.ben_linea
           and ben_producto     = b.ben_producto
           and ben_documento    = b.ben_documento
           and ben_poliza       = b.ben_poliza
           and ben_causante     = b.ben_causante
           and ben_ind_der_re  <> 1
           and ben_relacion     = 6
           and bnf_poliza       = ben_poliza
           and bnf_linea        = ben_linea
           and bnf_documento    = ben_documento
           and bnf_producto     = ben_producto
           and bnf_causante     = ben_causante
           and bnf_beneficiario = ben_beneficiario
           and bnf_grupo        = v_grp_fam_ben
           and bnf_estado       = 0;

        if v_count_mhn_muerto > 0 then
          select max(nat_fec_muerte)
            into v_mhn_fecha_muerte
            from rentarsv.beneficiarios
                ,rentarsv.persnat
                ,rentarsv.beneficios
           where nat_id           = ben_beneficiario
             and ben_linea        = b.ben_linea
             and ben_producto     = b.ben_producto
             and ben_documento    = b.ben_documento
             and ben_poliza       = b.ben_poliza
             and ben_causante     = b.ben_causante
             and nat_fec_muerte  is not null
             and ben_relacion     = 6
             and bnf_poliza       = ben_poliza
             and bnf_linea        = ben_linea
             and bnf_documento    = ben_documento
             and bnf_producto     = ben_producto
             and bnf_causante     = ben_causante
             and bnf_beneficiario = ben_beneficiario
             and bnf_grupo        = v_grp_fam_ben
             and bnf_estado       = 0
             and ben_ind_der_re  <> 1
             and rownum           = 1
           order by nat_fec_muerte desc;
        else
          v_mhn_fecha_muerte := null;
        end if;

        /* Determinar tipo beneficiario y porcentaje */
        if b.ben_relacion = 0 then
          v_tipo_beneficiario := 99;
          v_porc_pension      := 100;

        elsif b.ben_relacion = 1 then
          v_tipo_beneficiario := 41;
          v_porc_pension      := 50;

        elsif b.ben_relacion = 2 then
          v_tipo_beneficiario := 42;
          v_porc_pension      := 50;

        elsif b.ben_relacion = 3 and (v_cant_cony > 0 or nvl(v_conyuge_fecha_muerte, '01-jan-1900') > nvl(v_nat_fec_muerte, '31-dec-9999')) then
          v_tipo_beneficiario := 30;
          v_porc_pension      := 15;

        elsif b.ben_relacion = 3 and ((v_conyuge_fecha_muerte is not null and nvl(v_conyuge_fecha_muerte, '01-jan-1900') <=  nvl(v_nat_fec_muerte, '31-dec-9999')) or v_count_conyuge_total = 0) then
          if wp_hay_convi(v_grp_fam_ben + 1) = 0 and wp_hay_mhn(v_grp_fam_ben + 1) = 0 and p.pol_fec_inicio >= '01-jan-1988' then
            v_tipo_beneficiario := 35;
            v_porc_pension      := case v_cant_h_act_fall_cau when 0 then 0 else 15 + 50 / v_cant_h_act_fall_cau end;
          else
            v_tipo_beneficiario := 30;
            v_porc_pension      := 15;
          end if;

        elsif b.ben_relacion = 5 and (v_cant_cony > 0 or nvl(v_conyuge_fecha_muerte, '01-jan-1900') > nvl(v_nat_fec_muerte, '31-dec-9999')) then
          v_tipo_beneficiario := 30;
          v_porc_pension      := 15;

        elsif b.ben_relacion = 5 and ((v_conyuge_fecha_muerte is not null and nvl(v_conyuge_fecha_muerte, '01-jan-1900') < nvl(v_nat_fec_muerte, '31-dec-9999')) or v_count_conyuge_total = 0) then
          if wp_hay_convi(v_grp_fam_ben + 1) = 0 and wp_hay_mhn(l_id_grp) = 0 and p.pol_fec_inicio >= '01-jan-1988' and ((v_mhn_fecha_muerte is not null and nvl(v_mhn_fecha_muerte, '01-jan-1900') < nvl(v_nat_fec_muerte, '31-dec-9999')) or v_count_mhn_total = 0) then
            v_tipo_beneficiario := 35;
            v_porc_pension   := case v_cant_h_act_fall_cau when 0 then 0 else 15 + 50 / v_cant_h_act_fall_cau end;
          else
            v_tipo_beneficiario := 30;
            v_porc_pension      := 15;
          end if;

        elsif (b.ben_relacion = 4 and b.ben_ind_der_re = 1) then
          v_tipo_beneficiario := 10;
          v_requisito_pension := 5;
          v_porc_pension      := 0;
          v_pension_ben       := 0;

        elsif (b.ben_relacion = 3 or b.ben_relacion = 5) and (b.ben_ind_der_re = 1) then
          v_tipo_beneficiario := 30;
          v_requisito_pension := 7;
          v_porc_pension      := 0;
          v_pension_ben       := 0;

        elsif b.ben_relacion = 4 and wp_cant_h_act(l_id_grp) = 0 then
          v_tipo_beneficiario := 10;

        if b.nat_fec_muerte is null then
            if v_cant_cony > 0 then
              v_porc_pension := 60 / v_cant_cony;
            else
              v_porc_pension := 60;
            end if;
          else
            v_porc_pension := 60;
          end if;

        elsif b.ben_relacion = 4 and wp_cant_h_act(l_id_grp) > 0 then
          v_tipo_beneficiario := 11;

          if b.nat_fec_muerte is null then
            if v_cant_cony > 0 then
              v_porc_pension := 50 / v_cant_cony;
            else
              v_porc_pension := 50;
            end if;
          else
            v_porc_pension := 50;
          end if;

        elsif b.ben_relacion = 6 and wp_cant_h_act(l_id_grp) = 0 then
          v_tipo_beneficiario := 20;

          if b.nat_fec_muerte is null then
            if v_cant_mhn > 0 then
              v_porc_pension := 36 / v_cant_mhn;
            else
              v_porc_pension := 36;
            end if;
          else
            v_porc_pension := 36;
          end if;

        elsif b.ben_relacion = 6 and wp_cant_h_act(l_id_grp) > 0 then
          v_tipo_beneficiario := 21;

          if b.nat_fec_muerte is null then
            if v_cant_mhn > 0 then
              v_porc_pension := 30 / v_cant_mhn;
            else
              v_porc_pension := 30;
            end if;
          else
            v_porc_pension := 30;
          end if;

        elsif (b.ben_relacion = 7 and b.ben_ind_der_re = 1) then
          if b.ben_atrib_cc = 10 then
            v_tipo_beneficiario := 50;
            v_der_acrecer       := 'N';
            v_porc_pension      := 60;
          elsif b.ben_atrib_cc = 11 then
            v_tipo_beneficiario := 51;
            v_der_acrecer       := 'S';
            v_porc_pension      := 50;
          elsif (b.ben_atrib_cc = 12 or  b.ben_atrib_cc = 13) then
            v_tipo_beneficiario := 52;
            v_der_acrecer       := 'S';
            v_porc_pension      := 15;
          end if;

          v_derecho           := 10;
          v_requisito_pension := 8;
          v_pension_ben       := 0;

        elsif (b.ben_relacion = 7 and b.ben_ind_der_re = 2) then
          if b.ben_atrib_cc = 10 then
            v_tipo_beneficiario := 50;
            v_der_acrecer       := 'N';
            v_porc_pension      := 60;
          elsif b.ben_atrib_cc = 11 then
            v_tipo_beneficiario := 51;
            v_der_acrecer       := 'S';
            v_porc_pension      := 50;
          elsif (b.ben_atrib_cc = 12 or  b.ben_atrib_cc = 13) then
            v_tipo_beneficiario := 52;
            v_der_acrecer       := 'S';
            v_porc_pension      := 15;
          end if;

          v_derecho           := 99;
          v_requisito_pension := 8;

        elsif b.ben_relacion = 8 then
          v_porc_pension      := 0;
          v_requisito_pension := 2;
          v_derecho           := 10;
          v_pension_ben       := 0;
          v_der_acrecer       := 'N';

        if wp_cant_h_act(l_id_grp) = 0 then
            v_tipo_beneficiario := 10;
          end if;

        if wp_cant_h_act(l_id_grp) > 0 then
            v_tipo_beneficiario := 11;
          end if;

        elsif b.ben_relacion = 9 then
          v_tipo_beneficiario := 77;

        if (v_muerte = 1) and (v_vejez = 0) and (v_inval = 0) and (v_fec_garant is not null) then
            v_pg_sobr := 1;
          else
            v_pg_sobr := 0;
          end if;

        if v_pg_sobr = 0 then
            v_porc_pension := 100;
          end if;

        if v_pg_sobr = 1 then
            v_porc_pension := v_porc_asg_gar;
          end if;
        end if;

        if p.pol_atrb03 = 5 then
          if v_tipo_beneficiario =99 then
            v_porc_pension      := 100;
            v_pension_ben       := 0;
            v_derecho           := 10;
            v_requisito_pension := 1;
          else
            v_pension_ben := 0;
            v_derecho     := 10;

            if v_tipo_beneficiario = 30 then
              v_requisito_pension := 4;
              v_porc_pension      := 15;
            elsif v_tipo_beneficiario = 20 or v_tipo_beneficiario = 21 then
              v_requisito_pension := 3;

              if v_tipo_beneficiario = 20 then
                v_porc_pension := 36;
              else
                v_porc_pension := 30;
              end if;
            elsif v_tipo_beneficiario = 10 or v_tipo_beneficiario = 11 then
              if v_tipo_beneficiario = 10 then
                v_porc_pension := 60;
              else
                v_porc_pension := 50;
              end if;

              if b.ben_ind_der_re =  1 then
                v_requisito_pension := 5;
              else
                v_requisito_pension := 2;
              end if;
            end if;
          end if;
        end if;

        /* Determinar tipo derecho pension */
        if b.ben_relacion in (0, 1, 2, 4, 6) then
          select count(1)
            into v_vig
            from rentarsv.beneficiarios, rentarsv.persnat
           where ben_poliza       = v_pol_poliza
             and ben_beneficiario = b.ben_beneficiario
             and ben_linea        = b.ben_linea
             and ben_documento    = v_pol_documento
             and ben_producto     = v_pol_producto
             and nat_id           = ben_beneficiario
             and ben_causante     = b.ben_causante
             and ben_relacion    in (0, 1, 2, 4, 6)
             and ben_ind_der_re  <> 1
             and nat_fec_muerte  is null;

          if v_vig > 0 and p.pol_atrb03 <> 5 then
            v_derecho := 99;
          elsif v_vig = 0 and p.pol_atrb03 <> 5 then
            v_derecho := 10;
          end if;
        end if;


          if b.ben_relacion in (3, 5) then
            v_vig := null;

            begin
              /* hijos invalidos */
              select(
                     (select count(*)
                        from rentarsv.beneficiarios
                            ,rentarsv.persnat
                       where ben_poliza       = v_pol_poliza
                         and ben_beneficiario = b.ben_beneficiario
                         and ben_linea        = b.ben_linea
                         and ben_documento    = b.ben_documento
                         and ben_producto     = v_pol_producto
                         and ben_causante     = v_pol_contratante
                         and ben_relacion    in (3, 5)
                         and nat_id           = ben_beneficiario
                         and ben_ind_der_re  <> 1 /* ben_ind_der_re <> 1 */
                         and nat_fec_muerte  is null
                         and nat_fec_inval   is not null
                         and(trunc(months_between(nat_fec_inval, nat_fec_nacim) / 12, 1) < 24)
                         and(ben_est_civil = 3 or (ben_est_civil = 1 and v_pol_fec_inicio < ben_fec_est_civil))
                     )+
                     /* Hijos Sanos */
                     (select count(*)
                        from rentarsv.beneficiarios
                            ,rentarsv.persnat
                       where ben_poliza       = v_pol_poliza
                         and ben_beneficiario = b.ben_beneficiario
                         and ben_linea        = b.ben_linea
                         and ben_documento    = b.ben_documento
                         and ben_producto     = v_pol_producto
                         and ben_causante     = v_pol_contratante
                         and ben_relacion    in (3, 5)
                         and nat_id           = ben_beneficiario
                         and ben_ind_der_re  <> 1 /* ben_ind_der_re <> 1*/
                         and nat_fec_muerte  is null
                         and nat_fec_inval   is null
                         and (trunc(months_between(v_periodo_ult_dia, nat_fec_nacim) / 12, 1) < 18 and ben_est_civil = 3))) /* < 18 */
                into v_vig
                from dual;
            exception
              when others then
                v_vig := 0;
            end;

            if v_vig > 0 and p.pol_atrb03 <> 5 then
              if (v_tipo_pension=2 or v_tipo_pension=4 or v_tipo_pension=5 or v_tipo_pension=6 or v_tipo_pension=7 or v_tipo_pension=14) then /* isalazar */
                v_derecho := 99;
                /* isalazar */
                begin
                  update rentarsv.ris_treg_3
                  set der_pens = '99'
                  where r3_cia_id = 2
                  and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
                  and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
                  and NUM_ORD_INF = b.ben_ord_svs_nn
                  and to_number(rut_afil) = b.nat_numrut;
                  exception
                  when others then
                  rollback;
                end;
              else
                 if (b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
                     (b.ben_invalido in (1, 3) and b.nat_fec_inval is not null and p.pol_atrb01 <> 8 )) 
                     then
                     v_derecho := 99;
                 end if;
              end if; /* isalazar */
              /* isalazar */
            else
              select count(1)
                into v_count_temp
                from rentarsv.beneficiarios
                    ,rentarsv.persnat
               where ben_poliza       = v_pol_poliza
                 and ben_beneficiario = b.ben_beneficiario
                 and ben_linea        = b.ben_linea
                 and ben_documento    = b.ben_documento
                 and ben_producto     = v_pol_producto
                 and ben_causante     = v_pol_contratante
                 and ben_ind_der_re  <> 1
                 and ben_relacion    in (3, 5)
                 and nat_id           = ben_beneficiario
                 and nat_fec_muerte  is null
                 and(trunc(months_between(v_periodo_ult_dia, nat_fec_nacim) / 12, 1) >= 18
                 and trunc(months_between(v_periodo_ult_dia, nat_fec_nacim) / 12, 1) < 24
                 and ben_est_civil    = 3);

              if v_count_temp > 0 then
                v_count_temp :=0;

                select count(1)
                  into v_count_temp_cert
                  from rentarsv.certest
                 where ces_poliza       = b.ben_poliza
                   and ces_beneficiario = b.ben_beneficiario
                   and ces_linea        = b.ben_linea
                   and ces_documento    = b.ben_documento
                   and ces_producto     = b.ben_producto
                   and ces_causante     = b.ben_causante
                   and ces_fec_hasta   >= v_periodo_ult_dia;

                if v_count_temp_cert > 0 then --RF Caso 3
                  v_derecho := 99;
                  begin
                    update rentarsv.ris_treg_3
                    set der_pens = '99'
                    where r3_cia_id = 2
                    and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
                    and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
                    and NUM_ORD_INF = b.ben_ord_svs_nn
                    and to_number(rut_afil) = b.nat_numrut;
                    exception
                    when others then
                    rollback;
                  end;
                else
                  v_derecho := 20;
                  begin
                  update rentarsv.ris_treg_3
                  set der_pens = '20'
                  where r3_cia_id = 2
                  and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
                  and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
                  and NUM_ORD_INF = b.ben_ord_svs_nn
                  and to_number(rut_afil) = b.nat_numrut;
                  exception
                  when others then
                  rollback;
                  end;
                end if;
              else
                v_derecho      := 10;
                v_porc_pension := 15;
                v_pension_ben  := 0;
                begin
                  update rentarsv.ris_treg_3
                  set der_pens = '10'
                  where r3_cia_id = 2
                  and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
                  and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
                  and NUM_ORD_INF = b.ben_ord_svs_nn
                  and to_number(rut_afil) = b.nat_numrut;
                exception
                when others then
                rollback;
                end;
              end if;
            end if;
          end if;

        if b.ben_relacion = 9 then
          if (v_fec_garant < v_periodo_ult_dia) or (p.pol_atrb01 = 7) or v_ben_vigentes > 0 then
            v_derecho      := 10;
            v_porc_pension := 100;
          else
            v_derecho := 99;
          end if;
        end if;

        v_tiene_derecho_a_pago := 0;
        begin
        select bnf_estado --12/02/2024 RF Caso 4
        into v_tiene_derecho_a_pago
        from pensiones.beneficios,
             pensiones.beneficiarios
        where bnf_poliza = ben_poliza
        and bnf_beneficiario = ben_beneficiario
        and bnf_poliza = b.ben_poliza
        and bnf_beneficiario = b.ben_beneficiario
        and b.ben_relacion in (3,5)
        and bnf_cobertura = (select min(mincob.bnf_cobertura)
                             from pensiones.beneficios mincob
                             where mincob.bnf_poliza=ben_poliza);
        exception
          when no_data_found then
               v_tiene_derecho_a_pago := 0;
        end;
        /* isalazar */
        select count(*)
          into v_count_benefi_0
          from rentarsv.beneficios
         where bnf_poliza       = b.ben_poliza
           and bnf_linea        = b.ben_linea
           and bnf_documento    = b.ben_documento
           and bnf_producto     = b.ben_producto
           and bnf_causante     = b.ben_causante
           and bnf_beneficiario = b.ben_beneficiario
           and bnf_estado       = 0;

        if b.ben_relacion = 6 and v_count_benefi_0 = 0 then
          v_porc_pension      := 30;
          v_pension_ben       := 0;
          v_requisito_pension := 3;
          v_derecho           := 10;
        end if;
        /* isalazar */

        /* Determinar requisito pension */
        if v_derecho = 10 then
          if b.ben_relacion = 4 and b.ben_ind_der_re <> 1 then
            v_requisito_pension := 2;
          elsif b.ben_relacion = 6 and b.nat_fec_muerte is null then
            v_requisito_pension := 3;
            begin
            update rentarsv.ris_treg_3
            set req_pens = '3'
            where r3_cia_id = 2
						and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
						and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
						and to_number(rut_afil) = b.nat_numrut;
            exception
             when others then
             rollback;
            end;
          elsif (b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
                 (b.ben_est_civil = 1 or  b.nat_fec_muerte is not null or
                 (b.nat_fec_inval is null and b.nat_fec_muerte is null and
                round(((months_between(v_periodo_ult_dia, b.nat_fec_nacim)) / 12), 1) >= 24)))
                OR   --RF02 Caso 1
                (b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
                 (b.ben_invalido in (1, 3) and b.nat_fec_inval is not null and
                 round(((months_between(b.nat_fec_inval, b.nat_fec_nacim)) / 12), 1) >= 24))
                /* isalazar */
                or
                (b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
                 (b.ben_invalido in (1, 3) and b.nat_fec_inval is not null ))
                /* isalazar */
                OR   --RF02 Caso 2
                (b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
                 (b.ben_invalido in (2) and b.nat_fec_inval is null and
                 round(((months_between(add_months(v_periodo_ult_dia,1), b.nat_fec_nacim)) / 1), 3) >= 288 and
                 round(((months_between(add_months(v_periodo_ult_dia,1), b.nat_fec_nacim)) / 1), 3) < 289))
                OR   --RF02 Caso 4
                (b.ben_relacion in (3, 5) and b.ben_ind_der_re <> 1 and
                 (b.ben_invalido in (2) and b.nat_fec_inval is null and
                 round(((months_between(add_months(v_periodo_ult_dia,1), b.nat_fec_nacim)) / 1), 3) >= 288 and
                 round(((months_between(add_months(v_periodo_ult_dia,1), b.nat_fec_nacim)) / 1), 3) < 289))
                OR   --RF02 Caso 4
                (b.ben_relacion in (3, 5) and v_tiene_derecho_a_pago = 1 and
                 (b.ben_invalido in (2) and b.nat_fec_inval is null and
                 (trunc(months_between(v_periodo_ult_dia, b.nat_fec_nacim) / 12, 1) >= 18
                  and  trunc(months_between(v_periodo_ult_dia, b.nat_fec_nacim) / 12, 1) < 24
                  ))) then  --29/01/2024 se a?ade RF02 RIS Caso 1, 2 y 4
            v_requisito_pension := 4;
            begin
            update rentarsv.ris_treg_3
            set    der_pens = '10',            
                   req_pens = '4'
            where r3_cia_id = 2
						and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
						and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
						and to_number(rut_afil) = b.nat_numrut;
            exception
             when others then
             rollback;
            end;
          elsif b.ben_relacion = 9 then
            v_requisito_pension := 6;
            begin
            update rentarsv.ris_treg_3
            set req_pens = '6'
            where r3_cia_id = 2
						and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
						and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
						and to_number(rut_afil) = b.nat_numrut;
            exception
             when others then
             rollback;
            end;
          end if;
        else
            if (b.ben_relacion in (3, 5)) and v_derecho = '99' then  --isalazar
               v_requisito_pension := 1;
               begin
               update rentarsv.ris_treg_3
               set der_pens = '99',
                   req_pens = '1'
                   where r3_cia_id = 2
						       and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
						       and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
                   and NUM_ORD_INF = b.ben_ord_svs_nn
						       and to_number(rut_afil) = b.nat_numrut;
               exception
                   when others then
                   rollback;  
               end;
            elsif (b.ben_relacion in (3, 5)) then  --isalazar
               v_requisito_pension := 1;
               begin
               update rentarsv.ris_treg_3
               set req_pens = '1'
                   where r3_cia_id = 2
						       and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
						       and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
                   and NUM_ORD_INF = b.ben_ord_svs_nn
						       and to_number(rut_afil) = b.nat_numrut;
               exception
                   when others then
                   rollback;  
               end;    
            end if; --isalazar
        end if;

        /*select count(*)
          into v_count_benefi_0
          from rentarsv.beneficios
         where bnf_poliza       = b.ben_poliza
           and bnf_linea        = b.ben_linea
           and bnf_documento    = b.ben_documento
           and bnf_producto     = b.ben_producto
           and bnf_causante     = b.ben_causante
           and bnf_beneficiario = b.ben_beneficiario
           and bnf_estado       = 0;

        if b.ben_relacion = 6 and v_count_benefi_0 = 0 then
          v_porc_pension      := 30;
          v_pension_ben       := 0;
          v_requisito_pension := 3;
          v_derecho           := 10;
        end if;*/

        /* Determinar Fec Nac Hijo Menor */
        if b.ben_relacion in (4, 6, 7, 8) then
          /* Revisar en matriz para el grupo v_grp_fam */
          if wp_cant_h_inv(v_grp_fam_ben + 1) = 0 then
            begin
              select nvl(max(nat_fec_nacim), '')
                into v_fec_nac_h_m
                from rentarsv.beneficiarios
                    ,rentarsv.persnat
                    ,rentarsv.beneficios
               where ben_poliza       = v_pol_poliza
                 and ben_linea        = v_pol_linea
                 and ben_documento    = v_pol_documento
                 and ben_producto     = v_pol_producto
                 and ben_causante     = v_pol_contratante
                 and ben_ind_der_re  <> 1
                 and ben_relacion    in (3, 5)
                 and bnf_poliza       = ben_poliza
                 and bnf_linea        = ben_linea
                 and bnf_documento    = ben_documento
                 and bnf_producto     = ben_producto
                 and bnf_causante     = ben_causante
                 and bnf_beneficiario = ben_beneficiario
                 and bnf_grupo        = v_grp_fam_ben
                 and bnf_estado       = 0
                 and nat_id           = ben_beneficiario
                 and nat_fec_muerte  is null
                 and nat_fec_inval   is null
                 and(trunc(months_between(v_periodo_ult_dia, nat_fec_nacim) / 12, 1)) < 24
                 and ben_est_civil    = 3
                 and exists            (select ben_relacion
                                          from rentarsv.beneficiarios b1
                                              ,rentarsv.persnat p1
                                              ,rentarsv.beneficios f1
                                         where b1.ben_poliza       = v_pol_poliza
                                           and b1.ben_relacion     = b.ben_relacion
                                           and f1.bnf_poliza       = b1.ben_poliza
                                           and b1.ben_beneficiario = f1.bnf_beneficiario
                                           and f1.bnf_grupo        = bnf_grupo
                                           and p1.nat_id           = b1.ben_beneficiario
                                           and p1.nat_fec_muerte  is null);
            exception
              when no_data_found then
                v_fec_nac_h_m := null;
            end;
          else
            v_fec_nac_h_m := null;
          end if;
        end if;

        /* Determinar derecho a acrecer */
        if b.ben_relacion in (4, 6) and v_fec_nac_h_m is not null then
          v_der_acrecer := 'S';
        else
          if b.ben_relacion in (7) and v_tipo_beneficiario <> 50 then
            v_der_acrecer := 'S';
          else
            v_der_acrecer := 'N';
          end if;
        end if;

        if b.ben_relacion in (8) then
          v_der_acrecer := 'N';
        end if;

        /* Determinar monto pension */
        begin
          select nvl(round(prp_pension, 2), 0)
            into v_pension_ben
            from rentarsv.primpago
           where prp_linea        = b.ben_linea
             and prp_periodo      = v_periodo_id
             and prp_producto     = b.ben_producto
             and prp_documento    = b.ben_documento
             and prp_poliza       = b.ben_poliza
             and prp_beneficiario = b.ben_beneficiario;
        exception
          when no_data_found then
            begin
              select nvl(round(pns_monto_pension, 2), 0)
                into v_pension_ben
                from rentarsv.pensiones
                    ,rentarsv.persnat
               where pns_poliza       = b.ben_poliza
                 and pns_periodo      = v_periodo_id
                 and pns_linea        = b.ben_linea
                 and pns_documento    = b.ben_documento
                 and pns_beneficiario = b.ben_beneficiario
                 and pns_producto     = b.ben_producto
                 and pns_beneficiario = nat_id
                 and nat_fec_muerte  is null;
            exception
              when no_data_found then
                v_pension_ben := 0;
            end;
        end;

        if v_derecho = 20 and v_tipo_pension between 8 and 12 then
          v_pension_ben := v_monto_ref_muerte * v_porc_pension / 100;
        elsif v_derecho = 20 and v_tipo_pension between 4 and 7 then
          v_pension_ben := 0;
        end if;

        /* Determinar Periodo Garantizado y corregir Porcentaje */
        if v_fec_garant is not null then
          if (v_vejez = 0) and (v_inval = 0) and (v_muerte = 1) then
          /* (Sobrevivencia pura) */
            pg_sob := 'SI';
            pg_vi  := 'NO';
          else
            pg_sob := 'NO';
            pg_vi  := 'SI';
          end if;
        else
          pg_sob := 'NO';
          pg_vi  := 'NO';
        end if;

        if v_fec_vig_inic > v_periodo_ult_dia then
          if v_monto_ref_muerte = 0 then
            if v_tipo_beneficiario = 99 then
              v_pension_ben := v_monto_ref_inval;
            else
              v_pension_ben := 0;
            end if;
          else
            if v_tipo_beneficiario = 99 then
              v_pension_ben := 0;
            else
              v_pension_ben := v_monto_ref_muerte * v_porc_pension / 100;
            end if;
          end if;
        end if;

        if v_tipo_beneficiario = 77 then
          if v_pg_sobr = 0 then
            if p.pol_atrb01 = 7 then
              v_porc_pension := 100;
              v_pension_ben  := 0;
            else
              v_porc_pension := 100;
              --v_pension_ben  := v_monto_ref_inval;
              v_pension_ben  := v_monto_ref_muerte; --RF Caso 13  19/02/2024
              begin
              update rentarsv.ris_treg_3
              set PER_PENS = LPAD (NVL (to_char(v_monto_ref_muerte) / 0.01, '0'), 5, 0)
              where r3_cia_id = 2
	            and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	            and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
              and NUM_ORD_INF = b.ben_ord_svs_nn
	            and to_number(rut_afil) = b.nat_numrut;
              exception
              when others then
              rollback;
              end;
            end if;
          else
            if p.pol_atrb01 = 7 then
              v_porc_pension := 100;
              v_pension_ben  := 0;
            else
              v_porc_pension := v_porc_asg_gar;
              v_pension_ben  := (v_monto_ref_muerte * v_porc_asg_gar) / 100;
            end if;
          end if;
        end if;

        /* Determinar Pago Estatal */
        select to_number(to_char(add_months(to_date(to_char(v_periodo_id) || '01', 'yyyymmdd'), -2), 'yyyymm'))
          into v_per
          from dual;

        i := 1;

        /* Ciclo hasta v_per = periodo_cierre or I = 3 */
        while ((v_per <= v_periodo_id) or (i = 3)) loop
          v_count_pag_est := 0;
          v_tipo_pag_est  := null;

          select count(*)
            into v_count_pag_est
            from pensiones.liqrv a
                ,pensiones.dsgdetrv dsg
                ,gensegur.valormoneda c
           where dsg.dsg_pol     = v_pol_poliza
             and dsg.dsg_ben     = b.ben_beneficiario
             and dsg.dsg_lin     = v_pol_linea
             and dsg.dsg_doc     = v_pol_documento
             and dsg.dsg_prd     = v_pol_producto
             and dsg.dsg_cau     = v_pol_contratante
             and dsg.dsg_per     = v_per
             and dsg.dsg_mto_pes > 0
             and dsg.dsg_tipo   in (46)
             and a.lqr_pol       = dsg.dsg_pol
             and a.lqr_lin       = dsg.dsg_lin
             and a.lqr_doc       = dsg.dsg_doc
             and a.lqr_prd       = dsg.dsg_prd
             and a.lqr_cau       = dsg.dsg_cau
             and a.lqr_per       = dsg.dsg_per
             and a.lqr_grp       = dsg.dsg_grp
             and c.vmon_moneda   = 1
             and c.vmon_fecha    = a.lqr_fec_pago;

          if v_count_pag_est > 0 then
            select sum(nvl(round(dsg.dsg_mto_pes / c.vmon_valor, 6), 0))
                  ,2
              into v_mto_pag_est
                  ,v_tipo_pag_est
              from pensiones.liqrv a
                  ,pensiones.dsgdetrv dsg
                  ,gensegur.valormoneda c
             where dsg.dsg_pol     = v_pol_poliza
               and dsg.dsg_ben     = b.ben_beneficiario
               and dsg.dsg_lin     = v_pol_linea
               and dsg.dsg_doc     = v_pol_documento
               and dsg.dsg_prd     = v_pol_producto
               and dsg.dsg_cau     = v_pol_contratante
               and dsg.dsg_per     = v_per
               and dsg.dsg_mto_pes > 0
               and dsg.dsg_tipo   in (46)
               and a.lqr_pol       = dsg.dsg_pol
               and a.lqr_lin       = dsg.dsg_lin
               and a.lqr_doc       = dsg.dsg_doc
               and a.lqr_prd       = dsg.dsg_prd
               and a.lqr_cau       = dsg.dsg_cau
               and a.lqr_per       = dsg.dsg_per
               and a.lqr_grp       = dsg.dsg_grp
               and c.vmon_moneda   = 1
               and c.vmon_fecha    = a.lqr_fec_pago;
          elsif v_count_pag_est = 0 then
            v_count_pag_est := 0;
            v_tipo_pag_est  := null;

            select count(*)
              into v_count_pag_est
              from pensiones.liqrv a
                  ,pensiones.dsgdetrv dsg
                  ,gensegur.valormoneda c
             where dsg.dsg_pol     = v_pol_poliza
               and dsg.dsg_ben     = b.ben_beneficiario
               and dsg.dsg_lin     = v_pol_linea
               and dsg.dsg_doc     = v_pol_documento
               and dsg.dsg_prd     = v_pol_producto
               and dsg.dsg_cau     = v_pol_contratante
               and dsg.dsg_per     = v_per
               and dsg.dsg_mto_pes > 0
               and dsg.dsg_tipo   in (19)
               and a.lqr_pol       = dsg.dsg_pol
               and a.lqr_lin       = dsg.dsg_lin
               and a.lqr_doc       = dsg.dsg_doc
               and a.lqr_prd       = dsg.dsg_prd
               and a.lqr_cau       = dsg.dsg_cau
               and a.lqr_per       = dsg.dsg_per
               and a.lqr_grp       = dsg.dsg_grp
               and c.vmon_moneda   = 1
               and c.vmon_fecha    = a.lqr_fec_pago;

            if v_count_pag_est > 0 then
              select sum(nvl(round(dsg.dsg_mto_pes / c.vmon_valor, 6), 0))
                    ,1
                into v_mto_pag_est
                    ,v_tipo_pag_est
                from pensiones.liqrv a
                    ,pensiones.dsgdetrv dsg
                    ,gensegur.valormoneda c
               where dsg.dsg_pol     = v_pol_poliza
                 and dsg.dsg_ben     = b.ben_beneficiario
                 and dsg.dsg_lin     = v_pol_linea
                 and dsg.dsg_doc     = v_pol_documento
                 and dsg.dsg_prd     = v_pol_producto
                 and dsg.dsg_cau     = v_pol_contratante
                 and dsg.dsg_per     = v_per
                 and dsg.dsg_mto_pes > 0 --nueva scv
                 and dsg.dsg_tipo   in (19)
                 and a.lqr_pol       = dsg.dsg_pol
                 and a.lqr_lin       = dsg.dsg_lin
                 and a.lqr_doc       = dsg.dsg_doc
                 and a.lqr_prd       = dsg.dsg_prd
                 and a.lqr_cau       = dsg.dsg_cau
                 and a.lqr_per       = dsg.dsg_per
                 and a.lqr_grp       = dsg.dsg_grp
                 and c.vmon_moneda   = 1
                 and c.vmon_fecha    = a.lqr_fec_pago;
            elsif v_count_pag_est = 0 then
              v_mto_pag_est  := 0;
              v_tipo_pag_est := 3;
            end if;
          end if;

          if i = 1 then
            v_mto_pag_est_1  := v_mto_pag_est;
            v_tipo_pag_est_1 := v_tipo_pag_est;
          elsif i = 2 then
            v_mto_pag_est_2  := v_mto_pag_est;
            v_tipo_pag_est_2 := v_tipo_pag_est;
          elsif i = 3 then
            v_mto_pag_est_3  := v_mto_pag_est;
            v_tipo_pag_est_3 := v_tipo_pag_est;
          end if;

          i := i + 1;

      v_per := to_char((add_months(to_date(to_char(v_per) || '01', 'yyyymmdd'), 1)), 'yyyy') || to_char((add_months(to_date(to_char(v_per) || '01', 'yyyymmdd'), 1)), 'mm');
        end loop;

        if v_inval = 0 and b.ben_relacion = 0 then
          v_situacion_inval := 'N';
          b.nat_fec_inval   := null;
        else
          if b.ben_invalido = 1 then
            v_situacion_inval := 'T';
          elsif b.ben_invalido = 3 then
            v_situacion_inval := 'P';
          else
            v_situacion_inval := 'N';
            b.nat_fec_inval   := null;
          end if;
        end if;

        v_ind_crsv_nn := 0;

        if (v_tipo_beneficiario = 99 and (v_vigencia_pension = 9  or v_vigencia_pension = 7)) then
          select count(*)
            into v_count_siniestros
            from rentarsv.siniestros
                ,pensiones.certper
           where sin_linea     = v_pol_linea
             and sin_documento = v_pol_documento
             and sin_producto  = v_pol_producto
             and sin_poliza    = v_pol_poliza
             and sin_tipo     <> 1
             and sin_estado    = 13
             and cep_nat       = v_pol_contratante
             and cep_tip       = 3
             and to_number(to_char(cep_fec_rcp, 'yyyymm')) = v_periodo_id
             and cep_rst = 2;

          if v_count_siniestros > 0 then
            v_ind_crsv_nn := 1;
          end if;
        end if;

        /* Determinar Pago Bono por Hijo */
        select to_number(to_char(add_months(to_date(to_char(v_periodo_id) || '01', 'yyyymmdd'), -2), 'yyyymm'))
          into v_per
          from dual;

        i := 1;

        /* ciclo por period hasta periodo_cierre or i = 3 */
        while ((v_per <= v_periodo_id) or (i = 3)) loop
          v_mto_bhnv := 0;

          select sum(nvl(round(dsg.dsg_mto_pes / c.vmon_valor, 4), 0))
            into v_mto_bhnv
            from pensiones.liqrv a
                ,pensiones.dsgdetrv dsg
                ,gensegur.valormoneda c
           where dsg.dsg_pol     = v_pol_poliza
             and dsg.dsg_ben     = b.ben_beneficiario
             and dsg.dsg_lin     = v_pol_linea
             and dsg.dsg_doc     = v_pol_documento
             and dsg.dsg_prd     = v_pol_producto
             and dsg.dsg_cau     = v_pol_contratante
             and dsg.dsg_per     = v_per
             and dsg.dsg_mto_pes > 0
             and dsg.dsg_tipo   in (52)
             and a.lqr_pol       = dsg.dsg_pol
             and a.lqr_lin       = dsg.dsg_lin
             and a.lqr_doc       = dsg.dsg_doc
             and a.lqr_prd       = dsg.dsg_prd
             and a.lqr_cau       = dsg.dsg_cau
             and a.lqr_per       = dsg.dsg_per
             and a.lqr_grp       = dsg.dsg_grp
             and c.vmon_moneda   = 1
             and c.vmon_fecha    = a.lqr_fec_pago;

          if i = 1 then
            v_mto_bhnv_1 := v_mto_bhnv;
          elsif i = 2 then
            v_mto_bhnv_2 := v_mto_bhnv;
          elsif i = 3 then
            v_mto_bhnv_3 := v_mto_bhnv;
          end if;

          i := i + 1;

          v_per := to_char((add_months(to_date(to_char(v_per) || '01', 'yyyymmdd'), 1)), 'yyyy') || to_char((add_months(to_date(to_char(v_per) || '01', 'yyyymmdd'), 1)), 'mm');
        end loop;

        if v_pol_atrb12 = 1 and v_por_adi_nn is not null then
          v_porc_pension := v_por_adi_nn;
        end if;

        /* Adelanto 10% */
        if v_porc_anticipo_rv is null then
          v_porc_adelanto := 0;
        else
          v_porc_adelanto := v_porc_anticipo_rv;
        end if;

      if v_porc_adelanto = 0 then
          v_porc_pns_post_antic := 0;
        else
          v_porc_pns_post_antic := 100 * ((v_porc_pension/100) * (1 - (v_porc_adelanto/100)));
        end if;

        --RF Caso 8
        if v_vigencia_pension = 9 and v_tipo_beneficiario = 77 then
           v_derecho := 10;
           v_requisito_pension := 6;

           begin
           update rentarsv.ris_treg_3
           set der_pens = '10',
               REQ_PENS = '6'
           where r3_cia_id = 2
	         and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	         and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
           and NUM_ORD_INF = b.ben_ord_svs_nn
	         and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
        end if;

        --RF Caso 9
        /* Determinar Pension Base 0,00010 */
        select to_number(to_char(add_months(to_date(to_char(v_periodo_id) || '01', 'yyyymmdd'), -2), 'yyyymm'))
          into v_per
          from dual;

        i := 1;

        /* Ciclo hasta v_per = periodo_cierre or I = 3 */
        while ((v_per <= v_periodo_id) or (i = 3)) loop
          v_count_pag_base_aux := 0;
          begin
          select nvl(dsg_mto_uf,0)
            into v_count_pag_base_aux
            from pensiones.liqrv a
                ,pensiones.dsgdetrv dsg
           where dsg.dsg_pol     = v_pol_poliza
             and dsg.dsg_ben     = b.ben_beneficiario
             and dsg.dsg_lin     = v_pol_linea
             and dsg.dsg_doc     = v_pol_documento
             and dsg.dsg_prd     = v_pol_producto
             and dsg.dsg_cau     = v_pol_contratante
             and dsg.dsg_per     = v_per
             and dsg.dsg_mto_pes > 0
             and dsg.dsg_tipo   in (1)
             and a.lqr_pol       = dsg.dsg_pol
             and a.lqr_lin       = dsg.dsg_lin
             and a.lqr_doc       = dsg.dsg_doc
             and a.lqr_prd       = dsg.dsg_prd
             and a.lqr_cau       = dsg.dsg_cau
             and a.lqr_per       = dsg.dsg_per
             and a.lqr_grp       = dsg.dsg_grp
             and exists (select 1 from pensiones.dsgdetrv tienegarantia
                         where tienegarantia.dsg_pol = a.lqr_pol
                         and tienegarantia.dsg_ben = b.ben_beneficiario
                         and tienegarantia.dsg_tipo = 19
                         and tienegarantia.dsg_ben = b.ben_beneficiario
                         and tienegarantia.dsg_lin     = v_pol_linea
                         and tienegarantia.dsg_doc     = v_pol_documento
                         and tienegarantia.dsg_prd     = v_pol_producto
                         and tienegarantia.dsg_cau     = v_pol_contratante
                         and tienegarantia.dsg_per     = v_per);
          exception
             when no_data_found then
               v_count_pag_base_aux := 0;
          end;
          if i = 1 then
            v_count_pag_base_uf_1  := v_count_pag_base_aux;
          elsif i = 2 then
            v_count_pag_base_uf_2  := v_count_pag_base_aux;
          elsif i = 3 then
            v_count_pag_base_uf_3  := v_count_pag_base_aux;
          end if;

          i := i + 1;

          v_per := to_char((add_months(to_date(to_char(v_per) || '01', 'yyyymmdd'), 1)), 'yyyy') || to_char((add_months(to_date(to_char(v_per) || '01', 'yyyymmdd'), 1)), 'mm');
        end loop;
        if v_vigencia_pension = 6 and v_count_pag_base_uf_1 = 0.0001 and v_count_pag_base_uf_2 = 0.0001 and v_count_pag_base_uf_3 = 0.0001
           and v_derecho = 10 then
           v_vigencia_pension := 9;

           v_requisito_pension := 4;
           begin
            update rentarsv.ris_treg_2
            set vig_pens = '9'
            where r2_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000');
           exception
             when others then
             rollback;
           end;
           
           /* isalazar */
           if (v_tipo_beneficiario = 30 or v_tipo_beneficiario = 35) then
             v_requisito_pension := 4;
             begin
              update rentarsv.ris_treg_3
              set REQ_PENS = '4'
              where r3_cia_id = 2
              and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
              and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
              and NUM_ORD_INF = b.ben_ord_svs_nn
              and to_number(rut_afil) = b.nat_numrut;
             exception
               when others then
               rollback;
             end;
           elsif (v_tipo_beneficiario = 20) then
             v_requisito_pension := 3;
             begin
              update rentarsv.ris_treg_3
              set REQ_PENS = '3'
              where r3_cia_id = 2
              and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
              and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
              and NUM_ORD_INF = b.ben_ord_svs_nn
              and to_number(rut_afil) = b.nat_numrut;
             exception
               when others then
               rollback;
             end;
           elsif (v_tipo_beneficiario = 10 or v_tipo_beneficiario = 11) then
             v_requisito_pension := 2;
             begin
              update rentarsv.ris_treg_3
              set REQ_PENS = '2'
              where r3_cia_id = 2
              and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
              and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
              and NUM_ORD_INF = b.ben_ord_svs_nn
              and to_number(rut_afil) = b.nat_numrut;
             exception
               when others then
               rollback;
             end;
           elsif (v_tipo_beneficiario = 50 or v_tipo_beneficiario = 51 or v_tipo_beneficiario = 52) then
             v_requisito_pension := 9;
             begin
              update rentarsv.ris_treg_3
              set REQ_PENS = '9'
              where r3_cia_id = 2
              and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
              and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
              and NUM_ORD_INF = b.ben_ord_svs_nn
              and to_number(rut_afil) = b.nat_numrut;
             exception
               when others then
               rollback;
             end;
           end if;
           
           /*begin
            update rentarsv.ris_treg_3
            set REQ_PENS = '4'
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;*/
           /* isalazar */
        end if;
        --RF Caso 9

        --RF Caso 10
        if v_tipo_beneficiario in (30,35) and v_count_pag_base_uf_1 = 0.0001 and v_count_pag_base_uf_2 = 0.0001 and v_count_pag_base_uf_3 = 0.0001
          and v_requisito_pension = 1 then
           v_requisito_pension := 4;
           begin
            update rentarsv.ris_treg_3
            set REQ_PENS = '4'
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut
            and tip_ben = v_tipo_beneficiario;
           exception
             when others then
             rollback;
           end;
        end if;
        --RF Caso 10

        --RF Caso 11 y 12
        begin
          select to_number(to_char(add_months(to_date(to_char(v_periodo_id) || '01', 'yyyymmdd'), -3), 'yyyymm'))
          into v_per_ant
          from dual;

          select nvl(count(*),0)
            into v_tuvo_garantia_estatal
            from pensiones.liqrv a
                ,pensiones.dsgdetrv dsg
           where dsg.dsg_pol     = v_pol_poliza
             and dsg.dsg_ben     = b.ben_beneficiario
             and dsg.dsg_lin     = v_pol_linea
             and dsg.dsg_doc     = v_pol_documento
             and dsg.dsg_prd     = v_pol_producto
             and dsg.dsg_cau     = v_pol_contratante
             and dsg.dsg_per     <= v_per_ant
             and dsg.dsg_mto_pes > 0
             and dsg.dsg_tipo   in (1)
             and a.lqr_pol       = dsg.dsg_pol
             and a.lqr_lin       = dsg.dsg_lin
             and a.lqr_doc       = dsg.dsg_doc
             and a.lqr_prd       = dsg.dsg_prd
             and a.lqr_cau       = dsg.dsg_cau
             and a.lqr_per       = dsg.dsg_per
             and a.lqr_grp       = dsg.dsg_grp
             and exists (select 1 from pensiones.dsgdetrv tienegarantia
                         where tienegarantia.dsg_pol = a.lqr_pol
                         and tienegarantia.dsg_ben = b.ben_beneficiario
                         and tienegarantia.dsg_tipo = 19
                         and tienegarantia.dsg_ben = b.ben_beneficiario
                         and tienegarantia.dsg_lin     = v_pol_linea
                         and tienegarantia.dsg_doc     = v_pol_documento
                         and tienegarantia.dsg_prd     = v_pol_producto
                         and tienegarantia.dsg_cau     = v_pol_contratante
                         and tienegarantia.dsg_per     <= v_per_ant);
          exception
             when no_data_found then
               v_tuvo_garantia_estatal := 0;
          end;
        if v_tipo_beneficiario in (30,35) and v_tuvo_garantia_estatal > 0 and v_derecho = 99 and v_requisito_pension = 1 
          and v_count_pag_base_uf_1 = 0.0001 and v_count_pag_base_uf_2 = 0.0001 and v_count_pag_base_uf_3 = 0.0001
          then
           v_derecho := 10;
           v_requisito_pension := 4;

           begin
           update rentarsv.ris_treg_3
           set der_pens = '10',
               REQ_PENS = '4'
           where r3_cia_id = 2
	         and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	         and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
           and NUM_ORD_INF = b.ben_ord_svs_nn
	         and to_number(rut_afil) = b.nat_numrut
           and tip_ben = v_tipo_beneficiario;
           exception
             when others then
             rollback;
           end;
        end if;
        --RF Caso 11 y 12

        --RF Caso 14
        /*v_grp_fam_ben_cony_mhn_cc := 0;
        v_cant_hij_mismo_grp_fam := 0;
        begin --grupo familiar beneficiario conyuge o mhn/phn o cc
          select bnf_grupo
            into v_grp_fam_ben_cony_mhn_cc
            from rentarsv.beneficios
           where bnf_poliza       = b.ben_poliza
             and bnf_beneficiario = b.ben_beneficiario
             and bnf_linea        = b.ben_linea
             and bnf_documento    = b.ben_documento
             and bnf_producto     = b.ben_producto
             and bnf_causante     = b.ben_causante
             and b.ben_relacion in (4,6,7,8)
             and bnf_cobertura    = (select min(mincob.bnf_cobertura)
                                     from rentarsv.beneficios mincob
                                     where mincob.bnf_poliza = b.ben_poliza);
        exception
          when no_data_found then
           v_grp_fam_ben_cony_mhn_cc := 0;
        end;

        begin
        select nvl(count(*),0)
        Into v_cant_hij_mismo_grp_fam
        from rentarsv.beneficios bnf, rentarsv.beneficiarios benef, rentarsv.persnat
        where benef.ben_linea = bnf.bnf_linea
        and benef.ben_producto = bnf.bnf_producto
        and benef.ben_documento = bnf.bnf_documento
        and benef.ben_poliza = bnf.bnf_poliza
        and benef.ben_causante = bnf.bnf_causante
        and benef.ben_beneficiario = bnf.bnf_beneficiario
        and bnf.bnf_poliza = benef.ben_poliza
        and bnf.bnf_causante = benef.ben_causante
        and bnf.bnf_grupo = v_grp_fam_ben_cony_mhn_cc
        and benef.ben_poliza = b.ben_poliza
        and benef.ben_relacion in (3,5)
        and benef.ben_ind_der_re = 2
        and bnf.bnf_estado = 0
        and benef.ben_beneficiario = nat_id
        and ((benef.ben_invalido not in (1,3)
              and ((TRUNC((MONTHS_BETWEEN(v_periodo_ult_dia, nat_fec_nacim) / 1),1)) <= 288)  --16/02/2024  hijos sanos hasta 24

              )
              or (benef.ben_invalido in (1,3) and nat_est_civil <> 1) --07/03/2024 considera hijos invalidos solteros
            );
        exception
             when no_data_found then
             v_cant_hij_mismo_grp_fam := 0;
             when others then
             v_cant_hij_mismo_grp_fam := 0;
        end;


        if v_tipo_beneficiario in (10,11) and b.ben_relacion in (4,8) then
          if v_cant_hij_mismo_grp_fam > 0 then
            v_tipo_beneficiario := 11;
           begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          elsif v_cant_hij_mismo_grp_fam <=0 then
            v_tipo_beneficiario := 10;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          elsif v_cant_hij_mismo_grp_fam is null then
            v_tipo_beneficiario := 10;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          end if;
        elsif v_tipo_beneficiario in (20,21) and b.ben_relacion in (6) then
          if v_cant_hij_mismo_grp_fam > 0 then
            v_tipo_beneficiario := 21;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          elsif v_cant_hij_mismo_grp_fam <=0 then
            v_tipo_beneficiario := 20;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          elsif v_cant_hij_mismo_grp_fam is null then
            v_tipo_beneficiario := 20;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          end if;
        elsif v_tipo_beneficiario in (50,51,52) and b.ben_relacion in (7) then
          if v_cant_hij_mismo_grp_fam > 0 then
            v_tipo_beneficiario := 51;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          elsif v_cant_hij_mismo_grp_fam <=0 then
            v_tipo_beneficiario := 50;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          elsif v_cant_hij_mismo_grp_fam is null then
            v_tipo_beneficiario := 50;
            begin
            update rentarsv.ris_treg_3
            set tip_ben=v_tipo_beneficiario
            where r3_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (b.ben_poliza, 10, '0')), '0000000000')
            and NUM_ORD_INF = b.ben_ord_svs_nn
	          and to_number(rut_afil) = b.nat_numrut;
           exception
             when others then
             rollback;
           end;
          end if;
        end if;*/
        --RF Caso 14

        v_sin_min_producto := 0;
        v_sin_min_siniestro := 0;
        --RF Caso 15
        begin
        select to_number(to_char(nvl(pol_fec_inicio,to_date('01/01/1900','dd/mm/yyyy')),'yyyymm'))
        into v_per_pol_fec_inicio
        from rentarsv.polizas
        where pol_poliza=b.ben_poliza;

        select to_number(to_char(add_months(to_date(to_char(v_periodo_id) || '01', 'yyyymmdd'), -2), 'yyyymm'))
        into v_per_trimestre
        from dual;

        select
        min(sin_producto),min(sin_tipo)
        into v_sin_min_producto, v_sin_min_siniestro
        from rentarsv.siniestros sin
        where sin.sin_poliza    = b.ben_poliza
        and sin.sin_id        = b.ben_causante
        and sin.sin_linea     = b.ben_linea
        and sin.sin_documento = b.ben_documento
        and sin.sin_producto  = b.ben_producto;
        exception
             when no_data_found then
             v_sin_min_producto := 0;
             v_sin_min_siniestro := 0;

        end;

        if v_sin_min_producto in (606,607) and v_sin_min_siniestro = 8 and v_per_trimestre <= v_per_pol_fec_inicio then

          begin
            update rentarsv.ris_treg_2
            set TIP_PENS = '05'
            where r2_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (v_pol_poliza, 10, '0')), '0000000000');
           exception
             when others then
             rollback;
           end;
        end if;
        --RF Caso 15

        --RF Caso 16
        begin
        select
        min(sin_producto),min(sin_tipo)
        into v_sin_min_producto, v_sin_min_siniestro
        from rentarsv.siniestros sin
        where sin.sin_poliza    = b.ben_poliza
        and sin.sin_id        = b.ben_causante
        and sin.sin_linea     = b.ben_linea
        and sin.sin_documento = b.ben_documento
        and sin.sin_producto  = b.ben_producto;
        exception
             when no_data_found then
             v_sin_min_producto := 0;
             v_sin_min_siniestro := 0;
         end;

        if v_sin_min_producto not in (606,607) and v_sin_min_siniestro = 8 and v_per_trimestre <= v_per_pol_fec_inicio then
          begin
            update rentarsv.ris_treg_2
            set TIP_PENS = '04'
            where r2_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (v_pol_poliza, 10, '0')), '0000000000');
           exception
             when others then
             rollback;
           end;
        end if;
        --RF Caso 16

        --RF Caso 17
        begin
        select pol_mod_pension
          into v_pol_mod_pension_post
          from pensiones.polizas
         where pol_poliza    = v_pol_poliza
           and pol_linea     = v_pol_linea
           and pol_producto  = v_pol_producto
           and pol_documento = v_pol_documento;
        exception
           when no_data_found then
                if v_pol_producto in (603, 606) then
                   v_pol_mod_pension_post := 'I';
                else
                   v_pol_mod_pension_post := 'D';
                end if;
        end;

        if v_pol_mod_pension_post = 'P' and v_per_trimestre <= v_per_pol_fec_inicio then
           v_tipo_renta_post := 3000;--svsp_tipo_renta_nn

           begin
            update rentarsv.ris_treg_2
            set TIP_REN = '3000'
            where r2_cia_id = 2
	          and fec_cie = to_char(v_periodo_ult_dia,'yyyymmdd')
	          and num_pol = NVL (TO_CHAR (LPAD (v_pol_poliza, 10, '0')), '0000000000');
           exception
             when others then
             rollback;
           end;
        end if;
        --RF Caso 17

      end loop;

      /* Ciclo Beneficiarios de SVS_BENEFICIARIO */
      v_hay_benef_legales := 'NO';

      vl_cont_reg := vl_cont_reg + 1;

      if vl_cont_reg = 100 then
        vl_cont_reg := 0;
        commit;
      end if;

      <<siguiente_poliza>>

      null;
    end loop;
    /* fin ciclo polizas. */

    commit;
  exception
    when e_error then
      rollback;
      raise_application_error(-20102, v_msj_error);
    when others then
      rollback;
      raise_application_error(-20102, sqlerrm || ', Poliza : ' || v_pol_poliza || ' : ' || v_msj_error);
  end SP_GEN_MODIF_RIS_PROY;
/
