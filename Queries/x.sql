SELECT * FROM PENSIONES.HAB_DCTO;

select distinct (dsg_tipo), dsg_d_H, dsg_gls from pensiones.dsgdetrv where dsg_per=202312 order by 2 DESC,1;


select itm_glosa, itm_hd, itm_codigo from pensiones.itmliqrv order by 1 ;
