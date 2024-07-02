/* queries para procesar la contingencia desde PB */
/*
/*************************************************************
PROCESO DE CONTINGENCIA 
*************************************************************/
/*
1.- Verificar que la fecha a ejecutar sea el 20,25 y ultimo dia habil del mes
*/
select NVL(F_ULTIMO_DIA_HABIL_MES(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
                                       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')),0)
       from dual;

--pasar la fecha manual para pruebas
select NVL(F_ULTIMO_DIA_HABIL_MES(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
       to_date('17/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy')),0) from dual;

/*
2.- Verificar si existe preliq autorizada
*/

select *--nvl(count(*),0)
from pensiones.paramet_fechas 
where prm_fec_desde = prm_fec_hasta 
and prm_tipo_tabla = 'RVLIQ';

/*
3.- Verificar si se genero la contingencia PRM_PROC1=1 y PRM_PROC7=1
*/
select *--nvl(count(*),0)
--into :ll_contingencia_generada
from pensiones.paramet_contingencia 
where prm_per =
               ( select to_number(to_char(add_months(prm_fec_desde,0),'YYYYMM'))
                 from pensiones.paramet_fechas 
                 where prm_fec_desde = prm_fec_hasta 
                 and prm_tipo_tabla = 'RVLIQ'
               )
and prm_proc7 = 1 for update;

select * from pensiones.paramet_contingencia where prm_per=202404 for update;

/*
4.- Obtiene el periodo 
*/
select to_number(to_char(add_months(prm_fec_desde,1),'YYYYMM'))
	from pensiones.paramet_fechas 
	where prm_fec_desde = prm_fec_hasta 
	and prm_tipo_tabla = 'RVLIQ';
  
select * from pensiones.paramet_fechas where prm_tipo_tabla='RVLIQ' for update;


                                  
/*
6.- Verificar que no existe proceso de contingencia, si hay registro se borra para reprocesar
*/
select *--nvl(count(*),0)
from pensiones.estadocontinpreliqrv
where plqr_per = 202404  --periodo obtenido en el punto #4
and UPPER(plqr_id_program) = UPPER('Contingencia')
and trunc(PLQR_FEC_EJEC) = trunc(sysdate)
and plqr_id_estado in (1,2) for update;   

/*************************************************************
PROCESO DE PRELIQUIDACION 
*************************************************************/
/*
7.- Verificar
*/

select NVL(F_DIAS_HABILES_PRELIQ(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
                                       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')),0)
      from dual;
--forzar una fecha para ejecuatar manualmente el job
--se coloca la fecha del 3 dia habil inicio mes
--por ejemplo: en este caso el dia 04-01-2024 para el periodo 202401
select NVL(F_DIAS_HABILES_PRELIQ(to_date('01/'||'01'||to_char(sysdate,'yyyy'),'dd/mm/yyyy'),
                           to_date('04/'||'01'||to_char(sysdate,'yyyy'),'dd/mm/yyyy')),0)
from dual;

/*
8.- Verificar si se ejecuto el Job JOB_PRELIQUID_AUT
*/
SELECT *
 FROM PENSIONES.PRELIQRV WHERE PLQR_PER = 202404;
 
select prm_fec_desde from pensiones.paramet_fechas 
	where prm_fec_desde = prm_fec_hasta 
	and prm_tipo_tabla = 'RVLIQ';

SELECT *
 FROM ADMBATCH.ABATCH_INSCRIPCIONES WHERE INS_PROCESO = 'RBLQS10' and ins_estado=4 
 -- and ins_timestamp between trunc(sysdate-49) and trunc(sysdate-33);  --and INS_COD_CORRELATIVO=855491;

SELECT * 
 FROM ADMBATCH.ABATCH_PROCESOS WHERE PRC_CODIGO = 'RBLQS10';


SELECT nvl(count(*),0), plqr_per, INS_COD_CORRELATIVO
		FROM ADMBATCH.ABATCH_INSCRIPCIONES,
				ADMBATCH.ABATCH_PROCESOS,
				pensiones.preliqrv
		WHERE PRC_APLICACION ='PENSIONES'
		AND PRC_CODIGO = INS_PROCESO
		AND INS_TIMESTAMP >= to_date('30/12/2019','dd/mm/yyyy')
		and upper(trim(ins_proceso)) = 'RBLQS10'
    and ins_timestamp between trunc(sysdate-40) and trunc(sysdate-26)
		--and ins_timestamp between trunc(sysdate-10) and trunc(sysdate+1)
		and ins_estado = 4
		and ins_cod_correlativo = plqr_id_batch
		and upper(trim(ins_proceso)) = upper(trim(plqr_id_program))
		and to_number(to_char(sysdate, 'HH24')) >= to_number((select cod_int_char
																							  from pensiones.codigos 
																					  where cod_template like '%HORA_PRELIQ%'))
		/*and to_number(to_char(sysdate, 'HH24')) <= (to_number((select cod_int_char
																									from pensiones.codigos 
																									where cod_template like '%HORA_PRELIQ%'))+4)*/
		and rownum <= 1
		group by plqr_per, INS_COD_CORRELATIVO;

/*
PRELIQ BCO CHILE
9.- valida si existen registros generados de preliquidacion
*/
select *--nvl(count(*),0)
from pensiones.preliq_tmp;

/*
10.- Verificar que no existe proceso de preliq, si hay registro se borra para reprocesar
*/select *--nvl(count(*),0)
from pensiones.estadocontinpreliqrv
where plqr_per = 202404  --periodo obtenido en el punto #4
and UPPER(plqr_id_program) = UPPER('Preliquidacion')
and plqr_id_estado in (1,2) for update; 


select * from pensiones.estadocontinpreliqrv 
where UPPER(plqr_id_program) = UPPER('Preliquidacion') for update

