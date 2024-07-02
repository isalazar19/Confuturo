/*
DECLARE
reg       NUMBER:=0;
p_periodo NUMBER:=202303;
v_cont    NUMBER :=0;

v_periodo VARCHAR2(6);
v_rut_emp VARCHAR2(8);
v_dv_emp  VARCHAR2(1);

TYPE genArch IS TABLE OF Varchar2(535) INDEX BY BINARY_INTEGER;
archivo_pgu genArch;

 --CREAR CURSOR 
 CURSOR arch IS
            select PDP_PERIODO,
                   PDP_RUT_EMP,
                   PDP_DV_EMP,
                   PDP_RUT_BEN,
                   PDP_DV_BEN,
                   PDP_AP_PAT_BEN,
                   PDP_AP_MAT_BEN,
                   PDP_NOMB_BEN,
                   PDP_DOM_BEN,
                   PDP_COMUNA_BEN,
                   PDP_CIUDAD_BEN,
                   PDP_REGION_BEN,
                   PDP_TELEF1,
                   PDP_TELEF2,
                   PDP_EMAIL,
                   PDP_FEC_PAGO,
                   PDP_FRM_PAGO,
                   PDP_MOD_PAGO,
                   PDP_RUT_ENT_PAG,
                   PDP_DV_ENT_PAG,
                   PDP_COM_ENT_PAG,
                   PDP_REG_ENT_PAG,
                   PDP_CTA_BAN_BEN,
                   PDP_NRO_CTA_BEN,
                   PDP_COB_MANDATO,
                   PDP_RUT_MANDA,
                   PDP_DV_MANDA,
                   PDP_AP_PAT_MANDA,
                   PDP_AP_MAT_MANDA,
                   PDP_NOMBRE_MANDA,
                   PDP_DOMI_MANDA,
                   PDP_COMUNA_MANDA,
                   PDP_CIUDAD_MANDA,
                   PDP_REGION_MANDA,
                   PDP_COD_ENT_BANCA,
                   PDP_TIP_CTA_MANDA,
                   PDP_NRO_CTA_MANDA,
                   PDP_TOT_DESCTOS,
                   PDP_FECPAG_CONTRIB,
                   PDP_FECPROX_PAGO,
                   PDP_ENT_BANCA_BEN,
                   PDP_ESTADO_PAGO,
                   PDP_RUT_ENT_TRASPASO,
                   PDP_DV_ENT_TRASPASO

            from PENSIONES.pgu_datos_pago_periodo
             where pdp_periodo=p_periodo;

begin
  select nvl(Count(*),0)
  into reg
  from PENSIONES.pgu_datos_pago_periodo
  where pdp_periodo=p_periodo;
  if reg > 0 THEN
     FOR rec IN arch LOOP
         -- Genera archivo plano (txt) 
         archivo_pgu(v_cont) := LPAD(NVL(rec.PDP_PERIODO, '0'),6, ' ')||         -- PERIODO
                                LPAD(NVL(rec.PDP_RUT_EMP, '0'),8,'0')||          -- RUT empresa
                                RPAD(NVL(rec.PDP_DV_EMP, ' '),1,' ')||           -- DV RUT empresa
                                LPAD(NVL(rec.PDP_RUT_BEN, '0'),8,'0')||          -- RUT benef
                                RPAD(NVL(rec.PDP_DV_BEN, ' '),1,' ')||           -- DV RUT benef
                                RPAD(NVL(rec.PDP_AP_PAT_BEN, ' '),20,' ')||      -- APELLIDO PAT benef
                                RPAD(NVL(rec.PDP_AP_MAT_BEN, ' '),20,' ')||      -- APELLIDO MAT benef
                                RPAD(NVL(rec.PDP_NOMB_BEN, ' '),30,' ')||        -- NOMBRE benef
                                RPAD(NVL(rec.PDP_DOM_BEN, ' '),45,' ')||         -- DIR benef
                                RPAD(NVL(rec.PDP_COMUNA_BEN,'0'),5,'0')||        -- COMUNA benef
                                RPAD(NVL(rec.PDP_CIUDAD_BEN,' 0 '),20,' ')||     -- CIUDAD benef
                                RPAD(NVL(rec.PDP_REGION_BEN,' 0 '),2,' ')||      -- REGION benef
                                RPAD(NVL(rec.PDP_TELEF1,' '),9,' ')||            -- TELEF FIJO benef
                                RPAD(NVL(rec.PDP_TELEF2,' '),9, ' ')||           -- TELEF MOVIL benef
                                RPAD(NVL(rec.PDP_EMAIL,' '),45,' ')||            -- EMAIL 
                                RPAD(NVL(rec.PDP_FEC_PAGO, '0'),8,'0')||         -- FECHA PAGO ULT PEN
                                RPAD(NVL(rec.PDP_FRM_PAGO,' '),2,' ')||          -- FORMA PAGO
                                RPAD(NVL(rec.PDP_MOD_PAGO,' '),2,' ')||          -- MODO PAGO
                                RPAD(NVL(rec.PDP_RUT_ENT_PAG, '0'),8,'0')||      -- RUT ENT Pagad
                                RPAD(NVL(rec.PDP_DV_ENT_PAG, ' '),1,' ')||       -- DV ENT Pagad
                                RPAD(NVL(rec.PDP_COM_ENT_PAG, ' '),5,' ')||      -- 
                                RPAD(NVL(rec.PDP_REG_ENT_PAG, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_CTA_BAN_BEN, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_NRO_CTA_BEN, '0'),18,'0')||
                                RPAD(NVL(rec.PDP_COB_MANDATO, ' '),2,' ')||
                                RPAD(NVL(rec.PDP_RUT_MANDA, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_MANDA, ' '),1,' ')||
                                RPAD(NVL(rec.PDP_AP_PAT_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_AP_MAT_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_NOMBRE_MANDA, ' '),30,' ')||
                                RPAD(NVL(rec.PDP_DOMI_MANDA, ' '),45,' ')||
                                RPAD(NVL(rec.PDP_COMUNA_MANDA, '0'),5,'0')||
                                RPAD(NVL(rec.PDP_CIUDAD_MANDA, ' '),20,' ')||
                                RPAD(NVL(rec.PDP_REGION_MANDA, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_COD_ENT_BANCA, '0'),3,'0')||
                                RPAD(NVL(rec.PDP_TIP_CTA_MANDA, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_NRO_CTA_MANDA, '0'),18,'0')||
                                RPAD(NVL(rec.PDP_TOT_DESCTOS, '0'),8,'0 ')||
                                RPAD(NVL(rec.PDP_FECPAG_CONTRIB, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_FECPROX_PAGO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_ENT_BANCA_BEN, '0'),3,'0')||
                                RPAD(NVL(rec.PDP_ESTADO_PAGO, '0'),2,'0')||
                                RPAD(NVL(rec.PDP_RUT_ENT_TRASPASO, '0'),8,'0')||
                                RPAD(NVL(rec.PDP_DV_ENT_TRASPASO, ' '),1,' ');

                                --DBMS_OUTPUT.PUT_LINE(archivo_pgu(v_cont));

         v_cont := v_cont + 1;
         --dbms_output.put_line(archivo_pgu(v_cont));
     END LOOP;
  end if;
end;
*/

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
         where tfc_per_pe = 202303
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
         where tfc_per_pe = 202303
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
         where tfc_per_pe = 202303
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
         where tfc_per_pe = 202303
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


/*select *
from PENSIONES.pgu_datos_pago_periodo
where pdp_periodo=202312;*/

 
select datos_archpgu from ct_tmp_pgu where periodo=202303

select * from ct_log

select * from PGU_TEMP_MAX_PERIODO

select * from ct_tmp_pgu (NO VA)

select *
from pensiones.codigos 
where cod_template 
like '%REPOSIT_LIQ_CONTINGENCIA%' 
or cod_template like '%GENERAN_LIQ_CONTINGENCIA%'
or cod_template like '%REPOSIT_PRELIQ%'
or cod_template like '%REPOSIT_PAGO_PGU%' for update

/*
1) se debe crear un registro en pensiones.codigo para la ruta de la carpeta que contendrá el 
archivo de Pagos PGU

insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('REPOSIT_PAGO_PGU',NULL,'Carpeta archivos contingencia','\\srv-cloudberry\HISTORICA\QA_Certificacion\CTG_RV\PGU','S')

select *
from pensiones.codigos 
where cod_template 
like '%REPOSIT_PAGO_PGU%' for update

2) Otorgar permisos de roles 
grant execute on pensiones.sp_ct_gen_aut_all to usuario_pensiones;

3) Agregar llamada al Procedure SP_CT_GENARCH_PGU_EXCEL en el Procedure SP_CT_GEN_AUT_ALL

4) Crear tabla CONTINGENCIA_LOG en la instancia PENSIONES

5) Modificar ventana en PB w_principal (NO APLICA)

6) Verificar que swe haya generado el archivo Excel en el repositorio correspondiente

PARTE 2 ARCHIVOS PGU BCO ESTADO

--ver periodo actual
select to_number(to_char(prm_fec_desde,'yyyymm')), to_char(prm_fec_desde,'yyyy/mm')
from 	pensiones.paramet_fechas
where prm_tipo_tabla = 'RVLIQ';

select to_number(to_char(add_months(prm_fec_desde,1),'YYYYMM'))
	from pensiones.paramet_fechas 
	where prm_fec_desde = prm_fec_hasta 
	and prm_tipo_tabla = 'RVLIQ'

select plq_fec_pago01, plq_fec_pago02, plq_fec_pago03 
from pensiones.prmliqrv
where  plq_per >= 202301 for update;

select nvl(count(*),0) 
from pensiones.codigos 
where cod_template like '%DIA_CONTIN%' 
and cod_int_num in (select to_char(trunc(sysdate),'DD') 
                    		   from dual)
                           
select NVL(F_DIAS_HABILES_PRUEBA(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
                                       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')),0)
       from dual;                           
                   
select nvl(count(*),0)         
from pensiones.codigos 
where cod_template like '%HORA_CONTIN%' 
and cod_int_num <= (select to_char(sysdate,'HH24') 
                    			 from dual)
and (cod_int_num + 4) >= (select to_char(sysdate,'HH24') 
                          				from dual)                           

--verificar si ya se proceso en el periodo
select *
from pensiones.estadocontinpreliqrv
where plqr_per = 202401
and UPPER(plqr_id_program) = UPPER('Contingencia')
and trunc(PLQR_FEC_EJEC) = trunc(sysdate)
and plqr_id_estado in (1,2) for update; 


Extraer el periodo para ejecutar el Job PRELIQUIDACION
select 
sysdate-120,
to_number(extract(year from sysdate-120)||trim(lpad(to_char(extract(month from sysdate-120)),2,0)))
from dual;

*/
