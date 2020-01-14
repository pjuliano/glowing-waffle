SELECT
                sc.recid,
                sc.invoice_region_code,
                sc.invoice_salesman_name,
                sc.invoice_date,
                sc.invoice_id,
                sc.catalog_no,
                sc.catalog_desc,
                sc.current_list_price,
                ipucs.inventory_value AS cost,
                sc.invoiced_qty,
                sc.total_price_usd,
                sc.invoiced_qty * ipucs.inventory_value AS total_cost,
                sc.invoiced_qty * sc.current_list_price AS total_loss
FROM
                kd_sales_cube sc
                LEFT JOIN inventory_part_unit_cost_sum ipucs
                    ON sc.company = ipucs.contract
                        AND sc.catalog_no = ipucs.part_no
WHERE
                sc.invoice_year >= 2018
                    AND sc.total_price_usd = 0
                    AND sc.product_set != 'FREIGHT'
                    --AND sc.invoiced_qty > 0
                    AND sc.sales_market = 'NORAM'
                    AND sc.current_list_price != 9999
                    AND 
                        (
                            (
                                sc.order_id NOT LIKE 'W%'
                                    AND sc.order_id NOT LIKE 'X%'
                            )
                                OR sc.order_id IS NULL
                        )
ORDER BY 
                sc.invoice_date,
                sc.invoice_region_code,
                sc.invoice_salesman_code