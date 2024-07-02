/* caso fecha matrimonio conyuge post-poliza */

SELECT DECODE(NVL(NAT_FEC_MATR_FC,''),'',
 (select CEP_FEC_INI_VIG from pensiones.certper where cep_nat=1072185 and cep_tip=2), NAT_FEC_MATR_FC)
FROM PENSIONES.PERSNAT
WHERE PERSNAT.NAT_ID=1072185;

select CEP_FEC_INI_VIG from pensiones.certper where cep_nat=1072185 and cep_tip=2



/* DEVOLVER ESTADO INGRESADO INCLUSION BENEFICIARIO */
select * from pensiones.SOL_ENDOSO_INCL_BENEF
where inc_poliza in (510187,660685)

update pensiones.SOL_ENDOSO_INCL_BENEF
set inc_estado=3
where inc_poliza in (510187,660685)
