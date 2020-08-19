CREATE OR REPLACE VIEW kd_svq2_contest_total AS
SELECT
                srq.repnumber || '-' || EXTRACT(YEAR FROM SYSDATE) AS record_id,
                COUNT(q1.customer_no) AS impl_customer_qty_q1,
                NVL(SUM(q1.impl_amount),0) AS impl_customer_revenue_q1,
                COUNT(q2.customer_no) AS impl_customer_qty_q2,
                NVL(SUM(q2.impl_amount),0) AS impl_customer_revenue_q2,
                COUNT(q3.customer_no) AS impl_customer_qty_q3,
                NVL(SUM(q3.impl_amount),0) AS impl_customer_revenue_q3,
                COUNT(q4.customer_no) AS impl_customer_qty_q4,
                NVL(SUM(q4.impl_amount),0) AS impl_customer_revenue_q4
FROM
                srrepquota srq
                LEFT JOIN kd_contest_2020_q1_impl_detail q1
                    on srq.repnumber = q1.rep_code
                LEFT JOIN kd_contest_2020_q2_impl_detail q2
                    on srq.repnumber = q2.rep_code
                LEFT JOIN kd_contest_2020_q3_impl_detail q3
                    on srq.repnumber = q3.rep_code
                LEFT JOIN kd_contest_2020_q4_impl_detail q4
                    on srq.repnumber = q4.rep_code
GROUP BY
                repnumber || '-' || EXTRACT(YEAR FROM SYSDATE)