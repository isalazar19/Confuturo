CREATE OR REPLACE PROCEDURE pensiones."SP_CT_INF_PGU" (
                                              p_periodo_new CT_PGU_DATOS_PAGO_PERIODO.PDP_PERIODO%TYPE,
                                              v_tabla OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN v_tabla FOR
    select (
      Rpad(Nvl(To_Char(pdp_periodo), ' '),6,' ') ||
      Rpad(Nvl(To_Char(pdp_rut_emp), '0'),8,'0') ||
      Rpad(Nvl(To_Char(pdp_dv_emp), ' '),1,' ') ||
      --Rpad(Nvl(To_Char(pdp_rut_ben), '0'),8,'0') ||
      lpad(LTRIM(pdp_rut_ben, '0'),8,' ') ||
      Rpad(Nvl(To_Char(pdp_dv_ben), ' '),1,' ') ||
      Rpad(Nvl(To_Char(pdp_ap_pat_ben), ' '),20,' ') ||
      Rpad(Nvl(To_Char(pdp_ap_mat_ben), ' '),20,' ')||
      Rpad(Nvl(To_Char(pdp_nomb_ben), ' '),30,' ')||
      pdp_dom_ben||
      pdp_comuna_ben||
      pdp_ciudad_ben||
      pdp_region_ben||
      pdp_telef1||
      pdp_telef2||
      pdp_email||
      pdp_fec_pago||
      pdp_frm_pago||
      pdp_mod_pago||
      pdp_rut_ent_pag||
      pdp_dv_ent_pag||
      Rpad(Nvl(To_Char(pdp_com_ent_pag), ' '),5,' ') ||
      Rpad(Nvl(To_Char(pdp_reg_ent_pag), ' '),2,' ') ||
      Rpad(Nvl(To_Char(pdp_cta_ban_ben), '0'),2,'0') ||
      Rpad(Nvl(To_Char(pdp_nro_cta_ben), ' '),18,' ') ||
      pdp_cob_mandato||
      Rpad(Nvl(To_Char(pdp_rut_manda), '0'),8,'0') ||
      Rpad(Nvl(To_Char(pdp_dv_manda), ' '),1,' ') ||
      pdp_ap_pat_manda||
      pdp_ap_mat_manda||
      pdp_nombre_manda||
      pdp_domi_manda||
      pdp_comuna_manda||
      pdp_ciudad_manda||
      pdp_region_manda||
      Rpad(Nvl(To_Char(pdp_cod_ent_banca), ' '),3,' ') ||
      pdp_tip_cta_manda||
      Rpad(Nvl(To_Char(pdp_nro_cta_manda), ' '),18,' ') ||
      pdp_tot_desctos||
      pdp_fecpag_contrib||
      pdp_fecprox_pago||
      pdp_ent_banca_ben ||
      pdp_estado_pago||
      Rpad(Nvl(To_Char(pdp_rut_ent_traspaso), '0'),8,'0') ||
      Rpad(Nvl(To_Char(pdp_dv_ent_traspaso), ' '),1,' ')  ) campo,
      pdp_poliza num_poliza

      from pensiones.ct_pgu_datos_pago_periodo
      where pdp_periodo = p_periodo_new order by 2;

END SP_CT_INF_PGU;
/
