/* pARA EJECUTAR LOS jobs */
--1.- SE OBTIENE EL PERIODO DESEADO DE FORMA MANUAL
select TO_number(to_char(to_date('31/12/2023','dd/mm/rrrr'),'YYYY')||to_char(to_date('31/12/2023','dd/mm/rrrr'),'MM'))
from dual;

select prm_fec_hasta + 1 , prm_fec_desde, prm_fec_hasta --01-01-2024  31-12-2023  31-12-2023
       from pensiones.paramet_fechas
       where prm_tipo_tabla='RVLIQ';


select to_number(to_char(add_months(prm_fec_hasta,1),'YYYYMM')) --202401
                        from pensiones.paramet_fechas
                        where prm_tipo_tabla='RVLIQ';
                        
select * from pensiones.prmliqrv order by plq_per DESC;

select nvl(count(*),0) from pensiones.prmliqrv where plq_per=(
select to_number(to_char(add_months(prm_fec_hasta,1),'YYYYMM')) --202401
                        from pensiones.paramet_fechas
                        where prm_tipo_tabla='RVLIQ');
                        
select to_char(add_months(prm_fec_hasta,1),'mm/yyyy'),
              to_number(to_char(add_months(prm_fec_hasta,1),'yyyymm'))
       from   pensiones.paramet_fechas
       where  prm_tipo_tabla = 'RVLIQ';                        

select * from gensegur.ipc  order by 1 desc     

select TRIM(nvl(cod_ext,'')) --INTO directorio
      from rentapre.codigos
      where codigos.cod_int_num = 5
      and codigos.cod_int_char = '0'
      and codigos.cod_template = 'PROC_GEN_POLIZA';      
      
/* obtener PGU EXCEL */
select * from PENSIONES.pgu_datos_pago_periodo where pdp_periodo=202303;

select * from pensiones.estadocontinpreliqrv where plqr_per=202303;
                 
