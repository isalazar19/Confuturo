select tip_reg
    || lpad(trim(num_pol), 10, '0')
    || lpad(trim(num_per_inf), 2, '0')
    || lpad(trim(rut_afil), 9, '0')
    || lpad(dig_ver, 1, ' ')
    || lpad(trim(tip_pens), 2, '0')
    || lpad(cia_obl, 1, ' ')
    || lpad(trim(vig_pens), 1, '0')
    || lpad(trim(cod_afp), 2, '0')
    || lpad(tip_afil, 1, ' ')
    || LPAD(TRIM(REPLACE(REPLACE(cta_ind, ',', ' '),' ','')), 7, '0')
    || LPAD(TRIM(REPLACE(REPLACE(ing_bas_uf, ',', ' '),' ','')), 5, '0')
    || lpad(trim(por_cub), 3, '0')
    || lpad(trim(fec_vig_ini), 8, '0')
    || LPAD(TRIM(REPLACE(REPLACE(pri_uni, ',', ' '),' ','')), 7, '0')
    || LPAD(TRIM(REPLACE(REPLACE(ren_mens, ',', ' '),' ','')), 5, '0')
    || lpad(trim(tip_ren), 4, '0')
    || lpad(trim(mod_ren), 4, '0')

    || lpad(R2_TIPO_OPERACION_RV, 2, ' ')  
    || lpad(trim(R2_MESES_RE), 3, '0') 
    || LPAD(TRIM(REPLACE(REPLACE(r2_porc_re, ',', ' '),' ','')), 5, '0')

    || LPAD(TRIM(REPLACE(REPLACE(tas_cto_emi, ',', ' '),' ','')), 4, '0')
    || LPAD(TRIM(REPLACE(REPLACE(tas_vta, ',', ' '),' ','')), 4, '0')
    || lpad(trim(num_reas), 1, '0')
    || lpad(trim(cia_reas_1), 2, '0')
    || lpad(ope_reas_1, 1, ' ')
    || lpad(mod_reas_1, 1, ' ')
    || LPAD(TRIM(REPLACE(REPLACE(por_ret_1, ',', ' '),' ','')), 5, '0')
    || lpad(trim(fec_ini_1), 8, '0')
    || lpad(trim(fec_ter_1), 8, '0')
    || LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_1, ',', ' '),' ','')), 4, '0')
    || lpad(trim(fec_reas_1), 8, '0')
    || lpad(trim(fec_vig_reas_1), 8, '0')
    || lpad(trim(cia_reas_2), 2, '0')
    || lpad(ope_reas_2, 1, ' ')
    || lpad(mod_reas_2, 1, ' ')
    || LPAD(TRIM(REPLACE(REPLACE(por_ret_2, ',', ' '),' ','')), 5, '0')
    || lpad(trim(fec_ini_2), 8, '0')
    || lpad(trim(fec_ter_2), 8, '0')
    || LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_2, ',', ' '),' ','')), 4, '0')
    || lpad(trim(fec_reas_2), 8, '0')
    || lpad(trim(fec_vig_reas_2), 8, '0')
    || lpad(trim(cia_reas_3), 2, '0')
    || lpad(ope_reas_3, 1, ' ')
    || lpad(mod_reas_3, 1, ' ')
    || LPAD(TRIM(REPLACE(REPLACE(por_ret_2, ',', ' '),' ','')), 5, '0')
    || lpad(trim(fec_ini_3), 8, '0')
    || lpad(trim(fec_ter_3), 8, '0')
    || LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_3, ',', ' '),' ','')), 4, '0')
    || lpad(trim(fec_reas_3), 8, '0')
    || lpad(trim(fec_vig_reas_3), 8, '0')

    || lpad(trim(R2_POLIZA_CON_ANTICIPO_RV), 1, '0') 

    || lpad(trim(fec_recal_act), 8, '0')
    || lpad(trim(fec_recal_ant), 8, '0')
    || LPAD(TRIM(REPLACE(REPLACE(ren_ant_recal_act, ',', ' '),' ','')), 5, '0') 
    || LPAD(TRIM(REPLACE(REPLACE(ren_ant_recal_ant, ',', ' '),' ','')), 5, '0') 
    || rpad(' ', 60, ' ') INFORMACION
   
    ,TIP_REG TIPO_REG
    ,lpad(trim(num_pol), 10, '0') N_INTERNO
    ,lpad(trim(num_per_inf), 2, '0') N_PERSONAS
    ,lpad(trim(rut_afil), 9, '0') RUT_AFI
    ,lpad(dig_ver, 1, ' ') DV_AFI
    ,lpad(trim(tip_pens), 2, '0') TIPO_PENSION
    ,lpad(cia_obl, 1, ' ') C�A_OBLIGADA
    ,lpad(trim(vig_pens), 1, '0') VIG_PEN
    ,lpad(trim(cod_afp), 2, '0') COD_AFP
    ,lpad(tip_afil, 1, ' ') TIPO_AFI
    ,LPAD(TRIM(REPLACE(REPLACE(cta_ind, ',', ' '),' ','')), 7, '0') CTA_INDIV
    ,LPAD(TRIM(REPLACE(REPLACE(ing_bas_uf, ',', ' '),' ','')), 5, '0') ING_BASE_UF
    ,lpad(trim(por_cub), 3, '0') PORCENTAJE_COBERTURA
    ,lpad(trim(fec_vig_ini), 8, '0') FEC_VIG_INICIAL
    ,LPAD(TRIM(REPLACE(REPLACE(pri_uni, ',', ' '),' ','')), 7, '0') PRIMA_UNICA
    ,LPAD(TRIM(REPLACE(REPLACE(ren_mens, ',', ' '),' ','')), 5, '0') RENTA_MENSUAL
    ,lpad(trim(tip_ren), 4, '0') TIPO_RENTA
    ,lpad(trim(mod_ren), 4, '0') MODAL_RENTA
    ,lpad(R2_TIPO_OPERACION_RV, 2, ' ') TIPO_OPERACION_RV
    ,lpad(trim(R2_MESES_RE), 3, '0') PERIODO_AUMENTO
    ,LPAD(TRIM(REPLACE(REPLACE(r2_porc_re, ',', ' '),' ','')), 5, '0') PORCENTAJE_AUMENTO
    ,LPAD(TRIM(REPLACE(REPLACE(tas_cto_emi, ',', ' '),' ','')), 4, '0') TASA_COSTO_EMISION
    ,LPAD(TRIM(REPLACE(REPLACE(tas_vta, ',', ' '),' ','')), 4, '0') TASA_VTA
    ,lpad(trim(num_reas), 1, '0') N_REASEG
    ,lpad(trim(cia_reas_1), 2, '0') C�A_REASEG1
    ,lpad(ope_reas_1, 1, ' ') OPERA_REAS1
    ,lpad(mod_reas_1, 1, ' ') MODO_REASEG1
    ,LPAD(TRIM(REPLACE(REPLACE(por_ret_1, ',', ' '),' ','')), 5, '0') PORCENTAJE_RETENIDO1
    ,lpad(trim(fec_ini_1), 8, '0') FEC_INICIO1
    ,lpad(trim(fec_ter_1), 8, '0') FEC_TERMINO1
    ,LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_1, ',', ' '),' ','')), 4, '0') TASA_COSTO_EQUIV_RET1
    ,lpad(trim(fec_reas_1), 8, '0') FEC_SUSCRIP_REAS1
    ,lpad(trim(fec_vig_reas_1), 8, '0') FEC_VIG_REASEG1
    ,lpad(trim(cia_reas_2), 2, '0') C�A_REASEG2
    ,lpad(ope_reas_2, 1, ' ') OPER_REASEG2
    ,lpad(mod_reas_2, 1, ' ') MODO_REASEG2
    ,LPAD(TRIM(REPLACE(REPLACE(por_ret_2, ',', ' '),' ','')), 5, '0') PORCENTAJE_RETENIDO2
    ,lpad(trim(fec_ini_2), 8, '0') FEC_INICIO2
    ,lpad(trim(fec_ter_2), 8, '0') FEC_TERMINO2
    ,LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_2, ',', ' '),' ','')), 4, '0') TASA_COSTO_EQUIV_RET2
    ,lpad(trim(fec_reas_2), 8, '0') FEC_SUSC_REASEG2
    ,lpad(trim(fec_vig_reas_2), 8, '0') FEC_VIG_REASEG2
    ,lpad(trim(cia_reas_3), 2, '0') C�A_REASEG3
    ,lpad(ope_reas_3, 1, ' ') OPER_REASEG3
    ,lpad(mod_reas_3, 1, ' ') MODO_REASEG3
    ,LPAD(TRIM(REPLACE(REPLACE(por_ret_3, ',', ' '),' ','')), 5, '0') PORCENTAJE_RETENIDO3
    ,lpad(trim(fec_ini_3), 8, '0') FEC_INICIO3
    ,lpad(trim(fec_ter_3), 8, '0') FEC_TERMINO3
    ,LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_3, ',', ' '),' ','')), 4, '0') TASA_COSTO_EQUIV_RET3
    ,lpad(trim(fec_reas_3), 8, '0') FEC_SUSC_REASEG3
    ,lpad(trim(fec_vig_reas_3), 8, '0') FEC_VIG_REASEG3
    ,lpad(trim(R2_POLIZA_CON_ANTICIPO_RV), 1, '0') POLIZA_CON_ANTICIPO_RRVV
    ,lpad(trim(fec_recal_act), 8, '0') FEC_RECAL_ACTUAL
    ,lpad(trim(fec_recal_ant), 8, '0') FEC_RECAL_ANTERIOR
    ,LPAD(TRIM(REPLACE(REPLACE(ren_ant_recal_act, ',', ' '),' ','')), 5, '0') RTA_ANTERIOR_RECAL_ACTUAL
    ,LPAD(TRIM(REPLACE(REPLACE(ren_ant_recal_ant, ',', ' '),' ','')), 5, '0') RTA_ANTERIOR_RECAL_ANTERIOR
  from rentarsv.ris_treg_2
 where r2_cia_id = 2
   and fec_cie   = 20231231
   and tip_reg   = '2' 
   and num_pol=1;

select tip_reg
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

    || lpad(trim(R3_PORC_ANTICIPO_RV), 4, '0') 
    || lpad(trim(R3_PORC_PNS_POST_ANTIC), 4, '0') 
    || lpad(trim(R3_FEC_ANTICIPO_RV), 8, '0') 
    
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
    || rpad(' ', 42, ' ') INFORMACION
    
    ,TIP_REG TIPO_REG
    ,lpad(trim(num_pol), 10, '0') N_INTERNO
    ,lpad(trim(num_ord_inf), 2, '0') N_ORDEN
    ,lpad(trim(rut_afil), 9, '0') RUT
    ,lpad(nvl(dig_ver, rpad(' ', 1, ' ')), 1, ' ') DV
    ,rpad(nvl(trim(ape_pat), rpad(' ', 25, ' ')), 25, ' ') APE_PATERNO
    ,rpad(nvl(trim(ape_mat), rpad(' ', 25, ' ')), 25, ' ') APE_MATERNO
    ,rpad(nvl(trim(nombres), rpad(' ', 30, ' ')), 30, ' ') NOMBRES
    ,lpad(trim(sexo), 1, ' ') SEXO
    ,lpad(trim(tip_ben), 2, '0') TIPO_BENEF
    ,lpad(trim(sit_inv), 1, ' ') SITUACION_IN
    ,lpad(trim(fec_nac), 8, '0') FEC_NAC
    ,lpad(trim(fec_mue), 8, '0') FEC_MUERTE
    ,lpad(trim(fec_inv), 8, '0') FEC_INVALIDEZ
    ,lpad(trim(der_pens), 2, '0') DERECHO_PEN
    ,lpad(trim(req_pens), 1, '0') REQUI_PEN
    ,lpad(trim(rel_hij_mad), 2, '0') REL_HIJO_MADRE
    ,lpad(trim(fec_nac_hij_men), 8, '0') FEC_NAC_HIJO_MENOR
    ,lpad(trim(der_a_crec), 1, ' ') DERECHO_A_CRECER
    ,lpad(trim(por_pens), 5, '0') PORCENTAJE_PENSION
    ,lpad(trim(per_pens), 5, '0') PEN_PERSONA
    ,lpad(trim(R3_PORC_ANTICIPO_RV), 4, '0') PORCENTAJE_ANTICIPO_RRVV
    ,lpad(trim(R3_PORC_PNS_POST_ANTIC), 4, '0') PORC_PENS_POST_ANTIC
    ,lpad(trim(R3_FEC_ANTICIPO_RV), 8, '0') FECHA_ANTICIPO_RRVV 
    ,lpad(trim(rt_base_tot), 7, '0') RT_BASE_TOTAL
    ,lpad(trim(rt_base_tabla_vigente_total), 7, '0') RT_BASE_2009_TOTAL
    ,lpad(trim(rt_fin_2004_85_tot), 7, '0') RT_FINANC_2004_85_TOTAL
    ,lpad(trim(rt_fin_st_rv_85_tot), 7, '0') RT_FINANC_STOCK_RV85_TOTAL
    ,lpad(trim(rt_fin_2004_2006_tot), 7, '0') RT_FINANC_2004_2006_TOTAL
    ,lpad(trim(rt_fin_2009_2006_tot), 7, '0') RT_FINANC_2009_2006_TOTAL
    ,lpad(trim(rt_financiera_2014_total), 7, '0') RT_FINANC_2014_TOTAL
    ,lpad(trim(rt_base_ret), 7, '0') RT_BASE_RET
    ,lpad(trim(rt_base_tabla_vigente_retenida), 7, '0') RT_BASE_2009_RET
    ,lpad(trim(rt_fin_2004_85_ret), 7, '0') RT_FINANC_2004_85_RET
    ,lpad(trim(rt_fin_st_rv_85_ret), 7, '0') RT_FINANC_STOCK_RV_85_RET
    ,lpad(trim(rt_fin_2004_2006_ret), 7, '0') RT_FINANC_2004_2006_RET
    ,lpad(trim(rt_fin_2009_2006_ret), 7, '0') RT_FINANC_2009_2006_RET
    ,lpad(trim(rt_financiera_2014_retenida), 7, '0') RT_FINANC_2014_RET
    ,lpad(trim(mto_pag_ben_est_1), 8, '0') MONTO_PAGO_1
    ,lpad(trim(mto_pag_ben_est_2), 8, '0') MONTO_PAGO_2
    ,lpad(trim(mto_pag_ben_est_3), 8, '0') MONTO_PAGO_3
    ,lpad(trim(tip_pag_ben_est_1), 1, ' ') TIPO_PAGO_1
    ,lpad(trim(tip_pag_ben_est_2), 1, ' ') TIPO_PAGO_2
    ,lpad(trim(tip_pag_ben_est_3), 1, ' ') TIPO_PAGO_3
    ,lpad(trim(mto_bhnv_1), 6, '0') BHN1
    ,lpad(trim(mto_bhnv_2), 6, '0') BHN2
    ,lpad(trim(mto_bhnv_3), 6, '0') BHN3
  from rentarsv.ris_treg_3
 where r3_cia_id = 2
   and fec_cie   = 20231231
   and tip_reg   = '3' 
   and num_pol=1;

/* cambiar formato sin coma */
/*select 'sin_comas' 
 , LPAD(TRIM(REPLACE(REPLACE('0000,00', ',', ' '),' ','')), 7, '0') cta_ind
 , LPAD(TRIM(REPLACE(REPLACE('00,00', ',', ' '),' ','')), 5, '0') ing_base_uf
 , LPAD(TRIM(REPLACE(REPLACE('2965,66', ',', ' '),' ','')), 7, '0') prima_unica
 , LPAD(TRIM(REPLACE(REPLACE('15,30', ',', ' '),' ','')), 5, '0') renta_mensual
 , LPAD(TRIM(REPLACE(REPLACE('00,00', ',', ' '),' ','')), 5, '0') porcentaje_aumento
 , LPAD(TRIM(REPLACE(REPLACE('4,44', ',', ' '),' ','')), 4, '0') tasa_costo_emision
 , LPAD(TRIM(REPLACE(REPLACE('5,35', ',', ' '),' ','')), 4, '0') tasa_vta
 , LPAD(TRIM(REPLACE(REPLACE('00,00', ',', ' '),' ','')), 5, '0') porcentaje_retenido1
 , LPAD(TRIM(REPLACE(REPLACE('0,00', ',', ' '),' ','')), 4, '0') tasa_costo_equiv_ret1
 , LPAD(TRIM(REPLACE(REPLACE('00,00', ',', ' '),' ','')), 5, '0') porcentaje_retenido2
 , LPAD(TRIM(REPLACE(REPLACE('0,00', ',', ' '),' ','')), 4, '0') tasa_costo_equiv_ret2
 , LPAD(TRIM(REPLACE(REPLACE('00,00', ',', ' '),' ','')), 5, '0') porcentaje_retenido3
 , LPAD(TRIM(REPLACE(REPLACE('0,00', ',', ' '),' ','')), 4, '0') tasa_costo_equiv_ret3
 , LPAD(TRIM(REPLACE(REPLACE('16,93', ',', ' '),' ','')), 5, '0') rta_anterior_recal_actual
 , LPAD(TRIM(REPLACE(REPLACE('00,00', ',', ' '),' ','')), 5, '0') rta_anterior_recal_anterior
 from dual
union*/
select '1' 
 , cta_ind
 , ing_bas_uf
 , pri_uni
 , ren_mens
 , r2_porc_re
 , tas_cto_emi
 , tas_vta
 , por_ret_1
 , tas_cto_equ_ret_1
 , por_ret_2
 , tas_cto_equ_ret_2
 , por_ret_3
 , tas_cto_equ_ret_3
 , ren_ant_recal_act
 , ren_ant_recal_ant
from rentarsv.ris_treg_2
 where r2_cia_id = 2
   and fec_cie   = 20231231
   and tip_reg   = '2' 
   and num_pol=1
union
select '2' 
 , LPAD(TRIM(REPLACE(REPLACE(cta_ind, ',', ' '),' ','')), 7, '0') cta_ind
 , LPAD(TRIM(REPLACE(REPLACE(ing_bas_uf, ',', ' '),' ','')), 5, '0') ing_base_uf
 , LPAD(TRIM(REPLACE(REPLACE(pri_uni, ',', ' '),' ','')), 7, '0') prima_unica
 , LPAD(TRIM(REPLACE(REPLACE(ren_mens, ',', ' '),' ','')), 5, '0') renta_mensual
 , LPAD(TRIM(REPLACE(REPLACE(r2_porc_re, ',', ' '),' ','')), 5, '0') porcentaje_aumento
 , LPAD(TRIM(REPLACE(REPLACE(tas_cto_emi, ',', ' '),' ','')), 4, '0') tasa_costo_emision
 , LPAD(TRIM(REPLACE(REPLACE(tas_vta, ',', ' '),' ','')), 4, '0') tasa_vta
 , LPAD(TRIM(REPLACE(REPLACE(por_ret_1, ',', ' '),' ','')), 5, '0') porcentaje_retenido1
 , LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_1, ',', ' '),' ','')), 4, '0') tasa_costo_equiv_ret1
 , LPAD(TRIM(REPLACE(REPLACE(por_ret_2, ',', ' '),' ','')), 5, '0') porcentaje_retenido2
 , LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_2, ',', ' '),' ','')), 4, '0') tasa_costo_equiv_ret2
 , LPAD(TRIM(REPLACE(REPLACE(por_ret_3, ',', ' '),' ','')), 5, '0') porcentaje_retenido3
 , LPAD(TRIM(REPLACE(REPLACE(tas_cto_equ_ret_3, ',', ' '),' ','')), 4, '0') tasa_costo_equiv_ret3
 , LPAD(TRIM(REPLACE(REPLACE(ren_ant_recal_act, ',', ' '),' ','')), 5, '0') rta_anterior_recal_actual
 , LPAD(TRIM(REPLACE(REPLACE(ren_ant_recal_ant, ',', ' '),' ','')), 5, '0') rta_anterior_recal_anterior
from rentarsv.ris_treg_2
 where r2_cia_id = 2
   and fec_cie   = 20231231
   and tip_reg   = '2' 
   and num_pol=1
