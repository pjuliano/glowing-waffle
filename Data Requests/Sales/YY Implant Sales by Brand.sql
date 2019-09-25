SELECT          region_code,
                salesman_code,
                person_info_api.get_name(salesman_code) AS salesman_name,
                customer_no,
                customer_name,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'REGEN' 
                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS CY_BIO_ALL,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS CY_IMPL_ALL,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'REGEN' 
                                AND EXTRACT(YEAR FROM invoicedate) = 2018
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PY_BIO_ALL,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND EXTRACT(YEAR FROM invoicedate) = 2018
                            THEN allamounts
                            ELSE 0
                        END    
                    ) AS PY_IMPL_ALL,
                SUM
                    (
                        CASE
                            WHEN part_product_code = 'REGEN'
                                AND invoicedate <= TRUNC(SYSDATE) - 365
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PYTD_BIO_ALL,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND invoicedate <= TRUNC(SYSDATE) - 365
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PYTD_IMPL_ALL,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND part_product_family NOT IN 
                                    (
                                        'EXHEX',
                                        'OCT',
                                        'TLMAX',
                                        'TRINX',
                                        'ZMAX'
                                    )
                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS CY_IMPL_NO_SI,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND part_product_family NOT IN 
                                    (
                                        'EXHEX',
                                        'OCT',
                                        'TLMAX',
                                        'TRINX',
                                        'ZMAX'
                                    ) 
                                AND EXTRACT(YEAR FROM invoicedate) = 2018
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PY_IMPL_NO_SI,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND part_product_family NOT IN 
                                    (
                                        'EXHEX',
                                        'OCT',
                                        'TLMAX',
                                        'TRINX',
                                        'ZMAX'
                                    )
                                AND invoicedate <= TRUNC(SYSDATE) - 365
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS PYTD_IMPL_NO_SI,
                SUM
                    (
                        CASE
                            WHEN part_product_code != 'REGEN'
                                AND part_product_family NOT IN
                                    (
                                        'ADVN+',
                                        'PAI',
                                        'PAITC',
                                        'PTCOM',
                                        'PCA',
                                        'DYMIC',
                                        'DIVA'
                                    )
                                AND EXTRACT(YEAR FROM invoicedate) = 2019
                            THEN allamounts
                            ELSE 0
                        END
                    ) AS CY_IMPL_NO_PT,
                    SUM
                        (
                            CASE
                                WHEN part_product_code != 'REGEN'
                                    AND part_product_family NOT IN
                                        (
                                            'ADVN+',
                                            'PAI',
                                            'PAITC',
                                            'PTCOM',
                                            'PCA',
                                            'DYMIC',
                                            'DIVA'
                                        )
                                    AND EXTRACT(YEAR FROM invoicedate) = 2018
                                THEN allamounts
                                ELSE 0
                            END
                        ) AS PY_IMPL_NO_PT,
                    SUM
                        (
                            CASE
                                WHEN part_product_code != 'REGEN'
                                    AND part_product_family NOT IN
                                        (
                                            'ADVN+',
                                            'PAI',
                                            'PAITC',
                                            'PTCOM',
                                            'PCA',
                                            'DYMIC',
                                            'DIVA'
                                        )
                                    AND invoicedate <= TRUNC(SYSDATE) - 365
                                THEN allamounts
                                ELSE 0
                            END
                        ) AS PYTD_IMPL_NO_PT    
FROM            kd_sales_data_cube
WHERE           EXTRACT(YEAR FROM invoicedate) >= 2018
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
GROUP BY        region_code,
                salesman_code,
                person_info_api.get_name(salesman_code),
                customer_no,
                customer_name
ORDER BY        region_code,
                salesman_code,
                salesman_name,
                customer_no