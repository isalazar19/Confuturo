/* TIPO REG 2 */
/*select to_char(replace(6.06,'.',''),'00000') from dual;
select lpad(0,7,'0') from dual*/

  SELECT '2'  
       || NVL (TO_CHAR (LPAD (svsp_poliza_id, 10, '0')), '0000000000')
       || NVL (TO_CHAR (LPAD (svsp_numero_personas_nn, 2, '0')), '00')
       || NVL (TO_CHAR (LPAD (svsp_rut_afiliado_nn, 9, '0')), '000000000')
       || NVL (TO_CHAR (LPAD (svsp_ver_rut_afiliado_cr, 1, ' ')), ' ')
       || NVL (TO_CHAR (LPAD (svsp_tipo_pension_ta, 2, '0')), '00')
       || NVL (TO_CHAR (LPAD (svsp_compania_obligada_ta, 1, ' ')), ' ')
       || NVL (TO_CHAR (LPAD (svsp_vigencia_pension_ta, 1, '0')), '0')
       || NVL (TO_CHAR (LPAD (svsp_codigo_afp_ta, 2, '0')), '00')
       || NVL (TO_CHAR (LPAD (svsp_tipo_afiliado_ta, 1, ' ')), ' ')
       || NVL (TO_CHAR (LPAD (svsp_cuenta_individual_nn, 7, '0')), '0000000')
       || NVL (TO_CHAR( LPAD (svsp_ingreso_base_en_uf_nn, 5, '0')), '00000')
       || NVL (TO_CHAR (LPAD (svsp_porcentaje_cubierto_nn, 3, '0')), '000')
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_vigencia_inicial_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || TRIM(to_char(replace(svsp_prima_unica_nn,'.',''),'0000000'))--NVL (svsp_prima_unica_nn, 0)
       || NVL (svsp_renta_mensual_nn,0)
       || NVL (TO_CHAR (LPAD (svsp_tipo_renta_nn, 4, '0')), '0000')
       || NVL (TO_CHAR (LPAD (svsp_modalidad_renta_nn, 4, '0')), '0000')
       || NVL (svsp_tasa_cto_emision_nn, 0)
       || NVL (CASE
              WHEN svsp_tasa_venta_nn <= 0
                THEN 0.01
              ELSE svsp_tasa_venta_nn
            END, 0)
       || NVL (TO_CHAR (LPAD (svsp_numero_reaseguro_nn, 1, '0')), '0')
       || NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_1_ta, 2, '0')), '00')
       || NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_1_ta, 1, ' ')), ' ')
       || NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_1_re, 1, ' ')), ' ')
       || NVL (svsp_porcentaje_retenido_1_nn, 0)
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (svsp_tasa_cto_equiv_ret_1_nn, 0)
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_2_ta, 2, '0')), '00')
       || NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_2_ta, 1, ' ')), ' ')
       || NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_2_re, 1, ' ')), ' ')
       || NVL (svsp_porcentaje_retenido_2_nn, 0)
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (svsp_tasa_cto_equiv_ret_2_nn, 0)
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_3_ta, 2, '0')), '00')
       || NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_3_ta, 1, ' ')), ' ')
       || NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_3_re, 1, ' ')), ' ')
       || NVL (svsp_porcentaje_retenido_3_nn, 0)
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (svsp_tasa_cto_equiv_ret_3_nn, 0)
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fec_recal_act, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fec_recal_ant, 'YYYYMMDD'), 8, '0')), '00000000')
       || NVL (svsp_ren_ant_recal_act, 0)
       || NVL (svsp_ren_ant_recal_ant, 0)
       || NVL (svsp_origen_re,0)
       || NVL (CASE
               WHEN svsp_origen_re = 2 THEN
                 round(((svsp_ingreso_base_en_uf_nn * svsp_porcentaje_cubierto_nn)/100),2)
              ELSE
                0
              END, 0)
       || NVL (svsp_meses_re,0)
       || NVL (DECODE(svsp_porc_re, 0, 100, svsp_porc_re), 100)
       || NVL (TO_CHAR (LPAD (SVSP_TIPO_OPERACION_RV, 2, '  ')), '  ')
       || NVL(SVSP_POLIZA_CON_ANTICIPO_RV, 0)

       , '2' TIPO_REGISTRO
       , NVL (TO_CHAR (LPAD (svsp_poliza_id, 10, '0')), '0000000000')
       , NVL (TO_CHAR (LPAD (svsp_numero_personas_nn, 2, '0')), '00')
       , NVL (TO_CHAR (LPAD (svsp_rut_afiliado_nn, 9, '0')), '000000000')
       , NVL (TO_CHAR (LPAD (svsp_ver_rut_afiliado_cr, 1, ' ')), ' ')
       , NVL (TO_CHAR (LPAD (svsp_tipo_pension_ta, 2, '0')), '00')
       , NVL (TO_CHAR (LPAD (svsp_compania_obligada_ta, 1, ' ')), ' ')
       , NVL (TO_CHAR (LPAD (svsp_vigencia_pension_ta, 1, '0')), '0')
       , NVL (TO_CHAR (LPAD (svsp_codigo_afp_ta, 2, '0')), '00')
       , NVL (TO_CHAR (LPAD (svsp_tipo_afiliado_ta, 1, ' ')), ' ')
       , NVL (svsp_cuenta_individual_nn, 0)
       , NVL (svsp_ingreso_base_en_uf_nn, 0)
       , NVL (TO_CHAR (LPAD (svsp_porcentaje_cubierto_nn, 3, '0')), '000')
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_vigencia_inicial_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , svsp_prima_unica_nn
       , NVL (svsp_renta_mensual_nn,0)
       , NVL (TO_CHAR (LPAD (svsp_tipo_renta_nn, 4, '0')), '0000')
       , NVL (TO_CHAR (LPAD (svsp_modalidad_renta_nn, 4, '0')), '0000')
       , NVL (svsp_tasa_cto_emision_nn, 0)
        , NVL (CASE
              WHEN svsp_tasa_venta_nn <= 0
                THEN 0.01
              ELSE svsp_tasa_venta_nn
            END, 0)
       , NVL (TO_CHAR (LPAD (svsp_numero_reaseguro_nn, 1, '0')), '0')
       , NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_1_ta, 2, '0')), '00')
       , NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_1_ta, 1, ' ')), ' ')
       , NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_1_re, 1, ' ')), ' ')
       , NVL (svsp_porcentaje_retenido_1_nn, 0)
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (svsp_tasa_cto_equiv_ret_1_nn, 0)
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_2_ta, 2, '0')), '00')
       , NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_2_ta, 1, ' ')), ' ')
       , NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_2_re, 1, ' ')), ' ')
       , NVL (svsp_porcentaje_retenido_2_nn, 0)
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (svsp_tasa_cto_equiv_ret_2_nn, 0)
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_3_ta, 2, '0')), '00')
       , NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_3_ta, 1, ' ')), ' ')
       , NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_3_re, 1, ' ')), ' ')
       , NVL (svsp_porcentaje_retenido_3_nn, 0)
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (svsp_tasa_cto_equiv_ret_3_nn, 0)
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
       , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fec_recal_act, 'YYYYMMDD'), 8, '0')), '00000000')
        , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fec_recal_ant, 'YYYYMMDD'), 8, '0')), '00000000')
        , NVL (svsp_ren_ant_recal_act, 0)
        , NVL (svsp_ren_ant_recal_ant, 0)
       , NVL (svsp_origen_re,0)
       , NVL (CASE
               WHEN svsp_origen_re = 2 THEN
                 round(((svsp_ingreso_base_en_uf_nn * svsp_porcentaje_cubierto_nn)/100),2)
              ELSE
                0
              END, 0)
       , NVL (svsp_meses_re,0)
       , NVL (DECODE(svsp_porc_re, 0, 100, svsp_porc_re), 100)
       , NVL (TO_CHAR (LPAD (SVSP_TIPO_OPERACION_RV, 2, '  ')), '  ')
       , NVL(SVSP_POLIZA_CON_ANTICIPO_RV, 0)
  FROM     rentarsv.svs_poliza
  WHERE    svsp_periodo_id = 202312
   AND svsp_poliza_id = 678226    
  ORDER BY svsp_poliza_id;
  

SELECT   NVL (TO_CHAR (LPAD (svsp_poliza_id, 10, '0')), '0000000000')
			 , NVL (TO_CHAR (LPAD (svsp_numero_personas_nn, 2, '0')), '00')
			 , NVL (TO_CHAR (LPAD (svsp_rut_afiliado_nn, 9, '0')), '000000000')
			 , NVL (TO_CHAR (LPAD (svsp_ver_rut_afiliado_cr, 1, ' ')), ' ')
			 , NVL (TO_CHAR (LPAD (svsp_tipo_pension_ta, 2, '0')), '00')
			 , NVL (TO_CHAR (LPAD (svsp_compania_obligada_ta, 1, ' ')), ' ')
			 , NVL (TO_CHAR (LPAD (svsp_vigencia_pension_ta, 1, '0')), '0')
			 , NVL (TO_CHAR (LPAD (svsp_codigo_afp_ta, 2, '0')), '00')
			 , NVL (TO_CHAR (LPAD (svsp_tipo_afiliado_ta, 1, ' ')), ' ')
			 , NVL (svsp_cuenta_individual_nn, 0)
			 , NVL (svsp_ingreso_base_en_uf_nn, 0)
			 , NVL (TO_CHAR (LPAD (svsp_porcentaje_cubierto_nn, 3, '0')), '000')
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_vigencia_inicial_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (svsp_prima_unica_nn, 0)
			 , NVL (svsp_renta_mensual_nn,0)
			 , NVL (TO_CHAR (LPAD (svsp_tipo_renta_nn, 4, '0')), '0000')
			 , NVL (TO_CHAR (LPAD (svsp_modalidad_renta_nn, 4, '0')), '0000')
			 , NVL (svsp_tasa_cto_emision_nn, 0)
	 		 , NVL (CASE
						  WHEN svsp_tasa_venta_nn <= 0
							  THEN 0.01
						  ELSE svsp_tasa_venta_nn
					  END, 0)
			 , NVL (TO_CHAR (LPAD (svsp_numero_reaseguro_nn, 1, '0')), '0')
			 , NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_1_ta, 2, '0')), '00')
			 , NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_1_ta, 1, ' ')), ' ')
			 , NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_1_re, 1, ' ')), ' ')
			 , NVL (svsp_porcentaje_retenido_1_nn, 0)
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (svsp_tasa_cto_equiv_ret_1_nn, 0)
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_1_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_2_ta, 2, '0')), '00')
			 , NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_2_ta, 1, ' ')), ' ')
			 , NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_2_re, 1, ' ')), ' ')
			 , NVL (svsp_porcentaje_retenido_2_nn, 0)
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (svsp_tasa_cto_equiv_ret_2_nn, 0)
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_2_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (TO_CHAR (LPAD (svsp_compania_reaseguro_3_ta, 2, '0')), '00')
			 , NVL (TO_CHAR (LPAD (svsp_operacion_reaseguro_3_ta, 1, ' ')), ' ')
			 , NVL (TO_CHAR (LPAD (svsp_modo_reaseguro_3_re, 1, ' ')), ' ')
			 , NVL (svsp_porcentaje_retenido_3_nn, 0)
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_inicio_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_termino_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (svsp_tasa_cto_equiv_ret_3_nn, 0)
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fecha_reas_3_fc, 'YYYYMMDD'), 8, '0')), '00000000')
			 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fec_recal_act, 'YYYYMMDD'), 8, '0')), '00000000')
	 		 , NVL (TO_CHAR (LPAD (TO_CHAR (svsp_fec_recal_ant, 'YYYYMMDD'), 8, '0')), '00000000')
	 		 , NVL (svsp_ren_ant_recal_act, 0)
	 		 , NVL (svsp_ren_ant_recal_ant, 0)
			 , NVL (svsp_origen_re,0)
			 , NVL (CASE
               WHEN svsp_origen_re = 2 THEN
                 round(((svsp_ingreso_base_en_uf_nn * svsp_porcentaje_cubierto_nn)/100),2)
              ELSE
                0
              END, 0)
/* ECM01 INI RE */
			 , NVL (svsp_meses_re,0)
			 , NVL (DECODE(svsp_porc_re, 0, 100, svsp_porc_re), 100)
/* ECM01 FIN RE */
/* HU PR-510 INI */
			 , NVL (TO_CHAR (LPAD (SVSP_TIPO_OPERACION_RV, 2, '  ')), '  ')
			 , NVL(SVSP_POLIZA_CON_ANTICIPO_RV, 0)
/* HU PR-510 FIN */
	FROM     rentarsv.svs_poliza
	WHERE    svsp_periodo_id = 202312
		and svsp_poliza_id=678226
	ORDER BY svsp_poliza_id; 


