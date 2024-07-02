/* LISTADO EMISION CARTAS DE ENDOSOs NEW*/
select ' ' marca,
       end_poliza ,
       nat_numrut  ,
       nat_dv ,
       nat_nomb ,
       end_prima_ant ,
       end_prima_nue ,
             case when mod_dig_nue =  8 and  mod_tipo_modif = 55 then 
         'Remoción beneficiario'
        else
            ctm_descripcion end end_descrip,
       mod_ben ,
       ctm_tipo_modif,
       end_asegurado,
       end_nro_modif,
       nat_nombre,
       nat_ap_pat,
       nat_ap_mat,
       end_correl,
       (select trim(cod_ext) from codigos where cod_template like 'TE06_TIPO_ENDOSOS' and cod_int_num=end_tip_end) tipo_endoso,
       to_char(substr(end_periodo,5,2))||'/'||to_char(substr(end_periodo,1,4)) periodo,
       to_char(end_fec_vig,'dd/mm/yyyy') fecha_de_emision,
       mod_dig_ant,
       mod_dig_nue,
       decode(mod_ben,null, '', cod_ext) relacion 

 ,
      (select case when sin_tipo = 1 then 'Sobrevivencia'
                    when sin_tipo = 8 and sin_producto in (606,607) then 'Vejez Anticipada'
                    when sin_tipo = 8 and sin_producto in (603,604) then 'Vejez Normal'
                    when sin_tipo = 2  
                       THEN  CASE when (select ben_invalido
                          from pensiones.beneficiarios
                          where ben_producto = sin_producto
                        and ben_linea = sin_linea
                        and ben_documento = sin_documento 
                        and ben_causante = sin_id 
                        and ben_poliza = sin_poliza
                        and ben_relacion = 0 ) = 1 then 'Invalidez Total' 
                                          
                                        ELSE 'Invalidez Parcial ' 
                                    END
                      end 
       from pensiones.siniestros s1
       where s1.sin_linea = end_linea 
             and s1.sin_producto = end_producto 
             and s1.sin_documento = end_documento 
             and s1.sin_poliza = end_poliza 
             and s1.sin_id = end_asegurado 
            
             and s1.sin_tipo in (select min(sin_tipo)
                              from pensiones.siniestros s2
                              where s2.sin_linea = s1.sin_linea
                                    and s2.sin_producto = s1.sin_producto
                                    and s2.sin_documento = s1.sin_documento
                             and s2.sin_poliza = s1.sin_poliza
                                    and s2.sin_id = s1.sin_id)) cob_actual,
  bnf_cobertura, 
decode( F_BUSCA_BENEF_VIG(bnf_poliza, bnf_beneficiario),0, 'Si', 'No') ult_benef,
bnf_grupo , 
ben_relacion
  from pensiones.endosos,
       pensiones.modificaciones , 
       pensiones.beneficios,
       pensiones.beneficiarios,
       pensiones.persnat,
       pensiones.catmod,
       pensiones.codigos
       
       
 where  (((end_estado <> 2 or end_estado is null) and 1 = 1 ) or (end_estado =  2 and 2 = 1))
   and end_periodo = 202401
   and mod_periodo = end_periodo 
   and mod_linea = end_linea 
   and mod_producto = end_producto 
   and mod_documento = end_documento 
   and mod_poliza = end_poliza 
   and mod_asegurado = end_asegurado 
   and mod_cobertura = end_cobertura 
   and mod_correl =  end_nro_modif 
   
   and mod_linea = bnf_linea 
   and mod_producto = bnf_producto 
   and mod_documento = bnf_documento 
   and mod_poliza = bnf_poliza 
   and mod_asegurado = bnf_causante 
   --and mod_ben = bnf_beneficiario 
   and mod_ben = bnf_beneficiario
   and mod_cobertura = bnf_cobertura
   
   and bnf_linea =  ben_linea 
   and bnf_producto = ben_producto 
   and bnf_documento = ben_documento 
   and bnf_poliza = ben_poliza 
   and bnf_causante = ben_causante 
   and bnf_beneficiario = ben_beneficiario 

   and nat_id = end_asegurado 
   and ben_relacion = cod_int_num
   and mod_tipo_modif = ctm_tipo_modif
   and cod_template =  'TR07-RELACION-BENEFICIARIOS'
 order by end_poliza asc, end_nro_modif asc


-- select end_correl,end_nro_modif from pensiones.endosos_bnl where end_poliza=677825 and end_periodo=202310  (1955444,1925446)
-- select * from modificaciones_bnl where mod_correl=1925446
-- select end_correl,end_nro_modif from pensiones.endosos where end_poliza=647562 and end_periodo=202310 (2266737, 2266737)
-- select * from modificaciones where mod_correl=2266954

-- select * from pensiones.datos_ben where dbe_tipo_endoso=75 and dbe_periodo>=202301

-- select * from pensiones.endosos_bnl where end_periodo=202312 and end_poliza in (8075,678075,652487,677989,679370,679909,680025,680136) order by end_poliza;
-- select * from pensiones.endosos where end_periodo=202312 and end_poliza in (8075,678075,652487,677989,679370,679909,680025,680136) order by end_poliza;
-- select * from pensiones.modificaciones where mod_periodo=202312 and mod_poliza in (8075,678075,652487,677989,679370,679909,680025,680136) order by mod_poliza
-- select * from pensiones.modificaciones where mod_periodo=202401  order by mod_poliza

