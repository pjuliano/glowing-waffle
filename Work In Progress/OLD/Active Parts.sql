WITH latest_sale_date AS
    (
        SELECT          catalog_no,
                        MAX(invoice_date) as last_invoice_date
        FROM            kd_sales_cube
        WHERE           company = '100'
                        AND invoiced_qty > 0
                        AND total_price_usd != 0 
        GROUP BY        catalog_no
    )    

SELECT              invpar.part_product_family,
                    invpar.part_product_code,
                    invpar.part_no,
                    invpar.description,
                    invpar.part_status,
                    salpar.catalog_no,
                    salpar.catalog_desc,
                    salpar.activeind_db,
                    lsd.last_invoice_date,
                    sysdate - lsd.last_invoice_date as days_since_last_sale,
                    SUM(
                            CASE
                                WHEN cube.invoice_year = EXTRACT(YEAR FROM SYSDATE) 
                                THEN cube.total_price_usd
                                ELSE 0
                            END
                        ) AS CY_TOTAL_REVENUE,
                    SUM(
                            CASE 
                                WHEN cube.invoice_year = EXTRACT(YEAR FROM SYSDATE)
                                THEN cube.invoiced_qty
                                ELSE 0
                            END
                        ) AS CY_TOTAL_UNITS,
                                        SUM(
                            CASE
                                WHEN cube.invoice_year = EXTRACT(YEAR FROM SYSDATE)-1 
                                THEN cube.total_price_usd
                                ELSE 0
                            END
                        ) AS PY_TOTAL_REVENUE,
                    SUM(
                            CASE 
                                WHEN cube.invoice_year = EXTRACT(YEAR FROM SYSDATE)-1
                                THEN cube.invoiced_qty
                                ELSE 0
                            END
                        ) AS PY_TOTAL_UNITS,
                    SUM(
                            CASE
                                WHEN cube.invoice_year = EXTRACT(YEAR FROM SYSDATE)-2 
                                THEN cube.total_price_usd
                                ELSE 0
                            END
                        ) AS PY2_TOTAL_REVENUE,
                    SUM(
                            CASE 
                                WHEN cube.invoice_year = EXTRACT(YEAR FROM SYSDATE)-2
                                THEN cube.invoiced_qty
                                ELSE 0
                            END
                        ) AS PY2_TOTAL_UNITS
FROM                inventory_part invpar
                    LEFT JOIN sales_part salpar ON
                        invpar.contract = salpar.company
                        AND invpar.part_no = salpar.catalog_no
                    LEFT JOIN kd_sales_cube cube ON
                        invpar.contract = cube.company 
                        AND invpar.part_no = cube.catalog_no
                    LEFT JOIN latest_sale_date lsd ON
                        invpar.part_no = lsd.catalog_no

WHERE                   invpar.contract = '100'
                    AND invpar.part_status != 'O'
                    AND invpar.accounting_group = 'FG'

GROUP BY            invpar.part_product_family,
                    invpar.part_product_code,
                    invpar.part_no,
                    invpar.description,
                    invpar.part_status,
                    salpar.catalog_no,
                    salpar.catalog_desc,
                    salpar.activeind_db,
                    last_invoice_date,
                    sysdate - lsd.last_invoice_date
ORDER BY            invpar.part_product_family,
                    invpar.part_product_code,
                    invpar.part_no,
                    invpar.part_status,
                    salpar.activeind_db
    