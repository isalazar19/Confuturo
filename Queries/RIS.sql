/* RIS */

SELECT * FROM rentarsv.ris_treg_1 WHERE r1_cia_id =2 AND fec_cie = 20231231;

SELECT COUNT(*) T_REG2 FROM rentarsv.ris_treg_2 WHERE r2_cia_id =2 AND fec_cie = 20231231;  

SELECT COUNT(*) T_REG3 FROM rentarsv.ris_treg_3 WHERE r3_cia_id =2 AND fec_cie = 20231231;

SELECT * FROM rentarsv.ris_treg_4 WHERE r4_cia_id =2 AND fec_cie = 20231231;

SELECT COUNT(*) FROM rentarsv.svs_poliza WHERE svsp_periodo_id = 202312;

SELECT COUNT(*) FROM rentarsv.svs_beneficiario WHERE svsb_periodo_id = 202312;



SELECT   NVL (TO_CHAR (LPAD (svsb_poliza_id, 10, '0')), '0000000000')
     , NVL (TO_CHAR (LPAD (svsb_numero_de_orden_id, 2, '0')), '00')
     , NVL (TO_CHAR (LPAD (svsb_rut_afil_o_benef_real, 9, '0')), '000000000')
     , NVL (TO_CHAR (LPAD (svsb_dv_afil_o_benef_real, 1, ' ')), ' ')
     , TRANSLATE (NVL (TO_CHAR (RPAD (svsb_ape_pat_afil_o_benef_real, 25, ' ')), '                         '), '·ÈÌÛ˙Ò().¥ˆ¸‡ËÏÚ˘¡…Õ”⁄¿»Ã“Ÿ—,', 'aeioun    ouaeiouAEIOUAEIOUN ')
     , TRANSLATE (NVL (TO_CHAR (RPAD (svsb_ape_mat_afil_o_benef_real, 25, ' ')), '                         '), '·ÈÌÛ˙Ò().¥ˆ¸‡ËÏÚ˘¡…Õ”⁄¿»Ã“Ÿ—,', 'aeioun    ouaeiouAEIOUAEIOUN ')
     , TRANSLATE (NVL (TO_CHAR (RPAD (svsb_nombres_afil_o_benef_real, 30, ' ')), '                              '), '·ÈÌÛ˙Ò().¥ˆ¸‡ËÏÚ˘¡…Õ”⁄¿»Ã“Ÿ—,', 'aeioun    ouaeiouAEIOUAEIOUN ')
     , NVL (TO_CHAR (LPAD (svsb_sexo_re, 1, ' ')), ' ')
     , NVL (TO_CHAR (LPAD (svsb_tipo_beneficiario_ta, 2, '0')), '00')
     , NVL (TO_CHAR (LPAD (svsb_situacion_invalidez_ta, 1, ' ')), ' ')
     , NVL (TO_CHAR (LPAD (TO_CHAR (svsb_fecha_nacimiento_fc, 'YYYYMMDD'), 8, '0')), '00000000')
     , NVL (TO_CHAR (LPAD (TO_CHAR (svsb_fecha_fallecimiento_fc, 'YYYYMMDD'), 8, '0')), '00000000')
     , NVL (TO_CHAR (LPAD (TO_CHAR (svsb_fecha_invalidez_fc, 'YYYYMMDD'), 8, '0')), '00000000')
     , NVL (TO_CHAR (LPAD (svsb_derecho_pension_ta, 2, '0')), '00')
     , NVL (TO_CHAR (LPAD (svsb_requisito_pension_ta, 1, '0')), '0')
     , NVL (TO_CHAR (LPAD (svsb_relacion_hijo_madre_nn, 2, '0')), '00')
     , NVL (TO_CHAR (LPAD (TO_CHAR (svsb_fecha_nac_hijo_menor_fc, 'YYYYMMDD'), 8, '0')), '00000000')
     , NVL (TO_CHAR (LPAD (svsb_derecho_acrecer_re, 1, ' ')), ' ')
     , LPAD (NVL (svsb_porcentaje_pension_nn / 0.01, '0'), 5, 0)
     , LPAD (NVL (svsb_pension_persona_nn / 0.01, '0'), 5, 0)
     , LPAD (NVL (svsb_rt_base_total_nn / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_base_2009_total / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_fin_2004_85_total / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_financiera_total_nn / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_fin_2004_2006_total / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_fin_2009_2006_total / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_base_retenida_nn / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_base_2009_retenida_nn / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_fin_2004_85_retenida / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_financiera_retenida_nn / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_fin_2004_2006_retenida / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_rt_fin_2009_2006_retenida / 0.01, '0'), 7, 0)
     , LPAD (NVL (svsb_monto_pago_bene_estatal_1 / 0.000001, '0'), 8, 0)
     , LPAD (NVL (svsb_monto_pago_bene_estatal_2 / 0.000001, '0'), 8, 0)
     , LPAD (NVL (svsb_monto_pago_bene_estatal_3 / 0.000001, '0'), 8, 0)
     , NVL (TO_CHAR (LPAD (svsb_tipo_pago_bene_estatal_1, 1, '0')), '0')
     , NVL (TO_CHAR (LPAD (svsb_tipo_pago_bene_estatal_2, 1, '0')), '0')
     , NVL (TO_CHAR (LPAD (svsb_tipo_pago_bene_estatal_3, 1, '0')), '0')
     , NVL (svsb_ind_crsv_nn, 0)
     , LPAD (NVL (svsb_bono_por_hijo_1 / 0.0001, '0'), 6, 0)
     , LPAD (NVL (svsb_bono_por_hijo_2 / 0.0001, '0'), 6, 0)
     , LPAD (NVL (svsb_bono_por_hijo_3 / 0.0001, '0'), 6, 0)         
/* HU PR-510 INI  */
     , LPAD (NVL (round(SVSB_PORC_ANTICIPO_RV, 2) / 0.01, '0'), 4, 0)
     , LPAD (NVL (round(SVSB_PORC_PNS_POST_ANTIC, 2) / 0.01, '0'), 4, 0)
     , NVL (TO_CHAR (LPAD (TO_CHAR (SVSB_FEC_ANTICIPO_RV, 'YYYYMMDD'), 8, '0')), '00000000')
/* HU PR-510 FIN  */
FROM     rentarsv.svs_beneficiario
WHERE    svsb_periodo_id = 202312
      AND svsb_poliza_id = 660613
ORDER BY svsb_numero_de_orden_id;




--select '?','AcÈnto' from dual
