/* volver atras calculo automatico pago pensiones (Póliza Pendientes por Recalcular) */

update pensiones.datos_pol
set dpo_fec_recalculo=null,
    dpo_pns_ref_nva = dpo_pns_ref_act,
    dpo_rtb_endoso = 0,
    dpo_cm_nueva = 0,
    dpo_cnu_nueva = 0    
where dpo_numpoliza=644617;


/* si es caso especial se limpia el campo */
update pensiones.datos_pol
set dpo_ind_caso_especial=null
where dpo_numpoliza=644617
and dpo_periodo=202401;

update pensiones.datos_ben
set dbe_fec_recalculo= null   
where dbe_numpoliza=644617;

delete from pensiones.datos_reserva
where numpoliza=644617
and fecproceso=to_date('16/01/2024','dd/mm/yyyy')
and tipoproceso='E';

delete from pensiones.datos_flujos where flj_numpol=17065
and flj_tipo_proc='E'
and flj_fec_proc=to_date('11/01/2024','dd/mm/yyyy');


select dpo_fec_recalculo,
    dpo_pns_ref_nva, dpo_pns_ref_act,
    dpo_rtb_endoso,    dpo_cm_nueva,
    dpo_cnu_nueva, dpo_ind_caso_borde, dpo_ind_caso_especial from pensiones.datos_pol    
where dpo_numpoliza=644617;

select dbe_fec_recalculo from pensiones.datos_ben where dbe_numpoliza=644617;

select * from pensiones.datos_reserva
where numpoliza=644617
and tipoproceso='E';

select * from pensiones.datos_flujos where flj_numpol=644617
and flj_tipo_proc='E';


/* OTRAS TABLAS */
select * from pensiones.polizas where pol_poliza=13396 for update ;
select * from pensiones.asegafp where asaf_poliza=13396 for update;
select * from pensiones.beneficiarios where ben_poliza=13396 for update;
select * from pensiones.beneficios where bnf_poliza=13396 for update;
select * from pensiones.modificaciones where mod_poliza=13396 for update;
select * from pensiones.modificaciones_bnl where mod_poliza=13396 for update;
select * from pensiones.endosos where end_poliza =13396 for update;
select * from pensiones.endosos_bnl where end_poliza=13396 for update;
select * from pensiones.datos_pol where dpo_numpoliza=13396 for update;
select * from pensiones.datos_ben where dbe_numpoliza=13396 for update;
select * from pensiones.datos_flujos where flj_numpol=13396 for update;
select * from pensiones.datos_reserva where numpoliza=13396 for update;
select * from pensiones.sol_endoso_incl_benef where inc_poliza=13396 for update;
select * from pensiones.sol_endoso_excl_benef where exc_poliza=13396 for update;
--delete from pensiones.datos_ben where dbe_numpoliza=644617;
--delete from pensiones.datos_pol where dpo_numpoliza=644617

select * from pensiones.beneficiarios where ben_poliza=644617 for update;
select * from pensiones.pensiones where pns_poliza=644617 for update;
select * from pensiones.beneficios where bnf_poliza=644617 for update;
select * from pensiones.persnat where nat_id=1482698 for update;
select * from pensiones.certper where cep_nat=1482698 for update;


/* TABLAS RESPALDO DE PREVDESA2  (Beneficiarios y Beneficios)*/
insert into pensiones.beneficiarios (BEN_ID_CREA, BEN_DATE_CREA, BEN_ID_MOD, BEN_DATE_MOD, BEN_RST, BEN_LINEA, BEN_PRODUCTO, BEN_DOCUMENTO, BEN_POLIZA, BEN_CAUSANTE, BEN_BENEFICIARIO, BEN_RELACION, BEN_INVALIDO, BEN_POSTUMO, BEN_FEC_18, BEN_ESTADO, BEN_FEC_ESTADO, BEN_EST_CIVIL, BEN_FEC_EST_CIVIL, BEN_FEC_NACIM, BEN_SEXO, BEN_PORCENTAJE, BEN_REL_ASEG, BEN_ASG_GAR, BEN_CONTINGENTE, BEN_SEC_DEP, BEN_ACR_RE, BEN_POR_ADI_NN, BEN_IND_DER_RE, BEN_MOT_NDE_NN, BEN_FNA_HME_FC, BEN_REL_AFP_NN, BEN_ES_IN_NN, BEN_ELI_M_NN, BEN_IND_CAD_RE, BEN_MOT_SUS_NN, BEN_TAB_MORT_NN, BEN_ORD_SVS_NN, BEN_ATRIB_CC, BEN_IND_ADICIONAL, BEN_PORC_ADICIONAL, BEN_RENTA_ADICIONAL, BEN_PORC10_BENEF)
values ('MIGRACION', to_date('30-12-2015 10:56:33', 'dd-mm-yyyy hh24:mi:ss'), 'XIOLRI00  ', to_date('18-01-2017', 'dd-mm-yyyy'), 2, 3, 607, 2, 644617, 1008600, 1027139, 4, 2, 2, null, 0, null, 1, null, to_date('13-04-1942', 'dd-mm-yyyy'), 'F', 100.00000, 3, 2, null, 2, 2, 0.00, 2, 0, null, 0, 0, 0, 'N', 0, 0, 2, null, null, null, null, null);

insert into pensiones.beneficios (BNF_ID_CREA, BNF_DATE_CREA, BNF_ID_MOD, BNF_DATE_MOD, BNF_RST, BNF_LINEA, BNF_PRODUCTO, BNF_DOCUMENTO, BNF_POLIZA, BNF_CAUSANTE, BNF_BENEFICIARIO, BNF_COBERTURA, BNF_CORR, BNF_PORC_MONTO, BNF_MONTO, BNF_GRUPO, BNF_ART_60, BNF_ESTADO, BNF_FEC_ESTADO, BNF_RESERVA_INIC, BNF_RESERVA_INIC_CM, BNF_FEC_RES, BNF_RESERVA_INIC_ACT, BNF_RESERVA_INIC_CM_ACT, BNF_FEC_RES_ACT, BNF_IND_CARGA, BNF_RES_INIC_AFP, BNF_RES_INIC_CM_AFP, BNF_FEC_RES_AFP, BNF_GLOSA_RES, BNF_GRP_PAG, BNF_FEC_INI_BNF, BNF_RES_INIC_TM, BNF_RES_INI_TM_ACT, BNF_RES_INI_TM_AFP)
values ('ALORRO00  ', to_date('28-11-2023', 'dd-mm-yyyy'), 'ALORRO00  ', to_date('28-11-2023', 'dd-mm-yyyy'), 2, 3, 607, 2, 644617, 1008600, 1027139, 1, 2, 0.00000, 0.00000, 2, 2, 0, null, 0.00000, 0.00000, null, 0.00000, 0.00000, null, 2, 0.00000, 0.00000, null, 0.00000, 1, to_date('25-11-2023', 'dd-mm-yyyy'), 0.00000, 0.00000, 0.00000);

insert into pensiones.beneficios (BNF_ID_CREA, BNF_DATE_CREA, BNF_ID_MOD, BNF_DATE_MOD, BNF_RST, BNF_LINEA, BNF_PRODUCTO, BNF_DOCUMENTO, BNF_POLIZA, BNF_CAUSANTE, BNF_BENEFICIARIO, BNF_COBERTURA, BNF_CORR, BNF_PORC_MONTO, BNF_MONTO, BNF_GRUPO, BNF_ART_60, BNF_ESTADO, BNF_FEC_ESTADO, BNF_RESERVA_INIC, BNF_RESERVA_INIC_CM, BNF_FEC_RES, BNF_RESERVA_INIC_ACT, BNF_RESERVA_INIC_CM_ACT, BNF_FEC_RES_ACT, BNF_IND_CARGA, BNF_RES_INIC_AFP, BNF_RES_INIC_CM_AFP, BNF_FEC_RES_AFP, BNF_GLOSA_RES, BNF_GRP_PAG, BNF_FEC_INI_BNF, BNF_RES_INIC_TM, BNF_RES_INI_TM_ACT, BNF_RES_INI_TM_AFP)
values ('MIGRACION', to_date('30-12-2015 10:57:05', 'dd-mm-yyyy hh24:mi:ss'), 'ALORRO00  ', to_date('28-11-2023', 'dd-mm-yyyy'), 2, 3, 607, 2, 644617, 1008600, 1027139, 8, 2, 0.00000, 0.00000, 2, 2, 1, to_date('28-11-2023', 'dd-mm-yyyy'), 0.00000, 0.00000, null, 0.00000, 0.00000, null, 2, 0.00000, 0.00000, null, 0.00000, 1, to_date('10-10-2014', 'dd-mm-yyyy'), 0.00000, 0.00000, 0.00000);



