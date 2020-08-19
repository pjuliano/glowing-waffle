WITH
    freight AS
        (
            SELECT
                            order_no,
                            SUM(line_package_charge) AS cost,
                            COUNT(1) AS shipments,
                            LISTAGG(tracking_number, ';') WITHIN GROUP (ORDER BY order_no) AS tracking_numbers
            FROM
                            ps_freight_info_co
            WHERE
                            EXTRACT(YEAR FROM pick_up_date) = 2019
            GROUP BY
                            order_no
        )

SELECT
                sc.recid,
                sc.invoice_region_code,
                sc.invoice_salesman_name,
                sc.invoice_id,
                sc.order_id,
                sc.catalog_no,
                sc.catalog_desc,
                sc.current_list_price,
                fr.cost,
                fr.shipments,
                sc.current_list_price - fr.shipments AS delta,
                fr.tracking_numbers
FROM
                kd_sales_cube sc
                LEFT JOIN freight fr
                    ON sc.order_id = fr.order_no
                        
WHERE
                sc.invoice_year >= 2019
                    AND sc.source = 'IFS'
                    AND sc.product_set = 'FREIGHT'
                    AND sc.sales_market = 'NORAM'