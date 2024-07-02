/* ver asegurado y beneficiarios */

--En Pago campo POL_ATRB01=4 y POL_ESTADO=3 Vigente
select * from pensiones.polizas where pol_poliza=513649;

/* contratante pol_contratante=1015245 */
--select * from persnat where  nat_id=1015245

/* Beneficiarios */
select * from beneficiarios where ben_poliza=664;

select ben_poliza,ben_beneficiario,nat_numrut||'-'||nat_dv rut, nat_nombre||', ' || nat_ap_pat || ' ' || nat_ap_mat nombre, nat_fec_nacim,
TRUNC( ( TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')) -  TO_NUMBER(TO_CHAR(persnat.NAT_FEC_NACIM,'YYYYMMDD') ) ) / 10000) as edad,
nat_est_civil ||'='|| 
(select cod_ext from pensiones.codigos
where cod_template LIKE 'TE01-ESTADOS-CIVILES%' and cod_int_num=nat_est_civil
) estado_civil, ben_relacion || '='||
(select cod_ext from pensiones.codigos 
where cod_template like 'TR07_RELACION_BENEFICIARIOS%' and cod_int_num=ben_relacion
) relacion, nat_fec_muerte, nat_fec_matr_fc,nat_fec_inval,
(select pol_atrb01||'='||DECODE(POL_ATRB01,5,'Resciliada',7,'Período Garantizado Pagado',8,'Terminada','En Pago')
from pensiones.polizas where pol_poliza=ben_poliza) situacion,
sin_tipo || '=' ||
(select cod_ext from pensiones.codigos
where cod_template like '%TC03-COBERTURAS' and cod_int_num=sin_tipo) causalidad
from pensiones.beneficiarios, pensiones.persnat, pensiones.siniestros
where SIN_LINEA = BEN_LINEA 
and SIN_PRODUCTO = BEN_PRODUCTO  
and SIN_DOCUMENTO = BEN_DOCUMENTO  
and SIN_POLIZA = BEN_POLIZA  
and sin_tipo = (select min(sin_tipo) from siniestros where
				SIN_LINEA = BEN_LINEA and  
        SIN_PRODUCTO = BEN_PRODUCTO and  
        SIN_DOCUMENTO = BEN_DOCUMENTO and  
        SIN_POLIZA = BEN_POLIZA )  
and ben_poliza in (7627)
and ben_beneficiario=nat_id
order by ben_poliza, ben_relacion;

/* contar beneficiarios de una poliza */

select ben_poliza,ben_relacion, 
(select cod_ext from pensiones.codigos where cod_template like 'TR07_RELACION_BENEFICIARIOS%' and cod_int_num=ben_relacion) nomb_relacion,
count(ben_relacion) as total
from pensiones.beneficiarios
where ben_poliza=600040
having count(*)>0
group by ben_poliza,  ben_relacion
order by ben_relacion


select * from pensiones.certper where cep_nat=1301260

/*DOMICILIO DEL BENEFICIARIO*/
SELECT GRP_ID_GRUPO,GRP_ID_DOM FROM pensiones.grupopago WHERE grp_id_grupo in (1131602,1478583)

SELECT * FROM pensiones.domicilios 
where dom_id_dom in (2003309,2084579) --GRP_ID_DOM

/* beneficios */ 
select * from pensiones.beneficios where bnf_poliza=13396
