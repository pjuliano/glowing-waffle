SELECT
                catalog_no,
                catalog_desc,
                sp.list_price AS k0,
                sp.list_price * 
                    (
                        SELECT              
                                        1 - dt.discount
                        FROM
                                        inventory_part ip
                        LEFT JOIN       kd_ecom_discount_tiers dt
                        ON              ip.part_product_family = dt.family
                                            AND dt.tier = 'K1'
                        WHERE
                                        ip.part_no = sp.catalog_no
                                            AND ip.contract = sp.contract
                    ) AS k1,
                sp.list_price * 
                    (
                        SELECT              
                                        1 - dt.discount
                        FROM
                                        inventory_part ip
                        LEFT JOIN       kd_ecom_discount_tiers dt
                        ON              ip.part_product_family = dt.family
                                            AND dt.tier = 'K2'
                        WHERE
                                        ip.part_no = sp.catalog_no
                                            AND ip.contract = sp.contract
                    ) AS k2,
                sp.list_price * 
                    (
                        SELECT              
                                        1 - dt.discount
                        FROM
                                        inventory_part ip
                        LEFT JOIN       kd_ecom_discount_tiers dt
                        ON              ip.part_product_family = dt.family
                                            AND dt.tier = 'K3'
                        WHERE
                                        ip.part_no = sp.catalog_no
                                            AND ip.contract = sp.contract
                    ) AS k3,
                sp.list_price * 
                    (
                        SELECT              
                                        1 - dt.discount
                        FROM
                                        inventory_part ip
                        LEFT JOIN       kd_ecom_discount_tiers dt
                        ON              ip.part_product_family = dt.family
                                            AND dt.tier = 'K4'
                        WHERE
                                        ip.part_no = sp.catalog_no
                                            AND ip.contract = sp.contract
                    ) AS k4
FROM
                sales_part_cfv sp
WHERE
                sp.cf$_ecom_part_db = 'TRUE'