  SELECT  end_asegurado, 
          SYSDATE Fecha,
          end_poliza,
         PERSNAT_A.nat_nomb persnat_nombre, persnat_a.nat_sexo,
         DOMICILIOS.DOM_DIRECCION domicilio,
         DOMICILIOS.DOM_COMUNA,
         DOMICILIOS.DOM_CIUDAD,
         grp_id_recep,
          PERSNAT_b.NAT_SEXO persnat_nat_sexo,   
          PERSNAT_A.NAT_EST_CIVIL persnat_nat_est_civil,   
          PERSNAT_A.NAT_FEC_NACIM, TRUNC((TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) -  TO_NUMBER(TO_CHAR(PERSNAT_A.NAT_FEC_NACIM,'YYYYMMDD') ) ) / 10000) AS Edad,
          PERSNAT_B.NAT_NOMBRE || ' ' ||  PERSNAT_B.NAT_AP_PAT || ' ' || PERSNAT_B.NAT_AP_MAT nombre_ben,
          decode(PERSNAT_B.NAT_SEXO,'F','MHN','M','PHN','MHN o PHN') identificacambiomhnphn,
          end_cobertura ,
          COBERTURA.COB_DESCRIPCION,
          end_poliza ,
          end_linea ,
          persnat_a.nat_numrut || '-' || persnat_a.nat_dv rut , 
            mod_tipo_modif, 
         end_fec_vig ,
         mod_cantidad_ant pns_ant,
         mod_cantidad_nue pns_nva,
        case when mod_tipo_modif = 57 and mod_dig_ant <> 0 then 
           to_date(  to_char(Substr(mod_dig_ant, 7, 2)||'/'|| Substr(mod_dig_ant, 5, 2)||'/'||Substr(mod_dig_ant, 1, 4)), 'dd/mm/yyyy') 
        else 
          null end fec_ant, 
        case when mod_tipo_modif = 57 and mod_dig_nue <> 0 then 
           to_date(  to_char(Substr(mod_dig_nue , 7, 2)||'/'|| Substr(mod_dig_nue , 5, 2)||'/'||Substr(mod_dig_nue , 1, 4)), 'dd/mm/yyyy') 
         else 
            null 
         end fec_nva,
         end_nro_endoso,
          case when mod_tipo_modif = 181
                then 'INGRESO DE NUEVO BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
             when mod_tipo_modif = 55
                then 'CAMBIO RELACI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
         when mod_tipo_modif = 75 or mod_tipo_modif = 58 
                then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
         when mod_tipo_modif = 57 
                then 'MODIFICA FECHA DE NACIMIENTO CAUSANTE/BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
         when mod_tipo_modif = 59
                then 'MODIFICA SEXO CAUSANTE/BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
         when mod_tipo_modif = 60
                then 'MODIFICA CONDICI�N INVALIDEZ P�LIZA N� '||to_char(end_poliza)  
      END tipo_endoso,
      (select decode(ben_invalido, 1,'Inv�lido total', 3, 'Inv�lido parcial', 'No inv�lido') 
       from pensiones.beneficiarios
       where ben_linea = bnf_linea 
             and ben_producto = bnf_producto 
             and ben_documento = bnf_documento 
             and ben_poliza = bnf_poliza 
             and ben_causante = bnf_causante 
             and ben_beneficiario = bnf_beneficiario ) t_inval,
       ( case Substr(end_periodo,5,2)
              
                when  '01' then 'Enero de '
                when '02' then 'Febrero de '
                when '03' then 'Marzo de '
                when '04' then 'Abril de '
                when '05' then 'Mayo de '
                when '06' then 'Junio de '
                when '07' then 'Julio de '
                when '08' then 'Agosto de '
                when '09' then 'Septiembre de '
                when '10' then 'Octubre de '
                when '11' then 'Noviembre de '
                when '12' then 'Diciembre de '
                else 'otro' end )
                || ' '  || 
                Substr(end_periodo,1,4) per_pago,
          ( case when mod_tipo_modif = 59 
             then  case when persnat_b.nat_sexo = 'F'
                   then  'Masculino'
                   else 'Femenino'
                  end
             else
               decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino')
             end) sexo_ant
             ,decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino') sexo_act
          ,PERSNAT_B.NAT_NOMBRE , PERSNAT_B.NAT_AP_PAT , PERSNAT_B.NAT_AP_MAT
      , mod_ben 
      , end_periodo
         , end_correl
         , (select cod_ext
            from asegafp,codigos 
            where asaf_afp = cod_int_num 
            and cod_template='TA02-AFP' 
            and asaf_poliza=7400) glosaafp
          , (select cod_ext from pensiones.beneficiarios,pensiones.codigos 
           where ben_linea = mod_linea 
                 and ben_producto = mod_producto  
                 and ben_documento = mod_documento 
                 and ben_poliza = mod_poliza 
                 and ben_causante = mod_asegurado 
                 and ben_beneficiario=mod_ben
                 and ben_relacion=cod_int_num 
                 and cod_template = 'TR07-RELACION-BENEFICIARIOS') tiporelacionbeneficiario
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_ant and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarioanterior
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_nue and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarionueva
      
            , PERSNAT_R.nat_nomb  nombre_envio
      , (select nvl((dpo_pns_ref_nva - dpo_pns_ref_act  ),0)
      from pensiones.datos_pol 
      where dpo_linea = mod_linea 
          and dpo_producto = mod_producto
          and dpo_documento = mod_documento
          and dpo_numpoliza =mod_poliza
          and dpo_id_causante =mod_asegurado
          and dpo_cobertura = mod_cobertura
          and dpo_periodo = mod_periodo)   diferencia,
         nvl((select cod_ext
   from pensiones.beneficiarios, 
        pensiones.codigos 
   where ben_relacion = cod_int_num
         and cod_template= 'TR07-RELACION-BENEFICIARIOS'
         and ben_linea = bnf_linea 
         and ben_producto = bnf_producto 
         and ben_documento = bnf_documento 
         and ben_poliza = bnf_poliza 
         and ben_causante = bnf_causante 
         and ben_beneficiario = bnf_beneficiario 
         and ben_relacion <> 9  )  , '')  relacion,
         dbe_fec_inf_cia,
         cep_fec_ini_vig
    FROM PERSNAT PERSNAT_A,
    PERSNAT PERSNAT_B,
  PERSNAT PERSNAT_R,
         DOMICILIOS,
         GRUPOPAGO,
         BENEFICIOS,
         pensiones.endosos_bnl,
         pensiones.modificaciones_bnl,
         pensiones.catmod,
         COBERTURA,
         pensiones.datos_ben,
         pensiones.certper
   WHERE DOMICILIOS.DOM_ID_DOM = GRUPOPAGO.GRP_ID_DOM
   and GRUPOPAGO.GRP_GRUPO = 1 --BENEFICIOS.BNF_GRP_PAG
   and GRUPOPAGO.GRP_POLIZA = BENEFICIOS.BNF_POLIZA
   and GRUPOPAGO.GRP_PRODUCTO = BENEFICIOS.BNF_PRODUCTO
   and GRUPOPAGO.GRP_DOCUMENTO = BENEFICIOS.BNF_DOCUMENTO
   and GRUPOPAGO.GRP_LINEA = BENEFICIOS.BNF_LINEA
   and BENEFICIOS.BNF_COBERTURA = end_cobertura
   and BENEFICIOS.BNF_CAUSANTE = end_asegurado
   and BENEFICIOS.BNF_POLIZA = end_poliza
   and BENEFICIOS.BNF_PRODUCTO = end_producto
   AND BENEFICIOS.BNF_LINEA = end_linea
   AND BENEFICIOS.BNF_COBERTURA = COBERTURA.COB_CODIGO
   and beneficios.bnf_beneficiario = mod_ben 
   AND end_linea      = 3
    AND end_poliza    = 7849
   AND end_asegurado = 1238931
    AND mod_ben  = 1248913
   and end_nro_modif = 1925564
   /*and (end_estado <> 2 or end_estado is null)*/
   and PERSNAT_A.nat_id = end_asegurado
    and PERSNAT_b.nat_id = beneficios.bnf_beneficiario
  and PERSNAT_R.nat_id = grp_id_grupo  
   and end_nro_modif = mod_correl
   and mod_tipo_modif = ctm_tipo_modif
   and dbe_linea = end_linea
   and dbe_tipo_endoso = ctm_tipo_modif
   and dbe_numpoliza = end_poliza
   and dbe_id_benef = cep_nat
   and cep_tip=8 

select * from pensiones.persnat where nat_id=1422688

select * from pensiones.datos_ben where dbe_id_benef=1247339

/* nulidad fallecido */ 
  SELECT  end_asegurado, 
          SYSDATE Fecha,
          end_poliza,
         PERSNAT_A.nat_nomb persnat_nombre,
         persnat_a.nat_sexo,
         DOMICILIOS.DOM_DIRECCION domicilio,
         DOMICILIOS.DOM_COMUNA,
         DOMICILIOS.DOM_CIUDAD,
         
          PERSNAT_b.NAT_SEXO persnat_nat_sexo,   
          PERSNAT_b.NAT_EST_CIVIL persnat_nat_est_civil,   
          PERSNAT_b.NAT_FEC_NACIM,
          PERSNAT_B.NAT_NOMBRE || ' ' ||  PERSNAT_B.NAT_AP_PAT || ' ' || PERSNAT_B.NAT_AP_MAT nombre_ben,
          decode(PERSNAT_B.NAT_SEXO,'F','MHN','M','PHN','MHN o PHN') identificacambiomhnphn,
          
          end_cobertura ,
          COBERTURA.COB_DESCRIPCION,
          end_poliza ,
          end_linea ,
          persnat_a.nat_numrut || '-' || persnat_a.nat_dv rut , 
            mod_tipo_modif, 
         end_fec_vig ,
         decode(mod_cantidad_ant, 0, end_prima_ant, mod_cantidad_ant)  pns_ant,
         decode(mod_cantidad_nue,0, end_prima_nue, mod_cantidad_nue) pns_nva,
         nvl((decode(mod_cantidad_nue,0, end_prima_nue, mod_cantidad_nue) - decode(mod_cantidad_ant, 0, end_prima_ant, mod_cantidad_ant) ),0) diferencia,
	      case when mod_tipo_modif = 57 and mod_dig_ant <> 0 then 
         	to_date(  to_char(Substr(mod_dig_ant, 7, 2)||'/'|| Substr(mod_dig_ant, 5, 2)||'/'||Substr(mod_dig_ant, 1, 4)), 'dd/mm/yyyy') 
      	else 
      	  null end fec_ant, 
      	case when mod_tipo_modif = 57 and mod_dig_nue <> 0 then 
     			to_date(  to_char(Substr(mod_dig_nue , 7, 2)||'/'|| Substr(mod_dig_nue , 5, 2)||'/'||Substr(mod_dig_nue , 1, 4)), 'dd/mm/yyyy') 
     		else 
     		   null 
     		end fec_nva,
     		end_nro_endoso,
          case when mod_tipo_modif = 181
                then 'INGRESO DE NUEVO BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
				when mod_tipo_modif = 55 and mod_dig_ant = 4   and mod_dig_nue = 6 
		       then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
                  when mod_tipo_modif = 55
                then 'CAMBIO RELACI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 75 or mod_tipo_modif = 58 
                then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 57 
                then 'MODIFICA FECHA DE NACIMIENTO CAUSANTE/BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 59
                then 'MODIFICA SEXO CAUSANTE/BENEFICIARIO P�LIZA N� ' 
				 when mod_tipo_modif = 60
                then 'MODIFICA CONDICI�N INVALIDEZ P�LIZA N� '||to_char(end_poliza)  
			END tipo_endoso,
      (select decode(ben_invalido, 1,'Inv�lido total', 3, 'Inv�lido parcial', 'No inv�lido') 
       from pensiones.beneficiarios
       where ben_linea = bnf_linea 
             and ben_producto = bnf_producto 
             and ben_documento = bnf_documento 
             and ben_poliza = bnf_poliza 
             and ben_causante = bnf_causante 
             and ben_beneficiario = bnf_beneficiario ) t_inval,
       ( case Substr(end_periodo,5,2)
              
                when  '01' then 'Enero de '
                when '02' then 'Febrero de '
                when '03' then 'Marzo de '
                when '04' then 'Abril de '
                when '05' then 'Mayo de '
                when '06' then 'Junio de '
                when '07' then 'Julio de '
                when '08' then 'Agosto de '
                when '09' then 'Septiembre de '
                when '10' then 'Octubre de '
                when '11' then 'Noviembre de '
                when '12' then 'Diciembre de '
                else 'otro' end )
                || ' '  || 
                Substr(end_periodo,1,4) per_pago,
          ( case when mod_tipo_modif = 59 
             then  case when persnat_b.nat_sexo = 'F'
                   then  'Masculino'
                   else 'Femenino'
                  end
             else
               decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino')
             end) sexo_ant
             ,decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino') sexo_act
          ,PERSNAT_B.NAT_NOMBRE , PERSNAT_B.NAT_AP_PAT , PERSNAT_B.NAT_AP_MAT
			, mod_ben 
			, end_periodo
         , end_correl
         , (select cod_ext
            from asegafp,codigos 
            where asaf_afp = cod_int_num 
            and cod_template='TA02-AFP' 
            and asaf_poliza=7849) glosaafp
         , (select cod_ext 
			from pensiones.beneficiarios,
					pensiones.codigos 
			where ben_poliza = mod_poliza 
					 and ben_beneficiario=mod_ben
           			 and ben_relacion=cod_int_num 
					 and cod_template = 'TR07-RELACION-BENEFICIARIOS') tiporelacionbeneficiario
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_ant and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarioanterior
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_nue and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarionueva,
         dbe_fec_inf_cia,
         cep_fec_ini_vig
    FROM PERSNAT PERSNAT_A,
         PERSNAT PERSNAT_B,
         DOMICILIOS,
         GRUPOPAGO,
         BENEFICIOS,
         pensiones.endosos_bnl,
         pensiones.modificaciones_bnl,
         pensiones.catmod,
         COBERTURA,
         pensiones.datos_ben,
         pensiones.certper
   WHERE DOMICILIOS.DOM_ID_DOM = GRUPOPAGO.GRP_ID_DOM
   and GRUPOPAGO.GRP_GRUPO = 1 --BENEFICIOS.BNF_GRP_PAG
   and GRUPOPAGO.GRP_POLIZA = BENEFICIOS.BNF_POLIZA
   and GRUPOPAGO.GRP_PRODUCTO = BENEFICIOS.BNF_PRODUCTO
   and GRUPOPAGO.GRP_DOCUMENTO = BENEFICIOS.BNF_DOCUMENTO
   and GRUPOPAGO.GRP_LINEA = BENEFICIOS.BNF_LINEA
   and BENEFICIOS.BNF_COBERTURA = end_cobertura
   and BENEFICIOS.BNF_CAUSANTE = end_asegurado
   and BENEFICIOS.BNF_POLIZA = end_poliza
   and BENEFICIOS.BNF_PRODUCTO = end_producto
   AND BENEFICIOS.BNF_LINEA = end_linea
   AND BENEFICIOS.BNF_COBERTURA = COBERTURA.COB_CODIGO
   and beneficios.bnf_beneficiario = mod_ben
   AND end_linea      = 3
   AND end_poliza    = 7849
   AND end_asegurado = 1238931
   AND mod_ben  = 1248913
   and end_nro_modif = 1925564
   and PERSNAT_A.nat_id = end_asegurado
    and PERSNAT_b.nat_id = bnf_beneficiario
   and end_nro_modif = mod_correl
   and mod_tipo_modif = ctm_tipo_modif
   and dbe_numpoliza = end_poliza
   and dbe_id_benef = cep_nat
   and cep_tip=8 


/* cambio edo civil hijo fallecido */

select end_asegurado,
       SYSDATE Fecha,
       end_poliza,
       
       PERSNAT_A.nat_nomb persnat_nombre,
       persnat_a.nat_sexo,
       DOMICILIOS.DOM_DIRECCION domicilio,
       DOMICILIOS.DOM_COMUNA,
       DOMICILIOS.DOM_CIUDAD,
       
          PERSNAT_b.NAT_SEXO persnat_nat_sexo,   
          PERSNAT_b.NAT_EST_CIVIL persnat_nat_est_civil,   
          PERSNAT_b.NAT_FEC_NACIM,
          PERSNAT_B.NAT_NOMBRE || ' ' ||  PERSNAT_B.NAT_AP_PAT || ' ' || PERSNAT_B.NAT_AP_MAT nombre_ben,
          decode(PERSNAT_B.NAT_SEXO,'F','MHN','M','PHN','MHN o PHN') identificacambiomhnphn,
          
          end_cobertura ,
          COBERTURA.COB_DESCRIPCION,
          end_poliza ,
          end_linea ,
          persnat_a.nat_numrut || '-' || persnat_a.nat_dv rut , 
            mod_tipo_modif, 
         end_fec_vig ,
         decode(mod_cantidad_ant, 0, end_prima_ant, mod_cantidad_ant)  pns_ant,
         decode(mod_cantidad_nue,0, end_prima_nue, mod_cantidad_nue) pns_nva,
         nvl((decode(mod_cantidad_nue,0, end_prima_nue, mod_cantidad_nue) - decode(mod_cantidad_ant, 0, end_prima_ant, mod_cantidad_ant) ),0) diferencia,
	      case when mod_tipo_modif = 57 and mod_dig_ant <> 0 then 
         	to_date(  to_char(Substr(mod_dig_ant, 7, 2)||'/'|| Substr(mod_dig_ant, 5, 2)||'/'||Substr(mod_dig_ant, 1, 4)), 'dd/mm/yyyy') 
      	else 
      	  null end fec_ant, 
      	case when mod_tipo_modif = 57 and mod_dig_nue <> 0 then 
     			to_date(  to_char(Substr(mod_dig_nue , 7, 2)||'/'|| Substr(mod_dig_nue , 5, 2)||'/'||Substr(mod_dig_nue , 1, 4)), 'dd/mm/yyyy') 
     		else 
     		   null 
     		end fec_nva,
     		end_nro_endoso,
          case when mod_tipo_modif = 181
                then 'INGRESO DE NUEVO BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
				when mod_tipo_modif = 55 and mod_dig_ant = 4   and mod_dig_nue = 6 
		       then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
                  when mod_tipo_modif = 55
                then 'CAMBIO RELACI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 75 or mod_tipo_modif = 58 
                then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 57 
                then 'MODIFICA FECHA DE NACIMIENTO CAUSANTE/BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 59
                then 'MODIFICA SEXO CAUSANTE/BENEFICIARIO P�LIZA N� ' 
				 when mod_tipo_modif = 60
                then 'MODIFICA CONDICI�N INVALIDEZ P�LIZA N� '||to_char(end_poliza)  
			END tipo_endoso,
      (select decode(ben_invalido, 1,'Inv�lido total', 3, 'Inv�lido parcial', 'No inv�lido') 
       from pensiones.beneficiarios
       where ben_linea = bnf_linea 
             and ben_producto = bnf_producto 
             and ben_documento = bnf_documento 
             and ben_poliza = bnf_poliza 
             and ben_causante = bnf_causante 
             and ben_beneficiario = bnf_beneficiario ) t_inval,
       ( case Substr(end_periodo,5,2)
              
                when  '01' then 'Enero de '
                when '02' then 'Febrero de '
                when '03' then 'Marzo de '
                when '04' then 'Abril de '
                when '05' then 'Mayo de '
                when '06' then 'Junio de '
                when '07' then 'Julio de '
                when '08' then 'Agosto de '
                when '09' then 'Septiembre de '
                when '10' then 'Octubre de '
                when '11' then 'Noviembre de '
                when '12' then 'Diciembre de '
                else 'otro' end )
                || ' '  || 
                Substr(end_periodo,1,4) per_pago,
          ( case when mod_tipo_modif = 59 
             then  case when persnat_b.nat_sexo = 'F'
                   then  'Masculino'
                   else 'Femenino'
                  end
             else
               decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino')
             end) sexo_ant
             ,decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino') sexo_act
          ,PERSNAT_B.NAT_NOMBRE , PERSNAT_B.NAT_AP_PAT , PERSNAT_B.NAT_AP_MAT
			, mod_ben 
			, end_periodo
         , end_correl
         , (select cod_ext
            from asegafp,codigos 
            where asaf_afp = cod_int_num 
            and cod_template='TA02-AFP' 
            and asaf_poliza=7849) glosaafp
         , (select cod_ext 
			from pensiones.beneficiarios,
					pensiones.codigos 
			where ben_poliza = mod_poliza 
					 and ben_beneficiario=mod_ben
           			 and ben_relacion=cod_int_num 
					 and cod_template = 'TR07-RELACION-BENEFICIARIOS') tiporelacionbeneficiario
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_ant and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarioanterior
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_nue and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarionueva,
         dbe_fec_inf_cia,
         nat_fec_matr_fc
from PERSNAT PERSNAT_A,
     PERSNAT PERSNAT_B,
     DOMICILIOS,
     GRUPOPAGO,
     BENEFICIOS,
     pensiones.endosos_bnl,
     pensiones.modificaciones_bnl,
     pensiones.catmod,
     COBERTURA,
     pensiones.datos_ben     
where DOMICILIOS.DOM_ID_DOM = GRUPOPAGO.GRP_ID_DOM
   and GRUPOPAGO.GRP_GRUPO = 0 --BENEFICIOS.BNF_GRP_PAG
   and GRUPOPAGO.GRP_POLIZA = BENEFICIOS.BNF_POLIZA
   and GRUPOPAGO.GRP_PRODUCTO = BENEFICIOS.BNF_PRODUCTO
   and GRUPOPAGO.GRP_DOCUMENTO = BENEFICIOS.BNF_DOCUMENTO
   and GRUPOPAGO.GRP_LINEA = BENEFICIOS.BNF_LINEA
   and BENEFICIOS.BNF_COBERTURA = end_cobertura
   and BENEFICIOS.BNF_CAUSANTE = end_asegurado
   and BENEFICIOS.BNF_POLIZA = end_poliza
   and BENEFICIOS.BNF_PRODUCTO = end_producto
   AND BENEFICIOS.BNF_LINEA = end_linea
   AND BENEFICIOS.BNF_COBERTURA = COBERTURA.COB_CODIGO
   and beneficios.bnf_beneficiario = mod_ben
   AND end_linea      = 3
   AND end_poliza    = 610349
   AND end_asegurado = 1005876
   AND mod_ben  = 1118150
   and end_nro_modif = 1925616
   and PERSNAT_A.nat_id = end_asegurado
   and PERSNAT_b.nat_id = bnf_beneficiario
   and end_nro_modif = mod_correl
   and mod_tipo_modif = ctm_tipo_modif
   and dbe_numpoliza = end_poliza
   
/*
select * from domicilios where dom_persona=1005876--dom_id_dom=2070572
select * from grupopago where grp_poliza=610349 --update grupopago set grp_grupo=1 where grp_poliza=610349
SELECT * FROM ENDOSOS_BNL WHERE END_POLIZA=610349
select bnf_beneficiario,BNF_LINEA,BNF_PRODUCTO,BNF_DOCUMENTO,BNF_POLIZA,BNF_CAUSANTE,BNF_COBERTURA,bnf_grp_pag from pensiones.BENEFICIOS where BNF_POLIZA=610349;
select * from pensiones.beneficiarios where ben_poliza=610349 AND BEN_EST_CIVIL=1;
SELECT * FROM MODIFICACIONES_BNL WHERE MOD_POLIZA=610349
SELECT * FROM PERSNAT WHERE NAT_ID=1118150


* cambia fecha de matrimonio del hijo
update persnat set nat_fec_matr_fc=null where nat_id=1118150
SELECT * FROM COBERTURA
select * from pensiones.catmod where ctm_tipo_modif=58
select * from 
*/   

/*****   vivos ***************

1.- CASO INCORPORACION NUEVO BENEFICIARIO 5274010
2.- CASO INCORPORACION CONYUGE POSTPOLIZA 607314 */

  SELECT  end_asegurado, 
          SYSDATE Fecha,
          end_poliza,
         PERSNAT_A.nat_nomb persnat_nombre,
         DOMICILIOS.DOM_DIRECCION domicilio,
         DOMICILIOS.DOM_COMUNA,
         DOMICILIOS.DOM_CIUDAD,
         
          PERSNAT_b.NAT_SEXO persnat_nat_sexo,   
          PERSNAT_A.NAT_EST_CIVIL persnat_nat_est_civil,   
          PERSNAT_A.NAT_FEC_NACIM,
          PERSNAT_B.NAT_NOMBRE || ' ' ||  PERSNAT_B.NAT_AP_PAT || ' ' || PERSNAT_B.NAT_AP_MAT nombre_ben,
          decode(PERSNAT_B.NAT_SEXO,'F','MHN','M','PHN','MHN o PHN') identificacambiomhnphn,
          end_cobertura ,
          COBERTURA.COB_DESCRIPCION,
          end_poliza ,
          end_linea ,
          persnat_a.nat_numrut || '-' || persnat_a.nat_dv rut , 
            mod_tipo_modif, 
         end_fec_vig ,
         mod_cantidad_ant pns_ant,
         mod_cantidad_nue pns_nva,
	      case when mod_tipo_modif = 57 and mod_dig_ant <> 0 then 
         	to_date(  to_char(Substr(mod_dig_ant, 7, 2)||'/'|| Substr(mod_dig_ant, 5, 2)||'/'||Substr(mod_dig_ant, 1, 4)), 'dd/mm/yyyy') 
      	else 
      	  null end fec_ant, 
      	case when mod_tipo_modif = 57 and mod_dig_nue <> 0 then 
     			to_date(  to_char(Substr(mod_dig_nue , 7, 2)||'/'|| Substr(mod_dig_nue , 5, 2)||'/'||Substr(mod_dig_nue , 1, 4)), 'dd/mm/yyyy') 
     		else 
     		   null 
     		end fec_nva,
     		end_nro_endoso,
          case when mod_tipo_modif = 181
                then 'INGRESO DE NUEVO BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
             when mod_tipo_modif = 55
                then 'CAMBIO RELACI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 75 or mod_tipo_modif = 58 
                then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 57 
                then 'MODIFICA FECHA DE NACIMIENTO CAUSANTE/BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
				 when mod_tipo_modif = 59
                then 'MODIFICA SEXO CAUSANTE/BENEFICIARIO P�LIZA N� '||to_char(end_poliza) 
				 when mod_tipo_modif = 60
                then 'MODIFICA CONDICI�N INVALIDEZ P�LIZA N� '||to_char(end_poliza)  
			END tipo_endoso,
      (select decode(ben_invalido, 1,'Inv�lido total', 3, 'Inv�lido parcial', 'No inv�lido') 
       from pensiones.beneficiarios
       where ben_linea = bnf_linea 
             and ben_producto = bnf_producto 
             and ben_documento = bnf_documento 
             and ben_poliza = bnf_poliza 
             and ben_causante = bnf_causante 
             and ben_beneficiario = bnf_beneficiario ) t_inval,
       ( case Substr(end_periodo,5,2)
              
                when  '01' then 'Enero de '
                when '02' then 'Febrero de '
                when '03' then 'Marzo de '
                when '04' then 'Abril de '
                when '05' then 'Mayo de '
                when '06' then 'Junio de '
                when '07' then 'Julio de '
                when '08' then 'Agosto de '
                when '09' then 'Septiembre de '
                when '10' then 'Octubre de '
                when '11' then 'Noviembre de '
                when '12' then 'Diciembre de '
                else 'otro' end )
                || ' '  || 
                Substr(end_periodo,1,4) per_pago,
          ( case when mod_tipo_modif = 59 
             then  case when persnat_b.nat_sexo = 'F'
                   then  'Masculino'
                   else 'Femenino'
                  end
             else
               decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino')
             end) sexo_ant
             ,decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino') sexo_act
          ,PERSNAT_B.NAT_NOMBRE , PERSNAT_B.NAT_AP_PAT , PERSNAT_B.NAT_AP_MAT
			, mod_ben 
			, end_periodo
         , end_correl
         , (select cod_ext
            from asegafp,codigos 
            where asaf_afp = cod_int_num 
            and cod_template='TA02-AFP' 
            and asaf_poliza=607314) glosaafp
          , (select cod_ext from pensiones.beneficiarios,pensiones.codigos 
           where ben_linea = mod_linea 
                 and ben_producto = mod_producto  
                 and ben_documento = mod_documento 
                 and ben_poliza = mod_poliza 
                 and ben_causante = mod_asegurado 
                 and ben_beneficiario=mod_ben
                 and ben_relacion=cod_int_num 
                 and cod_template = 'TR07-RELACION-BENEFICIARIOS') tiporelacionbeneficiario
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_ant and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarioanterior
         , (select cod_ext from codigos where 
            cod_int_num=mod_dig_nue and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarionueva
			
            , PERSNAT_R.nat_nomb  nombre_envio
		  , (select nvl((dpo_pns_ref_nva - dpo_pns_ref_act  ),0)
      from pensiones.datos_pol 
      where dpo_linea = mod_linea 
          and dpo_producto = mod_producto
          and dpo_documento = mod_documento
          and dpo_numpoliza =mod_poliza
          and dpo_id_causante =mod_asegurado
          and dpo_cobertura = mod_cobertura
          and dpo_periodo = mod_periodo)   diferencia,
			   nvl((select cod_ext
   from pensiones.beneficiarios, 
        pensiones.codigos 
   where ben_relacion = cod_int_num
         and cod_template= 'TR07-RELACION-BENEFICIARIOS'
         and ben_linea = bnf_linea 
         and ben_producto = bnf_producto 
         and ben_documento = bnf_documento 
         and ben_poliza = bnf_poliza 
         and ben_causante = bnf_causante 
         and ben_beneficiario = bnf_beneficiario 
         and ben_relacion <> 9  )  , '')  relacion,
         (select max(dbe_fec_inf_cia) dbe_fec_inf_cia from pensiones.datos_ben where dbe_numpoliza=527410) dbe_fec_inf_cia, 
         --persnat_b.nat_fec_matr_fc
         (SELECT DECODE(NVL(NAT_FEC_MATR_FC,''),'',
           (select CEP_FEC_INI_VIG from pensiones.certper where cep_nat=1072185 and cep_tip=2), NAT_FEC_MATR_FC)
          FROM PERSNAT PERSNAT_B
          WHERE PERSNAT_B.NAT_ID=1072185) nat_fec_matr_fc

    FROM PERSNAT PERSNAT_A,
    PERSNAT PERSNAT_B,
	PERSNAT PERSNAT_R,
         DOMICILIOS,
         GRUPOPAGO,
         BENEFICIOS,
         pensiones.endosos_bnl,
         pensiones.modificaciones_bnl,
         pensiones.catmod,
         COBERTURA
   WHERE DOMICILIOS.DOM_ID_DOM = GRUPOPAGO.GRP_ID_DOM
   and GRUPOPAGO.GRP_GRUPO = 0 --BENEFICIOS.BNF_GRP_PAG
   and GRUPOPAGO.GRP_POLIZA = BENEFICIOS.BNF_POLIZA
   and GRUPOPAGO.GRP_PRODUCTO = BENEFICIOS.BNF_PRODUCTO
   and GRUPOPAGO.GRP_DOCUMENTO = BENEFICIOS.BNF_DOCUMENTO
   and GRUPOPAGO.GRP_LINEA = BENEFICIOS.BNF_LINEA
   and BENEFICIOS.BNF_COBERTURA = end_cobertura
   and BENEFICIOS.BNF_CAUSANTE = end_asegurado
   and BENEFICIOS.BNF_POLIZA = end_poliza
   and BENEFICIOS.BNF_PRODUCTO = end_producto
   AND BENEFICIOS.BNF_LINEA = end_linea
   AND BENEFICIOS.BNF_COBERTURA = COBERTURA.COB_CODIGO
   and beneficios.bnf_beneficiario = mod_ben 
   AND end_linea      = 3
    AND end_poliza    = 607314
   AND end_asegurado = 1015152
    AND mod_ben  = 1072185
   and end_nro_modif = 1925449 
   /*and (end_estado <> 2 or end_estado is null)*/
   and PERSNAT_A.nat_id = end_asegurado
    and PERSNAT_b.nat_id = beneficios.bnf_beneficiario
	and PERSNAT_R.nat_id = grp_id_grupo	
   and end_nro_modif = mod_correl
   and mod_tipo_modif = ctm_tipo_modif
   

/*
3.- CASO DIVORCIO O NULIDAD DE MATRIMONIO DEL AFILIADO CAUSANTE */

  SELECT end_asegurado,
       SYSDATE Fecha,
       end_poliza,
       PERSNAT_A.nat_nomb persnat_nombre,
       DOMICILIOS.DOM_DIRECCION domicilio,
       DOMICILIOS.DOM_COMUNA,
       DOMICILIOS.DOM_CIUDAD,
       
       PERSNAT_A.NAT_SEXO persnat_nat_sexo,
       PERSNAT_A.NAT_EST_CIVIL persnat_nat_est_civil,
       PERSNAT_A.NAT_FEC_NACIM,
       PERSNAT_B.NAT_NOMBRE || ' ' || PERSNAT_B.NAT_AP_PAT || ' ' ||
       PERSNAT_B.NAT_AP_MAT nombre_ben,
       end_cobertura,
       COBERTURA.COB_DESCRIPCION,
       end_poliza,
       end_linea,
       persnat_a.nat_numrut || '-' || persnat_a.nat_dv rut,
       mod_tipo_modif,
       end_fec_vig,
       mod_cantidad_ant pns_ant,
       mod_cantidad_nue pns_nva,
       case
         when mod_tipo_modif = 57 and mod_dig_ant <> 0 then
          to_date(to_char(Substr(mod_dig_ant, 7, 2) || '/' ||
                          Substr(mod_dig_ant, 5, 2) || '/' ||
                          Substr(mod_dig_ant, 1, 4)),'dd/mm/yyyy')
         else
          null
       end fec_ant,
       case
         when mod_tipo_modif = 57 and mod_dig_nue <> 0 then
          to_date(to_char(Substr(mod_dig_nue, 7, 2) || '/' ||
                          Substr(mod_dig_nue, 5, 2) || '/' ||
                          Substr(mod_dig_nue, 1, 4)),'dd/mm/yyyy')
         else
          null
       end fec_nva,
       end_nro_endoso,
       case
         when mod_tipo_modif = 181 then
          'INGRESO DE NUEVO BENEFICIARIO P�LIZA N� ' || to_char(end_poliza)
		 when mod_tipo_modif = 55 and bnf_estado = 1  
		then 'REMOCI�N DE BENEFICIARIO P�LIZA N� '||to_char(end_poliza)  
         when mod_tipo_modif = 55 then
          'REMOCI�N DE BENEFICIARIO P�LIZA N� ' || to_char(end_poliza)
         when mod_tipo_modif = 75 or mod_tipo_modif = 58 then
          'REMOCI�N DE BENEFICIARIO P�LIZA N� ' || to_char(end_poliza)
         when mod_tipo_modif = 57 then
          'MODIFICA FECHA DE NACIMIENTO CAUSANTE/BENEFICIARIO P�LIZA N� ' ||
          to_char(end_poliza)
         when mod_tipo_modif = 59 then
          'MODIFICA SEXO CAUSANTE/BENEFICIARIO P�LIZA N� '
         when mod_tipo_modif = 60 then
          'MODIFICA CONDICI�N INVALIDEZ P�LIZA N� ' || to_char(end_poliza)
       END tipo_endoso,
       (select decode(ben_invalido,
                      1,
                      'Inv�lido total',
                      3,
                      'Inv�lido parcial',
                      'No inv�lido')
         from pensiones.beneficiarios
         where ben_linea = bnf_linea
           and ben_producto = bnf_producto
           and ben_documento = bnf_documento
           and ben_poliza = bnf_poliza
           and ben_causante = bnf_causante
           and ben_beneficiario = bnf_beneficiario) t_inval,
       (case Substr(end_periodo, 5, 2)
       
         when '01' then
          'Enero de '
         when '02' then
          'Febrero de '
         when '03' then
          'Marzo de '
         when '04' then
          'Abril de '
         when '05' then
          'Mayo de '
         when '06' then
          'Junio de '
         when '07' then
          'Julio de '
         when '08' then
          'Agosto de '
         when '09' then
          'Septiembre de '
         when '10' then
          'Octubre de '
         when '11' then
          'Noviembre de '
         when '12' then
          'Diciembre de '
         else
          'otro'
       end) || ' ' || Substr(end_periodo, 1, 4) per_pago,
       (case
         when mod_tipo_modif = 59 then
          case
            when persnat_b.nat_sexo = 'F' then
             'Masculino'
            else
             'Femenino'
          end
         else
          decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino')
       end) sexo_ant,
       decode(persnat_b.nat_sexo, 'F', 'Femenino', 'Masculino') sexo_act,
		 
       PERSNAT_B.NAT_NOMBRE,
       PERSNAT_B.NAT_AP_PAT,
       PERSNAT_B.NAT_AP_MAT,
       mod_ben,
       end_periodo,
       end_correl,
       (select cod_ext
          from pensiones.asegafp, 
               pensiones.codigos
         where asaf_afp = cod_int_num
           and cod_template = 'TA02-AFP'
           and asaf_linea = grp_linea
           and asaf_producto = grp_producto
           and asaf_documento = grp_documento
           and asaf_poliza = grp_poliza
           and asaf_asegurado = grp_asegurado) glosaafp,
       (select cod_ext
          from beneficiarios, codigos
         where ben_beneficiario = mod_ben
		   and ben_poliza = mod_poliza 
           and ben_relacion = cod_int_num
           and cod_template = 'TR07-RELACION-BENEFICIARIOS') tiporelacionbeneficiario,
       (select cod_ext
          from codigos
         where cod_int_num = mod_dig_ant
           and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarioanterior,
       (select cod_ext
          from codigos
         where cod_int_num = mod_dig_nue
           and cod_template = 'TR07-RELACION-BENEFICIARIOS') relacionbeneficiarionueva
     , (select  nvl( (dpo_pns_ref_nva - dpo_pns_ref_act),0)
      from pensiones.datos_pol 
      where dpo_linea = mod_linea 
          and dpo_producto = mod_producto
          and dpo_documento = mod_documento
          and dpo_numpoliza =mod_poliza
          and dpo_id_causante =mod_asegurado
          and dpo_cobertura = mod_cobertura
          and dpo_periodo = mod_periodo)   diferencia,
      dbe_fec_inf_cia, cep_fec_ini_vig
  from pensiones.persnat            persnat_a,
       pensiones.persnat            persnat_b,
       pensiones.domicilios,
       pensiones.grupopago,
       pensiones.beneficios,
       pensiones.endosos_bnl,
       pensiones.modificaciones_bnl,
       pensiones.catmod,
       pensiones.cobertura,
       pensiones.datos_ben,
       pensiones.certper
 where domicilios.dom_id_dom = grupopago.grp_id_dom
   and grupopago.grp_grupo = 0 --beneficios.bnf_grp_pag
   and grupopago.grp_linea = beneficios.bnf_linea
   and grupopago.grp_producto = beneficios.bnf_producto
   and grupopago.grp_documento = beneficios.bnf_documento
   and grupopago.grp_poliza = beneficios.bnf_poliza
   and grupopago.grp_asegurado = beneficios.bnf_causante
   and beneficios.bnf_cobertura = end_cobertura
   and beneficios.bnf_linea = end_linea
   and beneficios.bnf_producto = end_producto
   and beneficios.bnf_documento = end_documento
   and beneficios.bnf_poliza = end_poliza
   and beneficios.bnf_causante = end_asegurado
   and beneficios.bnf_cobertura = cobertura.cob_codigo
   and beneficios.bnf_beneficiario = mod_ben
   and end_linea      = 3
   and end_poliza = 535392
   and end_asegurado = 1428246
   and mod_ben =  1428249
   and end_nro_modif =  1925486
   and mod_linea = end_linea
   and mod_producto = end_producto
   and mod_documento = end_documento
   and mod_poliza = end_poliza
   and mod_asegurado = end_asegurado
  /* and (end_estado <> 2 or end_estado is null) */
   and persnat_a.nat_id = end_asegurado
   and persnat_b.nat_id = bnf_beneficiario
   and mod_correl = end_nro_modif  
   and mod_tipo_modif = ctm_tipo_modif
   and dbe_numpoliza = end_poliza
   and dbe_id_benef = cep_nat
   and cep_tip=10

/* 4.- MATRIMONIO DE UN HIJO BENEFICIARIO DE PENSION */

