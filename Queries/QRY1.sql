select * from pensiones.codigos
-- where cod_template = 'CORREO_AJUSTE_CONTABLE'
where cod_template LIKE '%MAIL-ENDOSOS%'

/* RELACION RIS */
select * from pensiones.codigos
where cod_template like '%TR11-RELACION-RIS%'
order by 2

/* COBERTURAS */
select * from pensiones.codigos
where cod_template like '%TC03-COBERTURAS'
order by 2

/*RELACION */
select * from pensiones.codigos 
where cod_template like 'TR07_RELACION_BENEFICIARIOS%' 
order by 2

/* RELACION EXTENDIDA ASEGURADO */
select * from pensiones.codigos
where cod_template like 'TR06_RELACION_ASEGURADO%'

/* ESTADOS POLIZA */
select * from pensiones.codigos
where cod_template like 'TE04_ESTADOS_POLIZA%'


select POL_PORC_RE
,NVL(POL_PORC_RE,'')
,DECODE(NVL(POL_PORC_RE,''), '','NO', 'SI') from pensiones.polizas
where pol_poliza in (524537,677825)

select * from pensiones.codigos
where cod_template = 'VENTANA-ENDOSO'

/* insert para pruebas locales */
insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('MAIL-ENDOSOS-JEFATURA',1,NULL,'isalazarc@ext.confuturo.cl','S')

insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('MAIL-ENDOSOS-BORDES',1,NULL,'psaavedrai@confuturo.cl','S')



/*TIPOS DE ENDOSOS */
select * from pensiones.codigos
where cod_template LIKE 'TE06_TIPO_ENDOSOS%'

/* AFPs */
select * from pensiones.codigos
where cod_template LIKE 'TA02-AFP%'

/* ESTADO CIVIL */
select * from pensiones.codigos
where cod_template LIKE 'TE01-ESTADOS-CIVILES%'

/* TIPOS CERTIFICADOS */
select * from pensiones.codigos
where cod_template LIKE 'TC10-CERTIFICADOS'  /* agregar cod =12 para Temino AUC */

insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('TC10-CERTIFICADOS',12,NULL,'Termino AUC','S')

select * from pensiones.codigos
where cod_template like 'TE07%'


select * from pensiones.productos

delete from pensiones.codigos
where cod_template = 'MAIL-ENDOSOS-BORDES'
and cod_ext='endososcasosbordepensiones@confuturo.cl'


select * from pensiones.codigos
where cod_template LIKE 'VENTANA-ENDOSO%'

insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('VENTANA-ENDOSO',NULL,'CC','Termino AUC','S')

--TE12-TIPO-CERT-END-INC-BEN
--TE13-TIPO-CAUSAL-END-INC-BEN

select * from pensiones.codigos
where cod_template LIKE 'TE12-TIPO-CERT-END-INC-BEN%'
or cod_template LIKE 'TE13-TIPO-CAUSAL-END-INC-BEN%'

