/*
1) Revisar el PROCEDURE SP_PRELIQ_GEN_AUT_ALL
2) Revisar la FUNCTION F_DIAS_HABILES_PRELIQ
3) Agregar al PROCEDURE SP_CT_GEN_AUT_ALL la rutina de la FUNCTION nueva
   F_ULTIMO_DIA_HABIL_MES (ver SP_PRELIQ_GEN_AUT_ALL)
4) Modificar el JOB JOB_CONTINGENCIA_AUT se agregara en el Schedule By Month day 20,25,26,27,28,29,30,31
*/


select to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
      to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')
from dual;
select NVL(F_DIAS_HABILES_PRELIQ(to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
                                       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')),0)
from dual;
      

SELECT *
FROM rentapre.feriados
WHERE FER_FECHA BETWEEN to_date(to_char('01-01-2024'),'dd/mm/yyyy') AND 
      to_date(to_char('31-12-2024'),'dd/mm/yyyy') for update;
      
SELECT NVL(COUNT(FER_FECHA),0)
      --INTO feriados
      FROM rentapre.feriados
      WHERE FER_FECHA = to_date(to_char('31-03-2024'),'dd/mm/yyyy');      
      

SELECT to_date('01/'||to_char(sysdate,'mm/yyyy'),'dd/mm/yyyy'),
       to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy'),
       EXTRACT( DAY FROM LAST_DAY(to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')) ) DAY,
       LAST_DAY(to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy')) "Last",
       LAST_DAY(SYSDATE) - SYSDATE "Days Left"
  FROM DUAL;    
  
select to_number(to_char(add_months(prm_fec_desde,1),'YYYYMM'))
       --into v_liq_aut
       from pensiones.paramet_fechas 
       where prm_fec_desde = prm_fec_hasta 
       and prm_tipo_tabla = 'RVLIQ';    
  
/*
DECLARE
  p_fecha_ini DATE ;
  p_fecha_fin DATE;
  v_fecha_ult_mes DATE;
  feriados    NUMBER;
  v_dia_fin_es_feriado NUMBER :=0;
  v_dia_job   NUMBER;
  v_fecha_fin DATE;
  v_dia_fecha_ult_mes NUMBER;
 
BEGIN
  p_fecha_ini := to_date('01/02/2024', 'DD/MM/YYYY');  --input
  p_fecha_fin := to_date('16/02/2024', 'DD/MM/YYYY');  --input
  --v_fecha_ult_mes := LAST_DAY(to_date(to_char(trunc(sysdate),'dd/mm/yyyy'),'dd/mm/yyyy'));
  v_fecha_ult_mes := LAST_DAY(to_date(to_char(p_fecha_fin,'dd/mm/yyyy'),'dd/mm/yyyy'));
  --obtiene el ultimo dia del mes
  v_dia_job := EXTRACT( DAY FROM to_date(to_char(p_fecha_fin,'dd/mm/yyyy'),'dd/mm/yyyy') );
  
  dbms_output.put_line('┌────────────────────────────────┐');
  dbms_output.put_line('│Fecha Inicio      :' || p_fecha_ini ||'    │');
  dbms_output.put_line('│Fecha Fin         :' || p_fecha_fin ||'    │');
  dbms_output.put_line('│Fecha Ult Dia Mes :' || v_fecha_ult_mes ||'    │');
  dbms_output.put_line('│Dia Job           :' || v_dia_job ||'           │');
  dbms_output.put_line('└────────────────────────────────┘');
  
  --EXTRACT( DAY FROM to_date(to_char(v_fecha_ult_mes,'dd/mm/yyyy'),'dd/mm/yyyy') );

  dbms_output.put_line('*');
  
  --preguntar si esta en el bloque de dias para el dia habil fin de mes
  if v_dia_job >= 26 then
    dbms_output.put_line('**');
    --saber si es feriado la fecha_ult_mes
    IF TO_CHAR(v_fecha_ult_mes,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN') THEN
      SELECT NVL(COUNT(FER_FECHA),0)
      INTO feriados
      FROM rentapre.feriados
      WHERE FER_FECHA = v_fecha_ult_mes;
    END IF;
      
    if feriados <=0 then
      dbms_output.put_line(v_fecha_ult_mes || ' No Es Feriado');
      dbms_output.put_line('*Fecha Ult Dia Mes :' || v_fecha_ult_mes);  
    else
      dbms_output.put_line(v_fecha_ult_mes || ' Es Feriado');
      --si es feriado busca la fecha que no sea feriado para asignar la fecha del último 
      --día hábil del mes
      dbms_output.put_line('*');
      v_dia_fecha_ult_mes := EXTRACT( DAY FROM to_date(to_char(v_fecha_ult_mes,'dd/mm/yyyy'),'dd/mm/yyyy') );
      FOR i IN REVERSE 26..v_dia_fecha_ult_mes
          LOOP
            v_fecha_fin := to_date(i||to_char(p_fecha_fin,'mm/yyyy'),'dd/mm/yyyy');
            --dbms_output.put_line(v_fecha_fin);
            --saber si es feriado la v_fecha_fin
            IF TO_CHAR(v_fecha_fin,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN') THEN
              SELECT NVL(COUNT(FER_FECHA),0)
              INTO v_dia_fin_es_feriado
              FROM rentapre.feriados
              WHERE FER_FECHA = v_fecha_fin;
            END IF;
            
            if v_dia_fin_es_feriado <=0 
            and (TO_CHAR(v_fecha_fin,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN')) then
               dbms_output.put_line(v_fecha_fin || ' No es Feriado');
               v_fecha_ult_mes := v_fecha_fin;
                dbms_output.put_line('*Fecha Ult Dia Mes :' || v_fecha_ult_mes);
               exit;
            else
               dbms_output.put_line(v_fecha_fin || ' Es Feriado');
            end if; 
      END LOOP;
    end if;
    v_dia_fecha_ult_mes := EXTRACT( DAY FROM to_date(to_char(v_fecha_ult_mes,'dd/mm/yyyy'),'dd/mm/yyyy') );
    if v_dia_job = v_dia_fecha_ult_mes then
      dbms_output.put_line('v_dia_job=v_dia_fecha_ult_mes');
      dbms_output.put_line(v_dia_fecha_ult_mes || '=' || v_dia_job);
    else
      dbms_output.put_line(v_dia_fecha_ult_mes || '<>' || v_dia_job);
    end if;
  else
    dbms_output.put_line('No hace nada');
  end if;
  
  
END;

*/
