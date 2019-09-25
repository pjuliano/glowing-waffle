SELECT
                ip.part_product_code,
                ip.part_product_family,
                ip.part_no,
                sp.catalog_desc,
                sp.activeind,
                sp.list_price,
                SUM(qty_onhand)
FROM
                inventory_part ip
                LEFT JOIN sales_part sp ON
                        ip.part_no = sp.catalog_no
                    AND ip.contract = sp.company
                LEFT JOIN inventory_part_in_stock ips ON
                        ip.part_no = ips.part_no
                    AND ip.contract = ips.contract
                    AND ips.location_type = 'Picking'
WHERE
                    ip.part_cost_group_id = 'PALTP'
GROUP BY
                ip.part_product_code,
                ip.part_product_family,
                ip.part_no,
                ip.description,
                sp.catalog_desc,
                sp.activeind,
                sp.list_price
ORDER BY
                ip.part_no