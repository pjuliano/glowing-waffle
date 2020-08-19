SELECT
                svq.salesman_code AS "Rep ID",
                svq.rep_name AS "Name",
                svq.region AS "Region",
                svq.this_month AS "Month Sales",
                svq.month_quota_pct AS "Month Quota Pct",
                svq.mtd_quota AS "Month Quota",
                svq.month_remaining AS "Month Remaining",
                svq.this_year AS "Year Sales",
                svq.year_quota_pct AS "Year Quota Pct",
                svq.ytd_quota_pct AS "YTD Quota Pct",
                rq.year AS "Year Quota",
                svq.ytd_quota AS "YTD Quota",
                svq.year_remaining AS "Year Remaining",
                ra.is_rep_id AS "IS Rep ID",
                ra.is_rep_name AS "IS Rep Name",
                dm.dm_code AS "DM Rep ID",
                dm.dm_name AS "DM Name"
FROM
                kd_svq2 svq 
                LEFT JOIN kd_svq2_rep_quota rq
                    ON svq.salesman_code = rq.repnumber
                LEFT JOIN kd_inside_rep_assignments ra
                    ON svq.salesman_code = ra.rep_id
                LEFT JOIN kd_svq2_dm_config dm
                    ON svq.salesman_code = dm.rep_code