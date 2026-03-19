select '| Operation and options            |  Object  | cost     | cpu_cost | io_cost  |' as "Plan Table" from dual
union all
select '--------------------------------------------------------------------------------' from dual
union all
select * from
(select
       rpad('| '||substr(lpad(' ',1*(level-1))||operation||
            decode(options, null,'',' '||options), 1, 35), 35, ' ')||'|'||
       rpad(substr(object_name||' ',1, 9), 10, ' ')||'| ' ||
       cast(cost as char(9)) ||'|' || 
       cast(cpu_cost as char(10)) ||'| ' ||
       cast(io_cost as char(9))||'|' 
        as "Explain plan"
from plan_table
start with id=0 and timestamp = (select max(timestamp) from plan_table
                                 where id=0)
connect by prior id = parent_id
        and prior nvl(statement_id, ' ') = nvl(statement_id, ' ')
        and prior timestamp <= timestamp
order by id, position)
union all
select '--------------------------------------------------------------------------------' from dual
/