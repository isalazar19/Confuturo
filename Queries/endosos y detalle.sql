/* endosos */

--1.- Buscar endosos por periodo
select * from pensiones.endosos
where end_periodo=202401;

--2.- cabecera de endo
SELECT endosos.END_PERIODO,
       endosos.END_COBERTURA,
       endosos.END_NRO_ENDOSO,
       endosos.END_FEC_VIG,
       endosos.END_CORREL 
  FROM endosos
 WHERE (ENDOSOS.END_LINEA = 3)
   AND (ENDOSOS.END_PRODUCTO = 607)
   AND (ENDOSOS.END_DOCUMENTO = 2)
   AND (ENDOSOS.END_POLIZA = 644617);
   --AND (ENDOSOS.END_ASEGURADO = 1476118); /* si losabe */

/* detalle endoso */
select end_periodo
      ,ctm_descripcion
      ,end_nro_endoso
      ,end_fec_vig
      ,case
         when end_nro_endoso = 1 and end_tip_end = 1 then
           case mod_tipo_modif
             when 30 then 0
             else mod_cantidad_ant
           end
         else end_prima_ant
       end PNS_ANT
      ,case
         when end_nro_endoso = 1 and end_tip_end = 1 then
           case mod_tipo_modif
             when 30 then end_prima_nue
             else mod_cantidad_nue
           end
         else end_prima_nue
       end PNS_NVA
      ,case
         when end_nro_endoso = 1 and end_tip_end = 1 then
           case mod_tipo_modif
             when 30 then 0
             else end_prima_ant
           end
         else mod_cantidad_ant
       end PRIMA_ANT
      ,case
         when end_nro_endoso = 1 and end_tip_end = 1 then
           case mod_tipo_modif
             when 30 then mod_cantidad_nue
             else end_prima_nue
           end
         else mod_cantidad_nue
       end PRIMA_NVA
      ,end_trib_ant
      ,end_trib_nue
      ,end_porc_trib_ant
      ,end_porc_trib_nue
      ,end_no_trib_ant
      ,end_no_trib_nue
      ,end_porc_no_trib_ant
      ,end_porc_no_trib_nue
  from pensiones.catmod
      ,pensiones.modificaciones
      ,pensiones.endosos
 where mod_linea      = end_linea
   and mod_producto   = end_producto
   and mod_documento  = end_documento
   and mod_poliza     = end_poliza
   and mod_asegurado  = end_asegurado
   and mod_linea      = 3
   and ctm_tipo_modif = mod_tipo_modif
   and mod_nro_endoso = end_nro_endoso
   and mod_correl     = end_nro_modif
   and end_correl     = 2271362;

/* obtiene el nombre del beneficiario del endoso */
select * 
from pensiones.modificaciones,  pensiones.persnat
where mod_correl=2271362
and mod_ben=nat_id;

/* Obtiene el Tipo de Endoso */
select
  trim(replace(to_char(nat_numrut,'99,999,999')||'-'||nat_dv,',','.')) rut_benef,
  dbe_tipo_endoso tipo_endoso,
  ctm_descripcion glosa_endoso
from pensiones.datos_ben,pensiones.catmod, pensiones.persnat,
pensiones.modificaciones
where dbe_numpoliza = 644617
and dbe_periodo = 202401
and dbe_tipo_endoso = ctm_tipo_modif
and dbe_id_benef = nat_id
and dbe_numpoliza = mod_poliza
and dbe_periodo = mod_periodo
and dbe_tipo_endoso = mod_tipo_modif
and dbe_id_benef = mod_ben
and dbe_id_causante = mod_asegurado
order by mod_correl asc;

