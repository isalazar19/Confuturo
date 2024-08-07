CREATE OR REPLACE FUNCTION pensiones."F_ULTIMO_DIA_HABIL_MES"
 (p_fecha_inicio IN DATE, p_fecha_fin IN DATE)
 RETURN NUMBER IS
  v_fecha_ult_mes DATE;
  feriados    NUMBER;
  v_dia_fin_es_feriado NUMBER :=0;
  v_dia_job   NUMBER;
  v_fecha_fin DATE;
  v_dia_fecha_ult_mes NUMBER;

BEGIN
  --p_fecha_ini := to_date('01/02/2024', 'DD/MM/YYYY');  --input
  --p_fecha_fin := to_date('16/02/2024', 'DD/MM/YYYY');  --input
  v_fecha_ult_mes := LAST_DAY(to_date(to_char(p_fecha_fin,'dd/mm/yyyy'),'dd/mm/yyyy'));
  --obtiene el ultimo dia del mes
  v_dia_job := EXTRACT( DAY FROM to_date(to_char(p_fecha_fin,'dd/mm/yyyy'),'dd/mm/yyyy') );

  --dbms_output.put_line('Fecha Inicio      :' || p_fecha_inicio);
  --dbms_output.put_line('Fecha Fin         :' || p_fecha_fin);
  --dbms_output.put_line('Fecha Ult Dia Mes :' || v_fecha_ult_mes);
  --dbms_output.put_line('Dia Job           :' || v_dia_job);
  --dbms_output.put_line('----------------------------------');

  --dbms_output.put_line('*');

  --se ejecuta para los dias previstos 20 y 25 y para el ultimo dia de cada mes se ejecuta el 1ro 
  if v_dia_job = 20 or v_dia_job = 25 or v_dia_job = 1 then
    --dbms_output.put_line('Se ejecuta el dia ' || v_dia_job);
    RETURN 1;
  /*
  --preguntar si esta en el bloque de dias para el dia habil fin de mes
  elsif v_dia_job >= 26 then
    --dbms_output.put_line('**');
    --saber si es feriado la fecha_ult_mes
    IF TO_CHAR(v_fecha_ult_mes,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN') THEN
      SELECT NVL(COUNT(FER_FECHA),0)
      INTO feriados
      FROM rentapre.feriados
      WHERE FER_FECHA = v_fecha_ult_mes;
    END IF;

    if feriados <=0
    and (TO_CHAR(v_fecha_ult_mes,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN')) then
      --dbms_output.put_line(v_fecha_ult_mes || ' No Es Feriado');
      --dbms_output.put_line('*Fecha Ult Dia Mes :' || v_fecha_ult_mes);
      v_fecha_ult_mes := v_fecha_ult_mes;
    else
      --dbms_output.put_line(v_fecha_ult_mes || ' Es Feriado');
      --si es feriado busca la fecha que no sea feriado para asignar la fecha del �ltimo
      --d�a h�bil del mes
      --dbms_output.put_line('*');
      v_dia_fecha_ult_mes := EXTRACT( DAY FROM to_date(to_char(v_fecha_ult_mes,'dd/mm/yyyy'),'dd/mm/yyyy') );
      FOR i IN REVERSE 26..v_dia_fecha_ult_mes
          LOOP
            v_fecha_fin := to_date(i||to_char(p_fecha_fin,'mm/yyyy'),'dd/mm/yyyy');
            --saber si es feriado la v_fecha_fin
            IF TO_CHAR(v_fecha_fin,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN') THEN
              SELECT NVL(COUNT(FER_FECHA),0)
              INTO v_dia_fin_es_feriado
              FROM rentapre.feriados
              WHERE FER_FECHA = v_fecha_fin;
            END IF;

            if v_dia_fin_es_feriado <=0
            and (TO_CHAR(v_fecha_fin,'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT','SUN')) then
               --dbms_output.put_line(v_fecha_fin || ' No es Feriado');
               v_fecha_ult_mes := v_fecha_fin;
               --dbms_output.put_line('*Fecha Ult Dia Mes :' || v_fecha_ult_mes);
               exit;
            ---else
               ---dbms_output.put_line(v_fecha_fin || ' Es Feriado');
            end if;
      END LOOP;
    end if;
    v_dia_fecha_ult_mes := EXTRACT( DAY FROM to_date(to_char(v_fecha_ult_mes,'dd/mm/yyyy'),'dd/mm/yyyy') );
    if v_dia_job = v_dia_fecha_ult_mes then
      --dbms_output.put_line('v_dia_job=v_dia_fecha_ult_mes');
      --dbms_output.put_line(v_dia_fecha_ult_mes || '=' || v_dia_job);
      RETURN 1;
    else
      --dbms_output.put_line(v_dia_job || '<>' || v_dia_fecha_ult_mes);
      RETURN 0;
    end if;
  */
  else
    --dbms_output.put_line('No hace nada');
    RETURN 0;
  end if;

END F_ULTIMO_DIA_HABIL_MES;
/
