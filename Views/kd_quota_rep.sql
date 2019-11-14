CREATE OR REPLACE VIEW kd_quota_rep AS
WITH 
    rep_sales_days AS
        (
            SELECT
                            rep.rep_code,
                            rep.rep_name,
                            rep.region_code,
                            rep.start_date,
                            rep.end_date,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 1
                                        THEN days.total_sales_days
                                    END
                                ) AS m1_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 1
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m1_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 2
                                        THEN days.total_sales_days
                                    END 
                                ) AS m2_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 2
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m2_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 3
                                        THEN days.total_sales_days
                                    END 
                                ) AS m3_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 3
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m3_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 4
                                        THEN days.total_sales_days
                                    END 
                                ) AS m4_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 4
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m4_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 5
                                        THEN days.total_sales_days
                                    END 
                                ) AS m5_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 5
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m5_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 6
                                        THEN days.total_sales_days
                                    END 
                                ) AS m6_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 6
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m6_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 7
                                        THEN days.total_sales_days
                                    END 
                                ) AS m7_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 7
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m7_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 8
                                        THEN days.total_sales_days
                                    END 
                                ) AS m8_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 8
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m8_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 9
                                        THEN days.total_sales_days
                                    END 
                                ) AS m9_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 9
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m9_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 10
                                        THEN days.total_sales_days
                                    END 
                                ) AS m10_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 10
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m10_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 11
                                        THEN days.total_sales_days
                                    END 
                                ) AS m11_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 11
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m11_rep_sales_days,
                            MAX
                                (
                                    CASE
                                        WHEN days.month = 12
                                        THEN days.total_sales_days
                                    END 
                                ) AS m12_total_sales_days,
                            SUM
                                (
                                    CASE
                                        WHEN yc.day BETWEEN rep.start_date AND NVL(rep.end_date, TRUNC(SYSDATE))
                                            AND calendar_api.get_week_day(yc.day) NOT IN ('Saturday','Sunday') 
                                            AND yc.holiday IS NULL
                                            AND EXTRACT(MONTH FROM yc.day) = 12
                                        THEN 1
                                        ELSE 0
                                    END
                                ) AS m12_rep_sales_days
            FROM
                            kd_quota_rep_config rep,
                            kd_year_calendar yc
                            JOIN kd_work_days_per_month days
                                ON EXTRACT(MONTH FROM yc.day) = days.month
--            WHERE
--                            rep.end_date IS NULL
            GROUP BY
                            rep.rep_code,
                            rep.rep_name,
                            rep.region_code,
                            rep.start_date,
                            rep.end_date
            ORDER BY
                            rep.rep_code,
                            rep.start_date
        )

SELECT
                rwd.rep_code,
                rwd.rep_name,
                rwd.region_code,
                rwd.start_date,
                rwd.end_date,
                terr.product_type,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 1
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 1
                        AND rwd.end_date IS NULL
                    THEN terr.m1
                    ELSE ROUND((rwd.m1_rep_sales_days/rwd.m1_total_sales_days) * terr.m1,2) 
                END AS m1_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 2
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 2
                        AND rwd.end_date IS NULL
                    THEN
                        terr.m2
                    ELSE ROUND((rwd.m2_rep_sales_days/rwd.m2_total_sales_days) * terr.m2,2) 
                END AS m2_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 3
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 3
                        AND rwd.end_date IS NULL
                    THEN terr.m3
                    ELSE ROUND((rwd.m3_rep_sales_days/rwd.m3_total_sales_days) * terr.m3,2) 
                END AS m3_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 4
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 4
                        AND rwd.end_date IS NULL
                    THEN terr.m4
                    ELSE ROUND((rwd.m4_rep_sales_days/rwd.m4_total_sales_days) * terr.m4,2) 
                END AS m4_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 5
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 5
                        AND rwd.end_date IS NULL
                    THEN terr.m5
                    ELSE ROUND((rwd.m5_rep_sales_days/rwd.m5_total_sales_days) * terr.m5,2) 
                END AS m5_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 6
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 6
                        AND rwd.end_date IS NULL
                    THEN terr.m6
                    ELSE ROUND((rwd.m6_rep_sales_days/rwd.m6_total_sales_days) * terr.m6,2) 
                END AS m6_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 7 
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 7 
                        AND rwd.end_date IS NULL
                    THEN terr.m7
                    ELSE ROUND((rwd.m7_rep_sales_days/rwd.m7_total_sales_days) * terr.m7,2) 
                END AS m7_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 8
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 8
                        AND rwd.end_date IS NULL
                    THEN terr.m8
                    ELSE ROUND((rwd.m8_rep_sales_days/rwd.m8_total_sales_days) * terr.m8,2) 
                END AS m8_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 9 
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 9
                        AND rwd.end_date IS NULL
                    THEN terr.m9
                    ELSE ROUND((rwd.m9_rep_sales_days/rwd.m9_total_sales_days) * terr.m9,2) 
                END AS m9_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 10 
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 10 
                        AND rwd.end_date IS NULL
                    THEN terr.m10
                    ELSE ROUND((rwd.m10_rep_sales_days/rwd.m10_total_sales_days) * terr.m10,2) 
                END AS m10_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 11
                        AND EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 11
                        AND rwd.end_date IS NULL
                    THEN terr.m11
                    ELSE ROUND((rwd.m11_rep_sales_days/rwd.m11_total_sales_days) * terr.m11,2) 
                END AS m11_rep_quota,
                CASE
                    WHEN EXTRACT(MONTH FROM SYSDATE) <= 12 
                        AND 
                            (
                                EXTRACT(MONTH FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) != 12
                                    OR EXTRACT(YEAR FROM TO_DATE(rwd.start_date,'MM/DD/YYYY')) = EXTRACT(YEAR FROM SYSDATE)-1
                            )
                        AND rwd.end_date IS NULL
                    THEN terr.m12
                    ELSE ROUND((rwd.m12_rep_sales_days/rwd.m12_total_sales_days) * terr.m12,2) 
                END AS m12_rep_quota
                
FROM
                rep_sales_days rwd
                LEFT JOIN kd_quota_territory terr
                    ON rwd.rep_code = terr.territory_code
WHERE
                rwd.end_date IS NULL