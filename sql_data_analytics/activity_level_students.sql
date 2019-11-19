WITH


teachers AS (
select a.*, date(b.created_at) as group_created_at, DATE_ADD(date(b.created_at), INTERVAL 6 month) end_date
from (
 select distinct date(timestamp) timestamp, player_id, group_id
 from (
   select *
   from `classcraft-dev.tests_simon.power_usage`
 )
) as a
left join `classcraft-dev.game_activities.groups` as b
on a.group_id = b.group_id
where timestamp between date_add(date(b.created_at), interval 0 month) and date_add(date(b.created_at), interval 1 month)


),


filter AS (
 select timestamp, player_id, lag(timestamp,1) over (partition by player_id order by timestamp ASC) previous_time
 from (
   select *
   from teachers
   union all
   select group_created_at, player_id, group_id, group_created_at, end_date
   from (select distinct player_id, group_id, group_created_at, end_date from teachers)
   union all
   select end_date, player_id, group_id, group_created_at, end_date
   from (select distinct player_id,  group_id, group_created_at, end_date from teachers)
   )
 ),



lags AS (
 select timestamp, player_id, previous_time, DATE_DIFF(timestamp, previous_time, day) difference_days
 from filter
 ),


engagement AS (
 select player_id, count(*) - 2 frequency, stddev(difference_days) std_dev, (1/stddev(difference_days) * (count(*) -2)) engagement_score
 from lags
 group by player_id
 ),


formula AS (
 select player_id,
   case
     when frequency = 1 then 0
     else engagement_score
 end as engagement_index
 from engagement
 )


select *
from formula
order by engagement_index
