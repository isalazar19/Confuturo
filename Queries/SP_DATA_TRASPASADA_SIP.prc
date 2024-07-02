CREATE OR REPLACE PROCEDURE "SP_DATA_TRASPASADA_SIP" (
                                        p_ano IN VARCHAR2,
                                        v_tabla OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN v_tabla FOR
       select CRT_MES
              ,TO_CHAR(TO_DATE(TO_CHAR(CRT_MES), 'mm'),'Month','NLS_DATE_LANGUAGE = SPANISH') detalle_mes
              ,sum(CRT_MTO_IMP) monto_imponible
              ,0 cotizacion_salud_7
              ,0 adicional_salud
              ,sum(CRT_COTIZ) cotizacion_salud
              ,0 otra_rebajas
              ,sum(CRT_MTO_TBT) monto_tributable
              ,sum(CRT_IMP_RET) impuesto_unico
              ,0 impuesto_adicional
              ,sum(CRT_RTA_EXE_$$) renta_exenta
              ,sum(CRT_REB_ZEX_$$) zona_extrema
              ,CRT_FACTOR factor_actualizacion
              ,sum(round(CRT_MTO_TBT * CRT_FACTOR, 0)) monto_tributable_actualizado
              ,sum(round(CRT_IMP_RET * CRT_FACTOR, 0)) impuesto_unico_actualizado
              ,0 impuesto_adic_actualizado
        FROM CERTIF_RENTA
        where crt_anno = TO_NUMBER(p_ano)
        and crt_mes <= (select max(crt_mes) FROM CERTIF_RENTA
                        where crt_anno = TO_NUMBER(p_ano) )
        GROUP BY crt_MES,CRT_FACTOR
        order by 1;

END SP_DATA_TRASPASADA_SIP;
/
