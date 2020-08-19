CREATE OR REPLACE VIEW kd_ecom_inventory AS
SELECT
                spc.catalog_no,
                spc.cf$_shopify_inv_id,
                ROUND(NVL(SUM(ipis.qty_onhand - ipis.qty_reserved),0) * .8) AS inventory_qty,
                spc.list_price
FROM
                sales_part_cfv spc
                LEFT JOIN inventory_part_in_stock ipis
                    ON spc.contract = ipis.contract
                        AND spc.catalog_no = ipis.part_no
WHERE
                spc.cf$_ecom_part_db = 'TRUE'
GROUP BY
                spc.catalog_no,
                spc.cf$_shopify_inv_id,
                spc.list_price