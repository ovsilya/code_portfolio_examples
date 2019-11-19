SELECT 

A.teacher_id, 
A.trial, 
A.total_students, 
EXTRACT(DAYOFYEAR FROM A.account_created_at) AS account_created_dayofyear, 
A.xp, A.hp, 
A.random_event,	
A.random_picker, 
A.message,	
A.objective_completion,
A.objective_creation, 
A.quest_creation,	
A.quest_importation, 
A.discussion_comment, 
A.assignment_feedback,
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
MAX(trial) AS trial,
MIN(total_students) AS  total_students, 
MIN(account_created_at) AS  account_created_at, 
-- MIN(DATE) AS first_day_played,
SUM(xp) AS  xp, 
SUM(hp) AS  hp, 
SUM(random_event) AS  random_event,	
SUM(random_picker) AS  random_picker,	
SUM(message) AS  message,	

SUM(objective_completion) AS  objective_completion,	
SUM(objective_creation) AS  objective_creation,	
SUM(quest_creation) AS  quest_creation,	
SUM(quest_importation) AS  quest_importation,	

SUM(discussion_comment) AS  discussion_comment,	

SUM(assignment_feedback) AS  assignment_feedback, 

SUM(power_usage) AS power_usage,
SUM(gear_equipping) AS gear_equipping,
SUM(gear_item_purchase) AS gear_item_purchase,
SUM(per_training) AS per_training,
SUM(level_up) AS level_up,

MIN(date_for_7day) AS  date_for_day_7
FROM `classcraft-dev.Ilya_OVS_dataset.train_data_ungrouped`
GROUP BY teacher_id) AS A
LEFT JOIN `classcraft-dev.game_activities.subscription_status_log` as B
ON A.teacher_id = B.teacher_id and A.date_for_day_7 = B.date
