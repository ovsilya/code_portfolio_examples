WITH
teachers AS (
select a.*, date(b.created_at) as account_created_at, DATE_ADD(date(b.created_at), INTERVAL 6 month) end_date
from (
 select distinct date(timestamp) timestamp, teacher_id
 from (
   select *
   from `classcraft-dev.tests_simon.xp_modification`
   union all
   select *
   from `classcraft-dev.tests_simon.hp_modification`
   union all
   select *
   from `classcraft-dev.tests_simon.gp_modification`
 )
where context = "statModification"
) as a
left join `classcraft-dev.tests_simon.teachers` as b
on a.teacher_id = b.teacher_id
where timestamp between date_add(date(b.created_at), interval 0 month) and date_add(date(b.created_at), interval 6 month)
),
filter AS (
 select timestamp, teacher_id, lag(timestamp,1) over (partition by teacher_id order by timestamp ASC) previous_time
 from (
   select *
   from teachers
   union all
   select account_created_at, teacher_id, account_created_at, end_date
   from (select distinct teacher_id, account_created_at, end_date from teachers)
   union all
   select end_date timestamp, teacher_id, account_created_at, end_date
   from (select distinct teacher_id, account_created_at, end_date from teachers)
   )
 ),
lags AS (
 select timestamp, teacher_id, previous_time, DATE_DIFF(timestamp, previous_time, day) difference_days
 from filter
 ),
engagement AS (
 select teacher_id, count(*) - 2 frequency, stddev(difference_days) std_dev, (1/stddev(difference_days) * (count(*) -2)) engagement_score
 from lags
 group by teacher_id
 ),
formula AS (
 select teacher_id,
   case
     when frequency = 1 then 0
     else engagement_score
 end as engagement_index
 from engagement
 )
select *,
  case
    when engagement_index >= 0 and engagement_index <= 0.534759 then "low_active"
    when engagement_index > 0.534759  and engagement_index <= 6.858288 then "medium_active"
    when engagement_index > 6.858288 then "high_active"
    end as activity_level_behaviour

from formula
order by engagement_index
