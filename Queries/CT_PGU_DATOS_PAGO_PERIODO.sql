-- Create table
create table pensiones.CT_PGU_DATOS_PAGO_PERIODO
(
  pdp_periodo          VARCHAR2(6) default 0 not null,
  pdp_poliza           NUMBER(7) default 0,
  pdp_grp_pago         NUMBER(1) default 0,
  pdp_rut_emp          VARCHAR2(8) default '0',
  pdp_dv_emp           VARCHAR2(1) default ' ',
  pdp_rut_ben          VARCHAR2(8) default '0',
  pdp_dv_ben           VARCHAR2(1) default ' ',
  pdp_ap_pat_ben       VARCHAR2(20) default ' ',
  pdp_ap_mat_ben       VARCHAR2(20) default ' ',
  pdp_nomb_ben         VARCHAR2(30) default ' ',
  pdp_dom_ben          VARCHAR2(45) default ' ',
  pdp_comuna_ben       VARCHAR2(5) default ' ',
  pdp_ciudad_ben       VARCHAR2(20) default ' ',
  pdp_region_ben       VARCHAR2(2) default ' ',
  pdp_telef1           VARCHAR2(9) default ' ',
  pdp_telef2           VARCHAR2(9) default ' ',
  pdp_email            VARCHAR2(45) default '000@000.cl',
  pdp_fec_pago         VARCHAR2(8) default ' ',
  pdp_frm_pago         VARCHAR2(2) default ' ',
  pdp_mod_pago         VARCHAR2(2) default ' ',
  pdp_rut_ent_pag      VARCHAR2(8) default '0',
  pdp_dv_ent_pag       VARCHAR2(1) default ' ',
  pdp_com_ent_pag      VARCHAR2(5) default ' ',
  pdp_reg_ent_pag      VARCHAR2(2) default ' ',
  pdp_cta_ban_ben      VARCHAR2(2) default ' ',
  pdp_nro_cta_ben      VARCHAR2(18) default ' ',
  pdp_cob_mandato      VARCHAR2(2) default ' ',
  pdp_rut_manda        VARCHAR2(8) default '0',
  pdp_dv_manda         VARCHAR2(1) default ' ',
  pdp_ap_pat_manda     VARCHAR2(20) default ' ',
  pdp_ap_mat_manda     VARCHAR2(20) default ' ',
  pdp_nombre_manda     VARCHAR2(30) default ' ',
  pdp_domi_manda       VARCHAR2(45) default ' ',
  pdp_comuna_manda     VARCHAR2(5) default ' ',
  pdp_ciudad_manda     VARCHAR2(20) default ' ',
  pdp_region_manda     VARCHAR2(2) default ' ',
  pdp_cod_ent_banca    VARCHAR2(3) default ' ',
  pdp_tip_cta_manda    VARCHAR2(2) default ' ',
  pdp_nro_cta_manda    VARCHAR2(18) default ' ',
  pdp_tot_desctos      VARCHAR2(8) default ' ',
  pdp_fecpag_contrib   VARCHAR2(8) default ' ',
  pdp_fecprox_pago     VARCHAR2(8) default ' ',
  pdp_ent_banca_ben    VARCHAR2(3) default ' ',
  pdp_prd              NUMBER(3) default 0,
  pdp_cau              NUMBER(9) default 0,
  pdp_cob              NUMBER(2) default 0,
  pdp_cta_bco          VARCHAR2(25) default ' ',
  pdp_lqr_frm_pago     NUMBER(3) default 0,
  pdp_id_dom           NUMBER(7) default 0,
  pdp_ben              NUMBER(9) default 0,
  pdp_id_recep         NUMBER(9) default 0,
  pdp_bco              NUMBER(3) default 0,
  pdp_mto_pre_liq      NUMBER(9) default 0,
  pdp_estado_proc      VARCHAR2(1) default ' ',
  pdp_id_cre_cr        VARCHAR2(10) default ' ',
  pdp_dat_cre_fc       DATE,
  pdp_id_mod_cr        VARCHAR2(10) default ' ',
  pdp_dat_mod_fc       DATE,
  pdp_estado_pago      VARCHAR2(2) default ' ',
  pdp_rut_ent_traspaso VARCHAR2(8) default '0',
  pdp_dv_ent_traspaso  VARCHAR2(1) default ' '
)
tablespace DATA_PENSIONES_TS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );