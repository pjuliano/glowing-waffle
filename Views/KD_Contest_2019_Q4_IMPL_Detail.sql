CREATE OR REPLACE VIEW kd_contest_2019_q4_impl_detail AS
WITH exclusions AS 
    (
        SELECT
                        sdrec.customer_no,
                        SUM(sdrec.invoiced_qty)
        FROM
                        kd_sales_data_request sdrec
        WHERE
                        sdrec.charge_type = 'Parts' 
                            AND sdrec.corporate_form = 'DOMDIR'
                            AND sdrec.catalog_no != '3DBC-22001091' 
                            AND
                                (
                                    (
                                        sdrec.order_no NOT LIKE 'W%' 
                                            AND sdrec.order_no NOT LIKE 'X%'
                                    )
                                        OR sdrec.order_no IS NULL
                                )
                            AND 
                                (
                                    sdrec.market_code != 'PREPOST'
                                        OR sdrec.market_code IS NULL
                                )
                            AND sdrec.invoice_id != 'CR1001802096' 
                            AND 
                                (
                                    sdrec.order_no != 'C512921' 
                                        OR sdrec.order_no IS NULL
                                )
                            AND sdrec.part_product_code = 'IMPL'
                            AND sdrec.invoicedate BETWEEN add_months(TO_DATE('09/30/2019','MM/DD/YYYY'),-24) AND TO_DATE('09/30/2019','MM/DD/YYYY')
                            AND catalog_desc NOT LIKE '%MAX%'
        GROUP BY
                        sdrec.customer_no
        HAVING
                        SUM(sdrec.invoiced_qty) > 0
                            AND SUM(sdrec.allamounts) > 0
    ),
dso_reps AS
    (
        SELECT
                        person_id AS repnumber,
                        name AS rep_name,
                        'USNA' AS region
        FROM
                        person_info
        WHERE
                        person_id IN ('898','899')
        
        UNION ALL
        
        SELECT
                        repnumber,
                        rep_name,
                        region
        FROM
                        srrepquota
    )

SELECT
                '2019-Q4-IMPL' AS contest_name,
                sr.region,
                DECODE(sr.repnumber,'305','126',sr.repnumber) AS rep_code,
                sr.rep_name,
                sdr.customer_no,
                sdr.customer_name,
                sdr.invoice_id,
                SUM(sdr.invoiced_qty) AS invoiced_qty,
                SUM(sdr.allamounts) AS sales_amount
FROM
                srrepquota sr
                LEFT JOIN kd_sales_data_request sdr
                    ON sr.repnumber = sdr.salesman_code
                        AND sdr.charge_type = 'Parts' 
                        AND sdr.corporate_form = 'DOMDIR'
                        AND sdr.catalog_no != '3DBC-22001091' 
                        AND
                            (
                                (
                                    sdr.order_no NOT LIKE 'W%' 
                                        AND sdr.order_no NOT LIKE 'X%'
                                )
                                    OR sdr.order_no IS NULL
                            )
                        AND 
                            (
                                sdr.market_code != 'PREPOST'
                                    OR sdr.market_code IS NULL
                            )
                        AND sdr.invoice_id != 'CR1001802096' 
                        AND 
                            (
                                sdr.order_no != 'C512921' 
                                    OR sdr.order_no IS NULL
                            )
                        AND sdr.part_product_code = 'IMPL'
                        AND sdr.invoicedate BETWEEN TO_DATE('10/01/2019','MM/DD/YYYY') AND TO_DATE('12/31/2019','MM/DD/YYYY')
                        AND sdr.customer_no NOT IN
                            (
                                SELECT
                                                customer_no
                                FROM
                                                exclusions
                            )
                        AND sdr.invoice_id != 'CD1001938657' --To make sure Dr. Ho doesn't get in the contest.
WHERE
                    sr.repnumber NOT IN ('318','999','000','001','002')
                        AND customer_no IS NOT NULL
                        
GROUP BY
                    sr.region,
                    sr.repnumber,
                    sr.rep_name,
                    sdr.customer_no,
                    sdr.customer_name,
                    sdr.invoice_id

UNION ALL

SELECT
                '2019-Q4-IMPL' AS contest_name,
                sr.region AS region,
                DECODE(sr.repnumber,'305','126',sr.repnumber) AS rep_code,
                sr.rep_name,
                sdr.customer_no,
                sdr.customer_name,
                sdr.invoice_id,
                SUM(sdr.invoiced_qty) AS invoiced_qty,
                SUM(sdr.allamounts) AS sales_amount
FROM
                dso_reps sr
                LEFT JOIN kd_contest_2019_q4_impl_ext cont
                    ON sr.repnumber = cont.rep_code
                LEFT JOIN kd_sales_data_request sdr
                    ON sdr.invoice_id = cont.invoice_id
                        AND sdr.charge_type = 'Parts' 
                        AND sdr.corporate_form = 'DOMDIR'
                        AND sdr.catalog_no != '3DBC-22001091' 
                        AND
                            (
                                (
                                    sdr.order_no NOT LIKE 'W%' 
                                        AND sdr.order_no NOT LIKE 'X%'
                                )
                                    OR sdr.order_no IS NULL
                            )
                        AND 
                            (
                                sdr.market_code != 'PREPOST'
                                    OR sdr.market_code IS NULL
                            )
                        AND sdr.invoice_id != 'CR1001802096' 
                        AND 
                            (
                                sdr.order_no != 'C512921' 
                                    OR sdr.order_no IS NULL
                            )
                        AND sdr.part_product_code = 'IMPL'
                        AND sdr.invoicedate BETWEEN TO_DATE('10/01/2019','MM/DD/YYYY') AND TO_DATE('12/31/2019','MM/DD/YYYY') 
WHERE
                    sr.repnumber NOT IN ('318','999','000')
                        AND sdr.customer_no IS NOT NULL
GROUP BY
                    sr.region,
                    sr.repnumber,
                    sr.rep_name,
                    sdr.customer_no,
                    sdr.customer_name,
                    sdr.invoice_id;
