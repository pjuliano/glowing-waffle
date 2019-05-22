SELECT          kdsc.customer_id,
                kdsc.customer_name,
                kdsc.invoice_date,
                kdsc.part_product_code,
                kdsc.part_product_family,
                kdsc.second_commodity,
                kdsc.catalog_no,
                kdsc.catalog_desc,
                kdsc.invoiced_qty,
                ip.part_status
FROM            ifsapp.kd_sales_cube kdsc,
                ifsapp.inventory_part ip
WHERE           invoice_date BETWEEN to_date('&FromDate','MM/DD/YYYY') AND to_date('&ToDate','MM/DD/YYYY') AND
                ip.part_no = kdsc.catalog_no
ORDER BY        invoice_date ASC