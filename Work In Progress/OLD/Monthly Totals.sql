SELECT
                salesman_code,
                SUM(
                    CASE
                        WHEN EXTRACT(MONTH FROM invoicedate) = 1
                        THEN allamounts
                        ELSE 0
                    END
                    ) AS JAN,
                SUM(
                    CASE
                        WHEN EXTRACT(MONTH FROM invoicedate) = 2
                        THEN allamounts
                        ELSE 0
                    END
                    ) AS FEB,
                                SUM(
                    CASE
                        WHEN EXTRACT(MONTH FROM invoicedate) = 3
                        THEN allamounts
                        ELSE 0
                    END
                    ) AS MAR,
                                SUM(
                    CASE
                        WHEN EXTRACT(MONTH FROM invoicedate) = 4
                        THEN allamounts
                        ELSE 0
                    END
                    ) AS APR,
                                SUM(
                    CASE
                        WHEN EXTRACT(MONTH FROM invoicedate) = 5
                        THEN allamounts
                        ELSE 0
                    END
                    ) AS MAY
FROM
                kd_sales_data_request
WHERE           
                EXTRACT(YEAR FROM invoicedate) = 2019
                AND charge_type = 'Parts' 
                AND part_product_code != 'REGEN'
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
                AND salesman_code IN ('217','302','313','314')
GROUP BY 
                salesman_code