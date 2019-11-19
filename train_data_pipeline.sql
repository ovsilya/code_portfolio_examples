SELECT 

A.teacher_id, 
A.total_students, 
EXTRACT(DAYOFYEAR FROM A.account_created_at) AS account_created_dayofyear, 
A.xp, A.hp, 
A.random_event,	
A.random_picker, 
A.message,	
A.discussion_comment,
A.power_usage,
A.gear_equipping,
A.gear_item_purchase,
A.per_training,
A.level_up,

CASE
  WHEN B.plan IS NULL THEN "freemium"
  ELSE B.plan END AS label

FROM(
SELECT 
teacher_id,
MIN(total_students) AS  total_students, 
MIN(account_created_at) AS  account_created_at, 
SUM(xp) AS  xp, 
SUM(hp) AS  hp, 
SUM(random_event) AS  random_event,	
SUM(random_picker) AS  random_picker,	
SUM(message) AS  message,		
SUM(discussion_comment) AS  discussion_comment,	 
SUM(power_usage) AS power_usage,
SUM(gear_equipping) AS gear_equipping,
SUM(gear_item_purchase) AS gear_item_purchase,
SUM(per_training) AS per_training,
SUM(level_up) AS level_up
FROM `classcraft-dev.Ilya_OVS_dataset.train_data_ungrouped_pipeline`
GROUP BY teacher_id) AS A
LEFT JOIN `classcraft-dev.game_activities.subscription_status_log` as B
ON A.teacher_id = B.teacher_id and B.date = "2018-10-22"