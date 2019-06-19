WITH compare AS 
    (
        SELECT          'REQUEST' AS source,
                        salesman_code,
                        invoice_id,
                        SUM(allamounts) AS total
        FROM            kd_sales_data_request
        WHERE           charge_type = 'Parts' 
                        AND corporate_form = 'DOMDIR'
                        AND catalog_no != '3DBC-22001091' 
                        AND
                            (
                                (
                                    order_no Not Like 'W%' 
                                    AND order_no Not Like 'X%'
                                )
                                OR order_no Is Null
                            )
                        AND 
                            (
                                market_code != 'PREPOST'
                                OR market_code Is Null
                            )
                        AND invoice_id != 'CR1001802096' 
                        AND 
                            (
                                order_no != 'C512921' 
                                OR order_no Is Null
                            )
                        AND salesman_code = '101'
                        AND EXTRACT(YEAR FROM invoicedate) = 2019
        GROUP BY        'REQUEST',
                        salesman_code,
                        invoice_id
        
        UNION ALL
        
        SELECT          'CUBE',
                        salesman_code,
                        invoice_id,
                        SUM(allamounts)
        FROM            kd_sales_data_cube
        WHERE           charge_type = 'Parts' 
                        AND corporate_form = 'DOMDIR'
                        AND catalog_no != '3DBC-22001091' 
                        AND
                            (
                                (
                                    order_no Not Like 'W%' 
                                    AND order_no Not Like 'X%'
                                )
                                OR order_no Is Null
                            )
                        AND 
                            (
                                market_code != 'PREPOST'
                                OR market_code Is Null
                            )
                        AND invoice_id != 'CR1001802096' 
                        AND 
                            (
                                order_no != 'C512921' 
                                OR order_no Is Null
                            )
                        AND salesman_code = '101'
                        AND EXTRACT(YEAR FROM invoicedate) = 2019
        GROUP BY        'CUBE',
                        salesman_code,
                        invoice_id
    )
SELECT          salesman_code,
                invoice_id,
                SUM
                    (
                        CASE
                            WHEN source = 'REQUEST'
                            THEN total
                        END 
                    ) AS request,
                SUM
                    (
                        CASE 
                            WHEN source = 'CUBE'
                            THEN total
                        END 
                    ) AS cube
FROM            compare
GROUP BY        salesman_code,
                invoice_id
HAVING          SUM
                    (
                        CASE
                            WHEN source = 'REQUEST'
                            THEN total
                        END 
                    ) !=
                SUM
                    (
                        CASE 
                            WHEN source = 'CUBE'
                            THEN total
                        END 
                    )