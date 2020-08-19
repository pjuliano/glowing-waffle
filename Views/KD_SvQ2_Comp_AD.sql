CREATE OR REPLACE VIEW kd_svq2_comp_ad AS
SELECT
                reg.rep_code || '-' || EXTRACT(YEAR FROM SYSDATE) AS record_id,
                reg.rep_code,
                reg.manager AS rep_name,
                SUM(tq.m1) AS quota_jan,
                SUM(tq.m2) AS quota_feb,
                SUM(tq.m3) AS quota_mar,
                SUM(tq.m4) AS quota_apr,
                SUM(tq.m5) AS quota_may,
                SUM(tq.m6) AS quota_jun,
                SUM(tq.m7) AS quota_jul,
                SUM(tq.m8) AS quota_aug,
                SUM(tq.m9) AS quota_sep,
                SUM(tq.m10) AS quota_oct,
                SUM(tq.m11) AS quota_nov,
                SUM(tq.m12) AS quota_dec,
                SUM(svq.ytd_quota) AS ytd_quota,
                SUM(svq.this_year) AS ytd_sales,
                SUM(svq.this_year) - SUM(svq.ytd_quota) AS ytd_over_under,
                ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) AS ytd_quota_pct,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                    THEN SUM(svq.ytd_quota) * .85
                    ELSE SUM(svq.this_year)
                END AS base_a,
                reg.rate_a,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                    THEN (SUM(svq.ytd_quota) * .85) * (reg.rate_a / 100) 
                    ELSE SUM(svq.this_year) * (reg.rate_a / 100) 
                END AS payout_a,
                SUM(svq.this_year) - 
                    CASE
                        WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                        THEN SUM(svq.ytd_quota) * .85
                        ELSE SUM(svq.this_year)
                    END AS base_b,
                reg.rate_b,
                (
                    SUM(svq.this_year) - 
                        CASE
                            WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                            THEN SUM(ytd_quota) * .85
                            ELSE SUM(svq.this_year)
                        END
                ) * (reg.rate_b / 100) AS payout_b,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                    THEN SUM(svq.this_year) - SUM(svq.ytd_quota)
                    ELSE 0
                END AS base_c,
                '3.75' AS rate_c,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                    THEN SUM(svq.this_year) - SUM(svq.ytd_quota)
                    ELSE 0
                END * 0.0375 AS payout_c_qe,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                    THEN SUM(svq.this_year) - SUM(svq.ytd_quota)
                    ELSE 0
                END * 0.0125 AS payout_c_ye,
                nvl(reg.jan_payout,0) + 
                    nvl(reg.feb_payout,0) + 
                    nvl(reg.mar_payout,0) + 
                    nvl(reg.apr_payout,0) + 
                    nvl(reg.may_payout,0) +
                    nvl(reg.jun_payout,0) +
                    nvl(reg.jul_payout,0) +
                    nvl(reg.aug_payout,0) +
                    nvl(reg.sep_payout,0) +
                    nvl(reg.oct_payout,0) +
                    nvl(reg.nov_payout,0) +
                    nvl(reg.dec_payout,0) AS ytd_paid,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                    THEN (SUM(svq.ytd_quota) * .85) * (reg.rate_a / 100)
                    ELSE SUM(svq.this_year) * (reg.rate_a / 100)
                END + 
                    (
                        (
                            SUM(svq.this_year) - 
                                CASE 
                                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                                    THEN SUM(svq.ytd_quota) * .85
                                    ELSE SUM(svq.this_year)
                                END
                        ) * (reg.rate_b / 100)
                    ) - 
                    nvl(reg.jan_payout,0) - 
                    nvl(reg.feb_payout,0) - 
                    nvl(reg.mar_payout,0) - 
                    nvl(reg.apr_payout,0) - 
                    nvl(reg.may_payout,0) -
                    nvl(reg.jun_payout,0) -
                    nvl(reg.jul_payout,0) -
                    nvl(reg.aug_payout,0) -
                    nvl(reg.sep_payout,0) -
                    nvl(reg.oct_payout,0) -
                    nvl(reg.nov_payout,0) -
                    nvl(reg.dec_payout,0) AS cm_payout,
                (
                    CASE
                        WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                        THEN SUM(svq.this_year) - SUM(ytd_quota)
                        ELSE 0
                    END * 0.0375
                ) - 
                    nvl(reg.q1_payout,0) -
                    nvl(reg.q2_payout,0) -
                    nvl(reg.q3_payout,0) -
                    nvl(reg.q4_payout,0) AS cqe_payout
FROM
                kd_svq2 svq
                LEFT JOIN kd_svq2_rep_config rep
                    ON svq.salesman_code = rep.rep_code
                        AND 
                            (
                                svq.end_date = rep.end_date
                                    OR 
                                        (
                                            svq.end_date IS NULL
                                                AND rep.end_date IS NULL
                                        )
                            )
                LEFT JOIN kd_svq2_region_config reg
                    ON rep.region_code = reg.region_code
                LEFT JOIN kd_svq2_territory_quota tq
                    ON svq.salesman_code = tq.territory_code
GROUP BY
                reg.rep_code || '-' || EXTRACT(YEAR FROM SYSDATE),
                reg.rep_code,
                reg.manager,
                reg.rate_a,
                reg.rate_b,
                nvl(reg.jan_payout,0), 
                nvl(reg.feb_payout,0),
                nvl(reg.mar_payout,0),
                nvl(reg.apr_payout,0),
                nvl(reg.may_payout,0),
                nvl(reg.jun_payout,0),
                nvl(reg.jul_payout,0), 
                nvl(reg.aug_payout,0),
                nvl(reg.sep_payout,0),
                nvl(reg.oct_payout,0),
                nvl(reg.nov_payout,0),
                nvl(reg.dec_payout,0),
                nvl(reg.q1_payout,0),
                nvl(reg.q2_payout,0),
                nvl(reg.q3_payout,0),
                nvl(reg.q4_payout,0)