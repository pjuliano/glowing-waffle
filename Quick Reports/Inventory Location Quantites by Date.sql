SELECT
                ith.contract,
                ith.part_no,
                inventory_part_api.get_description(ith.contract,ith.part_no) AS part_desc,
                inventory_location_api.get_warehouse(ith.contract,ith.location_no) AS warehouse,
                ith.location_no,
                inventory_part_api.get_accounting_group(ith.contract,ith.part_no) AS accounting_group,
                icus.inventory_value,
                SUM(DECODE(ith.direction,'-',ith.quantity * -1,ith.quantity)) AS qty_onhand
FROM
                inventory_transaction_hist ith
                LEFT JOIN inventory_part_unit_cost_sum icus
                    ON ith.contract = icus.contract
                        AND ith.part_no = icus.part_no
WHERE
                ith.date_applied <= TO_DATE('&ThroughDate','MM/DD/YYYY')
                    AND ith.direction != '0'
GROUP BY
                ith.contract,
                ith.part_no,
                inventory_part_api.get_description(ith.contract,ith.part_no),
                ith.location_no,
                inventory_part_api.get_accounting_group(ith.contract,ith.part_no),
                icus.inventory_value