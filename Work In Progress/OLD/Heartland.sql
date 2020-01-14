CREATE OR REPLACE VIEW KD_HEARTLAND_EPICOR AS
SELECT
                sc.delivery_street_1 AS "EPICOR ID",
                sc.delivery_customer_name AS "Office Name",
                'Keystone Dental, Inc.' AS "Distributor",
                'Keystone Dental, Inc.' AS "Manufacturer",
                sc.part_product_family AS "Category",
                sc.part_product_code AS "Sub-Category",
                sc.catalog_no AS "Distributor Item Number",
                sc.catalog_no AS "Manufacturer Item Number",
                sc.catalog_desc AS "Item Description",
                sp.sales_unit_meas AS "Unit of Measure",
                1 AS "Qty per Unit of Measure",
                NULL AS "Strength or Other",
                sc.unit_price_usd AS "Unit Price",
                sc.invoiced_qty AS "Qty",
                sc.total_price_usd AS "Amount",
                sc.invoice_month AS "Invoice Month",
                sc.invoice_year AS "Invoice Year",
                sc.invoice_date
FROM
                kd_sales_cube sc
                LEFT JOIN sales_part sp
                    ON sc.catalog_no = sp.catalog_no
                        AND sc.company = sp.contract
WHERE
                sc.invoice_customer_id = 'A13473'
                    AND sc.part_product_family != 'FREIGHT'