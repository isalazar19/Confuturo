/* INTERBASE */
--select * from rentarsv.siniestros;
select * from rentarsv.polizas where pol_atrb10=2 and pol_producto in(606,607) order by pol_poliza DESC ;

select * from rentarsv.svs_poliza where  svsp_periodo_id=202312 and svsp_poliza_id=678226;

select * from pensiones.polizas where pol_mod_pension='P' and pol_producto in (606,607) ;

select * from rentarsv.svs_beneficiario where svsb_poliza_id=678226 and svsb_periodo_id=202312
