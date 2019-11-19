SELECT DISTINCT a.teacher_id, a.date,  (DATE_DIFF(a.date, DATE(created_at), DAY)+1)
                                       - (DATE_DIFF(a.date, DATE(created_at), WEEK) * 2)
                                       - (case when EXTRACT(DAYOFWEEK FROM created_at) = 7 then 1 else 0 end) 
                                       - (case when EXTRACT(DAYOFWEEK FROM a.date) = 1 then 1 else 0 end)
                                       AS days_since_account_creation, 
IFNULL(plan, "freemium") AS plan, 
account_created_at, 
trial, 
premium, 
IFNULL(total_students, 0) total_students, 
IFNULL(highest_median_level_increase, 0) highest_median_level_increase, 
IFNULL(assignment_feedback, 0) assignment_feedback, 
IFNULL(boss_battle, 0) boss_battle, 
IFNULL(countdown, 0) countdown,  
IFNULL(gradebook, 0) gradebook, 
IFNULL(message, 0) message, 
IFNULL(random_event, 0) random_event, 
IFNULL(random_picker, 0) random_picker, 
IFNULL(stopwatch, 0) stopwatch, 
IFNULL(volume_meter, 0) volume_meter, 
IFNULL(xp, 0) xp, 
IFNULL(hp, 0) hp, 
IFNULL(gp, 0) gp, 
IFNULL(objective_completion, 0) objective_completion, 
IFNULL(objective_creation, 0) objective_creation, 
IFNULL(quest_creation, 0) quest_creation, 
IFNULL(quest_importation, 0) quest_importation,

IFNULL(discussion_comment, 0) discussion_comment,
IFNULL(power_usage, 0) power_usage,
IFNULL(gear_equipping, 0) gear_equipping,
IFNULL(gear_item_purchase, 0) gear_item_purchase,
IFNULL(per_training, 0) per_training,
IFNULL(level_up, 0) level_up

FROM (
 SELECT teacher_id, date, # assignment_feedback, boss_battle, countdown, discussion_comment, gradebook, message, random_event, random_picker, stopwatch, volume_meter
   SUM(IF(activity_type LIKE "%xp_modification", count, null)) xp,
   SUM(IF(activity_type LIKE "%hp_modification", count, null)) hp,
   SUM(IF(activity_type LIKE "%gp_modification", count, null)) gp,
   SUM(IF(activity_type LIKE "%objective_completion", count, null)) objective_completion,
   SUM(IF(activity_type LIKE "%objective_creation", count, null)) objective_creation,
   SUM(IF(activity_type LIKE "%quest_creation", count, null)) quest_creation,
   SUM(IF(activity_type LIKE "%quest_importation", count, null)) quest_importation,
   SUM(IF(activity_type LIKE "%assignment_feedback", count, null)) assignment_feedback,
   SUM(IF(activity_type LIKE "%boss_battle", count, null)) boss_battle,
   SUM(IF(activity_type LIKE "%countdown", count, null)) countdown,
   SUM(IF(activity_type LIKE "%gradebook", count, null)) gradebook,
   SUM(IF(activity_type LIKE "%message", count, null)) message,
   SUM(IF(activity_type LIKE "%random_event", count, null)) random_event,
   SUM(IF(activity_type LIKE "%random_picker", count, null)) random_picker,
   SUM(IF(activity_type LIKE "%stopwatch", count, null)) stopwatch,
   SUM(IF(activity_type LIKE "%volume_meter", count, null)) volume_meter,


   SUM(IF(activity_type LIKE "%discussion_comment", count, null)) discussion_comment,
   SUM(IF(activity_type LIKE "%power_usage", count, null)) power_usage,
   SUM(IF(activity_type LIKE "%gear_equipping", count, null)) gear_equipping,
   SUM(IF(activity_type LIKE "%gear_item_purchase", count, null)) gear_item_purchase,
   SUM(IF(activity_type LIKE "%per_training", count, null)) per_training,
   SUM(IF(activity_type LIKE "%level_up", count, null)) level_up



 FROM `classcraft-dev.tests_simon.all_recorded_activity`
 WHERE teacher_id IS NOT NULL
 GROUP BY teacher_id, date) a
LEFT JOIN `classcraft-dev.tests_simon.teachers` b
ON a.teacher_id = b.teacher_id
LEFT JOIN `classcraft-dev.game_activities.subscription_status_log` c
ON a.teacher_id = c.teacher_id AND a.date = c.date
LEFT JOIN (
 SELECT teacher_id, ANY_VALUE(account_created_at) AS account_created_at, ANY_VALUE(trial) AS trial, ANY_VALUE(premium) AS premium, SUM(num_students) AS total_students, MAX(median_level_increase) AS highest_median_level_increase
 FROM `classcraft-dev.tests_simon.active_teachers`
 GROUP BY teacher_id) d
ON a.teacher_id = d.teacher_id
ORDER BY teacher_id, date
