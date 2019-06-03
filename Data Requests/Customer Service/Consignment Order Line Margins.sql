SELECT          sc.customer_id,
                sc.customer_name,
                sc.region_code,
                sc.salesman_code,
                sc.salesman_name,
                sc.invoice_date,
                sc.invoice_id,
                sc.item_id,
                sc.part_product_code,
                sc.part_product_family,
                sc.second_commodity,
                sc.catalog_no,
                sc.catalog_desc,
                sc.invoiced_qty,
                sc.current_list_price,
                sc.total_price_usd,
                ipc.inventory_value AS cost,
                ROUND(100 * (sc.total_price_usd - (sc.invoiced_qty * ipc.inventory_value)) / NULLIF(sc.total_price_usd,0),2) AS margin_pct
                
FROM            kd_sales_cube sc
                LEFT JOIN customer_order_tab co
                    ON  sc.order_id = co.order_no AND
                        sc.company = co.contract
                LEFT JOIN inventory_part_unit_cost_sum ipc
                    ON  sc.catalog_no = ipc.part_no AND
                        sc.company = ipc.contract
WHERE           co.order_id = 'CO' AND
                sc.invoice_year > 2015 AND
                sc.part_product_code != 'FREIGHT'
ORDER BY        sc.customer_id,
                sc.invoice_date,
                sc.invoice_id,
                sc.item_id