CREATE OR REPLACE VIEW kd_contest_2020_q2_regen AS
SELECT
                salesman_code,
                customer_no,
                SUM(allamounts) AS regen_amount
FROM
                kd_sales_data_request
WHERE
                part_product_code = 'REGEN'
                    AND charge_type = 'Parts' 
                    AND corporate_form = 'DOMDIR'
                    AND catalog_no != '3DBC-22001091' 
                    AND
                        (
                            (
                                order_no Not Like 'W%' 
                                AND order_no Not Like 'X%'
                            )
                            OR order_no Is Null
                        )
                    AND 
                        (
                            market_code != 'PREPOST'
                            OR market_code Is Null
                        )
                    AND invoice_id != 'CR1001802096' 
                    AND 
                        (
                            order_no != 'C512921' 
                            OR order_no Is Null
                        )
                    AND EXTRACT(YEAR FROM invoicedate) = 2020
                    AND TO_CHAR(invoicedate, 'Q') = 2
                    AND customer_no NOT IN
                            (
                                SELECT DISTINCT
                                                customer_no
                                FROM
                                                kd_sales_data_request
                                WHERE
                                                part_product_code = 'REGEN'
                                                AND charge_type = 'Parts' 
                                                AND corporate_form = 'DOMDIR'
                                                AND catalog_no != '3DBC-22001091' 
                                                AND
                                                    (
                                                        (
                                                            order_no Not Like 'W%' 
                                                            AND order_no Not Like 'X%'
                                                        )
                                                        OR order_no Is Null
                                                    )
                                                AND 
                                                    (
                                                        market_code != 'PREPOST'
                                                        OR market_code Is Null
                                                    )
                                                AND invoice_id != 'CR1001802096' 
                                                AND 
                                                    (
                                                        order_no != 'C512921' 
                                                        OR order_no Is Null
                                                    )
                                                AND invoicedate <= TO_DATE('03/30/2020','MM/DD/YYYY')
                            )
GROUP BY 
                salesman_code,
                customer_no
HAVING
                sum(allamounts) >= 2500