select '0'
      ,tip_reg
    ,'00'
      ,'1'
    || trim(fec_cie)
    || trim(rut_cia)
    || trim(dig_ver)
    || rpad(trim(nom_cia), 60, ' ')
  || rpad(' ', 235, ' ')
  from rentarsv.ris_treg_1
 where r1_cia_id = 2
   and fec_cie   = 20230331
   and tip_reg   = '1' 
union 
select num_pol
      ,tip_reg
      ,'00'
      ,   '2'
    || lpad(trim(num_pol), 10, '0')
    || lpad(trim(num_per_inf), 2, '0')
    || lpad(trim(rut_afil), 9, '0')
    || lpad(dig_ver, 1, ' ')
    || lpad(trim(tip_pens), 2, '0')
    || lpad(cia_obl, 1, ' ')
    || lpad(trim(vig_pens), 1, '0')
    || lpad(trim(cod_afp), 2, '0')
    || lpad(tip_afil, 1, ' ')
    || lpad(trim(cta_ind), 7, '0')
    || lpad(trim(ing_bas_uf), 5, '0')
    || lpad(trim(por_cub), 3, '0')
    || lpad(trim(fec_vig_ini), 8, '0')
    || lpad(trim(pri_uni), 7, '0')
    || lpad(trim(ren_mens), 5, '0')
    || lpad(trim(tip_ren), 4, '0')
    || lpad(trim(mod_ren), 4, '0')

    || lpad(R2_TIPO_OPERACION_RV, 2, ' ')  /* HU PR-112 */
    || lpad(trim(R2_MESES_RE), 3, '0') /* HU PR-112 */
    || lpad(trim(R2_PORC_RE), 5, '0')  /* HU PR-112 */

    || lpad(trim(tas_cto_emi), 4, '0')
    || lpad(trim(tas_vta), 4, '0')
    || lpad(trim(num_reas), 1, '0')
    || lpad(trim(cia_reas_1), 2, '0')
    || lpad(ope_reas_1, 1, ' ')
    || lpad(mod_reas_1, 1, ' ')
    || lpad(trim(por_ret_1), 5, '0')
    || lpad(trim(fec_ini_1), 8, '0')
    || lpad(trim(fec_ter_1), 8, '0')
    || lpad(trim(tas_cto_equ_ret_1), 4, '0')
    || lpad(trim(fec_reas_1), 8, '0')
    || lpad(trim(fec_vig_reas_1), 8, '0')
    || lpad(trim(cia_reas_2), 2, '0')
    || lpad(ope_reas_2, 1, ' ')
    || lpad(mod_reas_2, 1, ' ')
    || lpad(trim(por_ret_2), 5, '0')
    || lpad(trim(fec_ini_2), 8, '0')
    || lpad(trim(fec_ter_2), 8, '0')
    || lpad(trim(tas_cto_equ_ret_2), 4, '0')
    || lpad(trim(fec_reas_2), 8, '0')
    || lpad(trim(fec_vig_reas_2), 8, '0')
    || lpad(trim(cia_reas_3), 2, '0')
    || lpad(ope_reas_3, 1, ' ')
    || lpad(mod_reas_3, 1, ' ')
    || lpad(trim(por_ret_3), 5, '0')
    || lpad(trim(fec_ini_3), 8, '0')
    || lpad(trim(fec_ter_3), 8, '0')
    || lpad(trim(tas_cto_equ_ret_3), 4, '0')
    || lpad(trim(fec_reas_3), 8, '0')
    || lpad(trim(fec_vig_reas_3), 8, '0')

    || lpad(trim(R2_POLIZA_CON_ANTICIPO_RV), 1, '0') /* HU PR-112 */

    || lpad(trim(fec_recal_act), 8, '0')
    || lpad(trim(fec_recal_ant), 8, '0')
    || lpad(trim(ren_ant_recal_act), 5, '0')
    || lpad(trim(ren_ant_recal_ant), 5, '0')
    || rpad(' ', 60, ' ') as informacion  
    /*, '2' TIPO_REGISTRO
    , lpad(trim(num_pol), 10, '0') NRO_INTERNO
    , lpad(trim(num_per_inf), 2, '0') NRO_PERSONAS
    , lpad(trim(rut_afil), 9, '0') RUT_AFI
    , lpad(dig_ver, 1, ' ') DV_AFI
    , lpad(trim(tip_pens), 2, '0') TIPO_PENSION
    , lpad(cia_obl, 1, ' ') CIA_OBLIGADA
    , lpad(trim(vig_pens), 1, '0') VIG_PEN
    , lpad(trim(cod_afp), 2, '0') COD_AFP
    , lpad(tip_afil, 1, ' ') TIPO_AFI
    , lpad(trim(cta_ind), 7, '0') CTA_INDIV
    , lpad(trim(ing_bas_uf), 5, '0') ING_BASE_UF
    , lpad(trim(por_cub), 3, '0') PORC_COBERTURA
    , lpad(trim(fec_vig_ini), 8, '0') FEC_VIG_INICIAL
    , lpad(trim(pri_uni), 7, '0') PRIMA_UNICA
    , lpad(trim(ren_mens), 5, '0') RTA_MENSUAL
    , lpad(trim(tip_ren), 4, '0') TIPO_RTA
    , lpad(trim(mod_ren), 4, '0') MODAL_RTA

    , lpad(R2_TIPO_OPERACION_RV, 2, ' ') TIPO_OPERACION_RV \* HU PR-112 *\
    , lpad(trim(R2_MESES_RE), 3, '0') PERIODO_AUMENTO \* HU PR-112 *\
    , lpad(trim(R2_PORC_RE), 5, '0') PORCENTAJE_AUMENTO \* HU PR-112 *\

    , lpad(trim(tas_cto_emi), 4, '0') TASA_COSTO_EMISION
    , lpad(trim(tas_vta), 4, '0') TASA_VTA
    , lpad(trim(num_reas), 1, '0') NRO_REASEG
    , lpad(trim(cia_reas_1), 2, '0') CIA_REASEG
    , lpad(ope_reas_1, 1, ' ') OPERA_REAS
    , lpad(mod_reas_1, 1, ' ') MODO_REASEG
    , lpad(trim(por_ret_1), 5, '0') PORCENTAJE_RETENIDO
    , lpad(trim(fec_ini_1), 8, '0') FEC_INICIO
    , lpad(trim(fec_ter_1), 8, '0') FEC_TERMINO
    , lpad(trim(tas_cto_equ_ret_1), 4, '0') TASA_COSTO_EQUIV_RET
    , lpad(trim(fec_reas_1), 8, '0') FEC_SUSCRIP_REAS
    , lpad(trim(fec_vig_reas_1), 8, '0') FEC_VIG_REASEG
    , lpad(trim(cia_reas_2), 2, '0') CIA_REASEG
    , lpad(ope_reas_2, 1, ' ') OPER_REASEG
    , lpad(mod_reas_2, 1, ' ') MODO_REASEG
    , lpad(trim(por_ret_2), 5, '0') PORCENTAJE_RETENIDO
    , lpad(trim(fec_ini_2), 8, '0') FEC_INICIO
    , lpad(trim(fec_ter_2), 8, '0') FEC_TERMINO
    , lpad(trim(tas_cto_equ_ret_2), 4, '0') TASA_COSTO_EQUIV_RET
    , lpad(trim(fec_reas_2), 8, '0') FEC_SUSC_REASEG
    , lpad(trim(fec_vig_reas_2), 8, '0') FEC_VIG_REASEG
    , lpad(trim(cia_reas_3), 2, '0') CiA_REASEG
    , lpad(ope_reas_3, 1, ' ') OPER_REASEG
    , lpad(mod_reas_3, 1, ' ') MODO_REASEG
    , lpad(trim(por_ret_3), 5, '0') PORCENTAJE_RETENIDO
    , lpad(trim(fec_ini_3), 8, '0') FEC_INICIO
    , lpad(trim(fec_ter_3), 8, '0') FEC_TERMINO
    , lpad(trim(tas_cto_equ_ret_3), 4, '0') TASA_COSTO_EQUIV_RET
    , lpad(trim(fec_reas_3), 8, '0') FEC_SUSC_REASEG
    , lpad(trim(fec_vig_reas_3), 8, '0') FEC_VIG_REASEG

    , lpad(trim(R2_POLIZA_CON_ANTICIPO_RV), 1, '0') POLIZA_CON_ANTICIPO_RRVV \* HU PR-112 *\

    , lpad(trim(fec_recal_act), 8, '0') FEC_RECAL_ACTUAL
    , lpad(trim(fec_recal_ant), 8, '0') FEC_RECAL_ANTERIOR
    , lpad(trim(ren_ant_recal_act), 5, '0') RENTA_ANTERIOR_RECAL_ACTUAL
    , lpad(trim(ren_ant_recal_ant), 5, '0') RENTA_ANTERIOR_RECAL_ANTERIOR
    , rpad(' ', 60, ' ') BLANCO*/
  from rentarsv.ris_treg_2
 where r2_cia_id = 2
   and fec_cie   = 20230331
   and tip_reg   = '2' 
   and num_pol = 668806
union 
select num_pol
      ,tip_reg
      ,num_ord_inf
      ,'3'
    || lpad(trim(num_pol), 10, '0')
    || lpad(trim(num_ord_inf), 2, '0')
    || lpad(trim(rut_afil), 9, '0')
    || lpad(nvl(dig_ver, rpad(' ', 1, ' ')), 1, ' ')
    || rpad(nvl(trim(ape_pat), rpad(' ', 25, ' ')), 25, ' ')
    || rpad(nvl(trim(ape_mat), rpad(' ', 25, ' ')), 25, ' ')
    || rpad(nvl(trim(nombres), rpad(' ', 30, ' ')), 30, ' ')
    || lpad(trim(sexo), 1, ' ')
    || lpad(trim(tip_ben), 2, '0')
    || lpad(trim(sit_inv), 1, ' ')
    || lpad(trim(fec_nac), 8, '0')
    || lpad(trim(fec_mue), 8, '0')
    || lpad(trim(fec_inv), 8, '0')
    || lpad(trim(der_pens), 2, '0')
    || lpad(trim(req_pens), 1, '0')
    || lpad(trim(rel_hij_mad), 2, '0')
    || lpad(trim(fec_nac_hij_men), 8, '0')
    || lpad(trim(der_a_crec), 1, ' ')
    || lpad(trim(por_pens), 5, '0')
    || lpad(trim(per_pens), 5, '0')

    || lpad(trim(R3_PORC_ANTICIPO_RV), 4, '0') /* HU PR-112 */
    || lpad(trim(R3_PORC_PNS_POST_ANTIC), 4, '0') /* HU PR-112 */
    || lpad(trim(R3_FEC_ANTICIPO_RV), 8, '0') /* HU PR-112 */
    
    || lpad(trim(rt_base_tot), 7, '0')
    || lpad(trim(rt_base_tabla_vigente_total), 7, '0')
    || lpad(trim(rt_fin_2004_85_tot), 7, '0')
    || lpad(trim(rt_fin_st_rv_85_tot), 7, '0')
    || lpad(trim(rt_fin_2004_2006_tot), 7, '0')
    || lpad(trim(rt_fin_2009_2006_tot), 7, '0')
    || lpad(trim(rt_financiera_2014_total), 7, '0')
    || lpad(trim(rt_base_ret), 7, '0')
    || lpad(trim(rt_base_tabla_vigente_retenida), 7, '0')
    || lpad(trim(rt_fin_2004_85_ret), 7, '0')
    || lpad(trim(rt_fin_st_rv_85_ret), 7, '0')
    || lpad(trim(rt_fin_2004_2006_ret), 7, '0')
    || lpad(trim(rt_fin_2009_2006_ret), 7, '0')
    || lpad(trim(rt_financiera_2014_retenida), 7, '0')
    || lpad(trim(mto_pag_ben_est_1), 8, '0')
    || lpad(trim(mto_pag_ben_est_2), 8, '0')
    || lpad(trim(mto_pag_ben_est_3), 8, '0')
    || lpad(trim(tip_pag_ben_est_1), 1, ' ')
    || lpad(trim(tip_pag_ben_est_2), 1, ' ')
    || lpad(trim(tip_pag_ben_est_3), 1, ' ')
    || lpad(trim(mto_bhnv_1), 6, '0')
    || lpad(trim(mto_bhnv_2), 6, '0')
    || lpad(trim(mto_bhnv_3), 6, '0')
    || rpad(' ', 42, ' ')
  from rentarsv.ris_treg_3
 where r3_cia_id = 2
   and fec_cie   = 20230331
   and tip_reg   = '3' 
   and num_pol = 668806
union 
select '9999999999'
      ,tip_reg
      ,'00'
      ,'4'
    || lpad(trim(num_pol_inf), 6, '0')
    || lpad(trim(num_reg_inf), 6, '0')
    || lpad(trim(tot_rt_base_tot), 17, '0')
    || lpad(trim(tot_rt_base_tabla_vig_tot), 17, '0')
    || lpad(trim(tot_rt_fin_2004_85_tot), 17, '0')
    || lpad(trim(tot_rt_fin_st_rv_85_tot), 17, '0')
    || lpad(trim(tot_rt_fin_2004_2006_tot), 17, '0')
    || lpad(trim(tot_rt_fin_2009_2006_tot), 17, '0')
    || lpad(trim(tot_rt_fin_2014_tot), 17, '0')
    || lpad(trim(tot_rt_base_ret), 17, '0')
    || lpad(trim(tot_rt_base_tabla_vig_ret), 17, '0')
    || lpad(trim(tot_rt_fin_2004_85_ret), 17, '0')
    || lpad(trim(tot_rt_fin_st_rv_85_ret), 17, '0')
    || lpad(trim(tot_rt_fin_2004_2006_ret), 17, '0')
    || lpad(trim(tot_rt_fin_2009_2006_ret), 17, '0')
    || lpad(trim(tot_rt_fin_2014_ret), 17, '0')
   || rpad(' ', 131, ' ')
  from rentarsv.ris_treg_4
 where r4_cia_id = 2
   and fec_cie   = 20230331
   and tip_reg   = '4' 
 order by 1 asc
         ,2 asc
         ,3 asc;
