SELECT          region_code,
                customer_no,
                customer_name,
                salesman_code,
                person_info_api.get_name(salesman_code) AS salesman_name,
                SUM
                    (
                        CASE
                            WHEN UPPER(catalog_desc) LIKE '%MAX%'
                                AND part_product_code = 'IMPL'
                                AND invoicedate BETWEEN ADD_MONTHS
                                    (
                                        TO_DATE
                                            (
                                                '12/31/2018',
                                                'MM/DD/YYYY'
                                            ),
                                        -18
                                    )
                                    AND TO_DATE
                                        (
                                            '12/31/2018',
                                            'MM/DD/YYYY'
                                        )
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PY_MAX_IMPL,
                SUM
                    (
                        CASE
                            WHEN UPPER(catalog_desc) NOT LIKE '%MAX%'
                                AND part_product_code = 'IMPL'
                                AND invoicedate BETWEEN ADD_MONTHS
                                    (
                                        TO_DATE
                                            (
                                                '12/31/2018',
                                                'MM/DD/YYYY'
                                            ),
                                        -18
                                    )
                                    AND TO_DATE
                                        (
                                            '12/31/2018',
                                            'MM/DD/YYYY'
                                        )
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PY_NOT_MAX_IMPL,
                SUM
                    (
                        CASE
                            WHEN UPPER(catalog_desc) NOT LIKE '%MAX%'
                                AND part_product_code = 'IMPL'
                                AND EXTRACT
                                    (
                                        YEAR FROM INVOICEDATE
                                    ) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS CY_NOT_MAX_IMPL    
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
GROUP BY        region_code,
                customer_no,
                customer_name,
                salesman_code,
                person_info_api.get_name(salesman_code)
HAVING          SUM
                    (
                        CASE
                            WHEN UPPER(catalog_desc) LIKE '%MAX%'
                                AND part_product_code = 'IMPL'
                                AND invoicedate BETWEEN ADD_MONTHS
                                    (
                                        TO_DATE
                                            (
                                                '12/31/2018',
                                                'MM/DD/YYYY'
                                            ),
                                        -18
                                    )
                                    AND TO_DATE
                                        (
                                            '12/31/2018',
                                            'MM/DD/YYYY'
                                        )
                            THEN allamounts
                            ELSE 0
                        END
                    ) != 0 
                    AND SUM
                        (
                            CASE
                                WHEN UPPER(catalog_desc) NOT LIKE '%MAX%'
                                    AND part_product_code = 'IMPL'
                                    AND invoicedate BETWEEN ADD_MONTHS
                                        (
                                            TO_DATE
                                                (
                                                    '12/31/2018',
                                                    'MM/DD/YYYY'
                                                ),
                                            -18
                                        )
                                        AND TO_DATE
                                            (
                                                '12/31/2018',
                                                'MM/DD/YYYY'
                                            )
                                THEN allamounts
                                ELSE 0
                            END
                        ) <= 0
                    AND SUM
                        (
                            CASE
                                WHEN UPPER(catalog_desc) NOT LIKE '%MAX%'
                                    AND part_product_code = 'IMPL'
                                    AND EXTRACT
                                        (
                                            YEAR FROM INVOICEDATE
                                        ) = 2019
                                THEN allamounts
                                ELSE 0
                            END
                        ) >= 1500