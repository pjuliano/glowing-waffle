select
   rj.job_name,
   s.username,
   s.sid,
   s.serial#,
   p.spid,
   s.lockwait,
   s.logon_time,
   rj.elapsed_time
from 
   dba_scheduler_running_jobs rj,
   v$session s,
   v$process p
where
   rj.session_id = s.sid
and
   s.paddr = p.addr
order by
   rj.job_name;

alter system kill session '1069,15255';