select * from pensiones.contingencia_log order by 1 for update
--delete from pensiones.contingencia_log

--ALTER TABLE pensiones.contingencia_log DISABLE CONSTRAINT PK_CONTING_LOG;

/*
select NVL(F_ULTIMO_DIA_HABIL_MES(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
                                       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')),0)
       from dual;

--pasar la fecha manual para pruebas
select NVL(F_ULTIMO_DIA_HABIL_MES(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
       to_date('17/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy')),0) from dual;

--eliminar para hacer pruebas
select *
from pensiones.estadocontinpreliqrv
where plqr_per = 202401
and UPPER(plqr_id_program) = UPPER('Contingencia')
and trunc(PLQR_FEC_EJEC) = trunc(sysdate)
and plqr_id_estado in (1,2)  for update; 




*/
--muestra la fecha y hora con formato de 24H
select to_Date(to_char(sysdate,'dd/mm/yyyy HH24:mi:ss'),'dd/mm/yyyy HH24:mi:ss')
from dual;

--verifica si existen registros generados de preliq
--en caso de que no hayan registros se debe ejecuatr el JOB_PRELIQ_AUT
--luego el SP_PRELIQ_GENARCH_BCOCHILE no ejecutarlo manual ya que se ejecuta desde
--el PB  f_preliq_genera_bcochile
select *--nvl(count(*),0)
from pensiones.preliq_tmp;

select * from ct_log where log_date_crea=to_date('09-04-2024', 'dd-mm-yyyy') for update

select * from pensiones.ct_liqrv where lqr_per=202401



