CREATE OR REPLACE PROCEDURE "SP_CT_GEN_AUT_ALL"
IS
BEGIN

   DECLARE
        v_liq_aut          NUMBER := 0;
        v_periodo_ant      NUMBER := 0;
        v_periodo_new      NUMBER := 0;
        v_cont_stock       NUMBER := 0;
        v_reprocesa_stock  NUMBER := 0;
        v_fecha_pago       DATE;
        v_fecha_gen_desde  DATE;
        v_fecha_gen_hasta  DATE;
        v_log_stock        NUMBER;
        v_cont_diferidas   NUMBER := 0;
        v_reprocesa_dif    NUMBER := 0;
        v_log_diferidas    NUMBER;
        v_fecha_pago_real  DATE;
        v_procesos_previos NUMBER := 0;
        v_log_gen_bco_chi  NUMBER;
        v_error            NUMBER;
        v_sqlerrm          VARCHAR2(2000);
        v_recipient        VARCHAR2(80) := 'confuturo@confuturo.cl';
        v_subject          VARCHAR2(80) := 'Generacion de registros de liquidacion de contingencia';
        v_rcpt_array       DBMS_SQL.varchar2_table;
        v_text             VARCHAR(200);
        v_cant_registros   NUMBER := 0;
        /* isalazarc - INI 12-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
        RF02 – ACTUALIZACIÓN DE CONTINGENCIA */
        v_cod_error        NUMBER;
        v_msj_error        VARCHAR2(200);
        /* isalazarc - FIN 12-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/
        /* isalazarc - INI 19-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
        RF01 - ACTUALIZACION DE CONTINGENCIA DEPURADA*/
        v_es_dia_preliq           NUMBER := 0;
        /* isalazarc - FIN 19-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/


begin
       /* isalazarc - INI 19-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
       RF01 - ACTUALIZACION DE CONTINGENCIA DEPURADA*/
       --to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
       --to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')
       select NVL(F_ULTIMO_DIA_HABIL_MES(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
                                       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')),0)
       into v_es_dia_preliq
       from dual;


       if v_es_dia_preliq = 1 then
       /* isalazarc - FIN 19-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/


         select to_number(to_char(add_months(prm_fec_desde,1),'YYYYMM'))
         into v_liq_aut
         from pensiones.paramet_fechas
         where prm_fec_desde = prm_fec_hasta
         and prm_tipo_tabla = 'RVLIQ';

         if v_liq_aut > 0 THEN
           --stock generacion
           SELECT  To_Number(To_char(prm_fec_hasta,'yyyymm')),
           To_Number(To_char(add_months(prm_fec_hasta,1),'yyyymm')),
           To_Date('18'||'/'||To_char(add_months(prm_fec_hasta,1),'mm')||'/'||To_char(add_months(prm_fec_hasta,1),'yyyy'), 'dd/mm/yyyy'),
           To_Date('01'||'/'||To_char(add_months(prm_fec_hasta,1),'mm')||'/'||To_char(add_months(prm_fec_hasta,1),'yyyy'), 'dd/mm/yyyy'),
           To_Date(To_char(Last_Day(add_months(prm_fec_hasta,1)), 'dd')||'/'||To_char(add_months(prm_fec_hasta,1),'mm')||'/'||To_char(add_months(prm_fec_hasta,1),'yyyy'), 'dd/mm/yyyy')
           INTO    v_periodo_ant,
           v_periodo_new,
           v_fecha_pago,
           v_fecha_gen_desde,
           v_fecha_gen_hasta
           FROM     PENSIONES.PARAMET_FECHAS
           WHERE    prm_tipo_tabla = 'RVLIQ';

           SELECT  nvl(Count(*),0)
           INTO    v_cont_stock
           FROM    PENSIONES.PARAMET_CONTINGENCIA
           WHERE   PRM_PER  = v_periodo_new
           AND     PRM_PROC1= 1;

           if v_cont_stock > 0 then
             v_reprocesa_stock := 1;
           elsif v_cont_stock <= 0 or v_cont_stock is null then
             v_reprocesa_stock := 0;
           end if;

  --Abril/2023 Novasis: para guardar si existe proceso de diferidas ejecutado, ya que
  --en sp_ct_genliq_stock se inicializan valores en tabla de parámetros

           --diferidas generado
           SELECT nvl(Count(*),0)
           INTO   v_cont_diferidas
           FROM   PARAMET_CONTINGENCIA
           WHERE  PRM_PER = v_periodo_new
           AND    PRM_PROC2= 1;


                              --202004        202003       18/04/2020      1 si 0 no
           SP_CT_GENLIQ_STOCK(v_periodo_new,v_periodo_ant,v_fecha_pago,v_reprocesa_stock, v_log_stock);

  /*Abril/2023 Novasis:
           --diferidas generado
           SELECT nvl(Count(*),0)
           INTO   v_cont_diferidas
           FROM   PARAMET_CONTINGENCIA
           WHERE  PRM_PER = v_periodo_new
           AND    PRM_PROC2= 1;
  */
           if v_cont_diferidas > 0 then
             v_reprocesa_dif := 1;
           elsif v_cont_diferidas <= 0 or v_cont_diferidas is null then
             v_reprocesa_dif := 0;
           end if;
                                   --202004          202003          1 si 0 no
           SP_CT_GENLIQ_DIFERIDAS( v_periodo_new, v_periodo_ant, v_reprocesa_dif, v_log_diferidas);

           --genera datos para archivo banco de chile
           SELECT nvl(Count(*),0)
           INTO   v_procesos_previos
           FROM   PENSIONES.PARAMET_CONTINGENCIA
           WHERE  PRM_PER   = v_periodo_new
           AND    PRM_PROC1 = 1
           AND    PRM_PROC2 = 1;


           SELECT PRM_FECHA_PAGO
           INTO   v_fecha_pago_real
           FROM PENSIONES.PARAMET_CONTINGENCIA
           WHERE prm_per = v_periodo_new;

           if v_procesos_previos > 0 then
                                      --202004        18/04/2020
              SP_CT_GENARCH_BCOCHILE( v_periodo_new, v_fecha_pago, v_log_gen_bco_chi);
           end if;

           /* isalazarc - INI 12-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU
           RF02 – ACTUALIZACIÓN DE CONTINGENCIA */
           --sp_ct_genarch_pgu_excel(v_periodo_new,v_cod_error,v_msj_error);
           SP_CT_GENARCH_CARTERA_EXCEL(v_periodo_ant,v_cod_error,v_msj_error); /* 21-06-2024 se cambia fecha periodo ant */
           /* isalazarc - FIN 12-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/

           if v_log_stock != -1 and v_log_diferidas != -1 and v_log_gen_bco_chi != -1 then
              BEGIN
                 UPDATE PARAMET_CONTINGENCIA
                 SET    PRM_PROC7 = 1
                 WHERE  PRM_PER = v_periodo_new;
                 commit;
                 EXCEPTION WHEN OTHERS THEN
                           v_sqlerrm := SubStr(sqlerrm,1,2000);
                           v_error := -1;
             END;
              begin
                select nvl(count(*),0)
                into v_cant_registros
                from pensiones.ct_liqrv
                where lqr_per = v_periodo_new;

                --Recipiente de direcciones
                v_Rcpt_array(1) := 'fortizs.externo@confuturo.cl';
                v_Rcpt_array(2) := 'rvillalobosa@confuturo.cl';
                v_Rcpt_array(3) := 'jguerram@confuturo.cl';
                v_Rcpt_array(4) := 'rrubiod@confuturo.cl';
                v_Rcpt_array(5) := 'jvillalobosf@confuturo.cl';

                v_text := 'Registros generados para liquidacion periodo :'||v_periodo_new||' son '||v_cant_registros||  '.';

                if v_cant_registros >= 0 then
                   PS_ENVIA_CORREO_CF(v_subject,
                                      v_rcpt_array,
                                      v_recipient,
                                      v_text);
                end if;
           end;
           end if;

        end if;
      end if; /* isalazarc - FIN 19-02-2024 PROYECTO MANTENCION PROCESO DE CONTINGENCIA, LIQUIDACION Y PGU*/
   end;
end;
/
