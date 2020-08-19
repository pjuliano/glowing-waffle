CREATE OR REPLACE VIEW kd_svq2_comp_dm AS
SELECT
                dm.dm_code || 'DM-' || EXTRACT(YEAR FROM SYSDATE) AS record_id,
                dm.dm_code AS rep_code,
                dm.dm_name AS rep_name,
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
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 95
                    THEN SUM(svq.ytd_quota) * .95
                    ELSE SUM(svq.this_year) 
                END AS base_a,
                dm.rate_a,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 95
                    THEN (SUM(svq.ytd_quota) * .95) * (dm.rate_a / 100)
                    ELSE SUM(svq.this_year) * (dm.rate_a / 100)
                END AS payout_a,
                SUM(svq.this_year) -
                    CASE
                        WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 95
                        THEN SUM(svq.ytd_quota) * .95
                        ELSE SUM(svq.this_year)
                    END AS base_b,
                dm.rate_b,
                (
                    SUM(svq.this_year) -
                        CASE
                            WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 95
                            THEN SUM(ytd_quota) * .95
                            ELSE SUM(this_year)
                        END
                ) * (dm.rate_b / 100) AS payout_b,
                nvl(dm.jan_payout,0) + 
                    nvl(dm.feb_payout,0) + 
                    nvl(dm.mar_payout,0) + 
                    nvl(dm.apr_payout,0) + 
                    nvl(dm.may_payout,0) +
                    nvl(dm.jun_payout,0) +
                    nvl(dm.jul_payout,0) +
                    nvl(dm.aug_payout,0) +
                    nvl(dm.sep_payout,0) +
                    nvl(dm.oct_payout,0) +
                    nvl(dm.nov_payout,0) +
                    nvl(dm.dec_payout,0) AS ytd_paid,
                CASE
                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                    THEN (SUM(svq.ytd_quota) * .85) * (dm.rate_a / 100)
                    ELSE SUM(svq.this_year) * (dm.rate_a / 100)
                END + 
                    (
                        (
                            SUM(svq.this_year) - 
                                CASE 
                                    WHEN ROUND((SUM(svq.this_year) / SUM(svq.ytd_quota)) * 100,2) > 85
                                    THEN SUM(svq.ytd_quota) * .85
                                    ELSE SUM(svq.this_year)
                                END
                        ) * (dm.rate_b / 100)
                    ) - 
                    nvl(dm.jan_payout,0) - 
                    nvl(dm.feb_payout,0) - 
                    nvl(dm.mar_payout,0) - 
                    nvl(dm.apr_payout,0) - 
                    nvl(dm.may_payout,0) -
                    nvl(dm.jun_payout,0) -
                    nvl(dm.jul_payout,0) -
                    nvl(dm.aug_payout,0) -
                    nvl(dm.sep_payout,0) -
                    nvl(dm.oct_payout,0) -
                    nvl(dm.nov_payout,0) -
                    nvl(dm.dec_payout,0) AS cm_payout                    
FROM
                kd_svq2 svq
                JOIN kd_svq2_dm_config dm
                    ON svq.salesman_code = dm.rep_code
                LEFT JOIN kd_svq2_territory_quota tq
                    ON svq.salesman_code = tq.territory_code
GROUP BY
                dm.dm_code || 'DM-' || EXTRACT(YEAR FROM SYSDATE),
                dm.dm_code,
                dm.dm_name,
                dm.rate_a,
                dm.rate_b,
                nvl(dm.jan_payout,0),
                nvl(dm.feb_payout,0),
                nvl(dm.mar_payout,0),
                nvl(dm.apr_payout,0),
                nvl(dm.may_payout,0),
                nvl(dm.jun_payout,0),
                nvl(dm.jul_payout,0),
                nvl(dm.aug_payout,0),
                nvl(dm.sep_payout,0),
                nvl(dm.oct_payout,0),
                nvl(dm.nov_payout,0),
                nvl(dm.dec_payout,0)