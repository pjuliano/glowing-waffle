SELECT
                kd_sales_data_request.part_product_family,
                catalog_no,
                sales_part_api.get_catalog_desc('100',catalog_no) AS catalog_desc,
                ROUND
                    (
                        AVG
                            (
                                CASE
                                    WHEN EXTRACT(YEAR FROM invoicedate) = 2018
                                    THEN 100 * (1 - (sale_unit_price / NULLIF(sales_part_api.get_list_price('100',catalog_no),0)))
                                    ELSE NULL
                                END
                            ),
                        4
                    ) AS "2018_AVG_DISC",
                SUM
                    (
                        CASE
                            WHEN EXTRACT(YEAR FROM invoicedate) = 2018 
                            THEN invoiced_qty
                            ELSE 0
                        END
                    ) AS "2018_UNITS",
                ROUND
                    (
                        AVG
                            (
                                CASE
                                    WHEN EXTRACT(YEAR FROM invoicedate) = 2019
                                    THEN 100 * (1 - (sale_unit_price / NULLIF(sales_part_api.get_list_price('100',catalog_no),0)))
                                    ELSE NULL
                                END
                            ),
                        4
                    )AS "2019_AVG_DISC",
                SUM
                    (
                        CASE
                            WHEN EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN invoiced_qty
                            ELSE 0
                        END
                    ) AS "2019_UNITS"
                
FROM
                kd_sales_data_request LEFT JOIN
                    inventory_product_family_cfv ON
                        kd_sales_data_request.part_product_family = inventory_product_family_cfv.part_product_family
WHERE
                EXTRACT(YEAR FROM invoicedate) >= 2018
                    AND charge_type = 'Parts'
                    AND invoiced_qty > 0
                    AND inventory_product_family_cfv.cf$_kdprodfamtype = 'Implants'
                    AND corporate_form = 'DOMDIR'
                    AND part_product_code != 'LIT'
GROUP BY
                kd_sales_data_request.part_product_family,
                catalog_no,
                catalog_desc