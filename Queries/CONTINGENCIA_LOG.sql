-- Create table
create table pensiones.CONTINGENCIA_LOG
(
  fecha_log       DATE not null,
  descripcion_log VARCHAR2(250) not null
)
tablespace DATA_PENSIONES_TS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column CONTINGENCIA_LOG.fecha_log
  is 'Fecha ejecucion ';
comment on column CONTINGENCIA_LOG.descripcion_log
  is 'Descripcion de la ejecucion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table CONTINGENCIA_LOG
  add constraint PK_CONTING_LOG primary key (FECHA_LOG)
  disable;