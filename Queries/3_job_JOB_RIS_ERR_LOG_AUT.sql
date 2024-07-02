
begin
  sys.dbms_scheduler.create_job(job_name            => 'RENTARSV.JOB_RIS_ERR_LOG_AUT',
                                job_type            => 'PLSQL_BLOCK',
                                job_action          => 'declare
                                                         v_periodo number := 0;
                                                         begin
                                                           select
                                                           to_number(extract(year from add_months(sysdate,-1))||trim(lpad(to_char(extract(month from add_months(sysdate,-1))),2,0)))
                                                           into v_periodo
                                                           from dual;
                                                           SP_GEN_MODIF_RIS_PROY(v_periodo,2,null);
                                                         end;',
                                start_date          => to_date('03-04-2024 13:30:00', 'dd-mm-yyyy hh24:mi:ss'),
                                repeat_interval     => 'Freq=Monthly;ByMonthDay=9;ByHour=22;ByMinute=00',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => false,
                                auto_drop           => false,
                                comments            => 'Proceso de Rectificacion Automatizada RIS Errores Logicos.');
end;
/

