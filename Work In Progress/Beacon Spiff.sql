CREATE OR REPLACE VIEW kd_contest_2020_beacon AS
SELECT DISTINCT
                TO_CHAR(invoicedate,'Q') AS quarter,
                salesman_code,
                customer_no
FROM
                kd_sales_data_request
WHERE
                charge_type = 'Parts' 
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
                    AND market_code IN ('PBKS5','PBPS5')