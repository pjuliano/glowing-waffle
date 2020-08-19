CREATE OR REPLACE VIEW kd_svq2_comp_sp AS
SELECT
                sp.sp_code || 'SP-' || EXTRACT(YEAR FROM SYSDATE) AS record_id,
                sp.sp_code AS rep_code,
                sp.sp_name AS rep_name,
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
                sp.rate_a,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                    THEN (SUM(svq.ytd_quota) * .85) * (sp.rate_a / 100)
                    ELSE SUM(svq.this_year) * (sp.rate_a / 100)
                END AS payout_a,
                SUM(svq.this_year) -
                    CASE
                        WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                        THEN SUM(svq.ytd_quota) * .85
                        ELSE SUM(svq.this_year)
                    END AS base_b,
                sp.rate_b,
                (
                    SUM(svq.this_year) -
                        CASE
                            WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                            THEN SUM(ytd_quota) * .85
                            ELSE SUM(this_year)
                        END
                ) * (sp.rate_b / 100) AS payout_b,
                
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                    THEN SUM(svq.this_year) - SUM(svq.ytd_quota)
                    ELSE 0
                END AS base_c,
                '1.5' AS rate_c,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                    THEN SUM(svq.this_year) - SUM(svq.ytd_quota)
                    ELSE 0
                END * 0.015 AS payout_c_qe,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                    THEN SUM(svq.this_year) - SUM(svq.ytd_quota)
                    ELSE 0
                END * 0.01 AS payout_c_ye,
                nvl(sp.jan_payout,0) + 
                    nvl(sp.feb_payout,0) + 
                    nvl(sp.mar_payout,0) + 
                    nvl(sp.apr_payout,0) + 
                    nvl(sp.may_payout,0) +
                    nvl(sp.jun_payout,0) +
                    nvl(sp.jul_payout,0) +
                    nvl(sp.aug_payout,0) +
                    nvl(sp.sep_payout,0) +
                    nvl(sp.oct_payout,0) +
                    nvl(sp.nov_payout,0) +
                    nvl(sp.dec_payout,0) AS ytd_paid,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                    THEN (SUM(svq.ytd_quota) * .85) * (sp.rate_a / 100)
                    ELSE SUM(svq.this_year) * (sp.rate_a / 100)
                END + 
                    (
                        (
                            SUM(svq.this_year) - 
                                CASE 
                                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                                    THEN SUM(svq.ytd_quota) * .85
                                    ELSE SUM(svq.this_year)
                                END
                        ) * (sp.rate_b / 100)
                    ) - 
                    nvl(sp.jan_payout,0) - 
                    nvl(sp.feb_payout,0) - 
                    nvl(sp.mar_payout,0) - 
                    nvl(sp.apr_payout,0) - 
                    nvl(sp.may_payout,0) -
                    nvl(sp.jun_payout,0) -
                    nvl(sp.jul_payout,0) -
                    nvl(sp.aug_payout,0) -
                    nvl(sp.sep_payout,0) -
                    nvl(sp.oct_payout,0) -
                    nvl(sp.nov_payout,0) -
                    nvl(sp.dec_payout,0) AS cm_payout,
                (
                    CASE
                        WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 100
                        THEN SUM(svq.this_year) - SUM(ytd_quota)
                        ELSE 0
                    END * 0.015
                ) - 
                    nvl(sp.q1_payout,0) -
                    nvl(sp.q2_payout,0) -
                    nvl(sp.q3_payout,0) -
                    nvl(sp.q4_payout,0) AS cqe_payout
FROM
                kd_svq2 svq
                JOIN kd_svq2_sp_config sp
                    ON svq.salesman_code = sp.rep_code
                LEFT JOIN kd_svq2_territory_quota tq
                    ON svq.salesman_code = tq.territory_code
GROUP BY
                sp.sp_code || 'SP-' || EXTRACT(YEAR FROM SYSDATE),
                sp.sp_code,
                sp.sp_name,
                sp.rate_a,
                sp.rate_b,
                nvl(sp.jan_payout,0),
                nvl(sp.feb_payout,0), 
                nvl(sp.mar_payout,0), 
                nvl(sp.apr_payout,0),  
                nvl(sp.may_payout,0),
                nvl(sp.jun_payout,0),
                nvl(sp.jul_payout,0),
                nvl(sp.aug_payout,0),
                nvl(sp.sep_payout,0),
                nvl(sp.oct_payout,0),
                nvl(sp.nov_payout,0),
                nvl(sp.dec_payout,0),
                nvl(sp.q1_payout,0),
                nvl(sp.q2_payout,0),
                nvl(sp.q3_payout,0),
                nvl(sp.q4_payout,0)