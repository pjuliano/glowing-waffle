CREATE OR REPLACE VIEW kd_svq2_contest_total_sp AS
SELECT
                sp.sp_code || 'SP-' || EXTRACT(YEAR FROM SYSDATE) AS record_id,
                COUNT(q1.customer_no) AS impl_customer_qty_q1,
                NVL(SUM(q1.impl_amount),0) AS impl_customer_revenue_q1,
                COUNT(q2.customer_no) AS impl_customer_qty_q2,
                NVL(SUM(q2.impl_amount),0) AS impl_customer_revenue_q2,
                COUNT(q3.customer_no) AS impl_customer_qty_q3,
                NVL(SUM(q3.impl_amount),0) AS impl_customer_revenue_q3,
                COUNT(q4.customer_no) AS impl_customer_qty_q4,
                NVL(SUM(q4.impl_amount),0) AS impl_customer_revenue_q4
                
FROM
                kd_svq2_sp_config sp
                LEFT JOIN kd_contest_2020_q1_impl_detail q1
                    on sp.rep_code = q1.rep_code
                LEFT JOIN kd_contest_2020_q2_impl_detail q2
                    on sp.rep_code = q2.rep_code
                LEFT JOIN kd_contest_2020_q3_impl_detail q3
                    on sp.rep_code = q3.rep_code
                LEFT JOIN kd_contest_2020_q4_impl_detail q4
                    on sp.rep_code = q4.rep_code
GROUP BY
                sp.sp_code || 'SP-' || EXTRACT(YEAR FROM SYSDATE)