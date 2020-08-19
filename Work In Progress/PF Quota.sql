CREATE OR REPLACE VIEW kd_pvq AS 
SELECT
                sc.sales_market,
                sc.segment,
                sc.product_type,
                sc.product_brand,
                sc.part_product_family,
                ROUND (SUM
                                (
                                CASE
                                                WHEN sc.invoice_date = TRUNC (SYSDATE)
                                                THEN sc.total_price_usd
                                                ELSE 0
                                END
                                )
                ,0) AS today,
                ROUND (SUM
                                (
                                CASE
                                                WHEN sc.invoice_month = EXTRACT (MONTH FROM SYSDATE)
                                                THEN sc.total_price_usd
                                                ELSE 0
                                END
                                )
                ,0) AS this_month,
                DECODE (EXTRACT (MONTH FROM SYSDATE),
                                        1,pfq.m1,
                                        2,pfq.m2,
                                        3,pfq.m3,
                                        4,pfq.m4,
                                        5,pfq.m5,
                                        6,pfq.m6,
                                        7,pfq.m7,
                                        8,pfq.m8,
                                        9,pfq.m9,
                                        10,pfq.m10,
                                        11,pfq.m11,
                                        12,pfq.m12,0) AS month_quota,
                ROUND ( (ROUND (SUM
                                (
                                CASE
                                                WHEN sc.invoice_month = EXTRACT (MONTH FROM SYSDATE)
                                                THEN sc.total_price_usd
                                                ELSE 0
                                END
                                )
                ,0) / DECODE (EXTRACT (MONTH FROM SYSDATE),
                                              1,pfq.m1,
                                              2,pfq.m2,
                                              3,pfq.m3,
                                              4,pfq.m4,
                                              5,pfq.m5,
                                              6,pfq.m6,
                                              7,pfq.m7,
                                              8,pfq.m8,
                                              9,pfq.m9,
                                              10,pfq.m10,
                                              11,pfq.m11,
                                              12,pfq.m12,0)) * 100,2) AS month_quota_achievement,
                ROUND (SUM
                                (
                                CASE
                                                WHEN sc.invoice_month = EXTRACT (MONTH FROM SYSDATE)
                                                THEN sc.total_price_usd
                                                ELSE 0
                                END
                                )
                / NULLIF (wd.elapsed_work_days,0),0) AS daily_average_this_month,
                ROUND (SUM
                                (
                                CASE
                                                WHEN sc.invoice_quarter = TO_CHAR (SYSDATE,'Q')
                                                THEN sc.total_price_usd
                                                ELSE 0
                                END
                                )
                ,0) AS this_quarter,
                DECODE (to_number (TO_CHAR (SYSDATE,'Q')),
                                        1,pfq.m1 + pfq.m2 + pfq.m3,
                                        2,pfq.m4 + pfq.m5 + pfq.m6,
                                        3,pfq.m7 + pfq.m8 + pfq.m9,
                                        4,pfq.m10 + pfq.m11 + pfq.m12,0) AS quarter_quota,
                ROUND ( (ROUND (SUM
                                (
                                CASE
                                                WHEN sc.invoice_quarter = TO_CHAR (SYSDATE,'Q')
                                                THEN sc.total_price_usd
                                                ELSE 0
                                END
                                )
                ,0) / DECODE (to_number (TO_CHAR (SYSDATE,'Q')),
                                              1,pfq.m1 + pfq.m2 + pfq.m3,
                                              2,pfq.m4 + pfq.m5 + pfq.m6,
                                              3,pfq.m7 + pfq.m8 + pfq.m9,
                                              4,pfq.m10 + pfq.m11 + pfq.m12,0)) * 100,2) AS quarter_quota_achievement,
                ROUND (SUM (sc.total_price_usd),0) AS this_year,
                pfq.m1 + pfq.m2 + pfq.m3 + pfq.m4 + pfq.m5 + pfq.m6 + pfq.m7 + pfq.m8 + pfq.m9 + pfq.m10 + pfq.m11 + pfq.m12 AS year_quota,
                ROUND ( (ROUND (SUM (sc.total_price_usd),0) / (pfq.m1 + pfq.m2 + pfq.m3 + pfq.m4 + pfq.m5 + pfq.m6 + pfq.m7 + pfq.m8 + pfq.m9 + pfq.m10 + pfq.m11 + pfq.m12)) * 100,2) AS year_quota_achievement
FROM
                kd_pf_quota pfq
                FULL OUTER JOIN kd_sales_cube sc
                ON              pfq.sales_market = sc.sales_market
                                AND pfq.segment = sc.segment
                                AND pfq.part_product_family = sc.part_product_family
                LEFT JOIN kd_work_days_per_month wd
                ON              wd.month = EXTRACT (MONTH FROM SYSDATE)
WHERE
                invoice_year = EXTRACT (YEAR FROM SYSDATE)
GROUP BY
                sc.sales_market,
                sc.segment,
                sc.product_type,
                sc.product_brand,
                sc.part_product_family,
                DECODE (EXTRACT (MONTH FROM SYSDATE),
                                        1,pfq.m1,
                                        2,pfq.m2,
                                        3,pfq.m3,
                                        4,pfq.m4,
                                        5,pfq.m5,
                                        6,pfq.m6,
                                        7,pfq.m7,
                                        8,pfq.m8,
                                        9,pfq.m9,
                                        10,pfq.m10,
                                        11,pfq.m11,
                                        12,pfq.m12,0),
                DECODE (EXTRACT (MONTH FROM SYSDATE),
                                        1,pfq.m1,
                                        2,pfq.m2,
                                        3,pfq.m3,
                                        4,pfq.m4,
                                        5,pfq.m5,
                                        6,pfq.m6,
                                        7,pfq.m7,
                                        8,pfq.m8,
                                        9,pfq.m9,
                                        10,pfq.m10,
                                        11,pfq.m11,
                                        12,pfq.m12,0),
                NULLIF (wd.elapsed_work_days,0),
                DECODE (to_number (TO_CHAR (SYSDATE,'Q')),
                                        1,pfq.m1 + pfq.m2 + pfq.m3,
                                        2,pfq.m4 + pfq.m5 + pfq.m6,
                                        3,pfq.m7 + pfq.m8 + pfq.m9,
                                        4,pfq.m10 + pfq.m11 + pfq.m12,0),
                DECODE (to_number (TO_CHAR (SYSDATE,'Q')),
                                        1,pfq.m1 + pfq.m2 + pfq.m3,
                                        2,pfq.m4 + pfq.m5 + pfq.m6,
                                        3,pfq.m7 + pfq.m8 + pfq.m9,
                                        4,pfq.m10 + pfq.m11 + pfq.m12,0),
                pfq.m1 + pfq.m2 + pfq.m3 + pfq.m4 + pfq.m5 + pfq.m6 + pfq.m7 + pfq.m8 + pfq.m9 + pfq.m10 + pfq.m11 + pfq.m12
ORDER BY
                sc.sales_market,
                sc.segment,
                sc.product_type,
                sc.product_brand,
                sc.part_product_family