CREATE OR REPLACE VIEW kd_boomi_svq2 AS
SELECT
                --RANK() OVER (ORDER BY svq.ytd_quota_pct DESC) AS rank,
                NULL AS rank,
                to_char(SYSDATE,'YYYY-MM-DD') AS "CURRENT_DATE",
                CASE 
                    WHEN svq.salesman_code IN ('001','002') 
                    THEN rconf.rep_code 
                    WHEN svq.end_date IS NOT NULL 
                    THEN rconf.rep_code
                    ELSE svq.salesman_code 
                END AS owner_code, 
                svq.salesman_code,
                svq.name,
                to_char(TO_DATE(svq.start_date,'MM/DD/YYYY'),'YYYY-MM-DD') AS start_date,
                to_char(TO_DATE(svq.end_date,'MM/DD/YYYY'),'YYYY-MM-DD') AS end_date,
                svq.region,
                round(svq.today) AS today,
                round(svq.this_month) AS this_month,
                round(svq.this_month_implants) AS this_month_implants,
                round(svq.this_month_bio) AS this_month_bio,
                svq.mtd_quota,
                svq.mtd_quota_impl,
                svq.mtd_quota_bio,
                svq.mtd_quota_remaining,
                svq.mtd_quota_impl_remaining,
                svq.mtd_quota_bio_remaining,
                svq.month_quota_pct,
                svq.month_quota_pct_impl,
                svq.month_quota_pct_bio,
                svq.mtd_quota_pct,
                svq.mtd_quota_pct_impl,
                svq.mtd_quota_pct_bio,
                round(svq.month_remaining) AS month_remaining,
                round(svq.month_remaining_impl) AS month_remaining_impl,
                round(svq.month_remaining_bio) AS month_remaining_bio,
                rm.month_quota,
                rm.month_quota_impl,
                rm.month_quota_bio,
                round(svq.month_remaining / nullif((mcal.total_sales_days - mcal.elapsed_work_days),0)) AS avg_per_day_req_month,
                CASE
                    WHEN round(((rm.month_quota / mcal.total_sales_days) * mcal.elapsed_work_days) - svq.this_month) > 0 
                    THEN round(((rm.month_quota / mcal.total_sales_days) * mcal.elapsed_work_days) - svq.this_month)
                    ELSE 0
                END AS "SALES_TODAY_TO_HIT_100%_MTD",
                round(svq.this_quarter) AS this_quarter,
                round(svq.this_quarter_implants) AS this_quarter_implants,
                round(svq.this_quarter_bio) AS this_quarter_bio,
                round(rq.qtr_quota) AS qtr_quota,
                round(rq.qtr_quota_impl) AS qtr_quota_impl,
                round(rq.qtr_quota_bio) AS qtr_quota_bio,
                svq.quarter_quota_pct,
                svq.quarter_quota_pct_impl,
                svq.quarter_quota_pct_bio,
                svq.qtd_quota_pct,
                svq.qtd_quota_pct_impl,
                svq.qtd_quota_pct_bio,
                round(svq.quarter_remaining) AS quarter_remaining,
                round(svq.quarter_remaining_impl) AS quarter_remaining_impl,
                round(svq.quarter_remaining_bio) AS quarter_remaining_bio,
                round(svq.this_year) AS this_year,
                round(svq.this_year_implants) AS this_year_implants,
                round(svq.this_year_bio) AS this_year_bio,
                round(ry.year_quota) AS year_quota,
                round(ry.year_quota_impl) AS year_quota_impl,
                round(ry.year_quota_bio) AS year_quota_bio,
                svq.year_quota_pct,
                svq.year_quota_pct_impl,
                svq.year_quota_pct_bio,
                svq.ytd_quota_pct,
                svq.ytd_quota_pct_impl,
                svq.ytd_quota_pct_bio,
                svq.ytd_quota,
                svq.ytd_quota_impl,
                svq.ytd_quota_bio,
                round(svq.year_remaining) AS year_remaining,
                svq.ytd_quota_remaining,
                round(svq.year_remaining_impl) AS year_remaining_impl,
                svq.ytd_quota_impl_remaining,
                round(svq.year_remaining_bio) AS year_remaining_bio,
                svq.ytd_quota_bio_remaining,
                svq.year_quota_pct_reg,
                svq.year_quota_pct_impl_reg,
                svq.year_quota_pct_bio_reg,
                svq.ytd_quota_pct_reg,
                svq.ytd_quota_pct_impl_reg,
                svq.ytd_quota_pct_bio_reg,
                svq.quarter_quota_pct_reg,
                svq.quarter_quota_pct_impl_reg,
                svq.quarter_quota_pct_bio_reg,
                svq.qtd_quota_pct_reg,
                svq.qtd_quota_pct_impl_reg,
                svq.qtd_quota_pct_bio_reg,
                svq.month_quota_pct_reg,
                svq.month_quota_pct_impl_reg,
                svq.month_quota_pct_bio_reg,
                svq.mtd_quota_pct_reg,
                svq.mtd_quota_pct_impl_reg,
                svq.mtd_quota_pct_bio_reg,
                svq.year_quota_pct_total,
                svq.year_quota_pct_impl_total,
                svq.year_quota_pct_bio_total,
                svq.ytd_quota_pct_total,
                svq.ytd_quota_pct_impl_total,
                svq.ytd_quota_pct_bio_total,
                svq.quarter_quota_pct_total,
                svq.quarter_quota_pct_impl_total,
                svq.quarter_quota_pct_bio_total,
                svq.qtd_quota_pct_total,
                svq.qtd_quota_pct_impl_total,
                svq.qtd_quota_pct_bio_total,
                svq.month_quota_pct_total,
                svq.month_quota_pct_impl_total,
                svq.month_quota_pct_bio_total,
                svq.mtd_quota_pct_total,
                svq.mtd_quota_pct_impl_total,
                svq.mtd_quota_pct_bio_total,
                svq.pymtd_sd,
                svq.pyqtd_sd,
                svq.pyytd_sd,
                svq.py_mtd_sd_reg,
                svq.py_qtd_sd_reg,
                svq.py_ytd_sd_reg,
                svq.py_month_sd_total,
                svq.py_quarter_sd_total,
                svq.py_year_sd_total,
                mcal.total_sales_days - mcal.elapsed_work_days AS sales_days_remaining_month,
                round(regm.this_month) AS this_month_reg,
                round(regm.this_month_implants) AS this_month_impl_reg,
                round(regm.this_month_bio) AS this_month_bio_reg,
                round(regm.month_quota) AS month_quota_reg,
                round(regm.month_quota_impl) AS month_quota_impl_reg,
                round(regm.month_quota_bio) AS month_quota_bio_reg,
                round(regm.month_quota - regm.this_month) AS month_remaining_reg,
                round(regm.month_quota_impl - regm.this_month_implants) AS month_remaining_impl_reg,
                round(regm.month_quota_bio - regm.this_month_bio) AS month_remaining_bio_reg,
                round(regq.this_quarter) AS this_quarter_reg,
                round(regq.this_quarter_implants) AS this_quarter_impl_reg,
                round(regq.this_quarter_bio) AS this_quarter_bio_reg
FROM
                kd_svq2 svq
                LEFT JOIN kd_svq2_rep_month rm
                    ON svq.salesman_code = rm.salesman_code
                        AND svq.start_date = rm.start_date
                LEFT JOIN kd_svq2_rep_quarter rq
                    ON svq.salesman_code = rq.salesman_code
                        AND svq.start_date = rq.start_date
                LEFT JOIN kd_svq2_rep_year ry
                    ON svq.salesman_code = ry.salesman_code
                        AND svq.start_date = ry.start_date
                JOIN kd_monthly_calendar mcal
                    ON mcal.month = EXTRACT(MONTH FROM sysdate)
                JOIN kd_svq2_region_month regm
                    ON svq.region = regm.region
                JOIN kd_svq2_region_quarter regq
                    ON svq.region = regq.region
                JOIN kd_svq2_region_config rconf
                    ON svq.region = rconf.region_code