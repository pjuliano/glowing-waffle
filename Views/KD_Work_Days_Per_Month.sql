CREATE OR REPLACE VIEW kd_work_days_per_month AS
SELECT
                EXTRACT(MONTH FROM yc.day) AS month,
                COUNT(EXTRACT(MONTH FROM yc.day)) total_days,
                SUM
                    (
                        CASE
                            WHEN yc.weekday IN ('Saturday','Sunday')
                            THEN 0
                            ELSE 1
                        END
                    ) AS weekdays,
                SUM
                    (
                        CASE
                            WHEN yc.holiday IS NOT NULL
                            THEN 1
                            ELSE 0
                        END
                    ) AS holidays,
                SUM
                    (
                        CASE
                            WHEN yc.weekday IN ('Saturday','Sunday')
                            THEN 0
                            ELSE 1
                        END
                    ) -
                SUM
                    (
                        CASE
                            WHEN yc.holiday IS NOT NULL
                            THEN 1
                            ELSE 0
                        END
                    ) AS total_sales_days,
                SUM
                    (
                        CASE
                            WHEN yc.day BETWEEN to_date('01/' || EXTRACT(DAY FROM yc.day) || '/' || EXTRACT(YEAR FROM sysdate),'MM/DD/YYYY') AND trunc(sysdate) 
                                AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                AND yc.holiday IS NULL
                            THEN 1
                            ELSE 0
                        END
                    ) AS elapsed_work_days
FROM
                kd_year_calendar yc
GROUP BY
                EXTRACT(MONTH FROM yc.day)
ORDER BY
                EXTRACT(MONTH FROM yc.day);