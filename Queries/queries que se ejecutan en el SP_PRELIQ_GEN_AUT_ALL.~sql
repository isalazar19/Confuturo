
/*
1.- PARA EJECUTAR JOB_PRELIQ FORZAMOS LA FECHA MANUALMENTE DE ACUERDO AL PERIODO
    EN ESTE CASO el 3ER dia habil de inicio de mes 202401
    COPIAR A LA FUNCION ESTAS LINEAS
*/
select NVL(F_DIAS_HABILES_PRELIQ(to_date('01/'||'01'||to_char(sysdate,'yyyy'),'dd/mm/yyyy'),
                                 to_date('04/'||'01'||to_char(sysdate,'yyyy'),'dd/mm/yyyy')),0)
      --into v_es_dia_preliq
      from dual;

/*
2.- se valida que hayan ingresado los parametros
si no se encuentra registro en prmliqrv
usuario debe ingresar esto vía mantenedor en SIP (pensiones)
*/
select *--nvl(count(*),0)
       --into v_existe_prmliqrv
       from pensiones.prmliqrv
       where plq_per = (select to_number(to_char(add_months(prm_fec_hasta,1),'YYYYMM'))
                        from pensiones.paramet_fechas
                        where prm_tipo_tabla='RVLIQ');
                        

                 
--ingreso de ipc de preliquidacion con valor igual a
       --ultima liquidacion oficial autorizada
       select to_number(to_char(add_months(to_date(max(ipc_per),'yyyymm'),1),'yyyymm'))
       --into v_per_ipc_preliq
       from gensegur.ipc;
       
select * from gensegur.ipc order by 1 desc for update; 

/* 
verificar que se ingrese este registro BATCH
*/
select * from pensiones.preliqrv order by 1 desc for update;
                        

--valida si esta insertado
         SELECT *--nvl(count(*),0)
         --into v_existe_uf_insert
         FROM gensegur.VALORMONEDA
         WHERE VALORMONEDA.VMON_MONEDA = 1
         AND VALORMONEDA.VMON_FECHA >=
            (select to_date('10/'||to_char(add_months(prm_fec_hasta,1),'mm/yyyy'),'dd/mm/yyyy')
             from   pensiones.paramet_fechas
             where  prm_tipo_tabla = 'RVLIQ')
         AND VALORMONEDA.VMON_FECHA <=
             (select to_date('09/'||to_char(add_months(prm_fec_hasta,2),'mm/yyyy'),'dd/mm/yyyy')
              from   pensiones.paramet_fechas
              where  prm_tipo_tabla = 'RVLIQ')
         ORDER BY VALORMONEDA.VMON_FECHA ASC;
         
--si tiene registros se eliminan para volver a insertarlos
DELETE FROM gensegur.VALORMONEDA
         WHERE VALORMONEDA.VMON_MONEDA = 1
         AND VALORMONEDA.VMON_FECHA >=
            (select to_date('10/'||to_char(add_months(prm_fec_hasta,1),'mm/yyyy'),'dd/mm/yyyy')
             from   pensiones.paramet_fechas
             where  prm_tipo_tabla = 'RVLIQ')
         AND VALORMONEDA.VMON_FECHA <=
             (select to_date('09/'||to_char(add_months(prm_fec_hasta,2),'mm/yyyy'),'dd/mm/yyyy')
              from   pensiones.paramet_fechas
              where  prm_tipo_tabla = 'RVLIQ');




