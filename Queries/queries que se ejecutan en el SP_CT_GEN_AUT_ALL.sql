/* queries que se ejecutan en el SP SP_CT_GEN_AUT_ALL 

1.- DETERMINA LOS DIAS 20 Y 25 Y EL ULTIMO DIA HABIL MES 
F_ULTIMO_DIA_HABIL_MES
RETORNA 1=SI EJECUTA 0=NO EJECUTA

2.- SI ES 1 RETORNA EL PERIODO A PROCESAR, PARA PERIODO 202312 SE COLOCA 0 EN ADD_MONTHS()
   select to_number(to_char(add_months(prm_fec_desde,0),'YYYYMM'))
     from pensiones.paramet_fechas 
     where prm_fec_desde = prm_fec_hasta 
     and prm_tipo_tabla = 'RVLIQ';
         
3.- LUEGO CONSULTA ESTAS FECHAS

   SELECT  To_Number(To_char(prm_fec_hasta-1,'yyyymm')),
           To_Number(To_char(add_months(prm_fec_hasta,0),'yyyymm')),
           To_Date('18'||'/'||To_char(add_months(prm_fec_hasta,0),'mm')||'/'||To_char(add_months(prm_fec_hasta,0),'yyyy'), 'dd/mm/yyyy'),
           To_Date('01'||'/'||To_char(add_months(prm_fec_hasta,0),'mm')||'/'||To_char(add_months(prm_fec_hasta,0),'yyyy'), 'dd/mm/yyyy'),
           To_Date(To_char(Last_Day(add_months(prm_fec_hasta,0)), 'dd')||'/'||To_char(add_months(prm_fec_hasta,0),'mm')||'/'||To_char(add_months(prm_fec_hasta,0),'yyyy'), 'dd/mm/yyyy')
           FROM     PENSIONES.PARAMET_FECHAS 
           WHERE    prm_tipo_tabla = 'RVLIQ';      

   SELECT  *--nvl(Count(*),0)
           FROM    PENSIONES.PARAMET_CONTINGENCIA 
           WHERE   PRM_PER  = 202312 -- VALOR DEL RESULTADO DEL 2DO CAMPO DEL SELECT ANTERIOR
           AND     PRM_PROC1= 1;

--diferidas generado 
           SELECT nvl(Count(*),0)
           --INTO   v_cont_diferidas
           FROM   PARAMET_CONTINGENCIA
           WHERE  PRM_PER = 202312
           AND    PRM_PROC2= 1;

--en sp_ct_genliq_stock se inicializan valores en tabla de parámetros
