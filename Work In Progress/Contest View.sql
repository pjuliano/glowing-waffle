CREATE OR REPLACE VIEW kd_contest_2020_overview AS
SELECT
          srq.region,
          srq.repnumber,
          srq.rep_name,
          NVL (SUM (q1impl.kit_qty),0) AS kit_qty_q1,
          NVL (SUM (q1impl.impl_qty),0) AS impl_qty_q1,
          NVL (SUM (q1impl.impl_amount),0) AS impl_amount_q1,
          NVL (SUM (q2impl.kit_qty),0) AS kit_qty_q2,
          NVL (SUM (q2impl.impl_qty),0) AS impl_qty_q2,
          NVL (SUM (q2impl.impl_amount),0) AS impl_amount_q2,
          NVL (SUM (q3impl.kit_qty),0) AS kit_qty_q3,
          NVL (SUM (q3impl.impl_qty),0) AS impl_qty_q3,
          NVL (SUM (q3impl.impl_amount),0) AS impl_amount_q3,
          NVL (SUM (q4impl.kit_qty),0) AS kit_qty_q4,
          NVL (SUM (q4impl.impl_qty),0) AS impl_qty_q4,
          NVL (SUM (q4impl.impl_amount),0) AS impl_amount_q4,
          NVL (COUNT (q1regen.customer_no),0) AS regen_qty_q1,
          NVL (COUNT (q2regen.customer_no),0) AS regen_qty_q2,
          NVL (COUNT (q3regen.customer_no),0) AS regen_qty_q3,
          NVL (COUNT (q4regen.customer_no),0) AS regen_qty_q4,
          SUM
                    (
                              CASE
                                        WHEN beacon.quarter = 1
                                        THEN 1
                                        ELSE 0
                              END
                    )
          AS beacon_q1,
          SUM
                    (
                              CASE
                                        WHEN beacon.quarter = 2
                                        THEN 1
                                        ELSE 0
                              END
                    )
          AS beacon_q2,
          SUM
                    (
                              CASE
                                        WHEN beacon.quarter = 3
                                        THEN 1
                                        ELSE 0
                              END
                    )
          AS beacon_q3,
          SUM
                    (
                              CASE
                                        WHEN beacon.quarter = 4
                                        THEN 1
                                        ELSE 0
                              END
                    )
          AS beacon_q4
FROM
          srrepquota srq
          LEFT JOIN kd_contest_2020_q1_impl_detail q1impl
          ON
                    srq.repnumber = q1impl.rep_code
          LEFT JOIN kd_contest_2020_q2_impl_detail q2impl
          ON
                    srq.repnumber = q2impl.rep_code
          LEFT JOIN kd_contest_2020_q3_impl_detail q3impl
          ON
                    srq.repnumber = q3impl.rep_code
          LEFT JOIN kd_contest_2020_q4_impl_detail q4impl
          ON
                    srq.repnumber = q4impl.rep_code
          LEFT JOIN kd_contest_2020_q1_regen q1regen
          ON
                    srq.repnumber = q1regen.salesman_code
          LEFT JOIN kd_contest_2020_q2_regen q2regen
          ON
                    srq.repnumber = q2regen.salesman_code
          LEFT JOIN kd_contest_2020_q3_regen q3regen
          ON
                    srq.repnumber = q3regen.salesman_code
          LEFT JOIN kd_contest_2020_q4_regen q4regen
          ON
                    srq.repnumber = q4regen.salesman_code
          LEFT JOIN kd_contest_2020_beacon beacon
          ON
                    srq.repnumber = beacon.salesman_code

GROUP BY
          srq.region,
          srq.repnumber,
          srq.rep_name
ORDER BY
          srq.repnumber