/* queries agregar campos y datos */
ALTER TABLE pensiones.beneficiarios
ADD BEN_HIJOS NUMBER(3);

comment on column pensiones.beneficiarios.ben_hijos is 'Indica si tiene hijos en comun 0=No 1=Si';

ALTER TABLE pensiones.datos_ben
ADD DBE_HIJOS NUMBER(3);

comment on column pensiones.datos_ben.dbe_hijos is 'Indica si tiene hijos en comun 0=No 1=Si';


/* TERMINO AUC */
insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('TC10-CERTIFICADOS',12,NULL,'Termino AUC','S')


/* NOTIFICACION PLANILLA DE SEGUIMIENTO */
insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('MAIL-ENDOSOS-JEFATURA',1,NULL,'gcastror@confuturo.cl','S')

/* Notificación y cuadro Resumen del Endoso */
insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('MAIL-ENDOSOS-BORDES',1,NULL,'endososcasosbordepensiones@confuturo.cl','S')


insert into pensiones.codigos
(cod_template,cod_int_num,cod_int_char,cod_ext,cod_vigencia)
values
('VENTANA-ENDOSO',NULL,'CC','Termino AUC','S')
