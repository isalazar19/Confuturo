/* LISTADO EMISION CARTAS DE ENDOSOs */
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
  from pensiones.endosos_bnl,
       pensiones.modificaciones_bnl  ,
       pensiones.beneficios,
       pensiones.beneficiarios,
       pensiones.persnat,
       pensiones.catmod,
       pensiones.codigos
       
 where  (((end_estado <> 2 or end_estado is null) and 1 = 1 ) or (end_estado =  2 and 2 = 1))
   and end_periodo = 202312
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
   and mod_ben = bnf_beneficiario 
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
 
/* 

select * from pensiones.polizas where pol_poliza=7849
select * from pensiones.endosos_bnl where end_poliza=534866

select * from pensiones.beneficiarios where ben_poliza=7849 and ben_beneficiario=1248912
select * from persnat where nat_id=1248912

select * from pensiones.catmod

*fecha del divorcio*
select * from pensiones.certper where cep_nat=1247339 and cep_tip=10

*fecha nulidad matrimonio
select * from pensiones.certper where cep_nat=1248913 

*fecha matrimonio
select * from pensiones.certper where cep_nat=1072185 and cep_tip=2

select * from datos_ben where dbe_numpoliza=7849

update pensiones.endosos_bnl set end_estado=null where end_poliza=534866 and end_periodo=202310
 
 select mod_linea,mod_producto,mod_documento,mod_poliza,mod_asegurado,mod_cobertura,mod_ben,mod_periodo,mod_tipo_modif from pensiones.modificaciones where mod_correl=2267276;


* hijo cuando se casa
select * from pensiones.persnat where nat_est_civil=1
******************************************
* CAMBIAR FECHA, COBERTURA DE UNA POLIZA *
******************************************
TABLAS:
ENDOSOS, ENDODOS_BNL, MODIFICACIONES_BNL

select * from pensiones.endosos where end_poliza=678439
update pensiones.endosos
set end_periodo=202310, end_fec_vig=TO_DATE('2023/10/01', 'yyyy/mm/dd'), end_cobertura=1
where end_poliza=678439 and end_correl=2267278

* solo si hay que cambiar la cobertura
select * from pensiones.beneficios where bnf_poliza=678439
update pensiones.beneficios set bnf_cobertura=8 where bnf_poliza=678439

select * from endosos_bnl where end_poliza=678439
update pensiones.endosos_bnl
set end_periodo=202310, end_fec_vig=TO_DATE('2023/10/01', 'yyyy/mm/dd'), end_cobertura=1
where end_poliza=678439 and end_correl=1955620

select * from modificaciones_bnl where mod_poliza=678439
update pensiones.modificaciones_bnl
set mod_periodo=202310, mod_fec_vig=TO_DATE('2023/10/01', 'yyyy/mm/dd'), mod_cobertura=1
where mod_poliza=678439 and mod_correl=1925617

****************************************
* ver asegurado y beneficiarios
select * from pensiones.endosos_bnl where end_poliza=622564 

select * from beneficiarios where ben_poliza=622564 

select ben_poliza,nat_id,nat_numrut||'-'||nat_dv, nat_nombre, nat_ap_pat, nat_ap_mat, nat_fec_nacim,nat_est_civil, 
(select cod_ext from pensiones.codigos
where cod_template LIKE 'TE01-ESTADOS-CIVILES%' and cod_int_num=nat_est_civil
) , ben_relacion ,
(select cod_ext from pensiones.codigos 
where cod_template like 'TR07_RELACION_BENEFICIARIOS%' and cod_int_num=ben_relacion
), nat_fec_muerte, nat_fec_matr_fc
from persnat, pensiones.beneficiarios
where ben_beneficiario=nat_id
and nat_id in (select ben_beneficiario from pensiones.beneficiarios where ben_poliza=622564 )

********************************************************
para ver polizas  con hijos solteros y cambiar edo civil
********************************************************
select * from pensiones.modificaciones_bnl tbl1, pensiones.beneficiarios
where tbl1.mod_cobertura in (2,8)
and not exists (select 1 from pensiones.modificaciones_bnl tbl2 where tbl2.mod_poliza=tbl1.mod_poliza and tbl2.mod_cobertura=1)
and tbl1.mod_asegurado=ben_causante
and ben_relacion=3
order by mod_poliza DESC

select * from pensiones.modificaciones_bnl where mod_poliza=678490


select * from pensiones.endosos_bnl where end_poliza = 678439 and end_periodo=202310
update pensiones.endosos_bnl set end_cobertura=8 where end_poliza = 678439 and end_periodo=202310

select * from pensiones.endosos where end_poliza = 678439 and end_periodo=202310
update pensiones.endosos_bnl set end_cobertura=8 where end_poliza = 678439 and end_periodo=202310

select * from pensiones.modificaciones_bnl where mod_poliza =678439 and mod_periodo=202310
update pensiones.modificaciones_bnl set mod_cobertura=8 where mod_poliza = 678439 and mod_periodo=202310

select * from pensiones.beneficios where bnf_causante=1478714 and bnf_beneficiario=1478716
select * from pensiones.beneficiarios where ben_causante=1478714 and ben_beneficiario=1478716
select * from pensiones.persnat where nat_id=1478714
select * from pensiones.catmod where ctm_tipo_modif=58
pensiones.codigos

/*********************************
/* TRAER CORREO DEL BENFICIARIO 
/********************************
SELECT * FROM pensiones.beneficiarios where ben_poliza in (7849) and ben_beneficiario in (1476599,1165026,1238085)

--GRP_ID_GRUPO=BEN_BENEFICIARIO
SELECT GRP_ID_GRUPO,GRP_ID_DOM FROM pensiones.grupopago WHERE grp_id_grupo in (1248912,1248913)

update pensiones.grupopago
set grp_id_dom=419026
where grp_id_grupo=1248913

SELECT * FROM pensiones.domicilios 
where dom_id_dom in (605228,419026) --419026

 */
