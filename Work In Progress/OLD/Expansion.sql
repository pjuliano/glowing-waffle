SELECT          region_code,
                salesman_code,
                person_info_api.get_name(salesman_code) AS salesman_name,
                customer_no,
                customer_name,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'REGEN'
                                AND EXTRACT(YEAR FROM invoicedate) != 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS prior_bio,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND EXTRACT(YEAR FROM invoicedate) != 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS prior_impl,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'REGEN'
                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS current_bio,
                ROUND
                    (
                        1 - 
                            (
                                SUM
                                    (
                                        CASE
                                            WHEN part_product_code = 'REGEN'
                                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                                            THEN allamounts
                                            ELSE 0
                                        END
                                    ) /
                                NULLIF
                                    (
                                        SUM
                                            (
                                                CASE
                                                    WHEN part_product_code = 'REGEN'
                                                        AND EXTRACT(YEAR FROM invoicedate) = 2019
                                                    THEN invoiced_qty * sales_part_api.get_list_price('100',catalog_no)
                                                    ELSE 0
                                                END
                                            ), 
                                        0
                                    )        
                                ), 
                            4
                    ) * 100 AS current_bio_discount,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS current_impl,
                ROUND
                    (
                        1 - 
                            (
                                SUM
                                    (
                                        CASE
                                            WHEN part_product_code != 'REGEN'
                                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                                            THEN allamounts
                                            ELSE 0
                                        END
                                    ) /
                                NULLIF
                                    (     
                                        SUM
                                            (
                                                CASE
                                                    WHEN part_product_code != 'REGEN'
                                                        AND EXTRACT(YEAR FROM invoicedate) = 2019
                                                    THEN invoiced_qty * sales_part_api.get_list_price('100',catalog_no)
                                                    ELSE NULL
                                                END
                                            ), 
                                        0
                                    )        
                                ), 
                            4
                    ) * 100 AS current_impl_discount
FROM            kd_sales_data_request
WHERE           invoicedate >= ADD_MONTHS(TO_DATE('12/31/2018','MM/DD/YYYY'),-18)
                --AND invoicedate <= TO_DATE('06/30/2019','MM/DD/YYYY')
                AND charge_type = 'Parts' 
                AND corporate_form = 'DOMDIR'
                AND catalog_no != '3DBC-22001091' 
                AND catalog_no != 'PR15'
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
HAVING          (
                    SUM
                        (
                            CASE
                                WHEN part_product_code = 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) != 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) <= 0 
                    AND SUM
                        (
                            CASE
                                WHEN part_product_code = 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) = 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) > 0
                    AND SUM
                        (
                            CASE
                                WHEN part_product_code != 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) != 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) >= 1500
                    AND SUM
                        (
                            CASE
                                WHEN part_product_code != 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) = 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) >= 1500
                )        
                OR 
                (   
                    SUM
                        (
                            CASE
                                WHEN part_product_code != 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) != 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) <= 0
                    AND SUM
                        (
                            CASE
                                WHEN part_product_code != 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) = 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) > 0
                    AND SUM
                        (
                            CASE
                                WHEN part_product_code = 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) != 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) >= 1500
                    AND SUM
                        (
                            CASE
                                WHEN part_product_code = 'REGEN'
                                    AND EXTRACT(YEAR FROM invoicedate) = 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) >= 1500    
                )        
GROUP BY        region_code,
                salesman_code,
                person_info_api.get_name(salesman_code),
                customer_no,
                customer_name