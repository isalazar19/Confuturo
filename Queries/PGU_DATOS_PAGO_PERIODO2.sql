-- Create table
create table PGU_DATOS_PAGO_PERIODO2
(
  pdp_periodo          VARCHAR2(6) not null,
  pdp_poliza           NUMBER(7) not null,
  pdp_grp_pago         NUMBER(1) not null,
  pdp_rut_emp          VARCHAR2(8),
  pdp_dv_emp           VARCHAR2(1),
  pdp_rut_ben          VARCHAR2(8),
  pdp_dv_ben           VARCHAR2(1),
  pdp_ap_pat_ben       VARCHAR2(20),
  pdp_ap_mat_ben       VARCHAR2(20),
  pdp_nomb_ben         VARCHAR2(30),
  pdp_dom_ben          VARCHAR2(45),
  pdp_comuna_ben       VARCHAR2(5),
  pdp_ciudad_ben       VARCHAR2(20),
  pdp_region_ben       VARCHAR2(2),
  pdp_telef1           VARCHAR2(9),
  pdp_telef2           VARCHAR2(9),
  pdp_email            VARCHAR2(45),
  pdp_fec_pago         VARCHAR2(8),
  pdp_frm_pago         VARCHAR2(2),
  pdp_mod_pago         VARCHAR2(2),
  pdp_rut_ent_pag      VARCHAR2(8),
  pdp_dv_ent_pag       VARCHAR2(1),
  pdp_com_ent_pag      VARCHAR2(5),
  pdp_reg_ent_pag      VARCHAR2(2),
  pdp_cta_ban_ben      VARCHAR2(2),
  pdp_nro_cta_ben      VARCHAR2(18),
  pdp_cob_mandato      VARCHAR2(2),
  pdp_rut_manda        VARCHAR2(8),
  pdp_dv_manda         VARCHAR2(1),
  pdp_ap_pat_manda     VARCHAR2(20),
  pdp_ap_mat_manda     VARCHAR2(20),
  pdp_nombre_manda     VARCHAR2(30),
  pdp_domi_manda       VARCHAR2(45),
  pdp_comuna_manda     VARCHAR2(5),
  pdp_ciudad_manda     VARCHAR2(20),
  pdp_region_manda     VARCHAR2(2),
  pdp_cod_ent_banca    VARCHAR2(3),
  pdp_tip_cta_manda    VARCHAR2(2),
  pdp_nro_cta_manda    VARCHAR2(18),
  pdp_tot_desctos      VARCHAR2(8),
  pdp_fecpag_contrib   VARCHAR2(8),
  pdp_fecprox_pago     VARCHAR2(8),
  pdp_ent_banca_ben    VARCHAR2(3),
  pdp_prd              NUMBER(3) not null,
  pdp_cau              NUMBER(9) not null,
  pdp_cob              NUMBER(2) not null,
  pdp_cta_bco          VARCHAR2(25),
  pdp_lqr_frm_pago     NUMBER(3),
  pdp_id_dom           NUMBER(7),
  pdp_ben              NUMBER(9),
  pdp_id_recep         NUMBER(9),
  pdp_bco              NUMBER(3),
  pdp_mto_pre_liq      NUMBER(9),
  pdp_estado_proc      VARCHAR2(1),
  pdp_id_cre_cr        VARCHAR2(10),
  pdp_dat_cre_fc       DATE,
  pdp_id_mod_cr        VARCHAR2(10),
  pdp_dat_mod_fc       DATE,
  pdp_estado_pago      VARCHAR2(2),
  pdp_rut_ent_traspaso VARCHAR2(8),
  pdp_dv_ent_traspaso  VARCHAR2(1)
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
-- Create/Recreate indexes 
create index DBA_BIZWARE.TMP_POLP_IDX2 on PGU_DATOS_PAGO_PERIODO2 (PDP_PERIODO, PDP_POLIZA)
  tablespace DATA_PENSIONES_TS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table PGU_DATOS_PAGO_PERIODO2
  add constraint PK_PGU_DATOS_PAGO_PERIODO2 primary key (PDP_PERIODO, PDP_PRD, PDP_POLIZA, PDP_CAU, PDP_GRP_PAGO, PDP_COB)
  using index 
  tablespace DATA_PENSIONES_TS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Grant/Revoke object privileges 
grant select on PGU_DATOS_PAGO_PERIODO2 to ROL_CONSULTA_TI;
grant select, insert, update, delete on PGU_DATOS_PAGO_PERIODO2 to ROL_MANTENCION_TI;
grant select on PGU_DATOS_PAGO_PERIODO2 to ROL_SEL_PENSIONES;
grant select on PGU_DATOS_PAGO_PERIODO2 to SELECT_ALL_SCHEMAS;
grant select on PGU_DATOS_PAGO_PERIODO2 to SELECT_TODOS_ESQUEMAS;
grant select on PGU_DATOS_PAGO_PERIODO2 to SELECT_USRSERVICIO;
grant select on PGU_DATOS_PAGO_PERIODO2 to SEL_REN_PEN_EXP;
grant select on PGU_DATOS_PAGO_PERIODO2 to USER_PENSIONES_FUSION;
grant select on PGU_DATOS_PAGO_PERIODO2 to USR_NOVASYS;
grant select, insert, update, delete on PGU_DATOS_PAGO_PERIODO2 to USUARIO_RENTAPRE;
grant select, insert, update, delete on PGU_DATOS_PAGO_PERIODO2 to USUARIO_RENTARSV;
grant select, insert, update, delete on PGU_DATOS_PAGO_PERIODO2 to USUARIO_RENTRAPA;
