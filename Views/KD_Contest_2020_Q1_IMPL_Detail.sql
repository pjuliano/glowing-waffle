CREATE OR REPLACE VIEW kd_contest_2020_Q1_IMPL_detail AS
WITH 
    exclusions AS
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
                                AND sdrec.invoicedate BETWEEN TO_DATE('01/01/2019','MM/DD/YYYY') AND TO_DATE('12/31/2019','MM/DD/YYYY')
            GROUP BY
                            sdrec.customer_no
            HAVING
                            SUM(sdrec.invoiced_qty) > 0
                                AND SUM(sdrec.allamounts) > 0
        ),
    reps AS
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
                '2020-Q1-IMPL' AS contest_name,
                sr.region,
                DECODE(sr.repnumber,'305','126',sr.repnumber) AS rep_code,
                sr.rep_name,
                sdr.customer_no,
                sdr.customer_name,
                sdr.invoice_id,
                SUM
                    (
                        CASE 
                            WHEN catalog_no IN 
                                (
                                    SELECT
                                                    catalog_no
                                    FROM
                                                    kd_kit_parts
                                )
                            THEN invoiced_qty
                            ELSE 0
                        END 
                    ) AS kit_qty,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'IMPL'
                            THEN sdr.invoiced_qty
                            ELSE 0 
                        END 
                    ) AS impl_qty,
                SUM
                    (
                        CASE 
                            WHEN part_product_code = 'IMPL'
                            THEN sdr.allamounts
                            ELSE 0
                        END
                    ) AS impl_amount
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
                        AND sdr.invoicedate BETWEEN TO_DATE('01/01/2020','MM/DD/YYYY') AND TO_DATE('3/31/2020','MM/DD/YYYY')
                        AND 
                            (
                                sdr.part_product_code = 'IMPL'
                                    OR sdr.catalog_no IN 
                                        (
                                            SELECT 
                                                            catalog_no
                                            FROM
                                                            kd_kit_parts
                                        )
                            )
WHERE
                    sdr.customer_no NOT IN  
                        (
                            SELECT 
                                            customer_no 
                            FROM 
                                            exclusions 
                        )
                        AND sr.repnumber NOT IN ('318','999','000','001','002')
                        AND customer_no IS NOT NULL
GROUP BY
                    sr.region,
                    sr.repnumber,
                    sr.rep_name,
                    sdr.customer_no,
                    sdr.customer_name,
                    sdr.invoice_id
HAVING
                SUM
                    (
                        CASE 
                            WHEN catalog_no IN 
                                (
                                    SELECT
                                                    catalog_no
                                    FROM
                                                    kd_kit_parts
                                )
                            THEN invoiced_qty
                            ELSE 0
                        END 
                    ) > 0
                    AND 
                        SUM
                            (
                                CASE 
                                    WHEN part_product_code = 'IMPL'
                                    THEN sdr.allamounts
                                    ELSE 0
                                END
                            ) >= 5000
                        
UNION ALL

SELECT
                '2020-Q1-IMPL' AS contest_name,
                sr.region AS region,
                sr.repnumber AS rep_code,
                sr.rep_name,
                sdr.customer_no,
                sdr.customer_name,
                sdr.invoice_id,
                SUM
                    (
                        CASE 
                            WHEN catalog_no IN 
                                (
                                    SELECT
                                                    catalog_no
                                    FROM
                                                    kd_kit_parts
                                )
                            THEN invoiced_qty
                            ELSE 0
                        END 
                    ) AS kit_qty,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'IMPL'
                            THEN sdr.invoiced_qty
                            ELSE 0 
                        END 
                    ) AS impl_qty,
                SUM
                    (
                        CASE 
                            WHEN part_product_code = 'IMPL'
                            THEN sdr.allamounts
                            ELSE 0
                        END
                    ) AS impl_amount
FROM
                reps sr
                LEFT JOIN kd_contest_2020_q1_impl_ext cont
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
                        AND sdr.invoicedate BETWEEN TO_DATE('01/01/2020','MM/DD/YYYY') AND TO_DATE('3/31/2020','MM/DD/YYYY')
                        AND 
                            (
                                sdr.part_product_code = 'IMPL'
                                    OR sdr.catalog_no IN 
                                        (
                                            SELECT 
                                                            catalog_no
                                            FROM
                                                            kd_kit_parts
                                        )
                            )
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