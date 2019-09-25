CREATE OR REPLACE VIEW kd_consignment_inventory AS
SELECT
                ipis.location_no,
                customer_info_api.get_name(ipis.location_no) AS customer_name,
                ipis.contract,
                ipis.part_no,
                ipis.lot_batch_no,
                ipis.eng_chg_level,
                ipis.expiration_date,
                SUM(ipis.qty_onhand) AS QTY_ONHAND,
                SUM(ipis.qty_onhand * sales_part_api.get_list_price(ipis.contract,ipis.part_no)) AS LIST_PRICE_VALUE
FROM
                inventory_part_in_stock ipis
WHERE
                ipis.warehouse = 'CONS'
GROUP BY
                ipis.location_no,
                customer_info_api.get_name(ipis.location_no),
                ipis.contract,
                ipis.part_no,
                ipis.lot_batch_no,
                ipis.eng_chg_level,
                ipis.expiration_date