--CREATE OR REPLACE VIEW kd_svq2_comp AS
SELECT
                svq.salesman_code || '-' || EXTRACT(YEAR FROM SYSDATE) AS record_id,
                svq.salesman_code AS rep_code,
                svq.rep_name,
                quota.jan AS quota_jan,
                quota.feb AS quota_feb,
                quota.mar AS quota_mar,
                quota.apr AS quota_apr,
                quota.may AS quota_may,
                quota.june AS quota_jun,
                quota.july AS quota_jul,
                quota.aug AS quota_aug,
                quota.sept AS quota_sep,
                quota.oct AS quota_oct,
                quota.nov AS quota_nov,
                quota.dec AS quota_dec,
                svq.ytd_quota,
                svq.this_year AS ytd_sales,
                svq.this_year - svq.ytd_quota AS ytd_over_under,
                svq.ytd_quota_pct,
                CASE
                    WHEN svq.ytd_quota_pct > 85
                    THEN svq.ytd_quota * .85
                    ELSE svq.this_year
                END AS base_a,
                config.rate_a,
                CASE
                    WHEN svq.ytd_quota_pct > 85
                    THEN (svq.ytd_quota * .85) * (config.rate_a / 100)
                    ELSE svq.this_year * (config.rate_a / 100)
                END AS payout_a,
                svq.this_year - 
                    CASE
                        WHEN svq.ytd_quota_pct > 85
                        THEN svq.ytd_quota * .85
                        ELSE svq.this_year
                    END AS base_b,
                config.rate_b,
                (
                    svq.this_year - 
                        CASE
                            WHEN svq.ytd_quota_pct > 85
                            THEN svq.ytd_quota * .85
                            ELSE svq.this_year
                        END
                ) * (config.rate_b / 100) AS payout_b,
                CASE 
                    WHEN svq.ytd_quota_pct > 100
                    THEN svq.this_year - svq.ytd_quota
                    ELSE 0
                END AS base_c,
                '7.5' AS rate_c,
                CASE 
                    WHEN svq.ytd_quota_pct > 100
                    THEN svq.this_year - svq.ytd_quota
                    ELSE 0
                END * .075 AS payout_c_qe,
                CASE 
                    WHEN svq.ytd_quota_pct > 100
                    THEN svq.this_year - svq.ytd_quota
                    ELSE 0
                END * .025 AS payout_c_ye,
                nvl(config.jan_payout,0) + 
                    nvl(config.feb_payout,0) + 
                    nvl(config.mar_payout,0) + 
                    nvl(config.apr_payout,0) + 
                    nvl(config.may_payout,0) +
                    nvl(config.jun_payout,0) +
                    nvl(config.jul_payout,0) +
                    nvl(config.aug_payout,0) +
                    nvl(config.sep_payout,0) +
                    nvl(config.oct_payout,0) +
                    nvl(config.nov_payout,0) +
                    nvl(config.dec_payout,0) AS ytd_paid,
                CASE
                    WHEN svq.ytd_quota_pct > 85
                    THEN (svq.ytd_quota * .85) * (config.rate_a / 100)
                    ELSE svq.this_year * (config.rate_a / 100)
                END +
                    (
                        (
                            svq.this_year - 
                                CASE
                                    WHEN svq.ytd_quota_pct > 85
                                    THEN svq.ytd_quota * .85
                                    ELSE svq.this_year
                                END
                        ) * (config.rate_b / 100)
                    ) - 
                    nvl(config.jan_payout,0) - 
                    nvl(config.feb_payout,0) - 
                    nvl(config.mar_payout,0) - 
                    nvl(config.apr_payout,0) - 
                    nvl(config.may_payout,0) -
                    nvl(config.jun_payout,0) -
                    nvl(config.jul_payout,0) -
                    nvl(config.aug_payout,0) -
                    nvl(config.sep_payout,0) -
                    nvl(config.oct_payout,0) -
                    nvl(config.nov_payout,0) -
                    nvl(config.dec_payout,0) AS cm_payout,
                CASE 
                    WHEN svq.ytd_quota_pct > 100
                    THEN svq.this_year - svq.ytd_quota
                    ELSE 0
                END * .075 - 
                    nvl(config.q1_payout,0) - 
                    nvl(config.q2_payout,0) -
                    nvl(config.q3_payout,0) -
                    nvl(config.q4_payout,0) AS cqe_payout
FROM
                kd_svq2 svq
                JOIN kd_svq2_rep_config config
                    ON svq.salesman_code = config.rep_code
                        AND config.end_date IS NULL
                JOIN kd_svq2_rep_quota quota
                    ON svq.salesman_code = quota.repnumber
                        AND quota.end_date IS NULL
WHERE
                svq.end_date IS NULL
ORDER BY
                svq.salesman_code