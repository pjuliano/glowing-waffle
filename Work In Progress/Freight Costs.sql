WITH
    freight AS
        (
            SELECT
                            order_no,
                            tracking_number AS tracking_number,
                            SUM(line_package_charge) AS cost,
                            COUNT(1) AS shipments,
                            ROW_NUMBER() OVER (PARTITION BY order_no ORDER BY order_no) AS row_number
            FROM
                            ps_freight_info_co
            WHERE
                            EXTRACT(YEAR FROM pick_up_date) = EXTRACT(YEAR FROM SYSDATE)
            GROUP BY
                            order_no,
                            tracking_number
        )

SELECT
                sc.recid,
                sc.invoice_region_code,
                sc.invoice_salesman_name,
                sc.invoice_date,
                sc.invoice_id,
                sc.order_id,
                sc.catalog_no,
                sc.catalog_desc,
                sv.description AS ship_method,
                fr.tracking_number,
                nvl(sc.current_list_price,0) AS current_list_price,
                CASE
                    WHEN fr.row_number = 1
                    THEN sc.total_price_usd 
                    ELSE NULL
                END AS sales_price,
                fr.cost,
                fr.shipments,
                nvl(sc.current_list_price,0) - sc.total_price_usd AS price_delta,
                nvl(sc.total_price_usd,0) - fr.cost AS cost_delta
FROM
                freight fr       
                LEFT JOIN kd_sales_cube sc
                    ON sc.order_id = fr.order_no
                LEFT JOIN customer_order co
                    ON sc.order_id = co.order_no
                JOIN mpccom_ship_via sv
                    ON co.ship_via_code = sv.ship_via_code
WHERE
                sc.invoice_year = EXTRACT(YEAR FROM SYSDATE)
                    AND sc.source = 'IFS'
                    AND sc.product_set = 'FREIGHT'
                    AND sc.sales_market = 'NORAM'
                    AND invoice_id NOT LIKE 'CR%'
                    --AND invoice_id = 'CD1001924565'

ORDER BY
                sc.invoice_date,
                sc.invoice_salesman_name;