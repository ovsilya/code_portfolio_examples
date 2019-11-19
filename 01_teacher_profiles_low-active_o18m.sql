SELECT teacher_id,  retention_level, profile_type, school_type,  school_level
FROM(
SELECT date, teacher_id, retention_level, profile_type,
                                                 CASE
                                                  WHEN subscription_plan IS NULL THEN "free"
                                                  WHEN subscription_plan = "yearly_premium" THEN "yearly_premium"
                                                  WHEN subscription_plan = "monthly_premium" THEN "monthly_premium"
                                                  WHEN subscription_plan = "organization" THEN "organization"
                                                  WHEN subscription_plan = "enterprise_monthly_premium" THEN "enterprise_monthly_premium"
                                                  WHEN subscription_plan = "license" THEN "license"
                                                  END AS subscription_plan, school_type, school_level, grade,subject, created_at
  FROM(
SELECT ab.date, ab.teacher_id, ab.retention_level, 
                                                CASE
                                                  WHEN ab.subscription_plan IS NULL THEN "teacher"
                                                  WHEN ab.subscription_plan = "yearly_premium" THEN "teacher"
                                                  WHEN ab.subscription_plan = "monthly_premium" THEN "teacher"
                                                  WHEN ab.subscription_plan = "organization" THEN "organization"
                                                  WHEN ab.subscription_plan = "enterprise_monthly_premium" THEN "organization"
                                                  WHEN ab.subscription_plan = "license" THEN "teacher"
                                                  END AS profile_type,
                                                ab.subscription_plan, d.type as school_type, d.level as school_level, e.grade as grade, e.subject as subject, date(c.created_at) as created_at
  FROM(
SELECT *
  FROM(
SELECT b.date, a.teacher_id, a.retention_level, 
                                      b.plan as subscription_plan 
FROM (SELECT *
  FROM(
    SELECT teacher_id, COUNT(DISTINCT(time)) as days_of_activity, "over 18 months" as retention_level
    FROM `classcraft-dev.game_activities.all_activities_fall`
    WHERE retention_level = "over 18 months"
    GROUP BY teacher_id)
  WHERE days_of_activity = 1) as a
  LEFT JOIN `classcraft-dev.game_activities.subscription_status_log` as b
  ON a.teacher_id = b.teacher_id)
GROUP BY date, teacher_id, retention_level, subscription_plan) as ab
LEFT JOIN `classcraft-dev.game_activities.teachers` as c
ON ab.teacher_id = c.teacher_id
LEFT JOIN `classcraft-dev.game_activities.schools` as d
ON c.school_id = d.school_id
LEFT JOIN `classcraft-dev.game_activities.groups` as e
ON ab.teacher_id = e.teacher_id)
GROUP BY date,  teacher_id, retention_level, profile_type, subscription_plan,  school_type,  school_level, grade,  subject, created_at
ORDER BY teacher_id)
GROUP BY teacher_id,  retention_level, profile_type, school_type,  school_level