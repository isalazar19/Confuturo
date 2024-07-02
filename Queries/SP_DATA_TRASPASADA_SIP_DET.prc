CREATE OR REPLACE PROCEDURE "SP_DATA_TRASPASADA_SIP_DET" (
                                        p_ano IN VARCHAR2,
                                        p_mes IN INTEGER,
                                        v_tabla OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN v_tabla FOR
    select CRT_RUT
          ,CRT_NOMB
          ,CRT_MTO_IMP monto_imponible
          ,0 cotizacion_salud_7
          ,0 adicional_salud
          ,CRT_COTIZ cotizacion_salud
          ,0 otra_rebajas
          ,CRT_MTO_TBT monto_tributable
          ,CRT_IMP_RET impuesto_unico
          ,0 impuesto_adicional
          ,CRT_RTA_EXE_$$ renta_exenta
          ,CRT_REB_ZEX_$$ zona_extrema
          ,CRT_FACTOR factor_actualizacion
          ,round(CRT_MTO_TBT * CRT_FACTOR, 0) monto_tributable_actualizado
          ,round(CRT_IMP_RET * CRT_FACTOR, 0) impuesto_unico_actualizado
          ,0 impuesto_adic_actualizado
    FROM CERTIF_RENTA
    where crt_anno = TO_NUMBER(p_ano)
    and crt_mes = p_mes;
    
END SP_DATA_TRASPASADA_SIP_DET;
/
