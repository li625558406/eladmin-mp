drop table if exists qrtz_fired_triggers;
drop table if exists qrtz_paused_trigger_grps;
drop table if exists qrtz_scheduler_state;
drop table if exists qrtz_locks;
drop table if exists qrtz_simple_triggers;
drop table if exists qrtz_simprop_triggers;
drop table if exists qrtz_cron_triggers;
drop table if exists qrtz_blob_triggers;
drop table if exists qrtz_triggers;
drop table if exists qrtz_job_details;
drop table if exists qrtz_calendars;

create table qrtz_job_details(
sched_name VARCHAR(120) not null,
job_name VARCHAR(200) not null,
job_group VARCHAR(200) not null,
description VARCHAR(250) null,
job_class_name VARCHAR(250) not null,
is_durable VARCHAR(1) not null,
is_nonconcurrent VARCHAR(1) not null,
is_update_data VARCHAR(1) not null,
requests_recovery VARCHAR(1) not null,
job_data BYTEA null,
primary key (sched_name, job_name, job_group))
;

create table qrtz_triggers (
sched_name VARCHAR(120) not null,
trigger_name VARCHAR(200) not null,
trigger_group VARCHAR(200) not null,
job_name VARCHAR(200) not null,
job_group VARCHAR(200) not null,
description VARCHAR(250) null,
next_fire_time BIGINT null,
prev_fire_time BIGINT null,
priority INTEGER null,
trigger_state VARCHAR(16) not null,
trigger_type VARCHAR(8) not null,
start_time BIGINT not null,
end_time BIGINT null,
calendar_name VARCHAR(200) null,
misfire_instr SMALLINT null,
job_data BYTEA null,
primary key (sched_name, trigger_name, trigger_group),
foreign key (sched_name, job_name, job_group)
references qrtz_job_details(sched_name, job_name, job_group))
;

create table qrtz_simple_triggers (
sched_name VARCHAR(120) not null,
trigger_name VARCHAR(200) not null,
trigger_group VARCHAR(200) not null,
repeat_count BIGINT not null,
repeat_interval BIGINT not null,
times_triggered BIGINT not null,
primary key (sched_name, trigger_name, trigger_group),
foreign key (sched_name, trigger_name, trigger_group)
references qrtz_triggers(sched_name, trigger_name, trigger_group))
;

create table qrtz_cron_triggers (
sched_name VARCHAR(120) not null,
trigger_name VARCHAR(200) not null,
trigger_group VARCHAR(200) not null,
cron_expression VARCHAR(120) not null,
time_zone_id VARCHAR(80),
primary key (sched_name, trigger_name, trigger_group),
foreign key (sched_name, trigger_name, trigger_group)
references qrtz_triggers(sched_name, trigger_name, trigger_group))
;

create table qrtz_simprop_triggers (
sched_name VARCHAR(120) not null,
trigger_name VARCHAR(200) not null,
trigger_group VARCHAR(200) not null,
str_prop_1 VARCHAR(512) null,
str_prop_2 VARCHAR(512) null,
str_prop_3 VARCHAR(512) null,
int_prop_1 INTEGER null,
int_prop_2 INTEGER null,
long_prop_1 BIGINT null,
long_prop_2 BIGINT null,
dec_prop_1 numeric(13, 4) null,
dec_prop_2 numeric(13, 4) null,
bool_prop_1 VARCHAR(1) null,
bool_prop_2 VARCHAR(1) null,
primary key (sched_name, trigger_name, trigger_group),
foreign key (sched_name, trigger_name, trigger_group)
references qrtz_triggers(sched_name, trigger_name, trigger_group))
;

create table qrtz_blob_triggers (
sched_name VARCHAR(120) not null,
trigger_name VARCHAR(200) not null,
trigger_group VARCHAR(200) not null,
blob_data BYTEA null,
primary key (sched_name, trigger_name, trigger_group),
foreign key (sched_name, trigger_name, trigger_group)
references qrtz_triggers(sched_name, trigger_name, trigger_group))
;
create index idx_qrtz_blob_triggers on qrtz_blob_triggers(sched_name, trigger_name, trigger_group);

create table qrtz_calendars (
sched_name VARCHAR(120) not null,
calendar_name VARCHAR(200) not null,
calendar BYTEA not null,
primary key (sched_name, calendar_name))
;

create table qrtz_paused_trigger_grps (
sched_name VARCHAR(120) not null,
trigger_group VARCHAR(200) not null,
primary key (sched_name, trigger_group))
;

create table qrtz_fired_triggers (
sched_name VARCHAR(120) not null,
entry_id VARCHAR(95) not null,
trigger_name VARCHAR(200) not null,
trigger_group VARCHAR(200) not null,
instance_name VARCHAR(200) not null,
fired_time BIGINT not null,
sched_time BIGINT not null,
priority integer not null,
state VARCHAR(16) not null,
job_name VARCHAR(200) null,
job_group VARCHAR(200) null,
is_nonconcurrent VARCHAR(1) null,
requests_recovery VARCHAR(1) null,
primary key (sched_name, entry_id))
;

create table qrtz_scheduler_state (
sched_name VARCHAR(120) not null,
instance_name VARCHAR(200) not null,
last_checkin_time BIGINT not null,
checkin_interval BIGINT not null,
primary key (sched_name, instance_name))
;

create table qrtz_locks (
sched_name VARCHAR(120) not null,
lock_name VARCHAR(40) not null,
primary key (sched_name, lock_name))
;

create index idx_qrtz_j_req_recovery on qrtz_job_details(sched_name, requests_recovery);
create index idx_qrtz_j_grp on qrtz_job_details(sched_name, job_group);

create index idx_qrtz_t_j on qrtz_triggers(sched_name, job_name, job_group);
create index idx_qrtz_t_jg on qrtz_triggers(sched_name, job_group);
create index idx_qrtz_t_c on qrtz_triggers(sched_name, calendar_name);
create index idx_qrtz_t_g on qrtz_triggers(sched_name, trigger_group);
create index idx_qrtz_t_state on qrtz_triggers(sched_name, trigger_state);
create index idx_qrtz_t_n_state on qrtz_triggers(sched_name, trigger_name, trigger_group, trigger_state);
create index idx_qrtz_t_n_g_state on qrtz_triggers(sched_name, trigger_group, trigger_state);
create index idx_qrtz_t_next_fire_time on qrtz_triggers(sched_name, next_fire_time);
create index idx_qrtz_t_nft_st on qrtz_triggers(sched_name, trigger_state, next_fire_time);
create index idx_qrtz_t_nft_misfire on qrtz_triggers(sched_name, misfire_instr, next_fire_time);
create index idx_qrtz_t_nft_st_misfire on qrtz_triggers(sched_name, misfire_instr, next_fire_time, trigger_state);
create index idx_qrtz_t_nft_st_misfire_grp on qrtz_triggers(sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);

create index idx_qrtz_ft_trig_inst_name on qrtz_fired_triggers(sched_name, instance_name);
create index idx_qrtz_ft_inst_job_req_rcvry on qrtz_fired_triggers(sched_name, instance_name, requests_recovery);
create index idx_qrtz_ft_j_g on qrtz_fired_triggers(sched_name, job_name, job_group);
create index idx_qrtz_ft_jg on qrtz_fired_triggers(sched_name, job_group);
create index idx_qrtz_ft_t_g on qrtz_fired_triggers(sched_name, trigger_name, trigger_group);
create index idx_qrtz_ft_tg on qrtz_fired_triggers(sched_name, trigger_group);

commit;