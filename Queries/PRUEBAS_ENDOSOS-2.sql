/* sale MHN */
select * from SOL_ENDOSO_EXCL_BENEF where EXC_RELACION=6

/* Termino AUC */
select * from pensiones.sol_endoso_excl_benef where exc_relacion=7

/* buscar conyuges */
select * from pensiones.beneficiarios where ben_relacion=4 order by 4 desc

/* buscar conviviente civil */
select * from pensiones.beneficiarios where ben_relacion=7 and ben_ind_der_re=2 order by 2 desc

/* sale MHN */
select * from pensiones.beneficiarios where ben_relacion=6 order by 4 desc

