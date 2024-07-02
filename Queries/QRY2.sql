SELECT  end_poliza,
         PERSNAT_A.nat_numrut ||'-'||PERSNAT_A.nat_dv rut_tit ,
         PERSNAT_A.nat_nomb persnat_nombre,
         (case when BNF_COBERTURA <> 1 then 
               COBERTURA.COB_DESCRIPCION
         else
            (case when (select cob_descripcion 
                         from   pensiones.cobertura
                         where cob_codigo =   (select max(sin_tipo)
                         from pensiones.siniestros
                         where sin_linea = pol_linea 
                               and sin_producto = pol_producto 
                               and sin_documento = pol_documento 
                               and sin_poliza = pol_poliza 
                               and sin_id =  pol_contratante)) <> 'Sobrevivencia'
                    then 
                        COBERTURA.COB_DESCRIPCION ||' de ' || (select cob_descripcion 
                         from   pensiones.cobertura
                         where cob_codigo =   (select max(sin_tipo)
                         from pensiones.siniestros
                         where sin_linea = pol_linea 
                               and sin_producto = pol_producto 
                               and sin_documento = pol_documento 
                               and sin_poliza = pol_poliza 
                               and sin_id =  pol_contratante ))
                     else
                       'Sobrevivencia' end )
                       end ) tp_pens,   
          pol_fec_inicio  ,
          'UF ' || (select dpo_pns_ref_act
                 from pensiones.datos_pol 
                 where dpo_linea = dbe_linea 
                       and dpo_producto = dbe_producto 
                       and dpo_documento =dbe_documento 
                       and dpo_numpoliza =dbe_numpoliza 
                       and dpo_id_causante =dbe_id_causante 
                       and dpo_cobertura =dbe_cobertura 
                       and dpo_periodo = dbe_periodo )   ref_act, 
/*    case when mod_tipo_modif = 181
                then 'INGRESO DE NUEVO BENEFICIARIO'
             when mod_tipo_modif = 55
                then 'CAMBIO RELACIÓN DE BENEFICIARIO'
         when mod_tipo_modif = 75 or mod_tipo_modif = 58 
                then 'REMOCIÓN DE BENEFICIARIO'
         when mod_tipo_modif = 57 
                then 'MODIFICA FECHA DE NACIMIENTO CAUSANTE/BENEFICIARIO'  
         when mod_tipo_modif = 59
                then 'MODIFICA SEXO CAUSANTE/BENEFICIARIO'
         when mod_tipo_modif = 60
                then 'MODIFICA CONDICIÓN INVALIDEZ'  
      END */
      /*case when cod_int_char = 'GP' then 
         'Incorporación Beneficiario No Declarado'
        else    cod_ext end*/pensiones.catmod.CTM_DESCRIPCION ipo_endoso, cod_ext, 
      PERSNAT_B.nat_numrut ||'-'|| PERSNAT_B.nat_dv rut_ben, 
                PERSNAT_B.NAT_NOMBRE || ' ' ||  PERSNAT_B.NAT_AP_PAT || ' ' || PERSNAT_B.NAT_AP_MAT nombre_ben,
              PERSNAT_b.nat_fec_nacim fec_nacim ,          
          PERSNAT_b.nat_fec_matr_fc fec_matri,
      case when  ben_relacion <> 3 and  ben_relacion <> 5 then 
            decode(f_hijos_exis(pol_linea, pol_poliza,pol_contratante, pol_producto, to_char(sysdate, 'yyyymm')), 0, 'No', 'Si') 
        else '' end  
       hijos_comun, 

       (select cod_ext 
        from pensiones.codigos 
        where F_datos_endosos(mod_poliza  , mod_ben  , 1 ) = cod_int_num
              and cod_template = 'TR11-RELACION-RIS') tiporelacionbeneficiario,

        mod_fec_exofi fec_extraof,
        
        case when mod_fec_afp = to_date('01/01/1900', 'dd/mm/yyyy')  or mod_fec_afp =  null 
              then   ' ' 
              else to_char(mod_fec_afp, 'dd/mm/yyyy') end  fec_afp,
         case when mod_fec_cia = to_date('01/01/1900', 'dd/mm/yyyy')  or mod_fec_cia =  null 
              then   ' ' 
              else to_char(mod_fec_cia, 'dd/mm/yyyy') end    fec_cia, 
        PERSNAT_a.nat_fec_muerte fec_muerte
      ,DECODE(NVL(POL_PORC_RE,0), 0,'NO', 'SI')     ES_ESCALONADA
      ,DECODE(NVL(POL_PORC_RE,0), 0,NULL, TO_CHAR(pensiones.pkg_renta_escalonada.f_calc_fin_renta(POL_FEC_INICIO, POL_MESES_RE),'DD/MM/YYYY')) FEC_TERM_ESCALONADA
    FROM pensiones.polizas, 
         pensiones.asegafp,
         pensiones.BENEFICIOS,
       pensiones.beneficiarios,
         pensiones.PERSNAT PERSNAT_A,
         pensiones.PERSNAT PERSNAT_B,
         pensiones.endosos,
         pensiones.modificaciones,
         pensiones.catmod,
         pensiones.COBERTURA,
         pensiones.datos_ben,
         pensiones.codigos 
 WHERE pol_linea = asaf_linea 
         and pol_producto = asaf_producto 
         and pol_documento  = asaf_documento 
         and pol_poliza = asaf_poliza 
         and pol_contratante = asaf_asegurado 
         
         and asaf_linea = BENEFICIOS.BNF_LINEA 
         and asaf_producto = BENEFICIOS.BNF_PRODUCTO
         and asaf_documento =BENEFICIOS.BNF_DOCUMENTO
         and asaf_poliza =BENEFICIOS.BNF_POLIZA
         and asaf_asegurado = BENEFICIOS.BNF_CAUSANTE

        and BENEFICIOS.BNF_LINEA = BEN_LINEA
         and BENEFICIOS.BNF_PRODUCTO = BEN_PRODUCTO
         and BENEFICIOS.BNF_DOCUMENTO = BEN_DOCUMENTO
         and BENEFICIOS.BNF_POLIZA = BNF_POLIZA
         and BENEFICIOS.BNF_CAUSANTE = BEN_CAUSANTE
         and beneficios.bnf_beneficiario = ben_beneficiario 
         
         and BENEFICIOS.BNF_LINEA = end_linea
         and BENEFICIOS.BNF_PRODUCTO = end_producto
         and BENEFICIOS.BNF_DOCUMENTO = end_documento
         and BENEFICIOS.BNF_POLIZA = end_poliza
         and BENEFICIOS.BNF_CAUSANTE = end_asegurado
         and BENEFICIOS.BNF_COBERTURA = end_cobertura
         and beneficios.bnf_beneficiario = mod_ben 
         
         AND BENEFICIOS.BNF_COBERTURA = COBERTURA.COB_CODIGO

         AND end_linea      =3
         and PERSNAT_A.nat_id = end_asegurado
         and PERSNAT_b.nat_id = beneficios.bnf_beneficiario
         and end_nro_modif = mod_correl
         and mod_tipo_modif = ctm_tipo_modif
       
         and end_periodo = 202311

        and dbe_linea =  mod_linea 
         and dbe_producto = mod_producto 
         and dbe_documento = mod_documento 
         and dbe_numpoliza = mod_poliza 
         and dbe_id_causante = mod_asegurado 
         and dbe_cobertura = mod_cobertura 
         and dbe_id_benef = mod_ben 
         and dbe_periodo =  mod_periodo 
         and dbe_ind_vtna_endoso = cod_int_char
         and cod_template = 'VENTANA-ENDOSO'
         and mod_tipo_modif =  dbe_tipo_endoso 
