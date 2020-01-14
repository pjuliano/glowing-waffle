WITH totals AS
    (
        SELECT          req.order_no,
                        SUM
                            (
                                req.allamounts
                            ) AS total,
                        SUM
                            (
                                salpar.list_price * req.invoiced_qty
                            ) AS list,
                        SUM
                            (
                                CASE
                                    WHEN req.part_product_code = 'IMPL'
                                    THEN req.invoiced_qty
                                    ELSE 0
                                END
                            ) AS implants    
        FROM            kd_sales_data_request req
                        LEFT JOIN sales_part salpar ON
                            req.site = salpar.contract
                            AND req.catalog_no = salpar.catalog_no
        WHERE           req.charge_type = 'Parts' 
                        AND req.corporate_form = 'DOMDIR'
                        AND req.catalog_no != '3DBC-22001091' 
                        AND
                            (
                                (
                                    req.order_no Not Like 'W%' 
                                    AND req.order_no Not Like 'X%'
                                )
                                OR req.order_no Is Null
                            )
                        AND 
                            (
                                req.market_code != 'PREPOST'
                                OR req.market_code Is Null
                            )
                        AND req.invoice_id != 'CR1001802096' 
                        AND 
                            (
                                req.order_no != 'C512921' 
                                OR req.order_no Is Null
                            )
        GROUP BY        req.order_no
    )
    
SELECT DISTINCT req.salesman_code,
                person_info_api.get_name(req.salesman_code) AS salesman_name,
                req.customer_no,
                req.customer_name,
                req.invoice_id,
                req.invoicedate,
                req.part_product_family,
                (
                    SELECT          SUM(invoiced_qty)
                    FROM            kd_sales_data_request,
                                    kd_kit_parts
                    WHERE           kd_sales_data_request.catalog_no = kd_kit_parts.catalog_no
                                    AND invoicedate BETWEEN 
                                        ADD_MONTHS(TO_DATE('12/31/2018','MM/DD/YYYY'),-18) 
                                        AND TO_DATE('12/31/2018','MM/DD/YYYY')
                                    AND customer_no = req.customer_no
                                    AND part_product_family = req.part_product_family
                                    AND kd_kit_parts.catalog_no NOT IN
                                        (
                                            'LODI-7422',
                                            'LODI-7421',
                                            '15700K',
                                            '15863K'
                                        )
                ) AS prior_kits,                   
                totals.total,
                totals.implants,
                totals.list,
                ROUND((1 - Totals.Total/NULLIF(Totals.List,0)) * 100,2) AS discount_pct      
FROM            kd_sales_data_request req,
                kd_kit_parts kits,
                totals
WHERE           req.order_no = totals.order_no
                AND req.catalog_no = kits.catalog_no
                AND kits.catalog_no NOT IN 
                    (
                        'LODI-7422',
                        'LODI-7421',
                        '15700K',
                        '15863K')
                AND EXTRACT(YEAR FROM invoicedate) = EXTRACT(YEAR FROM SYSDATE)
                AND req.charge_type = 'Parts' 
                AND req.corporate_form = 'DOMDIR'
                AND req.catalog_no != '3DBC-22001091' 
                AND
                    (
                        (
                            req.order_no Not Like 'W%' 
                            AND req.order_no Not Like 'X%'
                        )
                        OR req.order_no Is Null
                    )
                AND 
                    (
                        req.market_code != 'PREPOST'
                        OR req.market_code Is Null
                    )
                AND req.invoice_id != 'CR1001802096' 
                AND 
                    (
                        req.order_no != 'C512921' 
                        OR req.order_no Is Null
                    )
ORDER BY        salesman_code