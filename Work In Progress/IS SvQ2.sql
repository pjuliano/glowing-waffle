SELECT
          ira.is_rep_id,
          ira.is_rep_name,
          SUM (svq.today)                                                                         AS today,
          SUM (svq.this_month)                                                                    AS this_month,
          SUM (svq.pymtd_sd)                                                                      AS pymtd_sd,
          ROUND ( (SUM (svq.this_month) / SUM (svq.mtd_quota + svq.mtd_quota_remaining)) * 100,2) AS month_quota_pct,
          SUM (svq.mtd_quota)                                                                     AS mtd_quota,
          SUM (svq.mtd_quota_remaining)                                                           AS mtd_quota_remaining,
          ROUND ( (SUM (svq.this_month) / SUM (svq.mtd_quota)) * 100,2)                           AS mtd_quota_pct,
          SUM (svq.month_remaining)                                                               AS month_remaining,
          SUM (svq.this_quarter)                                                                  AS this_quarter,
          SUM (svq.pyqtd_sd)                                                                      AS pyqtd_sd,
          ROUND ( (SUM (svq.this_quarter) / SUM (svq.this_quarter + quarter_remaining)) * 100,2)  AS quarter_quota_pct,
          SUM (svq.quarter_remaining)                                                             AS quarter_remaining,
          SUM (svq.this_year)                                                                     AS this_year,
          SUM (svq.pyytd_sd)                                                                      AS pyytd_sd,
          ROUND ( (SUM (svq.this_year) / SUM (svq.this_year + svq.year_remaining)) * 100,2)       AS year_quota_pct,
          SUM (svq.ytd_quota)                                                                     AS ytd_quota,
          ROUND ( (SUM (svq.this_year) / SUM (svq.ytd_quota)) * 100,2)                            AS ytd_quota_pct,
          SUM (svq.ytd_quota_remaining)                                                           AS ytd_quota_remaining,
          SUM (svq.year_remaining)                                                                AS year_remaining
FROM
          kd_inside_rep_assignments ira
          LEFT JOIN kd_svq2         svq
          ON
                    ira.rep_id = svq.salesman_code
GROUP BY
          ira.is_rep_id,
          ira.is_rep_name