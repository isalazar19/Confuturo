select * from pensiones.liqrv where lqr_per=202312 and lqr_pol = 610801 for update; /* cambiar a estatus 2*/

/* select de la ventana w_rbmod_02_05 */
select * from pensiones.tmp_mod_liq_poliza
where tml_prd=606
and tml_pol=610801
and tml_cau=1015283
and tml_cob=1
and tml_estado='V';

/* Llama a la ventana w_rbmod_02_04 
contine un DW Princial con el siguiente Query */
select lqr_per, 
    lqr_lin, 
    lqr_prd, 
    lqr_doc, 
    lqr_pol, 
    lqr_cau, 
    lqr_cob,
    lqr_tot_hab, 
    lqr_mto_imp,
    lqr_mto_tbt ,
    lqr_tot_dsc ,
    lqr_lq,
		0  impuesto,
		0 salud,
		0 pb,
		0 adic_salud,
    0 red_judic, 
		lqr_grp, 
		lqr_date_mod,
		lqr_id_mod , 
		0 cred_consumo,
		0 aporte_ccaf
from pensiones.liqrv
where lqr_lin = 3
		and lqr_prd = 606
		and  lqr_pol = 610801
		and lqr_per = 202312 
		and lqr_cob = 1
         and lqr_rst = 1 ;
 
 /* Boton Grabar w_rbmod_02_04 */        
 /* se hace un update con estas condiciones 
    update pensiones.Liqbenrv
	 set lqb_tot_hab =:ido_tot_hab ,
		  lqb_mto_impon =:ido_tot_impon ,
		  lqb_mto_tbt = :ido_tot_tbt,
		  lqb_tot_desc =:ido_tot_desc,
		  lqb_liq = :ido_liq 
	where lqb_per = :i_periodo
			 and lqb_lin = :g_linea
			 and lqb_prd = :i_producto
			 and lqb_doc = 2
			 and lqb_pol = :i_poliza
			 and lqb_cau = :i_causante
			 and lqb_grp = :ll_grp
			 and lqb_cob = :i_cobertura
			 and lqb_mto_tbt > 0; */
----------------------------------------------
 select * from pensiones.Liqbenrv
	where lqb_per = 202312
			 and lqb_lin = 3
			 and lqb_prd = 606
			 and lqb_doc = 2
			 and lqb_pol = 610801
			 and lqb_cau = 1015283
			 and lqb_grp = 1
			 and lqb_cob = 1
			 and lqb_mto_tbt > 0;         
       
/* 
   si impuesto del DW Ppal es mayor a 0 
      si el resultado de este select es igual a 0 */
          select count(*)  
              from pensiones.dsgdetrv 
              where dsg_per = 202312
                   and dsg_lin = 3
                   and dsg_prd = 606
                   and dsg_doc = 2
                   and dsg_pol = 610801
                   and dsg_cau = 1015283
                   and dsg_grp = 1
                   and dsg_tipo = 5 ;
/*   
         insert into pensiones.dsgdetrv 
         insert into pensiones.detliqrv
      sino
         update pensiones.dsgdetrv set dsg_mto_pes = :ido_impuesto
         update pensiones.detliqrv set dlr_mto_pes = :ido_impuesto
      fin si
   sino
         delete pensiones.dsgdetrv
         delete pensiones.detliqrv
   fin si
   
   si salud del DW Ppal es may a 0
      update pensiones.dsgdetrv set dsg_mto_pes =  :ido_salud
      update pensiones.detliqrv set dlr_mto_pes = :ido_salud
   fin si
   
   si ret_jud del DW Ppal es mayor a 0
      update pensiones.dsgdetrv set dsg_mto_pes =  :ido_ret_jud
      update pensiones.detliqrv set dlr_mto_pes =  :ido_ret_jud
   fin si
*/ 

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

/* Para hacer el Calculo Masivo de Impuesto:

1.- Se toma el ultimo periodo con este Query:
select max(lqr_per)
  into :il_ultimo_periodo
  from pensiones.liqrv;
      
2.- Se valida que no esten autorizados la liquidación de pensiones ejecutando el count debe retornar 0
el siguiente Query:
select count(*)
  into :ll_autorizados
  from pensiones.liqrv
 where lqr_per = :il_ultimo_periodo
   and lqr_rst = 2;
   
   
3.- Cálculos:

wf_calcular_salud_pactada()
────────────────────
salud_pactada = round(liqrv_salud_pactada_uf * valor_uf,2)

donde:
liqrv_salud_pactada_uf = lqr_val_tot tabla pensiones.liqrv
fecha_salud campo lqr_fec_pago tabla pensiones.liqrv

valor_uf = funcion f_consultar_valor_uf(fecha_salud) que tiene este select
select vmon_valor
  into :lde_valor_uf
  from gensegur.valormoneda
 where vmon_moneda = 1
   and vmon_fecha  = :arg_fecha;


wf_calcular_tope_salud()
──────────────────
tope_salud = round(4.2 * valor_uf,2)
fecha_salud campo lqr_fec_pago tabla pensiones.liqrv

donde:
valor_uf = funcion f_consultar_valor_uf(fecha_salud) que tiene este select
select vmon_valor
  into :lde_valor_uf
  from gensegur.valormoneda
 where vmon_moneda = 1
   and vmon_fecha  = :arg_fecha;


wf_calcular_pension_tributable()
─────────────────────────
pension_tributable = round(((pension_base_uf * round(%_tributable, 2)) / 100) * lde_valor_uf, 2)

donde:
pension_base_uf campo dlr_mto_uf tabla pensiones.detliqrv
%_tributable campo porc_tributable
fecha_pago campo lqr_fec_pago tabla pensiones.liqrv

valor_uf = funcion f_consultar_valor_uf(fecha_pago) que tiene este select
select vmon_valor
  into :lde_valor_uf
  from gensegur.valormoneda
 where vmon_moneda = 1
   and vmon_fecha  = :arg_fecha;


wf_obt_reliq_meses_anteriores()
─────────────────────────

Busca la reliquidación de meses anteriores para la poliza:

select dlr_mto_pes
  into :ll_reliq_meses_anteriores
  from pensiones.detliqrv
 where dlr_tip = 3
   and dlr_per = :il_ultimo_periodo
   and dlr_pol = :ll_poliza
	and dlr_grp = :li_grupo;


Si ll_reliq_meses_anteriores > 0 entonces realiza los siguientes calculos:

wf_calcular_total_imponible(pension_tributable,ll_reliq_meses_anteriores)
────────────────────────────────────────────────────────
total_imponible = round(pension_tributable + ll_reliq_meses_anteriores, 2)


wf_calcular_salud_legal(total_imponible)
───────────────────────────────
%_salud_legal = f_consultar_salud_legal(il_ultimo_periodo) tiene este select
select plq_ctz_salud
  into :lde_salud_legal
  from pensiones.prmliqrv
 where plq_per = :arg_periodo;

si %_salud_legal > 0 entonces
salud_legal = round((total_imponible * %_salud_legal) / 100, 2)


 wf_calcular_adicional_salud(salud_pactada, salud_legal)
───────────────────────────────────────────
adicional_salud = round(salud_pactada - salud_legal, 2)

si adicional_Salud < 0 entonces adicional_salud=0


wf_calcular_total_tributable(total_imponible, salud_legal, adicional_salud, tope_salud)
───────────────────────────────────────────────────────────────────────────────────────
total_salud = round(salud_legal + adicional_salud, 2)
si total_salud > tope_salud entonces
   total_salud = round(tope_salud, 2)
fin si
total_tributable = round(total_imponible - total_salud, 2)

wf_obtener_factor_rebaja_tramo(factor,tramo,rebaja) = obtiene factor, tramo, rebaja

wf_calcular_nuevo_impuesto(total_tributable, factor, rebaja)
────────────────────────────────────────────────────────────
nuevo_impuesto = round((total_tributable * factor) - rebaja, 2)

wf_calcular_pension_no_tributable()
───────────────────────────────────
pension_base_uf = campo dlr_mto_uf tabla pensiones.detliqrv
%_no_tributable = campo porc_no_tributable
fecha_pago      = campo lqr_fec_pago tabla pensiones.liqrv

valor_uf = f_consultar_valor_uf(fecha_pago)

if valor_uf <= 0 then
	return -1
end if

pension_no_tributable = round(((pension_base_uf * %_no_tributable) / 100) * valor_uf, 2)


si pension_no_tributable >= 0 entonces

wf_calcular_total_haberes(total_imponible, pension_no_tributable)
───────────────────────────────────────────────────────────────────
total_haberes = total_imponible + pension_no_tributable


wf_calcular_total_descuentos(salud_legal, adicional_salud, nuevo_impuesto)
──────────────────────────────────────────────────────────────────────────
--Busca otros descuentos que existan
ll_poliza = dw_1.getItemNumber(arg_fila, 'asegafp_poliza')
li_grupo  = dw_1.getItemNumber(arg_fila, 'liqrv_grupo_pago')

select nvl(sum(nvl(dlr_mto_pes, 0)), 0)
  into :total_debe_adicionales
  from pensiones.detliqrv
 where dlr_per      = :il_ultimo_periodo
   and dlr_d_h      = 'D'
   and dlr_pol      = :ll_poliza
	and dlr_grp      = :li_grupo
	and dlr_tip not in (5, 6, 43);

total_descuentos = salud_legal + adicional_salud + nuevo_impuesto + total_debe_adicionales


wf_calcular_liquido_pago(total_haberes, total_descuentos)
─────────────────────────────────────────────────────────
liquido_pago = round(total_haberes - total_descuento, 2)



*/




select p.nat_numrut, count(p.nat_numrut)
from pensiones.beneficiarios ben, pensiones.persnat p
where ben.ben_relacion <> 9
and p.nat_id = ben.ben_beneficiario
and p.nat_numrut not in (0,1,2,3,4,5,6,7,8,9,11111111,33333333)
and ben.ben_ind_der_re = 2
group by p.nat_numrut
having count(p.nat_numrut)>1
order by p.nat_numrut asc;

--CASO 1
select ben_poliza,ben_beneficiario,ben_relacion, ben_causante from pensiones.beneficiarios 
where ben_beneficiario in (select nat_id from persnat where nat_numrut=8970450) order by 1;

--CASO 2
select ben_poliza,ben_beneficiario,ben_relacion, ben_causante from pensiones.beneficiarios 
where ben_beneficiario in (select nat_id from persnat where nat_numrut=5170685) order by 1;

--CASO 3
select ben_poliza,ben_beneficiario,ben_relacion, ben_causante from pensiones.beneficiarios 
where ben_beneficiario in (select nat_id from persnat where nat_numrut=4432214) order by 1;


--APV
select * from pensiones.asegafp where asaf_porc_trib is not null or asaf_porc_no_trib is not null;

--Query doble poliza
SELECT distinct ben_relacion ||'-'|| cod_ext   RELACION,
                ben_beneficiario ID,
                ben_poliza       poliza,
                n1.nat_numrut       rut,
                n1.nat_dv dv,
                n1.nat_nomb         nombre,
                nvl(lqr_lq, 0) mto_pns_$$,
                n1.nat_Fec_nacim fec_nacim,
                trunc((sysdate-n1.nat_fec_nacim)/365) edad,
                n1.nat_fec_inval  fec_inval,
                n1.NAT_FEC_MUERTE fec_muerte,
                n1.nat_sexo sexo ,
                n1.nat_fec_matr_fc ,
                b1.ben_fec_est_civil   ,
                ROUND((LQR_LQ/VMON_VALOR),2) ,
                (select nvl(DSG_MTO_UF,0) 
                from pensiones.dsgdetrv
                  where dsg_tipo = 1
                  and dsg_per = lqr_per
                  and dsg_prd = lqr_prd
                  and dsg_doc = lqr_doc
                  and dsg_pol = lqr_pol
                  and dsg_cau = lqr_cau
                  and dsg_grp = lqr_grp) pb_uf
 
  FROM PENSIONES.BENEFICIARIOS b1,
       pensiones.persnat       n1,
       pensiones.persnat       n2,
       pensiones.beneficios,
       pensiones.siniestros,
       pensiones.liqrv ,
       pensiones.codigos,
       gensegur.valormoneda
 WHERE sin_linea = bnf_linea
   and sin_producto = bnf_producto
   and sin_documento = bnf_documento
   and sin_poliza = bnf_poliza
   and sin_tipo = bnf_cobertura
   and sin_id = bnf_causante
   and bnf_linea = ben_linea
   and bnf_producto = ben_producto
   and bnf_documento = ben_documento
   and bnf_poliza = ben_poliza
   and bnf_causante = ben_causante
   and bnf_beneficiario = ben_beneficiario
   and ben_relacion  not in ( 8,9)
   AND n1.NAT_FEC_MUERTE IS NULL
   and sin_estado = 11
   and n1.nat_numrut not in (0, 1)
   and n1.nat_numrut = n2.nat_numrut 
   
   and b1.ben_beneficiario = n1.nat_id
   and lqr_per = :p_per_act
   and lqr_pol   = ben_poliza
   and lqr_rep = ben_beneficiario

   and n1.nat_numrut in
       (SELECT DISTINCT n1.nat_numrut beneficiario
          FROM PENSIONES.BENEFICIARIOS b1, pensiones.persnat n1
         WHERE b1.ben_relacion not in ( 8,9)
           and b1.ben_beneficiario = nat_id
           and (select count(*)
                  from pensiones.beneficiarios b2
                 where b2.ben_beneficiario = b1.ben_beneficiario
                 and b2.ben_relacion not in ( 8,9)) = 1

         HAVING COUNT(*) >= 2
         group by nat_numrut)

           
       and (select count(*)
            from pensiones.dsgdetrv d1
            where d1.dsg_per = lqr_per
                  and d1.dsg_lin = lqr_lin
                  and d1.dsg_doc = lqr_doc
                  and d1.dsg_tipo = 1
                  and d1.dsg_ben in (n1.nat_id, n2.nat_id))> 1
       
       and (select nvl(sum(d1.dsg_mto_uf ),0) 
            from pensiones.dsgdetrv d1, pensiones.beneficiarios
            where d1.dsg_per = lqr_per
                  and d1.dsg_lin = lqr_lin
                  and d1.dsg_doc = lqr_doc
                  and d1.dsg_tipo = 1
                  and d1.dsg_ben in (n1.nat_id, n2.nat_id)
                  and d1.dsg_lin = ben_linea 
                  and d1.dsg_prd = ben_producto 
                  and d1.dsg_doc = ben_documento 
                  and d1.dsg_pol = ben_poliza 
                  and d1.dsg_cau = ben_causante 
                  and d1.dsg_ben = ben_beneficiario 
                  and ben_relacion not in (8,9) ) > :p_tope         

       and vmon_moneda  = 1
       AND VMON_FECHA = LQR_FEC_PAGO
       and ben_relacion = cod_int_num 
       and cod_template = 'TR07-RELACION-BENEFICIARIOS'

       order by n1.nat_numrut
