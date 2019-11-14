SELECT
                cpe.customer_id,
                sc.invoice_customer_name,
                sc.invoice_salesman_code,
                sc.invoice_salesman_name,
                cpll.catalog_no,
                sc.catalog_desc,
                sc.product_set,
                sc.current_list_price,
                cpll.sales_price,
                SUM(sc.invoiced_qty * sc.current_list_price) AS total_at_list,
                SUM(sc.total_price_usd) AS total_price_usd,
                100 * (1 - ( SUM(sc.total_price_usd) / NULLIF(SUM(sc.invoiced_qty * sc.current_list_price),0))) AS effective_discount
FROM
                customer_pricelist_ent cpe
                JOIN kd_current_price_list_lines cpll
                    ON cpe.price_list_no = cpll.price_list_no
                JOIN kd_sales_cube sc
                    ON cpe.customer_id = sc.invoice_customer_id
                        AND cpll.catalog_no = sc.catalog_no
                        AND sc.invoice_year = 2019
                        AND sc.invoiced_qty > 0
                        AND sc.order_id NOT LIKE 'W%'
                        AND sc.order_ID NOT LIKE 'X%'
                        AND sc.order_currency = 'USD'
                        AND sc.corporate_form = 'DOMDIR'
GROUP BY
                cpe.customer_id,
                sc.invoice_customer_name,
                sc.invoice_salesman_code,
                sc.invoice_salesman_name,
                cpll.catalog_no,
                sc.catalog_desc,
                sc.product_set,
                sc.current_list_price,
                cpll.sales_price