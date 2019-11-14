SELECT
                sc.invoice_customer_id,
                sc.invoice_customer_name,
                sc.invoice_salesman_code,
                sc.invoice_salesman_name,
                SUM
                    (
                        CASE
                            WHEN sc.invoice_year = 2018
                            THEN sc.total_price_usd
                            ELSE 0
                        END
                    ) AS py_sales,
                SUM
                    (
                        CASE
                            WHEN sc.invoice_year = 2018
                            THEN sc.invoiced_qty * sc.current_list_price
                            ELSE 0
                        END
                    ) AS py_sales_at_list,
                ROUND(100 * (1 - (SUM(CASE WHEN sc.invoice_year = 2018 THEN sc.total_price_usd ELSE 0 END) / NULLIF(SUM(CASE WHEN sc.invoice_year = 2018 THEN sc.invoiced_qty * sc.current_list_price ELSE 0 END),0))),2) AS py_effective_discount,
                SUM
                    (
                        CASE
                            WHEN sc.invoice_year = 2019
                            THEN sc.total_price_usd
                            ELSE 0
                        END
                    ) AS cy_sales,
                SUM
                    (
                        CASE
                            WHEN sc.invoice_year = 2019
                            THEN sc.invoiced_qty * sc.current_list_price
                            ELSE 0
                        END
                    ) AS cy_sales_at_list,
                 ROUND(100 * (1 - (SUM(CASE WHEN sc.invoice_year = 2019 THEN sc.total_price_usd ELSE 0 END) / NULLIF(SUM(CASE WHEN sc.invoice_year = 2019 THEN sc.invoiced_qty * sc.current_list_price ELSE 0 END),0))),2) AS cy_effective_discount
FROM
                kd_sales_cube sc
                JOIN 
                    (
                        SELECT
                                        DISTINCT customer_id
                        FROM
                                        customer_pricelist_ent
                    ) cpe
                    ON sc.invoice_customer_id = cpe.customer_id
WHERE
                sc.source = 'IFS'
                    AND sc.corporate_form = 'DOMDIR'
                    AND sc.invoice_year >= 2018
                    AND sc.part_product_family != 'FREIGHT'
                    AND sc.current_list_price != 9999
                    AND sc.catalog_no NOT IN (SELECT catalog_no FROM kd_kit_parts)
                    AND sc.delivery_country != 'CANADA'
                    AND 
                        (
                            sc.order_id NOT LIKE 'W%'
                                OR sc.order_id NOT LIKE 'X%'
                                OR sc.order_id IS NULL
                        )
                    AND sc.invoiced_qty > 0 
GROUP BY
                sc.invoice_customer_id,
                sc.invoice_customer_name,
                sc.invoice_salesman_code,
                sc.invoice_salesman_name