WITH orderdates AS
    (
        SELECT          
                        customer_no,
                        customer_name,
                        MIN(invoicedate) AS First_Invoice_Date,
                        MAX(invoicedate) AS Last_Invoice_Date
        FROM            
                        kd_sales_data_cube
        WHERE           
                        part_product_family = 'IHMAX'
                            AND part_product_code != 'LIT'
                            AND customer_no NOT LIKE 'R%'
        GROUP BY        
                        customer_no,
                        customer_name
    )
    
SELECT          
                sdc.salesman_code,
                ods.customer_no,
                ods.customer_name,
                ods.first_invoice_date,
                ods.last_invoice_date,
                SUM(sdc.invoiced_qty) AS total_qty,
                SUM(sdc.allamounts) AS total_sales
FROM            
                orderdates ods
                LEFT JOIN kd_sales_data_cube sdc ON
                    ods.customer_no = sdc.customer_no
                        AND sdc.part_product_family = 'IHMAX'
                        AND sdc.part_product_code != 'LIT'
GROUP BY        
                sdc.salesman_code,
                ods.customer_no,
                ods.customer_name,
                ods.first_invoice_date,
                ods.last_invoice_date